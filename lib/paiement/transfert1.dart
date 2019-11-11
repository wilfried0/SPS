import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:page_transition/page_transition.dart';
import 'package:services/auth/profile.dart';
import 'package:services/composants/components.dart';
import 'package:services/paiement/transfert22.dart';
import 'encaisser2.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'retrait2.dart';
import 'transfert2.dart';


// ignore: must_be_immutable
class Transfert1 extends StatefulWidget {
  Transfert1(this._code);
  String _code;
  @override
  _Transfert1State createState() => new _Transfert1State(_code);
}

class _Transfert1State extends State<Transfert1> {
  _Transfert1State(this._code);
  String _code;
  TabController _tabController;
  PageController pageController;
  int currentPage = 0;
  int choice = 0;
  var _userTextController;
  GlobalKey<ScaffoldState> _scaffoldKey;
  // ignore: non_constant_identifier_names
  int recenteLenght, archiveLenght, populaireLenght, id_kitty;
  var _formKey = GlobalKey<FormState>();
  var _categorie = ['A', 'B', 'C', 'D'];
  int flex4, flex6, taille, enlev, rest, enlev1, indik=0;
  double ad,_taill,gauch, droit, hauteurcouverture, nomright, nomtop, right1, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext, left1, social, topo, div1, div2, margeleft, margeright;
  File _image;
  List data, list;
  Color color;
  // ignore: non_constant_identifier_names
  String kittyImage,_current, firstnameBenef,solde,kittyId,remain, particip, previsional_amount,amount_collected, endDate, startDate, title, suggested_amount, amount, description, number, nom="", tel="", email="", montant="", mot="";

