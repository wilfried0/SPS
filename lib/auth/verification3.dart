import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:services/composants/components.dart';
import 'package:services/composants/services.dart';

import 'connexion.dart';
import 'modifier.dart';

// ignore: must_be_immutable
class Verification3 extends StatefulWidget {

  Verification3(this._code);
  String _code;

  @override
  _Verification3State createState() => new _Verification3State(_code);
}

class _Verification3State extends State<Verification3> {
  var client;

  var completer;


  _Verification3State(this._code);
  String _code, _token, news, old, _url;

  var _formKey = GlobalKey<FormState>();
  bool _isHidden = true;

  @override
  void initState(){
    super.initState();
    _url = '$base_url/user/Auth/resetPassword/';
    print(_code.split(' ').length);
    if(_code.split(' ').length == 5){
      _token = _code.split(' ')[4];
      print('le token $_token');
    }
      //_code.split(':')[2];
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

  Future<void> ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Echec connexion!',style: TextStyle(
            color: couleur_fond_bouton
          ),),
          content: const Text('Désolé vous devez être connecté pour modifier votre mot de passe'),
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

  void checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      makeLogin();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      makeLogin();
    } else {
      _ackAlert(context);
    }
  }

  Future<Login> makeLogin() async {
    news = this.news;
    old = this.old;

    var headers = {
      "Accept": "application/json",
      "Authorization": "Bearer $_token"
    };

    if(_url.endsWith('/'))
    _url = '$_url$old/$news';
    print(_url);
    final response = await http.get(_url, headers: headers,);
    final int statusCode = response.statusCode;
    final responseJson = json.decode(response.body);
    if(statusCode == 200){
      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Modifier(_code)));
      //Navigator.of(context).push(SlideLeftRoute(enterWidget: Modifier(_code), oldWidget: Verification3(_code)));
    }else{
      throw new Exception("Erreur lors de la récupération des données.");
    }
    return Login.fromJson(responseJson);
  }

  @override
  Widget build(BuildContext context) {
    final marge = (14*MediaQuery.of(context).size.width)/414;
    final espace = (MediaQuery.of(context).size.height - 533.3333333333334)<0?0.0:MediaQuery.of(context).size.height - 533.3333333333334;
    final pas = (MediaQuery.of(context).size.height - 533.3333333333334)<0?0.0:42.0;

    //double sp = MediaQuery.of(context).size.height;
    return new Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: new AppBar(
          elevation: 0.0,
          backgroundColor: couleur_appbar,
          flexibleSpace: barreTop,

          leading: GestureDetector(
              onTap: (){
                setState(() {
                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Connexion()));
                  //Navigator.of(context).push(SlideLeftRoute(enterWidget: Connexion(_code), oldWidget: Verification3(_code)));
                });
                //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Verification2(_code)));
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
                      padding: const EdgeInsets.only(top: 0.0, left: 40.0, right: 40.0),
                      child: new Image.asset('images/logo.png'),
                    ),
                  ),

                  Padding(
                      padding: EdgeInsets.only(top:espace/2,)),

                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: new Text("Mot de passe oublié ?",
                          style: TextStyle(
                              color: couleur_titre,
                              fontSize: taille_titre,
                              fontFamily: police_titre,
                              fontWeight: FontWeight.bold
                          )),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: marge_libelle_champ),),

                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: new Text("Etape 3 sur 3",
                          style: TextStyle(
                              color: couleur_libelle_etape,
                              fontSize: taille_libelle_etape,
                              fontFamily: police_libelle_etape,
                              fontWeight: FontWeight.bold
                          )),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: marge_champ_libelle),),

                  Padding(
                    padding: EdgeInsets.only(left:20.0, right: 20.0),
                    child: new Text("Maintenant que c'est fait, vous pouvez réinitialiser votre mot de passe pour vos prochaines sessions.",
                      style: TextStyle(
                          color: couleur_decription_page,
                          fontSize: taille_description_page,
                          fontFamily: police_description_page
                      ),textAlign: TextAlign.justify,),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: marge_libelle_champ),),

                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Container(
                      margin: EdgeInsets.only(top: 0.0),
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
                          new Expanded(
                            flex:2,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: new Image.asset('images/Groupe180.png'),
                            ),
                          ),
                          new Expanded(
                            flex:10,
                            child: Padding(
                              padding: EdgeInsets.only(left:marge),
                              child: new TextFormField(
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize: taille_champ,
                                    fontFamily: police_champ
                                ),
                                validator: (String value){
                                  if(value.isEmpty){
                                    return 'nouveau mot de passe vide !';
                                  }else{
                                    old = value;
                                    return null;
                                  }
                                },
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Nouveau mot de passe',
                                  hintStyle: TextStyle(
                                      color: couleur_libelle_champ,
                                      fontSize: taille_champ,
                                      fontFamily: police_champ
                                  ),
                                  //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                ),
                                //obscureText: !_isHidden,
                                /*textAlign: TextAlign.end,*/
                              ),
                            ),
                          ),
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
                            color: couleur_bordure,
                            width: bordure
                        ),
                      ),
                      height: 50.0,
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                            flex:2,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: new Image.asset('images/Groupe180.png'),
                            ),
                          ),
                          new Expanded(
                            flex:10,
                            child: Padding(
                              padding: EdgeInsets.only(left:marge),
                              child: new TextFormField(
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize: taille_champ,
                                    fontFamily: police_champ
                                ),
                                validator: (String value){
                                  if(value.isEmpty){
                                    return 'Vérification du nouveau mot de passe vide !';
                                  }else{
                                    news = value;
                                    return null;
                                  }
                                },
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Vérification du nouveau mot de passe',
                                  hintStyle: TextStyle(
                                      color: couleur_libelle_champ,
                                      fontSize: taille_champ,
                                      fontFamily: police_champ
                                  ),
                                  //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                ),
                                obscureText: !_isHidden,
                                /*textAlign: TextAlign.end,*/
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: pas/2),
                    child: new GestureDetector(
                      onTap: (){
                        setState(() {
                          print(_code);
                          if(_formKey.currentState.validate()){
                            if(_token == null){
                              ackAlert(context);
                            }else
                            checkConnection();
                          }
                        });
                      },
                      child: new Container(
                        height: hauteur_champ,
                        width: MediaQuery.of(context).size.width-40,
                        decoration: new BoxDecoration(
                          color: couleur_fond_bouton,
                          border: new Border.all(
                            color: Colors.transparent,
                            width: 0.0,
                          ),
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        child: Center(child: new Text('Modifier mon mot de passe', style: new TextStyle(fontSize: taille_text_bouton, color: Colors.white, fontFamily: police_bouton),)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Vous avez déjà un compte ? ",
                          style: TextStyle(
                              color: couleur_decription_page,
                              fontSize: taille_description_champ,
                              fontFamily: police_description_champ
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Connexion()));
                            });
                            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Connexion(_code)));
                          },
                          child: Text("Connectez-vous !",
                            style: TextStyle(
                                color: couleur_fond_bouton,
                                fontSize: taille_description_champ,
                                fontFamily: police_description_champ,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top:20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Vous n'avez pas de compte ? ",
                          style: TextStyle(
                              color: couleur_decription_page,
                              fontSize: taille_description_champ,
                              fontFamily: police_description_champ
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Connexion()));
                            });
                            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Connexion(_code)));
                          },
                          child: Text("Inscrivez-vous !",
                            style: TextStyle(
                                color: couleur_fond_bouton,
                                fontSize: taille_description_champ,
                                fontFamily: police_description_champ,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ],
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
}