import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:services/composants/components.dart';
import 'cagnottes/detail.dart';
import 'cagnottes/participer.dart';
import 'package:flutter/material.dart';
import 'utils/components.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'verification.dart';

class Paiement extends StatefulWidget {
  Paiement(this._code);
  String _code;
  @override
  _PaiementState createState() => new _PaiementState(_code);
}

class _PaiementState extends State<Paiement> {
  _PaiementState(this._code);
  String _code;
  TabController _tabController;
  PageController pageController;
  int currentPage = 0;
  bool _value1 = false;
  int choice = 0, idUser;
  int recenteLenght, archiveLenght, populaireLenght, id_kitty;
  var _formKey = GlobalKey<FormState>();
  int flex4, flex6, taille, enlev, rest, enlev1, _id, choix;
  double _tail,_taill,haut, _width, hauteurcouverture, nomright, nomtop, right1, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext, _larg, left1, social, topo, div1, div2, margeleft, margeright;
  File _image;
  List data, list;
  var _userTextController = new TextEditingController();
  var _userTextController1 = new TextEditingController();
  var _userTextController2 = new TextEditingController();
  var _userTextController3 = new TextEditingController();
  var _userTextController4 = new TextEditingController();
  var _userTextController5 = new TextEditingController();
  var _userTextController6 = new TextEditingController();
  var _userTextController7 = new TextEditingController();
  var _userTextController8 = new TextEditingController();

