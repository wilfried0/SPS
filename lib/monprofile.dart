import 'package:carousel_slider/carousel_slider.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';
import 'package:services/auth/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'composants/components.dart';


// ignore: must_be_immutable
class Monprofile extends StatefulWidget {
  Monprofile(this._code);
  String _code;
  @override
  _MonprofileState createState() => new _MonprofileState(_code);
}

class _MonprofileState extends State<Monprofile> {
  _MonprofileState(this._code);
  String _code;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TabController _tabController;
  PageController pageController;
  int currentPage = 0;
  bool masque;
  int choice = 0, indik=1;
  // ignore: non_constant_identifier_names
  int recenteLenght, archiveLenght, populaireLenght, flex1, flex2, id_kitty, montant;
  bool isLoding = false;
  int flex4, flex6, taille, enlev, rest, enlev1, choix;
  double _tail, hauteurcouverture, nomright, nomtop, right1, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext, left1, social, topo, div1, div2, margeleft, margeright;
  File _image;
  // ignore: non_constant_identifier_names
  String kittyImage, monstatus, momo_url, data, _reference, ref, kittyId, country, firstnameBenef, url,momo, card, monnaie, paie_url, _xaf, endDate, startDate, title, suggested_amount, amount, description, number, _paie, nom, email, tel, mot, _nom, _ville, _quartier, _pays, _pathImage;


  @override
  void initState() {
    super.initState();
    this.lire();
    pageController = PageController(
        initialPage: currentPage,
        keepPage: false,
        viewportFraction: 0.8
    );
  }

  @override
  void dispose() {
    //_tabController.dispose();
    super.dispose();
  }

