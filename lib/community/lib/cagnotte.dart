import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:services/auth/profile.dart';
import 'package:services/composants/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'cagnottes/detail.dart';
import 'getDrawerContent.dart';
import 'cagnottes/participer.dart';
import 'package:flutter/material.dart';
import 'utils/components.dart';
import 'utils/services.dart';
import 'dart:async';


class Cagnotte extends StatefulWidget {
  Cagnotte(this._code);
  String _code;
  @override
  _CagnotteState createState() => new _CagnotteState(_code);
}

class _CagnotteState extends State<Cagnotte> with SingleTickerProviderStateMixin {
  _CagnotteState(this._code);
  String _code,_url0, _url2, _url3, _url1, _url, _url4;

  Future<Login> post;
  TabController _tabController;
  PageController pageController;
  int currentPage = 1, nb1, nb2, nb3, nb;
  String _token = null, kittyImage, _username, _user_kitty, titre, user_part, _currency;
  DateTime date;
  bool isLoding = true, closed = false;
  int recenteLenght = 3, archiveLenght = 3, populaireLenght =3, xval, choix=1, kittyId;
  int flex4, flex6, taille, enlev, rest, enlev1, idUser, grand;
  double _width,fromHeight, filtre,rating,star, hauteurcouverture, nomright, nomtop, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext, _larg;
  var _cagnottes= [], cagnottes = [], _trans = [], _closed = [];
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  void initState(){
    date = new DateTime.now();
    _url0 = '$cagnotte_url/kitty/all/desc';
    _url1 = '$cagnotte_url/kitty/visibility/true/Desc';
    _url2 = '$cagnotte_url/kitty/startDateBefore/publique';//kitty/visibility/true/Asc';
    _url3 = '$cagnotte_url/kitty/populate';
    _url = _url0;
    _url4 = "$cagnotte_url/trans/allTrans";
    rating = 0.0;
    this.lire();
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
    //this._read();
    //checkConnection();
    nb1 = nb;
    //getTrans();
    pageController = PageController(
        initialPage: currentPage,
        keepPage: false,
        viewportFraction: 0.8
    );
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
    HttpClientRequest request = await client.getUrl(Uri.parse("$_url"));
    request.headers.set('Accept', 'application/json');
    request.headers.set('Authorization', 'Bearer $_token');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    if(response.statusCode == 200 || response.statusCode == 403){
      if(closed == false && _code != "cagnotte"){
        _cagnottes = json.decode(reply);
        print(_cagnottes);
      } else{
        _cagnottes = [];
        var list = json.decode(reply);
        for(int i = 0; i<list.length; i++){
          if(_code == "cagnotte"){
            if(list[i]["kitty"]['username'] == _username){
              setState(() {
                _cagnottes.add(list[i]);
              });
            }
          }else{
            if((DateTime.parse(list[i]["kitty"]["endDate"]).difference(DateTime.parse(list[i]["kitty"]["startDate"]))).inDays<0){
              setState(() {
                _cagnottes.add(list[i]);
              });
            }
          }
        }
        print("liste des cagnottes "+_cagnottes.toString());
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

  double getStars(int id_kitty, var liste){
    int star = 0, nbre=0;
    for(int i=0;i<liste.length;i++){
      if(id_kitty == liste[i]['kitty']['id_kitty'] && liste[i]['trans']['levelKitty']!=null){
        nbre++;
        star = star + liste[i]['trans']['levelKitty'];
      }else{

      }
    }
    rating = star/nbre;
    return rating.toString()!="NaN"?rating:0;
  }

  Future<String> getListKitty() async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.getUrl(Uri.parse("$_url"));
    print("Mon $_url");
    print("Token: $_token");
    request.headers.set('Accept', 'application/json');
    if(_code == "cagnotte")
    request.headers.set('Authorization', 'Bearer $_token');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    if(response.statusCode == 200 || response.statusCode == 403){
      if(closed == false && _code != "cagnotte"){
        _cagnottes = [];
        var list = json.decode(reply);
        for(int i = 0; i<list.length; i++){
          if(list[i]["kitty"]['visibility'] == true){
            setState(() {
              _cagnottes.add(list[i]);
            });
          }
        }
        print(_cagnottes);
      } else{
        _cagnottes = [];
        var list = json.decode(reply);
        for(int i = 0; i<list.length; i++){
          if(_code == "cagnotte"){
            if(list[i]["kitty"]['username'] == _username){
              setState(() {
                _cagnottes.add(list[i]);
              });
            }
          }else{
            if((DateTime.parse(list[i]["kitty"]["endDate"]).difference(DateTime.parse(list[i]["kitty"]["startDate"]))).inDays<0){
              setState(() {
                _cagnottes.add(list[i]);
              });
            }
          }
        }
        print("liste des cagnottes "+_cagnottes.toString());
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
    double leftcagnotte, rightcagnotte, topcagnotte, bottomcagnotte;
    if(_large<=320){
      _width = MediaQuery.of(context).size.width-124;
      filtre = taille_libelle_etape-1.5;
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
    }else if(_large==360 && _haut == 732){
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
      bottomphoto = 90;
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
    } else if(_large == 375){
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
      grand = 5;
    }else if(_large> 412){
      _width = MediaQuery.of(context).size.width-143-71;
      filtre = taille_libelle_etape;
      fromHeight = 200;
      leftcagnotte = 40;
      rightcagnotte = 40;
      topcagnotte = 40;
      bottomcagnotte = 70;
      hauteurcouverture = 300;
      nomright =  MediaQuery.of(context).size.width-400;
      nomtop = 280;
      datetop = 10;
      titretop = 340;
      titreleft = 20;
      amounttop = 360;
      amountleft = 20;
      amountright = 20;
      topcolect = 385;
      topphoto = 0;
      bottomphoto = 180;
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
      grand = 5;
    }
    else if(_large>360){
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
    }
    return WillPopScope(
      // ignore: missing_return
      onWillPop: (){
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Profile('')));
      },
      child: new DefaultTabController(
        length: 3,
        child: new Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomPadding: false,
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
                                  child: Text('Cagnottes',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: taille_titre+grand-2,
                                      color: choix==1? orange_F:Colors.white,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                               /* Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: (){
                                      choix = 2;
                                      this._stock();
                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Tontine('')));
                                    },
                                    child: Text('Tontines',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: taille_titre+grand-2,
                                        color: choix!=1?orange_F:Colors.white,),
                                      textAlign: TextAlign.right,),
                                  ),
                                ),*/
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
                            ),),
                            new Text("Achevées", style: TextStyle(
                              fontSize: filtre+grand-1,
                              fontWeight: FontWeight.bold,
                            ),),
                            new Text("Populaires", style: TextStyle(
                                fontSize: filtre+grand-1,
                                fontWeight: FontWeight.bold
                            ),)
                          ],
                          onTap: (index){
                            setState(() {
                              _code = "";
                              switch(index){
                                case 0:_cagnottes = [];_code = ""; closed = false;_url = _url0;getListKitty();break;
                                case 1:_cagnottes = [];_code = ""; closed = true;_url = _url0;getListKitty();break;
                                case 2:_cagnottes = []; _code = ""; closed = false; _url = _url3;getListKitty();break;
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
          body: _cagnottes.isEmpty?Theme(
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
                itemCount: _cagnottes==null?0:_cagnottes.length,
                itemBuilder: (context, index) => _buildCarousel(context, index),
              ),
              new PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                controller: pageController,
                itemCount: _cagnottes==null?0:_cagnottes.length,
                itemBuilder: (context, index) => _buildCarousel(context, index),
              ),
              new PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                controller: pageController,
                itemCount: _cagnottes==null?0:_cagnottes.length,
                itemBuilder: (context, index) => _buildCarousel(context, index),
              )
            ],
          ),
            floatingActionButton:Platform.isIOS? FloatingActionButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Profile('')));
              },
            backgroundColor: Colors.white,
            splashColor: orange_F,
            child: Icon(Icons.arrow_back, color: bleu_F,size: 30,),
          ):Container(),
          bottomNavigationBar: bottomNavigation(context, _scaffoldKey,  choix, _token),
        ),
      ),
    );
  }

  _buildCarousel(BuildContext context, int index) {
    return _cagnottes[index]["amount_collected"]==null ||  _cagnottes[index]["kitty"]["previsional_amount"] == null?Container():
      InkWell(
        onTap: () {
          kittyImage = _cagnottes[index]["kitty"]["kittyImage"];//_cagnottes[index]["kitty"]["kittyImage"]
          kittyId = _cagnottes[index]["kitty"]['id_kitty'];
          if(_code.isEmpty){}else _code="";
          _user_kitty = _cagnottes[index]["kitty"]['username'];
          titre = _cagnottes[index]["kitty"]["title"];
          user_part = _cagnottes[index]["kitty"]['username'];
          _currency = _cagnottes[index]["kitty"]['currency'];
          this._stock();
          _code = '$index^${_cagnottes[index]["kitty"]["kittyImage"]}^${_cagnottes[index]["kitty"]["firstnameBenef"]}^${_cagnottes[index]["kitty"]["endDate"]}^${_cagnottes[index]["kitty"]["startDate"]}^${_cagnottes[index]["kitty"]["title"]}^${_cagnottes[index]["kitty"]["previsional_amount"]}^${_cagnottes[index]["amount_collected"]}^${_cagnottes[index]["kitty"]["description"]}^${_cagnottes[index]["kitty"]['username']}^${_cagnottes[index]["kitty"]["id_kitty"]}^${_cagnottes[index]["participants_num"]}^${_cagnottes[index]["kitty"]["currency"]}^${_cagnottes[index]["remaining_amount"]}';
          print('${_cagnottes[index]["remaining_amount"]}');
          if(_cagnottes[index]["kitty"]['username'] == _username){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Detail(_code)));
          }else{
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Participer(_code)));
          }
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
                      image:_cagnottes[index]["kitty"]["kittyImage"]!=null && _cagnottes[index]["kitty"]["kittyImage"].toString().startsWith("$cagnotte_url")?
                      DecorationImage(
                          image: NetworkImage(_cagnottes[index]["kitty"]["kittyImage"]),
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
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: nomtop, right:nomright),
                      child: Text('',//_cagnottes[index]["kitty"]["firstnameBenef"],
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: taille_champ
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: datetop, left: 20),
                      child: Text((DateTime.parse(_cagnottes[index]["kitty"]["endDate"]).difference(DateTime.parse(_cagnottes[index]["kitty"]["startDate"]))).inDays>=0?
                      (DateTime.parse(_cagnottes[index]["kitty"]["endDate"]).difference(DateTime.parse(_cagnottes[index]["kitty"]["startDate"]))).inDays.toString() +' jours restants':
                      "Expirée",
                        style: TextStyle(
                            color: couleur_titre,
                            fontWeight: FontWeight.normal,
                            fontSize: taille_description_champ
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: titretop, left: titreleft),
                  child: Text(_cagnottes[index]["kitty"]["title"].toString().length<=xval?_cagnottes[index]["kitty"]["title"].toString():_cagnottes[index]["kitty"]["title"].toString().substring(0, xval)+'...',
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
                        width: _cagnottes[index]["amount_collected"]>0 && _cagnottes[index]["kitty"]["previsional_amount"]>0 && _cagnottes[index]["amount_collected"]<_cagnottes[index]["kitty"]["previsional_amount"]?double.parse(_cagnottes[index]["amount_collected"].toString())*_width/double.parse(_cagnottes[index]["kitty"]["previsional_amount"].toString()):_width,
                        color: _cagnottes[index]["amount_collected"]>0 && _cagnottes[index]["kitty"]["previsional_amount"]>0?orange_F:couleur_titre,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 1, right: 5),
                          child: _cagnottes[index]["amount_collected"]>0 && _cagnottes[index]["kitty"]["previsional_amount"]>0?Text((double.parse(_cagnottes[index]["amount_collected"].toString())*100/double.parse(_cagnottes[index]["kitty"]["previsional_amount"].toString())).toString().split('.')[0]+"%",
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
                        width: _cagnottes[index]["amount_collected"]>0 && _cagnottes[index]["kitty"]["previsional_amount"]>0 && _cagnottes[index]["amount_collected"]<_cagnottes[index]["kitty"]["previsional_amount"]?_width - double.parse(_cagnottes[index]["amount_collected"].toString())*_width/double.parse(_cagnottes[index]["kitty"]["previsional_amount"].toString()):0,//(_width - (double.parse(_cagnottes[index]["amount"].toString())*100/double.parse(_cagnottes[index]["previsional_amount"].toString()))*100/_width)>0?_width - (double.parse(_cagnottes[index]["amount"].toString())*100/double.parse(_cagnottes[index]["previsional_amount"].toString()))*100/_width:0,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 10.0, top: topcolect),
                  child: Row(
                    children: <Widget>[
                      Text(_cagnottes[index]["amount_collected"].toString().split('.')[1].length<=2?getMillis(_cagnottes[index]["amount_collected"].toString())+' ${_cagnottes[index]["kitty"]["currency"]}':getMillis(_cagnottes[index]["amount_collected"].toString()).split('.')[0]+'.'+_cagnottes[index]["amount_collected"].toString().split('.')[1].substring(0,2),
                        style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_description_champ,
                          fontWeight: FontWeight.bold,
                        ),),
                      Text(double.parse(_cagnottes[index]["amount_collected"].toString())>1?' collectés sur ':' collecté sur ',
                        style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_description_champ,
                          fontWeight: FontWeight.normal,
                        ),),


                      Text('${getMillis(_cagnottes[index]["kitty"]["previsional_amount"].toString())} ${_cagnottes[index]["kitty"]["currency"]}',
                        style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_description_champ,
                          fontWeight: FontWeight.bold,
                        ),),
                    ],
                  ),
                ),


                Padding(
                  padding: EdgeInsets.only(bottom: 0),
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, top: toptext+5),
                    child: _cagnottes[index]["kitty"]["description"].toString().length<taille?Text(_cagnottes[index]["kitty"]["description"].toString(),
                      style: TextStyle(
                        color: couleur_bordure,
                        fontSize: taille_libelle_champ,
                      ),
                      textAlign: TextAlign.justify,
                    ):Column(
                      children: <Widget>[
                        Text(_cagnottes[index]["kitty"]["description"].toString().substring(0, taille-enlev),
                          style: TextStyle(
                            color: couleur_bordure,
                            fontSize: taille_libelle_champ,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        Row(
                          children: <Widget>[
                            Text('${_cagnottes[index]["kitty"]["description"].toString().substring(taille-enlev, taille-enlev+rest)}...',style:
                            TextStyle(
                              color: couleur_bordure,
                              fontSize: taille_libelle_champ,
                            ),),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _ackAlert(context, _cagnottes[index]["kitty"]["description"].toString());
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
                                child: Center(child: new Text("Plus", style: new TextStyle(fontSize: taille_text_bouton-1, color: Colors.white),)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: hauteurcouverture+fromHeight),
                  child: Center(
                    child: SmoothStarRating(
                      allowHalfRating: false,
                      rating: double.parse(getStars(_cagnottes[index]["kitty"]["id_kitty"], _trans).toString().split(".")[0]),
                      size: star,
                      starCount: 5,
                      color: orange_F,
                      borderColor: orange_F,
                      spacing:5.0,
                    ),
                  ),
                )
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
      this.getListKitty();
    });
  }

  void _stock() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(CHOIX, choix.toString());
    prefs.setString(ID_KITTY, kittyId.toString());
    prefs.setString(KITTY_IMAGE, kittyImage);
    prefs.setString(USER_KITTY, _user_kitty);
    prefs.setString(TITLE_KITTY, titre);
    prefs.setString(USER_PART, user_part);
    prefs.setString(CURRENCY, _currency);
  }
}