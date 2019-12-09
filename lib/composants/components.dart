import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


// ignore: non_constant_identifier_names
final couleur_titre = const Color(0xFF747474);
// ignore: non_constant_identifier_names
final bleu_F = const Color(0xFF2A2A42);
// ignore: non_constant_identifier_names
final taille_titre = 25.0;
// ignore: non_constant_identifier_names
final police_titre = 'Poppins-Bold';
// ignore: non_constant_identifier_names
final interligne_titre = 40.0;
// ignore: non_constant_identifier_names
final marge_apres_titre = 30.0;

// ignore: non_constant_identifier_names
final orange_F = const Color(0xFFfa9800);

// ignore: non_constant_identifier_names
final police_description_page = 'Poppins-Medium';
// ignore: non_constant_identifier_names
final taille_description_page = 16.0;
// ignore: non_constant_identifier_names
final interligne_description_page = 25.0;
// ignore: non_constant_identifier_names
final couleur_decription_page = const Color(0xFFB8B8B8);
// ignore: non_constant_identifier_names
final marge_apres_description_page = 16.0;
// ignore: non_constant_identifier_names
final police_libelle_etape = 'Poppins-SemiBold';
// ignore: non_constant_identifier_names
final taille_libelle_etape = 16.0;
// ignore: non_constant_identifier_names
final interligne_libelle_etape = 25.0;
// ignore: non_constant_identifier_names
final couleur_libelle_etape = const Color(0xFF535C9A);
// ignore: non_constant_identifier_names
final police_libelle_champ = 'Poppins-Medium';
// ignore: non_constant_identifier_names
final taille_libelle_champ = 12.0;
// ignore: non_constant_identifier_names
final interligne_libelle_champ = 18.0;
// ignore: non_constant_identifier_names
final couleur_libelle_champ = const Color(0xFF747474);
// ignore: non_constant_identifier_names
final marge_bas_libelle_champ = 5.0;
// ignore: non_constant_identifier_names
final marge_droit_icone = 15.0;
// ignore: non_constant_identifier_names
final police_description_champ = 'Poppins-Regular';
// ignore: non_constant_identifier_names
final taille_description_champ = 10.0;
// ignore: non_constant_identifier_names
final interligne_description_champ = 13.0;
// ignore: non_constant_identifier_names
final marge_bas_description_champ = 10.0;
// ignore: non_constant_identifier_names
final couleur_description_champ = const Color(0xFFB8B8B8);
// ignore: non_constant_identifier_names
final police_champ = 'Poppins-Medium';
// ignore: non_constant_identifier_names
final taille_champ = 12.0;
// ignore: non_constant_identifier_names
final interligne_champ = 18.0;
// ignore: non_constant_identifier_names
final couleur_champ = const Color(0xFFD8D8D8);
// ignore: non_constant_identifier_names
final couleur_appbar = const Color(0xFFfafafa);
// ignore: non_constant_identifier_names
final largeur_champ = 290.0;
// ignore: non_constant_identifier_names
final hauteur_champ = 50.0;
// ignore: non_constant_identifier_names
final courbure = 8.0;
// ignore: non_constant_identifier_names
final bordure = .5;
// ignore: non_constant_identifier_names
final couleur_bordure = const Color(0xFF747474);
// ignore: non_constant_identifier_names
final marge_bas = 30.0;
// ignore: non_constant_identifier_names
final marge_interieur_champ = 15.0;
// ignore: non_constant_identifier_names
final marge_apres_logo = 35.0;
// ignore: non_constant_identifier_names
final marge_avant_logo = 5.0;
// ignore: non_constant_identifier_names
final hauteur_logo = 60.0;
// ignore: non_constant_identifier_names
final police_bouton = 'Poppins-Medium';
// ignore: non_constant_identifier_names
final taille_text_bouton = 12.0;
// ignore: non_constant_identifier_names
final interligne_bouton = 18.0;
// ignore: non_constant_identifier_names
final couleur_text_bouton = const Color(0xFFFFFFFF);
// ignore: non_constant_identifier_names
final couleur_fond_bouton = const Color(0xFF535C9A);
// ignore: non_constant_identifier_names
final marge_bas_bouton = 30.0;
// ignore: non_constant_identifier_names
final hauteur_bouton = 50.0;
// ignore: non_constant_identifier_names
final largeur_bouton = 290.0;
// ignore: non_constant_identifier_names
final courbure_bouton = 8.0;
// ignore: non_constant_identifier_names
final marge_apres_champ = 20.0;
// ignore: non_constant_identifier_names
final marge_libelle_champ = 5.0;
// ignore: non_constant_identifier_names
double marge_champ_libelle = 20.0;
// ignore: non_constant_identifier_names
final base_url = "http://74.208.183.205:8086/corebanking/rest/member";//"http://192.168.45.145:8080/negprod/api";
final baseUrl = "http://serveless-spc-app.s3-website.eu-west-3.amazonaws.com/detailcagnottepart";

