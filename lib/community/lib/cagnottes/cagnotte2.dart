import 'package:flutter/material.dart';
import 'package:services/composants/components.dart';
import '../utils/components.dart';
import 'cagnotte1.dart';
import 'cagnotte3.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'categories.dart';
import 'visibiliti.dart';

class Cagnotte2 extends StatefulWidget {
  Cagnotte2();
  @override
  _Cagnotte2State createState() => new _Cagnotte2State();
}

class _Cagnotte2State extends State<Cagnotte2> {
  _Cagnotte2State();
  String _categorie, _visible, _libelle;
  bool _cat = false, _vis = false;
  var _formKey = GlobalKey<FormState>();
  var _libelleTextController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  @override
  void initState(){
    super.initState();
    this.read();
  }

  @override
  void dispose() {
    if(_libelleTextController != null)
    _libelleTextController.dispose();
    super.dispose();
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(
     new SnackBar(content: new Text(value,style:
      TextStyle(
        color: Colors.white,
        fontSize: taille_champ+5
      ),
    textAlign: TextAlign.center,),
    backgroundColor: couleur_fond_bouton,
    duration: Duration(seconds: 5),));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      backgroundColor: GRIS,
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text('Détails de la cagnotte',
          style: TextStyle(
            color: couleur_titre,
            fontSize: taille_libelle_etape,
          ),),
        elevation: 0.0,
        backgroundColor: GRIS,
        flexibleSpace: barreTop,
        leading: IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: couleur_fond_bouton,),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte1()));
          },
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text('Créer une cagnotte',
                  style: TextStyle(
                      color: couleur_titre,
                      fontSize: taille_titre,
                      fontWeight: FontWeight.bold
                  ),),

                Padding(
                  padding: EdgeInsets.only(top: marge_libelle_champ),),

                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: new Text('Etape 2 sur 5',
                      style: TextStyle(
                          color: couleur_libelle_etape,
                          fontSize: taille_libelle_etape,
                          fontWeight: FontWeight.bold
                      )),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: new Text("Dans quelle catégorie classez-vous\ncette cagnotte ?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: taille_description_page,
                    ),),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        onTap: (){
                          setState(() {
                            this.save();
                          });
                          if(_formKey.currentState.validate()){
                            this.save();
                          }
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Categories()));
                        },
                        child: Text(_categorie == null?'Cliquer ici pour choisir une catégorie':'Cliquer ici pour modifier la catégorie',
                        style: TextStyle(
                          color: bleu_F,
                          fontSize:taille_champ,
                          fontWeight: FontWeight.normal
                        ),),
                      ),
                      Spacer(),
                      Switch(
                          value: this._cat,
                          activeColor: couleur_fond_bouton,
                          onChanged: (val){
                            setState(() {
                              if(_categorie == null)
                                this._cat = false;
                              else
                                this._cat = true;
                            });
                            if(_formKey.currentState.validate()){
                              this.save();
                            }
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Categories()));
                          }
                      )
                    ],
                  ),
                ),

                _categorie == null?Container():Text(_categorie,
                  style: TextStyle(
                      color: couleur_fond_bouton,
                      fontSize: taille_champ+3,
                      fontWeight: FontWeight.bold
                  ),),

                _categorie == null?Container():Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Divider(
                    height: .9,
                    color: couleur_libelle_champ,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: new Text("Quel titre donnez-vous à cette\ncagnotte ?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: taille_description_page,
                    ),),
                ),

                Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Container(
                      color: Colors.white,
                      child: new TextFormField(
                        controller: _libelleTextController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            color: couleur_libelle_champ,
                            fontSize: taille_champ+3,
                        ),
                        validator: (String value){
                          if(value.isEmpty){
                            return null;
                          }else{
                            setState(() {
                              _libelle = value;
                            });
                            return null;
                          }
                        },
                        decoration: InputDecoration(enabledBorder: OutlineInputBorder(
                          //borderRadius: new BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: couleur_bordure),
                        ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: couleur_libelle_champ, width: 1.5),
                          ),
                          labelText: 'Libellé',
                          labelStyle: new TextStyle(
                              color: couleur_libelle_champ,
                              fontWeight: FontWeight.normal
                          ),
                          hintStyle: TextStyle(
                            color: couleur_libelle_champ,
                            fontSize: taille_champ+3,
                          ),),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: new Text("A quelle visibilité attribuée vous à cette\ncagnotte ?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: taille_description_page,
                    ),),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        onTap: (){
                          if(_formKey.currentState.validate()){
                            this.save();
                          }
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Visibiliti()));
                        },
                        child: Text(_visible == null?'Cliquer ici pour choisir une visibilité':'Cliquer ici pour modifier la visibilité',
                          style: TextStyle(
                              color: bleu_F,
                              fontSize:taille_champ,
                              fontWeight: FontWeight.normal
                          ),),
                      ),
                      Spacer(),
                      Switch(
                          value: this._vis,
                          activeColor: couleur_fond_bouton,
                          onChanged: (val){
                            setState(() {
                              if(_visible == null)
                                this._vis = false;
                              else
                                this._vis = true;
                            });
                            if(_formKey.currentState.validate()){
                              this.save();
                            }
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Visibiliti()));
                          }
                      ),
                    ],
                  ),
                ),

                _visible==null?Container():Padding(
                    padding: EdgeInsets.only(top: 10),
                  child: Text(_visible,
                  style: TextStyle(
                      color: couleur_fond_bouton,
                      fontSize: taille_champ+3,
                      fontWeight: FontWeight.bold
                  ),)
                ),

                _visible == null?Container():Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Divider(
                    height: .9,
                    color: couleur_libelle_champ,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: new InkWell(
                    onTap: () {
                      setState(() {
                        if(_categorie != null && _visible != null){
                          if(_formKey.currentState.validate() && _libelle != null){
                            this.save();
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte3()));
                          }else if(_libelle==null){
                            showInSnackBar("Renseigner le libellé!");
                          }
                        }else if(_categorie==null && _visible==null){
                          showInSnackBar("Sélectionner une catégorie et une visibilité!");
                        }else if(_categorie==null){
                          showInSnackBar("Sélectionner une catégorie!");
                        }else if(_visible==null){
                          showInSnackBar("Sélectionner une visibilité!");
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
                      child: Center(child: new Text("Continuer", style: new TextStyle(fontSize: taille_champ+3, color: Colors.white),)),
                    ),
                  ),
                )
              ],
            ),
          )
      ),
      bottomNavigationBar: barreBottom,
    );
  }

  void save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(LIBELLE, _libelle);
    print('saved $_libelle');
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _categorie =prefs.getString(CATEGORIE) != null? prefs.getString(CATEGORIE).split("^")[0]:null;
      if(_categorie == null || _categorie == "null"){
        _cat = false;
      }else{
        _cat = true;
      }

      _visible = prefs.getString(VISIBLE);
      if(_visible == null || _visible == "null"){
        _vis = false;
      }else{
        _vis = true;
      }

      _libelle = prefs.getString(LIBELLE);
      if(_libelle == null || _libelle == "null"){
        _libelleTextController = null;
      }else{
        _libelleTextController.text = _libelle;
      }
    });
    print('_visible: $_visible');
  }
}