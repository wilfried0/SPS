import 'dart:convert';
import 'dart:io';
import 'package:services/community/lib/getDrawerContent.dart';
import 'package:services/community/lib/tontines/participermembretontine.dart';
import 'package:services/community/lib/tontines/participertontine.dart';
import 'package:services/composants/components.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../cagnotte.dart';
import 'package:flutter/material.dart';
import '../utils/components.dart';
import 'package:http/http.dart' as http;
import '../utils/services.dart';
import 'dart:async';

import 'detailtontine.dart';


class Tontine extends StatefulWidget {
  Tontine(this._codetontine);
  String _codetontine;
  @override
  _TontineState createState() => new _TontineState(_codetontine);
}

class _TontineState extends State<Tontine> with SingleTickerProviderStateMixin {
  _TontineState(this._codetontine);
  String _codetontine, _urlt2, _urlt3, _urlt1, _urlt, _urlt0, _urlt4, _password;
  final logouttontine = '$base_url/user/Auth/signout';
  Future<Login> post;
  TabController _tabController;
  PageController pageController;
  int currentPage = 1, nb1, nb2, nb3, nb, id, roundId;
  String _token = null, titre, avatar, startDate, creationDate, name, _username;
  DateTime date;
  bool isLoding = true, closed = false;
  int recenteLenght = 3, archiveLenght = 3, populaireLenght =3, xval, choix=2;
  int flex4, flex6, taille, enlev, rest, enlev1, idUser, grand;
  double fromHeight,_width,filtre,rating,star, hauteurcouverture, nomright, nomtop, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext, _larg;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  String currency, nom, owner, description, montant, periode, retard, nextCash;
  var _tontines= [], tontines = [];
  List<String> listParticipants = new List<String>();
  List<String> listDemandes = new List<String>();
  List listtontine, listdemande;


  @override
  void initState(){
    date = new DateTime.now();
    _urlt0 = '$tontine_url/tontines/find/user';
    _urlt1 = '$tontine_url/tontines/find?page=1&size=2';
    _urlt2 = '$base_url/kitty/endDateBefore/true';//kitty/visibility/true/Asc';
    _urlt3 = '$base_url/kitty/populate';
    //_urlt = _urlt1;
    _urlt4 = "$base_url/trans/allTrans";

    if(_codetontine == 'tontine'){
      _urlt = _urlt0;
    }else{
      _urlt = _urlt1;
    }
    this.lire();
    rating = 0.0;
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
    pageController = PageController(
        initialPage: currentPage,
        keepPage: false,
        viewportFraction: 0.8
    );
  }

  void checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {

    } else if (connectivityResult == ConnectivityResult.wifi) {

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
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.getUrl(Uri.parse("$_urlt1"));
    request.headers.set('Accept', 'application/json');
    request.headers.set('Authorization', 'Bearer $_token');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    if(response.statusCode == 200 || response.statusCode == 403){
      if(closed == false && _codetontine != "cagnotte"){
        _tontines = json.decode(reply);
        print(_tontines);
      } else{
        _tontines = [];
        var list = json.decode(reply);
        for(int i = 0; i<list.length; i++){
          if(_codetontine == "tontine"){
            if(list[i]["kitty"]['username'] == _username){
              setState(() {
                _tontines.add(list[i]);
              });
            }
          }else{
            if((DateTime.parse(list[i]["kitty"]["endDate"]).difference(DateTime.parse(list[i]["kitty"]["startDate"]))).inDays<0){
              setState(() {
                _tontines.add(list[i]);
              });
            }
          }
        }
        print("liste des cagnottes "+_tontines.toString());
      }
      setState(() {
        isLoding = false;
      });
      //responseJson['isExist']
    }else if(response.statusCode == 401){
      setState(() {
        isLoding = false;
      });
      AlertCon(context);
    }else{
      print(response.statusCode);
      print(reply);
      setState(() {
        isLoding = false;
      });
      showInSnackBar("Service indisponible!", _scaffoldKey, 5);
    }
  }

