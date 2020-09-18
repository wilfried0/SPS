import 'package:services/community/lib/tontines/settings.dart';
import 'package:services/community/lib/tontines/tontine2.dart';
import 'package:services/composants/components.dart';
import 'package:flutter/material.dart';
import '../utils/components.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Tontine5 extends StatefulWidget {
  Tontine5();
  @override
  _Tontine5State createState() => new _Tontine5State();
}

class _Tontine5State extends State<Tontine5> {
  _Tontine5State();
  String paticipationDuration, delayTimes, saction;
  var _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var delayTimesController, participationDurationController, sanctionController;
  //var isKeyboardOpen = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    delayTimesController = new TextEditingController();
    participationDurationController = new TextEditingController();
    sanctionController = new TextEditingController();
  }

  @override
  void dispose() {
    delayTimesController.dispose();
    participationDurationController.dispose();
    sanctionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text('Période et retard autorisés',
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
                    child: new Text('Etape 5 sur 5',
                        style: TextStyle(
                            color: couleur_libelle_etape,
                            fontSize: taille_libelle_etape,
                            fontWeight: FontWeight.bold
                        )),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: new Text("Quel est le nombre de jours après lequel on participe à la tontine ?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: taille_description_page,
                      ),),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: new TextFormField(
                      controller: participationDurationController,
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
                            paticipationDuration = value;
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
                        labelText: 'Période de participation',
                        labelStyle: new TextStyle(
                            color: couleur_libelle_champ,
                            fontWeight: FontWeight.normal
                        ),
                        suffixText: 'Jours',
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
                    child: new Text("Nombre de jours de retard autorisés",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: taille_description_page,
                      ),),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top:0),
                    child: new TextFormField(
                      controller: delayTimesController,
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
                            delayTimes = value;
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
                        labelText: 'Retard autorisé',
                        labelStyle: new TextStyle(
                            color: couleur_libelle_champ,
                            fontWeight: FontWeight.normal
                        ),
                        suffixText: 'Jours',
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
                    child: new Text("Valeur en pourcentage de la sanction",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: taille_description_page,
                      ),),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top:0),
                    child: new TextFormField(
                      controller: sanctionController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                          color: couleur_libelle_champ,
                          fontSize: taille_champ+3,
                          fontWeight: FontWeight.bold
                      ),
                      validator: (String value){
                        if(value.isEmpty){
                          return "Sanction vide!";
                        }else{
                          setState(() {
                            saction = value;
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
                        labelText: 'Sanction',
                        labelStyle: new TextStyle(
                            color: couleur_libelle_champ,
                            fontWeight: FontWeight.normal
                        ),
                        suffixText: '%',
                        hintStyle: TextStyle(
                          color: couleur_libelle_champ,
                          fontSize: taille_champ+3,
                        ),
                        //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: new InkWell(
                      onTap: () {
                        setState(() {
                          if(_formKey.currentState.validate() && paticipationDuration != null){
                            _save();
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Settings()));
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
    prefs.setString(DELAYTIMES, delayTimes);
    delayTimesController.text = delayTimes;
    print('savedelaytimes $delayTimes');
    prefs.setString(PARTICIPATIONDURATION, paticipationDuration);
    prefs.setString(SANCTION, saction);
    sanctionController.text = saction;
    participationDurationController.text = paticipationDuration;
    print('saveparticipationduration $paticipationDuration');
  }
}