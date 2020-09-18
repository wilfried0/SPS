import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/auth/connexion.dart';
import 'package:services/community/lib/cagnottes/cagnotte1.dart';
import 'package:services/community/lib/tontines/paysctontine.dart';
import 'package:services/community/lib/tontines/tontine.dart';
import 'package:services/composants/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../cagnotte.dart';
import '../search.dart';

final String CHOIX = "CHOIX";
/*
* Informations liées à la création de la cagnotte
* */

final String CATEGORIE = "CATEGORIE";
final String ORIGIN = "ORIGIN";
final String VISIBLE = "VISIBLE";
final String LIBELLE = "LIBELLE";
final String MONTANT_CAGNOTTE = "MONTANT_CAGNOTTE";
final String DATE_CAGNOTTE = "DATE_CAGNOTTE";
final String DIAL_CODE = "DIAL_CODE";
final String FLAG_CAGNOTTE = "FLAG_CAGNOTTE";
final String PRENOM_CAGNOTTE = "PRENOM_CAGNOTTE";
final String NOM_CAGNOTTE = "NOM_CAGNOTTE";
final String PHONE_CAGNOTTE = "PHONE_CAGNOTTE";
final String PHONE_CAGNOTTE_CRE = "PHONE_CAGNOTTE_CRE";
final String DESCRIPTION_CAGNOTTE = "DESCRIPTION_CAGNOTTE";
final String TOKEN = "TOKEN";
final String MONTANT_ENCAISSE = "MONTANT_ENCAISSE";
final String CURRENCYSYMBOL_CONNEXION = "MONTANT_ENCAISSE";
final String MONTANT_OFFRE = "MONTANT_OFFRE";
final String PHONE_OFFRE = "PHONE_OFFRE";
final String COUNTRY_OFFRE = "COUNTRY_OFFRE";
final String USER_PART = "USER_PART";
/**
 * Les infos liées à la contribution de la cagnotte
 * **/
final String ID_KITTY = "ID_KITTY";
final String KITTY_IMAGE = "KITTY_IMAGE";
final String FIRST_NAME_BENEF = "FIRST_NAME_BENEF";
final String LAST_NAME_BENEF = "LAST_NAME_BENEF";
final String END_DATE = "END_DATE";
final String START_DATE = "START_DATE";
final String TITLE = "TITLE";
final String PREVISIONAL_AMOUNT = "PREVISIONAL_AMOUNT";
final String NUMERO_BEN_CAGNOTTE = "NUMERO_BEN_CAGNOTTE";
final String AMOUNT_COLLECTED = "AMOUNT_COLLECTED";
final String DESCRIPTION = "DESCRIPTION";
final String USERNAME = "USERNAME";
final String PARTICIPANT_NUM = "PARTICIPANT_NUM";
final String CURRENCY = "CURRENCY";
final String CURRENCYSYMBOL = "CURRENCYSYMBOL";
final String REMAIN_AMOUNT = "REMAIN_AMOUNT";

final String MONTANT_PART = "MONTANT_PART";
final String PRENOM_PART = "PRENOM_PART";
final String NOM_PART = "NOM_PART";
final String TEL_PART = "TEL_PART";
final String MOTIF_PART = "MOTIF_PART";
final String EMAIL_PART = "EMAIL_PART";
final String MASK_PART = "MASK_PART";
final String CHOIX_PART = "CHOIX_PART";
final String USER_KITTY = "USER_KITTY";
final String TITLE_KITTY = "TITLE_KITTY";


//CREATION TONTINE INFORMATIONS
final String AVATAR_TONTINE = "AVATAR_TONTINE";
final String LIBELLE_TONTINE = "LIBELLE_TONTINE";
final String DELAYTIMES = "DELAYTIMES";
final String PARTICIPATIONDURATION = "PARTICIPATIONDURATION";
final String SANCTION = "SANCTION";
final String CURRENCYSYMBOLT = "CURRENCYSYMBOLT";
final String MONTANT_TONTINE = "MONTANT_TONTINE";
final String DESCRIPTION_TONTINE = "DESCRIPTION_TONTINE";
final String INVITATIONS_TONTINE = "INVITATIONS_TONTINE";
final String INVITATIONS_TONTINE_X = "INVITATIONS_TONTINE_X";
final String INVITATIONS_TONTINE_S = "INVITATIONS_TONTINE_S";
final String STARTDATE_TONTINE = "STARTDATE_TONTINE";
//final String PARTICIP_DURATION_TONTINE = "PARTICIP_DURATION_TONTINE";

