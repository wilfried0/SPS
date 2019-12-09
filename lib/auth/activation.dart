import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:services/auth/connexion.dart';
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

  String url, secretCode;
  String  idUser, spsTransactionId;
  String  code, _text1, _text2, text1, text2, text, textID, _text, iso="+237";
  bool _enable;
  var _userTextController = new TextEditingController();
  int ad = 3;

  var _header = {
    "content-type": "application/json",
    "accept": "application/json"
  };
  var _formKey2 = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
      _enable = true;
      idUser = "";
      phone = "";
      _text = "Veuillez renseigner le code d'activation envoyé à votre numéro de téléphone";
      textID = "ID de l'utilisateur vide !";
      _text1 = "Code d'activation vide !";
      _text2 = 'Définir un code secret (4 caractères)';
      text1 = "";
      text2 = '';
      text = 'Activation du compte';
  }

  @override
  void dispose() {
    _userTextController.dispose();
    super.dispose();
  }

  Future<String> createPost(var body) async {
    return await http.post(url, body: body, headers: _header, encoding: Encoding.getByName("utf-8")).then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        print(statusCode);
        throw new Exception("Error while fetching data");
      }else if(statusCode == 200){
        Post.fromJson(json.decode(response.body));
        //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child:  Activer(_code)));
      }
      return response.body;
    });
  }
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
                    padding: EdgeInsets.only(top: _enable==false?marge_apres_titre:0),),

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
                              child: new Image.asset('images/Trace943.png'),
                            ),
                          ),

                          new Expanded(
                            flex:10,
                            child: new TextFormField(
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
                        Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Inscrip()));
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
                        child: Center(child: new Text("Activer mon compte", style: new TextStyle(fontSize: taille_text_bouton+ad, color: Colors.white),)),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top:20.0),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Connexion()));
                          //Navigator.of(context).push(SlideLeftRoute(enterWidget: Connexion(_code), oldWidget: Inscription(_code)));
                        });
                        //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Connexion(_code)));
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
            fontSize: taille_description_champ
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
                    url = "$base_url/user/Auth/resendCode/$tel";
                    var response = await http.get(url);
                    print(url);
                    print(response.body);
                      if(response.statusCode == 200){
                        setState(() {
                          //idUser = response.body.toString().split(',')[4].split(':')[1].substring(0, response.body.toString().split(',')[4].split(':')[1].length-2);
                          print('idUser $idUser');
                          _userTextController.text = idUser;
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

  void _save(String valeur) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'paiement';
    final value = valeur;
    prefs.setString(key, value);
  }
}