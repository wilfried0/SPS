import 'dart:convert';
import 'dart:io';
import 'package:page_transition/page_transition.dart';
import 'package:services/auth/service_client.dart';
import 'package:services/community/lib/utils/components.dart';
import 'package:share/share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:services/auth/connexion.dart';
import 'package:shared_preferences/shared_preferences.dart';


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

final GRIS = const Color(0xFFF1F3F9);
// ignore: non_constant_identifier_names
final base_url = /*"https://pcs.sprint-pay.com/corebanking/rest";*/"http://74.208.183.205:8086/corebanking/rest";
final baseUrl = /*"https://pcs.sprint-pay.com/paymentcore/rest/users/contact";*/"http://74.208.183.205:7086/paymentcore/rest/users/contact";
final base = /*"https://kyc.sprint-pay.com/spkyc-identitymanager/uploadFile";*/"http://74.208.183.205:8086/spkyc-identitymanager/uploadFile";
final Nature = /*"https://kyc.sprint-pay.com/spkyc-administration/api/getNatureClientByService/4";*/"http://74.208.183.205:8086/spkycgateway/api/administration/getNatureClientByService/773";
final carte_url = "http://74.208.183.205:8086/sp-tutukacore/api";
final lien_android = "https://play.google.com/store/apps/details?id=sprintpay.services&hl=fr";
final lien_ios = "https://apps.apple.com/ng/app/sprint-pay/id1511300855";
final cond = "https://sprint-pay.com/wp-content/uploads/2018/11/CGU-Afrique-CEMAC-%E2%80%93-Sprint-Pay-2018.pdf";

var current;
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


String getMillis(String amount){
  String reste=amount.split('.')[1];
  if(reste.length>2){
    reste = reste.substring(0, 2);
  }
  amount = reversed(amount.split('.')[0]);
  String nombre="";
  if(amount.length <= 3){
    return reversed(amount)+','+reste;
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

Future<String> getMonSolde(GlobalKey<ScaffoldState> _scaffoldKey, String _username, String _password) async {
  final prefs = await SharedPreferences.getInstance();
  _username = prefs.getString("username");
  _password = prefs.getString("password");
  String sold = "$base_url/transaction/getSoldeUser";
  var bytes = utf8.encode('$_username:$_password');
  var credentials = base64.encode(bytes);
  var headers = {
    "Accept": "application/json",
    "Authorization": "Basic $credentials"
  };
  var response = await http.get(Uri.encodeFull(sold), headers: headers,);
  if(response.statusCode == 200){
    //print(json.decode(response.body));
    //var responseJson = json.decode(utf8.decode(response.bodyBytes));
    //print(responseJson);
    var responseJson = json.decode(response.body);
    print(responseJson);
      return response.body;
  } else {
    showInSnackBar("Service indisponible", _scaffoldKey, 5);
    return null;
  }
}

logOut() async {
  String token;
  final prefs = await SharedPreferences.getInstance();
  token = prefs.getString(TOKEN);
  HttpClient client = new HttpClient();
  client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
  String url = "$cagnotte_url/user/auth/signout";
  HttpClientRequest request = await client.getUrl(Uri.parse(url));
  request.headers.set('Accept', 'application/json');
  request.headers.set('Authorization', 'Bearer $token');
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();
  print("reply $reply");
  prefs.setString(TOKEN, null);
  prefs.setString('nom', null);
  prefs.setString('ville', null);
  prefs.setString('quartier', null);
  prefs.setString('pays', null);
  prefs.setString('avatar', null);
}

void showInSnackBar(String value, GlobalKey<ScaffoldState> _scaffoldKey, int val) {
  _scaffoldKey.currentState.showSnackBar(
      new SnackBar(content: new Text(value,style:
      TextStyle(
          color: Colors.white,
          fontSize: taille_description_champ+3
      ),
        textAlign: TextAlign.center,),
        backgroundColor: couleur_fond_bouton,
        duration: Duration(seconds: val),));
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

bottomNavigate(BuildContext context, int enlev, GlobalKey<ScaffoldState> _scaffoldKey) {
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
                Share.share("Je te recommande de télécharger SprintPay, l'application de transfert d'argent gratuit. $lien_android\n$lien_ios");
              },
              child: Container(
                  height:MediaQuery.of(context).size.width>1000?50: 20,
                  width:MediaQuery.of(context).size.width>1000?50: 20,
                  child: new Icon(Icons.thumb_up, size:MediaQuery.of(context).size.width>1000?50: 25,)
              ),//Image.asset('images/creer.png')),
            ),
            title: GestureDetector(
              onTap:(){
                Share.share("Je te recommande de télécharger SprintPay, l'application de transfert d'argent gratuit. $lien_android\n$lien_ios");
              },
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text('Recommander à un ami',
                  style: TextStyle(
                      fontSize:MediaQuery.of(context).size.width>1000?20: taille_text_bouton,
                      fontWeight: FontWeight.bold,
                      color: orange_F
                  ),),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap:(){
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: ListDisplay()));
              },
              child: Container(
                  height:MediaQuery.of(context).size.width>1000?50: 20,
                  width:MediaQuery.of(context).size.width>1000?50: 20,
                  child: new Icon(Icons.help_outline, size: MediaQuery.of(context).size.width>1000?50:25,)//Image.asset('images/creer.png')),
              ),
            ),
            title: GestureDetector(
              onTap:(){
                //showInSnackBar("Service pas encore disponible!", _scaffoldKey);
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: ListDisplay()));
              },
              child: Text('Service client',
                style: TextStyle(
                    fontSize:MediaQuery.of(context).size.width>1000?20: taille_text_bouton,
                    fontWeight: FontWeight.bold,
                    color: orange_F
                ),),
            ),
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap:(){
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Connexion()));
              },
              child: Container(
                  height:MediaQuery.of(context).size.width>1000?50:20,
                  width:MediaQuery.of(context).size.width>1000?50: 20,
                  child: new Icon(Icons.lock,size: MediaQuery.of(context).size.width>1000?50:25)),//Image.asset('images/creer.png')),
            ),
            title: GestureDetector(
              onTap:(){
                logOut();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Connexion()), (Route<dynamic> route) => false);
                //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Connexion()));
              },
              child: Text('Déconnexion',
                style: TextStyle(
                    fontSize:MediaQuery.of(context).size.width>1000?20: taille_text_bouton,
                    fontWeight: FontWeight.bold,
                    color: orange_F
                ),),
            ),
          ),
        ],
      ),
    ),
  );
}