  String kittyImage,_xaf='XAF', _paie, firstnameBenef, endDate, startDate, title, suggested_amount, amount, description, number, nom="", tel="", email="", montant="", mot="";
  var _mySelection = '+237';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    this._read();
    this.lire();
    id_kitty = int.parse(_code.split('^')[10]);
    kittyImage = _code.split('^')[1];
    firstnameBenef = _code.split('^')[2];
    endDate = _code.split('^')[3];
    startDate = _code.split('^')[4];
    title = _code.split('^')[5];
    suggested_amount = _code.split('^')[6];
    amount = _code.split('^')[7];
    description = _code.split('^')[8];
    number = _code.split('^')[9];
    this.lecture();
    pageController = PageController(
        initialPage: currentPage,
        keepPage: false,
        viewportFraction: 0.8
    );
  }
  void _onChanged1(bool value) => setState(() => _value1 = value);

  bool tryParse(String str) {
    if(str == null) {
      return false;
    }
    return int.tryParse(str) != null;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _userTextController.dispose();
    _userTextController1.dispose();
    _userTextController2.dispose();
    _userTextController3.dispose();
    _userTextController4.dispose();
    _userTextController5.dispose();
    _userTextController6.dispose();
    _userTextController7.dispose();
    _userTextController8.dispose();
    super.dispose();
  }

  lecture() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final key = 'choix';
      choix = int.parse(prefs.getString(key));
      print('je lis le choix: $choix');
    });
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width-40;
    double fromHeight, leftcagnotte, rightcagnotte, topcagnotte, bottomcagnotte;
    final _large = MediaQuery.of(context).size.width;
    if(_large<=320){
      fromHeight = 130;
      leftcagnotte = 30;
      rightcagnotte = 30;
      topcagnotte = 10; //espace entre mes tabs et le slider
      bottomcagnotte = 50;
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
      _larg = 30;
      enlev1 = 243;
      right1 = 120;
      left1 = 0;
      social = 25;
      topo = 470;
      div1 = 387;
      margeleft = 11.5;
      margeright = 11;
      _tail = taille_description_champ-1;
      _taill = taille_description_champ-3;
      haut = 75;
    }else if(_large>320 && _large<=360){
      left1 = 0;
      right1 = 150;
      fromHeight = 200;
      leftcagnotte = 40;
      rightcagnotte = 40;
      topcagnotte = 40;
      bottomcagnotte = 70;
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
      _larg = 40;
      enlev1 = 260;
      social = 30;
      topo = 480;
      div1 = 388;
      margeleft = 12.5;
      margeright = 12.5;
      _tail = taille_description_champ-1;
      _taill = taille_description_champ-1;
      haut=75;
    }else if(_large == 375){
      left1 = 0;
      right1 = 197;
      fromHeight = 200;
      leftcagnotte = 40;
      rightcagnotte = 40;
      topcagnotte = 40;
      bottomcagnotte = 70;
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
      _larg = 40;
      enlev1 = 260;
      social = 30;
      topo = 480;
      div1 = 387;
      margeleft = 13;
      margeright = 13;
      _tail = taille_description_champ;
      _taill = taille_description_champ;
      haut = 75;
    }else if(_large>360){
      left1 = 0;
      right1 = 197;
      fromHeight = 200;
      leftcagnotte = 40;
      rightcagnotte = 40;
      topcagnotte = 40;
      bottomcagnotte = 70;
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
      _larg = 40;
      enlev1 = 260;
      social = 30;
      topo = 480;
      div1 = 387;
      margeleft = 15;
      margeright = 14;
      _tail = taille_description_champ;
      _taill = taille_description_champ;
      haut = 75;
    }
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new DefaultTabController(
        length: 1,
        child: new Scaffold(
          key: _scaffoldKey,
          body: _buildCarousel(context),
          bottomNavigationBar: bottomNavigation(context, _scaffoldKey,  choix, "null"),
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
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                        /*gradient: LinearGradient(
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                            colors: [
                              Colors.white,
                              bleu_F,
                            ],
                            stops: [
                              0.0,
                              1.0
                            ]
                        ),*/
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                        image: DecorationImage(
                            image: NetworkImage(kittyImage),
                            fit: BoxFit.cover
                        )
                    ),),
                  // The card widget with top padding,
                  // incase if you wanted bottom padding to work,
                  // set the `alignment` of container to Alignment.bottomCenter
                  new Container(
                    child: new Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly
                      children: <Widget>[
                        Padding(
                          padding: new EdgeInsets.only(
                              top: topphoto,
                              right: 0.0,
                              left: 20.0),
                          child: SizedBox(
                            child: Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: _image == null?AssetImage("images/ellipse1.png"):Image.file(_image),
                                      fit: BoxFit.cover
                                  )
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 335),
                    child: Divider(
                      height: 5,
                      color: couleur_bordure,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 23, left: 20, right: 20),
                    child: Row(
                      children: <Widget>[
                        InkWell(
                            onTap: (){
                              setState(() {
                                this._save(null);
                                Navigator.pop(context);
                                if(idUser==-1)
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Participer(_code)));
                                else
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Detail(_code)));
                              });
                            },
                            child: Icon(Icons.arrow_back_ios,color: Colors.white,)
                        ),
                        InkWell(
                          onTap: (){
                            setState(() {
                              this._save(null);
                              //Navigator.pop(context);
                              if(idUser==-1)
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Participer(_code)));
                              else
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Detail(_code)));
                            });
                          },
                          child: Text('Retour',
                            style: TextStyle(color: Colors.white, fontSize: taille_champ),),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 355, left: 20),
                    child: Text(title,
                      style: TextStyle(
                          color: couleur_fond_bouton,
                          fontSize: taille_text_bouton,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 385),
                    child: Divider(
                      height: 5,
                      color: couleur_bordure,
                    ),
                  ),

                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(top: div1),
                          child: Container(color: couleur_bordure, height: haut, margin: EdgeInsets.only(left: margeleft, right: margeright),),
                        ),
                      ),

                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.only(top: 380 ),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.shopping_cart,
                                color: couleur_fond_bouton,
                                size: 40,
                              ),
                              Text('PARTICIPATION',
                                style: TextStyle(
                                    color: couleur_fond_bouton,
                                    fontSize: _tail,
                                    fontWeight: FontWeight.bold
                                ),)
                            ],
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(top: div1),
                          child: Container(color: couleur_bordure, height: haut, margin: EdgeInsets.only(left: margeleft, right: margeright),),
                        ),
                      ),

                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: EdgeInsets.only(top: 380),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.check_circle_outline,
                                color: couleur_libelle_champ,
                                size: 40,
                              ),
                              Text('VERIFICATION',
                                style: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize: _tail,
                                    fontWeight: FontWeight.normal
                                ),)
                            ],
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(top: div1),
                          child: Container(color: couleur_bordure, height: haut, margin: EdgeInsets.only(left: margeleft, right: margeright),),
                        ),
                      ),

                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.only(top: 380),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.payment,
                                color: couleur_libelle_champ,
                                size: 40,
                              ),
                              Text('PAIEMENT',
                                style: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize: _tail,
                                    fontWeight: FontWeight.normal
                                ),)
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(top: div1),
                          child: Container(color: couleur_bordure, height: haut, margin: EdgeInsets.only(left: margeleft, right: margeright),),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 460),
                    child: Divider(
                      height: 5,
                      color: couleur_bordure,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 462),
                    child: Container(
                      height: hauteur_champ,
                      width: MediaQuery.of(context).size.width,
                      color: couleur_champ,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, top: 15),
                        child: Text("Choix du moyen de paiement",
                          style: TextStyle(
                              color: couleur_libelle_champ,
                              fontSize: taille_description_page,
                              fontWeight: FontWeight.bold
                          ),),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 530, left: 20, right: 20),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: InkWell(
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
                            child: InkWell(
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
                            child: InkWell(
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
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 630),
                    child: Divider(
                      height: 5,
                      color: couleur_bordure,
                    ),
                  ),

                  Padding(
                      padding: EdgeInsets.only(top: 650, left: 20),
                      child: TextFormField(
                        controller: _userTextController1,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            fontSize: taille_libelle_champ,
                            color: couleur_libelle_champ,
                            fontFamily: police_champ
                        ),
                        validator: (String value){
                          if(value.isEmpty){
                            return null;
                          }else{
                            nom = value;
                            _userTextController1.text = nom;
                            return null;
                          }
                        },
                        decoration: InputDecoration.collapsed(
                          hintText: 'Nom et prénom du donnateur',
                          hintStyle: TextStyle(
                              color: couleur_libelle_champ,
                              fontSize: taille_libelle_champ
                          ),
                        ),
                      )
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 677),
                    child: Divider(
                      height: 5,
                      color: couleur_bordure,
                    ),
                  ),

                  Padding(
                      padding: EdgeInsets.only(top: 695, left: 20),
                      child: TextFormField(
                        controller: _userTextController2,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                            fontSize: taille_libelle_champ,
                            color: couleur_libelle_champ,
                            fontFamily: police_champ
                        ),
                        validator: (String value){
                          if(value.isEmpty){
                            return null;
                          }else{
                            email = value;
                            _userTextController2.text = email;
                            return null;
                          }
                        },
                        decoration: InputDecoration.collapsed(
                          hintText: 'Adresse email du donnateur',
                          hintStyle: TextStyle(
                              color: couleur_libelle_champ,
                              fontSize: taille_libelle_champ
                          ),
                        ),
                      )
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 724),
                    child: Divider(
                      height: 5,
                      color: couleur_bordure,
                    ),
                  ),

                  Padding(
                      padding: EdgeInsets.only(top: 728, left: 20),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Icon(Icons.phone,
                            color: couleur_libelle_champ,)
                          ),
                          Expanded(
                            flex: 4,
                              child: CountryCodePicker(
                                showFlag: true,
                                onChanged: (CountryCode code)=>getCurrency(code),
                              )
                          ),
                          Expanded(
                            flex: 10,
                            child: TextFormField(
                              controller: _userTextController3,
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
                                  tel = '$value';
                                  _userTextController3.text = tel;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Téléphone du donnateur',
                                hintStyle: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize: taille_libelle_champ
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 771),
                    child: Divider(
                      height: 5,
                      color: couleur_bordure,
                    ),
                  ),

                  Padding(
                      padding: EdgeInsets.only(top: 790, left: 20),
                      child: TextFormField(
                        controller: _userTextController4,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            fontSize: taille_libelle_champ,
                            color: couleur_libelle_champ,
                            fontFamily: police_champ
                        ),
                        validator: (String value){
                          if(value.isEmpty){
                            return null;
                          }else{
                            montant = value;
                            _userTextController4.text = montant;
                            return null;
                          }
                        },
                        decoration: InputDecoration.collapsed(
                          hintText: 'Un commentaire pour accompagner votre don',
                          hintStyle: TextStyle(
                              color: couleur_libelle_champ,
                              fontSize: taille_libelle_champ
                          ),
                        ),
                      )
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 818),
                    child: Divider(
                      height: 5,
                      color: couleur_bordure,
                    ),
                  ),

                  Padding(
                      padding: EdgeInsets.only(top: 837, left: 20, right: 20),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 10,
                            child: TextFormField(
                              controller: _userTextController5,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  fontSize: taille_libelle_champ,
                                  color: couleur_libelle_champ,
                                  fontFamily: police_champ
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return 'Montant vide !';
                                }else{
                                  mot = value;
                                  _userTextController5.text = mot;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Montant de votre contribution',
                                hintStyle: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize: taille_libelle_champ
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                              child: Text(_xaf==null?'XAF':'$_xaf',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                  color: couleur_libelle_champ,
                                  fontSize: taille_libelle_champ
                              ),)
                          )
                        ],
                      )
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 865),
                    child: Divider(
                      height: 5,
                      color: couleur_bordure,
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 865, left: 5),
                    child: new SwitchListTile(
                      value: _value1,
                      onChanged: _onChanged1,
                      activeColor: couleur_fond_bouton,
                      title: new Text('Masquer ma participation', style: new TextStyle(fontWeight: FontWeight.normal, color: couleur_libelle_champ, fontSize: taille_libelle_champ)),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 920),
                    child: Container(
                      height: hauteur_champ,
                      width: MediaQuery.of(context).size.width,
                      color: couleur_champ,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, top: 15),
                        child: Text(""),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top:960,bottom: 0),
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          if(_formKey.currentState.validate()){
                            print(_mySelection);
                            if(tryParse('${_mySelection.substring(0, _mySelection.length)}$tel')==false){
                              showInSnackBar("Numéro de téléphone $_mySelection$tel invalide!");
                            }else {
                              String values = '$choice^$nom^$email^$tel^$montant^$mot^$_value1^$_xaf^$_mySelection^$id_kitty';
                              print(values);
                              _save(values);
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Verification(_code)));
                            }
                            //Navigator.of(context).push(SlideLeftRoute(enterWidget: Verification(_code), oldWidget: Paiement(_code)));
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
                          borderRadius: new BorderRadius.circular(0.0),
                        ),
                        child: new Center(child: new Text('Vérification', style: new TextStyle(fontSize: taille_text_bouton, color: couleur_text_bouton, fontFamily: police_bouton),),),
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
  void _save(String valeur) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'paiement';
    final value = valeur;
    prefs.setString(key, value);
    print('saved $value');
  }

  _read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final key = 'paiement';
      _paie = prefs.getString(key)!=null?prefs.get(key):null;
      if(_paie!=null){
        //'$choice^$nom^$email^$tel^$montant^$mot^$_value1^$_xaf^$_mySelection^$id_kitty';
        choice = int.parse(_paie.split('^')[0]);
        nom = _paie.split('^')[1];
        _userTextController1.text = nom.toString();
        email = _paie.split('^')[2];
        _userTextController2.text = email.toString();
        tel = _paie.split('^')[3];
        _userTextController3.text = tel.toString();
        montant = _paie.split('^')[4];
        _userTextController4.text = montant.toString();
        mot = _paie.split('^')[5];
        _userTextController5.text = mot.toString();
        _value1 = _paie.split('^')[6]=="true"?true:false;
        _xaf = _paie.split('^')[7];
        _userTextController7.text = _xaf.toString();
        _mySelection = _paie.split('^')[8]==null?'+237':_paie.split('^')[8];
      }else{
        _userTextController.text = "";
        _userTextController1.text = "";
        _userTextController2.text = "";
        _userTextController3.text = "";
        _userTextController4.text = "";
        _userTextController5.text = "";
        _userTextController6.text = "";
        _userTextController7.text = "";
        _userTextController8.text = "";
      }
    });
  }


  getCurrency(CountryCode code) async {
    _mySelection = code.dialCode.toString();
    final url = "$base_url/user/currencyUser/${code.toCodeString()}";
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.set('Accept', 'application/json');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print(response.statusCode);
    print(reply);
      if(response.statusCode == 200){
        setState(() {
          this._xaf = json.decode(reply)['currencyCode'];
        });
      }else{
        this._xaf = "";
        showInSnackBar("Un problème est survenu. Veuillez réessayer plus tard!");
      }
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

  lire() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final key = 'idUser';
      idUser = prefs.getString(key)==null?-1:int.parse(prefs.getString(key));
      print('hello ${prefs.getString(key)}');
    });
  }
}