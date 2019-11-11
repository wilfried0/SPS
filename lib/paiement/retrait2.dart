import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:services/composants/components.dart';
import 'package:services/composants/services.dart';
import 'confirma.dart';
import 'echec.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'retrait1.dart';


// ignore: must_be_immutable
class Retrait2 extends StatefulWidget {
  Retrait2(this._code);
  String _code;
  @override
  _Retrait2State createState() => new _Retrait2State(_code);
}

class _Retrait2State extends State<Retrait2> {
  _Retrait2State(this._code);
  String _code;
  TabController _tabController;
  PageController pageController;
  int currentPage = 0;
  int choice = 0;
  int recenteLenght, archiveLenght, populaireLenght;
  var _formKey = GlobalKey<FormState>();
  int flex4, flex6, taille, enlev, rest, enlev1, indik;
  double aj, ajj,gauch, droit,_taill, hauteurcouverture, nomright, nomtop, right1, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext, left1, social, topo, div1, div2, margeleft, margeright;
  List data, list;
  var _userTextController = new TextEditingController();
  // ignore: non_constant_identifier_names
  String kittyImage,_xaf="XAF",_mySelection,solde, previsional_amount, amount_collected, kittyId, firstnameBenef,particip, endDate, startDate, title, suggested_amount, amount, description, number, nom="", tel="", email="", montant="", mot="";