class getRateAmount {
  final String countryCible;
  final int amount;
  final String deviseLocale;


  getRateAmount({this.countryCible, this.amount, this.deviseLocale});

  getRateAmount.fromJson(Map<String, dynamic> json)
      :
        countryCible = json['countryCible'],
        amount = json['amount'],
        deviseLocale = json['deviseLocale'];

  Map<String, dynamic> toJson() =>
      {
        "countryCible": countryCible,
        "amount": amount,
        "deviseLocale": deviseLocale,
      };
}

class createMemberTemp{
  final String country;
  final String username;
  final String password;

  createMemberTemp({this.country, this.username, this.password});

  createMemberTemp.fromJson(Map<String, dynamic> json)
      : country = json['country'],
        username = json['username'],
        password = json['password'];

  Map<String, dynamic> toJson() =>
      {
        "country": country,
        "username": username,
        "password": password,
      };
}

class getCommission {
  final String typeOperation;
  final String country;
  final int amount;
  final String deviseLocale;


  getCommission({this.typeOperation, this.country, this.amount, this.deviseLocale});

  getCommission.fromJson(Map<String, dynamic> json)
      :typeOperation = json['typeOperation'],
        country = json['country'],
        amount = json['amount'],
        deviseLocale = json['deviseLocale'];

  Map<String, dynamic> toJson() =>
      {
        "typeOperation": typeOperation,
        "country": country,
        "amount": amount,
        "deviseLocale": deviseLocale,
      };
}


class walletTrans {
  final String to;
  final String description;
  final int amount;
  final double fees;
  final String deviseLocale;
  final String toFirstname;
  final String toCountryCode;


  walletTrans({this.to, this.amount, this.fees, this.description, this.deviseLocale, this.toFirstname, this.toCountryCode});

  walletTrans.fromJson(Map<String, dynamic> json)
      :to = json['to'],
        amount = json['amount'],
        fees = json['fees'],
        description = json['description'],
        deviseLocale = json['deviseLocale'],
        toFirstname = json['toFirstname'],
        toCountryCode = json['toCountryCode'];

