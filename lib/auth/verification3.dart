import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:services/composants/components.dart';
import 'package:services/paiement/transfert22.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'connexion.dart';

// ignore: must_be_immutable
class Verification3 extends StatefulWidget {

  Verification3(this._code);
  String _code;

  @override
  _Verification3State createState() => new _Verification3State(_code);
}

class _Verification3State extends State<Verification3> {

  _Verification3State(this._code);
  var client;
  bool isLoading = false;
  var completer;
  String _code, news, old, _url, _username, _password, code;
  var _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState(){
    super.initState();
    this.read();
    _url = '$base_url/user/resetPassword/';
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

  void checkConnection(var body) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        isLoading = true;
      });
      changePass(body);
    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        isLoading = true;
      });
      changePass(body);
    } else {
      _ackAlert(context);
    }
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      code = prefs.getString("code");
    });
  }

  @override
  Widget build(BuildContext context) {
    final marge = (14*MediaQuery.of(context).size.width)/414;
    final espace = (MediaQuery.of(context).size.height - 533.3333333333334)<0?0.0:MediaQuery.of(context).size.height - 533.3333333333334;
    final pas = (MediaQuery.of(context).size.height - 533.3333333333334)<0?0.0:42.0;

    //double sp = MediaQuery.of(context).size.height;
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
                      child: new Text("Etape 2 sur 2",
                          style: TextStyle(
                              color: couleur_libelle_etape,
                              fontSize: taille_libelle_etape,
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
                          fontSize: taille_champ+2,
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
                              child: new Icon(Icons.vpn_key, color: couleur_description_champ,),
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
                                    fontSize: taille_champ+3,
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
                                      fontSize: taille_champ+3,
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
                              child: new Icon(Icons.vpn_key, color: couleur_description_champ,),
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
                                    fontSize: taille_champ+3,
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
                                      fontSize: taille_champ+3,
                                  ),
                                  //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                ),
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
                            if(old != news){
                              showInSnackBar("Les mots de passe sont différents", _scaffoldKey);
                            }else{
                              var findUser = new FindUser(
                                  keyword: code
                              );
                              print(json.encode(findUser));
                              checkConnection(json.encode(findUser));
                            }
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
                        child: Center(child:isLoading==false? new Text('Actualiser mon mot de passe', style: new TextStyle(fontSize: taille_champ+3, color: Colors.white),):CupertinoActivityIndicator()),
                      ),
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

  Future<void> changePass(var body) async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString("username");
    _password = news;
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse(_url));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json');
    request.headers.set('Authorization', 'Basic $credentials');
    request.write(body);
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print("statusCode ${response.statusCode}");
    print("body $reply");
      if (response.statusCode < 200 || json == null) {
        setState(() {
          isLoading = false;
        });
        throw new Exception("Error while fetching data");
      }else if(response.statusCode == 200){
        var responseJson = json.decode(reply);
        print(responseJson['result']);
        setState(() {
          isLoading = false;
        });
        if(responseJson['code'] == 200){
          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Connexion()));
        }else{
          showInSnackBar("Erreur lors de la mise à jour du mot de passe", _scaffoldKey);
        }
      }else {
        setState(() {
          isLoading = false;
        });
        showInSnackBar("Echec de l'opération!", _scaffoldKey);
      }
      return null;
  }
}

void showInSnackBar(String value, GlobalKey<ScaffoldState> _scaffoldKey) {
  _scaffoldKey.currentState.showSnackBar(
      new SnackBar(content: new Text(value,style:
      TextStyle(
          color: Colors.white,
          fontSize: taille_description_champ+3
      ),
        textAlign: TextAlign.center,),
        backgroundColor: couleur_fond_bouton,
        duration: Duration(seconds: 5),));
}