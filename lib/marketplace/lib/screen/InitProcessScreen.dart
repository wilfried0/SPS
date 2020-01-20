import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:services/marketplace/lib/api/ServerResponseValidator.dart';
import 'package:services/marketplace/lib/models/CommonServiceItem.dart';
import 'package:services/marketplace/lib/models/ServiceConfig.dart';
import 'package:services/marketplace/lib/models/Services.dart';
import 'package:services/marketplace/lib/models/Transaction.dart';
import 'package:services/marketplace/lib/system/AppState.dart';
import 'package:services/marketplace/lib/system/Config.dart';

import '../colors.dart';
import '../confirm.dart';
import '../services.dart';
import 'item/InputGenerator.dart';
import 'item/ProcessStep.dart';

class InitProcessScreen extends StatefulWidget {
  InitProcessScreen(this._merchant);

  final Merchant _merchant;

  @override
  _InitProcessScreenState createState() =>
      _InitProcessScreenState(this._merchant);
}

class GroupModel {
  String text;
  int index;

  GroupModel({this.text, this.index});
}

class _InitProcessScreenState extends State<InitProcessScreen> {
  _InitProcessScreenState(this._merchant);

  Transaction _transaction = new Transaction();
  final Merchant _merchant;
  var _formKey = GlobalKey<FormState>();
  var _formKey2 = GlobalKey<FormState>();
  bool isLoading = false, isCheckedPayForOther = false;
  var _category = [''];
  List<CommonServiceItem> serviceItems = [];
  CommonServiceItem selectedServiceItem;
  String _current, _url, _serviceNumber, currency, commission, nom, recepteur;
  int _ischeck = 0, index = -1;
  double montant = -1;
  List donnees;
  ServiceConfig _serviceConfig;
  var data;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _userTextController = new TextEditingController();
  var _userTextController1 = new TextEditingController();
  var _userTextController2 = new TextEditingController();
  var _btnVerifyKey;
  InputGenerator _inputGenerator;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getItemData("merchandId");
    if (_merchant.category == Services.UTILITY_CATEGORY) {
      _userTextController.text = "Montant de la facture";
    }
    _serviceConfig = Config.rule(_merchant.id);
    _inputGenerator = new InputGenerator();
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
        var responseValidator = ServerResponseValidator.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)));
        if (responseValidator.isError()) {
          showInSnackBar("An occured while processing yout request");
        }
        donnees = responseValidator.getJson()['items'];
        data = responseValidator.getJson()['items'];
        if (_merchant.category == Services.UTILITY_CATEGORY) {
          if (donnees.isEmpty) {
            setState(() {
              _ischeck = 0;
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
              commission = data[0]['spCommissionAmount'];
              _userTextController.text = '$montant';
            });
          }
        } else if (_merchant.category == Services.TV_CATEGORY) {
          if (data.isEmpty) {
            setState(() {
              _ischeck = 0;
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
            setState(() {
              _ischeck = 2;
              _category = list;
            });
          }
        } else if (_merchant.category == Services.TELCO_CATEGORY) {
          data.forEach((service) =>
              serviceItems.add(CommonServiceItem.fromJson(service)));
          if (serviceItems.length == 1) selectedServiceItem = serviceItems[0];
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
                  Visibility(
                    visible: _serviceConfig.serviceRequired,
                    child: Padding(
                      padding: EdgeInsets.only(top: 8, left: 15, right: 15),
                      child: Container(
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.circular(10.0),
                          color: Colors.transparent,
                          border: Border.all(
                              color: couleur_bordure, width: bordure),
                        ),
                        height: hauteur_champ,
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                          icon: Padding(
                            padding: EdgeInsets.only(right: 20),
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
                              if (_merchant.category == Services.TV_CATEGORY) {
                                index = _category.indexOf(_current);
                                selectedServiceItem = serviceItems[index];
                                print(
                                    "Selected Item ${selectedServiceItem.toJson()}");

                                montant = data[index]['priceAmount'];
                                currency = data[index]['currency'];
                                commission = data[index]['spCommissionAmount'];
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
                                fontSize: taille_libelle_champ + 3,
                              ),
                            ),
                          ),
                          items: _category.map((String name) {
                            return DropdownMenuItem<String>(
                              value: name,
                              child: Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                  name,
                                  style: TextStyle(
                                      color: couleur_fond_bouton,
                                      fontSize: taille_libelle_champ + 3,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          }).toList(),
                        )),
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: new InputGenerator().getForm(
                          _serviceConfig, _formKey,
                          showPayByOther: isCheckedPayForOther)),
                  _serviceConfig.canPayByOther
                      ? Row(
                          //mainAxisAlignment: MainAxisAlignment.center,  1fcc2ec18bc30a725c0dab9970d02291758426dc
                          children: <Widget>[
                            Checkbox(
                                activeColor: couleur_fond_bouton,
                                value: isCheckedPayForOther,
                                onChanged: (bool val) {
                                  setState(() {
                                    isCheckedPayForOther = val;
                                  });
                                  if (!isCheckedPayForOther) {
                                    recepteur = null;
                                    nom = null;
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
                          if (_formKey2.currentState != null)
                            isForm2Valid = _formKey2.currentState.validate();
                          if (_formKey.currentState != null)
                            isForm1Valid = _formKey.currentState.validate();
                          if (isForm1Valid && isForm2Valid) {
                            AppState.putString(Data.CURRENCY, currency);
                            AppState.putString(Data.SERVICE_AMOUNT, "$montant");

                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    //TODO send _merchant and service selected
                                    child: Confirm(_merchant,
                                        selectedServiceItem, _transaction)));
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
}