  Map<String, dynamic> toJson() =>
      {
        "to": to,
        "amount": amount,
        "fees": fees,
        "description": description,
        "deviseLocale": deviseLocale,
        "toFirstname": toFirstname,
        "toCountryCode": toCountryCode,
      };
}

class mtnTrans {
  final String to;
  final String description;
  final int amount;
  final double fees;
  final String deviseLocale;


  mtnTrans({this.to, this.amount, this.fees, this.description, this.deviseLocale});

  mtnTrans.fromJson(Map<String, dynamic> json)
      :to = json['to'],
        amount = json['amount'],
        fees = json['fees'],
        description = json['description'],
        deviseLocale = json['deviseLocale'];

  Map<String, dynamic> toJson() =>
      {
        "to": to,
        "amount": amount,
        "fees": fees,
        "description": description,
        "deviseLocale": deviseLocale,
      };
}

class eucTrans {
  final String to;
  final String description;
  final int amount;
  final double fees;
  final String deviseLocale;
  final String toFirstname;
  final String toCountryCode;
  final String from;
  final String fromFirstname;
  final String fromLastname;


  eucTrans({this.to, this.amount, this.fees, this.description, this.deviseLocale, this.toFirstname, this.toCountryCode, this.from, this.fromFirstname, this.fromLastname});

  eucTrans.fromJson(Map<String, dynamic> json)
      :to = json['to'],
        amount = json['amount'],
        fees = json['fees'],
        description = json['description'],
        deviseLocale = json['deviseLocale'],
        toFirstname = json['toFirstname'],
        toCountryCode = json['toCountryCode'],
        from = json['from'],
        fromFirstname = json['fromFirstname'],
        fromLastname = json['fromLastname'];

  Map<String, dynamic> toJson() =>
      {
        "to": to,
        "amount": amount,
        "fees": fees,
        "description": description,
        "deviseLocale": deviseLocale,
        "toFirstname": toFirstname,
        "toCountryCode": toCountryCode,
        "from": from,
        "fromFirstname": fromFirstname,
        "fromLastname": fromLastname,
      };
}


class orangeTrans {
  final String to;
  final String description;
  final int amount;
  final double fees;
  final String deviseLocale;
  final String successUrl;
  final String failureUrl;


  orangeTrans({this.to, this.amount, this.fees, this.description, this.deviseLocale, this.successUrl, this.failureUrl});

  orangeTrans.fromJson(Map<String, dynamic> json)
      :to = json['to'],
        amount = json['amount'],
        fees = json['fees'],
        description = json['description'],
        deviseLocale = json['deviseLocale'],
        successUrl = json['deviseLocale'],
        failureUrl = json['failureUrl'];

  Map<String, dynamic> toJson() =>
      {
        "to": to,
        "amount": amount,
        "fees": fees,
        "description": description,
        "deviseLocale": deviseLocale,
        "successUrl": successUrl,
        "failureUrl": failureUrl,
      };
}

class paypalTrans {
  final String email;
  final String description;
  final int amount;
  final double fees;
  final String deviseLocale;
  final String successUrl;
  final String failureUrl;


  paypalTrans({this.email, this.amount, this.fees, this.description, this.deviseLocale, this.successUrl, this.failureUrl});

  paypalTrans.fromJson(Map<String, dynamic> json)
      :email = json['email'],
        amount = json['amount'],
        fees = json['fees'],
        description = json['description'],
        deviseLocale = json['deviseLocale'],
        successUrl = json['deviseLocale'],
        failureUrl = json['failureUrl'];

  Map<String, dynamic> toJson() =>
      {
        "email": email,
        "amount": amount,
        "fees": fees,
        "description": description,
        "deviseLocale": deviseLocale,
        "successUrl": successUrl,
        "failureUrl": failureUrl,
      };
}

class RequestCard {
  final String username;
  final String firstName;
  final String lastName;
  final double fees;
  final String idOrPassport;
  final String cellphoneNumber;
  final String expiryDate;
  final int amount;
  final String countryCodeISO3;


  RequestCard({this.username, this.firstName, this.lastName, this.idOrPassport, this.cellphoneNumber, this.expiryDate, this.amount, this.fees, this.countryCodeISO3});

