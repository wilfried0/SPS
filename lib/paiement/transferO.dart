import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:services/composants/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'transfert1.dart';
import 'transfert3.dart';

// ignore: must_be_immutable
class TransfertO extends StatefulWidget {
  TransfertO(this._code);
  String _code;
  @override
  _TransfertOState createState() => new _TransfertOState(_code);
}



class _TransfertOState extends State<TransfertO> {
  double marge;
  List data;
  _TransfertOState(this._code);
  String _code;
  String _firstname, _lastname, _adresse, _ville, _name, _username;
  var _formKey = GlobalKey<FormState>(), firstController, lastController, adressController, townController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState(){
    this.read();
    super.initState();
    firstController = new TextEditingController();
    lastController = new TextEditingController();
    adressController = new TextEditingController();
    townController = new TextEditingController();
  }


  @override
  void dispose(){
    super.dispose();
    firstController.dispose();
    lastController.dispose();
    adressController.dispose();
    townController.dispose();
  }

  void _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("villef", "$_ville");
      prefs.setString("nomf", "$_lastname");
      prefs.setString("prenomf", "$_firstname");
      prefs.setString("nomd", "$_name");
    prefs.setString("adressef", "$_adresse");
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString("username");
      geUserByPhone(_username);
      if(prefs.getString("ville") != "null"){
        _ville = prefs.getString("ville");
        townController.text = _ville;
      }
      if(prefs.getString("quartier") != "null"){
        _adresse = prefs.getString("quartier");
        adressController.text = _adresse;
      }
      if(prefs.getString("prenomf") != "null"){
        _firstname = prefs.getString("prenomf");
        firstController.text = _firstname;
      }
      if(prefs.getString("adressef") != "null"){
        _adresse = prefs.getString("adressef");
        adressController.text = _adresse;
      }
    });
  }

  Future<void> geUserByPhone(String phone) async {
    print("url: $base_url/transaction/getUserByUsername/$phone");
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.getUrl(Uri.parse("$base_url/transaction/getUserByUsername/$phone"));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print("statusCode ${response.statusCode}");
    print("body $reply");
    if(response.statusCode == 200){
      var responseJson = json.decode(reply);
      setState(() {
        _lastname = responseJson['lastname'];
        lastController.text = _lastname;
        _firstname = responseJson['firstname'];
        firstController.text = _firstname;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    marge = (5*MediaQuery.of(context).size.width)/414;

    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: GRIS,
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: GRIS,
        flexibleSpace: barreTop,
        leading: IconButton(
            onPressed: (){
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfert1(_code)));
            },
            icon: Icon(Icons.arrow_back_ios,color: couleur_fond_bouton,)
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: hauteur_logo,
            child: new Image.asset('images/logo.png'),
          ),

          Padding(padding: EdgeInsets.only(top: marge_apres_logo),),

          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: new Text("Informations sur l'expéditeur",
                  style: TextStyle(
                      color: couleur_titre,
                      fontSize: taille_titre,
                      fontWeight: FontWeight.bold
                  )),
            ),
          ),

          Padding(padding: EdgeInsets.only(top: marge_apres_titre),),

          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: marge_libelle_champ),),

                Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 0.0, right: 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Veuillez écrire le nom légal complet, comme indiqué sur le passeport, permi de conduire, ou CNI (Carte Nationale d'Identité) du bénéficiaire.",
                      style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_champ+2
                      ),textAlign: TextAlign.justify,),
                  ),
                ),

                Padding(padding: EdgeInsets.only(top: marge_libelle_champ),),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 0.0),
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                      color: Colors.white,
                      border: Border.all(
                        width: bordure,
                        color: couleur_bordure,
                      ),
                    ),
                    height: hauteur_champ,
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                          flex:2,
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: new Icon(Icons.person, color: couleur_decription_page,)//Image.asset('images/Groupe177.png'),
                          ),
                        ),
                        new Expanded(
                          flex:10,
                          child: Padding(
                            padding: EdgeInsets.only(left:0.0),
                            child: new TextFormField(
                              controller: firstController,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                fontSize: taille_champ+3,
                                color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  _firstname = "";
                                  return null;
                                }else{
                                  _firstname = value;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Prénom',
                                hintStyle: TextStyle(color: couleur_libelle_champ,
                                  fontSize: taille_champ+3,
                                ),
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 0.0),
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: bordure,
                        color: couleur_bordure,
                      ),
                    ),
                    height: hauteur_champ,
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                          flex:2,
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(Icons.person, color: couleur_decription_page,)//new Image.asset('images/Groupe177.png'),
                          ),
                        ),
                        new Expanded(
                          flex:10,
                          child: Padding(
                            padding: EdgeInsets.only(left:0.0),
                            child: new TextFormField(
                              controller: lastController,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  fontSize: taille_champ+3,
                                  color: couleur_libelle_champ
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return "Champ nom vide!";
                                }else{
                                  _lastname = value;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Nom',
                                hintStyle: TextStyle(color: couleur_libelle_champ,
                                  fontSize: taille_champ+3,
                                ),
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 0.0),
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: bordure,
                        color: couleur_bordure,
                      ),
                    ),
                    height: hauteur_champ,
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                          flex:2,
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(Icons.location_on, color: couleur_decription_page,)//new Image.asset('images/Groupe177.png'),
                          ),
                        ),
                        new Expanded(
                          flex:10,
                          child: Padding(
                            padding: EdgeInsets.only(left:0.0),
                            child: new TextFormField(
                              controller: adressController,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  fontSize: taille_champ+3,
                                  color: couleur_libelle_champ
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return "Champ adresse vide!";
                                }else{
                                  _adresse = value;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Adresse',
                                hintStyle: TextStyle(color: couleur_libelle_champ,
                                  fontSize: taille_champ+3,
                                ),
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 0.0),
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                      color: Colors.white,
                      border: Border.all(
                        width: bordure,
                        color: couleur_bordure,
                      ),
                    ),
                    height: hauteur_champ,
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                          flex:2,
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(Icons.location_city, color: couleur_decription_page,)//new Image.asset('images/Groupe177.png'),
                          ),
                        ),
                        new Expanded(
                          flex:10,
                          child: Padding(
                            padding: EdgeInsets.only(left:0.0),
                            child: new TextFormField(
                              controller: townController,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  fontSize: taille_champ+3,
                                  color: couleur_libelle_champ
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return "Champ ville vide!";
                                }else{
                                  _ville = value;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Ville',
                                hintStyle: TextStyle(color: couleur_libelle_champ,
                                  fontSize: taille_champ+3,
                                ),
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: marge_champ_libelle),
                  child: InkWell(
                    onTap: () async {
                      setState(() {
                        if(_formKey.currentState.validate()){
                          _name = "$_firstname $_lastname";
                          this._save();
                          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfert3(_code)));
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
                      child: Center(child: new Text('Poursuivre', style: new TextStyle(fontSize: taille_text_bouton+3, color: Colors.white),)
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: barreBottom,
    );
  }
}