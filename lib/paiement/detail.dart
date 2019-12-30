import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:page_transition/page_transition.dart';
import 'package:services/composants/components.dart';
import 'package:services/composants/services.dart';
import 'package:services/paiement/encaisser1.dart';
import 'package:services/paiement/historique.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:services/paiement/retrait1.dart';
import 'dart:async';

import 'package:services/paiement/transfert3.dart';
import 'package:shared_preferences/shared_preferences.dart';


// ignore: must_be_immutable
class Detail extends StatefulWidget {
  Detail(this._code);
  String _code;
  @override
  _DetailState createState() => new _DetailState(_code);
}

class _DetailState extends State<Detail> with SingleTickerProviderStateMixin {
  _DetailState(this._code);
  String _code;
  Future<Login> post;
  int currentPage = 0, choix;
  String _token, solde, idUser, userImage, deviseLocale, _fromCountry, _toCountry, _serviceName, _name, _amount, _fees, _status, _nature, _transactionid, _date, _payst, _paysf;
  bool isLoding = false, loadImage = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int recenteLenght = 3, archiveLenght = 3, populaireLenght =3, nb;
  int flex4, flex6, taille, enlev, rest, enlev1, enl;
  double haut, _taill,topi, bottomsolde,sold,topo22,top33, top34, top1, top, top2, top3,top4, topo1, topo2, hauteurcouverture, nomright, nomtop, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext;
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState(){
    super.initState();
    this.read();
  }