  RequestCard.fromJson(Map<String, dynamic> json)
      :username = json['username'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        idOrPassport = json['idOrPassport'],
        cellphoneNumber = json['cellphoneNumber'],
        expiryDate = json['expiryDate'],
        amount = json['amount'],
        fees = json['fees'],
        countryCodeISO3 = json['countryCodeISO3'];

  Map<String, dynamic> toJson() =>
      {
        "username": username,
        "firstName": firstName,
        "lastName": lastName,
        "idOrPassport": idOrPassport,
        "cellphoneNumber": cellphoneNumber,
        "expiryDate": expiryDate,
        "amount": amount,
        "fees": fees,
        "countryCodeISO3": countryCodeISO3,
      };
}

class yupTrans {
  final String description;
  final int amount;
  final double fees;
  final String deviseLocale;
  final String successUrl;
  final String failureUrl;


  yupTrans({this.amount, this.fees, this.description, this.deviseLocale, this.successUrl, this.failureUrl});

  yupTrans.fromJson(Map<String, dynamic> json)
      :amount = json['amount'],
        fees = json['fees'],
        description = json['description'],
        deviseLocale = json['deviseLocale'],
        successUrl = json['deviseLocale'],
        failureUrl = json['failureUrl'];

  Map<String, dynamic> toJson() =>
      {
        "amount": amount,
        "fees": fees,
        "description": description,
        "deviseLocale": deviseLocale,
        "successUrl": successUrl,
        "failureUrl": failureUrl,
      };
}

class cardTrans {
  final String to;
  final String description;
  final String ipAddress;
  final int amount;
  final double fees;
  final String deviseLocale;
  final String language;
  final String successUrl;
  final String failureUrl;


  cardTrans({this.to, this.amount, this.fees, this.description, this.ipAddress,this.language, this.deviseLocale, this.successUrl, this.failureUrl});

  cardTrans.fromJson(Map<String, dynamic> json)
      :to = json['to'],
        amount = json['amount'],
        fees = json['fees'],
        ipAddress = json['ipAddress'],
        language = json['language'],
        description = json['description'],
        deviseLocale = json['deviseLocale'],
        successUrl = json['deviseLocale'],
        failureUrl = json['failureUrl'];

  Map<String, dynamic> toJson() =>
      {
        "to": to,
        "amount": amount,
        "fees": fees,
        "description": description,
        "ipAddress": ipAddress,
        "language": language,
        "deviseLocale": deviseLocale,
        "successUrl": successUrl,
        "failureUrl": failureUrl,
      };
}

class orangeRetrait {
  final String to;
  final String description;
  final int amount;
  final double fees;
  final String deviseLocale;


  orangeRetrait({this.to, this.amount, this.fees, this.description, this.deviseLocale});

  orangeRetrait.fromJson(Map<String, dynamic> json)
      :to = json['to'],
        amount = json['amount'],
        fees = json['fees'],
        description = json['description'],
        deviseLocale = json['deviseLocale'];

  Map<String, dynamic> toJson() =>
      {
        "to": to,
        "amount": amount,
        "fees": fees,
        "description": description,
        "deviseLocale": deviseLocale,
      };
}

class wariTrans {
  final String to;
  final String description;
  final int amount;
  final double fees;
  final String deviseLocale;
  final String toFirstname;
  final String toLastname;
  final String toCountryCode;
  final String toAdress;
  final String fromCountryISO;
  final String fromCardType;
  final String fromCardNumber;
  final String fromCardIssuingDate;
  final String fromCardExpirationDate;


  wariTrans({this.to, this.amount,this.fees, this.description, this.deviseLocale, this.toFirstname,this.toLastname, this.toCountryCode, this.fromCardExpirationDate, this.fromCardIssuingDate, this.fromCardNumber, this.fromCardType, this.fromCountryISO, this.toAdress});

  wariTrans.fromJson(Map<String, dynamic> json)
      :to = json['to'],
        amount = json['amount'],
        fees = json['fees'],
        description = json['description'],
        deviseLocale = json['deviseLocale'],
        toFirstname = json['toFirstname'],
        toCountryCode = json['toCountryCode'],
        toLastname = json['toLastname'],
        toAdress = json['toAdress'],
        fromCountryISO = json['fromCountryISO'],
        fromCardType = json['fromCardType'],
        fromCardNumber = json['fromCardNumber'],
        fromCardIssuingDate = json['fromCardIssuingDate'],
        fromCardExpirationDate = json['fromCardExpirationDate'];