  // ignore: missing_return
  Future<String> getListTontine() async {
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.getUrl(Uri.parse("$_urlt"));
    print("Mon $_urlt");
    print("Token: $_token");
    request.headers.set('Accept', 'application/json');
    if(_codetontine == "tontine")
      request.headers.set('Authorization', 'Basic $credentials');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print("liste des tontines v"+reply.toString());
   print("mon  statutcode: ${response.statusCode}");
    if(response.statusCode == 200 || response.statusCode == 403){
      _tontines = json.decode(reply)['content'] as List;
      setState(() {
        isLoding = false;
      });
      //responseJson['isExist']
    }else if(response.statusCode == 401){
      setState(() {
        isLoding = false;
      });
      AlertCon(context);
    }else{
      print(response.statusCode);
      print(reply);
      setState(() {
        isLoding = false;
      });
      showInSnackBar("Service indisponible!", _scaffoldKey, 5);
    }
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
    print("hauteur: $_haut");
    double leftcagnotte, rightcagnotte, topcagnotte, bottomcagnotte;
    if(_large<=320){
      _width = MediaQuery.of(context).size.width-124;
      filtre = taille_libelle_etape-1.5;
      fromHeight = 130;
      leftcagnotte = 30;
      rightcagnotte = 30;
      topcagnotte = 10; //espace entre mes tabs et le slider
      bottomcagnotte = 50;
      hauteurcouverture = 200;
      nomright = 0;
      nomtop = 130;
      datetop = 10;
      titretop = 230;
      titreleft = 20;
      amounttop = 210;
      amountleft = 20;
      amountright = 20;
      topcolect = 235;
      topphoto = 155;
      bottomphoto = 0;
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
    }else if(_large==360){
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
    }else if(_large == 375){
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
      grand = 5;
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
    }
    else if(_large>360){
      _width = MediaQuery.of(context).size.width-143;
      filtre = taille_libelle_etape;
      fromHeight = 200;
      leftcagnotte = 40;
      rightcagnotte = 40;
      topcagnotte = 40;
      bottomcagnotte = 30;
      hauteurcouverture = 400;
      nomright =  MediaQuery.of(context).size.width-330;
      nomtop = 280;
      datetop = 10;
      titretop = 440;
      titreleft = 20;
      amounttop = 360;
      amountleft = 20;
      amountright = 20;
      topcolect = 385;
      topphoto = 355;
      bottomphoto = 0;
      desctop = 510;
      descbottom = 0;
      flex4 = 4;
      flex6 = 6;
      bottomtext = 50;
      toptext = 520;
      taille = 437;
      enlev = 104;
      rest = 40;
      _larg = 40;
      enlev1 = 2;
      xval = 40;
      star = 30;
      grand = 0;
    }
    return new MaterialApp(
      theme: ThemeData(primaryColor: Colors.white, accentColor: Color(0xFF2A2A42), fontFamily: 'Poppins'),
      debugShowCheckedModeBanner: false,
      home: new DefaultTabController(
        length: 3,
        child: new Scaffold(
          key: _scaffoldKey,
          backgroundColor: bleu_F,
          appBar: new PreferredSize(
              preferredSize: Size.fromHeight(fromHeight), //200
              child: new Container(
                child: SafeArea(
                    child: Column(
                      children: <Widget>[
                        new Padding(
                            padding: EdgeInsets.only(top: topcagnotte, bottom: bottomcagnotte, left: leftcagnotte, right: rightcagnotte),
                            child: new Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: (){
                                      this._stock();
                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte(_codetontine)));
                                    },
                                    child: Text('Cagnottes',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: taille_titre+grand-2,
                                        color: choix==1? orange_F:Colors.white,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),

                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text('Tontines',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: taille_titre+grand-2,
                                      color: choix!=1?orange_F:Colors.white,),
                                    textAlign: TextAlign.right,),
                                ),
                              ],
                            )),
                        new TabBar(
                          indicatorColor: Colors.transparent,
                          unselectedLabelColor: Colors.white,
                          labelColor: orange_F,
                          tabs: [
                            new Text("Récentes", style: TextStyle(
                                fontSize: filtre+grand-1,
                                fontWeight: FontWeight.bold,
                                fontFamily: police_titre
                            ),),
                            new Text("Achevées", style: TextStyle(
                                fontSize: filtre+grand-1,
                                fontWeight: FontWeight.bold,
                                fontFamily: police_titre
                            ),),
                            new Text("Populaires", style: TextStyle(
                                fontSize: filtre+grand-1,
                                fontWeight: FontWeight.bold,
                                fontFamily: police_titre
                            ),)
                          ],
                          onTap: (index){
                            setState(() {
                              switch(index){
                                case 0:_tontines = [];_codetontine = ""; closed = false;_urlt = _urlt1;getListTontine();break;
                                case 1:_tontines = [];_codetontine = ""; closed = true;_urlt = _urlt1;getListTontine();break;
                                case 2:_tontines = []; _codetontine = ""; closed = false; _urlt = _urlt1;getListTontine();break;
                              }
                            });
                          },
                        )
                      ],
                    )
                ),
              )
          ),
          drawer: Drawer(
            child: getDrawerContent(),
          ),
          endDrawer: getDrawerContent(),
          body: _tontines.isEmpty?Theme(
            data: Theme.of(context).copyWith(accentColor: orange_F),
            child: isLoding==true?Center(
                child: Column(
                  children: <Widget>[
                    Theme(
                      data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.dark)),
                      child: new CupertinoActivityIndicator(
                        animating: true,
                        radius: 20,
                      ),
                    ),

                    Text('Chargement en cours ...', style: TextStyle(
                        fontSize: taille_champ+3,
                        color: Colors.white
                    ),)
                  ],
                )
            ):
            Center(
                child: Text('Catégorie vide!', style: TextStyle(
                    fontSize: taille_champ,
                    color: Colors.white
                ),)
            ),
          ):new TabBarView(
            controller: _tabController,
            children: <Widget>[
              new PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                controller: pageController,
                itemCount: _tontines==null?0:_tontines.length,
                itemBuilder: (context, index) => _buildCarousel(context, index),
              ),
              new PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                controller: pageController,
                itemCount: _tontines==null?0:_tontines.length,
                itemBuilder: (context, index) => _buildCarousel(context, index),
              ),
              new PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                controller: pageController,
                itemCount: _tontines==null?0:_tontines.length,
                itemBuilder: (context, index) => _buildCarousel(context, index),
              )
            ],
          ),
          bottomNavigationBar: bottomNavigation(context, _scaffoldKey,  choix, _token),
        ),
      ),
    );
  }

  _buildCarousel(BuildContext context, int index) {
    return _tontines[index]["amount"] == null?Container():
      InkWell(
        onTap: () {//nom, owner, description, montant, periode, retard, nextCash, listtontine
          print("ma taille: ${MediaQuery.of(context).size.width}/${MediaQuery.of(context).size.height}");
          nom = _tontines[index]['name'];
          id = _tontines[index]['id'];
          owner = _tontines[index]['ownerUsername'];
          description = _tontines[index]['description'];
          montant = _tontines[index]['amount'].toString();
          periode = _tontines[index]['paticipationDuration'].toString();
          retard = _tontines[index]['delayTimes'].toString();
          nextCash = _tontines[index]['nextEncashOrder'].toString();
          startDate = _tontines[index]['startDate'];
          creationDate = _tontines[index]['creationDate'];
          listtontine = _tontines[index]['participants'];
          listdemande = _tontines[index]['memberships'];
          avatar = _tontines[index]['avatar'];
          currency = _tontines[index]['currency'];
          //roundId = _tontines[index]['rounds']['id'];
           print("Liste des participants: $listtontine");
           print("Liste des demandes: $listdemande");
           print(listtontine);
           print(creationDate);
           this.save();
          _codetontine = '$index^${_tontines[index]["name"]}^${_tontines[index]["id"]}^${_tontines[index]["ownerUsername"]}^${_tontines[index]["startDate"]}^${_tontines[index]['description']}^${_tontines[index]['amount']}^${_tontines[index]['paticipationDuration'].toString()}^${_tontines[index]["description"]}^${_tontines[index]['nextEncashOrder'].toString()}^${_tontines[index]['creationDate']}^${_tontines[index]["participants"]}^${_tontines[index]["avatar"]}^${_tontines[index]["remaining_amount"]}^${_tontines[index]["memberships"]}';
          getRoute();
          /*if(listtontinevrai()==true || _tontines[index]['ownerUsername'] == _username){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Detailtontinev(_codetontine)));
          }else{
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Participertontine(_codetontine)));
          }*/
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0)
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  height: hauteurcouverture,
                  width: MediaQuery.of(context).size.width,
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
                      image:_tontines[index]["avatar"]!=null && _tontines[index]["avatar"].toString().startsWith("$cagnotte_url")?
                      DecorationImage(
                          image: NetworkImage(_tontines[index]["avatar"]),
                          fit: BoxFit.cover
                      ):
                      DecorationImage(
                          image: AssetImage("images/cover.jpg"),
                          fit: BoxFit.cover
                      )
                  ),),
                // The card widget with top padding,
                // incase if you wanted bottom padding to work,
                // set the `alignment` of container to Alignment.bottomCenter
                new Container(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[


                      Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: nomtop-10, right:nomright),
                            child: Text('Debut de cotisations \n ${_tontines[index]['startDate'].toString().split("T")[0]}',//_cagnottes[index]["kitty"]["firstnameBenef"],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: taille_champ
                              ),
                            ),
                          ),
                          /*Padding(
                            padding: EdgeInsets.only(top: datetop, left: nomright),
                            child: Text((DateTime.parse(_tontines[index]["startDate"]).difference(DateTime.parse(_tontines[index]["startDate"]))).inDays>=0?
                            (DateTime.parse(_tontines[index]["startDate"]).difference(DateTime.parse(_tontines[index]["startDate"]))).inDays.toString() +' jours restants':
                            "Expirée",
                              style: TextStyle(
                                  color: couleur_titre,
                                  fontWeight: FontWeight.normal,
                                  fontSize: taille_description_champ
                              ),
                            ),
                          )*/
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: titretop, left: titreleft),
                  child: Text(_tontines[index]["name"].toString().length<=xval?_tontines[index]["name"].toString():_tontines[index]["name"].toString().substring(0, xval)+'...',
                    style: TextStyle(
                        color: couleur_fond_bouton,
                        fontSize: taille_text_bouton,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: amountleft, right: amountright, top: amounttop),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 15,
                        width: _tontines[index]["amount"]>0 && _tontines[index]["amount"]>0 && _tontines[index]["amount"]<_tontines[index]["amount"]?double.parse(_tontines[index]["amount_collected"].toString())*_width/double.parse(_tontines[index]["amount"].toString()):_width,
                        color: _tontines[index]["amount"]>0 && _tontines[index]["amount"]>0?orange_F:couleur_titre,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 1, right: 5),
                          child: Text('0%',style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: taille_text_bouton
                          ),),/*_tontines[index]["amount"]>0 && _tontines[index]["amount"]>0?Text((double.parse(_tontines[index]["amount"].toString())*100/double.parse(_tontines[index]["amount"].toString())).toString().split('.')[0]+"%",
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
                          ),),*/
                        ),
                      ),
                      Container(
                        color: couleur_titre,
                        height: 15,
                        width: _tontines[index]["amount"]>0 && _tontines[index]["amount"]>0 && _tontines[index]["amount"]<_tontines[index]["amount"]?_width - double.parse(_tontines[index]["amount"].toString())*_width/double.parse(_tontines[index]["amount"].toString()):0,//(_width - (double.parse(_cagnottes[index]["amount"].toString())*100/double.parse(_cagnottes[index]["previsional_amount"].toString()))*100/_width)>0?_width - (double.parse(_cagnottes[index]["amount"].toString())*100/double.parse(_cagnottes[index]["previsional_amount"].toString()))*100/_width:0,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 10.0, top: topcolect + 18),
                  child: Text('${getMillis(_tontines[index]["amount"].toString())} ${_tontines[index]['currency']} / ${_tontines[index]["paticipationDuration"]} jours',
                    style: TextStyle(
                        color: couleur_titre,
                        fontSize: taille_champ,
                        fontWeight: FontWeight.bold,
                        fontFamily: police_titre
                    ),),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 0),
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, top: toptext+25),
                    child: _tontines[index]["description"].toString().length<taille?Text(_tontines[index]["description"].toString(),
                      style: TextStyle(
                          color: couleur_bordure,
                          fontSize: taille_libelle_champ,
                          fontFamily: police_titre
                      ),
                      textAlign: TextAlign.justify,
                    ):Column(
                      children: <Widget>[
                        Text(_tontines[index]["description"].toString().substring(0, taille-enlev),
                          style: TextStyle(
                              color: couleur_bordure,
                              fontSize: taille_libelle_champ,
                              fontFamily: police_titre
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        Row(
                          children: <Widget>[
                            Text('${_tontines[index]["description"].toString().substring(taille-enlev, taille-enlev+rest)}...',style:
                            TextStyle(
                                color: couleur_bordure,
                                fontSize: taille_libelle_champ,
                                fontFamily: police_titre
                            ),),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _ackAlert(context, _tontines[index]["description"].toString());
                                  //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte4(_code), oldWidget: Cagnotte3(_code)));
                                });
                              },
                              child: new Container(
                                height: 15,
                                width: _larg,
                                decoration: new BoxDecoration(
                                  color: couleur_fond_bouton,
                                  border: new Border.all(
                                    color: Colors.transparent,
                                    width: 0.0,
                                  ),
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
                                child: Center(child: new Text("Plus", style: new TextStyle(fontSize: taille_text_bouton-1, color: Colors.blue, fontFamily: police_bouton),)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
  lire() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString(TOKEN);
      _username = prefs.getString("username");
      _password = prefs.getString("password");
      this.getListTontine();
    });
  }

  bool listtontinevrai() {
    bool result = false;
    for(int index=0; index<listtontine.length; index++){
      listParticipants.add(listtontine[index]['username'].toString());
      if(listtontine[index]['username']==_username){
        result = true;
      }
    }
    print("Ma liste juste des numéros des participants: ${listParticipants.toString()}");
    return result;
  }


  getRoute(){
    if(_token == null || listtontinevrai() == false){
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Participertontine(_codetontine)));
    }else if(owner == _username){
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DetailTontine(_codetontine)));
    }else if(listtontinevrai() == true){
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ParticiperMembretontine(_codetontine)));
    }
  }

  void _stock() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(CHOIX, "1");
  }
