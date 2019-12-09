import 'dart:convert';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:services/auth/profile.dart';
import 'package:services/composants/components.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';
import 'package:services/composants/services.dart';
import 'package:services/paiement/detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:fl_chart/fl_chart.dart';


// ignore: must_be_immutable
class Historique extends StatefulWidget {
  Historique(this._code);
  String _code;
  final List<Color> availableColors = [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];
  @override
  _HistoriqueState createState() => new _HistoriqueState(_code);
}

class _HistoriqueState extends State<Historique> with SingleTickerProviderStateMixin {
  _HistoriqueState(this._code);
  String _code, _url2, _url3, _url1, _url, _url4;
  Future<Login> post;
  TabController _tabController;
  PageController pageController;
  int currentPage = 1, nb1, nb2, nb3, nb;
  String _token;
  DateTime date;
  bool isLoding = true;
  int recenteLenght = 3, archiveLenght = 3, populaireLenght =3, xval, choix=1, indik=1, enlvb, enlevt, ind=2017;
  int flex4, flex6, taille, enlev, rest, enlev1, idUser, grand;
  double _width,r,l,_height, filtre,rating,star, hauteurcouverture, nomright, nomtop, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext, _larg;
  var _cagnottes= [], cagnottes = [], _trans = [], _liste = [];
  final Color barBackgroundColor = const Color(0xff72d8bf);
  final Duration animDuration = Duration(milliseconds: 250);

  int touchedIndex;

  bool isPlaying = false;

  @override
  void initState(){
    date = new DateTime.now();
    _url1 = '$base_url/kitty/visibility/true/Desc';
    _url2 = '$base_url/kitty/endDateBefore/true';//kitty/visibility/true/Asc';
    _url3 = '$base_url/kitty/populate';
    _url = _url1;
    _url4 = "$base_url/trans/allTrans";
    rating = 0.0;
    super.initState();
    this.getDate();
    _tabController = new TabController(length: 3, vsync: this);
    this._read();
    //checkConnection();
    nb1 = nb;
    this.lire();
    //getTrans();
    Timer(Duration(seconds: 15), onDoneLoading);
    pageController = PageController(
        initialPage: currentPage,
        keepPage: false,
        viewportFraction: 0.8
    );
  }

  getDate(){
    String text;
    var date  = new DateTime.now().year;
    int _tail=date-2017, inter;
    for(int i=0;i<=_tail;i++){
      inter = 2017+i;
      text = inter.toString();
      _liste.add(text);
    }
  }

  onDoneLoading() async {
    setState(() {
      isLoding = false;
    });
  }