  Map<String, dynamic> toJson() =>
      {
        "to": to,
        "amount": amount,
        "fees": fees,
        "description": description,
        "deviseLocale": deviseLocale,
        "toFirstname": toFirstname,
        "toCountryCode": toCountryCode,
        "toLastname": toLastname,
        "toAdress": toAdress,
        "fromCountryISO": fromCountryISO,
        "fromCardType": fromCardType,
        "fromCardNumber": fromCardNumber,
        "fromCardIssuingDate": fromCardIssuingDate,
        "fromCardExpirationDate": fromCardExpirationDate,
      };
}

class ATPSTrans {
  final double fees;
  final int amount;
  final String deviseLocale;
  final String description;
  final String to;
  final String toCountryCode;
  final String toLastname;
  final String toFirstname;
  final String toAdress;
  final String toTown;
  final String fromFirstname;
  final String fromLastname;
  final String fromAdress;
  final String fromPlaceOfBith;
  final String fromCardType;
  final String fromCardNumber;
  final String fromCardIssuingDate;
  final String fromCardExpirationDate;


  ATPSTrans({this.to,this.fromFirstname,this.fromPlaceOfBith, this.fromAdress, this.fromLastname, this.amount,this.fees, this.description, this.deviseLocale, this.toFirstname,this.toLastname, this.toCountryCode, this.fromCardExpirationDate, this.fromCardIssuingDate, this.fromCardNumber, this.fromCardType, this.toTown, this.toAdress});

  ATPSTrans.fromJson(Map<String, dynamic> json)
      :to = json['to'],
        amount = json['amount'],
        fees = json['fees'],
        description = json['description'],
        deviseLocale = json['deviseLocale'],
        toFirstname = json['toFirstname'],
        toCountryCode = json['toCountryCode'],
        toLastname = json['toLastname'],
        toAdress = json['toAdress'],
        toTown = json['toTown'],
        fromFirstname = json['fromFirstname'],
        fromPlaceOfBith = json['fromPlaceOfBith'],
        fromLastname = json['fromLastname'],
        fromAdress = json['fromAdress'],
        fromCardType = json['fromCardType'],
        fromCardNumber = json['fromCardNumber'],
        fromCardIssuingDate = json['fromCardIssuingDate'],
        fromCardExpirationDate = json['fromCardExpirationDate'];

  Map<String, dynamic> toJson() =>
      {
        "to": to,
        "amount": amount,
        "fees": fees,
        "description": description,
        "deviseLocale": deviseLocale,
        "toFirstname": toFirstname,
        "toCountryCode": toCountryCode,
        "toLastname": toLastname,
        "fromFirstname": fromFirstname,
        "fromLastname": fromLastname,
        "fromPlaceOfBith": fromPlaceOfBith,
        "fromAdress": fromAdress,
        "toAdress": toAdress,
        "toTown": toTown,
        "fromCardType": fromCardType,
        "fromCardNumber": fromCardNumber,
        "fromCardIssuingDate": fromCardIssuingDate,
        "fromCardExpirationDate": fromCardExpirationDate,
      };
}

class BRMCashTrans {
  final double fees;
  final int amount;
  final String deviseLocale;
  final String description;
  final String type;
  final String to;
  final String toCountryCode;
  final String fromCountryCode;
  final String toLastname;
  final String toFirstname;
  final String toAdress;
  final String toTown;
  final String fromTown;
  final String fromFirstname;
  final String fromLastname;
  final String fromAdress;


  BRMCashTrans({this.to, this.amount,this.fees, this.description, this.deviseLocale, this.toFirstname,this.toLastname, this.toCountryCode, this.type, this.fromAdress, this.fromFirstname, this.fromLastname, this.fromTown, this.toAdress, this.toTown, this.fromCountryCode});

