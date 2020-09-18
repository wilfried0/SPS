import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:services/auth/activation.dart';
import 'package:services/community/lib/paiement/webview.dart';
import 'package:services/composants/components.dart';
import 'confirmation.dart';
import 'paiement.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pays.dart';
import 'package:flutter/material.dart';
import 'utils/components.dart';
import 'cagnotte.dart';
import 'utils/services.dart';
import 'dart:io';
import 'package:http/http.dart' as http;



class Verification extends StatefulWidget {
  Verification(this._code);
  String _code;
  @override
  _VerificationState createState() => new _VerificationState(_code);
}

class _VerificationState extends State<Verification> {
  _VerificationState(this._code);
  String _code;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _url = '$base_url/kitty/all/desc';
  TabController _tabController;
  PageController pageController;
  int currentPage = 0;
  bool _value1, masque;
  int choice = 1;
  int recenteLenght, archiveLenght, populaireLenght, flex1, flex2, id_kitty, montant;
  bool isLoding = false;
  int flex4, flex6, taille, enlev, rest, enlev1, choix;
  double _tail,_taill, _width, hauteurcouverture, nomright, nomtop, right1, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext, _larg, left1, social, topo, div1, div2, margeleft, margeright;
  List _cagnottes;
  File _image;
  String kittyImage, monstatus, momo_url, data, _reference, ref, kittyId, country, _status, firstnameBenef, url,momo, card, monnaie, paie_url, _xaf, endDate, startDate, title, suggested_amount, amount, description, number, _paie, nom, email, tel, mot;


  @override
  void initState() {
    super.initState();
    this.lire();
    card = '$base_url/cardpayment/hosted';
    momo = '$base_url/mobilepayment/request';
    //index = int.parse(_code.split('^')[0]);
    kittyImage = _code.split('^')[1];
    firstnameBenef = _code.split('^')[2];
    endDate = _code.split('^')[3];
    startDate = _code.split('^')[4];
    title = _code.split('^')[5];
    suggested_amount = _code.split('^')[6];
    amount = _code.split('^')[7];
    description = _code.split('^')[8];
    number = _code.split('^')[9];
    kittyId = _code.split('^')[10];
    this.lecture();
//_code = '$index ${_cagnottes[index]["kittyImage"]} ${_cagnottes[index]["firstnameBenef"]} ${_cagnottes[index]["endDate"]} ${_cagnottes[index]["startDate"]} ${_cagnottes[index]["title"]} ${_cagnottes[index]["suggested_amount"]} ${_cagnottes[index]["amount"]} ${_cagnottes[index]["description"]}';
    //kittyImage = 'https://i.pinimg.com/474x/f1/2e/08/f12e08d516208335bcc91c3955908af4--bridesmaid-hairstyles-bride-hairstyles.jpg';
    pageController = PageController(
        initialPage: currentPage,
        keepPage: false,
        viewportFraction: 0.8
    );
  }

