import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:services/auth/profile.dart';
import 'package:services/composants/components.dart';

// ignore: must_be_immutable
class Echec extends StatefulWidget {
  Echec(this._code);
  String _code;

  @override
  _EchecState createState() => new _EchecState(_code);
}

class _EchecState extends State<Echec> {

  _EchecState(this._code);
  String _code, sms;

  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if(_code.split('^').last == '§')
      sms = "Désolé!\nEchec de l'offre!";
    else if(_code.split('^').last == '&')
      sms = "Désolé!\nEchec de l'encaissement!";
    else
      sms = "Désolé!\nVotre participation n'a été enregistrée!";

  }

  @override
  Widget build(BuildContext context) {

    final espace = (MediaQuery.of(context).size.height - 533.3333333333334)<0?0.0:MediaQuery.of(context).size.height - 533.3333333333334;
    final pas = (MediaQuery.of(context).size.height - 533.3333333333334)<0?0.0:42.0;

    return new Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: new AppBar(
          title: Text('Confirmation',style: TextStyle(
            color: couleur_titre,
            fontSize: taille_libelle_etape,
          ),),
          elevation: 0.0,
          backgroundColor: couleur_appbar,
          flexibleSpace: barreTop,

          leading: GestureDetector(
              onTap: (){
                setState(() {
                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Profile('$_code')));
                  //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Echec(_code)));
                });
                //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Verification3(_code)));
              },
              child: Icon(Icons.arrow_back_ios,)),
          iconTheme: new IconThemeData(color: couleur_fond_bouton),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          return Future.value(false); //return a `Future` with false value so this route cant be popped or closed.
        },
        child: SingleChildScrollView(
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
                        backgroundColor: couleur_champ,
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
                        child: new Text(sms,
                            style: TextStyle(
                                color: couleur_titre,
                                fontSize: taille_titre,
                                fontFamily: police_titre,
                                fontWeight: FontWeight.bold
                            )),
                      ),
                    ),


                    Padding(
                      padding: EdgeInsets.only(left:20.0, top:20.0, right: 20),
                      child: new Text("Cliquez pour retourner à l'accueil Sprint Pay",
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
                            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Profile('$_code')));
                            //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Echec(_code)));
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
                          child: Center(child: new Text("Retourner à l'accueil", style: new TextStyle(fontSize: taille_text_bouton, color: Colors.white, fontFamily: police_bouton),)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: barreBottom,
    );
  }
}