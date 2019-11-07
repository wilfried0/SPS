import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:services/composants/components.dart';
import 'package:services/composants/services.dart';

import 'transfert1.dart';
import 'transfert3.dart';

// ignore: must_be_immutable
class Transfert2 extends StatefulWidget {
  Transfert2(this._code);
  String _code;
  @override
  _Transfert2State createState() => new _Transfert2State(_code);
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

class _Transfert2State extends State<Transfert2> {
  double marge;
  List data;
  _Transfert2State(this._code);
  String _code;
  bool _check=false;
  String _firstname,_current, _lastname, _email, _verfiPassword, _ville, _country, _birthday, _username, _password;
  bool boolFirstname=false, boolLastname=false, boolEmail=false, boolPassword=false, boolVille=false, boolbirthday=false, boolUsername=false;
  int choice = 0;
  var _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String url;
  var _header = {
    "content-type": "application/json",
    "accept": "application/json"
  };
  var _categorie = ['Madame', 'Monsieur'];

  @override
  void initState(){
    super.initState();
    this.loadMap();
    url = '$base_url/user/Auth/createmember';
    this._country = this._code.split('^')[3];
    this._ville = 'Yaoundé';
    this._birthday = '2019-07-24';
    boolVille = true; boolbirthday = true;
  }

  Future<bool>loadMap() async {
    var jsonText = await rootBundle.loadString('images/map.json');
    setState(() => this.data = json.decode(jsonText));
    return true;
  }


  bool isEmail(String em) {
    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }

  @override
  Widget build(BuildContext context) {
    marge = (5*MediaQuery.of(context).size.width)/414;

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: couleur_appbar,
        flexibleSpace: barreTop,

        leading: InkWell(
            onTap: (){
              setState(() {
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfert1(_code)));
                //Navigator.of(context).push(SlideLeftRoute(enterWidget: Connexion(_code), oldWidget: Inscription(_code)));
              });
            },
            child: Icon(Icons.arrow_back_ios,)),
        iconTheme: new IconThemeData(color: couleur_fond_bouton),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: hauteur_logo,
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 40.0, right: 40.0),
              child: new Image.asset('images/logo.png'),
            ),
          ),

          Padding(padding: EdgeInsets.only(top: marge_apres_logo),),

          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: new Text("Ajouter le bénéficiaire",
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
                Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 0.0, right: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("ipsum lorem strdo ipsum lorem strdo ipsum lorem strdo ipsum lorem strdo ipsum lorem strdo ipsum lorem strdo ipsum lorem strdo ipsum lorem strdo ipsum lorem strdo",
                      style: TextStyle(
                          color: couleur_description_champ,
                          fontSize: taille_description_champ
                      ),),
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
                  padding: EdgeInsets.only(left: 20.0, top: 0.0, right: 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Veuillez écrire votre nom légal complet, comme indiqué sur votre passeport ou votre permi de conduire.",
                      style: TextStyle(
                          color: couleur_description_champ,
                          fontSize: taille_description_champ
                      ),),
                  ),
                ),

                Padding(padding: EdgeInsets.only(top: marge_libelle_champ),),

                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          icon: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: new Icon(Icons.arrow_drop_down_circle,
                              color: couleur_champ,),
                          ),
                          isDense: false,
                          elevation: 1,
                          isExpanded: true,
                          onChanged: (String selected){
                            setState(() {
                              _current = selected;
                            });
                          },
                          value: _current,
                          hint: Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text('Madame/Monsieur',
                              style: TextStyle(
                                color: couleur_libelle_champ,
                                fontSize:taille_champ,
                              ),),
                          ),
                          items: _categorie.map((String name){
                            return DropdownMenuItem<String>(
                              value: name,
                              child: Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(name,
                                  style: TextStyle(
                                      color: couleur_libelle_champ,
                                      fontSize:taille_champ,
                                  ),),
                              ),
                            );
                          }).toList(),
                        )
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
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  fontSize: taille_champ,
                                  color: couleur_libelle_champ
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
                                  color: couleur_libelle_champ
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
                            padding: const EdgeInsets.only(left: 17.0, right: 17.0),
                            child: new Image.asset('images/Groupe179.png'),
                          ),
                        ),
                        new Expanded(
                          flex:10,
                          child: Padding(
                            padding: EdgeInsets.only(left:0.0),
                            child: new TextFormField(
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
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                    fontSize: taille_champ,
                                    color: couleur_libelle_champ
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
                            child: new Icon(Icons.account_balance, color: couleur_decription_page,),
                          ),
                        ),
                        new Expanded(
                          flex:10,
                          child: Padding(
                            padding: EdgeInsets.only(left:0.0),
                            child: new TextFormField(
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
                            child: new Image.asset('images/check.jpg'),
                          ),
                        ),
                        new Expanded(
                          flex:10,
                          child: new TextFormField(
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
                              child: new Image.asset('images/online-shop.jpg'),
                            ),
                          ),
                          new Expanded(
                            flex:10,
                            child: Padding(
                              padding: EdgeInsets.only(left:marge),
                              child: new TextFormField(
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
                    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfert3(_code)));
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
                    child: Center(child: new Text('Poursuivre', style: new TextStyle(fontSize: taille_text_bouton, color: Colors.white),)),
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

  Future<void> getListUser(BuildContext context){
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
      return AlertDialog(
        title: Container(
          margin: EdgeInsets.only(top: 0.0),
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.only(
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            color: couleur_champ,
            border: Border.all(
                width: .1,
                color: couleur_champ
            ),
          ),
          height: 50.0,
          child: Row(
            children: <Widget>[
              Expanded(
                flex:1,
                child: Padding(
                  padding: const EdgeInsets.only(left:15.0),
                  child: new Icon(Icons.search,
                    size: 20.0,
                    color: couleur_bordure,),
                ),
              ),
              new Expanded(
                flex:10,
                child: Padding(
                  padding: EdgeInsets.only(left:20),
                  child: new TextField(
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: couleur_libelle_champ,
                    ),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Rechercher',
                      hintStyle: TextStyle(color: couleur_libelle_champ,),
                      //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    ),
                    onChanged: (String str){
                      //this.searchData(str);
                    },
                    /*textAlign: TextAlign.end,*/
                  ),
                ),
              ),
            ],
          ),
        ),
        content: Container(
          width: MediaQuery.of(context).size.width,
          //height: MediaQuery.of(context).size.height-50,
          child: ListView.builder(
            itemCount: 10,//data==null?0:data.length,
            itemBuilder: (BuildContext context, int i){
              //var name = data[i]['name'];
              //var flagUri = 'flags/${data[i]['code'].toLowerCase()}.png';
              return GestureDetector(
                child:
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: Divider(color: couleur_bordure,
                        height: .1,),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0, top: 10.0, bottom: 10.0),
                          child: SizedBox(
                            height: 30,
                            width: 40,
                            child: Image.asset("images/ellipse1.png"),
                          ),
                        ),
                        SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Assam Engozo'o Wilfried", //vérifier les débordement
                                style: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize: taille_champ,
                                    fontFamily: police_titre,
                                    fontWeight: FontWeight.bold
                                ),),
                              Text("237693685094",
                                style: TextStyle(
                                    color: couleur_libelle_etape,
                                    fontSize: taille_champ,
                                    fontFamily: police_titre
                                ),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: (){
                  setState(() {
                    Navigator.pop(context);
                  });
                  //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Connexion(_code)));
                },
              );
          }
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Annuler', style: TextStyle(
              color: Colors.red
            ),),
            onPressed: () {
              //this.savAll();
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Nouveau'),
            onPressed: () {
              //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Pays()));
              addUser(context);
            },
          ),
        ],

      );
      }
    );
  }

  Future<void> addUser(BuildContext context){
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Container(
              margin: EdgeInsets.only(top: 0.0),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                color: couleur_champ,
                border: Border.all(
                    width: .1,
                    color: couleur_champ
                ),
              ),
              height: 50.0,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex:1,
                    child: Padding(
                      padding: const EdgeInsets.only(left:15.0),
                      child: new Icon(Icons.search,
                        size: 20.0,
                        color: couleur_bordure,),
                    ),
                  ),
                  new Expanded(
                    flex:10,
                    child: Padding(
                      padding: EdgeInsets.only(left:20),
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: 14,
                          color: couleur_libelle_champ,
                        ),
                        decoration: InputDecoration.collapsed(
                          hintText: 'Rechercher',
                          hintStyle: TextStyle(color: couleur_libelle_champ,),
                          //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        ),
                        onChanged: (String str){
                          //this.searchData(str);
                        },
                        /*textAlign: TextAlign.end,*/
                      ),
                    ),
                  ),
                ],
              ),
            ),
            content: ListView.builder(
                itemCount: 0,//data==null?0:data.length,
                itemBuilder: (BuildContext context, int i){
                  //var name = data[i]['name'];
                  //var flagUri = 'flags/${data[i]['code'].toLowerCase()}.png';
                  return GestureDetector(
                    child:
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: Divider(color: couleur_bordure,
                            height: .1,),
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0, top: 10.0, bottom: 10.0),
                              child: SizedBox(
                                height: 30,
                                width: 40,
                                child: Image.asset("images/ellipse1.png"),
                              ),
                            ),
                            SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("", //vérifier les débordement
                                    style: TextStyle(
                                        color: couleur_libelle_champ,
                                        fontSize: taille_champ,
                                        fontFamily: police_titre,
                                        fontWeight: FontWeight.bold
                                    ),),
                                  Text("",
                                    style: TextStyle(
                                        color: couleur_libelle_etape,
                                        fontSize: taille_champ,
                                        fontFamily: police_titre
                                    ),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Transfert2(_code)));
                    },
                  );
                }
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Annuler', style: TextStyle(
                    color: Colors.red
                ),),
                onPressed: () {
                  //this.savAll();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
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