  void _onChanged1(bool value) => setState(() => _value1 = masque);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
      flex1 = 8;
      flex2 = 4;
      _tail = taille_description_champ-1;
      _taill = taille_description_champ-2;
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
      flex1 = 8;
      flex2 = 3;
      _tail = taille_description_champ-1;
      _taill = taille_description_champ-1;
    }else if(_large == 375){
      flex1 = 8;
      flex2 = 4;
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
    }else if(_large>360){
      flex1 = 9;
      flex2 = 3;
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

  lecture() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final key = 'choix';
      choix = int.parse(prefs.getString(key));
      print('je lis le choix: $choix');
    });
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
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Paiement(_code)));
                              //Navigator.of(context).push(SlideLeftRoute(enterWidget: Paiement(_code), oldWidget: Verification(_code)));
                            });
                          },
                          child: Icon(Icons.arrow_back_ios,color: Colors.white,)
                      ),
                      InkWell(
                        onTap: (){
                          setState(() {
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Paiement(_code)));
                            //Navigator.of(context).push(SlideLeftRoute(enterWidget: Paiement(_code), oldWidget: Verification(_code)));
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
                        child: Container(
                          color: couleur_bordure, height: 75,
                          margin: EdgeInsets.only(left: margeleft, right: margeright),
                        ),
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
                              color: couleur_libelle_champ,
                              size: 40,
                            ),
                            Text('PARTICIPATION',
                              style: TextStyle(
                                  color: couleur_libelle_champ,
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
                        child: Container(color: couleur_bordure, height: 75,
                          margin: EdgeInsets.only(left: margeleft, right: margeright),),
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
                              color: couleur_fond_bouton,
                              size: 40,
                            ),
                            Text('VERIFICATION',
                              style: TextStyle(
                                  color: couleur_fond_bouton,
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
                        child: Container(color: couleur_bordure, height: 75, margin: EdgeInsets.only(left: margeleft, right: margeright),),
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
                        child: Container(color: couleur_bordure, height: 75, margin: EdgeInsets.only(left: margeleft, right: margeright),),
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
                      child: Text("Vérification des informations",
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
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Moyen de payement utilisé',
                            style: TextStyle(
                                fontSize: taille_libelle_champ,
                                color: couleur_libelle_champ,
                                fontFamily: police_champ
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: flex1,
                                child: Text(
                                  getText(choice),
                                  style: TextStyle(
                                      fontSize: taille_libelle_champ,
                                      color: couleur_libelle_champ,
                                      fontFamily: police_champ,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: flex2,
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.credit_card,
                                        color: choice==0?orange_F:couleur_libelle_champ,
                                        size: 30,
                                      ),
                                      Icon(
                                        Icons.web,
                                        color: choice==1?orange_F:couleur_libelle_champ,
                                        size: 30,
                                      ),
                                      Icon(
                                        Icons.phone_iphone,
                                        color: choice==2?orange_F:couleur_libelle_champ,
                                        size: 25,
                                      ),
                                    ],
                                  )
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                ),

                Padding(
                  padding: EdgeInsets.only(top: 580),
                  child: Divider(
                    height: 5,
                    color: couleur_bordure,
                  ),
                ),

                Padding(
                    padding: EdgeInsets.only(top: 600, left: 20),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Nom et prénom du donnateur',style: TextStyle(
                              fontSize: taille_libelle_champ,
                              color: couleur_libelle_champ,
                              fontFamily: police_champ
                          ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(nom == null?'':'$nom',style: TextStyle(
                                fontSize: taille_libelle_champ,
                                color: couleur_libelle_champ,
                                fontFamily: police_champ,
                                fontWeight: FontWeight.bold
                            ),),
                          ),
                        )
                      ],
                    )
                ),

                Padding(
                  padding: EdgeInsets.only(top: 650),
                  child: Divider(
                    height: 5,
                    color: couleur_bordure,
                  ),
                ),

                Padding(
                    padding: EdgeInsets.only(top: 670, left: 20),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Adresse email du donnateur',style: TextStyle(
                              fontSize: taille_libelle_champ,
                              color: couleur_libelle_champ,
                              fontFamily: police_champ
                          ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(email == null?'':'$email',style: TextStyle(
                                fontSize: taille_libelle_champ,
                                color: couleur_libelle_champ,
                                fontFamily: police_champ,
                                fontWeight: FontWeight.bold
                            ),),
                          ),
                        )
                      ],
                    )
                ),

                Padding(
                  padding: EdgeInsets.only(top: 720),
                  child: Divider(
                    height: 5,
                    color: couleur_bordure,
                  ),
                ),

                Padding(
                    padding: EdgeInsets.only(top: 740, left: 20),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Téléphone du donnateur',style: TextStyle(
                              fontSize: taille_libelle_champ,
                              color: couleur_libelle_champ,
                              fontFamily: police_champ
                          ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('$tel',style: TextStyle(
                                fontSize: taille_libelle_champ,
                                color: couleur_libelle_champ,
                                fontFamily: police_champ,
                                fontWeight: FontWeight.bold
                            ),),
                          ),
                        )
                      ],
                    )
                ),

                Padding(
                  padding: EdgeInsets.only(top: 788),
                  child: Divider(
                    height: 5,
                    color: couleur_bordure,
                  ),
                ),

                Padding(
                    padding: EdgeInsets.only(top: 808, left: 20, right: 20),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 10,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Montant de votre contribution',style: TextStyle(
                                        fontSize: taille_libelle_champ,
                                        color: couleur_libelle_champ,
                                        fontFamily: police_champ
                                    ),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('$montant',style: TextStyle(
                                          fontSize: taille_libelle_champ,
                                          color: couleur_libelle_champ,
                                          fontFamily: police_champ,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ),
                                  )
                                ],
                              ),
                            )
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
                  padding: EdgeInsets.only(top: 858),
                  child: Divider(
                    height: 5,
                    color: couleur_bordure,
                  ),
                ),

                Padding(
                    padding: EdgeInsets.only(top: 878, left: 20),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Votre commentaire',style: TextStyle(
                              fontSize: taille_libelle_champ,
                              color: couleur_libelle_champ,
                              fontFamily: police_champ
                          ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('$mot',style: TextStyle(
                                fontSize: taille_libelle_champ,
                                color: couleur_libelle_champ,
                                fontFamily: police_champ,
                                fontWeight: FontWeight.bold
                            ),),
                          ),
                        )
                      ],
                    )
                ),

                Padding(
                  padding: EdgeInsets.only(top: 928),
                  child: Divider(
                    height: 5,
                    color: couleur_bordure,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 928, left: 5),
                  child: new SwitchListTile(
                    value: masque==null?false:masque,
                    onChanged: _onChanged1,
                    activeColor: couleur_fond_bouton,
                    title: new Text('Masquer ma participation', style: new TextStyle(fontWeight: FontWeight.bold, color: couleur_libelle_champ, fontSize: taille_libelle_champ)),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 980),
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
                  padding: const EdgeInsets.only(top:1030,bottom: 0),
                  child: InkWell(
                    onTap: (){
                      var cardsp = new Cardsp(
                          amount: this.montant,
                          currency: this._xaf,
                          firstnameBenef: this.nom,
                          lastnameBenef: '',
                          description: this.mot,
                          mobileNumber: this.tel,
                          country: this.country,
                          email: this.email,
                          spMerchandUrl: '',
                          clientUrl: '',
                          failureUrl: '',
                          cancel_url: 'http://sprint-pay.com/',
                          return_url: 'http://sprint-pay.com/',
                          kittyID: this.id_kitty,
                          maskpart: this.masque
                      );
                      setState(() {
                        isLoding = true;
                      });
                      print(json.encode(cardsp));
                      createCard(json.encode(cardsp));
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
                      child: new Center(
                        child:isLoding==false?new Text('Valider ma contribution', style: new TextStyle(fontSize: taille_text_bouton, color: couleur_text_bouton, fontFamily: police_bouton),):CupertinoActivityIndicator(),
                      ),
                    ),
                  ),
                ),
              ],
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

  lire() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final key = 'paiement';
      _paie = prefs.getString(key)==null?"":prefs.getString(key);
      print('paiement: $_paie');
      choice = int.parse(_paie.split('^')[0]);
      nom = _paie.split('^')[1];
      print("nom: $nom");
      email = _paie.split('^')[2];
      print("email: $email");
      tel = '${_paie.split('^')[8].substring(1, _paie.split('^')[8].length)}${_paie.split('^')[3]}';
      montant = int.parse(_paie.split('^')[5]);
      mot = _paie.split('^')[4];
      masque = getBool(_paie.split('^')[6]);
      _value1 = masque;
      _xaf = _paie.split('^')[7];
      country = _paie.split('^')[8].substring(1);
      id_kitty = int.parse(_paie.split('^')[9]);
      print('id kitty $id_kitty');
    });
  }

  String getText(int val){
    switch(val){
      case 0: return "Carte de crédit";break;
      case 1: return "Sprint-pay Wallet";break;
      case 2: return "Mobile money";break;    }
    return null;
  }

  bool getBool(String str){
    if(str.toLowerCase() == 'true'){
      return true;
    }else{
      return false;
    }
  }

  // ignore: missing_return
  Future<String> createCard(var body) async {
    var _header = {
      "accept": "application/json",
      "content-type" : "application/json"
    };
    if(choice == 0){
      url = card;
      return await http.post(url, body: body, headers: _header, encoding: Encoding.getByName("utf-8")).then((http.Response response) {
        final int statusCode = response.statusCode;
        print('voici le statusCode $statusCode');
        print('body ${response.body}');
        if (statusCode < 200 || json == null) {
          print(statusCode);
          print(response.body);
          setState(() {
            isLoding = false;
          });
          throw new Exception("Error while fetching data");
        }else if(statusCode == 200){
          print(response.body);
          var convertDataToJson = json.decode(utf8.decode(response.bodyBytes));
          paie_url = convertDataToJson['paymentUrl'];
          print(paie_url);
          setState(() {
            isLoding = false;
            //this._save(null);
          });
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Webview('{$paie_url^bonjour§$_code}')));
          //Navigator.of(context).push(SlideLeftRoute(enterWidget: Webview('{$paie_url^bonjour§$_code}'), oldWidget: Verification('$_code')));
          //_launchURL(paie_url);
        }else if(statusCode == 502){
          setState(() {
            isLoding = false;
            //this._save(null);
          });
          showInSnackBar("Veuillez vérifier vos paramètres de connexion!");
        }else{
          setState(() {
            isLoding = false;
            //this._save(null);
          });
          showInSnackBar("${response.body}");
        }
        return response.body;
      });
    }else if(choice == 1){
      url = "$base_url/walletpayment/cashout";
      return await http.post(url, body: body, headers: _header, encoding: Encoding.getByName("utf-8")).then((http.Response response) {
        final int statusCode = response.statusCode;
        print('voilà le statusCode $statusCode');
        print('country ${response.body}');
        if (statusCode < 200 || json == null) {
          print(statusCode);
          print(response.body);
          setState(() {
            isLoding = false;
            //this._save(null);
          });
          throw new Exception("Error while fetching data");
        }else if(statusCode == 200 || statusCode == 403){
          var convertDataToJson = json.decode(utf8.decode(response.bodyBytes))['body'];
          setState(() {
            isLoding = false;
            //this._save(null);
          });
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Activation()));
          //Navigator.of(context).push(SlideLeftRoute(enterWidget: Activation('${convertDataToJson['spsTransactionId']}^§'), oldWidget: Verification('$_code')));
        }else if(statusCode > 400){
          print(response.body);
          //Navigator.of(context).push(SlideLeftRoute(enterWidget: Pays(), oldWidget: Configuration('$_code')));
        }else {
          setState(() {
            isLoding = false;
            //this._save(null);
          });
          showInSnackBar("${response.body}");
        }
        return response.body;
      });

    }else if(choice == 2){
      url = momo;
      return await http.post(url, body: body, headers: _header, encoding: Encoding.getByName("utf-8")).then((http.Response response) {
        final int statusCode = response.statusCode;
        print('voilà le statusCode $statusCode');
        print('body ${response.body}');
        if (statusCode < 200 || json == null) {
          print(statusCode);
          print(response.body);
          setState(() {
            isLoding = false;
            //this._save(null);
          });
          throw new Exception("Error while fetching data");
        }else if(statusCode == 200){
          print(response.body);
          var convertDataToJson = json.decode(utf8.decode(response.bodyBytes));
          paie_url = convertDataToJson['payment_url'];
          _reference = convertDataToJson['id'];
          if(paie_url!=null){
            //Orange
            setState(() {
              isLoding = false;
              //this._save(null);
            });
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Webview('{$paie_url^$_reference§$_code}')));
            //Navigator.of(context).push(SlideLeftRoute(enterWidget: Webview('{$paie_url^$_reference§$_code}'), oldWidget: Verification('$_code')));
          }else{
            //Mtn
            //_status = convertDataToJson['status'];
            ref = convertDataToJson['reference'];
            print('la référence: $ref');
            momo_url="$base_url/trans/ref/$ref";
            print('l url de référence: $momo_url');
            this._getStatus(momo_url);
          }
        }else if(statusCode == 502){
          setState(() {
            isLoding = false;
          });
          showInSnackBar("Echec de la connexion au serveur!");
        }
        else if(statusCode > 400){
          print(response.body);
          var convertDataToJson = json.decode(utf8.decode(response.bodyBytes));
          setState(() {
            isLoding = false;
            //this._save(null);
          });
          if(convertDataToJson['error'].toString().contains("phone"))
            showInSnackBar("Numéro de téléphone invalide!");
          else{
            setState(() {
              isLoding = false;
              //this._save(null);
            });
            showInSnackBar(convertDataToJson['error']);
          }
          //Navigator.of(context).push(SlideLeftRoute(enterWidget: Pays(), oldWidget: Configuration('$_code')));
        }else {
          setState(() {
            isLoding = false;
            //this._save(null);
          });
          showInSnackBar("${response.body}");
        }
        return response.body;
      });
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text(value,style:
        TextStyle(
            color: orange_F,
            fontSize: taille_description_champ
        ),
          textAlign: TextAlign.center,),
          backgroundColor: couleur_fond_bouton,
          duration: Duration(seconds: 5),));
  }

  _getStatus(String url) async {
    var response = await http.get(url);
    var convertDataToJson = json.decode(utf8.decode(response.bodyBytes));
    print('voilà ${response.statusCode}');
    print(response.body);
    if(convertDataToJson['status'] == "PROCESSED"){
      monstatus = "PROCESSED";
      setState(() {
        isLoding = false;
        this._save(null);
      });
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Confirmation(convertDataToJson['transactionID'])));
      //Navigator.of(context).push(SlideLeftRoute(enterWidget: Confirmation(''), oldWidget: Verification(_code)));
    }else if(convertDataToJson['status'] == "REFUSED"){
      if(monstatus == "PROCESSED"){
        setState(() {
          isLoding = false;
          this._save(null);
        });
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Confirmation(convertDataToJson['transactionID'])));
        //Navigator.of(context).push(SlideLeftRoute(enterWidget: Confirmation(''), oldWidget: Verification(_code)));
      }else {
        showInSnackBar(convertDataToJson['status']);
        Timer(Duration(seconds: 20), onDoneLoading);
      }
    }else if(convertDataToJson['status'] == "CREATED"){
      _getStatus(momo_url);
    }
  }

  onDoneLoading() async {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte('')));
  }
}