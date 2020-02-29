import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/ServerResponseValidator.dart';
import 'colors.dart';
import 'confirm.dart';
import 'models/CommonServiceItem.dart';
import 'models/Services.dart';
import 'models/Transaction.dart';
import 'screen/item/ProcessStep.dart';
import 'services.dart';
import 'system/AppState.dart';

class Operator extends StatefulWidget {
  Operator(this._merchant, this.selectedServiceItem);
  final Merchant _merchant;
  final CommonServiceItem selectedServiceItem;
  @override
  _OperatorState createState() =>
      _OperatorState(this._merchant, selectedServiceItem);
}

class GroupModel {
  String text;
  int index;
  GroupModel({this.text, this.index});
}

class _OperatorState extends State<Operator> {
  bool _showOtherInput = false;

  final _billInputController = TextEditingController();

  _OperatorState(this._merchant, this.selectedServiceItem);

  Transaction _transaction = new Transaction();
  final Merchant _merchant;
  var _formKey = GlobalKey<FormState>();
  var _formKey2 = GlobalKey<FormState>();
  bool isLoading = false, coched = false;
  List<String> _category = List();
  List<CommonServiceItem> serviceItems = [];
  CommonServiceItem selectedServiceItem;
  String _current, _url, _serviceNumber, currency, nom, recepteur;
  int _ischeck = 0, index = -1;
  double commission, montant = -1;
  List donnees;
  var data;
  bool _isContratNumberValid = false;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _userTextController = new TextEditingController();
  var _userTextController1 = new TextEditingController();
  var _userTextController2 = new TextEditingController();
  var _btnVerifyKey;
  String _code;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    coched = false;
    _code = "+237";
    this.getItemData("merchandId");
    if (_merchant.category == Services.UTILITY_CATEGORY) {
      _userTextController.text = "Montant de la facture";
    }
    init();
  }

  void init() async {
    var sellableItemId = await AppState.getInt(Data.SELLABLE_ITEM);
    var serviceNumber = await AppState.getString(Data.MERCHANT_ID);
    setState(() {
      _transaction.sellableItemId = sellableItemId;
      _transaction.serviceNumber = serviceNumber;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _userTextController.dispose();
    _userTextController1.dispose();
    _userTextController2.dispose();
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

  Future<String> getData(String route) async {
    var _header = {
      "accept": "application/json",
      "content-type": "application/json",
    };
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var response = await http.get(
        Uri.encodeFull(route),
        headers: _header,
      );
      print('statuscode ${response.statusCode} ' +
          utf8.decode(response.bodyBytes));
      print('url $route');
      if (response.statusCode == 200) {
        try {
          var responseValidator = ServerResponseValidator.fromJson(
              jsonDecode(utf8.decode(response.bodyBytes)));

          if (responseValidator.isError()) {
            showInSnackBar(
                "Impossible de traiter votre requete, veuillez verifiez votre connexion intenet");
          }
          donnees = responseValidator.getJson()['items'];
          data = responseValidator.getJson()['items'];
          //print("donnes: ${data[0]['priceAmount']}");
          if (_merchant.category == Services.UTILITY_CATEGORY) {
            if (donnees.isEmpty) {
              setState(() {
                _ischeck = 0;
                _isContratNumberValid = false;
              });
              showInSnackBar("Numéro de compteur inexistant!");
              _serviceNumber = null;
            } else {
              setState(() {
                _ischeck = 2;
                _transaction.amount = "${data[0]['priceAmount']}";
                _transaction.currency = data[0]['currency'];
                montant = data[0]['priceAmount'];
                currency = data[0]['currency'];
                _userTextController.text = '$montant';
                _isContratNumberValid = true;
              });
              serviceItems.clear();
              data.forEach((service) =>
                  serviceItems.add(CommonServiceItem.fromJson(service)));
              if (serviceItems.length == 1)
                selectedServiceItem = serviceItems[0];
              List<String> list = new List();
              for (int i = 0; i < donnees.length; i++) {
                list.add(donnees[i]['description']);
              }
              _category = list;
              print("montant: $montant");
            }
          } else if (_merchant.category == Services.TV_CATEGORY) {
            if (data.isEmpty) {
              setState(() {
                _ischeck = 0;
                _isContratNumberValid = false;
              });
              showInSnackBar("Numéro de d'abonnement inexistant!");
            } else {
              serviceItems.clear();
              data.forEach((service) =>
                  serviceItems.add(CommonServiceItem.fromJson(service)));
              List<String> list = new List();
              for (int i = 0; i < donnees.length; i++) {
                list.add(donnees[i]['description']);
              }
              _category = list;
              setState(() {
                _ischeck = 2;
                _isContratNumberValid = true;
                print('Sokoto');
              });
            }
          } else if (_merchant.category == Services.TELCO_CATEGORY) {
            data.forEach((service) =>
                serviceItems.add(CommonServiceItem.fromJson(service)));
            if (serviceItems.length == 1) selectedServiceItem = serviceItems[0];
          }
        } on Exception catch (e) {
          showInSnackBar(
              "Impossible de traiter votre requete, veuillez verifiez votre connexion intenet");
        }
      }
    } else {
      ackAlert(context);
    }
    getCheck();
    return "success";
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
            ProcessStep(ProcessStep.CONFIG, _merchant.logoFileId),
            Card(
              elevation: 0,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                  ),
                  _merchant.category == Services.TELCO_CATEGORY
                      ? Padding(
                    padding:
                    EdgeInsets.only(left: 15, right: 15, top: 30),
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
                                  color: couleur_bordure, width: bordure),
                            ),
                            height: hauteur_champ,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    flex: 5,
                                    child: Padding(
                                        padding:
                                        EdgeInsets.only(left: 20),
                                        child: CountryCodePicker(
                                          showFlag: true,
                                          textStyle: TextStyle(
                                              color:
                                              couleur_libelle_champ),
                                          onChanged: (code) {
                                            _code = code.dialCode;
                                          },
                                        ))),
                                new Expanded(
                                  flex: 10,
                                  child: new TextFormField(
                                    keyboardType: TextInputType.phone,
                                    style: TextStyle(
                                      fontSize: taille_libelle_champ + 3,
                                      color: couleur_libelle_champ,
                                    ),
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return 'Champs requis';
                                      } else {
                                        _transaction
                                            .beneficiaryPhoneNumber =
                                            _code.replaceAll("+", "") +
                                                value;
                                        _transaction.serviceNumber =
                                            value;
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration.collapsed(
                                      hintText: 'Numéro à recharger',
                                      hintStyle: TextStyle(
                                        fontSize:
                                        taille_libelle_champ + 3,
                                        color: couleur_libelle_champ,
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
                                bottomRight: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                              ),
                              color: Colors.transparent,
                              border: Border.all(
                                  color: couleur_bordure, width: bordure),
                            ),
                            height: hauteur_champ,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: new TextFormField(
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    fontSize: taille_libelle_champ + 3,
                                    color: couleur_libelle_champ,
                                  ),
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return 'Champ montant vide !';
                                    } else {
                                      _transaction.amount = value;
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'Montant de la recharge',
                                    hintStyle: TextStyle(
                                      fontSize: taille_libelle_champ + 3,
                                      color: couleur_libelle_champ,
                                    ),
                                    //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: _merchant.category == Services.PHARMACY_CATEGORY
                        ? Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.only(
                                topRight: Radius.circular(10.0),
                                topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular(
                                    coched == false ? 10.0 : 0.0),
                                bottomRight: Radius.circular(
                                    coched == false ? 10.0 : 0.0),
                              ),
                              border: Border.all(
                                  color: couleur_bordure, width: bordure),
                            ),
                            height: hauteur_champ,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: new TextFormField(
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    fontSize: taille_libelle_champ + 3,
                                    color: couleur_libelle_champ,
                                  ),
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return 'Champ montant vide !';
                                    } else {
                                      _transaction.amount = value;
                                      _transaction.description =
                                      "Paiement d'une ordonnance";
                                      print(
                                          "Pharmacy transaction ${_transaction.toJson()}");
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'Montant de l\'ordonnance',
                                    hintStyle: TextStyle(
                                      fontSize: taille_libelle_champ + 3,
                                      color: couleur_libelle_champ,
                                    ),
                                    //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          coched == false
                              ? Container()
                              : Container(
                            decoration: new BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                  color: couleur_bordure,
                                  width: bordure),
                            ),
                            height: hauteur_champ,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        flex: 5,
                                        child: CountryCodePicker(
                                          showFlag: true,
                                          textStyle: TextStyle(
                                              color:
                                              couleur_libelle_champ),
                                          onChanged: (code) {
                                            _code = code.dialCode;
                                          },
                                        )),
                                    Expanded(
                                      flex: 10,
                                      child: new TextFormField(
                                        keyboardType:
                                        TextInputType.text,
                                        style: TextStyle(
                                          fontSize:
                                          taille_libelle_champ +
                                              3,
                                          color:
                                          couleur_libelle_champ,
                                        ),
                                        validator: (String value) {
                                          if (value.isEmpty) {
                                            return 'Champ bénéficiaire vide !';
                                          } else {
                                            setState(() {
                                              _transaction
                                                  .beneficiaryPhoneNumber =
                                                  _code.replaceAll(
                                                      "+", "") +
                                                      value;
                                            });
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration
                                            .collapsed(
                                          hintText:
                                          'Numéro du bénéficiaire',
                                          hintStyle: TextStyle(
                                            fontSize:
                                            taille_libelle_champ +
                                                3,
                                            color:
                                            couleur_libelle_champ,
                                          ),
                                          //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          coched == false
                              ? Container()
                              : Container(
                            decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.only(
                                bottomRight: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                              ),
                              border: Border.all(
                                  color: couleur_bordure,
                                  width: bordure),
                            ),
                            height: hauteur_champ,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: new TextFormField(
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    fontSize:
                                    taille_libelle_champ + 3,
                                    color: couleur_libelle_champ,
                                  ),
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return 'Champ bénéficiaire vide !';
                                    } else {
                                      setState(() {
                                        _transaction
                                            .beneficiaryEmail =
                                            value;
                                      });
                                      return null;
                                    }
                                  },
                                  decoration:
                                  InputDecoration.collapsed(
                                    hintText:
                                    'Nom complet du bénéficiaire',
                                    hintStyle: TextStyle(
                                      fontSize:
                                      taille_libelle_champ + 3,
                                      color: couleur_libelle_champ,
                                    ),
                                    //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                        : Container(),
                  ),
                  _merchant.category == Services.UTILITY_CATEGORY ||
                      _merchant.category == Services.TV_CATEGORY
                      ? Padding(
                    padding:
                    EdgeInsets.only(left: 15, right: 15, top: 30),
                    child: Column(
                      children: <Widget>[
                        Form(
                          key: _formKey2,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: _merchant.logoFileId.contains("tv.png")
                                ? Container()
                                : Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 8,
                                  child: Padding(
                                    padding:
                                    EdgeInsets.only(right: 5),
                                    child: Container(
                                      decoration: new BoxDecoration(
                                        borderRadius:
                                        new BorderRadius.only(
                                          bottomRight:
                                          Radius.circular(10.0),
                                          bottomLeft:
                                          Radius.circular(10.0),
                                          topRight:
                                          Radius.circular(10.0),
                                          topLeft:
                                          Radius.circular(10.0),
                                        ),
                                        color: Colors.transparent,
                                        border: Border.all(
                                            color: couleur_bordure,
                                            width: bordure),
                                      ),
                                      height: hauteur_champ,
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 20),
                                          child: new TextFormField(
                                            controller:
                                            _billInputController,
                                            keyboardType:
                                            TextInputType.text,
                                            onEditingComplete: () {
                                              _isContratNumberValid =
                                              false;
                                            },
                                            style: TextStyle(
                                              fontSize:
                                              taille_libelle_champ +
                                                  3,
                                              color:
                                              couleur_libelle_champ,
                                            ),
                                            validator:
                                                (String value) {
                                              if (value.isEmpty) {
                                                return _merchant
                                                    .category ==
                                                    Services
                                                        .TV_CATEGORY
                                                    ? (value.length > 0 &&
                                                    value.length !=
                                                        14 &&
                                                    !value
                                                        .substring(0,
                                                        2)
                                                        .contains("140")
                                                    ? "Numéro d\'abonnement invalide"
                                                    : 'Numéro d\'abonnement vide')
                                                    : 'Numéro du compteur vide !';
                                              } else {
                                                _serviceNumber =
                                                    value;
                                                _transaction
                                                    .serviceNumber =
                                                    value;
                                                return null;
                                              }
                                            },
                                            decoration:
                                            InputDecoration
                                                .collapsed(
                                              hintText: _merchant
                                                  .category ==
                                                  Services
                                                      .TV_CATEGORY
                                                  ? 'Numéro d\'abonnement'
                                                  : 'Numéro du compteur',
                                              hintStyle: TextStyle(
                                                fontSize:
                                                taille_libelle_champ +
                                                    3,
                                                color:
                                                couleur_libelle_champ,
                                              ),
                                              //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding:
                                    EdgeInsets.only(left: 5),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (_formKey2.currentState
                                              .validate()) {
                                            _ischeck = 1;
                                            _url =
                                            "$baseUrl/items?merchantId=${_merchant.id}&serviceNumber=$_serviceNumber";
                                            this.getData(_url);
                                          }
                                        });
                                      },
                                      child: new Container(
                                        height: hauteur_champ,
                                        width:
                                        MediaQuery.of(context)
                                            .size
                                            .width -
                                            40,
                                        decoration:
                                        new BoxDecoration(
                                          color: Colors.green,
                                          border: new Border.all(
                                            color:
                                            Colors.transparent,
                                            width: 0.0,
                                          ),
                                          borderRadius:
                                          new BorderRadius
                                              .circular(10.0),
                                        ),
                                        child: new Center(
                                            key: _btnVerifyKey,
                                            child: getCheck()),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Form(
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
                                child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      icon: Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: new Icon(
                                          Icons.arrow_drop_down_circle,
                                          color: Colors.green,
                                        ),
                                      ),
                                      isDense: true,
                                      elevation: 1,
                                      isExpanded: true,
                                      onChanged: (String selected) {
                                        int index = -1;
                                        setState(() {
                                          _current = selected;
                                          if (_merchant.category ==
                                              Services.TV_CATEGORY) {
                                            index =
                                                _category.indexOf(_current);
                                            selectedServiceItem =
                                            serviceItems[index];
                                            print(
                                                "Selected Item ${selectedServiceItem.toJson()}");

                                            montant =
                                            data[index]['priceAmount'];
                                            currency =
                                            data[index]['currency'];
                                            commission = data[index]
                                            ['spCommissionAmount'];

                                            if (_merchant.logoFileId
                                                .contains("tv.png") &&
                                                selected.contains("autre")) {
                                              _showOtherInput = true;
                                            } else {
                                              _showOtherInput = false;
                                            }
                                          }
                                        });
                                        _userTextController.text = "$montant";
                                      },
                                      value: _current,
                                      hint: Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: Text(
                                          getText(),
                                          style: TextStyle(
                                            color: couleur_libelle_champ,
                                            fontSize:
                                            taille_libelle_champ + 3,
                                          ),
                                        ),
                                      ),
                                      items: _category.map((String name) {
                                        return DropdownMenuItem<String>(
                                          value: name,
                                          child: Padding(
                                            padding:
                                            EdgeInsets.only(left: 20),
                                            child: Text(
                                              name,
                                              style: TextStyle(
                                                  color: couleur_fond_bouton,
                                                  fontSize:
                                                  taille_libelle_champ +
                                                      3,
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    )),
                              ),
                              _showOtherInput
                                  ? Container(
                                decoration: new BoxDecoration(
                                  border: Border.all(
                                      color: couleur_bordure,
                                      width: bordure),
                                ),
                                height: hauteur_champ,
                                child: Center(
                                  child: Padding(
                                    padding:
                                    EdgeInsets.only(left: 20),
                                    child: new TextFormField(
                                      keyboardType:
                                      TextInputType.text,
                                      style: TextStyle(
                                        fontSize:
                                        taille_libelle_champ +
                                            3,
                                        color:
                                        couleur_libelle_champ,
                                      ),
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return 'Champ autre vide !';
                                        } else {
                                          _transaction
                                              .serviceNumber =
                                              value;
                                          return null;
                                        }
                                      },
                                      decoration:
                                      InputDecoration.collapsed(
                                        hintText:
                                        'Préciser le service',
                                        hintStyle: TextStyle(
                                          fontSize:
                                          taille_libelle_champ +
                                              3,
                                          color:
                                          couleur_libelle_champ,
                                        ),
                                        //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                                  : Container(),
                              coched == false
                                  ? Container()
                                  : Container(
                                decoration: new BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                      color: couleur_bordure,
                                      width: bordure),
                                ),
                                height: hauteur_champ,
                                child: Center(
                                  child: Padding(
                                    padding:
                                    EdgeInsets.only(left: 20),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                            flex: 5,
                                            child:
                                            CountryCodePicker(
                                              showFlag: true,
                                              textStyle: TextStyle(
                                                  color:
                                                  couleur_libelle_champ),
                                              onChanged: (code) {
                                                _code =
                                                    code.dialCode;
                                              },
                                            )),
                                        Expanded(
                                          flex: 10,
                                          child: new TextFormField(
                                            keyboardType:
                                            TextInputType.text,
                                            style: TextStyle(
                                              fontSize:
                                              taille_libelle_champ +
                                                  3,
                                              color:
                                              couleur_libelle_champ,
                                            ),
                                            validator:
                                                (String value) {
                                              if (value.isEmpty) {
                                                return 'Champ bénéficiaire vide !';
                                              } else {
                                                recepteur =
                                                "$_code$value";
                                                _userTextController1
                                                    .text =
                                                "$recepteur";

                                                setState(() {
                                                  _transaction
                                                      .beneficiaryPhoneNumber =
                                                      _code.replaceAll(
                                                          "+",
                                                          "") +
                                                          value;
                                                });

                                                return null;
                                              }
                                            },
                                            decoration:
                                            InputDecoration
                                                .collapsed(
                                              hintText:
                                              'Numéro du bénéficiaire',
                                              hintStyle: TextStyle(
                                                fontSize:
                                                taille_libelle_champ +
                                                    3,
                                                color:
                                                couleur_libelle_champ,
                                              ),
                                              //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              coched == false
                                  ? Container()
                                  : Container(
                                decoration: new BoxDecoration(
                                  border: Border.all(
                                      color: couleur_bordure,
                                      width: bordure),
                                ),
                                height: hauteur_champ,
                                child: Center(
                                  child: Padding(
                                    padding:
                                    EdgeInsets.only(left: 20),
                                    child: new TextFormField(
                                      keyboardType:
                                      TextInputType.text,
                                      style: TextStyle(
                                        fontSize:
                                        taille_libelle_champ +
                                            3,
                                        color:
                                        couleur_libelle_champ,
                                      ),
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return 'Champ bénéficiaire vide !';
                                        } else {
                                          nom = "$value";
                                          _userTextController2
                                              .text = "$value";
                                          print("Name $value");
                                          setState(() {
                                            _transaction
                                                .beneficiaryEmail =
                                                value;
                                          });
                                          return null;
                                        }
                                      },
                                      decoration:
                                      InputDecoration.collapsed(
                                        hintText:
                                        'Email du bénéficiaire',
                                        hintStyle: TextStyle(
                                          fontSize:
                                          taille_libelle_champ +
                                              3,
                                          color:
                                          couleur_libelle_champ,
                                        ),
                                        //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              (_merchant.category ==
                                  Services.UTILITY_CATEGORY) &&
                                  montant == -1
                                  ? Container()
                                  : Container(
                                decoration: new BoxDecoration(
                                  borderRadius:
                                  new BorderRadius.only(
                                    bottomRight:
                                    Radius.circular(10.0),
                                    bottomLeft:
                                    Radius.circular(10.0),
                                    topRight: Radius.circular(
                                        _merchant.category ==
                                            Services
                                                .UTILITY_CATEGORY
                                            ? 10.0
                                            : 0.0),
                                    topLeft: Radius.circular(
                                        _merchant.category ==
                                            Services
                                                .UTILITY_CATEGORY
                                            ? 10.0
                                            : 0.0),
                                  ),
                                  color: Colors.transparent,
                                  border: Border.all(
                                      color: couleur_bordure,
                                      width: bordure),
                                ),
                                height: hauteur_champ,
                                child: Center(
                                  child: Padding(
                                    padding:
                                    EdgeInsets.only(left: 20),
                                    child: new TextFormField(
                                      enabled: _merchant.logoFileId
                                          .contains("tv.png")
                                          ? true
                                          : false,
                                      controller: _merchant
                                          .logoFileId
                                          .contains("tv.png")
                                          ? null
                                          : _userTextController,
                                      keyboardType:
                                      TextInputType.number,
                                      style: TextStyle(
                                        fontSize:
                                        taille_libelle_champ +
                                            3,
                                        color:
                                        couleur_libelle_champ,
                                      ),
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return 'Champ montant vide !';
                                        } else {
                                          montant =
                                              double.parse(value);
                                          _transaction.amount =
                                          "$montant";
                                          _userTextController.text =
                                          "$montant";
                                          return null;
                                        }
                                      },
                                      decoration:
                                      InputDecoration.collapsed(
                                        hintText: _merchant
                                            .category ==
                                            Services
                                                .UTILITY_CATEGORY ||
                                            _merchant
                                                .category ==
                                                Services
                                                    .TELCO_CATEGORY
                                            ? 'Montant de la recharge'
                                            : 'Montant',
                                        hintStyle: TextStyle(
                                          fontSize:
                                          taille_libelle_champ +
                                              3,
                                          color:
                                          couleur_libelle_champ,
                                        ),
                                        //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                      : Container(),
                  _merchant.logoFileId.contains("tv.png") ||
                      _merchant.category == Services.PHARMACY_CATEGORY
                      ? Row(
                    //mainAxisAlignment: MainAxisAlignment.center,  1fcc2ec18bc30a725c0dab9970d02291758426dc
                    children: <Widget>[
                      Checkbox(
                          activeColor: couleur_fond_bouton,
                          value: coched,
                          onChanged: (bool val) {
                            setState(() {
                              coched = val;
                            });
                            if (!coched) {
                              _transaction.beneficiaryPhoneNumber = null;
                            }
                          }),
                      Text(
                        "Paiement pour un tiers",
                        style: TextStyle(
                            color: couleur_description_champ,
                            fontSize: taille_champ + 3,
                            fontFamily: police_description_champ,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          bool isForm1Valid = true;
                          bool isForm2Valid = true;
                          bool serviceNumberValide = true;
                          if (_formKey2.currentState != null)
                            isForm2Valid = _formKey2.currentState.validate();
                          if (_formKey.currentState != null)
                            isForm1Valid = _formKey.currentState.validate();
                          if (_merchant.category == Services.TV_CATEGORY ||
                              _merchant.category == Services.UTILITY_CATEGORY) {
                            serviceNumberValide = _isContratNumberValid;
                            print("bleuk");
                          }
                          print("Valid $serviceNumberValide");
                          if (isForm1Valid &&
                              isForm2Valid &&
                              serviceNumberValide) {
                            AppState.putString(Data.CURRENCY, currency);
                            AppState.putString(Data.SERVICE_AMOUNT, "$montant");
                            if (!coched) {
                              _transaction.beneficiaryEmail = null;
                            }
                            this._reg();
                            if (selectedServiceItem != null)
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: Confirm(_merchant,
                                          selectedServiceItem, _transaction)));
                            else
                              showInSnackBar(
                                  "Service temporairement indisponible réessayer dans quelques secondes !!!");
                          }
                        });
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
                            'Poursuivre l\'opération',
                            style: new TextStyle(
                                fontSize: taille_text_bouton + 3,
                                color: couleur_text_bouton),
                          )
                              : CupertinoActivityIndicator(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getCheck() {
    switch (_ischeck) {
      case 0:
        return new Text(
          'Vérifier',
          style: new TextStyle(
              fontSize: taille_text_bouton + 3, color: couleur_text_bouton),
        );
      case 1:
        return new CupertinoActivityIndicator();
      case 2:
        return new Icon(
          Icons.check,
          color: Colors.white,
        );
    }
  }

  String getText() {
    print("actu == $_current");
    if (_merchant.logoFileId.contains("tv.png")) {
      return "Choisissez un service";
    } else if (_merchant.category == Services.TV_CATEGORY && _ischeck == 1 ||
        _ischeck == 0) {
      return "Vérifier votre numéro d'abonnement";
    } else if (_merchant.category == Services.TV_CATEGORY && _ischeck == 2) {
      return "Access 5000 Fcfa/mois";
    } else {
      return "Choisissez une facture";
    }
  }

  getItemData(String v) async {
    if (_merchant.category == Services.TELCO_CATEGORY ||
        _merchant.logoFileId.contains("tv.png"))
      this.getData("$baseUrl/items?merchantId=${_merchant.id}");
  }

  void _reg() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('coched', "$coched");
    print("************************ $coched");
  }
}