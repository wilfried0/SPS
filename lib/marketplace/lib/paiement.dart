import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:services/composants/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/BaseController.dart';
import 'api/HandleResponseListener.dart';
import 'api/ServerResponseValidator.dart';
import 'api/TransactionController.dart';

import 'models/CommonServiceItem.dart';
import 'models/PaymentInput.dart';
import 'models/Services.dart';
import 'models/Transaction.dart';
import 'screen/BrowserScreen.dart';
import 'screen/dialog/SpConfirmDialog.dart';
import 'screen/item/ProcessStep.dart';
import 'utils/Amount.dart';

class Paiement extends StatefulWidget {
  Paiement(this._transaction, this._merchant, this._serviceItem);

  final Transaction _transaction;
  final Merchant _merchant;
  final CommonServiceItem _serviceItem;
  final List<PaymentInput> paimentInputs = [
    // new PaymentInput(true, true, true, _image)
  ];

  @override
  _PaiementState createState() =>
      _PaiementState(this._transaction, this._merchant, this._serviceItem);
}

class _PaiementState extends State<Paiement> implements HandleResponseListener {
  _PaiementState(this._transaction, this._merchant, this._serviceItem);

  static const String SPRINT_PAY = "SPRINT_PAY";
  static const String BUYER_PHONE = "BUYER_PHONE";
  static const String BUYER_EMAIL = "BUYER_EMAIL";
  static const String SP_CREDENTIAL = "SP_CREDENTIAL";
  static const String BUYER_ID = "BUYER_ID";
  static const String ACCOUNT_TYPE = "ACCOUNT_TYPE";

  var method = "";

  final Transaction _transaction;
  final Merchant _merchant;
  final CommonServiceItem _serviceItem;
  bool isLoading = false, _isHidden = true;
  int indik = 0;
  String countryCode;
  var _formKey = GlobalKey<FormState>();
  var _formKey_2 = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _montant, _nom, _recepteur, _description, amountCible, deviseLocale, country, devisebenef;
  String beneficiaryPhoneNumber, beneficiaryPhone, buyerName;
  var _commission;
  String coched;

