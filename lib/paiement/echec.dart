import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:services/auth/profile.dart';
import 'package:services/composants/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class Echec extends StatefulWidget {
  Echec(this._code);
  String _code;

  @override
  _EchecState createState() => new _EchecState(_code);
}

class _EchecState extends State<Echec> {

  _EchecState(this._code);
  String _code, sms, echec, notif, lir, img;

  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    this.lire();
    if(_code.split('^').last == '§'){
      sms = "Désolé!\nEchec du retrait!";
      notif = "Votre retrait a échoué!";
      img = "hand.png";
      this.save();
    } else if(_code.split('^').last == '&'){
      sms = "Désolé!\nEchec de la recharge!";
      notif = "Votre recharge a échouée!";
      img = "growth.png";
      this.save();
    } else if(_code.split('^').last == 't'){
      sms = "Désolé!\nEchec du transfert!";
      notif = "Votre transfert a échoué!";
      img = "payment-method.png";
      this.save();
    }else if(_code.split('^').last == 'c'){
      sms = "Désolé!\nEchec de la commande!";
      notif = "Votre commande de la carte prépayée a échoué!";
      img = "credit-card-2.png";
      this.save();
    }else if(_code.split('^').last == 'v'){
      sms = "Désolé!\nEchec de la commande!";
      notif = "Votre commande de la carte prépayée a échoué!";
      img = "credit-card.png";
      this.save();
    } else{
      sms = "Désolé!\nVotre participation n'a été enregistrée!";
      img = "exchange.png";
    }
    this._lire();
  }

  lire() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      echec = prefs.getString("echec");
    });
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

  _lire() async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getString("notif")!=null && prefs.getString("notif")!= "null")
      lir = prefs.getString("notif");
  }

  @override
  Widget build(BuildContext context) {

    //final espace = (MediaQuery.of(context).size.height - 533.3333333333334)<0?0.0:MediaQuery.of(context).size.height - 533.3333333333334;
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
          leading: Container(),)
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
                      child: new Text(sms,
                          style: TextStyle(
                              color: couleur_titre,
                              fontSize: taille_titre,
                              fontWeight: FontWeight.bold
                          )),
                    ),
                  ),

                  /*echec==null?Container():Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Center(
                      child: new Text("Motif: $echec",
                          style: TextStyle(
                              color: couleur_titre,
                              fontSize: taille_champ,
                              fontWeight: FontWeight.normal
                          )),
                    ),
                  ),*/

                  Padding(
                    padding: EdgeInsets.only(left:20.0, top:20.0, right: 20),
                    child: new Text("Cliquez pour retourner à l'accueil Sprint Pay",
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