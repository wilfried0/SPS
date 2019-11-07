import 'dart:convert';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:services/composants/services.dart';
import 'connexion.dart';
import 'package:http/http.dart' as http;
import 'activation.dart';
import 'package:services/composants/components.dart';

// ignore: must_be_immutable
class Inscription1 extends StatefulWidget {
  Inscription1(this._code);
  String _code;
  @override
  _Inscription1State createState() => new _Inscription1State(_code);
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

class _Inscription1State extends State<Inscription1> {
  _Inscription1State(this._code);
  String _code;
  bool _check=false;
  String _firstname, _lastname, _ville, _country, _birthday, _password, _verfiPassword, _email, _mySelection;
  bool boolFirstname=false, boolLastname=false, boolEmail=false, boolPassword=false, boolVille=false, boolbirthday=false, boolUsername=false;

  var _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isHidden = true;
  String url;
  var _header = {
    "content-type": "application/json",
    "accept": "application/json"
  };

  @override
  void initState(){
    List<String> list = _code.split('^');
    if(list.length-1>3){
      list.removeAt(list.length-1);
      _code = list.toString().substring(1,list.toString().length-1).replaceAll(',', '^');
      _code = _code.replaceAll(' ', "");
      print('back to $_code');
    }
    super.initState();
    url = '$base_url/user/Auth/createmember';
    print(url);
    this._ville = 'Yaoundé';
    boolVille = true; boolbirthday = true;
    print(_code);
  }

  void _toggleVisibility(){
    setState((){
      _isHidden = !_isHidden;
    });
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
        backgroundColor: couleur_appbar,
        flexibleSpace: barreTop,

        leading: GestureDetector(
            onTap: (){
              setState(() {
                Navigator.pop(context);
                //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Connexion(_code)));
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text("Inscrivez-vous.\nC'est gratuit",
                      style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_titre,
                          fontWeight: FontWeight.bold
                      )),

                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: new Text("Etape 2 sur 2",
                        style: TextStyle(
                            color: couleur_libelle_etape,
                            fontSize: taille_libelle_etape,
                            fontWeight: FontWeight.bold
                        )),
                  ),
                ],
              ),
            ),
          ),

