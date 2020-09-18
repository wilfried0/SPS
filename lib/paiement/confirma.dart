import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:services/auth/profile.dart';
import 'package:services/composants/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class Confirma extends StatefulWidget {
  Confirma(this._code);
  String _code;

  @override
  _ConfirmaState createState() => new _ConfirmaState(_code);
}

class _ConfirmaState extends State<Confirma> {

  _ConfirmaState(this._code);
  String _code, text, notif, lir, img;

  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(_code == "recharge"){//rechage
      text = "recharge";
      notif = "Votre recharge s'est effectuée avec succès!";
      img = "growth.png";
      this.save();
    }else if(_code == "transfert"){//transfert
      text = "transfert";
      notif = "Votre transfert s'est effectué avec succès!";
      img = "payment-method.png";
      this.save();
    }else if(_code == "retrait"){//retrait
      text = "retrait";
      notif = "Votre retrait s'est effectué avec succès!";
      img = "hand.png";
      this.save();
    }else if(_code == "cartep"){//retrait
      text = "commande";
      notif = "Votre commande s'est effectué avec succès!";
      img = "credit-card-2.png";
      this.save();
    }else if(_code == "cartev"){//retrait
      text = "commande";
      notif = "Votre commande s'est effectué avec succès!";
      img = "credit-card.png";
      this.save();
    }else{
      text = "Votre opération s'est effectuée avec succès!";
      img = "exchange.png";
    }
  }

  void save() async {
    final prefs = await SharedPreferences.getInstance();
    if(notif != null){
      if(lir != null){
        prefs.setString('notif', "$lir^$notif");
        lir = null;
        notif = null;
      }else{
        prefs.setString('notif', "$notif");
        notif = null;
      }
    }
  }


  @override
  Widget build(BuildContext context) {

    final espace = (MediaQuery.of(context).size.height - 533.3333333333334)<0?0.0:MediaQuery.of(context).size.height - 533.3333333333334;
    final pas = (MediaQuery.of(context).size.height - 533.3333333333334)<0?0.0:42.0;

    return new Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: new AppBar(
          title: Text('',style: TextStyle(
            color: couleur_titre,
            fontSize: taille_libelle_etape,
          ),),
          elevation: 0.0,
          backgroundColor: couleur_appbar,
          flexibleSpace: barreTop,
          leading: Container(),
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
                    padding: EdgeInsets.only(top: marge_apres_logo),),

                  Padding(
                      padding: EdgeInsets.only(top:(espace - 65)>0?(espace-65)/2:0.0,)),

                  Container(
                    child: CircleAvatar(
                      backgroundColor: couleur_champ,
                      radius: 70.0,
                      child: Container(
                        height: 70,
                          width: 70,
                          child: new Image.asset('images/$img')),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: marge_apres_titre),),

                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: new Text(text=="recharge"?'Votre $text a été\neffectuée avec succès!':'Votre $text a été\neffectué avec succès!',
                          style: TextStyle(
                              color: couleur_titre,
                              fontSize: taille_titre,
                              fontWeight: FontWeight.bold
                          )),
                    ),
                  ),


                  Padding(
                    padding: EdgeInsets.only(left:20.0, top:20.0, right: 20),
                    child: new Text("Cliquez pour retourner à l'accueil Sprint Pay Services.",
                      style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_description_page-2,
                      ),),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: pas/2),
                    child: new GestureDetector(
                      onTap: (){
                        setState(() {
                          init();
                          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Profile(_code)));
                          //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Confirma(_code)));
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
                        child: Center(child: new Text("Retourner à l'accueil", style: new TextStyle(fontSize: taille_text_bouton+3, color: Colors.white),)),
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

  init() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("prenomt", null);
    prefs.setString("prenomf", null);
    prefs.setString("nomt", null);
    prefs.setString("nomf", null);
    prefs.setString("adressed", null);
    prefs.setString("adressef", null);
    prefs.setString("villef", null);
    prefs.setString("villed", null);
    prefs.setString("nomd", null);
  }
}