  lire() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pays = prefs.getString("pays");
      _nom = prefs.getString("nom");
      _ville = prefs.getString("ville");
      _quartier = prefs.getString("quartier");
      _pathImage = null;//prefs.getString("avatar")=="null"?null:prefs.getString("avatar").toString().split(": ")[1];
      if(_pathImage == null){
      } else {
        _pathImage = "${_pathImage.replaceAll("'", "")}";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _large = MediaQuery.of(context).size.width;
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
      flex1 = 8;
      flex2 = 4;
    }else if(_large>320 && _large<=360){
      left1 = 0;
      right1 = 150;
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
      div1 = 388;
      margeleft = 12.5;
      margeright = 12.5;
      flex1 = 8;
      flex2 = 3;
    }else if(_large == 375){
      flex1 = 8;
      flex2 = 4;
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
      margeleft = 13;
      margeright = 13;
    }else if(_large>360){
      flex1 = 9;
      flex2 = 3;
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
    }
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new DefaultTabController(
        length: 1,
        child: new Scaffold(
          key: _scaffoldKey,
          body: _buildCarousel(context),
          //bottomNavigationBar: bottomNavigate(context, _code, choix, getWidgetTontine(choix, context), Verification(_code), Pays()),
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
    return Stack(
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
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                        color: couleur_fond_bouton
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: _pathImage==null? AssetImage("images/ellipse1.png"):FileImage(new File(_pathImage)),
                                      fit: BoxFit.cover
                                  )
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(_nom==null?"":"$_nom", style: TextStyle(
                                color: Colors.white,
                                fontSize: taille_champ+3
                            ),),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _quartier=="null" && _ville=="null" && _pays=="null"?Container():Icon(Icons.location_on,color: orange_F,size: 15,),
                              Row(
                                children: <Widget>[
                                  Text(_quartier=="null"?"":" $_quartier -", style: TextStyle(
                                      color: orange_F,
                                      fontSize: taille_champ
                                  ),),
                                  Text(_ville=="null"?"":" $_ville -", style: TextStyle(
                                      color: orange_F,
                                      fontSize: taille_champ
                                  ),),
                                  Text(_pays=="null"?"":" $_pays", style: TextStyle(
                                      color: orange_F,
                                      fontSize: taille_champ
                                  ),),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: new Container(
                    child: new Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly
                      children: <Widget>[
                        Padding(
                          padding: new EdgeInsets.only(
                              top: 40,
                              right:0.0,
                              left: MediaQuery.of(context).size.width-70),
                          child: SizedBox(
                            child: Container(
                              child: Icon(Icons.camera_alt,size: 50, color: Colors.white,),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                new Container(
                  child: new Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly
                    children: <Widget>[
                      Padding(
                        padding: new EdgeInsets.only(
                            top: 40,
                            //right:0.0,
                            left: 20
                        ),
                        child: SizedBox(
                          child: Container(
                            child: Icon(Icons.arrow_back_ios,color: Colors.white,),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                getView(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getMoyen(int index){
    String text;
    switch(index){
      case 0: text = "MES INFOS";
      break;
      case 1: text = "PARRAINAGE";
      break;
      case 2: text = "SÉCURITÉ";
      break;
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      height: 70,
      decoration: BoxDecoration(
        borderRadius: new BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
        ),
        //color: couleur_fond_bouton,
        border: Border.all(
            color: couleur_fond_bouton,
            width: 2
        ),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: getIcon(choice),
          ),
          Text("$text",
            style: TextStyle(
                color:orange_F,
                fontSize: _tail,
                fontWeight: FontWeight.bold
            ),)
        ],
      ),
    );
  }

  Widget getIcon(int index){
    switch(index){
      case 0: return Icon(
        Icons.person,
        color: orange_F,
        size: 40,
      );
      case 1: return Icon(
        Icons.supervised_user_circle,
        color: orange_F,
        size: 40,
      );
      case 2: return Icon(
        Icons.security,
        color: orange_F,
        size: 40,
      );
    }
  }

  Widget getView(){
    //if(choice == 0){
      return Padding(
          padding: EdgeInsets.only(top: 300, left: 0, right: 0),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 20, left: 0, right: 0),
                child: CarouselSlider(
                  enlargeCenterPage: true,
                  autoPlay: false,
                  enableInfiniteScroll: true,
                  onPageChanged: (value){
                    setState(() {
                      choice = value;
                      print(choice);
                    });
                  },
                  height: 80.0,
                  items: [0,1,2].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return getMoyen(i);
                      },
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top:90),
                child: SingleChildScrollView(
                  child:choice == 0? Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Container(
                          margin: EdgeInsets.only(top: 0.0),
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                            color: Colors.transparent,
                            border: Border.all(
                              width: .5,
                              color: couleur_fond_bouton,
                            ),
                          ),
                          height: 50,
                          child: Row(
                            children: <Widget>[
                              new Expanded(
                                flex:2,
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: new Icon(Icons.person, color: couleur_fond_bouton,)
                                ),
                              ),
                              new Expanded(
                                flex:10,
                                child: Padding(
                                  padding: EdgeInsets.only(left:0.0),
                                  child: new TextFormField(
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                    validator: (String value){
                                      if(value.isEmpty){
                                        return "Champ prénom vide !";
                                      }else{
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration.collapsed(
                                      hintText: 'prénom',
                                      hintStyle: TextStyle(color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                      //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                        child: Container(
                          margin: EdgeInsets.only(top: 0.0),
                          decoration: new BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              width: .5,
                              color: couleur_fond_bouton,
                            ),
                          ),
                          height: 50,
                          child: Row(
                            children: <Widget>[
                              new Expanded(
                                flex:2,
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: new Icon(Icons.person, color: couleur_fond_bouton,)
                                ),
                              ),
                              new Expanded(
                                flex:10,
                                child: Padding(
                                  padding: EdgeInsets.only(left:0.0),
                                  child: new TextFormField(
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                    validator: (String value){
                                      if(value.isEmpty){
                                        return "Champ nom vide !";
                                      }else{
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration.collapsed(
                                      hintText: 'Nom',
                                      hintStyle: TextStyle(color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                      //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                        child: Container(
                          margin: EdgeInsets.only(top: 0.0),
                          decoration: new BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              width: .5,
                              color: couleur_fond_bouton,
                            ),
                          ),
                          height: 50,
                          child: Row(
                            children: <Widget>[
                              new Expanded(
                                flex:2,
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: new Icon(Icons.location_on, color: couleur_fond_bouton,)
                                ),
                              ),
                              new Expanded(
                                flex:10,
                                child: Padding(
                                  padding: EdgeInsets.only(left:0.0),
                                  child: new TextFormField(
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black
                                    ),
                                    validator: (String value){
                                      if(value.isEmpty){
                                        return "Champ pays vide !";
                                      }else{
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration.collapsed(
                                      hintText: 'Pays de résidence',
                                      hintStyle: TextStyle(color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                      //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                        child: Container(
                          margin: EdgeInsets.only(top: 0.0),
                          decoration: new BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              width: .5,
                              color: couleur_fond_bouton,
                            ),
                          ),
                          height: 50,
                          child: Row(
                            children: <Widget>[
                              new Expanded(
                                flex:2,
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: new Icon(Icons.add_location, color: couleur_fond_bouton,)
                                ),
                              ),
                              new Expanded(
                                flex:10,
                                child: Padding(
                                  padding: EdgeInsets.only(left:0.0),
                                  child: new TextFormField(
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black
                                    ),
                                    validator: (String value){
                                      if(value.isEmpty){
                                        return "Champ adresse vide !";
                                      }else{
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration.collapsed(
                                      hintText: 'Adresse',
                                      hintStyle: TextStyle(color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                      //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                        child: Container(
                          margin: EdgeInsets.only(top: 0.0),
                          decoration: new BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              width: .5,
                              color: couleur_fond_bouton,
                            ),
                          ),
                          height: 50,
                          child: Row(
                            children: <Widget>[
                              new Expanded(
                                flex:2,
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: new Icon(Icons.directions, color: couleur_fond_bouton,)
                                ),
                              ),
                              new Expanded(
                                flex:10,
                                child: Padding(
                                  padding: EdgeInsets.only(left:0.0),
                                  child: new TextFormField(
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                    validator: (String value){
                                      if(value.isEmpty){
                                        return "Code postal vide";
                                      }else{
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration.collapsed(
                                      hintText: 'Code postal',
                                      hintStyle: TextStyle(color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                      //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                        child: Container(
                          margin: EdgeInsets.only(top: 0.0),
                          decoration: new BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              width: .5,
                              color: couleur_fond_bouton,
                            ),
                          ),
                          height: 50,
                          child: Row(
                            children: <Widget>[
                              new Expanded(
                                flex:2,
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: new Icon(Icons.email, color: couleur_fond_bouton,)
                                ),
                              ),
                              new Expanded(
                                flex:10,
                                child: Padding(
                                  padding: EdgeInsets.only(left:0.0),
                                  child: new TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                    validator: (String value){
                                      if(value.isEmpty){
                                        return "Champ email vide !";
                                      }else{
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration.collapsed(
                                      hintText: 'Email',
                                      hintStyle: TextStyle(color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                      //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                        child: Container(
                          margin: EdgeInsets.only(top: 0.0),
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                            ),
                            color: Colors.transparent,
                            border: Border.all(
                              width: .5,
                              color: couleur_fond_bouton,
                            ),
                          ),
                          height: 50,
                          child: Row(
                            children: <Widget>[
                              new Expanded(
                                flex:2,
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: new Icon(Icons.phone_android, color: couleur_fond_bouton,)
                                ),
                              ),
                              new Expanded(
                                flex:10,
                                child: Padding(
                                  padding: EdgeInsets.only(left:0.0),
                                  child: new TextFormField(
                                    keyboardType: TextInputType.phone,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                    validator: (String value){
                                      if(value.isEmpty){
                                        return "Champ téléphone vide !";
                                      }else{
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration.collapsed(
                                      hintText: 'Contact téléphonique',
                                      hintStyle: TextStyle(color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                      //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:20,bottom: 20, right: 20, left: 20),
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              showInSnackBar("Service pas encore disponible.", _scaffoldKey);
                              //isLoding = true;
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
                              borderRadius: new BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                                topLeft: Radius.circular(10.0),
                              ),
                            ),
                            child: new Center(
                              child:isLoding==false?new Text('Modifier  mon profile', style: new TextStyle(fontSize: taille_text_bouton, color: couleur_text_bouton),):CupertinoActivityIndicator(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ):choice == 1?Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Container(
                          margin: EdgeInsets.only(top: 0.0),
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                            color: Colors.transparent,
                            border: Border.all(
                              width: .5,
                              color: couleur_fond_bouton,
                            ),
                          ),
                          height: 50,
                          child: Row(
                            children: <Widget>[
                              new Expanded(
                                flex:4,
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: new CountryCodePicker(
                                      showFlag: true,
                                      onChanged: (code){

                                      },
                                    )
                                ),
                              ),
                              new Expanded(
                                flex:8,
                                child: Padding(
                                  padding: EdgeInsets.only(left:0.0),
                                  child: new TextFormField(
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                    validator: (String value){
                                      if(value.isEmpty){
                                        return "Parrain vide !";
                                      }else{
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration.collapsed(
                                      hintText: 'Pays du parrain',
                                      hintStyle: TextStyle(color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                      //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                        child: Container(
                          margin: EdgeInsets.only(top: 0.0),
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                            ),
                            color: Colors.transparent,
                            border: Border.all(
                              width: .5,
                              color: couleur_fond_bouton,
                            ),
                          ),
                          height: 50,
                          child: Row(
                            children: <Widget>[
                              new Expanded(
                                flex:2,
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: new Icon(Icons.phone_android, color: couleur_fond_bouton,)
                                ),
                              ),
                              new Expanded(
                                flex:10,
                                child: Padding(
                                  padding: EdgeInsets.only(left:0.0),
                                  child: new TextFormField(
                                    keyboardType: TextInputType.phone,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                    validator: (String value){
                                      if(value.isEmpty){
                                        return null;
                                      }else{
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration.collapsed(
                                      hintText: 'Contact fu parrain (facultatif)',
                                      hintStyle: TextStyle(color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                      //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:20,bottom: 20, right: 20, left: 20),
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              isLoding = true;
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
                              borderRadius: new BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                                topLeft: Radius.circular(10.0),
                              ),
                            ),
                            child: new Center(
                              child:isLoding==false?new Text('Valider', style: new TextStyle(fontSize: taille_text_bouton, color: couleur_text_bouton),):CupertinoActivityIndicator(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ):Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Container(
                          margin: EdgeInsets.only(top: 0.0),
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                            color: Colors.transparent,
                            border: Border.all(
                              width: .5,
                              color: couleur_fond_bouton,
                            ),
                          ),
                          height: 50,
                          child: Row(
                            children: <Widget>[
                              new Expanded(
                                flex:2,
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: new Icon(Icons.person, color: couleur_fond_bouton,)
                                ),
                              ),
                              new Expanded(
                                flex:10,
                                child: Padding(
                                  padding: EdgeInsets.only(left:0.0),
                                  child: new TextFormField(
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                    validator: (String value){
                                      if(value.isEmpty){
                                        return "Code de récupération vide !";
                                      }else{
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration.collapsed(
                                      hintText: 'Code de récupération',
                                      hintStyle: TextStyle(color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                      //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                        child: Container(
                          margin: EdgeInsets.only(top: 0.0),
                          decoration: new BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              width: .5,
                              color: couleur_fond_bouton,
                            ),
                          ),
                          height: 50,
                          child: Row(
                            children: <Widget>[
                              new Expanded(
                                flex:2,
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: new Icon(Icons.email, color: couleur_fond_bouton,)
                                ),
                              ),
                              new Expanded(
                                flex:10,
                                child: Padding(
                                  padding: EdgeInsets.only(left:0.0),
                                  child: new TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                    validator: (String value){
                                      if(value.isEmpty){
                                        return "Nouveau mot de passe vide !";
                                      }else{
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration.collapsed(
                                      hintText: 'Nouveau mot de passe',
                                      hintStyle: TextStyle(color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                      //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                        child: Container(
                          margin: EdgeInsets.only(top: 0.0),
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                            ),
                            color: Colors.transparent,
                            border: Border.all(
                              width: .5,
                              color: couleur_fond_bouton,
                            ),
                          ),
                          height: 50,
                          child: Row(
                            children: <Widget>[
                              new Expanded(
                                flex:2,
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: new Icon(Icons.phone_android, color: couleur_fond_bouton,)
                                ),
                              ),
                              new Expanded(
                                flex:10,
                                child: Padding(
                                  padding: EdgeInsets.only(left:0.0),
                                  child: new TextFormField(
                                    keyboardType: TextInputType.phone,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                    validator: (String value){
                                      if(value.isEmpty){
                                        return "Vérification mot de passe vide !";
                                      }else{
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration.collapsed(
                                      hintText: 'Vérification du nouveau mot de passe',
                                      hintStyle: TextStyle(color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                      //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:20,bottom: 20, right: 20, left: 20),
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              showInSnackBar("Service pas encore disponible.", _scaffoldKey);
                              //isLoding = true;
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
                              borderRadius: new BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                                topLeft: Radius.circular(10.0),
                              ),
                            ),
                            child: new Center(
                              child:isLoding==false?new Text('Modifier mon mot de passe', style: new TextStyle(fontSize: taille_text_bouton, color: couleur_text_bouton,),):CupertinoActivityIndicator(),
                            ),
                          ),
                        ),
                      ),

                      InkWell(
                        onTap: (){

                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 0, bottom: 20),
                          child: Center(
                            child: Text("Demander un nouveau code", style: TextStyle(
                                color: couleur_fond_bouton,
                                fontWeight: FontWeight.bold
                            ),),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
      );
  }
}