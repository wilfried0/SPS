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
import 'package:services/community/lib/utils/components.dart';
import 'package:services/composants/components.dart';
import 'package:services/lang/sit_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

// ignore: must_be_immutable
class Connexion extends StatefulWidget {
  Connexion();
  @override
  _ConnexionState createState() => new _ConnexionState();
}

class _ConnexionState extends State<Connexion> {

  _ConnexionState();
  String _username, _url, lang="FR",_value="1", currencyConnexion, currencySymbol, _url1, iso3, pays, _mySelection,_sername, iso="CM";
  var _formKey = GlobalKey<FormState>(), flagUri;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoding =false, coched = false;
  int ad=3;
  FocusNode searchFocus = FocusNode();
  var _usernameController;

  @override
  void initState() {
    print("l'iso est $iso");
    this.lire();
    super.initState();
    _url = '$base_url/member/getUser/';
    _url1 = "$cagnotte_url/user/currencyUser/";
    _usernameController = TextEditingController();
    Timer(Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(searchFocus);
    });
  }


  getCurrency(String f) async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    String url = "${this._url1}$f";
    print("$url");
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.set('Accept', 'application/json');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print(response.statusCode);
    print(reply);
    if(response.statusCode == 200){
      if(reply.isEmpty){
        showToast(SitLocalizations.of(context).error_get_dev,duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        checkConnection(1);
      }else{
        var responseJson = json.decode(reply);
        currencyConnexion = responseJson['currency']['currencyCode'];
        currencySymbol = responseJson['currency']['currencySymbol'];
        print('currencyConnexion: $currencyConnexion');
        checkConnection(1);
      }
    }else{
      print(response.statusCode);
      setState(() {
        isLoding = false;
      });
      //showInSnackBar("Service indisponible!", _scaffoldKey, 5);
    }
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }


  void checkConnection(int q) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      //print("Connected to Mobile");
      setState(() {
        isLoding = true;
      });
      if(q == 1)
        this.getUser();
      else
        this.getCurrency(iso3);
    } else if (connectivityResult == ConnectivityResult.wifi) {
      //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Connexion(_code)));
      setState(() {
        isLoding = true;
      });
      if(q == 1)
        this.getUser();
      else
        this.getCurrency(iso3);
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
          content: Text(SitLocalizations.of(context).check_conn),
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

  getUser() async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    String url = "${this._url}$_username";
    print("$url");
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.set('Accept', 'application/json');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print(reply);
    if(response.statusCode == 200){
      var responseJson = json.decode(reply);
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
      print(response.statusCode);
      setState(() {
        isLoding = false;
      });
      showInSnackBar(SitLocalizations.of(context).service_indis);
    }
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
        title: Text(SitLocalizations.of(context).exit),
        actions: <Widget>[
          FlatButton(
            child: Text(SitLocalizations.of(context).non),
              onPressed: () => Navigator.pop(context, false),
          ),
          FlatButton(
            child: Text(SitLocalizations.of(context).oui),
            onPressed: () => exit(0),
          )
        ],
      )
    );
  }

  @override
  void dispose() {
    super.dispose();
    if(_usernameController != null)
    _usernameController.dispose();
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
          backgroundColor: GRIS,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(55.0),
            child: new AppBar(
              elevation: 0.0,
              backgroundColor: GRIS,
              flexibleSpace: barreTop,
              leading: GestureDetector(
                  onTap: (){},
                  //child: Icon(Icons.arrow_back_ios,)
              ),
              /*actions: [
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 0, right: 20),
                      child: Theme(
                        data: Theme.of(context).copyWith(canvasColor: couleur_fond_bouton),
                        child: DropdownButtonHideUnderline(
                          child: new DropdownButton<String>(
                            icon: new Icon(Icons.arrow_drop_down, color: Colors.black,),
                            items: [
                              DropdownMenuItem(
                                value: "1",
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                        width: 30,
                                        height: 30,
                                        child: Image.asset('flags/fr.png')),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        "Français",style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13
                                      ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: "2",
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                        width: 30,
                                        height: 30,
                                        child: Image.asset('flags/gb.png')),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        "Anglais",style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13
                                      ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _value = value;
                                print(_value);
                              });
                            },
                            value: _value,

                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],*/
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
                            child: new Text("Bienvenue",//SitLocalizations.of(context).bienvenue,
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
                            child: new Text("sur la première plateforme d'interopérabilité des services financiers",//SitLocalizations.of(context).bienvenu_text,
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
                              color: Colors.white,
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
                                       setState(() {
                                         _mySelection = code.dialCode.toString();
                                         flagUri = "${code.flagUri}";
                                         iso3 = "${code.codeIso}";
                                         iso = "${code.code}";
                                         print(iso3);
                                         pays = "${code.name}";
                                       });
                                      },
                                    )
                                ),
                                new Expanded(
                                  flex:10,
                                  child: new TextFormField(
                                    controller: _usernameController,
                                    keyboardType: TextInputType.phone,
                                    style: TextStyle(
                                        fontSize: taille_libelle_champ+ad,
                                        color: couleur_libelle_champ,
                                    ),
                                    validator: (String value){
                                      if(value.isEmpty){
                                        return "Numéro de téléphone invalide !";//SitLocalizations.of(context).invalid_phone;
                                      }else{
                                        if(_mySelection == "+33" && value.startsWith("0")){
                                            _username = _mySelection.substring(1)+value.substring(1);
                                            _sername = value.substring(1);
                                        }else{
                                            _username = _mySelection.substring(1)+value;
                                            _sername = value;
                                        }
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration.collapsed(
                                      hintText:"Numéro de téléphone",// SitLocalizations.of(context).phone,
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

                        Row(
                          children: <Widget>[
                            Checkbox(
                                activeColor: couleur_fond_bouton,
                                value: coched,
                                onChanged: (bool val) {
                                  setState(() {
                                    coched = val;
                                  });
                                }),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  coched = !coched;
                                });
                              },
                              child: Text("Se souvenir de moi",//SitLocalizations.of(context).souvenir,
                                style: TextStyle(
                                  color: couleur_fond_bouton,
                                  fontWeight: FontWeight.bold,
                                  fontSize:taille_champ+ad
                              ),),
                            )
                          ],
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: new GestureDetector(
                            onTap: () {
                              setState(() {
                                if(_formKey.currentState.validate()){
                                  _username = _username.replaceAll(" ", "");
                                  print(_username);
                                  if(tryParse('${_username.replaceAll(" ", "")}')==false){
                                    showInSnackBar(SitLocalizations.of(context).invalid_phone);
                                  }else {
                                    checkConnection(0);
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
                              child: new Center(child: isLoding==false?new Text("Suivant",//SitLocalizations.of(context).suivant,
                                style: new TextStyle(fontSize: taille_text_bouton+ad, color: couleur_text_bouton),):
                              Theme(
                                data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.dark)),
                                child: CupertinoActivityIndicator(radius: 20,)),
                              ),
                            ),
                          ),
                        ),

                      /*Padding(
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
                      )*/
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
    prefs.setString('iso', "$iso");
    prefs.setString('lang', "$lang");
    print("***********************Voilà ${prefs.getString("iso")}");
    prefs.setString('pays', "$pays");
    prefs.setString('dial', "$_mySelection");
    prefs.setString('BUYER_COUNTRY', "$iso3");
    prefs.setString('BENEFICIARY_COUNTRY', "$iso3");
    prefs.setString(CURRENCYSYMBOL_CONNEXION, currencyConnexion);
    prefs.setString(CURRENCYSYMBOL, currencySymbol);
    prefs.setString('sername', "$_sername");
    if(coched == true) {
      prefs.setString('coched', "$_sername");
    }else{
    }
  }

  lire() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    print("*********************** ${prefs.getString("coched")}");
    if(prefs.getString("coched") == null || prefs.getString("coched") == "false"){
      _usernameController = null;
    }else{
      setState(() {
        coched = true;
        _usernameController.text = prefs.getString("coched");
      });
    }
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
    if(prefs.getString("iso") == "null" || prefs.getString("iso") == null){
      iso="CM";
    }else{
      iso = prefs.getString("iso");
    }
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