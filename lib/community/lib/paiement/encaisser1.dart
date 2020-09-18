import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:services/composants/components.dart';
import '../cagnottes/detail.dart';
import 'package:flutter/material.dart';
import '../utils/components.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'encaisser2.dart';


class Encaisser1 extends StatefulWidget {
  Encaisser1(this._code);
  String _code;
  @override
  _Encaisser1State createState() => new _Encaisser1State(_code);
}

class _Encaisser1State extends State<Encaisser1> {
  _Encaisser1State(this._code);
  String _code;
  var _userTextController;
  GlobalKey<ScaffoldState> _scaffoldKey;
  int recenteLenght, archiveLenght, populaireLenght, id_kitty;
  var _formKey = GlobalKey<FormState>();
  int flex4, flex6, taille, enlev, rest, enlev1, _id;
  double _tail,_taill,gauch, droit, _width, hauteurcouverture, nomright, nomtop, right1, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext, _larg, left1, social, topo, div1, div2, margeleft, margeright;
  File _image;
  List data, list;
  String kittyImage, firstnameBenef,kittyId,remain, particip, previsional_amount,amount_collected, endDate, startDate, title, suggested_amount, amount, description, number, nom="", tel="", email="", montant="", mot="";

  @override
  void initState() {
    super.initState();
    this.read();
    _userTextController = new MoneyMaskedTextController(decimalSeparator: '', thousandSeparator: '.', precision: 0);
    //isLoding = false;
    kittyImage = _code.split('^')[1];
    firstnameBenef = _code.split('^')[2];
    endDate = _code.split('^')[3];
    startDate = _code.split('^')[4];
    title = _code.split('^')[5];
    previsional_amount = _code.split('^')[6]; //previsional_amount
    amount_collected = _code.split('^')[7];
    print("amount_collected: $amount_collected");//amount_collected
    description = _code.split('^')[8];
    number = _code.split('^')[9];
    kittyId = _code.split('^')[10];
    particip = _code.split('^')[11];
    //currency = _code.split('^')[12];
    remain = _code.split('^')[13];
//_code = '$index ${_cagnottes[index]["kittyImage"]} ${_cagnottes[index]["firstnameBenef"]} ${_cagnottes[index]["endDate"]} ${_cagnottes[index]["startDate"]} ${_cagnottes[index]["title"]} ${_cagnottes[index]["suggested_amount"]} ${_cagnottes[index]["amount"]} ${_cagnottes[index]["description"]}';
  }

  @override
  void dispose() {
    _userTextController.dispose();
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
      _tail = taille_description_champ-1;
      _taill = taille_description_champ-2;
      gauch = 20;
      droit = 20;
    }else if(_large>320 && _large<=414){
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
      gauch = 60;
      droit = 60;
    }
    return new Scaffold(
      backgroundColor: GRIS,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(0.0),
            child: new AppBar(
              elevation: 0.0,
              backgroundColor: GRIS,
              flexibleSpace: barreTop,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Detail('$_code')));
                }
              ),
              iconTheme: new IconThemeData(color: couleur_fond_bouton),
            ),
          ),
        body: _buildCarousel(context),
        bottomNavigationBar: barreBottom
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

                  Padding(
                    padding: EdgeInsets.only(top: 70, left: gauch, right: droit),
                    child: Center(
                      child: Text('Etape 1 sur 2',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: taille_libelle_etape,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 190, left: gauch, right: droit),
                    child: Center(
                      child: Text('Encaisser ma cagnotte',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: taille_titre-2,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  new Container(
                    child: new Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly
                      children: <Widget>[
                        Padding(
                          padding: new EdgeInsets.only(
                              top: 300.0-45,
                              right: 0.0,
                              left: 20.0),
                          child: SizedBox(
                            child: Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                      image: _image == null?AssetImage("images/ellipse1.png"):Image.file(_image),
                                      fit: BoxFit.cover
                                  )
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 255, right: MediaQuery.of(context).size.width-enlev1, left: 10),
                          child: Text('',//firstnameBenef,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: taille_champ
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 23, left: 20, right: 20),
                    child: Row(
                      children: <Widget>[
                        InkWell(
                            onTap: (){
                              setState(() {
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Detail('$_code')));
                                //Navigator.of(context).push(SlideLeftRoute(enterWidget: Detail(_code), oldWidget: Encaisser1(_code)));
                              });
                            },
                            child: Icon(Icons.arrow_back_ios,color: Colors.white,)
                        ),
                        InkWell(
                          onTap: (){
                            setState(() {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Detail('$_code')));
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
                    padding: EdgeInsets.only(top: 335, left: 20, right: 20),
                    child: Text('Moyen par lequel vous allez encaisser votre cagnotte',
                      style: TextStyle(
                          color: couleur_libelle_champ,
                          fontSize: taille_champ+3,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 385, left: 0, right: 0),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: CarouselSlider(
                        enlargeCenterPage: true,
                        autoPlay: false,
                        enableInfiniteScroll: false,
                        onPageChanged: (value){},
                        height: 105.0,
                        items: [1].map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return getMoyen(1);
                            },
                          );
                        }).toList(),
                      ),
                    )
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 505, left: 20, right: 20),
                    child: Text('Quel montant souhaitez-vous encaisser?',
                      style: TextStyle(
                          color: couleur_libelle_champ,
                          fontSize: taille_champ+3,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 550),
                    child: Container(
                      margin: EdgeInsets.only(top: 0.0),
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                        color: Colors.white,
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
                                keyboardType: TextInputType.numberWithOptions(),
                                style: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize: taille_champ+3,
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
                                  hintText: 'Montant à encaisser',
                                  hintStyle: TextStyle(
                                      color: couleur_libelle_champ,
                                      fontSize: taille_champ+3,
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
                    padding: EdgeInsets.only(top:610,left: 20, right: 20),
                    child: InkWell(
                      onTap: (){

                        if(_formKey.currentState.validate()){
                          if((double.parse(montant.replaceAll(".", ""))+double.parse(montant.replaceAll(".", ""))*0.05)<=double.parse(remain)){
                            this._save(montant);
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Encaisser2('$_code')));
                          }else{
                            this._ackAlert(context, "Le montant à encaisser doit être inférieur à ${double.parse(remain)-double.parse(remain)*0.05}");
                          }
                        }
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
                        child: new Center(child: new Text('Poursuivre', style: new TextStyle( color: couleur_text_bouton),),),
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
    prefs.setString(MONTANT_ENCAISSE, valeur);
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      montant = prefs.getString(MONTANT_ENCAISSE)==null?"":prefs.getString(MONTANT_ENCAISSE);
      _userTextController.text = montant==""?"0":montant;
    });
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
    String img;
    switch(index){
      case 1: img = 'communityimages/sps.png';
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
        color: Colors.white,//index-1==indik&&(indik==2||indik==3)?Colors.white:index-1==indik?orange_F:bleu_F,
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 0),
        child: GestureDetector(
          onTap: (){
            setState(() {
              //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Retrait1('$_code')));
            });
          },
          child: Container(
            height: 60,
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
                  fit: BoxFit.fill,
                )
            ),),
        ),
      ),
    );
  }
}