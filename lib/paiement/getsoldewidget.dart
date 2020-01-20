import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:services/composants/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

class getSoldeWidget extends StatefulWidget {
  @override
  _getSoldeWidgetState createState() => _getSoldeWidgetState();
}

class _getSoldeWidgetState extends State<getSoldeWidget> {

  String deviseLocale, devise, solde, local, _username, _password;

  @override
  void initState(){
    super.initState();
    this.getSolde();
  }

  Future<void> getSolde() async {
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
      print(response.body);
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        solde = "${responseJson['amount']}";
        devise = " ${responseJson['devise']}";
        local = "${responseJson['amountLocale']}";
        deviseLocale = "${responseJson['deviseLocale']}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 35, ),//solde du compte
      child:deviseLocale=='EUR'? Column(
        children: <Widget>[
          Text('SOLDE', style: TextStyle(
              color: Colors.white,
              fontSize: taille_libelle_etape,
              fontWeight: FontWeight.bold
          ),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(solde==null?"0,0":"${getMillis('$solde')}", style: TextStyle(//Montant du solde
                  color: orange_F,
                  fontSize: taille_titre-5,
                  fontWeight: FontWeight.bold
              ),),
              Text(devise==null?" EUR":" $devise", style: TextStyle(//Montant du solde
                  color: orange_F,
                  fontSize: taille_titre-5,
                  fontWeight: FontWeight.bold
              ),),
            ],
          ),
        ],
      )
          :Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Column(
              children: <Widget>[
                Text('SOLDE', style: TextStyle(
                    color: Colors.white,
                    fontSize: taille_libelle_etape,
                    fontWeight: FontWeight.bold
                ),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(solde==null?"0,0":"${getMillis('$solde')}", style: TextStyle(//Montant du solde
                        color: orange_F,
                        fontSize: taille_titre-5,
                        fontWeight: FontWeight.bold
                    ),),
                    Text(devise==null?" EUR":" $devise", style: TextStyle(//Montant du solde
                        color: orange_F,
                        fontSize: taille_titre-5,
                        fontWeight: FontWeight.bold
                    ),),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            flex: 6,
            child: Column(
              children: <Widget>[
                Text('MONNAIE LOCALE', style: TextStyle(
                    color: Colors.white,
                    fontSize: taille_libelle_etape,
                    fontWeight: FontWeight.bold
                ),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(local==null?"0,0":getMillis('$local'), style: TextStyle(//Montant du solde
                        color: orange_F,
                        fontSize: taille_titre-5,
                        fontWeight: FontWeight.bold
                    ),),
                    Text(deviseLocale==null?" XAF":" $deviseLocale", style: TextStyle(//Montant du solde
                        color: orange_F,
                        fontSize: taille_titre-5,
                        fontWeight: FontWeight.bold
                    ),),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