final String NOM_TONTINE_X = "NOM_TONTINE_X";
final String DESCRIPTION_TONTINE_x = "DESCRIPTION_TONTINE_x";
final String MONTANT_TONTINE_x = "MONTANT_TONTINE_x";
final String PARTICIP_DURATION_TONTINE_X = "PARTICIP_DURATION_TONTINE_X";
final String CREATION_DATE_TONTINE_X = "CREATION_DATE_TONTINE_X";
final String STARTDATE_TONTINE_X = "STARTDATE_TONTINE_X";
final String DELAYTIMES_TONTINE = "DELAYTIMES_TONTINE";
final String NEXT_CASH_ORDER_TONTINE = "NEXT_CASH_ORDER_TONTINE";
final String OWNER_USER_TONTINE = "OWNER_USER_TONTINE";
final String PARTICIPANTS_X = "PARTICIPANTS_X";
final String DEMANDES_X = "DEMANDES_X";
final String AVATAR_X = "AVATAR_X";
final String ID_TONTINE_X = "ID_TONTINE_X";

// données paiement tontine
final String DESCRIPTION_P = "PARTICIPANTS_X";
final String EMAIL_P = "AVATAR_X";
final String PHONE_P = "ID_TONTINE_X";
final String CONFIRMATION = "CONFIRMATION";
final String ECHEC = "ECHEC";


// ignore: non_constant_identifier_names
final cagnotte_url = /*"https://community.sprint-pay.com/spcommunity/api";*/"http://74.208.183.205:8086/spcommunity/api";
final cagnotte_WebUrl = /*"https://spc.sprint-pay.com/detailcagnottepart";*/"test-spc.sprint-pay.com/detailcagnottepart";
final share_WebUrl = /*"https://community.sprint-pay.com/detailcagnottepart";*/"test-spc.sprint-pay.com/detailcagnottepart";
final tontine_url = /*"https://community.sprint-pay.com/spcommunity-tontine/api";*/"http://74.208.183.205:8086/spcommunity-tontine/api";
final BaseUrlTontine = /*"https://community.sprint-pay.com/spcommunity-tontine";*/"http://74.208.183.205:8086/spcommunity-tontine";
final checkPayUrl = /*"https://community.sprint-pay.com/SpPayment";*/"http://74.208.183.205:8086/SpPayment";

bool search = false;

String values;
Future<void> getAvatar(String _token) async {
  var response = await http.get(Uri.encodeFull("$base_url/user/infosConnectUser"), headers: {"Accept": "application/json", "Authorization": "Bearer $_token"},);
  var info = json.decode(utf8.decode(response.bodyBytes));
  values = "${info['firstname']} ${info['lastname']}^${info['town']}";
}

var current;
// ignore: non_constant_identifier_names
/*Widget getDrawerContent(BuildContext context, GlobalKey<ScaffoldState> _scaffoldKey){
  _lect();
  return Padding();
}



Widget getWidget(String _token, BuildContext context, GlobalKey<ScaffoldState> _scaffold){
  if(_token == null){
    //_scaffold.currentState.openEndDrawer();
    return getDrawerContent(context, _scaffold);
  }else{
    getAvatar(_token);
    return Profile(values.toString());
  }
}

Widget getWidget2(String _token, BuildContext context){
  if(_token == null){
    return Pays();
  }else{
    return Transaction('');
  }
}

Widget getWidgetTontine(int choix, BuildContext context){
  if(choix == 1){
    return Paysc();
  }else{
    return Tontine1('');
  }
}*/

void save() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(CONFIRMATION, "offre");
}