  read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _payst = prefs.getString("payst");
      _paysf = prefs.getString("paysf");
      _serviceName = prefs.getString("serviceName");
      _name = prefs.getString("named");
      _amount = prefs.getString("montant");
      _fees = prefs.getString("fees");
      _status = prefs.getString("status");
      _nature = prefs.getString("nature");
      _transactionid = prefs.getString("transactionid");
      _date = prefs.getString("date");
      print("la _date: $_date");
      deviseLocale = prefs.getString("deviseLocale");
    });
  }

  String getMonth(String date){
    String mois;
    switch(int.parse(date.split("-")[1])){
      case 1: mois = "Janvier";break;
      case 2: mois = "Février";break;
      case 3: mois = "Mars";break;
      case 4: mois = "Avril";break;
      case 5: mois = "Mai";break;
      case 6: mois = "Juin";break;
      case 7: mois = "Juillet";break;
      case 8: mois = "Août";break;
      case 9: mois = "Septembre";break;
      case 10: mois = "Octobre";break;
      case 11: mois = "Novembre";break;
      case 12: mois = "Décembre";break;
    }
    return "${date.split("-")[0]} $mois ${date.split("-")[2]}";
  }

  String getStatus(String status){
    String _status;
    if(status == "PROCESSED")
      _status = "Approuvé";
    else
      _status = "Echoué";
    return _status;
  }

  String getNature(String nature){
    String _nature = "";
    if(nature == "WALLET_TO_WALLET" || nature == "WALLET_TO_WARI"){
      _nature = "Transfert d'argent";
    }else if(nature == "EU_TO_WALLET" || nature == "CARD_TO_WALLET" || nature == "OM_TO_WALLET" || nature == "MOMO_TO_WALLET"){
      _nature = "Recharge d'argent";
    }else if(nature == "WALLET_TO_MOMO" || nature == "WALLET_TO_OM"){
      _nature = "Retrait d'argent";
    }
    return _nature;
  }

  String getMoyen(String nature){
    String _nature = "";
    if(nature == "WALLET_TO_WALLET"){
      _nature = "Wallet SprintPay";
    }else if(nature == "EU_TO_WALLET"){
      _nature = "Express Union";
    }else if(nature == "CARD_TO_WALLET"){
      _nature = "Carte bancaire";
    }else if(nature == "OM_TO_WALLET" || nature == "WALLET_TO_OM"){
      _nature = "Orange Money";
    }else if(nature == "MOMO_TO_WALLET" || nature == "WALLET_TO_MOMO"){
      _nature = "MTN Mobile Money";
    }else if(nature == "WALLET_TO_WARI"){
      _nature = "Wari";
    }
    return _nature;
  }


  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text(value,style:
        TextStyle(
            color: Colors.white,
            fontSize: taille_description_champ
        ),
          textAlign: TextAlign.center,),
          backgroundColor: couleur_fond_bouton,
          duration: Duration(seconds: 5),));
  }


  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final _large = MediaQuery.of(context).size.width;
    final _haut = MediaQuery.of(context).size.height;
    double fromHeight, leftcagnotte, rightcagnotte, topcagnotte, bottomcagnotte;
    if(_large<=320){
      fromHeight = 120;
      leftcagnotte = 20;
      rightcagnotte = 30;
      topcagnotte = 50; //espace entre mes tabs et le slider
      bottomcagnotte = 30;
      bottomsolde = 400;
      sold = 330;
      _taill = taille_description_champ-2;
      top1 = 65;
      top = 100;
      topo1 = 133;
      top2 = 142;
      top3 = 297;
      top4 = 220;
      top33 = 288;
      topo2 = 70;
      topo22 = 100;
      top34 = 211;
      haut=5;
      topi = 2;
      enl = 2;
    }else if(_large>320 && _large<=360 && _haut==738){
      fromHeight = 130;
      leftcagnotte = 20;
      rightcagnotte = 40;
      topcagnotte = 50;
      bottomcagnotte = 50;
      bottomsolde = 400;
      sold = 330;
      _taill = taille_description_champ-1;
      top1 = 75;
      top = 100;
      topo1 = 172;
      top2 = 190;
      top3 = 410;
      top4 = 300;
      top33 = 285;
      top34 = 395;
      topo2 = 90;
      topo22 = 100;
      haut=20;
      topi = 2;
      enl = 2;
    }else if(_large>320 && _large<=360){
      fromHeight = 130;
      leftcagnotte = 20;
      rightcagnotte = 40;
      topcagnotte = 50;
      bottomcagnotte = 50;
      bottomsolde = 400;
      sold = 330;
      _taill = taille_description_champ-1;
      top1 = 75;
      top = 100;
      topo1 = 155;
      top2 = 165;
      top3 = 345;
      top4 = 255;
      top33 = 245;
      top34 = 335;
      topo2 = 80;
      topo22 = 100;
      haut=10;
      topi = 2;
      enl = 2;
    }else if(_large>411 && _large<412){
      fromHeight = 130;
      leftcagnotte = 20;
      rightcagnotte = 40;
      topcagnotte = 50;
      bottomcagnotte = 40;
      bottomsolde = 400;
      sold = 330;
      _taill = taille_description_champ;
      top1 = 75;
      top = 100;
      topo1 = 172;
      top2 = 190;
      top3 = 410;
      top4 = 300;
      top33 = 285;
      top34 = 395;
      topo2 = 90;
      topo22 = 100;
      haut=20;
      topi = 2;
      enl = 2;
    }else if(_large>360){
      fromHeight = 130;
      leftcagnotte = 20;
      rightcagnotte = 40;
      topcagnotte = 50;
      bottomcagnotte = 50;
      bottomsolde = 400;
      sold = 330;
      _taill = taille_description_champ;
      top1 = 75;
      top = 100;
      topo1 = 172;
      top2 = 190;
      top3 = 410;
      top4 = 300;
      top33 = 285;
      top34 = 395;
      topo2 = 90;
      topo22 = 100;
      haut=20;
      topi = 15;
      enl = 2;
    }

    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(primaryColor: Colors.white, accentColor: Color(0xFF2A2A42), fontFamily: 'Poppins'),
      routes: <String, WidgetBuilder>{
        "/transfert": (BuildContext context) =>new Transfert3("+33^FR^France^FRA^0"),
        "/retrait": (BuildContext context) =>new Retrait1(_code),
        "/encaisser": (BuildContext context) =>new Encaisser1(_code)
      },
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        backgroundColor: bleu_F,
        appBar: new PreferredSize(
            preferredSize: Size.fromHeight(fromHeight), //200
            child: new Container(
              color: bleu_F,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Historique('$_code')));
                                //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Detail(_code)));
                              },
                              child: Icon(Icons.arrow_back_ios,color: Colors.white,)
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Historique('$_code')));
                              //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Detail(_code)));
                            },
                            child: Text('Retour',
                              style: TextStyle(color: Colors.white, fontSize: taille_champ),),
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: Text('détail de la transaction',
                            style: TextStyle(color: Colors.white, fontSize: taille_champ),),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:40, left: 20, right: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: couleur_fond_bouton,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(15),
                              topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            topLeft: Radius.circular(15),
                          )
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Text(_transactionid==null?"":_transactionid.startsWith("REF")?"$_transactionid":"REF $_transactionid", style: TextStyle(
                            color: orange_F,
                            fontSize: taille_champ,
                            fontWeight: FontWeight.bold
                        ),),
                      ) /*CarouselSlider(
                        enlargeCenterPage: true,
                        autoPlay: false,
                        enableInfiniteScroll: true,
                        viewportFraction: 1.0,
                        onPageChanged: (value){},
                        height: 35.0,
                        items: _liste.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return getMoyen(i);
                            },
                          );
                        }).toList(),
                      ),*/
                    ),
                  ),
                ],
              ),
            )
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: couleur_champ,
                ),
              ),
              Padding(
                padding: new EdgeInsets.only(top: top1-60, right: 20.0, left: 20.0),
                child: Card(
                  elevation: 5,
                  child: Container(
                    height: topo2+30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                      ),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: haut),
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                          });
                        },
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 0, bottom: 10, right: 20),
                              child: Container(
                                width: 5,
                                height: topo2+25,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(10),
                                        topRight: Radius.circular(10)
                                    )
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(getNature(_serviceName),
                                  style: TextStyle(
                                      color: couleur_titre,
                                      fontSize: taille_champ+3,
                                      fontWeight: FontWeight.bold
                                  ),),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(_amount==null?"":"${getMillis(_amount)} $deviseLocale",
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: taille_champ+3,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    /*GestureDetector(
                                      onTap: (){
                                        navigatorKey.currentState.pushNamed("/transfert");
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/2-10),
                                        child: Icon(Icons.cached, color: orange_F,size: 30,),
                                      ),
                                    )*/
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 15),
                                  child: Container(
                                    height: 2,
                                    width: MediaQuery.of(context).size.width-100,
                                    decoration: BoxDecoration(
                                      color: couleur_description_champ,
                                    ),
                                  ),
                                ),
                                Text(_date==null?"":getMonth(_date),
                                  style: TextStyle(
                                      color: couleur_champ,
                                      fontSize: taille_champ,
                                      fontWeight: FontWeight.bold
                                  ),textAlign: TextAlign.right,)
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 0, bottom: 10, left: 22),
                              child: Container(
                                width: 5,
                                height: topo2+25,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        topLeft: Radius.circular(10)
                                    )
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: top1+70, left: 50, right: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Text("Pays", style: TextStyle(
                      fontSize: taille_champ+2
                      ),),
                    ),
                    Expanded(
                      flex: 9,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(_paysf=="null"?"":"$_paysf ", style: TextStyle(
                              color: couleur_fond_bouton,
                              fontSize: taille_champ+2
                            ),),
                            Text(_payst=="null"?"":"vers ", style: TextStyle(
                                fontSize: taille_champ+2
                            ),),
                            Text(_payst=="null"?"":"$_payst ", style: TextStyle(
                                color: couleur_fond_bouton,
                                fontSize: taille_champ+2
                            ),),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: top1+100, left: 30, right: 30),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width-40,
                  decoration: BoxDecoration(
                    color: couleur_decription_page,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: top1+120, left: 50, right: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Moyen de paiement", style: TextStyle(
                            fontSize: taille_champ+2
                        ),),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(getMoyen(_serviceName), style: TextStyle(
                              color: couleur_fond_bouton,
                              fontSize: taille_champ+2,
                            fontWeight: FontWeight.bold
                          ),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: top1+160, left: 30, right: 30),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width-40,
                  decoration: BoxDecoration(
                    color: couleur_decription_page,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: top1+180, left: 50, right: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Destinataire", style: TextStyle(
                            fontSize: taille_champ+2
                        ),),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(_name==null||_name=="null"?"": _name.length<15?_name:_name.substring(0, 12)+"...", style: TextStyle(
                                color: couleur_fond_bouton,
                                fontSize: taille_champ+2,
                                fontWeight: FontWeight.bold
                            ),),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: top1+220, left: 30, right: 30),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width-40,
                  decoration: BoxDecoration(
                    color: couleur_decription_page,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: top1+240, left: 50, right: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Montant envoyé", style: TextStyle(
                            fontSize: taille_champ+2
                        ),),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(_amount==null?"":"${getMillis(_amount.toString())} $deviseLocale", style: TextStyle(
                              color: couleur_fond_bouton,
                              fontSize: taille_champ+2,
                              fontWeight: FontWeight.bold
                          ),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: top1+280, left: 30, right: 30),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width-40,
                  decoration: BoxDecoration(
                    color: couleur_decription_page,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: top1+300, left: 50, right: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Commission", style: TextStyle(
                            fontSize: taille_champ+2
                        ),),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(_fees==null?"":"${getMillis(_fees.toString())} $deviseLocale", style: TextStyle(
                              color: couleur_fond_bouton,
                              fontSize: taille_champ+2,
                              fontWeight: FontWeight.bold
                          ),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: top1+340, left: 30, right: 30),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width-40,
                  decoration: BoxDecoration(
                    color: couleur_decription_page,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: top1+360, left: 50, right: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Montant total de la transaction", style: TextStyle(
                            fontSize: taille_champ+2
                        ),),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(_fees==null || _amount==null?"":"${getMillis((double.parse(_fees)+double.parse(_amount)).toString())} $deviseLocale", style: TextStyle(
                              color: couleur_fond_bouton,
                              fontSize: taille_champ+2,
                              fontWeight: FontWeight.bold
                          ),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: top1+400, left: 30, right: 30),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width-40,
                  decoration: BoxDecoration(
                    color: couleur_decription_page,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: top1+420, left: 50, right: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Statut de la requête", style: TextStyle(
                            fontSize: taille_champ+2,
                        ),),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(getStatus(_status), style: TextStyle(
                              color: Colors.green,
                              fontSize: taille_champ+2,
                            fontWeight: FontWeight.bold
                          ),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: top1+460, left: 30, right: 30),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width-40,
                  decoration: BoxDecoration(
                    color: couleur_decription_page,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}