  void checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      this.getJsonData();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      this.getJsonData();
    } else {
      ackAlert(context);
    }
  }

  Future<void> ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Oops!'),
          content: const Text('Vérifier votre connexion internet.'),
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

  Future<String> getTrans() async {
    var _header = {
      "accept": "application/json",
      "content-type" : "application/json",
    };
    var response = await http.get(Uri.encodeFull(_url4), headers: _header,);
    print('statuscode ${response.statusCode}');
    print('url $_url4');
    if (response.statusCode == 200) {
      setState(() {
        var convertDataToJson = json.decode(utf8.decode(response.bodyBytes));
        _trans = convertDataToJson['content'];
        print("liste: ${_trans.toString()}");
      });
    }else print(response.body);
    return "success";
  }

  double getStars(int idKitty, var liste){
    int star = 0, nbre=0;
    for(int i=0;i<liste.length;i++){
      if(idKitty == liste[i]['kitty']['id_kitty'] && liste[i]['trans']['levelKitty']!=null){
        nbre++;
        star = star + liste[i]['trans']['levelKitty'];
      }else{}
    }
    rating = star/nbre;
    print("star: $rating");
    return rating.toString()!="NaN"?rating:0;
  }


  Future<String> getJsonData() async {
    var response = await http.get(Uri.encodeFull(_url), headers: {"Accept": "application/json"},);
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        if(_code=='true'){
          cagnottes = json.decode(utf8.decode(response.bodyBytes));
          var gnottes = [];
          for(int i=0;i<cagnottes.length;i++){
            if(cagnottes[i]["kitty"]['user']['id_user']!=idUser){
              cagnottes.remove(cagnottes[i]);
            }else{
              gnottes.add(cagnottes[i]);
            }
          }
          this._cagnottes = gnottes;
          nb = this._cagnottes.length;
        }else{
          _cagnottes = json.decode(utf8.decode(response.bodyBytes));
          nb = this._cagnottes.length;
          print(_cagnottes.toString());
        }
      });
    }else if(response.statusCode == 403 && _url == _url3){
      setState(() {
        if(_code=='true'){
          cagnottes = json.decode(utf8.decode(response.bodyBytes));
          var gnottes = [];
          for(int i=0;i<cagnottes.length;i++){
            if(cagnottes[i]["kitty"]['user']['id_user']!=idUser){
              cagnottes.remove(cagnottes[i]);
            }else{
              gnottes.add(cagnottes[i]);
            }
          }
          this._cagnottes = gnottes;
          nb = this._cagnottes.length;
        }else{
          _cagnottes = json.decode(utf8.decode(response.bodyBytes));
          nb = this._cagnottes.length;
          print(_cagnottes.toString());
        }
      });
    }
    return "success";
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _ackAlert(BuildContext context, String text) {
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

  @override
  Widget build(BuildContext context) {
    final _large = MediaQuery.of(context).size.width;
    final _haut = MediaQuery.of(context).size.height;
    double fromHeight, leftcagnotte, rightcagnotte, topcagnotte, bottomcagnotte;
    if(_large<=320){
      _width = MediaQuery.of(context).size.width-124;
      _height = MediaQuery.of(context).size.height;
      filtre = taille_libelle_etape-1.5;
      if(_height <= 568)
        fromHeight = 204.333333333333333333334;
      else
        fromHeight = 215;
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
      topphoto = 0;
      bottomphoto = 80;
      desctop = 320; //pour l'étoile et Agriculture
      descbottom = 0;
      flex4 = 8;
      flex6 = 7;
      bottomtext = 35;
      toptext = 260;
      taille = 150;
      enlev = 0;
      rest = 30;
      _larg = 30;
      enlev1 = 3;
      xval = 34;
      star = 30;
      grand = 0;
      enlvb = 0;
      enlevt = 0;
      r = 0.9;l=0.9;
    }else if(_large>320 && _large<=360 && _haut==738){
      _width = MediaQuery.of(context).size.width-132;
      filtre = taille_libelle_etape;
      fromHeight = 185;
      leftcagnotte = 40;
      rightcagnotte = 40;
      topcagnotte = 40;
      bottomcagnotte = 70;
      hauteurcouverture = 203;
      nomright =  MediaQuery.of(context).size.width-330;
      nomtop = 180;
      datetop = 10;
      titretop = 240;
      titreleft = 20;
      amounttop = 260;
      amountleft = 20;
      amountright = 20;
      topcolect = 280;
      topphoto = 0;
      bottomphoto = 90;
      desctop = 410;
      descbottom = 0;
      flex4 = 4;
      flex6 = 6;
      bottomtext = 50;
      toptext = 310;
      taille = 437;
      enlev = 104;
      rest = 40;
      _larg = 40;
      enlev1 = 2;
      xval = 40;
      star = 30;
      grand = 0;
      enlvb = 60;
      enlevt = 20;
      r = 1;l=1;
    }else if(_large>320 && _large<360){
      _width = MediaQuery.of(context).size.width-132;
      filtre = taille_libelle_etape;
      fromHeight = 185;
      leftcagnotte = 40;
      rightcagnotte = 40;
      topcagnotte = 40;
      bottomcagnotte = 70;
      hauteurcouverture = 203;
      nomright =  MediaQuery.of(context).size.width-330;
      nomtop = 180;
      datetop = 10;
      titretop = 240;
      titreleft = 20;
      amounttop = 260;
      amountleft = 20;
      amountright = 20;
      topcolect = 280;
      topphoto = 0;
      bottomphoto = 60;
      desctop = 320;
      descbottom = 0;
      flex4 = 4;
      flex6 = 6;
      bottomtext = 50;
      toptext = 310;
      taille = 437;
      enlev = 104;
      rest = 40;
      _larg = 40;
      enlev1 = 2;
      xval = 40;
      star = 30;
      grand = 0;
      enlvb = 60;
      enlevt = 20;
      r = 1;l=1;
    }else if(_large==360){
      _width = MediaQuery.of(context).size.width-132;
      filtre = taille_libelle_etape;
      fromHeight = 189;
      leftcagnotte = 40;
      rightcagnotte = 40;
      topcagnotte = 40;
      bottomcagnotte = 70;
      hauteurcouverture = 203;
      nomright =  MediaQuery.of(context).size.width-330;
      nomtop = 180;
      datetop = 10;
      titretop = 240;
      titreleft = 20;
      amounttop = 260;
      amountleft = 20;
      amountright = 20;
      topcolect = 280;
      topphoto = 12;
      bottomphoto = 0;
      desctop = 320;
      descbottom = 0;
      flex4 = 4;
      flex6 = 6;
      bottomtext = 50;
      toptext = 310;
      taille = 437;
      enlev = 104;
      rest = 40;
      _larg = 40;
      enlev1 = 2;
      xval = 40;
      star = 30;
      grand = 0;
      enlvb = 60;
      enlevt = 20;
      r = 1;l=1;
    }else if(_large == 375){//    >=Iphone 8 && 6
      _width = MediaQuery.of(context).size.width-143;
      filtre = taille_libelle_etape;
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
      topphoto = 95;
      bottomphoto = 0;
      desctop = 430;
      descbottom = 0;
      flex4 = 4;
      flex6 = 6;
      bottomtext = 50;
      toptext = 420;
      taille = 437;
      enlev = 104;
      rest = 40;
      _larg = 40;
      enlev1 = 2;
      xval = 40;
      star = 30;
      grand = 3;
      enlvb = 57;
      enlevt = 20;
      r = 1;l=1;
    }else if(_large> 411 && _large<412){
      _width = MediaQuery.of(context).size.width-143;
      filtre = taille_libelle_etape;
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
      topphoto = 62;
      bottomphoto = 0;
      desctop = 470;
      descbottom = 0;
      flex4 = 4;
      flex6 = 6;
      bottomtext = 50;
      toptext = 420;
      taille = 437;
      enlev = 104;
      rest = 40;
      _larg = 40;
      enlev1 = 2;
      xval = 40;
      star = 30;
      enlvb = 60;
      enlevt = 20;
      r = 1;l=1;
    }
    else if(_large>360){
      _width = MediaQuery.of(context).size.width-143;
      filtre = taille_libelle_etape;
      fromHeight = 200;
      leftcagnotte = 40;
      rightcagnotte = 40;
      topcagnotte = 40;
      bottomcagnotte = 100;
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
      topphoto = 10;
      bottomphoto = 0;
      desctop = 510;
      descbottom = 0;
      flex4 = 4;
      flex6 = 6;
      bottomtext = 50;
      toptext = 420;
      taille = 437;
      enlev = 104;
      rest = 40;
      _larg = 40;
      enlev1 = 2;
      xval = 40;
      star = 30;
      grand = 0;
      enlvb = 60;
      enlevt = 20;
      r = 1;l=1;
    }
    return new Scaffold(
          appBar: new PreferredSize(
              preferredSize: Size.fromHeight(fromHeight+226), //200
              child: new Container(
                color: bleu_F,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 43, left: 20, right: 20),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                                onTap: (){
                                    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Profile('$_code')));
                                    //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Detail(_code)));
                                },
                                child: Icon(Icons.arrow_back_ios,color: Colors.white,)
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: GestureDetector(
                              onTap: (){
                                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Profile('$_code')));
                                  //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Detail(_code)));
                              },
                              child: Text('Retour',
                                style: TextStyle(color: Colors.white, fontSize: taille_champ),),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Text('Mes transactions',
                              style: TextStyle(color: Colors.white, fontSize: taille_champ),),
                          ),
                        ],
                      ),
                    ),
                    new Padding(
                        padding: EdgeInsets.only(top: topcagnotte-enlevt, bottom: bottomcagnotte-enlvb, left: 20, right: 20),
                        child: Text('Historique de compte',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: taille_titre+grand,
                            color: Colors.white,),
                          textAlign: TextAlign.right,)),

                    Padding(
                      padding: const EdgeInsets.only(top:0, left: 40, right: 40),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            topLeft: Radius.circular(15),
                          ),
                          color: couleur_fond_bouton,
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                flex: 3,
                                child: Icon(Icons.refresh, color: orange_F,)),
                            Expanded(
                              flex: 6,
                              child: CarouselSlider(
                                enlargeCenterPage: true,
                                autoPlay: false,
                                enableInfiniteScroll: true,
                                onPageChanged: (value){
                                  print(value);
                                },
                                height: 35.0,
                                items: _liste.map((i) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      ind = int.parse(i);
                                      print("voilà $ind");
                                      return getMoyen(i);
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                            Expanded(
                                flex: 3,
                                child: Icon(Icons.refresh, color: orange_F,)),
                          ],
                        ),
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 1.5,
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                        color: bleu_F,
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 16, right: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Expanded(
                                    child: BarChart(mainBarData(),
                                      swapAnimationDuration: animDuration,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ),
          body:SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                choix = 0;
                              });
                            },
                            child: Center(
                              child: Text("Récentes",style: TextStyle(
                                  fontSize: filtre+grand,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: police_titre,
                                  color: choix==0?bleu_F:couleur_description_champ
                              ),),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                choix = 1;
                                print(MediaQuery.of(context).size.width);
                                print(MediaQuery.of(context).size.height);
                              });
                            },
                            child: Center(
                              child: Text("Réussies",style: TextStyle(
                                  fontSize: filtre+grand,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: police_titre,
                                  color: choix==1?bleu_F:couleur_description_champ
                              ),),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                choix = 2;
                              });
                            },
                            child: Center(
                              child: Text("Echouées",style: TextStyle(
                                  fontSize: filtre+grand,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: police_titre,
                                  color: choix==2?bleu_F:couleur_description_champ
                              ),),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Detail('$_code')));
                    },
                    child: Card(
                      elevation: .5,
                      color: couleur_appbar,
                      child: Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                flex: 6,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 5,
                                      height: 30.0,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(10),
                                          topRight: Radius.circular(10)
                                        )
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("Transfert d'argent", style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontSize: taille_champ
                                          ),),
                                          Text("Approuvé", style: TextStyle(
                                            color: couleur_description_champ,
                                            fontSize: taille_champ-2
                                          ),),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                            ),

                            Expanded(
                                flex: 6,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text("-10.000,0 XAF", style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: taille_champ
                                      ),),
                                      Text("10 juillet 2019", style: TextStyle(
                                        color: couleur_description_champ,
                                          fontSize: taille_champ-2
                                      ),),
                                    ],
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Detail('$_code')));
                    },
                    child: Card(
                      elevation: .5,
                      color: couleur_appbar,
                      child: Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                flex: 6,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 5,
                                      height: 30.0,
                                      decoration: BoxDecoration(
                                          color: orange_F,
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(10),
                                              topRight: Radius.circular(10)
                                          )
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("Retrait d'argent", style: TextStyle(
                                              color: orange_F,
                                              fontWeight: FontWeight.bold,
                                            fontSize: taille_champ
                                          ),),
                                          Text("En attente de validation", style: TextStyle(
                                              color: couleur_description_champ,
                                              fontSize: taille_champ-2
                                          ),),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                            ),

                            Expanded(
                                flex: 6,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text("-5.200,0 XAF", style: TextStyle(
                                          color: orange_F,
                                          fontWeight: FontWeight.bold,
                                          fontSize: taille_champ
                                      ),),
                                      Text("8 juillet 2019", style: TextStyle(
                                          color: couleur_description_champ,
                                          fontSize: taille_champ-2
                                      ),),
                                    ],
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
  }

  _read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final key = 'monToken';
      _token = prefs.getString(key);
    });
  }

  lire() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final key = 'idUser';
      idUser = prefs.getString(key)==null?-1:int.parse(prefs.getString(key));
    });
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

  BarChartGroupData makeGroupData(
      int x,
      double y, {
        bool isTouched = false,
        Color barColor = Colors.white,
        double width = 20,
        List<int> showTooltips = const [],
      }) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
        y: isTouched ? y + 1 : y,
        color: isTouched ? orange_F: couleur_fond_bouton,
        width: width,
        isRound: false,
        backDrawRodData: BackgroundBarChartRodData(
          show: true,
          y: 10,
          color: bleu_F,
        ),
      ),
    ], showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(12, (i) {
    switch (i) {
      case 0:
        return makeGroupData(0, 5, isTouched: i == touchedIndex);
      case 1:
        return makeGroupData(1, 6.5, isTouched: i == touchedIndex);
      case 2:
        return makeGroupData(2, 5, isTouched: i == touchedIndex);
      case 3:
        return makeGroupData(3, 7.5, isTouched: i == touchedIndex);
      case 4:
        return makeGroupData(4, 9, isTouched: i == touchedIndex);
      case 5:
        return makeGroupData(5, 11.5, isTouched: i == touchedIndex);
      case 6:
        return makeGroupData(6, 8.5, isTouched: i == touchedIndex);
      case 7:
        return makeGroupData(7, 6, isTouched: i == touchedIndex);
      case 8:
        return makeGroupData(8, 6.5, isTouched: i == touchedIndex);
      case 9:
        return makeGroupData(9, 2.5, isTouched: i == touchedIndex);
      case 10:
        return makeGroupData(10, 1.0, isTouched: i == touchedIndex);
      case 11:
        return makeGroupData(11, 3.5, isTouched: i == touchedIndex);
      default:
        return null;
    }
  });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: couleur_fond_bouton,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String weekDay;
                switch (group.x.toInt()) {
                  case 0:
                    weekDay = 'Jan';
                    break;
                  case 1:
                    weekDay = 'Fev';
                    break;
                  case 2:
                    weekDay = 'Mar';
                    break;
                  case 3:
                    weekDay = 'Avr';
                    break;
                  case 4:
                    weekDay = 'Mai';
                    break;
                  case 5:
                    weekDay = 'Jun';
                    break;
                  case 6:
                    weekDay = 'Jul';
                    break;
                  case 7:
                    weekDay = 'Aou';
                    break;
                  case 8:
                    weekDay = 'Sep';
                    break;
                  case 9:
                    weekDay = 'Oct';
                    break;
                  case 10:
                    weekDay = 'Nov';
                    break;
                  case 11:
                    weekDay = 'Dec';
                    break;
                }
                return BarTooltipItem(weekDay + '\n' + (rod.y - 1).toString(),
                    TextStyle(color: orange_F));
              }),
          touchCallback: (barTouchResponse) {
            setState(() {
              if (barTouchResponse.spot != null &&
                  barTouchResponse.touchInput is! FlPanEnd &&
                  barTouchResponse.touchInput is! FlLongPressEnd) {
                touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
              } else {
                touchedIndex = -1;
              }
            });
          }
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
            showTitles: true,
            textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: taille_description_champ),
            margin: 5,
            getTitles: (double value) {
              switch (value.toInt()) {
                case 0:
                  return 'Jan';
                case 1:
                  return 'Fev';
                case 2:
                  return 'Mar';
                case 3:
                  return 'Avr';
                case 4:
                  return 'Mai';
                case 5:
                  return 'Jui';
                case 6:
                  return 'Jul';
                case 7:
                  return 'Aou';
                case 8:
                  return 'Sep';
                case 9:
                  return 'Oct';
                case 10:
                  return 'Nov';
                case 11:
                  return 'Dec';
                default:
                  return '';
              }
            }),
        leftTitles: const SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
        //border: Border(),
      ),
      barGroups: showingGroups(),
    );
  }
}