  @override
  void initState() {
    super.initState();
    this.read();
    indik = int.parse(_code)+1;
    print(indik);
    pageController = PageController(
        initialPage: currentPage,
        keepPage: false,
        viewportFraction: 0.8
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _userTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _large = MediaQuery.of(context).size.width;
    double fromHeight = 200;
    switch(indik){
      case 1:aj=100; ajj=100;break;
      case 3:aj=100; ajj=200; break;
      default:aj=100;ajj=0;
    }
    if(_large<=320){
      hauteurcouverture = 150;
      nomright = 0;
      nomtop = 130;
      datetop = 10;
      titretop = 190;
      titreleft = 20;
      amounttop = 210;
      amountleft = 20;
      amountright = 20;
      topcolect = 235;
      topphoto = 250;
      bottomphoto = 40;
      desctop = 290; //pour l'étoile et Agriculture
      descbottom = 0;
      flex4 = 1;
      flex6 = 5;
      bottomtext = 35;
      toptext = 260;
      taille = 39;
      enlev = 0;
      rest = 30;
      enlev1 = 243;
      right1 = 120;
      left1 = 0;
      social = 25;
      topo = 470;
      div1 = 387;
      margeleft = 11.5;
      margeright = 11;
      gauch = 20;
      droit = 20;
      _taill = taille_description_champ-3;
    }else if(_large>320 && _large<=414){
      left1 = 0;
      right1 = 197;
      hauteurcouverture = 300;
      nomright =  MediaQuery.of(context).size.width-330;
      nomtop = 280;
      datetop = 10;
      titretop = 340;
      titreleft = 20;
      amounttop = 360;
      amountleft = 20;
      amountright = 20;
      topcolect = 385;
      topphoto = 250;
      bottomphoto = 0;
      desctop = 490;
      descbottom = 20;
      flex4 = 5;
      flex6 = 6;
      bottomtext = 50;
      toptext = 420;
      taille = 250;
      enlev = 104;
      rest = 40;
      enlev1 = 260;
      social = 30;
      topo = 480;
      div1 = 387;
      margeleft = 15;
      margeright = 14;
      gauch = 20;
      droit = 20;
      _taill = taille_description_champ-1;
    }
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new DefaultTabController(
        length: 1,
        child: new Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(fromHeight),
              child: new Container(
                color: bleu_F,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 23, left: 20, right: 20),
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                              onTap: (){
                                setState(() {
                                  Navigator.pop(context);
                                  //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Detail('$_code')));
                                  //Navigator.of(context).push(SlideLeftRoute(enterWidget: Detail(_code), oldWidget: Encaisser1(_code)));
                                });
                              },
                              child: Icon(Icons.arrow_back_ios,color: Colors.white,)
                          ),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                //Navigator.pop(context);
                                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Retrait1('$_code')));
                                //Navigator.of(context).push(SlideLeftRoute(enterWidget: Detail(_code), oldWidget: Encaisser1(_code)));
                              });
                            },
                            child: Text('Retour',
                              style: TextStyle(color: Colors.white, fontSize: taille_champ),),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0, left: gauch, right: droit),
                      child: Center(
                        child: Text('Etape 2 sur 2',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: taille_libelle_etape,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('Retirer de l\'argent',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: taille_titre-2,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 80, top: 20),//solde du compte
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text('SOLDE DU COMPTE', style: TextStyle(
                            color: Colors.white,
                            fontSize: taille_libelle_etape-2
                        ),),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 80, top: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(solde==null?"1.500,0 XAF":getMillis('$solde'), style: TextStyle(//Montant du solde
                            color: orange_F,
                            fontSize: taille_titre+8,
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: _buildCarousel(context),
            bottomNavigationBar: barreBottom
        ),
      ),
    );
  }


  _buildCarousel(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0)
            ),
            child: Form(
              key: _formKey,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: gauch, right: droit),
                    child: Text('Moyen par lequel vous allez faire un retrait de votre compte.',
                      style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_libelle_etape,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:70),
                    child: CarouselSlider(
                      enlargeCenterPage: true,
                      autoPlay: false,
                      enableInfiniteScroll: false,
                      onPageChanged: (value){},
                      height: 135.0,
                      items: [indik].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return getMoyen(indik);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  /*Padding(
                      padding: EdgeInsets.only(top: 250, left: 20, right: 20),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    choice = 0;
                                  });
                                },
                                child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0),
                                      ),
                                      color: choice==0?Colors.white:couleur_champ,
                                      border: Border.all(
                                        color: choice==0?orange_F:couleur_libelle_champ,
                                      )
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: <Widget>[
                                        Icon(
                                          Icons.credit_card,
                                          color: choice==0?orange_F:couleur_libelle_champ,
                                          size: 40,
                                        ),
                                        Text('Carte de crédit',
                                          style: TextStyle(
                                              color: couleur_libelle_champ,
                                              fontSize: _taill,
                                              fontWeight: FontWeight.bold
                                          ),)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5, left: 5),
                              child: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    choice = 1;
                                  });
                                },
                                child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0),
                                      ),
                                      color: choice==1?Colors.white:couleur_champ,
                                      border: Border.all(
                                        color: choice==1?orange_F:couleur_libelle_champ,
                                      )
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: <Widget>[
                                        Icon(
                                          Icons.web,
                                          color: choice==1?orange_F:couleur_libelle_champ,
                                          size: 40,
                                        ),
                                        Text('Sprint-pay Wallet',
                                          style: TextStyle(
                                              color: couleur_libelle_champ,
                                              fontSize: _taill,
                                              fontWeight: FontWeight.bold
                                          ),)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    choice = 2;
                                  });
                                },
                                child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0),
                                      ),
                                      color: choice==2?Colors.white:couleur_champ,
                                      border: Border.all(
                                        color: choice==2?orange_F:couleur_libelle_champ,
                                      )
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: <Widget>[
                                        Icon(
                                          Icons.phone_iphone,
                                          color: choice==2?orange_F:couleur_libelle_champ,
                                          size: 40,
                                        ),
                                        Text('Mobile money',
                                          style: TextStyle(
                                              color: couleur_libelle_champ,
                                              fontSize: _taill,
                                              fontWeight: FontWeight.bold
                                          ),)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                  ),*/

                  Padding(
                    padding: EdgeInsets.only(top: 230, left: gauch, right: droit),
                    child: Text("Vous êtes sur le point de retirer de votre compte un montant de",
                      style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_libelle_etape,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 270, left: gauch, right: droit),
                    child: Text(montant==null?"":'$montant,0 $_xaf',
                      style: TextStyle(
                          color: couleur_libelle_etape,
                          fontSize: taille_titre+15,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 330, left: gauch, right: droit),
                    child: Text("Commission de la transaction",
                      style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_libelle_etape,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 350, left: gauch, right: droit),
                    child: Text('0,0 $_xaf',
                      style: TextStyle(
                          color: couleur_libelle_etape,
                          fontSize: taille_titre+15,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  /*Padding(
                    padding: EdgeInsets.only(top: 475, left: gauch, right: droit),
                    child: Text("L'utilisateur qui recharge son compte",
                      style: TextStyle(
                          color: couleur_decription_page,
                          fontSize: taille_libelle_etape,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: gauch, right: droit, top: 520),
                    child: Container(
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0)
                        ),
                        color: Colors.transparent,
                        border: Border.all(
                            width: bordure,
                            color: couleur_bordure
                        ),
                      ),
                      height: hauteur_champ,
                      child: Padding(
                        padding: EdgeInsets.only(left: 0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                flex: 5,
                                child: CountryCodePicker(
                                  showFlag: true,
                                  onChanged: (CountryCode code){
                                    _mySelection = code.dialCode.toString();
                                  },
                                )
                            ),
                            Expanded(
                              flex: 10,
                              child: TextFormField(
                                //controller: _userTextController3,
                                keyboardType: TextInputType.phone,
                                style: TextStyle(
                                    fontSize: taille_libelle_champ,
                                    color: couleur_libelle_champ,
                                    fontFamily: police_champ
                                ),
                                validator: (String value){
                                  if(value.isEmpty){
                                    return 'Téléphone vide !';
                                  }else{
                                    //tel = '$value';
                                    //_userTextController3.text = tel;
                                    return null;
                                  }
                                },
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Contact téléphonique',
                                  hintStyle: TextStyle(
                                      color: couleur_libelle_champ,
                                      fontSize: taille_libelle_champ
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),*/

                  Padding(
                    padding: EdgeInsets.only(top: 310+aj, left: gauch, right: droit),
                    child: Text("Montant total à débiter",
                      style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_libelle_etape,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 330+aj, left: gauch, right: droit),
                    child: Text(montant==null?"":'$montant,0 $_xaf',
                      style: TextStyle(
                          color: couleur_libelle_etape,
                          fontSize: taille_titre+15,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  indik==1||indik==3?Padding(
                    padding: EdgeInsets.only(top: 395+aj, left: gauch, right: droit),
                    child: Text("Informations sur le bénéficiaire",
                      style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_libelle_etape,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ):Container(),

                  indik==1||indik==3?Padding(
                    padding: EdgeInsets.only(top: 425+aj, left: gauch, right: droit),
                    child: Container(
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(indik==1?10.0:0),
                          bottomRight: Radius.circular(indik==1?10.0:0),
                        ),
                        color: Colors.transparent,
                        border: Border.all(
                            color: couleur_bordure,
                            width: bordure
                        ),
                      ),
                      height: hauteur_champ,
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                              flex:2,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: new Image.asset('images/Groupe18.png'),
                              ),
                            ),
                          new Expanded(
                            flex:10,
                            child: new TextFormField(
                              controller: _userTextController,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                fontSize: taille_libelle_champ,
                                color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return 'Champ téléphone vide !';
                                }else{
                                  _userTextController.text = value;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Numéro de téléphone',
                                hintStyle: TextStyle(
                                  fontSize: taille_libelle_champ,
                                  color: couleur_libelle_champ,
                                ),
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ):Container(),

                  indik==3?Padding(
                    padding: EdgeInsets.only(left: gauch, right: droit, top: 475+aj),
                    child: Container(
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          topLeft: Radius.circular(0.0),
                          topRight: Radius.circular(0.0),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                        ),
                        color: Colors.transparent,
                        border: Border.all(
                            color: couleur_bordure,
                            width: bordure
                        ),
                      ),
                      height: hauteur_champ,
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                            flex:2,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: new Image.asset('images/Groupe177.png'),
                            ),
                          ),
                          new Expanded(
                            flex:10,
                            child: new TextFormField(
                              //controller: _userTextController,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                fontSize: taille_libelle_champ,
                                color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return 'Champ prénom vide !';
                                }else{
                                  _userTextController.text = value;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Prénom',
                                hintStyle: TextStyle(
                                  fontSize: taille_libelle_champ,
                                  color: couleur_libelle_champ,
                                ),
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ):Container(),
                  indik==3?Padding(
                    padding: EdgeInsets.only(left: gauch, right: droit, top: 525+aj),
                    child: Container(
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          topLeft: Radius.circular(0.0),
                          topRight: Radius.circular(0.0),
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                        color: Colors.transparent,
                        border: Border.all(
                            color: couleur_bordure,
                            width: bordure
                        ),
                      ),
                      height: hauteur_champ,
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                            flex:2,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: new Image.asset('images/Groupe177.png'),
                            ),
                          ),
                          new Expanded(
                            flex:10,
                            child: new TextFormField(
                              //controller: _userTextController,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                fontSize: taille_libelle_champ,
                                color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return 'Champ nom vide !';
                                }else{
                                  _userTextController.text = value;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Nom',
                                hintStyle: TextStyle(
                                  fontSize: taille_libelle_champ,
                                  color: couleur_libelle_champ,
                                ),
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ):Container(),

                  Padding(
                    padding: EdgeInsets.only(top:405+aj+ajj,left: gauch, right: droit),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Confirma("retrait")));
                          if(_formKey.currentState.validate()){
                            var cardsp = new Cardsp(
                                amount: int.parse(montant.replaceAll(".", "")),
                                currency: this._xaf,
                                firstnameBenef: this.nom,
                                lastnameBenef: '',
                                description: this.mot,
                                mobileNumber: this.number,
                                country: '',
                                email: this.email,
                                spMerchandUrl: '',
                                clientUrl: '',
                                failureUrl: '',
                                cancel_url: 'http://sprint-pay.com/',
                                return_url: 'http://sprint-pay.com/',
                                kittyID: int.parse(this.kittyId)
                            );
                            print(json.encode(cardsp));
                            createCard(json.encode(cardsp));
                            //Navigator.of(context).push(SlideLeftRoute(enterWidget: PassCodeScreen(), oldWidget: Encaisser2(_code)));
                          }
                        });
                      },
                      child: Container(
                        height: hauteur_bouton,
                        width: MediaQuery.of(context).size.width,
                        decoration: new BoxDecoration(
                          color: couleur_fond_bouton,
                          border: new Border.all(
                            color: Colors.transparent,
                            width: 0.0,
                          ),
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        child: new Center(child: new Text('Confirmer le retrait', style: new TextStyle(fontSize: taille_text_bouton, color: couleur_text_bouton, fontFamily: police_bouton),),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final key = 'wallet';
      montant = prefs.getString(key);
    });
  }

  void _save(String valeur) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'wallet';
    final value = valeur;
    prefs.setString(key, value);
    print('saved $value');
  }

  Future<String> createCard(var body) async {
    var _header = {
      "accept": "application/json",
      "content-type" : "application/json"
    };
    String url = "$base_url/walletpayment/cashin/encash";
    return await http.post(url, body: body, headers: _header, encoding: Encoding.getByName("utf-8")).then((http.Response response) {
      final int statusCode = response.statusCode;
      print('voici le statusCode $statusCode');
      if (statusCode < 200 || json == null) {
        print(statusCode);
        print(response.body);
        throw new Exception("Error while fetching data");
      }else if(statusCode == 200){
        print(response.body);
        var convertDataToJson = json.decode(utf8.decode(response.bodyBytes));
        print(convertDataToJson);
        this._save(null);
        if(convertDataToJson['body']['statusCode'] == 'SUCCESSFUL'){
          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Confirma('$_code')));
          //Navigator.of(context).push(SlideLeftRoute(enterWidget: Confirma(_code), oldWidget: Encaisser2('$_code')));
        }else{
          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Echec('$_code^&')));
          //Navigator.of(context).push(SlideLeftRoute(enterWidget: Echec('$_code^&'), oldWidget: Encaisser2('$_code')));
        }
      }else if(statusCode == 403){
        Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Echec('$_code^&')));
        //Navigator.of(context).push(SlideLeftRoute(enterWidget: Echec('$_code^&'), oldWidget: Encaisser2('$_code')));
      }
      else Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Echec('$_code^&')));
      //Navigator.of(context).push(SlideLeftRoute(enterWidget: Echec('$_code^&'), oldWidget: Encaisser2('$_code')));

      return response.body;
    });
  }

  Widget getMoyen(int index){
    String text, img;
    switch(index){
      case 1: text = "MOBILE MONEY";img = 'mobilemoney.jpg';
      break;
      case 2: text = "CARTE BANCAIRE";img = 'carte.jpg';
      break;
      case 3: text = "CASH PAR EXPRESS UNION";img = 'eu.png';
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
        border: Border.all(
            color: orange_F
        ),
        color: orange_F,
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 0),
        child: GestureDetector(
          onTap: (){
            setState(() {
              //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Retrait1('$_code')));
            });
          },
          child: Column(
            children: <Widget>[
              Container(
                height: 90,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    ),
                    image: DecorationImage(
                      image: AssetImage('images/$img'),
                      fit: BoxFit.cover,
                    )
                ),),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text('$text',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: _taill,
                      fontWeight: FontWeight.bold
                  ),)
              )
            ],
          ),
        ),
      ),
    );
  }
}