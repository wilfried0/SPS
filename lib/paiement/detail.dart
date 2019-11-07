import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:page_transition/page_transition.dart';
import 'package:services/composants/components.dart';
import 'package:services/composants/services.dart';
import 'package:services/paiement/historique.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';


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
  TabController _tabController;
  PageController pageController;
  int currentPage = 0, choix;
  String _token, solde, idUser, userImage;
  DateTime date;
  bool isLoding = false, loadImage = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int recenteLenght = 3, archiveLenght = 3, populaireLenght =3, nb;
  int flex4, flex6, taille, enlev, rest, enlev1, enl;
  double haut, _taill,topi, bottomsolde,sold,topo22,top33, top34, top1, top, top2, top3,top4, topo1, topo2, hauteurcouverture, nomright, nomtop, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext;
  var _liste = [];

  @override
  void initState(){
    date = new DateTime.now();
    super.initState();
    this.getDate();
    _tabController = new TabController(length: 1, vsync: this);
  }

  getDate(){
    for(int i=0;i<=5;i++){
      _liste.add("TR1OKO71O19");
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


  @override
  void dispose() {
    _tabController.dispose();
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

    return new Scaffold(
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
                  padding: const EdgeInsets.only(top:40, left: 50, right: 50),
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
                    child: CarouselSlider(
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
                    ),
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
                              Text('Transfert d\'argent',
                                style: TextStyle(
                                    color: couleur_titre,
                                    fontSize: taille_champ,
                                    fontWeight: FontWeight.bold
                                ),),
                              Row(
                                children: <Widget>[
                                  Text('10.000 XAF',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: taille_champ,
                                        fontWeight: FontWeight.bold
                                    ),),
                                  GestureDetector(
                                    onTap: (){

                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/2),
                                      child: Icon(Icons.cached, color: orange_F,size: 30,),
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Container(
                                  height: 2,
                                  width: MediaQuery.of(context).size.width-80,
                                  decoration: BoxDecoration(
                                    color: couleur_appbar,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Row(
                                  children: <Widget>[
                                    Text('Ref: TR1OKO71O19',
                                      style: TextStyle(
                                          color: couleur_champ,
                                          fontSize: _taill,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    Padding(
                                      padding: EdgeInsets.only(left: (MediaQuery.of(context).size.width-80)/2-10),
                                      child: Text('10 Juillet 2019',
                                        style: TextStyle(
                                            color: couleur_champ,
                                            fontSize: _taill,
                                            fontWeight: FontWeight.bold
                                        ),),
                                    )
                                  ],
                                ),
                              )
                            ],
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
                    fontSize: taille_champ
                    ),),
                  ),
                  Expanded(
                    flex: 9,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text("France ", style: TextStyle(
                            color: couleur_fond_bouton,
                            fontSize: taille_champ
                          ),),
                          Text("vers ", style: TextStyle(
                              fontSize: taille_champ
                          ),),
                          Text("Cameroun ", style: TextStyle(
                              color: couleur_fond_bouton,
                              fontSize: taille_champ
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
                          fontSize: taille_champ
                      ),),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text("MTN Mobile Money", style: TextStyle(
                            color: couleur_fond_bouton,
                            fontSize: taille_champ
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
                          fontSize: taille_champ
                      ),),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text("Wilfried ASSAM", style: TextStyle(
                            color: couleur_fond_bouton,
                            fontSize: taille_champ
                        ),),
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
                          fontSize: taille_champ
                      ),),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text("10.000,0 XAF", style: TextStyle(
                            color: couleur_fond_bouton,
                            fontSize: taille_champ
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
                          fontSize: taille_champ
                      ),),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text("0,0 XAF", style: TextStyle(
                            color: couleur_fond_bouton,
                            fontSize: taille_champ
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
                          fontSize: taille_champ
                      ),),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text("10.000,0 XAF", style: TextStyle(
                            color: couleur_fond_bouton,
                            fontSize: taille_champ
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
                          fontSize: taille_champ,
                      ),),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text("Aprouvé", style: TextStyle(
                            color: Colors.green,
                            fontSize: taille_champ,
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
    );
  }
  Widget getMoyen(String index){
    return Padding(
      padding: EdgeInsets.only(top: 0),
      child: Text("$index", style: TextStyle(
          color: orange_F,
          fontSize: taille_titre,
          fontWeight: FontWeight.bold
      ),),
    );
  }
}