          Padding(padding: EdgeInsets.only(top: marge_apres_titre),),

          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Coordonnées de connexion",
                      style: TextStyle(
                          color: couleur_libelle_champ,
                          fontSize: taille_libelle_champ,
                          fontWeight: FontWeight.bold
                      ),),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: marge_libelle_champ),),

                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Votre mot de passe doit comporter au moins 8 caractères',
                      style: TextStyle(
                          color: couleur_description_champ,
                          fontSize: taille_description_champ
                      ),),
                  ),
                ),

                Padding(padding: EdgeInsets.only(top: marge_libelle_champ),),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                      color: Colors.transparent,
                      border: Border.all(
                          width: bordure,
                          color: couleur_bordure
                      ),
                    ),
                    height: hauteur_champ,
                    child: Padding(
                      padding: EdgeInsets.only(left: 0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 4,
                              child: CountryCodePicker(
                                showFlag: true,
                                onChanged: (CountryCode code){
                                  _mySelection = code.dialCode.toString();
                                },
                              )
                          ),
                          Expanded(
                            flex: 10,
                            child: TextFormField(
                              //controller: _userTextController3,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                  fontSize: taille_libelle_champ,
                                  color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return 'Téléphone vide !';
                                }else{
                                  //tel = '$value';
                                  //_userTextController3.text = tel;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Contact téléphonique',
                                hintStyle: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize: taille_libelle_champ
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 0.0),
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.only(
                        topLeft: Radius.circular(0.0),
                        topRight: Radius.circular(0.0),
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
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
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
                                  _birthday = value;
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
                              padding: const EdgeInsets.all(5.0),
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
                                    fontSize: taille_champ,
                                    color: couleur_libelle_champ,
                                ),
                                validator: (String value){
                                  if(value.isEmpty){
                                    return 'Champ mot de passe vide !';
                                  }else if(value.length>=7){
                                    _password = value;
                                    return null;
                                  }else{
                                    return 'Votre mot de passe doit avoir au moins 8 caractères!';
                                  }
                                },
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Mot de passe',
                                  hintStyle: TextStyle(color: couleur_libelle_champ, fontSize: taille_champ,),
                                  //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                ),
                                obscureText: _isHidden,
                                /*textAlign: TextAlign.end,*/
                              ),
                            ),
                          ),
                          Expanded(
                            flex:2,
                            child: new IconButton(
                              onPressed: _toggleVisibility,
                              icon: _isHidden? new Icon(Icons.visibility_off,):new Icon(Icons.visibility,),
                              color: couleur_titre,
                              iconSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 0.0),
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.only(
                        bottomLeft: Radius.circular(0.0),
                        bottomRight: Radius.circular(0.0),
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
                              padding: const EdgeInsets.all(5.0),
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
                                    fontSize: taille_champ,
                                    color: couleur_libelle_champ,
                                ),
                                validator: (String value){
                                  if(value.isEmpty){
                                    return 'Vérification du mot de passe vide !';
                                  }else{
                                    _verfiPassword = value;
                                    if(_verfiPassword == _password){
                                      boolPassword = true;
                                      return null;
                                    }else{
                                      return 'Les mots de passe ne sont pas identiques';
                                    }
                                  }
                                },
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Vérification du mot de passe',
                                  hintStyle: TextStyle(color: couleur_libelle_champ,fontSize: taille_champ,),
                                  //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                ),
                                obscureText: _isHidden,
                                /*textAlign: TextAlign.end,*/
                              ),
                            ),
                          ),
                          Expanded(
                            flex:2,
                            child: new IconButton(
                              onPressed: _toggleVisibility,
                              icon: _isHidden? new Icon(Icons.visibility_off,):new Icon(Icons.visibility,),
                              color: couleur_titre,
                              iconSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Container(
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
                      padding: EdgeInsets.only(left: 0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 2,
                              child: CountryCodePicker(
                                showFlag: false,
                                onChanged: (CountryCode code){
                                  _mySelection = code.dialCode.toString();
                                },
                              )
                          ),
                          Expanded(
                            flex: 10,
                            child: TextFormField(
                              //controller: _userTextController3,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                  fontSize: taille_libelle_champ,
                                  color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return 'Téléphone vide !';
                                }else{
                                  //tel = '$value';
                                  //_userTextController3.text = tel;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Contact du parrain (facultatif)',
                                hintStyle: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize: taille_libelle_champ
                                ),
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
                  padding: const EdgeInsets.only(left: 5, right: 20),
                  child: Row(
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
                      Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Accepter les conditions générales d'utilisation",style: TextStyle(
                                  color: couleur_fond_bouton,
                                  fontSize: taille_description_champ,
                                  fontWeight: FontWeight.bold
                              ),),
                              Text("et la politique de confidentialité de SPRINT PAY",style: TextStyle(
                                  color: couleur_description_champ,
                                  fontSize: taille_description_champ,
                                  fontWeight: FontWeight.normal
                              ),),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /*Padding(
                  padding: const EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
                  child: Text("En soumettant ce formulaire, vous autorisez également SPRINT PAY à vous contacter et à vous envoyer des communications marketing en utilisant les coordonnées que vous avez fournies",
                    style: TextStyle(
                        color: couleur_description_champ,
                        fontSize: taille_description_champ,
                        fontFamily: police_description_champ
                    ),textAlign: TextAlign.justify,),
                ),*/

                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 20),
                  child: Row(
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Cochez cette case si vous ne souhaitez pas\nrecevoir les propositions commerciales de\nSPRINT PAY et de ses partenaires.",style: TextStyle(
                            color: couleur_description_champ,
                            fontSize: taille_description_champ,
                            fontWeight: FontWeight.normal
                        ),),
                      ),
                    ],
                  ),
                ),

                Padding(padding: EdgeInsets.only(top: marge_champ_libelle),),

                GestureDetector(
                  onTap: () async {
                    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Activation()));
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
                              //username: _username,
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
                    child: Center(child: new Text('Je m\'inscris', style: new TextStyle(fontSize: taille_text_bouton, color: Colors.white, fontFamily: police_bouton),)),
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
                Text('Vous avez déjà un compte? ',
                  style: TextStyle(
                      color: couleur_description_champ,
                      fontSize: taille_description_champ,
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Connexion()));
                      //Navigator.of(context).push(SlideLeftRoute(enterWidget: Connexion(_code), oldWidget: Inscription(_code)));
                    });
                    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Connexion(_code)));
                  },
                  child: Text('Connectez-vous !',
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
        ],
      ),
      bottomNavigationBar: barreBottom,
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