  @override
  void initState() {
    super.initState();
    print(_code);
    _code = "$_code^$indik";
    this.read();
    _userTextController = new MoneyMaskedTextController(decimalSeparator: '', thousandSeparator: '.', precision: 0);
//_code = '$index ${_cagnottes[index]["kittyImage"]} ${_cagnottes[index]["firstnameBenef"]} ${_cagnottes[index]["endDate"]} ${_cagnottes[index]["startDate"]} ${_cagnottes[index]["title"]} ${_cagnottes[index]["suggested_amount"]} ${_cagnottes[index]["amount"]} ${_cagnottes[index]["description"]}';

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
    ad = 0;
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
      _taill = taille_description_champ-3;
      gauch = 20;
      droit = 20;
    }else if(_large>320){
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
      _taill = taille_description_champ-1;
      gauch = 20;
      droit = 20;
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
                                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Profile('$_code')));
                                });
                              },
                              child: Icon(Icons.arrow_back_ios,color: Colors.white,)
                          ),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                //Navigator.pop(context);
                                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Profile('$_code')));
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
                        child: Text('Etape 1 sur 3',
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
                        child: Text('Transférer de l\'argent',
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
                  /*Padding(
                    padding: EdgeInsets.only(top: 20, left: gauch, right: droit),
                    child: Text('Vous souhaitez transférer vers',
                      style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_libelle_etape,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 60, left: 0, right: 0),
                    child: CarouselSlider(
                      enlargeCenterPage: true,
                      autoPlay: false,
                      enableInfiniteScroll: true,
                      onPageChanged: (value){
                        setState(() {
                          indik = value;
                          _code = "$_code^$indik";
                        });
                      },
                      height: 135.0,
                      items: [1,2,3,4].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return getMoyen(i);
                          },
                        );
                      }).toList(),
                    ),
                  ),*/

                  Padding(
                    padding: EdgeInsets.only(top: 25+ad, left: gauch, right: droit),
                    child: Text('Vous transférer vers',
                      style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_libelle_etape,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: gauch, right: droit, top: 55+ad),
                    child: Container(
                      margin: EdgeInsets.only(top: 0.0),
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
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
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: new Image.asset('flags/'+_code.split('^')[1].toLowerCase()+'.png'),
                            ),
                          ),

                          Expanded(
                            flex:12,
                            child: Padding(
                                padding: const EdgeInsets.only(left:10.0,),
                                child: new Text(this._code.split('^')[2],
                                  style: TextStyle(
                                      color: couleur_description_champ,
                                      fontSize: taille_champ,
                                  ),)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),



                  Padding(
                    padding: EdgeInsets.only(top: 130+ad, left: gauch, right: droit),
                    child: Text('Quel est le montant à transférer ?',
                      style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_libelle_etape,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: gauch, right: droit, top: 160+ad),
                    child: Container(
                      margin: EdgeInsets.only(top: 0.0),
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
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
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: new TextFormField(
                                controller: _userTextController,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize: taille_champ,
                                ),
                                validator: (String value){
                                  if(value.isEmpty || int.parse(value.replaceAll(".", ""))==0){
                                    return "Montant vide !";
                                  }else{
                                    montant = value;
                                    _userTextController.text = montant;
                                    return null;
                                  }
                                },
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Montant de la recharger',
                                  hintStyle: TextStyle(
                                      color: couleur_libelle_champ,
                                      fontSize: taille_champ,
                                  ),
                                  //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 240+ad, left: gauch, right: droit),
                    child: Text('Motif de l\'opération (facultatif)',
                      style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_libelle_etape,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 270+ad, left: gauch, right: droit),
                    child: Container(
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                        color: Colors.transparent,
                        border: Border.all(
                            color: couleur_bordure,
                            width: bordure
                        ),
                      ),
                      height: hauteur_champ,
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            icon: Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: new Icon(Icons.arrow_drop_down_circle,
                                color: couleur_fond_bouton,),
                            ),
                            isDense: true,
                            elevation: 1,
                            isExpanded: true,
                            onChanged: (String selected){
                              setState(() {
                                _current = selected;
                              });
                            },
                            value: _current,
                            hint: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text('Choisissez le motif',
                                style: TextStyle(
                                  color: couleur_libelle_champ,
                                  fontSize:taille_libelle_champ,
                                ),),
                            ),
                            items: _categorie.map((String name){
                              return DropdownMenuItem<String>(
                                value: name,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text(name,
                                    style: TextStyle(
                                        color: couleur_fond_bouton,
                                        fontSize:taille_libelle_champ,
                                        fontWeight: FontWeight.bold
                                    ),),
                                ),
                              );
                            }).toList(),
                          )
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top:355+ad,left: gauch, right: droit,bottom: 20),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 6,
                          child: GestureDetector(
                            onTap: (){
                              if(_formKey.currentState.validate()) {
                                this._save(montant);
                                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfert22('$_code')));
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Container(
                                height: hauteur_bouton,
                                width: MediaQuery.of(context).size.width/2-gauch,
                                decoration: new BoxDecoration(
                                  color: orange_F,
                                  border: new Border.all(
                                    color: Colors.transparent,
                                    width: 0.0,
                                  ),
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
                                child: new Center(child: new Text('Client SprintPay', style: new TextStyle(fontSize: taille_text_bouton, color: couleur_text_bouton),),),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: GestureDetector(
                            onTap: (){

                              if(_formKey.currentState.validate()) {
                                this._save(montant);
                                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfert2('$_code')));
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Container(
                                height: hauteur_bouton,
                                width: MediaQuery.of(context).size.width/2-droit-10,
                                decoration: new BoxDecoration(
                                  color: couleur_fond_bouton,
                                  border: new Border.all(
                                    color: Colors.transparent,
                                    width: 0.0,
                                  ),
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
                                child: new Center(child: new Text('Cash EU', style: new TextStyle(fontSize: taille_text_bouton, color: couleur_text_bouton),),),
                              ),
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
        ),
      ],
    );
  }
  void _save(String valeur) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'wallet';
    final value = valeur;
    prefs.setString(key, value);
    print('saved $value');
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final key = 'wallet';
      montant = prefs.getString(key)==null?"":prefs.getString(key);
      _userTextController.text = montant==""?"0":montant;
    });
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

  Future<void> _ackAlert(BuildContext context, String value) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Oops!'),
          content: Text(value),
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

  Widget getMoyen(int index){
    String text, img;
    switch(index){
      case 1: text = "MOBILE MONEY";img = 'mobilemoney.jpg';
      break;
      case 2: text = "PORTE MONEY";img = 'wallet.png';
      break;
      case 3: text = "CARTE BANCAIRE";img = 'carte.jpg';
      break;
      case 4: text = "CASH PAR EXPRESS UNION";img = 'eu.png';
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
            color: index-1==indik?orange_F:bleu_F
        ),
        color: index-1==indik?orange_F:bleu_F,
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
                child: index-1!=indik? Text('$text',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: _taill,
                      fontWeight: FontWeight.bold
                  ),):Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('$text',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: _taill,
                          fontWeight: FontWeight.bold
                      ),),
                    Icon(Icons.check, color: Colors.white,)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

