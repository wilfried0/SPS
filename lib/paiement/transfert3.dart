import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:services/composants/components.dart';
import 'package:services/composants/services.dart';

import 'confirma.dart';
import 'transfert1.dart';
import 'transfert2.dart';

// ignore: must_be_immutable
class Transfert3 extends StatefulWidget {
  Transfert3(this._code);
  String _code;
  @override
  _Transfert3State createState() => new _Transfert3State(_code);
}

Future<String> createPost(var body, var _header, String url, String _code, BuildContext context,GlobalKey<ScaffoldState> _scaffoldKey) async {
  return await http.post(url, body: body, headers: _header, encoding: Encoding.getByName("utf-8")).then((http.Response response) {
    final int statusCode = response.statusCode;
    print(statusCode);
    print(response.body);
    if (statusCode < 200 || json == null) {
      print(statusCode);
      print(response.body);
      throw new Exception("Error while fetching data");
    }else if(statusCode == 200){
      Post.fromJson(json.decode(response.body));
      String idUser = response.body.toString().split(',')[4].split(':')[1].substring(0, response.body.toString().split(',')[4].split(':')[1].length-2);
      print('idUser $idUser');
      //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Activation('$_code^$idUser')));
      //Navigator.of(context).push(SlideLeftRoute(enterWidget: Activation('$_code^$idUser'), oldWidget: Inscription('$_code^$idUser')));
    }else if(statusCode == 403){
      if(response.body.contains("EMAIL_ALREADY_USE"))
        showInSnackBar("Cette email est utilisée par un autre membre.", _scaffoldKey);
      else if(response.body.contains("USERNAME_EXIST"))
        showInSnackBar("Un utilisateur avec le même numéro de téléphone existe déjà", _scaffoldKey);
    }
    else print(statusCode);
    return response.body;
  });
}

class _Transfert3State extends State<Transfert3> {
  _Transfert3State(this._code);
  String _code;
  bool _check=false;
  String _firstname, _lastname, _email, _verfiPassword, _ville, _country, _birthday, _username, _password;
  bool boolFirstname=false, boolLastname=false, boolEmail=false, boolPassword=false, boolVille=false, boolbirthday=false, boolUsername=false;
  int choice = 0, indik;
  var _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _userTextController;
  bool _isHidden = true;
  String url;
  var _header = {
    "content-type": "application/json",
    "accept": "application/json"
  };

  @override
  void initState(){
    super.initState();
    print("hello world $_code");
    indik = int.parse(_code.split('^').last)+1;
    url = '$base_url/user/Auth/createmember';
    _userTextController = TextEditingController();
    this._country = this._code.split('^')[3];
    this._ville = 'Yaoundé';
    this._birthday = '2019-07-24';
    boolVille = true; boolbirthday = true;
  }

  @override
  void dispose() {
    _userTextController.dispose();
    super.dispose();
  }

  bool isEmail(String em) {
    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }

  @override
  Widget build(BuildContext context) {
    final marge = (5*MediaQuery.of(context).size.width)/414;

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        elevation: 0.0,
        title: Text('Vérification', style: TextStyle(
          color: couleur_description_champ,
          fontSize: taille_champ
        ),),
        backgroundColor: couleur_appbar,
        flexibleSpace: barreTop,

        leading: InkWell(
            onTap: (){
              setState(() {
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfert2(_code)));
                //Navigator.of(context).push(SlideLeftRoute(enterWidget: Connexion(_code), oldWidget: Inscription(_code)));
              });
            },
            child: Icon(Icons.arrow_back_ios,)),
        iconTheme: new IconThemeData(color: couleur_fond_bouton),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text('Transférer de l\'argent',
              style: TextStyle(
                  color: couleur_titre,
                  fontSize: taille_titre,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Text('Etape 3 sur 3',
              style: TextStyle(
                  color: couleur_libelle_etape,
                  fontSize: taille_libelle_etape,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: marge_apres_titre),),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text('Moyen vers lequel vous effectuez le transfert',
                    style: TextStyle(
                        color: couleur_titre,
                        fontSize: taille_libelle_etape,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: CarouselSlider(
                    enlargeCenterPage: true,
                    autoPlay: false,
                    enableInfiniteScroll: false,
                    onPageChanged: (value){},
                    height: 135.0,
                    items: [indik].map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return getMoyen(indik);
                        },
                      );
                    }).toList(),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Détails sur le montant',
                      style: TextStyle(
                          color: couleur_libelle_champ,
                          fontSize: taille_libelle_champ,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Divider(
                    color: couleur_champ,
                    height: 2,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 6,
                        child: Text("Montant à transférer", style: TextStyle(
                          color: couleur_libelle_champ,
                          fontSize: taille_champ
                        ),),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text("1.000,0 XAF", style: TextStyle(
                            color: couleur_fond_bouton,
                            fontSize: taille_champ,
                        ),textAlign: TextAlign.end,),
                      )
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Divider(
                    color: couleur_champ,
                    height: 2,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 6,
                        child: Text("Commission de la transaction", style: TextStyle(
                            color: couleur_libelle_champ,
                            fontSize: taille_champ
                        ),),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text("0,0 XAF", style: TextStyle(
                          color: couleur_fond_bouton,
                          fontSize: taille_champ,
                        ),textAlign: TextAlign.end,),
                      )
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Divider(
                    color: couleur_champ,
                    height: 2,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 6,
                        child: Text("Montant total à débiter", style: TextStyle(
                            color: couleur_libelle_champ,
                            fontSize: taille_champ
                        ),),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text("1.000,0 XAF", style: TextStyle(
                          color: couleur_fond_bouton,
                          fontSize: taille_champ,
                        ),textAlign: TextAlign.end,),
                      )
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Divider(
                    color: couleur_champ,
                    height: 2,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: marge_champ_libelle),),

                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Vous transférer vers',
                      style: TextStyle(
                          color: couleur_libelle_champ,
                          fontSize: taille_libelle_champ,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
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
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: new Image.asset('flags/'+_code.split('^')[1].toLowerCase()+'.png'),
                          ),
                        ),

                        Expanded(
                          flex:12,
                          child: Padding(
                              padding: const EdgeInsets.only(left:10.0,),
                              child: new Text(this._code.split('^')[2],
                                style: TextStyle(
                                  color: couleur_description_champ,
                                  fontSize: taille_champ,
                                ),)
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(padding: EdgeInsets.only(top: marge_champ_libelle),),

                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Motif de l\'opération',
                      style: TextStyle(
                          color: couleur_libelle_champ,
                          fontSize: taille_libelle_champ,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
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
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: new TextFormField(
                              enabled: false,
                              controller: _userTextController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  color: couleur_libelle_champ,
                                  fontSize: taille_champ,
                              ),
                              validator: (String value){
                                if(value.isEmpty || int.parse(value.replaceAll(".", ""))==0){
                                  return "Motif du transfert vide !";
                                }else{
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Motif',
                                hintStyle: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize: taille_champ,
                                ),
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: marge_champ_libelle),),

                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Identité & contact',
                      style: TextStyle(
                          color: couleur_libelle_champ,
                          fontSize: taille_libelle_champ,
                          fontWeight: FontWeight.bold
                      ),),
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
                      color: Colors.transparent,
                      border: Border.all(
                        width: bordure,
                        color: couleur_bordure,
                      ),
                    ),
                    height: hauteur_champ,
                    child: Row(
                      children: <Widget>[

                        new Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text("Madame/Monsieur", style: TextStyle(
                              color: couleur_libelle_champ,
                              fontSize: taille_champ
                            ),),
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
                      color: Colors.transparent,
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
                            child: new Image.asset('images/Groupe177.png'),
                          ),
                        ),
                        new Expanded(
                          flex:10,
                          child: Padding(
                            padding: EdgeInsets.only(left:0.0),
                            child: new TextFormField(
                              enabled: false,
                              controller: _userTextController,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  fontSize: taille_champ,
                                  color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return 'Champ prénom vide !';
                                }else{
                                  boolFirstname = true;
                                  _firstname = value;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Prénom',
                                hintStyle: TextStyle(color: couleur_libelle_champ,
                                  fontSize: taille_champ,
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
                      color: Colors.transparent,
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
                            child: new Image.asset('images/Groupe177.png'),
                          ),
                        ),
                        new Expanded(
                          flex:10,
                          child: Padding(
                            padding: EdgeInsets.only(left:0.0),
                            child: new TextFormField(
                              enabled: false,
                              controller: _userTextController,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  fontSize: taille_champ,
                                  color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return "Champ nom vide !";
                                }else{
                                  boolLastname = true;
                                  _lastname = value;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Nom',
                                hintStyle: TextStyle(color: couleur_libelle_champ,
                                  fontSize: taille_champ,
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
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
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
                            child: new Image.asset('images/Groupe182.png'),
                          ),
                        ),
                        Expanded(
                          flex:2,
                          child: Padding(
                              padding: const EdgeInsets.only(left:0.0,),
                              child: new Text(this._code.split('^')[0],
                                style: TextStyle(
                                  color: couleur_champ,
                                  fontSize: taille_champ,
                                ),)
                          ),
                        ),
                        new Expanded(
                          flex:8,
                          child: new TextFormField(
                            enabled: false,
                            controller: _userTextController,
                            keyboardType: TextInputType.phone,
                            style: TextStyle(
                              fontSize: taille_champ,
                              color: couleur_libelle_champ,
                            ),
                            validator: (String value){
                              if(value.isEmpty){
                                return "Champ téléphone vide !";
                              }else{
                                boolUsername = true;
                                _username = this._code.split('^')[0].substring(1)+value;
                                return null;
                              }
                            },
                            decoration: InputDecoration.collapsed(
                              hintText: 'Numéro de téléphone',
                              hintStyle: TextStyle(
                                fontSize: taille_champ,
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

                /*Padding(padding: EdgeInsets.only(top: marge_champ_libelle),),

                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Coordonnées de contact",
                      style: TextStyle(
                          color: couleur_libelle_champ,
                          fontSize: taille_libelle_champ,
                          fontWeight: FontWeight.bold
                      ),),
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
                      color: Colors.transparent,
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
                            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: new Image.asset('images/Groupe179.png'),
                          ),
                        ),
                        new Expanded(
                          flex:10,
                          child: Padding(
                            padding: EdgeInsets.only(left:0.0),
                            child: new TextFormField(
                              enabled: false,
                              controller: _userTextController,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  fontSize: taille_champ,
                                  color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return 'Adresse email vide';
                                }else if(isEmail(value) == false){
                                  return 'Adresse email invalide';
                                }else{
                                  boolEmail = true;
                                  _email = value;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Adresse email',
                                hintStyle: TextStyle(color: couleur_libelle_champ,
                                  fontSize: taille_champ,
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
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 0.0),
                    decoration: new BoxDecoration(
                      color: Colors.transparent,
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
                            child: new Image.asset('images/Groupe182.png'),
                          ),
                        ),
                        Expanded(
                          flex:2,
                          child: Padding(
                              padding: const EdgeInsets.only(left:0.0,),
                              child: new Text(this._code.split('^')[0],
                                style: TextStyle(
                                  color: couleur_champ,
                                  fontSize: taille_champ,
                                ),)
                          ),
                        ),
                        new Expanded(
                          flex:8,
                          child: new TextFormField(
                            enabled: false,
                            controller: _userTextController,
                            keyboardType: TextInputType.phone,
                            style: TextStyle(
                                fontSize: taille_champ,
                                color: couleur_libelle_champ,
                            ),
                            validator: (String value){
                              if(value.isEmpty){
                                return "Champ téléphone vide !";
                              }else{
                                boolUsername = true;
                                _username = this._code.split('^')[0].substring(1)+value;
                                return null;
                              }
                            },
                            decoration: InputDecoration.collapsed(
                              hintText: 'Numéro de téléphone',
                              hintStyle: TextStyle(
                                  fontSize: taille_champ,
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
                    child: Padding(
                      padding: EdgeInsets.only(left: marge,),
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                            flex:2,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: new Image.asset('images/Groupe18.png'),
                            ),
                          ),
                          new Expanded(
                            flex:10,
                            child: Padding(
                              padding: EdgeInsets.only(left:marge),
                              child: new TextFormField(
                                enabled: false,
                                controller: _userTextController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                    fontSize: taille_champ,
                                    color: couleur_libelle_champ,
                                ),
                                validator: (String value){
                                  if(value.isEmpty){
                                    return 'Ville de résidence vide !';
                                  }else{
                                    _password = value;
                                    return null;
                                  }
                                },
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Ville de résidence',
                                  hintStyle: TextStyle(color: couleur_libelle_champ,fontSize: taille_champ,),
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
                ),
                Padding(padding: EdgeInsets.only(top: marge_champ_libelle),),

                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Coordonnées bancaires",
                      style: TextStyle(
                          color: couleur_libelle_champ,
                          fontSize: taille_libelle_champ,
                          fontWeight: FontWeight.bold
                      ),),
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
                      color: Colors.transparent,
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
                            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: new Image.asset('images/Groupe179.png'),
                          ),
                        ),
                        new Expanded(
                          flex:10,
                          child: Padding(
                            padding: EdgeInsets.only(left:0.0),
                            child: new TextFormField(
                              enabled: false,
                              controller: _userTextController,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  fontSize: taille_champ,
                                  color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return 'Banque vide';
                                }else{
                                  boolEmail = true;
                                  _email = value;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Banque',
                                hintStyle: TextStyle(color: couleur_libelle_champ,
                                  fontSize: taille_champ,
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
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 0.0),
                    decoration: new BoxDecoration(
                      color: Colors.transparent,
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
                            child: new Image.asset('images/Groupe182.png'),
                          ),
                        ),
                        new Expanded(
                          flex:10,
                          child: new TextFormField(
                            enabled: false,
                            controller: _userTextController,
                            keyboardType: TextInputType.phone,
                            style: TextStyle(
                                fontSize: taille_champ,
                                color: couleur_libelle_champ,
                            ),
                            validator: (String value){
                              if(value.isEmpty){
                                return "Champ code agence vide !";
                              }else{
                                boolUsername = true;
                                _username = this._code.split('^')[0].substring(1)+value;
                                return null;
                              }
                            },
                            decoration: InputDecoration.collapsed(
                              hintText: 'Code agence',
                              hintStyle: TextStyle(
                                  fontSize: taille_champ,
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
                    child: Padding(
                      padding: EdgeInsets.only(left: marge,),
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                            flex:2,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: new Image.asset('images/Groupe15.png'),
                            ),
                          ),
                          new Expanded(
                            flex:10,
                            child: Padding(
                              padding: EdgeInsets.only(left:marge),
                              child: new TextFormField(
                                enabled: false,
                                controller: _userTextController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                    fontSize: taille_champ,
                                    color: couleur_libelle_champ,
                                ),
                                validator: (String value){
                                  if(value.isEmpty){
                                    return 'Numéro de compte vide!';
                                  }else{
                                    _password = value;
                                    return null;
                                  }
                                },
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Numéro de compte',
                                  hintStyle: TextStyle(color: couleur_libelle_champ, fontSize: taille_champ,),
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
                ),*/

                Padding(padding: EdgeInsets.only(top: marge_champ_libelle),),

                InkWell(
                  onTap: () async {
                    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Confirma('transfert')));
                    if (_formKey.currentState.validate()) {
                      if(_check == true){
                        if(boolFirstname==true && boolLastname==true && boolEmail==true && boolUsername==true && boolPassword==true) {
                          Role role = new Role(
                              idRole: 2,
                              roleName: "ROLE_CUSTUMER"
                          );
                          var newPost = new Post(
                              firstname: this._firstname,
                              lastname: this._lastname,
                              town:this._ville,
                              birthday:this._birthday,
                              country: this._country,
                              email:this._email,
                              username: _username,
                              password:this._password,
                              userImage: null,
                              role: role
                          );
                          //var body, var _header, String url, String _code, BuildContext context,GlobalKey<ScaffoldState> _scaffoldKey
                          FutureBuilder(
                              future: createPost(json.encode(newPost), _header, url, _code, context, _scaffoldKey),
                              builder: (context, snapshot){
                                if(snapshot.data!=null){

                                }
                                return Center(child: CircularProgressIndicator());
                              });
                        }
                      }else{
                        showInSnackBar("Veuillez d'abord valider les conditions d'utilisation", _scaffoldKey);
                      }
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
                    child: Center(child: new Text('valider le transfert', style: new TextStyle(fontSize: taille_text_bouton, color: Colors.white),)),
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
  Widget getMoyen(int index){
    String text, img;
    switch(index){
      case 1: text = "MOBILE MONEY";img = 'mobilemoney.jpg';
      break;
      case 2: text = "PORTE MONEY";img = 'wallet.png';
      break;
      case 3: text = "CARTE BANCAIRE";img = 'carte.jpg';
      break;
      case 4: text = "CASH PAR EXPRESS UNION";img = 'eu.png';
      break;
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
        ),
        border: Border.all(
            color: orange_F
        ),
        color: orange_F,
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 0),
        child: GestureDetector(
          onTap: (){
            setState(() {
              //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Retrait1('$_code')));
            });
          },
          child: Column(
            children: <Widget>[
              Container(
                height: 90,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    ),
                    image: DecorationImage(
                      image: AssetImage('images/$img'),
                      fit: BoxFit.cover,
                    )
                ),),
              Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text('$text',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: taille_description_champ-3,
                        fontWeight: FontWeight.bold
                    ),)
              )
            ],
          ),
        ),
      ),
    );
  }
}
void showInSnackBar(String value, GlobalKey<ScaffoldState> _scaffoldKey) {
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