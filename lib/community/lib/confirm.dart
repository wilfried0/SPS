import 'package:flutter/material.dart';
import 'package:services/composants/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cagnotte.dart';
import 'tontines/tontine.dart';
import 'utils/components.dart';

// ignore: must_be_immutable
class Confirm extends StatefulWidget {
  Confirm(this._code);
  String _code;

  @override
  _ConfirmState createState() => new _ConfirmState(_code);
}

class _ConfirmState extends State<Confirm> {

  _ConfirmState(this._code);
  String _code;
  var _formKey = GlobalKey<FormState>();
  String confirm, text;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lire();
  }

  lire() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      confirm = prefs.getString(CONFIRMATION);
      print("£££££££££££££££££££££££££££££££ $confirm");
      if(confirm == "settings"){
        text = "Votre tontine a été enregistrée!";
      }else if(confirm == "participation"){
        text = "Votre participation a été éffectuée avcec succes";
      }else if(confirm =="configuration"){
        text = "Votre cagnotte a été enregistrée!";
      }else if(confirm =="offre"){
        text = "Votre cagnotte a été offerte!";
      }else if(confirm =="encaisse"){
        text = "Votre cagnotte a été encaissée!";
      }
    });
  }

  init() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(MONTANT_PART, null);
    prefs.setString(MONTANT_ENCAISSE, null);
    prefs.setString(MONTANT_OFFRE, null);
    prefs.setString(NOM_PART, null);
    prefs.setString(TEL_PART, null);
    prefs.setString(MOTIF_PART, null);
    prefs.setString(EMAIL_PART, null);
    prefs.setString(ORIGIN, null);
    prefs.setString(DIAL_CODE, null);
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

          /*leading: InkWell(
              onTap: (){
                setState(() {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte(_code)));
                  //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Confirm(_code)));
                });
                //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Verification3(_code)));
              },
              child: Icon(Icons.arrow_back_ios,)),
          iconTheme: new IconThemeData(color: couleur_fond_bouton),*/
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
                        child: new Icon(Icons.check, size: 100, color: Colors.green,),//Image.asset('images/Groupee191.png'),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: marge_apres_titre),),

                    text == null?Container():Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: new Text(text,
                            style: TextStyle(
                                color: couleur_titre,
                                fontSize: taille_titre,
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
                        ),),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: pas/2),
                      child: new InkWell(
                        onTap: (){
                          setState(() {
                            init();
                            if(confirm == 'settings'){
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Tontine(_code)));
                            }else{
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte(_code)));
                            }
                            //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Confirm(_code)));
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
                          child: Center(child: new Text("Retourner à l'accueil", style: new TextStyle(color: Colors.white),)),
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