bottomNavigation(BuildContext context, GlobalKey<ScaffoldState> _scaffold, int choix, String token) {
  return new Theme(
    data: Theme.of(context).copyWith(
        canvasColor: orange_F,
        primaryColor: Colors.white,
        textTheme: Theme
            .of(context)
            .textTheme
            .copyWith(caption: new TextStyle(color: Colors.white))
    ),
    child: Padding(
      padding: const EdgeInsets.all(0.0),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0.0,
        items: [
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap:(){
                save();
                if(choix == 1){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte1()));
                }else
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Paysctontine()));
                //Navigator.of(context).push(SlideLeftRoute(enterWidget: news, oldWidget: old));
              },
              child: Container(
                  height: 20,
                  width: 20,
                  child: new Icon(Icons.create_new_folder)),//new Image.asset('images/creer.png')),
            ),
            title: InkWell(
              onTap:(){
                save();
                if(choix == 1){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte1()));
                }else
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Paysctontine()));
              },
              child: Text(choix==1?'Créer cagnotte':'Créer tontine',
                style: TextStyle(
                    fontSize: taille_text_bouton-2,
                    fontWeight: FontWeight.bold
                ),),
            ),
          ),
        /* BottomNavigationBarItem(
            icon: InkWell(
              onTap:(){
                if(token == "null"){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Pays()));
                }else
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Transaction('')));
              },
              child: Container(
                  height: 20,
                  width: 20,
                  child: new Image.asset('images/activity.png')),
            ),
            title: InkWell(
              onTap:(){
                if(token == "null"){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Pays()));
                }else
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Transaction('')));
              },
              child: Text('Activités',
                style: TextStyle(
                    fontSize: taille_text_bouton-1,
                    fontWeight: FontWeight.bold
                ),),
            ),
          ),*/
          BottomNavigationBarItem(
            icon: InkWell(
              onTap:(){
                save();
                search = !search;
                print(search);
                if(choix == 1){
                  if(search == true){
                    Navigator.push(context, MaterialPageRoute(builder:(context)=> Search('')));
                  }else
                    Navigator.push(context, MaterialPageRoute(builder:(context)=> Cagnotte('')));
                }else{
                  if(search == true){
                    Navigator.push(context, MaterialPageRoute(builder:(context)=> Search('')));
                  }else
                    Navigator.push(context, MaterialPageRoute(builder:(context)=> Tontine('')));
                }
              },
              child: Container(
                  height: 20,
                  width: 20,
                  child: search==false?new Icon(Icons.search)/*new Image.asset('images/search.png')*/:Icon(Icons.arrow_back,color: Colors.white,)
              ),
            ),
            title: InkWell(
              onTap:(){
                save();
                search = !search;
                print(search);
                if(search == true){
                  Navigator.push(context, MaterialPageRoute(builder:(context)=> Search('')));
                }else
                  Navigator.push(context, MaterialPageRoute(builder:(context)=> Cagnotte('')));
              },
              child: Text(search == false?'Recherche':'Retour',
                style: TextStyle(
                    fontSize: taille_text_bouton-1,
                    fontWeight: FontWeight.bold
                ),),
            ),
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: (){
                save();
                _scaffold.currentState.openEndDrawer();
              },
              child: Container(
                  height: 20,
                  width: 20,
                  child:
                  new Icon(Icons.person)),
            ),
            title: InkWell(
              onTap:(){
                save();
                _scaffold.currentState.openEndDrawer();
              },
              child: Text('Mon profil',
                style: TextStyle(
                    fontSize: taille_text_bouton-1,
                    fontWeight: FontWeight.bold
                ),),
            ),
          ),
        ],
      ),
    ),
  );
}

void stock(int choix) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(CHOIX, choix.toString());
}


String reversed(String str){
  String nombre="";
  for(int i=str.length-1;i>=0;i--){
    nombre = nombre+str.substring(i, i+1);
  }
  return nombre;
}

String changeAccent(String str){
  String string = str;
  for(int i=0;i<str.length; i++){
    print(str.substring(i));
  }
  return string;
}

Future<void> AlertCon(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: <Widget>[
            Icon(Icons.lock_outline,color: couleur_fond_bouton,),
            Text("Connectez-vous!", style: TextStyle(
                fontSize: taille_libelle_etape,
                color: couleur_fond_bouton
            ),),
          ],
        ),
        content: Text("Votre connexion a expiré, vouhaitez-vous, vous reconnecter",
          style: TextStyle(
            fontSize: taille_champ,
          ),
          textAlign: TextAlign.justify,),
        actions: <Widget>[
          FlatButton(
            child: Text('Annuler'),
            onPressed: () {
              //this.savAll();
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Me connecter'),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Connexion()));
              //Navigator.of(context).push(SlideLeftRoute(enterWidget: Pays(), oldWidget: Configuration('$_code')));
            },
          ),
        ],
      );
    },
  );
}