bool search = false;

var current;
String reversed(String str){
  String nombre="";
  for(int i=str.length-1;i>=0;i--){
    nombre = nombre+str.substring(i, i+1);
  }
  return nombre;
}

String getMillis(String amount){
  String reste=amount.split('.')[1];
  amount = reversed(amount.split('.')[0]);
  String nombre="";
  if(amount.length <= 3){
    return reversed(amount);
  }else
  if(amount.length == 4){
    for(int i=amount.length-1;i>=0;i--){
      nombre = nombre+amount.substring(i, i+1);
      if(i==amount.length-1){
        nombre = nombre+'.';
      }else{
      }
    }
  }else
    for(int i=amount.length-1;i>=0;i--){
      nombre = nombre+amount.substring(i, i+1);
      if(i==0 || i==amount.length-1){
      }else{
        if((i)%3 == 0){
          nombre = nombre+'.';
        }
      }
    }
  return nombre.toString()+','+reste;
}

String values;
Future<void> getAvatar(String _token) async {
  var response = await http.get(Uri.encodeFull("$base_url/user/infosConnectUser"), headers: {"Accept": "application/json", "Authorization": "Bearer $_token"},);
  var info = json.decode(utf8.decode(response.bodyBytes));
  values = "${info['firstname']} ${info['lastname']}^${info['town']}";
}


final barreBottom = BottomAppBar(
  child: Container(
    height: 5.0,
    color: Colors.transparent,
    child: Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Container(color: bleu_F,height: 5.0,),
        ),
        Expanded(
          flex: 2,
          child: Container(color: orange_F,height: 5.0,),
        )
      ],
    ),
  ),
);

final barreTop = Row(
  children: <Widget>[
    Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.only(top: 23.0),
        child: Container(color: orange_F,height: 5.0,),
      ),
    ),
    Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.only(top: 23.0),
        child: Container(color: bleu_F,height: 5.0,),
      ),
    )
  ],
);