  var emailController;
  final passwordController = TextEditingController();
  var phoneController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    this.lire();
    beneficiaryPhoneNumber = _transaction.beneficiaryPhoneNumber;
    beneficiaryPhone = _transaction.beneficiaryPhoneNumber;
    _commission = _serviceItem.spCommissionAmount;
    getDefaultComminion();
    print("ma commission: $_commission");
    print("ma commission: $beneficiaryPhoneNumber");
  }

  Future<void> getMontantCible() async {
    String _url = "$base_url/user/soldeBeneficiaire/$deviseLocale/${double.parse(_transaction.amount)}/$country";
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.getUrl(Uri.parse(_url));
    request.headers.set('Accept', 'application/json');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print("voilà**************************************************** $_url $reply");
    if(response.statusCode == 200){
      var responseJson = json.decode(reply);
      setState(() {
        amountCible = "${responseJson['balance'].toString()}" ;
        devisebenef = "${responseJson['formattedBalance'].toString()}";
      });
    }else{
      showInSnackBar("Erreur est survenu lors de la récupération du montant du destinataire!");
    }
    return null;
  }

  getTotal(double amount, double commission) {
    return amount + commission;
  }

  getDefaultComminion() {
    setState(() {
      _commission = Amount.getCommission(_serviceItem.commissionType,
          _serviceItem.spCommissionAmount, double.parse(_transaction.amount));
    });
  }

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  lire() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      coched = prefs.get("coched");
      country = prefs.get("countryCible");
      deviseLocale = prefs.get("deviseLocale");
      print("cochage: $coched");
      _montant = prefs.getString("montant") == null
          ? null
          : prefs.getString("montant");
      /*_commission = prefs.getString("commission") == null
          ? null
          : prefs.getString("commission");*/
      _nom = prefs.getString("nom") == null ? null : prefs.getString("nom");
      _recepteur = prefs.getString("recepteur") == null
          ? null
          : prefs.getString("recepteur");

      _transaction.buyerPhoneNumber = prefs.getString(BUYER_PHONE);
      _transaction.buyerEmail = prefs.getString(BUYER_EMAIL);
      _transaction.spauthToken = prefs.getString(SP_CREDENTIAL);
      _transaction.buyerId = prefs.getString(BUYER_ID);
      _transaction.accountType = prefs.getString(ACCOUNT_TYPE);
      emailController.text = _transaction.buyerEmail;
      _transaction.clientIpAddress = "127.0.0.0";
      this.getMontantCible();
    });
  }

  ///Fire when response format in invalid
  onFailure(ServerResponseValidator validator) {
    showInSnackBar(
        "Impossible de traiter votre requete car une erreur est survenue");
  }

  ///Fire when response has succeed
  onSuccess(Map<String, dynamic> json) async {
    print(json.toString());
    var url = json["paymenturl"];
    print("Mon url: $url");
    if (url != null)
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade, child: BrowserScreen(url)));
    else if (method.contains(SPRINT_PAY)) {
      SpVerify spVerify = new SpVerify(
          spauthToken: _transaction.spauthToken,
          transactionId: json['transactionid']);
      SpConfirmDialog().show(_scaffoldKey, context, spVerify);
    } else {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      BrowserScreen.successPayment(context);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  /// Fire when request is finish no matter if there is an error or not
  onRequestComplete(ServerResponseValidator validator) {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ProcessStep(ProcessStep.PAYMENT, _merchant.logoFileId),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: getHeight(indik + 1),
                child: Card(
                  elevation: 1,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: Text(
                            _merchant.category == Services.TELCO_CATEGORY ||
                                _merchant.category ==
                                    Services.UTILITY_CATEGORY
                                ? "Achat de crédit téléphonique."
                                : _merchant.category ==
                                Services.PHARMACY_CATEGORY
                                ? "Paiement d'une ordonnance"
                                : "Paiement facture",
                            style: TextStyle(color: couleur_libelle_champ),
                          ),
                        ),
                        (_merchant.category == Services.TV_CATEGORY ||
                            _merchant.category ==
                                Services.UTILITY_CATEGORY ||
                            _merchant.category ==
                                Services.PHARMACY_CATEGORY ||
                            _merchant.logoFileId.contains("tv.png")) &&
                            beneficiaryPhoneNumber == null
                            ? Container()
                            : Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Text(
                                  (_merchant.category ==
                                      Services.TELCO_CATEGORY ||
                                      _merchant.category ==
                                          Services.UTILITY_CATEGORY ||
                                      _merchant.category ==
                                          Services
                                              .PHARMACY_CATEGORY ||
                                      (_merchant.logoFileId
                                          .contains("tv.png")) &&
                                          beneficiaryPhoneNumber !=
                                              null)
                                      ? "Numéro bénéficiaire"
                                      : _merchant.category ==
                                      Services.PHARMACY_CATEGORY
                                      ? "Numéro du récepteur"
                                      : "Numéro de la facture",
                                  style: TextStyle(
                                      color: couleur_libelle_champ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  _merchant.category ==
                                      Services.TELCO_CATEGORY ||
                                      _merchant.category ==
                                          Services.UTILITY_CATEGORY ||
                                      _merchant.category ==
                                          Services
                                              .PHARMACY_CATEGORY ||
                                      (_merchant.logoFileId
                                          .contains("tv.png") &&
                                          beneficiaryPhoneNumber !=
                                              null) ||
                                      _merchant.category ==
                                          Services.PHARMACY_CATEGORY
                                      ? "+${_transaction.beneficiaryPhoneNumber} "
                                      : "Non Réquis",
                                  style: TextStyle(
                                      color: couleur_fond_bouton,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "Montant",
                                  style:
                                  TextStyle(color: couleur_libelle_champ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                    "${_transaction.amount} ${_transaction.currency}",
                                    style: TextStyle(
                                        color: couleur_fond_bouton,
                                        fontWeight: FontWeight.bold,
                                        fontSize: taille_libelle_champ + 3),
                                    textAlign: TextAlign.end),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "Commission",
                                  style:
                                  TextStyle(color: couleur_libelle_champ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                    "${getMillis(_commission.toString())} ${_transaction.currency}",
                                    style: TextStyle(
                                        color: couleur_fond_bouton,
                                        fontWeight: FontWeight.bold,
                                        fontSize: taille_libelle_champ + 3),
                                    textAlign: TextAlign.end),
                              ),
                            ],
                          ),
                        ),

                        _merchant.category != Services.TELCO_CATEGORY || amountCible == null?Container():Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "Le bénéficiaire recevra",
                                  style:
                                  TextStyle(color: couleur_libelle_champ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                    "${getMillis(double.parse(amountCible).toString())} $devisebenef",
                                    style: TextStyle(
                                        color: couleur_fond_bouton,
                                        fontWeight: FontWeight.bold,
                                        fontSize: taille_libelle_champ + 3),
                                    textAlign: TextAlign.end),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "Total à payer TTC",
                                  style:
                                  TextStyle(color: couleur_libelle_champ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                    "${getMillis(getTotal(double.parse(_transaction.amount), _commission).toString())} ${_transaction.currency}",
                                    style: TextStyle(
                                        color: couleur_fond_bouton,
                                        fontWeight: FontWeight.bold,
                                        fontSize: taille_libelle_champ + 3),
                                    textAlign: TextAlign.end),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 10),
                          child: Text(
                            "Moyen de paiement",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        CarouselSlider(
                          enlargeCenterPage: true,
                          autoPlay: false,
                          enableInfiniteScroll: true,
                          onPageChanged: (value) {
                            setState(() {
                              indik = value;
                              print(indik);
                            });
                            switch (indik) {
                              case 2:
                                setState(() {
                                  _commission = Amount.getCommission(
                                      _serviceItem.commissionType,
                                      _serviceItem.omCommissionAmount,
                                      double.parse(_transaction.amount));
                                });
                                break;
                              case 3:
                                setState(() {
                                  _commission = Amount.getCommission(
                                      _serviceItem.commissionType,
                                      _serviceItem.momoCommissionAmount,
                                      double.parse(_transaction.amount));
                                });
                                break;
                              case 4:
                                setState(() {
                                  _commission = Amount.getCommission(
                                      _serviceItem.commissionType,
                                      _serviceItem.yupCommissionAmount,
                                      double.parse(_transaction.amount));
                                });
                                break;
                              case 1:
                                setState(() {
                                  _commission = Amount.getCommission(
                                      _serviceItem.commissionType,
                                      _serviceItem.ccCommissionAmount,
                                      double.parse(_transaction.amount));
                                });
                                break;
                              default:
                                setState(() {
                                  _commission = Amount.getCommission(
                                      _serviceItem.commissionType,
                                      _serviceItem.spCommissionAmount,
                                      double.parse(_transaction.amount));
                                });
                                break;
                            }
                          },
                          height: 90.0,
                          items: [1, 2, 3, 4, 5].map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return getMoyen(i, context, indik);
                              },
                            );
                          }).toList(),
                        ),
                        indik == 0
                            ? Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Form(
                              key: _formKey_2,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: new BoxDecoration(
                                      borderRadius: new BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                      ),
                                      color: Colors.transparent,
                                      border: Border.all(
                                          color: couleur_bordure,
                                          width: bordure),
                                    ),
                                    height: hauteur_champ,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                            flex: 5,
                                            child: CountryCodePicker(
                                              showFlag: true,
                                              onChanged:
                                                  (CountryCode code) {
                                                countryCode = code
                                                    .dialCode
                                                    .replaceAll("+", "");
                                                //_mySelection = code.dialCode.toString();
                                              },
                                            )),
                                        new Expanded(
                                          flex: 10,
                                          child: new TextFormField(
                                            controller: phoneController,
                                            keyboardType:
                                            TextInputType.phone,
                                            style: TextStyle(
                                              fontSize:
                                              taille_libelle_champ,
                                              color:
                                              couleur_libelle_champ,
                                            ),
                                            validator: (String value) {
                                              if (value.isEmpty) {
                                                return 'Champ téléphone vide !';
                                              } else {
                                                return null;
                                              }
                                            },
                                            decoration:
                                            InputDecoration.collapsed(
                                              hintText:
                                              'Numéro de téléphone',
                                              hintStyle: TextStyle(
                                                fontSize:
                                                taille_libelle_champ,
                                                color:
                                                couleur_libelle_champ,
                                              ),
                                              //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 0.0),
                                    decoration: new BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                          width: bordure,
                                          color: couleur_bordure),
                                    ),
                                    height: hauteur_champ,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(
                                                10.0),
                                            child: new Icon(
                                              Icons.lock,
                                              color: couleur_bordure,
                                            ),
                                          ),
                                        ),
                                        new Expanded(
                                          flex: 10,
                                          child: new TextFormField(
                                            controller:
                                            passwordController,
                                            keyboardType:
                                            TextInputType.text,
                                            style: TextStyle(
                                                fontSize:
                                                taille_libelle_champ,
                                                color:
                                                couleur_libelle_champ),
                                            validator: (String value) {
                                              if (value.isEmpty) {
                                                return 'Champ mot de passe vide !';
                                              } else {
                                                //_password = value;
                                                return null;
                                              }
                                            },
                                            decoration:
                                            InputDecoration.collapsed(
                                              hintText: 'Mot de passe',
                                              hintStyle: TextStyle(
                                                  color:
                                                  couleur_libelle_champ,
                                                  fontSize:
                                                  taille_libelle_champ),
                                              //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                            ),
                                            obscureText: _isHidden,
                                            /*textAlign: TextAlign.end,*/
                                          ),
                                          //),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: new IconButton(
                                            onPressed: _toggleVisibility,
                                            icon: _isHidden
                                                ? new Icon(
                                              Icons.visibility_off,
                                            )
                                                : new Icon(
                                              Icons.visibility,
                                            ),
                                            color: couleur_bordure,
                                            iconSize: 20.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: new BoxDecoration(
                                      borderRadius: new BorderRadius.only(
                                        bottomRight:
                                        Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0),
                                      ),
                                      color: Colors.transparent,
                                      border: Border.all(
                                          color: couleur_bordure,
                                          width: bordure),
                                    ),
                                    height: hauteur_champ,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.all(10),
                                            child: new Icon(
                                              Icons.email,
                                              color: couleur_bordure,
                                            ),
                                          ),
                                        ),
                                        new Expanded(
                                          flex: 10,
                                          //child: Padding(
                                          child: Padding(
                                            padding:
                                            EdgeInsets.only(left: 15),
                                            child: new TextFormField(
                                              controller: emailController,
                                              keyboardType:
                                              TextInputType.text,
                                              style: TextStyle(
                                                  fontSize:
                                                  taille_libelle_champ,
                                                  color:
                                                  couleur_libelle_champ),
                                              validator: (String value) {
                                                if (value.isEmpty) {
                                                  return 'Champ email vide !';
                                                } else {
                                                  //_password = value;
                                                  return null;
                                                }
                                              },
                                              decoration: InputDecoration
                                                  .collapsed(
                                                hintText: 'Adresse mail',
                                                hintStyle: TextStyle(
                                                    color:
                                                    couleur_libelle_champ,
                                                    fontSize:
                                                    taille_libelle_champ),
                                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                              ),
                                              /*textAlign: TextAlign.end,*/
                                            ),
                                          ),
                                          //),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )),
                        )
                            : Container(),
                        indik == 3 || indik == 2 || indik == 4
                            ? Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: new BoxDecoration(
                                      borderRadius: new BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                      ),
                                      color: Colors.transparent,
                                      border: Border.all(
                                          color: couleur_bordure,
                                          width: bordure),
                                    ),
                                    height: hauteur_champ,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                            flex: 5,
                                            child: CountryCodePicker(
                                              showFlag: true,
                                              onChanged:
                                                  (CountryCode code) {
                                                countryCode = code
                                                    .dialCode
                                                    .replaceAll("+", "");
                                              },
                                            )),
                                        new Expanded(
                                          flex: 10,
                                          child: new TextFormField(
                                            controller: phoneController,
                                            keyboardType:
                                            TextInputType.phone,
                                            style: TextStyle(
                                              fontSize:
                                              taille_libelle_champ,
                                              color:
                                              couleur_libelle_champ,
                                            ),
                                            validator: (String value) {
                                              if (value.isEmpty) {
                                                return 'Champ téléphone vide !';
                                              } else {
                                                return null;
                                              }
                                            },
                                            decoration:
                                            InputDecoration.collapsed(
                                              hintText:
                                              'Numéro de téléphone',
                                              hintStyle: TextStyle(
                                                fontSize:
                                                taille_libelle_champ,
                                                color:
                                                couleur_libelle_champ,
                                              ),
                                              //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: new BoxDecoration(
                                      borderRadius: new BorderRadius.only(
                                        bottomRight:
                                        Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0),
                                      ),
                                      color: Colors.transparent,
                                      border: Border.all(
                                          color: couleur_bordure,
                                          width: bordure),
                                    ),
                                    height: hauteur_champ,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.all(10),
                                            child: new Icon(
                                              Icons.email,
                                              color: couleur_bordure,
                                            ),
                                          ),
                                        ),
                                        new Expanded(
                                          flex: 10,
                                          //child: Padding(
                                          child: Padding(
                                            padding:
                                            EdgeInsets.only(left: 15),
                                            child: new TextFormField(
                                              controller: emailController,
                                              keyboardType:
                                              TextInputType.text,
                                              style: TextStyle(
                                                  fontSize:
                                                  taille_libelle_champ,
                                                  color:
                                                  couleur_libelle_champ),
                                              validator: (String value) {
                                                if (value.isEmpty) {
                                                  return 'Champ email vide !';
                                                } else {
                                                  return null;
                                                }
                                              },
                                              decoration: InputDecoration
                                                  .collapsed(
                                                hintText: 'Adresse mail',
                                                hintStyle: TextStyle(
                                                    color:
                                                    couleur_libelle_champ,
                                                    fontSize:
                                                    taille_libelle_champ),
                                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                              ),
                                              /*textAlign: TextAlign.end,*/
                                            ),
                                          ),
                                          //),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )),
                        )
                            : Container(),
                        indik == 1
                            ? Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Container(
                            decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.only(
                                bottomRight: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                                topLeft: Radius.circular(10.0),
                              ),
                              color: Colors.transparent,
                              border: Border.all(
                                  color: couleur_bordure, width: bordure),
                            ),
                            height: hauteur_champ,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: new Icon(
                                      Icons.email,
                                      color: couleur_bordure,
                                    ),
                                  ),
                                ),
                                new Expanded(
                                  flex: 10,
                                  //child: Padding(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: new TextFormField(
                                      controller: emailController,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(
                                          fontSize: taille_libelle_champ,
                                          color: couleur_libelle_champ),
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return 'Champ email vide !';
                                        } else {
                                          //_password = value;
                                          return null;
                                        }
                                      },
                                      decoration:
                                      InputDecoration.collapsed(
                                        hintText: 'Adresse mail',
                                        hintStyle: TextStyle(
                                            color: couleur_libelle_champ,
                                            fontSize:
                                            taille_libelle_champ),
                                        //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                      ),
                                      /*textAlign: TextAlign.end,*/
                                    ),
                                  ),
                                  //),
                                ),
                              ],
                            ),
                          ),
                        )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: GestureDetector(
                onTap: () {
                  //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Profile('')));
                  bool isForm1Valid = _formKey.currentState == null
                      ? true
                      : _formKey.currentState.validate();
                  bool isForm2Valid = _formKey_2.currentState == null
                      ? true
                      : _formKey_2.currentState.validate();
                  print("Method = $indik");
                  if (isForm2Valid && isForm1Valid) {
                    switch (indik) {
                      case 2:
                        method = "ORANGE_MONEY_CM";
                        break;
                      case 3:
                        method = "MTN_MOMO_CM";
                        break;
                      case 4:
                        method = "YUP_CM";
                        break;
                      case 1:
                        method = "CREDIT_CARD";
                        break;
                      default:
                        method = SPRINT_PAY;
                        break;
                    }
                    if (_transaction.beneficiaryPhoneNumber == null) {
                      _transaction.beneficiaryPhoneNumber =
                          phoneController.text;
                      _transaction.beneficiaryEmail = emailController.text;
                      _transaction.buyerIsBeneficiary = true;
                    } else if (_transaction.beneficiaryEmail == null) {
                      _transaction.beneficiaryEmail = emailController.text;
                      _transaction.buyerIsBeneficiary = true;
                    } else {
                      _transaction.buyerIsBeneficiary = false;
                    }

                    if (_transaction.buyerId == null) {
                      _transaction.buyerId = "123";
                      _transaction.buyerEmail = emailController.text;
                      _transaction.buyerPhoneNumber = "${phoneController.text}";
                      _transaction.spauthToken = 'Basic ' +
                          base64.encode(utf8.encode(
                              '${phoneController.text}:${passwordController.text}'));
                    }

                    _transaction.paymentType = method;
                    _transaction.mobileMoneyPaymentNumber =
                        phoneController.text;
                    _transaction.buyerName = buyerName;

                    coched == "false"
                        ? _transaction.buyerIsBeneficiary = true
                        : _transaction.buyerIsBeneficiary = false;

                    print("on a coché: $coched");

                    try {
                      setState(() {
                        isLoading = true;
                      });
                      new TransactionController()
                          .pay(_transaction, onSuccess, onFailure, onRequestComplete)
                          .catchError((e) {
                            print("voilà l'erreur :$e");
                            showInSnackBar("Service indisponible!");
                      });
                    } on NoInternetException catch (e) {
                      // If the form is valid.
                      showInSnackBar(
                          "Impossible de traiter votre requete, veuillez verifiez votre connexion internet");
                    }
                  }
                },
                child: new Container(
                  height: hauteur_champ,
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: new BoxDecoration(
                    color: Colors.green,
                    border: new Border.all(
                      color: Colors.transparent,
                      width: 0.0,
                    ),
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  child: new Center(
                    child: isLoading == false
                        ? new Text(
                      'Payer',
                      style: new TextStyle(
                          fontSize: taille_text_bouton + 3,
                          color: couleur_text_bouton),
                    )
                        : CupertinoActivityIndicator(),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        style: TextStyle(color: Colors.white, fontSize: taille_champ + 3),
        textAlign: TextAlign.center,
      ),
      backgroundColor: couleur_fond_bouton,
      duration: Duration(seconds: 5),
    ));
  }

  String reversed(String str) {
    String nombre = "";
    for (int i = str.length - 1; i >= 0; i--) {
      nombre = nombre + str.substring(i, i + 1);
    }
    return nombre;
  }

  String getMillis(String amount) {
    String reste = amount.split('.')[1];
    if (reste.length > 2) {
      reste = reste.substring(0, 2);
    }
    amount = reversed(amount.split('.')[0]);
    String nombre = "";
    if (amount.length <= 3) {
      return reversed(amount) + ',' + reste;
    } else if (amount.length == 4) {
      for (int i = amount.length - 1; i >= 0; i--) {
        nombre = nombre + amount.substring(i, i + 1);
        if (i == amount.length - 1) {
          nombre = nombre + '.';
        } else {}
      }
    } else
      for (int i = amount.length - 1; i >= 0; i--) {
        nombre = nombre + amount.substring(i, i + 1);
        if (i == 0 || i == amount.length - 1) {
        } else {
          if ((i) % 3 == 0) {
            nombre = nombre + '.';
          }
        }
      }
    return nombre.toString() + ',' + reste;
  }
}