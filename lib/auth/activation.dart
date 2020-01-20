import 'package:connectivity/connectivity.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:services/auth/inscrip.dart';
import 'package:services/composants/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:services/composants/components.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: must_be_immutable
class Activation extends StatefulWidget {

  Activation();

  @override
  _ActivationState createState() => new _ActivationState();
}

class _ActivationState extends State<Activation> {

  _ActivationState();
  String phone;
  var _formKey = GlobalKey<FormState>();
  String url, secretCode, idUser;
  String  spsTransactionId;
  String  code, text, textID, _text,_text1, iso="+237", _username;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int ad = 3;
  bool isLoding = false, isResend = false;
  var _formKey2 = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    this.lire();
    url = '$base_url/member/activate';
    phone = "";
    code = "";
    _text = "Veuillez renseigner le code d'activation envoyé à votre numéro de téléphone";
    textID = "ID de l'utilisateur vide !";
    _text1 = "Code d'activation vide !";
    text = 'Activation du compte';
  }

  lire() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      idUser = prefs.getString("idUser");
      _username = prefs.getString("username");
      print(idUser);
    });
  }

  void checkConnection(int q) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      //print("Connected to Mobile");
      if(q == 0) {
        setState(() {
          isLoding = true;
        });
        this.getUser();
      }else {
        setState(() {
          isResend = true;
        });
        this.resendCode();
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Connexion(_code)));
      if(q == 0) {
        setState(() {
          isLoding = true;
        });
        this.getUser();
      }else{
        setState(() {
          isResend = true;
        });
        this.resendCode();
      }
    } else {
      _ackAlert(context);
    }
  }

  Future<Login> getUser() async {
    var headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    var _url = "$url/$idUser/$code";
    print(_url);
    http.Response response = await http.get(_url, headers: headers);
    final int statusCode = response.statusCode;
    print(statusCode);
    if(statusCode == 200){
      var responseJson = json.decode(response.body);
      print(responseJson);
      setState(() {
        isLoding = false;
      });
      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Inscrip()));
    }else{
      setState(() {
        isLoding = false;
      });
      showInSnackBar("veuillez vérifier votre code d'activation!");
      //throw new Exception(response.body);
    }
    return null;
  }

  Future<Login> resendCode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString("username");
      print(_username);
    });
    var headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    var _url = "$base_url/member/resendCode/$_username";
    print("mon url $_url");
    http.Response response = await http.get(_url, headers: headers);
    final int statusCode = response.statusCode;
    print(statusCode);
    print(response.body);
    if(statusCode == 200){
      var responseJson = json.decode(response.body);
      print(responseJson);
      setState(() {
        isResend = false;
      });
    }else{
      setState(() {
        isResend = false;
      });
      showInSnackBar("veuillez vérifier votre code d'activation!");
      //throw new Exception(response.body);
    }
    return null;
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
                });
                Navigator.pop(context);
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
                      padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                      child: new Image.asset('images/logo.png'),
                    ),
                  ),

                  Padding(
                      padding: EdgeInsets.only(top:espace/2,)),
                  Padding(
                    padding: EdgeInsets.only(top:marge_apres_logo),),

                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right:20.0, bottom: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: new Text(text,
                          style: TextStyle(
                              color: couleur_titre,
                              fontSize: taille_titre,
                              fontWeight: FontWeight.bold
                          )),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left:20.0, right: 20.0),
                    child: new Text(_text,
                      style: TextStyle(
                        color: couleur_decription_page,
                        fontSize: taille_description_champ+ad,
                      ),),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top:marge_apres_description_page),),

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
                          new Expanded(
                            flex:2,
                            child: Padding(
                              padding: const EdgeInsets.only(top:10.0, bottom: 10.0),
                              child: Icon(Icons.lock, color: couleur_description_champ,),
                            ),
                          ),

                          new Expanded(
                            flex:10,
                            child: new TextFormField(
                              //controller: _codeTextController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                color: couleur_libelle_champ,
                                fontSize: taille_champ+ad,
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return _text1;
                                }else{
                                  code = value;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(hintText: "Code d'activation"
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),


                  Padding(
                    padding: EdgeInsets.only(top: pas/2),
                    child: new GestureDetector(
                      onTap: () {
                        if(_formKey.currentState.validate()) {
                          checkConnection(0);
                        }
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
                        child: Center(
                            child:isLoding==false? new Text("Activer mon compte", style: new TextStyle(fontSize: taille_text_bouton+ad, color: Colors.white),):
                                CupertinoActivityIndicator()
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top:20.0),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          showInSnackBar("Pas encore disponible");
                        });
                      },
                      child: Text('Contactez-nous',
                        style: TextStyle(
                            color: couleur_fond_bouton,
                            fontSize: taille_champ+ad,
                            fontWeight: FontWeight.bold
                        ),textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top:20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Code non reçu ? ',
                          style: TextStyle(
                              color: couleur_libelle_champ,
                              fontSize: taille_champ+ad,
                              fontWeight: FontWeight.normal
                          ),textAlign: TextAlign.center,
                        ),

                        GestureDetector(
                          onTap: (){
                            setState(() {
                              checkConnection(1);
                            });
                          },
                          child:isResend == false? Text('Redemander le code',
                            style: TextStyle(
                                color: couleur_fond_bouton,
                                fontSize: taille_champ+ad,
                                fontWeight: FontWeight.bold
                            ),textAlign: TextAlign.center,
                          ):CupertinoActivityIndicator(),
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

  Future<void> ackAlert(BuildContext context, String text) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: _formKey2,
          child: AlertDialog(
            title: Row(
              children: <Widget>[
                Icon(Icons.fingerprint,color: couleur_fond_bouton,),
                Text("Demande du code!", style: TextStyle(
                    fontSize: taille_libelle_etape,
                    color: couleur_fond_bouton
                ),),
              ],
            ),
            content: Column(
              children: <Widget>[
                Text(text,
                  style: TextStyle(
                    fontSize: taille_champ,
                  ),
                  textAlign: TextAlign.justify,),
                Row(
                  children: <Widget>[
                    Expanded(
                        flex: 4,
                        child: CountryCodePicker(
                          showFlag: true,
                          onChanged: (CountryCode code){
                            iso = code.toString();
                          },
                        )
                    ),
                    Expanded(
                      flex: 8,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: taille_libelle_champ,
                          color: couleur_libelle_champ,
                        ),
                        validator: (String value){
                          if(value.isEmpty){
                            return "Téléphone vide!";
                          }else{
                            phone = value;
                            return null;
                          }
                        },
                        decoration: InputDecoration.collapsed(
                          hintText: 'téléphone',
                          hintStyle: TextStyle(
                              fontSize: taille_libelle_champ,
                              color: couleur_libelle_champ,
                              fontWeight: FontWeight.bold
                          ),
                          //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Valider'),
                onPressed: () async {
                  if(_formKey2.currentState.validate()) {
                    String tel = "${iso.substring(1, iso.length)}$phone";
                    url = "$base_url/member/user/Auth/resendCode/$tel";
                    var response = await http.get(url);
                    print(url);
                    print(response.body);
                    if(response.statusCode == 200){
                      setState(() {
                        //idUser = response.body.toString().split(',')[4].split(':')[1].substring(0, response.body.toString().split(',')[4].split(':')[1].length-2);
                        print('idUser $idUser');
                      });
                      Navigator.of(context).pop();
                    }else{
                      Navigator.of(context).pop();
                      setState(() {
                        showInSnackBar(response.body);
                      });
                    }
                  }
                },
              ),

              FlatButton(
                child: Text('Annuler'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}