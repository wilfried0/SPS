import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:services/auth/connexion.dart';
import 'package:services/composants/components.dart';
import 'package:services/composants/services.dart';
import 'inscription.dart';
import 'profile.dart';
import 'verification1.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class Connexion1 extends StatefulWidget {
  Connexion1();
  @override
  _Connexion1State createState() => new _Connexion1State();
}

class _Connexion1State extends State<Connexion1> with WidgetsBindingObserver {

  _Connexion1State();
  String _username, _password, _url, _nom, _ville, _quartier;

  var _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isHidden = true, isLoding =false;
  var _userTextController = new TextEditingController();
  int ad=3;
  bool isBackButtonActivated = false;

  @override
  void initState(){
    this._lect();
    _url = '$base_url/member/login';
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //BackButtonInterceptor.add(myInterceptor);
  }

  bool myInterceptor(bool stopDefaultButtonEvent) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Connexion()));
    //navigatorKey.currentState.pushNamed("/connexion"); // Do some stuff.
    return true;
  }

  void checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      //print("Connected to Mobile");
      setState(() {
        isLoding = true;
      });
      makeLogin();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Connexion(_code)));
      setState(() {
        isLoding = true;
      });
      makeLogin();
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
          content: const Text('Vérifier votre connexion internet.'),
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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    _userTextController.dispose();
    //BackButtonInterceptor.remove(myInterceptor);
  }

  @override
  didPopRoute(){
    bool override;
    if(isBackButtonActivated)
      override = false;
    else
      override = true;
    return new Future<bool>.value(override);
  }

  void _toggleVisibility(){
    setState((){
      _isHidden = !_isHidden;
    });
  }

  Future<Login> makeLogin() async {
    _username = this._username;
    _password = this._password;
    print('Username: $_username');
    print('Password: $_password');
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    var headers = {
      "Accept": "application/json",
      "Authorization": "Basic $credentials"
    };
    var url = this._url;
    http.Response response = await http.get(url, headers: headers);
    final int statusCode = response.statusCode;
    print("${response.body}");
    if(statusCode == 200){
      var responseJson = json.decode(response.body);
      if(responseJson['id'] == 0){
        setState(() {
          isLoding = false;
        });
        showInSnackBar("Mot de passe incorrect!");
      }else{
        List data = responseJson['customValues'];
        _nom = responseJson['name'];
        print("Nom: $_nom");
        for(int i=0; i<data.length;i++){
          if(data[i]['internalName'] == "city"){
            _ville = data[i]['value'];
          }else if(data[i]['internalName'] == "address"){
            _quartier = data[i]['value'];
          }
        }
        this._reg();
        setState(() {
          isLoding = false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Profile('')));
        //navigatorKey.currentState.pushNamed("/profile");
      }
    }else{
      setState(() {
        isLoding = false;
      });
      showInSnackBar("${json.decode(response.body)}");
    }
    //var responseJson = json.decode(response.body);
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


  //final navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final espace = (MediaQuery.of(context).size.height - 533.3333333333334)<=0?0.0:MediaQuery.of(context).size.height - 533.3333333333334;
    return MaterialApp(
      /*navigatorKey: navigatorKey,
      routes: <String, WidgetBuilder>{
        "/verification": (BuildContext context) =>new Verification1(''),
        "/inscription": (BuildContext context) =>new Inscription(),
        "/profile": (BuildContext context) =>new Profile(''),
        "/connexion": (BuildContext context) =>new Connexion()
      },*/
      theme: ThemeData(primaryColor: Colors.white, accentColor: Color(0xFF2A2A42), fontFamily: 'Poppins'),
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(55.0),
          child: new AppBar(
            elevation: 0.0,
            backgroundColor: couleur_appbar,
            flexibleSpace: barreTop,
            iconTheme: new IconThemeData(color: couleur_fond_bouton),
            leading: GestureDetector(
                onTap: (){
                  setState(() {
                    //navigatorKey.currentState.pushNamed("/connexion");
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Connexion()));
                  });
                },
                child: Icon(Icons.arrow_back_ios,color: couleur_fond_bouton,)
            ),
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
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: marge_apres_description_page),
                        child: Container(
                          margin: EdgeInsets.only(top: 0.0),
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                            color: Colors.transparent,
                            border: Border.all(
                              width: bordure,
                              color: couleur_bordure
                            ),
                          ),
                          height: hauteur_champ,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex:2,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: new Image.asset('images/Trace943.png'),
                                ),
                              ),
                              new Expanded(
                                flex:10,
                                //child: Padding(

                                  child: new TextFormField(
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                        fontSize: taille_libelle_champ+ad,
                                        color: couleur_libelle_champ
                                    ),
                                    validator: (String value){
                                      if(value.isEmpty){
                                        return 'Champ mot de passe vide !';
                                      }else{
                                        _password = value;
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration.collapsed(
                                      hintText: 'Mot de passe',
                                      hintStyle: TextStyle(color: couleur_libelle_champ,
                                      fontSize: taille_libelle_champ+ad),
                                      //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                    ),
                                    obscureText: _isHidden,
                                    /*textAlign: TextAlign.end,*/
                                  ),
                                //),
                              ),
                              Expanded(
                                flex:2,
                                child: new IconButton(
                                  onPressed: _toggleVisibility,
                                  icon: _isHidden? new Icon(Icons.visibility_off,):new Icon(Icons.visibility,),
                                  color: couleur_bordure,
                                  iconSize: 20.0,
                                ),
                              ),
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
                              checkConnection();
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
                          child: new Center(child: isLoding==false?new Text('Connexion', style: new TextStyle(fontSize: taille_text_bouton+ad, color: couleur_text_bouton),):
                          CupertinoActivityIndicator(),),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top:25.0),
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            showInSnackBar("Pas encore disponible");
                            //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Verification1('')));
                          });
                        },
                        child: Text("Mot de passe oublié ?",
                          style: TextStyle(
                              color: couleur_fond_bouton,
                              fontSize: taille_champ+ad,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top:20.0),
                      child: GestureDetector(
                          onTap: (){
                            showInSnackBar("Pas encore disponible");
                            //navigatorKey.currentState.pushNamed("/verification");
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

  _lect() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username')!=null?prefs.getString('username'):"";
    });
    print(_username);
  }

  void _reg() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('nom', "$_nom");
    prefs.setString('ville', "$_ville");
    prefs.setString('quartier', "$_quartier");
    prefs.setString('password', "$_password");
  }
}