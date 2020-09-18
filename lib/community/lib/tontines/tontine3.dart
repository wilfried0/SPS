import 'package:services/community/lib/tontines/tontine2.dart';
import 'package:services/community/lib/tontines/tontine4.dart';
import 'package:services/composants/components.dart';
import 'package:flutter/material.dart';
import '../utils/components.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Tontine3 extends StatefulWidget {
  Tontine3();
  @override
  _Tontine3State createState() => new _Tontine3State();
}

class _Tontine3State extends State<Tontine3> {
  _Tontine3State();
  String name, descriptiontontine;
  var _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _controller, _motifTextController;
  //var isKeyboardOpen = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = new TextEditingController();
    _motifTextController = new TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _motifTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text('Libellé et description de la tontine',
          style: TextStyle(
            color: couleur_titre,
            fontSize: taille_champ+3,
          ),),
        elevation: 0.0,
        backgroundColor: couleur_appbar,
        flexibleSpace: barreTop,
        leading: IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: couleur_fond_bouton,),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Tontine2()));
          },
        ),
        //iconTheme: new IconThemeData(color: couleur_fond_bouton),
      ),
      body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: new Text('Créer une Tontine',
                      style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_titre,
                          fontWeight: FontWeight.bold
                      ),),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: new Text('Etape 3 sur 5',
                        style: TextStyle(
                            color: couleur_libelle_etape,
                            fontSize: taille_libelle_etape,
                            fontWeight: FontWeight.bold
                        )),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: new Text("Quelle est le libellé de la Tontine ?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: taille_description_page,
                      ),),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: new TextFormField(
                      controller: _controller,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                          color: couleur_libelle_champ,
                          fontSize: taille_champ+3,
                          fontWeight: FontWeight.bold
                      ),
                      validator: (String value){
                        if(value.isEmpty){
                          return null;
                        }else{
                          setState(() {
                            name = value;
                          });
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          //borderRadius: new BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: couleur_bordure, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: couleur_bordure),
                        ),
                        labelText: 'Libellé',
                        labelStyle: new TextStyle(
                            color: couleur_libelle_champ,
                            fontWeight: FontWeight.normal
                        ),
                        hintStyle: TextStyle(
                          color: couleur_libelle_champ,
                          fontSize: taille_champ+3,
                        ),
                        //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: new Text("À propos de la tontine",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: taille_description_page,
                      ),),
                  ),

                  Container(
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
                          width: 1.5
                      ),
                    ),
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0.0, left: 10, right: 10),
                      child: new TextFormField(
                        controller: _motifTextController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: taille_champ+3,
                        ),
                        validator: (String value){
                          if(value.isEmpty){
                            return "Description est obligatoire!";
                          }else{
                            setState(() {
                              descriptiontontine = value;
                            });
                            return null;
                          }
                        },
                        decoration: InputDecoration.collapsed(
                          hintText: 'Votre description ici',
                          hintStyle: TextStyle(
                            color: couleur_libelle_champ,
                            fontSize: taille_champ,
                          ),
                          //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: new InkWell(
                      onTap: () {
                        setState(() {
                          if(_formKey.currentState.validate() && name != null){
                            _save();
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Tontine4()));
                          }else{
                            showInSnackBar("Veuillez renseigner le libellé", _scaffoldKey, 5);
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
                        child: Center(child: new Text("Continuer", style: new TextStyle(fontSize: taille_champ+3, color: Colors.white,),)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
      ),
      bottomNavigationBar: barreBottom,
    );
  }

  void _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(LIBELLE_TONTINE, name);
    _controller.text = name;
    prefs.setString(DESCRIPTION_TONTINE, descriptiontontine);
    _motifTextController.text = descriptiontontine;
    print('savename $name');
    print('savedesciption $descriptiontontine');
  }
}