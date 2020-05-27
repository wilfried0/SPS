import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:services/auth/connexion1.dart';
import 'package:services/auth/verification3.dart';
import 'package:services/composants/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class Verification2 extends StatefulWidget {

  Verification2();

  @override
  _Verification2State createState() => new _Verification2State();
}

class _Verification2State extends State<Verification2> {

  _Verification2State();

  var _formKey = GlobalKey<FormState>();
  bool isLoading = false, isResend = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String code, _username, _urlc;

  @override
  void initState(){
    super.initState();
    this._lect();
    _urlc = '$base_url/user/resendCode/';
  }

  void _reg() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('code', "$code");
    print("code: $code");
  }

  _lect() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username')!=null?prefs.getString('username'):"";
    });
    print(_username);
  }

  Future<void> getCode() async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    String url = "${this._urlc}$_username";
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.set('Accept', 'application/json');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    if(response.statusCode == 200){//
      setState(() {
        isResend = false;
      });
      showInSnackBar("Patientez un instant!");
    }else{
      setState(() {
        isResend = false;
      });
      showInSnackBar("Service indisponible! Réessayez plus tard.");
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

  void checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        isResend = true;
      });
      getCode();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        isResend = true;
      });
      getCode();
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
  Widget build(BuildContext context) {
    final espace = (MediaQuery.of(context).size.height - 533.3333333333334)<0?0.0:MediaQuery.of(context).size.height - 533.3333333333334;
    final pas = (MediaQuery.of(context).size.height - 533.3333333333334)<0?0.0:42.0;
    return new Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: new AppBar(
          elevation: 0.0,
          backgroundColor: couleur_appbar,
          flexibleSpace: barreTop,
          leading: IconButton(
              onPressed: (){
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Connexion1()));
              },
              icon: Icon(Icons.arrow_back_ios,color: couleur_fond_bouton,)
          ),
          //iconTheme: new IconThemeData(color: bleu_F),
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
                      padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                      child: new Image.asset('images/logo.png'),
                    ),
                  ),

                  Padding(
                      padding: EdgeInsets.only(top:espace/2,)),

                  Padding(
                    padding: EdgeInsets.only(left: 20.0,),
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
                      child: new Text("Etape 1 sur 2",
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
                    padding: EdgeInsets.only(left:20.0, right:20.0),
                    child: new Text("Veuillez saisir le code de récupération qui vous a été envoyé par SMS à votre numéro de téléphone",
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
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
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
                            flex:2,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: new Icon(Icons.lock, color: couleur_description_champ,),
                            ),
                          ),

                          new Expanded(
                            flex:10,
                            child: new TextFormField(
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                  color: couleur_libelle_champ,
                                  fontSize: taille_champ+3,
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return "Code de récupération vide !";
                                }
                                code = value;
                                return null;
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: "Code de récupération reçu",
                                hintStyle: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize: taille_champ+3,
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
                    padding: EdgeInsets.only(top: pas/2),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          if(_formKey.currentState.validate()){
                            _reg();
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Verification3('')));
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
                        child: Center(child:isLoading ==false? new Text("Valider", style: new TextStyle(fontSize: taille_champ+3, color: Colors.white),):CupertinoActivityIndicator()),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left:20.0, right:20.0, top: 20),
                    child: new Text("Vous n'avez toujours pas reçu de code ?",
                      style: TextStyle(
                          color: couleur_decription_page,
                          fontSize: taille_champ+2,
                      ),),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: pas/2),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          checkConnection();
                        });
                      },
                      child: Center(child:isResend==false? new Text("Renvoyer le code", style: new TextStyle(fontSize: taille_champ+3, color: couleur_fond_bouton, fontWeight: FontWeight.bold),):CupertinoActivityIndicator()),
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