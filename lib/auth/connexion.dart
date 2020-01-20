import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:services/auth/connexion1.dart';
import 'package:services/auth/inscription1.dart';
import 'package:services/composants/components.dart';
import 'package:services/composants/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class Connexion extends StatefulWidget {
  Connexion();
  @override
  _ConnexionState createState() => new _ConnexionState();
}

class _ConnexionState extends State<Connexion> {

  _ConnexionState();
  String _username, _url, iso3, pays, _mySelection;
  var _formKey = GlobalKey<FormState>(), flagUri;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoding =false;
  int ad=3;
  FocusNode searchFocus = FocusNode();

  @override
  void initState() {
    this.lire();
    super.initState();
    _url = '$base_url/member/getUser/';
    Timer(Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(searchFocus);
    });
  }

  void checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      //print("Connected to Mobile");
      setState(() {
        isLoding = true;
      });
      this.getUser();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Connexion(_code)));
      setState(() {
        isLoding = true;
      });
      this.getUser();
    } else {
      _ackAlert(context);
    }
  }


  Future<void> _ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Oops!'),
          content: Text("Vérifier votre connexion internet."),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Future<Login> getUser() async {
    var headers = {
      "Accept": "application/json"
    };
    var url = "${this._url}$_username";
    http.Response response = await http.get(url, headers: headers);
    final int statusCode = response.statusCode;
    print("${response.body}");
    if(statusCode == 200){
      var responseJson = json.decode(response.body);
      print(responseJson);
      setState(() {
        isLoding = false;
      });
      this._reg();
      if(responseJson['isExist'] == false){
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Inscription1()));
        //navigatorKey.currentState.pushNamed("/inscription");
      }else{
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Connexion1()));
        //navigatorKey.currentState.pushNamed("/connexion");
      }
    }else{
      print(statusCode);
      setState(() {
        isLoding = false;
      });
      showInSnackBar("Service indisponible!");
    }
    return null;
  }


  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text(value,style:
        TextStyle(
            color: Colors.white,
            fontSize: taille_champ+3
        ),
          textAlign: TextAlign.center,),
          backgroundColor: couleur_fond_bouton,
          duration: Duration(seconds: 5),));
  }

  bool tryParse(String str) {
    if(str == null) {
      return false;
    }
    return int.tryParse(str) != null;
  }

  Future<bool>_onBackPressed(){
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Fermer l'application ?"),
        actions: <Widget>[
          FlatButton(
            child: Text("No"),
              onPressed: () => Navigator.pop(context, false),
          ),
          FlatButton(
            child: Text("Yes"),
            onPressed: () => exit(0),
          )
        ],
      )
    );
  }

  //final navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final espace = (MediaQuery.of(context).size.height - 533.3333333333334)<=0?0.0:MediaQuery.of(context).size.height - 533.3333333333334;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: new Scaffold(
          key: _scaffoldKey,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(55.0),
            child: new AppBar(
              elevation: 0.0,
              backgroundColor: couleur_appbar,
              flexibleSpace: barreTop,
              leading: GestureDetector(
                  onTap: (){},
                  //child: Icon(Icons.arrow_back_ios,)
              ),
              //iconTheme: new IconThemeData(color: couleur_fond_bouton),
            ),
          ),
          body: SingleChildScrollView(
            child: Stack(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: new Column(
                      children: <Widget>[
                        Container(
                          height: hauteur_logo,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0.0, bottom: 10.0, left: 40.0, right: 40.0),
                            child: new Image.asset('images/logo.png'),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top:espace/2,)),

                        Padding(
                            padding: EdgeInsets.only(top:marge_apres_logo-15),),

                        Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: new Text("Bienvenue sur\nSprint-Pay",
                            style: TextStyle(
                              color: couleur_titre,
                              fontSize: taille_titre,
                              fontWeight: FontWeight.bold
                            ),),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left:20.0, top:20.0, right: 20.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: new Text("Première plateforme d'intéropérabilité des services financiers.",
                              style: TextStyle(
                                  color: couleur_titre,
                                  fontSize: taille_description_page,
                              ),),
                          ),
                        ),


                        Padding(
                          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: marge_apres_description_page),
                          child: Container(
                            decoration: new BoxDecoration(
                                borderRadius: new BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                ),
                              color: Colors.transparent,
                              border: Border.all(
                                color: couleur_bordure,
                                width: bordure
                              ),
                            ),
                            height: hauteur_champ,
                            child:_mySelection==null?Container(): Row(
                              children: <Widget>[
                                Expanded(
                                    flex: 5,
                                    child: CountryCodePicker(
                                      showFlag: true,
                                      textStyle: TextStyle(
                                        fontSize: taille_libelle_champ+ad,
                                        color: couleur_libelle_champ
                                      ),
                                      initialSelection:_mySelection,
                                      onChanged: (CountryCode code) {
                                        _mySelection = code.dialCode.toString();
                                        flagUri = "${code.flagUri}";
                                        iso3 = "${code.codeIso}";
                                        //print(iso3);
                                        pays = "${code.name}";
                                      },
                                    )
                                ),
                                new Expanded(
                                  flex:10,
                                  child: new TextFormField(
                                    keyboardType: TextInputType.phone,
                                    style: TextStyle(
                                        fontSize: taille_libelle_champ+ad,
                                        color: couleur_libelle_champ,
                                    ),
                                    validator: (String value){
                                      if(value.isEmpty){
                                        return "Champ téléphone vide !";
                                      }else{
                                        if(_mySelection == "+33" && value.startsWith("0")){
                                            _username = _mySelection.substring(1)+value.substring(1);
                                        }else{
                                            _username = _mySelection.substring(1)+value;
                                        }
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration.collapsed(
                                      hintText: "Numéro de téléphone",
                                      hintStyle: TextStyle(
                                          fontSize: taille_libelle_champ+ad,
                                          color: couleur_libelle_champ,
                                      ),
                                      //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: new GestureDetector(
                            onTap: () {
                              setState(() {
                                if(_formKey.currentState.validate()){
                                  print(_username);
                                  if(tryParse('$_username')==false){
                                    showInSnackBar("Numéro de téléphone invalide!");
                                  }else {
                                    checkConnection();
                                  }
                                }
                              });
                            },
                            child: new Container(
                              height: hauteur_champ,
                              width: MediaQuery.of(context).size.width - 40,
                              decoration: new BoxDecoration(
                                color: couleur_fond_bouton,
                                border: new Border.all(
                                  color: Colors.transparent,
                                  width: 0.0,
                                ),
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              child: new Center(child: isLoding==false?new Text("Commencer", style: new TextStyle(fontSize: taille_text_bouton+ad, color: couleur_text_bouton),):
                              CupertinoActivityIndicator(),),
                            ),
                          ),
                        ),

                      Padding(
                        padding: EdgeInsets.only(top:20.0),
                        child: GestureDetector(
                            onTap: (){
                              showInSnackBar("Pas encore disponible");
                              //navigatorKey.currentState.pushNamed("/activation");
                            },
                            child: Text("Contactez-nous",
                              style: TextStyle(
                                  color:couleur_fond_bouton,
                                  fontSize: taille_champ+ad,
                                  fontWeight: FontWeight.bold
                              ),textAlign: TextAlign.center,
                            )
                        ),
                      )
                      ],
                    ),
                  ),
                ],
              ),
          ),
          bottomNavigationBar: barreBottom,
        ),
    );
  }

  void _reg() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', "$_username");
    prefs.setString('flag', "$flagUri");
    prefs.setString('iso3', "$iso3");
    prefs.setString('pays', "$pays");
    prefs.setString('dial', "$_mySelection");

  }

  lire() async {
    final prefs = await SharedPreferences.getInstance();
      if(prefs.getString("pays") == null){
        pays="Cameroun";
      }else{
        pays = prefs.getString("pays");
      }
    print("pays: $pays");

      if(prefs.getString("iso3") == null){
        iso3="CMR";
      }else{
        iso3 = prefs.getString("iso3");
      }
    print("iso3: $iso3");
    if(prefs.getString("flag") == null){
      flagUri="flags/cm.png";
    }else{
      flagUri = prefs.getString("flag");
    }
    print("flagURI: $flagUri");

    if(prefs.getString("dial") == null){
      _mySelection="+237";
    }else{
      print("Mon dial"+prefs.getString("dial"));
      setState(() {
        _mySelection=prefs.getString("dial");
      });
    }
    print("dial: $_mySelection");
  }
}