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
class Transfert22 extends StatefulWidget {
  Transfert22(this._code);
  String _code;
  @override
  _Transfert22State createState() => new _Transfert22State(_code);
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

class _Transfert22State extends State<Transfert22> {
  double marge;
  List data;
  _Transfert22State(this._code);
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
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: (){
                addUser(context);
              },
                child: Icon(Icons.add_circle_outline, color: couleur_fond_bouton,)),
          )
        ],
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
      body: Column(
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
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Container(
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
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 20, top: 20),
              child: ListView.builder(
                  itemCount: 10,//data==null?0:data.length,
                  itemBuilder: (BuildContext context, int i){
                    //var name = data[i]['name'];
                    //var flagUri = 'flags/${data[i]['code'].toLowerCase()}.png';
                    return InkWell(
                      child: Column(
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
                        Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfert3(_code)));
                      },
                    );
                  }
              ),
            ),
          )
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
            content: Container(
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
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
                        Navigator.of(context).pop();
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