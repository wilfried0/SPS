import 'dart:convert';
import 'dart:io';
import 'package:services/community/lib/confirma.dart';
import 'package:services/community/lib/echec.dart';
import 'package:services/community/lib/paiement/getCode.dart';
import 'package:services/community/lib/paiement/ioswebview.dart';
import 'package:services/community/lib/paiement/participationtontine1.dart';
import 'package:services/community/lib/paiement/webview.dart';
import 'package:services/community/lib/utils/components.dart';
import 'package:services/community/lib/utils/services.dart';
import 'package:services/composants/components.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Paiementtontine2 extends StatefulWidget {
  Paiementtontine2(codetontine);
  String codetontine;
  @override
  _Paiementtontine2State createState() => _Paiementtontine2State(codetontine);
}

class _Paiementtontine2State extends State<Paiementtontine2> {
  _Paiementtontine2State(_code);
  String tontine_url, _codetontine, kittyImage, roundId, kittyId, _id, payment_url, _token, country, url, title,_password, _username, montant, prenom, nom, email, description, mobileNumber, _url, currency, currencySymbol, _tel, flagUri, dial_code;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();
  double _tail,_taill, _width, hauteurcouverture, nomright, nomtop, right1, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext, _larg, left1, social, topo, div1, div2, margeleft, margeright;
  int indik, temps = 600;
  int flex4, flex6, taille, enlev, rest, enlev1, choix, recenteLenght, archiveLenght, populaireLenght, flex1, flex2, id_kitty;
  File _image;
  bool _value1 = false,  isLoading = false;
  double fontSize =35, height = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.lire();
  }

  @override
  void dispose() {
    super.dispose();
  }

  lire() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      montant = prefs.getString(MONTANT_PART);
      prenom = prefs.getString(PRENOM_PART);
      nom = prefs.getString(NOM_PART);
      _tel = prefs.getString(TEL_PART);
      description = prefs.getString(DESCRIPTION_P);
      email = prefs.getString(EMAIL_P);
      _value1 = prefs.getString(MASK_PART) == "true"?true:false;
      _username = prefs.getString(PHONE_P);
      roundId = prefs.getString(ID_TONTINE_X);
      kittyImage = prefs.getString(KITTY_IMAGE);
      flagUri = prefs.getString(FLAG_CAGNOTTE);
      country = prefs.getString("iso3");
      title = prefs.getString(TITLE_KITTY);
      indik = int.parse(prefs.getString(CHOIX_PART))+1;
      _token = prefs.getString(TOKEN);
      dial_code = prefs.getString(DIAL_CODE);
      print("Mon indik: $indik");
      final tontine_url = "http://74.208.183.205:8086/spcommunity-tontine/api";
      if(indik == 1){
        url = "$tontine_url/payments/participate_by_om";
      }else if(indik == 2){
        url = "$tontine_url/payments/participate_by_momo";
      }else if(indik == 3){
        url = "$tontine_url/payments/participate_by_wallet_init";
      }else {
        url = "$tontine_url/payments/participate_by_paypal";
      }
      currency = prefs.getString(CURRENCY);
      currencySymbol = prefs.getString(CURRENCYSYMBOL);
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
    return Scaffold(
      key: _scaffoldKey,
      body: _buildBody(context),
      bottomNavigationBar: barreBottom,
    );
  }

  _buildBody(BuildContext context) {
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
                kittyImage==null?Container():Container(
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
                            top: 300-45.0,
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
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Paiementtontine1(_codetontine)));
                              //Navigator.of(context).push(SlideLeftRoute(enterWidget: Paiement(_code), oldWidget: Verification(_code)));
                            });
                          },
                          child: Icon(Icons.arrow_back_ios,color: Colors.white,)
                      ),
                      InkWell(
                        onTap: (){
                          setState(() {
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Paiementtontine1(_codetontine)));
                            //Navigator.of(context).push(SlideLeftRoute(enterWidget: Paiement(_code), oldWidget: Verification(_code)));
                          });
                        },
                        child: Text('Retour',
                          style: TextStyle(color: Colors.white, fontSize: taille_champ),),
                      )
                    ],
                  ),
                ),

                title==null?Container():Padding(
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
                            fontSize: taille_champ+3,
                            fontWeight: FontWeight.normal
                        ),),
                    ),
                  ),
                ),

                Padding(
                    padding: EdgeInsets.only(top: 522, left: 20, right: 20),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Moyen de payement utilisé',
                            style: TextStyle(
                              fontSize: taille_champ+3,
                              color: couleur_libelle_champ,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: flex1,
                                child:getText(indik)==null?Container(): Text(
                                  getText(indik),
                                  style: TextStyle(
                                      fontSize: taille_libelle_champ,
                                      color: couleur_libelle_champ,
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
                                        color: indik==4?orange_F:couleur_libelle_champ,
                                        size: 30,
                                      ),
                                      Icon(
                                        Icons.web,
                                        color: indik==3?orange_F:couleur_libelle_champ,
                                        size: 30,
                                      ),
                                      Icon(
                                        Icons.phone_iphone,
                                        color: indik==2||indik==1?orange_F:couleur_libelle_champ,
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
                    padding: EdgeInsets.only(top: 594, left: 20),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Nom et prénom du tontineur',style: TextStyle(
                            fontSize: taille_champ+3,
                            color: couleur_libelle_champ,
                          ),),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(nom == null?'':'$nom',style: TextStyle(
                              fontSize: taille_champ+3,
                              color: couleur_libelle_champ,
                              fontWeight: FontWeight.bold
                          ),),
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
                    padding: EdgeInsets.only(top: 664, left: 20),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Adresse email du tontineur',style: TextStyle(
                            fontSize: taille_champ+3,
                            color: couleur_libelle_champ,
                          ),),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(email == null?'':'$email',style: TextStyle(
                              fontSize: taille_champ+3,
                              color: couleur_libelle_champ,
                              fontWeight: FontWeight.bold
                          ),),
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
                    padding: EdgeInsets.only(top: 734, left: 20),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Téléphone du tontineur',style: TextStyle(
                            fontSize: taille_champ+3,
                            color: couleur_libelle_champ,
                          ),),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('$_tel',style: TextStyle(
                              fontSize: taille_champ+3,
                              color: couleur_libelle_champ,
                              fontWeight: FontWeight.bold
                          ),),
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
                    padding: EdgeInsets.only(top: 802, left: 20, right: 20),
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
                                      fontSize: taille_champ+3,
                                      color: couleur_libelle_champ,
                                    ),),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('$montant',style: TextStyle(
                                        fontSize: taille_champ+3,
                                        color: couleur_libelle_champ,
                                        fontWeight: FontWeight.bold
                                    ),),
                                  )
                                ],
                              ),
                            )
                        ),
                        Expanded(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Text('$currencySymbol',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: couleur_libelle_champ,
                                    fontSize: taille_champ+3
                                ),),
                            )
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
                    padding: EdgeInsets.only(top: 872, left: 20),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Votre commentaire sur la tontine',style: TextStyle(
                            fontSize: taille_champ+3,
                            color: couleur_libelle_champ,
                          ),),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('$description',style: TextStyle(
                              fontSize: taille_champ+3,
                              color: couleur_libelle_champ,
                              fontWeight: FontWeight.bold
                          ),),
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
                    value: _value1,
                    onChanged: (val){},
                    activeColor: couleur_fond_bouton,
                    title: new Text('Masquer ma participation', style: new TextStyle(fontWeight: FontWeight.normal, color: couleur_libelle_champ, fontSize: taille_champ+3)),
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
                      var oMomoTontine = new OMoMoTontine(
                          description: description,
                          email: email,
                          fees: 0,
                          roundId: int.parse(roundId)+2,
                          mobileNumber:_username,
                          failureUrl: "http://www.sprint-pay.com/",
                          successUrl: "http://www.sprint-pay.com/"
                      );
                      print(json.encode(oMomoTontine));
                      checkConnection1(json.encode(oMomoTontine));
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
                        child:isLoading==false?new Text('Valider ma contribution', style: new TextStyle(color: couleur_text_bouton),):CupertinoActivityIndicator(),
                      ),
                    ),
                  ),
                ),
                /*Padding(
                  padding: const EdgeInsets.only(top:1030,bottom: 0),
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Offrir1('')));
                      });
                      /*var oMomo = new OMoMo(
                          amount: int.parse(this.montant.replaceAll(".", "")),
                          country: country,
                          description: description,
                          email: email,
                          fees: 0,
                          kittyID: int.parse(kittyId),
                          maskpart: _value1,
                          firstname: "",
                          lastname: nom,
                          to: indik == 3?"${dial_code.substring(1)}$_tel":_username,
                          mobileNumber:indik == 3?"$_username": "$_tel",
                          failureUrl: "http://www.sprint-pay.com/",
                          successUrl: "http://www.sprint-pay.com/"
                      );
                      print(json.encode(oMomo));
                      checkConnection(json.encode(oMomo));*/
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
                        child: Text('Valider ma contribution', style: new TextStyle(color: couleur_text_bouton),)
                      ),
                    ),
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getMoyen(int index){
    String text, img;
    switch(index){
      case 1: text = "ORANGE MONEY";img = 'images/orange.png';
      break;
      case 2: text = "MTN MOBILE MONEY";img = 'images/mtn.jpg';
      break;
      case 3: text = "SPRINT-PAY WALLET";img = 'images/sps.png';
      break;
      case 4: text = "CARTE PAYPAL";img = 'images/carte.jpg';
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
                height: 80,
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
                    )
                ),),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: index-1!=indik? Text('$text',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold
                  ),):Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('$text',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
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

  void checkConnection1(var body) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        isLoading =true;
        contribKitty1(body);
      });

    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        isLoading =true;
        contribKitty1(body);
      });
    } else {
      showInSnackBar("Service indisponible!", _scaffoldKey, 5);
    }
  }

  Future<String> contribKitty1(var body) async {
    print("Mon url: $url");
    print("Mon token :$_token");
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString("username");
    _password = prefs.getString("password");
    print("$_username, $_password");
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse("$url"));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json');
    if(indik == 3)
    request.headers.set("Authorization", "Basic $credentials");
    request.add(utf8.encode(body));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print("statusCode ${response.statusCode}");
    print("body $reply");
    if (response.statusCode < 200 || json == null) {
      setState(() {
        isLoading = false;
      });
      throw new Exception("Error while fetching data");
    }else if(response.statusCode == 200){
      var responseJson = json.decode(reply);
      _id = responseJson['id'].toString();
      payment_url = responseJson['payment_url'];
      if(payment_url != null){
        setState(() {
          isLoading = false;
        });
        save();
        if(Platform.isIOS){
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new IosWebview("$_codetontine^c")));
        }else
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Webview("$_codetontine^c")));
      }else{
        if(indik == 3){
          setState(() {
            isLoading = false;
          });
          this.getcode(context);
        }else
          this.getStatus(_id);
      }
    }else if(response.statusCode == 403){
      setState(() {
        isLoading = false;
      });
      if(indik == 3)
        showInSnackBar("Compte SprintPay inexistant!", _scaffoldKey, 5);
      else
        showInSnackBar("Service indisponible!", _scaffoldKey, 5);
    } else {
      setState(() {
        isLoading = false;
      });
      showInSnackBar("Echec de l'opération!", _scaffoldKey, 5);
    }
    return null;
  }

  Future<void> getcode(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return GetCode(
          scaffold: _scaffoldKey,
          id: _id,
        );
      },
    );
  }



  Future<String> getStatus(String id) async {
    var url = "$checkPayUrl/transaction/payment/status/$id";
    print(url);
    print("Mon token :$_token");
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json'); //"Authorization": "Bearer $_token"
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print("statusCode ${response.statusCode}");
    print("body $reply");
    if(response.statusCode == 200){
      var responseJson = json.decode(reply);
      if(responseJson['status'] == "CREATED"){
        if(temps == 0){
          setState(() {
            isLoading = false;
          });
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Echec('part')));
        }else if(temps > 0){
          temps--;
          getStatus(id);
        }
      }else if(responseJson['status'] == "PROCESSED"){
        setState(() {
          isLoading = false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Confirma('part')));
      }else if(responseJson['status'] == "REFUSED"){
        setState(() {
          isLoading = false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Echec('part')));
      }else{
        setState(() {
          isLoading = false;
        });
        showInSnackBar("Service indisponible!", _scaffoldKey, 5);
      }
    }else{
      setState(() {
        isLoading = false;
      });
      showInSnackBar("Service indisponible", _scaffoldKey, 5);
    }
    return null;
  }

  String getText(int val){
    String result;
    switch(val){
      case 4: setState(() {
        result = "Carte de crédit paypal";
      });break;
      case 3: setState(() {
        result = "Sprint-pay Wallet";
      });break;
      case 2: setState(() {
        result = "MTN Mobile money";
      });break;
      case 1: setState(() {
        result = "ORANGE Mobile money";
      });break;
    }
    return result;
  }

  void save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("payment_url", "$payment_url");
    prefs.setString("id", "$_id");
    print("mon payment_url $payment_url  et mon id $_id");
  }
}