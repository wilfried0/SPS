import 'dart:convert';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:services/composants/services.dart';
import 'connexion.dart';
import 'package:http/http.dart' as http;
import 'activation.dart';
import 'package:services/composants/components.dart';

import 'inscription1.dart';

// ignore: must_be_immutable
class Inscription extends StatefulWidget {
  Inscription();
  @override
  _InscriptionState createState() => new _InscriptionState();
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

class _InscriptionState extends State<Inscription> {
  _InscriptionState();
  bool _check=false;
  String _firstname,_current, _lastname, _ville, _country, _birthday;
  bool boolFirstname=false, boolLastname=false, boolEmail=false, boolPassword=false, boolVille=false, boolbirthday=false, boolUsername=false;
  var _categorie = ['Madame', 'Monsieur'];
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
    super.initState();
    url = '$base_url/user/Auth/createmember';
    print(url);
    this._ville = 'Yaoundé';
    boolVille = true; boolbirthday = true;
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
                    child: new Text("Etape 1 sur 2",
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
                    child: Text('Lieu de résidence',
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
                  child: Container(
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                        bottomLeft: Radius.circular(0.0),
                        bottomRight: Radius.circular(0.0),
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
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: CountryCodePicker(
                            showFlag: true,
                            showOnlyCountryWhenClosed: true,
                            onChanged: (CountryCode code){
                              //_mySelection = code.dialCode.toString();
                            },
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
                            child: new Icon(Icons.edit_location, color: couleur_decription_page,),//Image.asset('images/Groupe177.png'),
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
                                  return "Champ ville vide !";
                                }else{
                                  boolLastname = true;
                                  _lastname = value;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Ville',
                                hintStyle: TextStyle(color: couleur_libelle_champ,
                                  fontSize: taille_champ
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

                Padding(padding: EdgeInsets.only(top: marge_champ_libelle),),

                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Identité',
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
                          fontSize: taille_description_champ,
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

                Padding(padding: EdgeInsets.only(top: marge_champ_libelle),),

                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Date de naissance",
                      style: TextStyle(
                          color: couleur_libelle_champ,
                          fontSize: taille_libelle_champ,
                          fontWeight: FontWeight.bold
                      ),),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: marge_libelle_champ),),

                /*Padding(
                 padding: EdgeInsets.only(left: 20.0, right: 20.0),
                 child: Align(
                   alignment: Alignment.centerLeft,
                   child: Text('Votre mot de passe doit comporter au moins 8 caractères',
                     style: TextStyle(
                         color: couleur_description_champ,
                         fontFamily: police_description_champ,
                         fontSize: taille_description_champ
                     ),),
                 ),
               ),*/

                Padding(padding: EdgeInsets.only(top: marge_libelle_champ),),

                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: GestureDetector(
                    onTap: (){
                      _selectDate();
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 0.0),
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
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
                              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                              child: new Icon(Icons.calendar_today, color: couleur_decription_page,),//Image.asset('images/Groupe179.png'),
                            ),
                          ),
                          new Expanded(
                            flex:10,
                            child: Padding(
                              padding: EdgeInsets.only(left:0.0),
                              child: new TextFormField(
                                keyboardType: TextInputType.text,
                                enabled: false,
                                style: TextStyle(
                                    fontSize: taille_champ,
                                    color: couleur_libelle_champ,
                                ),
                                validator: (String value){
                                  if(_birthday == null){
                                    return 'Date de naissance vide';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration.collapsed(
                                  hintText: _birthday==null?'Date de naissance':_birthday,
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
                ),
                /*Padding(
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
                                 fontFamily: police_champ,
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
                               fontFamily: police_champ
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
                                 fontFamily: police_champ
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
                                 fontFamily: police_champ
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
                                 hintStyle: TextStyle(color: couleur_libelle_champ, fontFamily: police_champ, fontSize: taille_champ,),
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
                                 fontFamily: police_champ
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
                                 hintStyle: TextStyle(color: couleur_libelle_champ, fontFamily: police_champ,fontSize: taille_champ,),
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
                     Text("Accepter les conditions d'utilisation et\nla politique de confidentialité de Sprintpay",style: TextStyle(
                         color: couleur_fond_bouton,
                         fontSize: taille_description_champ,
                         fontFamily: police_description_champ,
                       fontWeight: FontWeight.bold
                     ),),
                   ],
                 ),
               ),

               Padding(
                 padding: const EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
                 child: Text("En soumettant ce formulaire, vous autorisez également Sprint Pay à vous contacter et à vous envoyer des communications marketing en utilisant les coordonnées que vous avez fournies",
                   style: TextStyle(
                     color: couleur_description_champ,
                       fontSize: taille_description_champ,
                       fontFamily: police_description_champ
                   ),textAlign: TextAlign.justify,),
               ),*/

                Padding(padding: EdgeInsets.only(top: marge_champ_libelle),),

                GestureDetector(
                  onTap: () async {
                    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Inscription1("")));
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
                              /*email:this._email,
                               username: _username,
                               password:this._password,*/
                              userImage: null,
                              role: role
                          );
                          //var body, var _header, String url, String _code, BuildContext context,GlobalKey<ScaffoldState> _scaffoldKey
                          FutureBuilder(
                              future: createPost(json.encode(newPost), _header, url, "", context, _scaffoldKey),
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
                    child: Center(child: new Text('Continuer', style: new TextStyle(fontSize: taille_text_bouton, color: Colors.white, fontFamily: police_bouton),)),
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

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime(1900),
        firstDate: new DateTime(1900),
        lastDate: new DateTime(2019)
    );
    if(picked != null) setState(
            () => _birthday = picked.toString().split(" ")[0].replaceAll("-", "/")
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