//nom, owner, description, montant, periode, retard, nextCash, listtontine
  void save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(CHOIX, choix.toString());
    prefs.setString(NOM_TONTINE_X, nom);
    prefs.setString(ID_TONTINE_X, id.toString());
    prefs.setString(OWNER_USER_TONTINE, owner);
    prefs.setString(DESCRIPTION_TONTINE_x, description);
    prefs.setString(MONTANT_TONTINE_x, montant);
    prefs.setString(PARTICIP_DURATION_TONTINE_X, periode);
    prefs.setString(DELAYTIMES_TONTINE, retard);
    prefs.setString(NEXT_CASH_ORDER_TONTINE, nextCash);
    prefs.setString(STARTDATE_TONTINE_X, startDate);
    prefs.setString(AVATAR_X, avatar);
    prefs.setString(CURRENCY, currency);
    prefs.setStringList(PARTICIPANTS_X, listParticipants);
    prefs.setStringList(DEMANDES_X, listDemandes);
  }
}

  /*_read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final key = 'monToken';
      _token = prefs.getString(key);
    });
  }

  lire() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      this.getListTontine();
    });
  }

  void _save(String _token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'monToken';
    final value = _token==null?"0":'$_token';
    prefs.setString(key, value);
    print('saved $value');
  }
}*/