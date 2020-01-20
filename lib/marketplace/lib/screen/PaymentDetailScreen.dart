import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:services/marketplace/lib/api/BaseController.dart';
import 'package:services/marketplace/lib/api/HandleResponseListener.dart';
import 'package:services/marketplace/lib/api/ServerResponseValidator.dart';
import 'package:services/marketplace/lib/api/TransactionController.dart';
import 'package:services/marketplace/lib/models/CommonServiceItem.dart';
import 'package:services/marketplace/lib/models/PaymentInput.dart';
import 'package:services/marketplace/lib/models/Services.dart';
import 'package:services/marketplace/lib/models/Transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../colors.dart';
import 'BrowserScreen.dart';
import 'item/ProcessStep.dart';

class PaymentDetailScreen extends StatefulWidget {
  PaymentDetailScreen(this._transaction, this._merchant);

  final Transaction _transaction;
  final Merchant _merchant;
  final List<PaymentInput> paimentInputs = [
    // new PaymentInput(true, true, true, _image)
  ];
  @override
  _PaymentDetailScreenState createState() =>
      _PaymentDetailScreenState(this._transaction, this._merchant);
}

class _PaymentDetailScreenState extends State<PaymentDetailScreen>
    implements HandleResponseListener {
  _PaymentDetailScreenState(this._transaction, this._merchant);

  final Transaction _transaction;
  final Merchant _merchant;
  bool isLoading = false, _isHidden = true;
  int indik = 0;
  var _formKey = GlobalKey<FormState>();
  var _formKey_2 = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _recepteur;

  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    this.lire();
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('username:password'));
  }

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  lire() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recepteur = prefs.getString("recepteur") == null
          ? null
          : prefs.getString("recepteur");
    });
  }

  ///Fire when response format in invalid
  onFailure(ServerResponseValidator validator) {
    showInSnackBar("Une erreur est survenue");
  }

  ///Fire when response has succeed
  onSuccess(Map<String, dynamic> json) async {
    print(json.toString());
    var url = json["paymenturl"];
    if (url != null)
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade, child: BrowserScreen(url)));
    else {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    }
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
                        _merchant.category == Services.TV_CATEGORY ||
                                _merchant.category ==
                                    Services.UTILITY_CATEGORY ||
                                (_merchant.logoFileId.contains("tv.png") &&
                                    _recepteur == "null")
                            ? Container()
                            : Padding(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        _merchant.category ==
                                                    Services.TELCO_CATEGORY ||
                                                _merchant.category ==
                                                    Services.UTILITY_CATEGORY ||
                                                (_merchant.logoFileId
                                                        .contains("tv.png") &&
                                                    _recepteur != "null")
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
                                                (_merchant.logoFileId
                                                        .contains("tv.png") &&
                                                    _recepteur != "null")
                                            ? "${_transaction.beneficiaryPhoneNumber} "
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
                                child: Text("0 ${_transaction.currency}",
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
                          },
                          height: 90.0,
                          items: [1, 2, 3, 4].map((i) {
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
                                                    initialSelection: "+237",
                                                    onChanged:
                                                        (CountryCode code) {
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
                        indik == 3 || indik == 2
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
                                                    initialSelection: "+237",
                                                    onChanged:
                                                        (CountryCode code) {
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
                      : _formKey.currentState.validate();
                  if (isForm2Valid && isForm1Valid) {
                    var method = "";
                    switch (indik) {
                      case 2:
                        method = "ORANGE_MONEY_CM";
                        break;
                      case 3:
                        method = "MTN_MOMO_CM";
                        break;
                      case 1:
                        method = "CREDIT_CARD";
                        break;
                    }
                    if (_transaction.beneficiaryPhoneNumber == null)
                      _transaction.beneficiaryPhoneNumber =
                          phoneController.text;
                    _transaction.beneficiaryEmail = emailController.text;
                    _transaction.paymentType = method;
                    _transaction.mobileMoneyPaymentNumber =
                        phoneController.text;
                    try {
                      setState(() {
                        isLoading = true;
                      });
                      new TransactionController().pay(_transaction, onSuccess,
                          onFailure, onRequestComplete);
                    } on NoInternetException catch (e) {
                      // If the form is valid.
                      showInSnackBar(e.message);
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
}
