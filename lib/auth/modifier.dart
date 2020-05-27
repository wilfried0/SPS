import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:services/auth/verification3.dart';
import 'package:services/composants/components.dart';

import 'connexion.dart';

// ignore: must_be_immutable
class Modifier extends StatefulWidget {
  Modifier(this._code);
  String _code;

  @override
  _ModifierState createState() => new _ModifierState(_code);
}

class _ModifierState extends State<Modifier> {

  _ModifierState(this._code);
  String _code;

  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final espace = (MediaQuery.of(context).size.height - 533.3333333333334)<0?0.0:MediaQuery.of(context).size.height - 533.3333333333334;
    final pas = (MediaQuery.of(context).size.height - 533.3333333333334)<0?0.0:42.0;

    return new Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: new AppBar(
          elevation: 0.0,
          backgroundColor: couleur_appbar,
          flexibleSpace: barreTop,
          leading: IconButton(
              onPressed: (){
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Verification3(_code)));
              },
              icon: Icon(Icons.arrow_back_ios,color: couleur_fond_bouton,)
          ),
          //iconTheme: new IconThemeData(color: couleur_fond_bouton),
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
                      child: new Image.asset('images/logo_sprint.png'),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: marge_apres_logo),),

                  Padding(
                      padding: EdgeInsets.only(top:(espace - 65)>0?(espace-65)/2:0.0,)),

                  Container(
                    child: CircleAvatar(
                      backgroundColor: couleur_description_champ,
                      radius: 65.0,
                      child: new Image.asset('images/Groupee191.png'),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: marge_apres_titre),),

                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: new Text('Votre mot de passe a bien été modifié',
                          style: TextStyle(
                              color: couleur_titre,
                              fontSize: taille_titre,
                              fontFamily: police_titre,
                              fontWeight: FontWeight.bold
                          )),
                    ),
                  ),


                  Padding(
                    padding: EdgeInsets.only(left:20.0, top:20.0),
                    child: new Text("Cliquez pour vous connecter dès maintenant à votre compte Sprint Pay",
                      style: TextStyle(
                          color: couleur_decription_page,
                          fontSize: taille_description_page,
                          fontFamily: police_description_page
                      ),),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: pas/2),
                    child: new GestureDetector(
                      onTap: (){
                        setState(() {
                          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Connexion()));
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
                        child: Center(child: new Text('Connexion en un clic', style: new TextStyle(fontSize: taille_text_bouton, color: Colors.white, fontFamily: police_bouton),)),
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
}