  BRMCashTrans.fromJson(Map<String, dynamic> json)
      :to = json['to'],
        amount = json['amount'],
        fees = json['fees'],
        description = json['description'],
        deviseLocale = json['deviseLocale'],
        toFirstname = json['toFirstname'],
        toCountryCode = json['toCountryCode'],
        toLastname = json['toLastname'],
        toAdress = json['toAdress'],
        toTown = json['toTown'],
        fromTown = json['fromTown'],
        fromCountryCode = json['fromCountryCode'],
        fromLastname = json['fromLastname'],
        fromFirstname = json['fromFirstname'],
        type = json['type'],
        fromAdress = json['fromAdress'];

  Map<String, dynamic> toJson() =>
      {
        "to": to,
        "amount": amount,
        "fees": fees,
        "description": description,
        "deviseLocale": deviseLocale,
        "toFirstname": toFirstname,
        "toCountryCode": toCountryCode,
        "toLastname": toLastname,
        "toAdress": toAdress,
        "toTown": toTown,
        "fromTown": fromTown,
        "fromCountryCode": fromCountryCode,
        "fromLastname": fromLastname,
        "fromFirstname": fromFirstname,
        "type": type,
        "fromAdress": fromAdress,
      };
}


class BRMAccountTrans {
  final double fees;
  final int amount;
  final String deviseLocale;
  final String description;
  final String type;
  final String to;
  final String toCountryCode;
  final String fromCountryCode;
  final String toLastname;
  final String toFirstname;
  final String toAdress;
  final String toTown;
  final String fromTown;
  final String fromFirstname;
  final String fromLastname;
  final String fromAdress;
  final String accountNumber;
  final String bankName;


  BRMAccountTrans({this.to,this.accountNumber, this.bankName, this.amount,this.fees, this.description, this.deviseLocale, this.toFirstname,this.toLastname, this.toCountryCode, this.type, this.fromAdress, this.fromFirstname, this.fromLastname, this.fromTown, this.toAdress, this.toTown, this.fromCountryCode});

  BRMAccountTrans.fromJson(Map<String, dynamic> json)
      :to = json['to'],
        amount = json['amount'],
        fees = json['fees'],
        accountNumber = json['accountNumber'],
        bankName = json['bankName'],
        description = json['description'],
        deviseLocale = json['deviseLocale'],
        toFirstname = json['toFirstname'],
        toCountryCode = json['toCountryCode'],
        toLastname = json['toLastname'],
        toAdress = json['toAdress'],
        toTown = json['toTown'],
        fromTown = json['fromTown'],
        fromCountryCode = json['fromCountryCode'],
        fromLastname = json['fromLastname'],
        fromFirstname = json['fromFirstname'],
        type = json['type'],
        fromAdress = json['fromAdress'];

  Map<String, dynamic> toJson() =>
      {
        "to": to,
        "amount": amount,
        "fees": fees,
        "description": description,
        "deviseLocale": deviseLocale,
        "toFirstname": toFirstname,
        "toCountryCode": toCountryCode,
        "toLastname": toLastname,
        "toAdress": toAdress,
        "toTown": toTown,
        "fromTown": fromTown,
        "fromCountryCode": fromCountryCode,
        "fromLastname": fromLastname,
        "fromFirstname": fromFirstname,
        "type": type,
        "fromAdress": fromAdress,
        "bankName": bankName,
        "accountNumber": accountNumber,
      };
}


class contact {
  final String username;

  contact({this.username});

  contact.fromJson(Map<String, dynamic> json)
      :username = json['username'];

  Map<String, dynamic> toJson() =>
      {
        "username": username
      };
}

//MarketPlace

Widget getMoyen(int index, BuildContext context, int indik) {
  String text, img;
  switch (index) {
    case 1:
      text = "SPRINTPAY";
      img = 'marketimages/sprintpay.png';
      break;
    case 5:
      text = "CARTE PAYPAL";
      img = 'images/paypal.jpg';
      break;
    case 2:
      text = "ORANGE";
      img = 'images/orange.png';
      break;
    case 3:
      text = "MTN";
      img = 'images/mtn.jpg';
      break;
    case 4:
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
      color: index - 1 == indik ? orange_F : bleu_F,
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


double getHeight(int index) {
  switch (index) {
    case 1:
      return 555;
    case 2:
      return 500;
    case 3:
      return 500;
    case 4:
      return 500;
    case 5:
      return 500;
  }
}