import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:services/composants/components.dart';
import 'package:services/composants/services.dart';
import 'inscription.dart';
import 'profile.dart';
import 'verification1.dart';
import 'pays.dart';
import 'package:page_transition/page_transition.dart';
import 'activation.dart';
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
  String _username, _password, _url, _token, _route, _user, _mySelection;

  var _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isHidden = true, isLoding =false, _check=false;
  var _userTextController = new TextEditingController();

  @override
  void initState(){
    this._username = "";
    this._password = "";
    this._lect();
    this.read();
    print('route: $_route');
    _url = '$base_url/user/Auth/signin';
    super.initState();
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
    super.dispose();
    _userTextController.dispose();
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

    if(statusCode == 200){
      var responseJson = json.decode(response.body);
      _token = responseJson['token'];
      save('${responseJson['idUser']}');
      _save(_token);
      if(_check == true) _reg(_user);
      setState(() {
        isLoding = false;
      });

    }else if(statusCode == 401){
      makeLogin();
    }else if(statusCode == 403){
      print(response.body);
      setState(() {
        isLoding = false;
      });
      var responseJson = json.decode(response.body);
      if(responseJson['error'].contains("not found"))
        this.showInSnackBar("Utilisateur +$_username n'a pas de compte!");
      else if(responseJson['error'].contains("already connected"))
        this.showInSnackBar("Utilisateur +$_username est déjà connecté via un autre appareil!");
      else {
        var responseJson = json.decode(response.body);
        this.showInSnackBar(responseJson['error']);
      }
      //Timer(Duration(seconds: 5), onDoneLoading);
    }else if(statusCode == 500){
      setState(() {
        isLoding = false;
      });
      this.showInSnackBar("Utilisateur ou Mot de passe incorrect");
    }
    else{
      print(statusCode);
      setState(() {
        isLoding = false;
      });
      throw new Exception("Erreur lors de la récupération des données.");
    }
    //var responseJson = json.decode(response.body);
    return null;
  }

  onDoneLoading() async {
    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Cagnotte('')));
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text(value,style:
        TextStyle(
            color: Colors.white,
            fontSize: taille_description_champ
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

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final espace = (MediaQuery.of(context).size.height - 533.3333333333334)<=0?0.0:MediaQuery.of(context).size.height - 533.3333333333334;
    return new Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: new AppBar(
          elevation: 0.0,
          backgroundColor: couleur_appbar,
          flexibleSpace: barreTop,
          leading: GestureDetector(
              onTap: (){
                setState(() {
                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Pays()));
                  //Navigator.of(context).push(SlideLeftRoute(enterWidget: Pays(), oldWidget: Connexion(_code)));
                });
                //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Pays()));
              },
              child: Icon(Icons.arrow_back_ios,)),
          iconTheme: new IconThemeData(color: couleur_fond_bouton),
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
                        child: new Text('Bienvenue sur\nSprint Pay',
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
                        child: new Text("Première plateforme d'interopérabilité des services financiers",
                          style: TextStyle(
                              color: couleur_decription_page,
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
                            ),
                          color: Colors.transparent,
                          border: Border.all(
                            color: couleur_bordure,
                            width: bordure
                          ),
                        ),
                        height: hauteur_champ,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                flex: 5,
                                child: CountryCodePicker(
                                  showFlag: true,
                                  onChanged: (CountryCode code){
                                    _mySelection = code.dialCode.toString();
                                  },
                                )
                            ),
                            new Expanded(
                              flex:10,
                              child: new TextFormField(
                                controller: _userTextController,
                                keyboardType: TextInputType.phone,
                                style: TextStyle(
                                    fontSize: taille_libelle_champ,
                                    color: couleur_libelle_champ,
                                ),
                                validator: (String value){
                                  if(value.isEmpty){
                                    return 'Champ téléphone vide !';
                                  }else{
                                    _username = _mySelection.substring(1)+value;
                                    _user = value;
                                    _userTextController.text = value;
                                    return null;
                                  }
                                },
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Numéro de téléphone',
                                  hintStyle: TextStyle(
                                      fontSize: taille_libelle_champ,
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
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Container(
                        margin: EdgeInsets.only(top: 0.0),
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
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
                                      fontSize: taille_libelle_champ,
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
                                    fontSize: taille_libelle_champ),
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
                            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Profile('')));
                            if(_formKey.currentState.validate()){
                              if(tryParse('$_username')==false){
                              showInSnackBar("Numéro de téléphone +$_username invalide!");
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
                          child: new Center(child: isLoding==false?new Text('Connexion', style: new TextStyle(fontSize: taille_text_bouton, color: couleur_text_bouton),):
                          CupertinoActivityIndicator(),),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 20),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.center,  1fcc2ec18bc30a725c0dab9970d02291758426dc
                        children: <Widget>[
                          Checkbox(
                              activeColor: couleur_fond_bouton,
                              value: _check,
                              onChanged: (bool val){
                                setState(() {
                                  _check = val;
                                });
                              }
                          ),
                          Text("Se souvenir de mon identifiant",style: TextStyle(
                              color: couleur_description_champ,
                              fontSize: taille_description_champ,
                              fontWeight: FontWeight.normal
                          ),),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top:0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Vous êtes nouveau?",
                          style: TextStyle(
                            color: couleur_description_champ,
                            fontSize: taille_description_champ,
                          ),
                          ),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Inscription()));
                                //Navigator.of(context).push(SlideLeftRoute(enterWidget: Inscription(_code), oldWidget: Connexion(_code)));
                              });
                              //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Inscription(_code)));
                            },
                            child: Text(" Inscrivez-vous !",
                              style: TextStyle(
                                  color: couleur_fond_bouton,
                                  fontSize: taille_description_champ,
                                  fontWeight: FontWeight.bold
                              ),
                              ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:15.0),
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Verification1('')));
                            //Navigator.of(context).push(SlideLeftRoute(enterWidget: Verification3(_code), oldWidget: Connexion(_code)));
                          });
                          //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Verification1(_code)));
                        },
                        child: Text("Mot de passe oublié ?",
                          style: TextStyle(
                              color: couleur_fond_bouton,
                              fontSize: taille_description_champ,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top:17.0),
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Activation()));
                            //Navigator.of(context).push(SlideLeftRoute(enterWidget: Activation('$_code^'), oldWidget: Inscription('$_code^')));
                          });
                          //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Verification1(_code)));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Code d'activation reçu?",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: taille_description_champ,
                              ),
                            ),
                            Text(" Valider mon compte",
                              style: TextStyle(
                                  color:couleur_fond_bouton,
                                  fontSize: taille_description_champ,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        )
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ),
      bottomNavigationBar: barreBottom,
    );
  }

  void _save(String _token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'monToken';
    final value = '$_token';
    prefs.setString(key, value);
    print('saved $value');
  }

  void save(String idUser) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'idUser';
    final value = '$idUser';
    prefs.setString(key, value);
    print('saved $value');
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final key = 'route';
      _route = prefs.getString(key);
    });
  }

  void enreg() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'route';
    final value = "";
    prefs.setString(key, value);
  }

  void _reg(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'username';
    final value = "$username";
    prefs.setString(key, value);
  }

  _lect() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final key = 'username';
      _user = prefs.getString(key)!=null?prefs.getString(key):"";
      _userTextController.text ="$_user";
    });
  }
}