bottomNavigate(BuildContext context, int enlev) {
  return new Theme(
    data: Theme.of(context).copyWith(
        canvasColor: bleu_F,
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
              },
              child: Container(
                  height: 20,
                  width: 20,
                  child: new Icon(Icons.person,
                    color: orange_F,)),//Image.asset('images/creer.png')),
            ),
            title: GestureDetector(
              onTap:(){
              },
              child: Text("Accueil",
                style: TextStyle(
                    fontSize: taille_text_bouton-enlev,
                    fontWeight: FontWeight.bold,
                  color: orange_F,
                ),),
            ),
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap:(){
              },
              child: Container(
                  height: 20,
                  width: 20,
                  child: new Icon(Icons.thumb_up)
              ),//Image.asset('images/creer.png')),
            ),
            title: GestureDetector(
              onTap:(){
              },
              child: Text('Recommander à un ami',
                style: TextStyle(
                    fontSize: taille_text_bouton-enlev,
                    fontWeight: FontWeight.bold
                ),),
            ),
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap:(){
              },
              child: Container(
                  height: 20,
                  width: 20,
                  child: new Icon(Icons.help_outline)//Image.asset('images/creer.png')),
              ),
            ),
            title: GestureDetector(
              onTap:(){
              },
              child: Text('Service client',
                style: TextStyle(
                    fontSize: taille_text_bouton-enlev,
                    fontWeight: FontWeight.bold
                ),),
            ),
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap:(){
                print("hello");
                //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: news1));
              },
              child: Container(
                  height: 20,
                  width: 20,
                  child: new Icon(Icons.lock)),//Image.asset('images/creer.png')),
            ),
            title: GestureDetector(
              onTap:(){
                print("hello");
                //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: news1));
              },
              child: Text('Déconnexion',
                style: TextStyle(
                    fontSize: taille_text_bouton-enlev,
                    fontWeight: FontWeight.bold
                ),),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _Drawer(BuildContext context){
  return Drawer(
      elevation: 20.0,
      child: new ListView(
        padding: EdgeInsets.zero,
        children: <Widget> [
          Container(
            height: 140,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage('images/banner.jpg'),
                  fit: BoxFit.cover,
                )),
          ),

          new ListTile(
            title: Padding(
              padding: EdgeInsets.only(left: 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex:1,
                      child: Icon(Icons.home)),//Image.asset("images/Groupe12.png")),
                  Expanded(
                    flex:11,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: new Text('Retour à l\'accueil',style: TextStyle(
                          color: bleu_F,
                          fontWeight: FontWeight.bold,
                          fontFamily: police_titre
                      ),),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Pays()));
              //Navigator.pop(context);
            },
          ),

          Padding(
            padding: EdgeInsets.only(left: 20),
            child: new Divider(
              color: couleur_champ,
            ),
          ),

          new ListTile(
            title: Padding(
              padding: EdgeInsets.only(left: 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex:1,
                    child: Image.asset("images/Groupe3.png",height: 50,width: 50,),
                  ),
                  Expanded(
                    flex:11,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: new Text('Tarifs',style: TextStyle(
                          color: bleu_F,
                          fontWeight: FontWeight.bold,
                          fontFamily: police_titre
                      ),),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {},
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: new Divider(
              color: couleur_champ,
            ),
          ),

          new ListTile(
            title: Padding(
              padding: EdgeInsets.only(left: 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex:1,
                      child: Image.asset("images/Groupe11.png")),
                  Expanded(
                    flex:11,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: new Text('Comment ça marche',style: TextStyle(
                          color: bleu_F,
                          fontWeight: FontWeight.bold,
                          fontFamily: police_titre
                      ),),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {},
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: new Divider(
              color: couleur_champ,
            ),
          ),
          new ListTile(
            title: Padding(
              padding: EdgeInsets.only(left: 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex:1,
                      child: Image.asset("images/trace3.png")),
                  Expanded(
                    flex:11,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: new Text('A propos',style: TextStyle(
                          color: bleu_F,
                          fontWeight: FontWeight.bold,
                          fontFamily: police_titre
                      ),),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {},
          ),

          Padding(
            padding: EdgeInsets.only(left: 20),
            child: new Divider(
              color: couleur_champ,
            ),
          ),

          new ListTile(
            title: Padding(
              padding: EdgeInsets.only(left: 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex:1,
                      child: Image.asset("images/ic_deconnexion.png")),
                  Expanded(
                    flex:11,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: new Text('Connexion',style: TextStyle(
                          color: bleu_F,
                          fontWeight: FontWeight.bold,
                          fontFamily: police_titre
                      ),),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Pays()));
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: new Divider(
              color: couleur_champ,
            ),
          ),

          new ListTile(
            title: Padding(
              padding: EdgeInsets.only(left: 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex:1,
                      child: Image.asset("images/ic_contact_service.png")),
                  Expanded(
                    flex:11,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: new Text('Service client',style: TextStyle(
                          color: bleu_F,
                          fontWeight: FontWeight.bold,
                          fontFamily: police_titre
                      ),),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: new Divider(
              color: couleur_champ,
            ),
          ),

          new ListTile(
            title: Padding(
              padding: EdgeInsets.only(left: 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex:1,
                      child: Image.asset("images/ic_conditions.png")),
                  Expanded(
                    flex:11,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: new Text('Conditions générales d\'utilisation',style: TextStyle(
                          color: bleu_F,
                          fontWeight: FontWeight.bold,
                          fontFamily: police_titre
                      ),),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: new Divider(
              color: couleur_champ,
            ),
          ),
        ],
      )
  );
}