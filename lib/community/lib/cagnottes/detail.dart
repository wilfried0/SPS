import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:services/community/lib/paiement/participation1.dart';
import 'package:services/composants/components.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../getDrawerContent.dart';
import '../paiement/encaisser1.dart';
import '../paiement/offrir1.dart';
import 'package:flutter/material.dart';
import '../utils/components.dart';
import '../cagnotte.dart';
import 'dart:io';
import 'commentaires.dart';
import 'participants.dart';
import 'configuration.dart';
import '../utils/services.dart';

class Detail extends StatefulWidget {
  Detail(this._code);
  String _code;
  @override
  _DetailState createState() => new _DetailState(_code);
}

class _DetailState extends State<Detail> {
  _DetailState(this._code);
  String _code;
  int recenteLenght, archiveLenght, populaireLenght, choix, titre=45;
  int flex4, flex6, taille, enlev, rest, enlev1, _nbr, choice, xval, tai;
  double _width, hauteurcouverture, nomright, nomtop, right1, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext, _larg, left1, social, topo, div1, div2, margeleft, margeright;
  File _image;
  String _url, url, kittyImage,_token,currency,remain, remaining_amount, firstnameBenef, endDate, startDate, title, previsional_amount, amount_collected, description, number, particip, kittyId;
  List _cagnottes;
  bool isLoding=false;
  var _formKey2 = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    isLoding = false;
    kittyImage = _code.split('^')[1];
    firstnameBenef = _code.split('^')[2];
    endDate = _code.split('^')[3];
    startDate = _code.split('^')[4];
    title = _code.split('^')[5];
    previsional_amount = _code.split('^')[6]; //previsional_amount
    amount_collected = _code.split('^')[7];
    remaining_amount = _code.split('^')[13];
    print("remaining_amount: $remaining_amount");
    print("amount_collected: $amount_collected");//amount_collected
    description = _code.split('^')[8];
    number = _code.split('^')[9];
    kittyId = _code.split('^')[10];
    particip = _code.split('^')[11];
    currency = _code.split('^')[12];
    remain = _code.split('^')[13];
    choice = -1;
    this.read();
  }

  @override
  void dispose() {
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
      _larg = 45;
      enlev1 = 243;
      right1 = 120;
      left1 = 0;
      social = 25;
      topo = 480;
      div1 = 410;
      margeleft = 10.5;
      margeright = 10;
      xval = 1;
      tai = 25;
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
      _larg = 55;
      enlev1 = 260;
      social = 30;
      topo = 480;
      div1 = 410;
      margeleft = 11.5;
      margeright = 11.5;
      xval = 0;
      tai = 25;
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
      _larg = 55;
      enlev1 = 260;
      social = 30;
      topo = 480;
      div1 = 410;
      margeleft = 12;
      margeright = 12;
      xval = 0;
      tai = 40;
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
      _larg = 55;
      enlev1 = 260;
      social = 30;
      topo = 480;
      div1 = 410;
      margeleft = 14;
      margeright = 13;
      xval = 0;
      tai = 25;
    }
    return new Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            child: getDrawerContent(),
          ),
          endDrawer: getDrawerContent(),
          body: _buildCarousel(context),
          bottomNavigationBar: bottomNavigation(context, _scaffoldKey,  choix, _token),
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
            child: Stack(
              children: <Widget>[
                Container(
                  height: hauteurcouverture,
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
                      image:kittyImage!=null && kittyImage.startsWith(cagnotte_url)?
                      DecorationImage(
                          image: NetworkImage(kittyImage),
                          fit: BoxFit.cover
                      )
                      :DecorationImage(
                          image: NetworkImage("images/cover.jpg"),
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
                            top: hauteurcouverture-55,
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
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 280, right: MediaQuery.of(context).size.width-enlev1),
                            child: Text('',//firstnameBenef,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: taille_champ
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Container(
                              height: 30,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text((DateTime.parse(endDate).difference(DateTime.parse(startDate))).inDays>=0?
                                  (DateTime.parse(endDate).difference(DateTime.parse(startDate))).inDays.toString():
                                  "",
                                    style: TextStyle(
                                        color: couleur_libelle_champ,
                                        fontSize: taille_libelle_champ,
                                        fontWeight: FontWeight.bold
                                    ),),
                                  Text((DateTime.parse(endDate).difference(DateTime.parse(startDate))).inDays>0?' Jour(s) Restant(s)':
                                  "Expirée",
                                    style: TextStyle(
                                        color: couleur_libelle_champ,
                                        fontSize: taille_libelle_champ-xval,
                                        fontWeight: FontWeight.normal
                                    ),)
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 335),
                  child: Divider(
                    height: 5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 23, left: 20, right: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: <Widget>[
                            InkWell(
                                onTap: (){
                                  setState(() {
                                    //Navigator.pop(context);
                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte('')));
                                    //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Detail(_code)));
                                  });
                                },
                                child: Icon(Icons.arrow_back_ios,color: Colors.white,)
                            ),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  //Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte('')));
                                  //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Detail(_code)));
                                });
                              },
                              child: Text('Retour',
                                style: TextStyle(color: Colors.white, fontSize: taille_champ),),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          flex:flex4>1? flex4-2:flex4,
                          child: Text('')
                      ),
                      Expanded(
                        flex: flex6,
                        child: Row(
                          children: <Widget>[
                            InkWell(
                              onTap: (){
                                setState(() {
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Configuration()));
                                  //Navigator.of(context).push(SlideLeftRoute(enterWidget: Configuration(_code), oldWidget: Detail(_code)));
                                });
                              },
                              child: Container(
                                  height: 0,
                                  width: 0,
                                  child: new Image.asset('communityimages/edit.png')),
                            ),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Configuration()));
                                  //Navigator.of(context).push(SlideLeftRoute(enterWidget: Configuration(_code), oldWidget: Detail(_code)));
                                });
                              },
                              child: Text('',
                                style: TextStyle(color: Colors.white, fontSize: taille_champ),),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 360, left: 20),
                  child: title==null?Container():Text(title.length>titre?title.substring(0, titre):title,
                    style: TextStyle(
                        color: couleur_fond_bouton,
                        fontSize: taille_text_bouton,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                amount_collected == null || previsional_amount == null?Container():Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 380),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 15,
                        width: double.parse(amount_collected)>0 && double.parse(previsional_amount.toString())>0 && double.parse(amount_collected.toString())<double.parse(previsional_amount.toString())?double.parse(amount_collected.toString())*_width/double.parse(previsional_amount.toString()):_width,
                        color: double.parse(amount_collected.toString())>0 && double.parse(previsional_amount.toString())>0?orange_F:couleur_titre,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 1, right: 5),
                          child: double.parse(amount_collected.toString())>0 && double.parse(previsional_amount.toString())>0?Text((double.parse(amount_collected.toString())*100/double.parse(previsional_amount.toString())).toString().split('.')[0]+"%",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: taille_text_bouton
                            ),
                            textAlign: TextAlign.right,
                          ):Text('0%',style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: taille_text_bouton
                          ),),
                        ),
                      ),
                      Container(
                        color: couleur_titre,
                        height: 15,
                        width: double.parse(amount_collected.toString())>0 && double.parse(previsional_amount.toString())>0 && double.parse(amount_collected.toString())<double.parse(previsional_amount.toString())?_width - double.parse(amount_collected.toString())*_width/double.parse(previsional_amount.toString()):0,
                      )
                    ],
                  ),
                ),

                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: EdgeInsets.only(top: 400, left: 20, ),
                        child: Column(
                          children: <Widget>[
                            Text(getMillis(amount_collected.toString()).toString()+' $currency',
                              style: TextStyle(
                                  color: couleur_libelle_champ,
                                  fontSize: taille_libelle_champ,
                                  fontWeight: FontWeight.bold
                              ),),
                            Text(double.parse(amount_collected.toString())>1?'Collectés':'Collecté',
                              style: TextStyle(
                                  color: couleur_libelle_champ,
                                  fontSize: taille_libelle_champ-xval,
                                  fontWeight: FontWeight.normal
                              ),),

                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(top: div1),
                        child: Container(color: couleur_decription_page, height: 40,
                          margin: EdgeInsets.only(left: margeleft+1, right: margeright+1),),
                      ),
                    ),

                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: EdgeInsets.only(top: 400),
                        child: Column(
                          children: <Widget>[
                            Text(particip!=null?particip:'0',
                              style: TextStyle(
                                  color: couleur_libelle_champ,
                                  fontSize: taille_libelle_champ,
                                  fontWeight: FontWeight.bold
                              ),),
                            Text(double.parse(particip)>1?'Contributeurs':'Contributeur',
                              style: TextStyle(
                                  color: couleur_libelle_champ,
                                  fontSize: taille_libelle_champ-xval,
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
                        child: Container(color: couleur_decription_page, height: 40,
                          margin: EdgeInsets.only(left: margeleft+1, right: margeright+1),),
                      ),
                    ),

                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: EdgeInsets.only(top: 400, left: 20, ),
                        child: Column(
                          children: <Widget>[
                            Text(getMillis(remaining_amount.toString())+' $currency',
                              style: TextStyle(
                                  color: couleur_libelle_champ,
                                  fontSize: taille_libelle_champ,
                                  fontWeight: FontWeight.bold
                              ),),
                            Text(double.parse(remaining_amount.toString())>1?'Restants':'Restant',
                              style: TextStyle(
                                  color: couleur_libelle_champ,
                                  fontSize: taille_libelle_champ-xval,
                                  fontWeight: FontWeight.normal
                              ),),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 460),
                  child: Divider(
                    height: 5,
                  ),
                ),

                description.length>=tai? Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 5.0, top: topo-5),
                      child: Text(description.toString().length>=tai? description.toString().substring(0, tai)+'...':description.toString(),
                        style: TextStyle(
                            color: couleur_bordure,
                            fontSize: taille_description_page,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.0, right: 5.0, top: topo-5),
                      child: InkWell(
                        onTap: (){
                          this.ackAlert(context, description.toString());
                        },
                        child: new Container(
                          height: 25,
                          width: _larg,
                          decoration: new BoxDecoration(
                            color: couleur_fond_bouton,
                            border: new Border.all(
                              color: Colors.transparent,
                              width: 0.0,
                            ),
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          child: Center(child: new Text("Plus", style: new TextStyle(fontSize: taille_text_bouton-1, color: Colors.white),)),
                        ),
                      ),
                    )
                  ],
                ):Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: topo),
                  child: Text(description.toString(),
                    style: TextStyle(
                      color: couleur_decription_page,
                      fontSize: taille_champ,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 510),
                  child: Divider(
                    height: 5,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 528, left: 20, right: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 6,
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              isLoding = false;
                              choice = 1;
                              this._ackAlert(context);
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: Container(
                              height: 75,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                  ),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: couleur_champ,
                                  )
                              ),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Icon(
                                      Icons.email,
                                      color: orange_F,
                                      size: 30,
                                    ),
                                  ),
                                  Text('Inviter des amis',
                                    style: TextStyle(
                                        color: couleur_bordure,
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.bold
                                    ),)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              choice = 2;
                              Share.share("$share_WebUrl$kittyId");
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Container(
                              height: 75,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                  ),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: couleur_champ,
                                  )
                              ),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Icon(
                                      Icons.mobile_screen_share,
                                      color: orange_F,
                                      size: 30,
                                    ),
                                  ),
                                  Text('Partager ma cagnotte',
                                    style: TextStyle(
                                        color: couleur_bordure,
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.bold
                                    ),)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 618),
                  child: Divider(
                    height: 5,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 617.5),
                  child: Container(
                    color: couleur_champ,
                    height: 175,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top:10, left: 20, right: 20),
                          child: InkWell(
                            onTap: (){
                              print(_code);
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Encaisser1('$_code')));
                              //Navigator.of(context).push(SlideLeftRoute(enterWidget: Encaisser1(_code), oldWidget: Detail(_code)));
                            },
                            child: Container(
                              height: hauteur_bouton,
                              width: MediaQuery.of(context).size.width - 40,
                              decoration: new BoxDecoration(
                                color: Colors.green,
                                border: new Border.all(
                                  color: Colors.transparent,
                                  width: 0.0,
                                ),
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              child: new Center(child: new Text('Encaisser ma cagnotte', style: new TextStyle(color: couleur_text_bouton),),),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top:10, left: 20, right: 20),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Offrir1('$_code')));
                              //Navigator.of(context).push(SlideLeftRoute(enterWidget: Offrir1(_code), oldWidget: Detail(_code)));
                            },
                            child: Container(
                              height: hauteur_bouton,
                              width: MediaQuery.of(context).size.width - 40,
                              decoration: new BoxDecoration(
                                color: couleur_fond_bouton,
                                border: new Border.all(
                                  color: Colors.transparent,
                                  width: 0.0,
                                ),
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              child: new Center(child: new Text('Offrir ma cagnotte', style: new TextStyle(color: couleur_text_bouton),),),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 744),
                  child: Divider(
                    height: 5,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 754),
                  child: Container(
                    height: 30,
                    color: couleur_champ,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Container(
                                height: 30,
                                width: 30,
                                child: new Image.asset('communityimages/group.png')),
                          ),
                        ),

                        Expanded(
                          flex: 10,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text('Commentaires',
                              style: TextStyle(
                                  color: couleur_libelle_champ,
                                  fontSize: taille_description_page,
                                  fontWeight: FontWeight.bold
                              ),),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 790),
                  child: Divider(
                    height: 5,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 800),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 10,
                        child: Text(particip!=null? int.parse(particip)>1?'$particip commentaires':'$particip commentaire': '0 commentaire',
                          style: TextStyle(
                              color: couleur_description_champ,
                              fontSize: taille_champ
                          ),),
                      ),
                      Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Commentaires('$_code')));
                              //Navigator.of(context).push(SlideLeftRoute(enterWidget: Commentaires(_code), oldWidget: Detail(_code)));
                            },
                            child: Icon(Icons.chevron_right,
                              color: couleur_description_champ,
                              size: 30,),
                          )
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 835),
                  child: Container(
                    height: 40,
                    color: couleur_champ,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Container(
                                height: 30,
                                width: 30,
                                child: new Image.asset('communityimages/archive.png')),
                          ),
                        ),

                        Expanded(
                          flex: 10,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text('Participations',
                              style: TextStyle(
                                  color: couleur_libelle_champ,
                                  fontSize: taille_description_page,
                                  fontWeight: FontWeight.bold
                              ),),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 872),
                  child: Divider(
                    height: 5,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 880),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 10,
                        child: Text(particip!=null? int.parse(particip)>1?'$particip participants':'$particip participant'
                            :'0 participant',
                          style: TextStyle(
                              color: couleur_description_champ,
                              fontSize: taille_champ
                          ),),
                      ),
                      Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Participants('$_code')));
                            },
                            child: Icon(Icons.chevron_right,
                              color: couleur_description_champ,
                              size: 30,),
                          )
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 915),
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    color: couleur_champ,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top:970, left: 20, right: 20, bottom: 20),
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        if((DateTime.parse(endDate).difference(DateTime.parse(startDate))).inDays>=0){
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Paiement1(_code)));
                        }else
                          showInSnackBar("Vous ne pouvez plus contribuer à cette cagnotte", _scaffoldKey, 5);
                      });
                    },
                    child: Container(
                      height: hauteur_bouton,
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: new BoxDecoration(
                        color: couleur_fond_bouton,
                        border: new Border.all(
                          color: Colors.transparent,
                          width: 0.0,
                        ),
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      child: new Center(child: new Text('Participer à ma cagnotte', style: new TextStyle(
                          color: couleur_text_bouton,),),),
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


  read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString(TOKEN);
    });
  }

  Future<void> _ackAlert(BuildContext context) {
    String address, partLink="$share_WebUrl$kittyId";
    int kittyID = int.parse(kittyId);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: _formKey2,
          child: AlertDialog(
            title: Text('Email(s) des amis séparées par des virgules.',
              style: TextStyle(
                  fontSize: taille_libelle_champ,
                  color: couleur_libelle_etape,
              ),
              textAlign: TextAlign.justify,),
            content: Container(
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
              height: 200,
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: TextStyle(
                      color: couleur_libelle_champ,
                      fontSize: taille_champ,
                  ),
                  validator: (String value){
                    if(value.isEmpty){

                      return null;
                    }else{
                      address = value;
                      return null;
                    }
                  },
                  decoration: InputDecoration.collapsed(
                    hintText: 'Emails ici',
                    hintStyle: TextStyle(
                        color: couleur_libelle_champ,
                        fontSize: taille_champ,
                    ),
                    //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              isLoding==false?FlatButton(
                child: Text('Valider'),
                onPressed: () {
                  if(_formKey2.currentState.validate()){
                    if(address.isEmpty || address==null){
                    }else{
                      if(address.contains(' '))
                        address = address.replaceAll(' ', "");
                      var invite = new Invite(
                          address: address,
                          kittyID: kittyID,
                          partLink: partLink
                      );
                      print(json.encode(invite));
                      isLoding = true;
                      cretaInvite(json.encode(invite));
                    }
                    setState(() {
                      choice = -1;
                    });
                    Navigator.of(context).pop();
                  }
                },
              ):CupertinoActivityIndicator(),

              FlatButton(
                child: Text('Annuler'),
                onPressed: () {
                  setState(() {
                    choice = -1;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String> cretaInvite(var body) async {
    String url = "$cagnotte_url/invitation/send";
    print("Endpoint $url");
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse("$url"));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json');
    request.headers.set('Authorization', 'Bearer $_token');
    request.add(utf8.encode(body));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print("statusCode ${response.statusCode}");
    print("body $reply");
    if (response.statusCode < 200 || json == null) {
      setState(() {
        isLoding = false;
      });
      throw new Exception("Error while fetching data");
    }else if(response.statusCode == 200){
      setState(() {
        isLoding = false;
      });
      showInSnackBar("Invitation(s) envoyée(s) avec succès", _scaffoldKey, 5);
    }else if(response.statusCode == 401){
      setState(() {
        isLoding = false;
      });
    }else print(response.statusCode);
    return null;
  }


  Future<void> ackAlert(BuildContext context, String text) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(text,
            textAlign: TextAlign.justify,),
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
}