import 'package:flutter/material.dart';

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

double getHeight(int index) {
  switch (index) {
    case 1:
      return 500;
    case 2:
      return 400;
    case 3:
      return 450;
    case 4:
      return 450;
  }
}

Widget getMoyen(int index, BuildContext context, int indik) {
  String text, img;
  switch (index) {
    case 1:
      text = "SPRINTPAY";
      img = 'marketimages/sprintpay.png';
      break;
    case 2:
      text = "CARTE BANCAIRE";
      img = 'marketimages/carte.jpg';
      break;
    case 3:
      text = "ORANGE";
      img = 'images/orange.png';
      break;
    case 4:
      text = "MTN";
      img = 'images/mtn.jpg';
      break;
    case 5:
      text = "YUP";
      img = 'marketimages/yup.jpg';
      break;
  }
  return Container(
    width: MediaQuery.of(context).size.width,
    margin: EdgeInsets.symmetric(horizontal: 5.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
        bottomRight: Radius.circular(10.0),
        bottomLeft: Radius.circular(10.0),
      ),
      border: Border.all(color: index - 1 == indik ? orange_F : bleu_F),
      color: index - 1 == indik ? Colors.white : bleu_F,
    ),
    child: Padding(
      padding: EdgeInsets.only(top: 0),
      child: Column(
        children: <Widget>[
          Container(
            height: 73,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                ),
                image: DecorationImage(
                  image: AssetImage('$img'),
                  fit: BoxFit.cover,
                )),
          ),
          /*Padding(
              padding: EdgeInsets.only(top: 10),
              child: index-1!=indik? Text('$text',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold
                ),):Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('$text',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold
                    ),),
                  Icon(Icons.check, color: Colors.white,)
                ],
              ),
            )*/
        ],
      ),
    ),
  );
}

Widget getMoyen2(int index, BuildContext context, int indik) {
  String img;
  switch (index) {
    case 1:
      img = 'pub1.jpg';
      break;
    case 2:
      img = 'pub2.jpg';
      break;
    case 3:
      img = 'pub3.jpg';
      break;
    case 4:
      img = 'pub4.jpg';
      break;
    case 5:
      img = 'pub5.jpg';
      break;
  }
  return Container(
    width: MediaQuery.of(context).size.width,
    margin: EdgeInsets.symmetric(horizontal: 5.0),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
        ),
        border: Border.all(color: Colors.transparent),
        color: Colors.transparent),
    child: Padding(
      padding: EdgeInsets.only(top: 0),
      child: Column(
        children: <Widget>[
          Container(
            height: 298,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                ),
                image: DecorationImage(
                  image: AssetImage('marketimages/$img'),
                  fit: BoxFit.cover,
                )),
          ),
          /*Padding(
              padding: EdgeInsets.only(top: 10),
              child: index-1!=indik? Text('$text',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold
                ),):Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('$text',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold
                    ),),
                  Icon(Icons.check, color: Colors.white,)
                ],
              ),
            )*/
        ],
      ),
    ),
  );
}

Future<void> notConnection(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Oops!'),
        content: Text("Vérifier votre connexion internet."),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}