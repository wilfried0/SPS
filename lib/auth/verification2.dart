import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:services/composants/components.dart';
import 'connexion.dart';
import 'verification3.dart';
import 'verification1.dart';

// ignore: must_be_immutable
class Verification2 extends StatefulWidget {

  Verification2(this._code);
  String _code;

  @override
  _Verification2State createState() => new _Verification2State(_code);
}

class _Verification2State extends State<Verification2> {

  _Verification2State(this._code);
  String _code;

  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final espace = (MediaQuery.of(context).size.height - 533.3333333333334)<0?0.0:MediaQuery.of(context).size.height - 533.3333333333334;
    final pas = (MediaQuery.of(context).size.height - 533.3333333333334)<0?0.0:42.0;


    //double sp = MediaQuery.of(context).size.height;
    return new Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: new AppBar(
          elevation: 0.0,
          backgroundColor: couleur_appbar,
          flexibleSpace: barreTop,

          leading: GestureDetector(
              onTap: (){
                setState(() {
                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Verification1(_code)));
                });
                //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Verification1(_code)));
              },
              child: Icon(Icons.arrow_back_ios,)),
          iconTheme: new IconThemeData(color: bleu_F),
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
                      child: new Image.asset('images/logo.png'),
                    ),
                  ),

                  Padding(
                      padding: EdgeInsets.only(top:espace/2,)),

                  Padding(
                    padding: EdgeInsets.only(left: 20.0,),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: new Text("Mot de passe oublié ?",
                          style: TextStyle(
                              color: couleur_titre,
                              fontSize: taille_titre,
                              fontFamily: police_titre,
                              fontWeight: FontWeight.bold
                          )),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: marge_libelle_champ),),

                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: new Text("Etape 2 sur 3",
                          style: TextStyle(
                              color: couleur_libelle_etape,
                              fontSize: taille_libelle_etape,
                              fontFamily: police_libelle_etape,
                              fontWeight: FontWeight.bold
                          )),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: marge_champ_libelle),),

                  Padding(
                    padding: EdgeInsets.only(left:20.0, right:20.0),
                    child: new Text("Veuillez saisir le code de validation qui vous a été envoyé par SMS à votre numéro de téléphone",
                      style: TextStyle(
                          color: couleur_decription_page,
                          fontSize: taille_description_page,
                          fontFamily: police_description_page
                      ),textAlign: TextAlign.justify,),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: marge_libelle_champ),),

                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                            flex:2,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: new Image.asset('images/Trace943.png'),
                            ),
                          ),

                          new Expanded(
                            flex:10,
                            child: new TextFormField(
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                  color: couleur_libelle_champ,
                                  fontSize: taille_champ,
                                  fontFamily: police_champ
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return "Code de validation vide !";
                                }
                                return null;
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: "Saisissez le code de validation reçu",
                                hintStyle: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize: taille_champ,
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
                    padding: EdgeInsets.only(top: pas/2),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Verification3(_code)));
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
                        child: Center(child: new Text("Valider", style: new TextStyle(fontSize: taille_text_bouton, color: Colors.white, fontFamily: police_bouton),)),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left:20.0, right:20.0, top: 20),
                    child: new Text("Vous n'avez toujours pas reçu de code par SMS ?",
                      style: TextStyle(
                          color: couleur_decription_page,
                          fontSize: taille_description_page,
                          fontFamily: police_description_page
                      ),),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: pas/2),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Verification3(_code)));
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
                        child: Center(child: new Text("Renvoyer le code", style: new TextStyle(fontSize: taille_text_bouton, color: Colors.white, fontFamily: police_bouton),)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Vous avez déjà un compte ? ",
                          style: TextStyle(
                              color: couleur_decription_page,
                              fontSize: taille_description_champ,
                              fontFamily: police_description_champ
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Connexion()));
                            });
                            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Connexion(_code)));
                          },
                          child: Text("Connectez-vous !",
                            style: TextStyle(
                                color: couleur_fond_bouton,
                                fontSize: taille_description_champ,
                                fontFamily: police_description_champ,
                                fontWeight: FontWeight.bold
                            ),
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
                        Text("Vous n'avez pas de compte ? ",
                          style: TextStyle(
                              color: couleur_decription_page,
                              fontSize: taille_description_champ,
                              fontFamily: police_description_champ
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Connexion()));
                            });
                            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Connexion(_code)));
                          },
                          child: Text("Inscrivez-vous !",
                            style: TextStyle(
                                color: couleur_fond_bouton,
                                fontSize: taille_description_champ,
                                fontFamily: police_description_champ,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ],
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