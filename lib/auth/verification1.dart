import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:services/composants/components.dart';
import 'connexion.dart';
import 'verification2.dart';

// ignore: must_be_immutable
class Verification1 extends StatefulWidget {

  Verification1(this._code);
  String _code;

  @override
  _Verification1State createState() => new _Verification1State(_code);
}

class _Verification1State extends State<Verification1> {

  _Verification1State(this._code);
  String _code, _mySelection;

  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final espace = (MediaQuery.of(context).size.height - 533.3333333333334)<0?0.0:MediaQuery.of(context).size.height - 533.3333333333334;

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
                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Connexion()));
                });
                //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Connexion(_code)));
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
                      padding: const EdgeInsets.only(top: 0.0, left: 40.0, right: 40.0),
                      child: new Image.asset('images/logo.png'),
                    ),
                  ),

                  Padding(
                      padding: EdgeInsets.only(top:espace/2,)),

                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
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
                      child: new Text("Etape 1 sur 3",
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
                    padding: EdgeInsets.only(left:20.0),
                    child: new Text("Merci de renseigner votre numéro de téléphone afin que nous puissions vous envoyer un code de validation pour vous permettre de réinitialiser vos accès",
                      style: TextStyle(
                          color: couleur_decription_page,
                          fontSize: taille_description_page,
                        fontFamily: police_description_page
                      ),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: marge_libelle_champ),),

                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
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
                            flex:10,
                            child: Padding(
                                padding: const EdgeInsets.only(left:10.0,),
                                child: new Text("code",
                                  style: TextStyle(
                                    color: couleur_champ,
                                    fontSize: taille_champ,
                                    fontFamily: police_champ
                                  ),)
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
                            color: couleur_bordure,
                            width: bordure
                        ),
                      ),
                      height: hauteur_champ,
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                            flex:2,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                              child: new Image.asset('images/Groupe182.png'),
                            ),
                          ),
                          new Expanded(
                            flex:10,
                            child: Padding(
                              padding: EdgeInsets.only(left:0.0),
                              child: new TextFormField(
                                keyboardType: TextInputType.phone,
                                style: TextStyle(
                                  fontSize: taille_champ,
                                  color: couleur_description_champ,
                                  fontFamily: police_champ
                                ),
                                validator: (String value){
                                  if(value.isEmpty){
                                    return "Champ téléphone vide !";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration.collapsed(
                                  hintText: "Téléphone",
                                  hintStyle: TextStyle(color: couleur_description_champ,
                                    fontFamily: police_champ,fontSize: taille_champ,),
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
                    padding: EdgeInsets.only(top: marge_champ_libelle),
                    child: new GestureDetector(
                      onTap: (){
                        setState(() {
                          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Verification2(_code)));
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
                        child: Center(child: new Text("Demander un code de validation", style: new TextStyle(fontSize: taille_text_bouton, color: Colors.white, fontFamily: police_bouton),)),
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