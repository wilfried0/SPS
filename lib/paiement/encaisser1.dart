import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:services/auth/profile.dart';
import 'package:services/composants/components.dart';
import 'package:services/paiement/getsoldewidget.dart';
import 'encaisser2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


// ignore: must_be_immutable
class Encaisser1 extends StatefulWidget {
  Encaisser1(this._code);
  String _code;
  @override
  _Encaisser1State createState() => new _Encaisser1State(_code);
}

class _Encaisser1State extends State<Encaisser1> {
  _Encaisser1State(this._code);
  String _code;
  PageController pageController;
  int currentPage = 0;
  int indik=1;
  var _userTextController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //final navigatorKey = GlobalKey<NavigatorState>();
  // ignore: non_constant_identifier_names
  int recenteLenght, archiveLenght, populaireLenght, id_kitty;
  var _formKey = GlobalKey<FormState>();
  int flex4, flex6, taille, enlev, rest, enlev1;
  double _taill,gauch,amountCible,fees,newSolde, droit, hauteurcouverture, nomright, nomtop, right1, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext, left1, social, topo, div1, div2, margeleft, margeright;
  List data, list;
  bool isLoading = false;
  // ignore: non_constant_identifier_names
  String kittyImage,code, _url, firstnameBenef,_username, _password, kittyId,remain, particip, previsional_amount,amount_collected, endDate, startDate, title, suggested_amount, amount, description, number, nom="", tel="", email="", montant="", mot="", solde, deviseLocale, local, devise, country;

  @override
  void initState() {
    this.read();
    super.initState();
    _userTextController = new MoneyMaskedTextController(decimalSeparator: '', thousandSeparator: '.', precision: 0);
    pageController = PageController(
        initialPage: currentPage,
        keepPage: false,
        viewportFraction: 0.8
    );
    _url = "$base_url/transaction/getRateAmountByCurrency";
    //BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    //_tabController.dispose();
    _userTextController.dispose();
    super.dispose();
    //BackButtonInterceptor.remove(myInterceptor);
  }

  bool myInterceptor(bool stopDefaultButtonEvent) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Profile(_code)));
    //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Profile(_code)));
    //navigatorKey.currentState.pushNamed("/profil"); // Do some stuff.
    return false;
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      country = prefs.getString("iso3");
      print(country);
      solde = prefs.getString("solde");
      devise = prefs.getString("devise");
      local = prefs.getString("local");
      deviseLocale = prefs.getString("deviseLocale");
    });
  }

  Future<String> getRateAmountByCurrency(var body) async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString("username");
    _password = prefs.getString("password");
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse(_url));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json');
    request.headers.set('Authorization', 'Basic $credentials');
    request.add(utf8.encode(body));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print("statusCode ${response.statusCode}");
    print("body $reply");
    print("url $_url");
    if (response.statusCode < 200 || json == null) {
      throw new Exception("Error while fetching data");
    }else if(response.statusCode == 200){
      var responseJson = json.decode(reply);
      amountCible = responseJson['amountCible'];
      if(amountCible<100){
        setState(() {
          isLoading = false;
        });
        showInSnackBar("Le montant doit être supérieur ou égale à 100 XAF");
      }else{
        var getcommission = getCommission(
            typeOperation:code,
            country: "$country",
            amount: int.parse(this.montant.replaceAll(".", "")),
            deviseLocale: deviseLocale
        );
        print(json.encode(getcommission));
        checkConnection(json.encode(getcommission), indik);
      }
    }else {
      showInSnackBar("Service indisponible!");
    }
    return null;
  }

  void checkConnection(var body, int q) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      //print("Connected to Mobile");
      setState(() {
        print("q vaut $q");
        isLoading = true;
        if(q == 0){//MTN
          getSoldeCommission(body, q);
        }else if(q == 1){//ORANGE
          getSoldeCommission(body, q);
        }else if(q == 2){//PAYPAL
          getSoldeCommission(body, q);
        }else if(q == 3){//CARD
          getSoldeCommission(body, q);
          //getSoldeCommission(body, q);
        }else{
          isLoading = false;
          showInSnackBar("Service pas encore disponible!");
        }
      });
      //this.getUser();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Connexion(_code)));
      setState(() {
        print("q vaut $q");
        isLoading = true;
        if(q == 0){//MTN
          getSoldeCommission(body, q);
        }else if(q == 1){//ORANGE
          getSoldeCommission(body, q);
        }else if(q == 2){//PAYPAL
          getSoldeCommission(body, q);
        }else if(q == 3){//CARD
          getSoldeCommission(body, q);
        }else{
          isLoading = false;
          showInSnackBar("Service non disponible!");
        }
      });
      //this.getUser();103587
    } else {
      _ackAlert(context);
    }
  }

  Future<String> getSoldeCommission(var body, int q) async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString("username");
    _password = prefs.getString("password");
    print("$_username, $_password");
    String fee = "$base_url/transaction/getFeesTransaction";
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse("$fee"));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json');
    request.headers.set('Authorization', 'Basic $credentials');
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
        fees = responseJson['fees'];
        newSolde = double.parse(montant)+fees;
        print(newSolde.toString());
        print(double.parse(local));
        this._save();
        setState(() {
          isLoading = false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Encaisser2(_code)));
        //navigatorKey.currentState.pushNamed("/encaisser");
      }else {
        setState(() {
          isLoading = false;
        });
        showInSnackBar("Service indisponible!");
      }
  }

  Future<void> _ackAlert(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    final _large = MediaQuery.of(context).size.width;
    double fromHeight = 120;
    if(_large<=320){
      hauteurcouverture = 250;
      fromHeight = 200;
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
      _taill = taille_description_champ-3;
      gauch = 20;
      droit = 20;
    }else if(_large>320){
      fromHeight = 200;
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
      _taill = taille_description_champ-1;
      gauch = 20;
      droit = 20;
    }
    //return new MaterialApp(
    /*navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white, accentColor: Color(0xFF2A2A42), fontFamily: 'Poppins'),
      routes: <String, WidgetBuilder>{
        "/encaisser": (BuildContext context) =>new Encaisser2(_code),
        "/profil": (BuildContext context) =>new Profile(_code),
      },*/
    return new DefaultTabController(
      length: 1,
      child: new Scaffold(
        backgroundColor: GRIS,
          key: _scaffoldKey,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(fromHeight),
            child: new Container(
              color: bleu_F,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 23, left: 20, right: 20),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Profile(_code)));
                            },
                            icon: Icon(Icons.arrow_back_ios,color: Colors.white,)
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Profile(_code)));
                              //Navigator.pop(context);
                              //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Profile('$_code')));
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
                    padding: EdgeInsets.only(top: 0, left: gauch, right: droit),
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
                    padding: EdgeInsets.only(top: 20),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('Recharger mon compte',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: taille_titre-2,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),

                  getSoldeWidget(),

                  /*Padding(
                      padding: EdgeInsets.only(top: 20),//solde du compte
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('SOLDE DU COMPTE', style: TextStyle(
                            color: Colors.white,
                            fontSize: taille_libelle_etape-2
                        ),),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(solde==null?"1.500,0 XAF":getMillis('$solde'), style: TextStyle(//Montant du solde
                            color: orange_F,
                            fontSize: taille_titre+8,
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                    ),*/
                ],
              ),
            ),
          ),
          body: _buildCarousel(context),
          bottomNavigationBar: barreBottom
      ),
    );
    //);
  }


  _buildCarousel(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: GRIS,
                borderRadius: BorderRadius.circular(10.0)
            ),
            child: Form(
              key: _formKey,
              child: Stack(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20, left: gauch, right: droit),
                        child: Text('Par quel moyen souhaitez-vous recharger votre compte ?',
                          style: TextStyle(
                              color: couleur_titre,
                              fontSize: taille_libelle_etape,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      country == null?Container():
                      country == "COG"?
                      Padding(
                        padding: EdgeInsets.only(top: 20, left: 0, right: 0),
                        child: CarouselSlider(
                          enlargeCenterPage: true,
                          autoPlay: false,
                          enableInfiniteScroll: false,
                          initialPage: 2,
                          onPageChanged: (value){
                            setState(() {
                              indik = value;
                              _code = "$indik";
                              print("Congo ******* $indik");
                            });
                          },
                          height:MediaQuery.of(context).size.width>1000?286: 136.0,
                          items: [1,2].map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return getMoyen(i);
                              },
                            );
                          }).toList(),
                        ),
                      ):country == "CMR"?Padding(
                        padding: EdgeInsets.only(top: 20, left: 0, right: 0),
                        child: CarouselSlider(
                          enlargeCenterPage: true,
                          autoPlay: false,
                          enableInfiniteScroll: true,
                          initialPage: 1,
                          onPageChanged: (value){
                            setState(() {
                              indik = value;
                              _code = "$indik";
                              print("cameroun ******* $indik");
                            });
                          },
                          height:MediaQuery.of(context).size.width>1000?286: 136.0,
                          items: [1,2,3].map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return getMoyen(i);
                              },
                            );
                          }).toList(),
                        ),
                      ):Padding(
                        padding: EdgeInsets.only(top: 20, left: 0, right: 0),
                        child: CarouselSlider(
                          enlargeCenterPage: true,
                          autoPlay: false,
                          enableInfiniteScroll: false,
                          //initialPage: 1,
                          onPageChanged: (value){
                            setState(() {
                              indik = value;
                              _code = "$indik";
                              print("europe et autres ******* $indik");
                            });
                          },
                          height:MediaQuery.of(context).size.width>1000?286: 136.0,
                          items: [3].map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return getMoyen(3);
                              },
                            );
                          }).toList(),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 20, left: gauch, right: droit),
                        child: Text('Quel est le montant de votre recharge?',
                          style: TextStyle(
                              color: couleur_titre,
                              fontSize: taille_libelle_etape,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: gauch, right: droit, top: 20),
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
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                        color: couleur_libelle_champ,
                                        fontSize: taille_champ+3,
                                        fontFamily: police_champ
                                    ),
                                    validator: (String value){
                                      if(value.isEmpty || int.parse(value.replaceAll(".", ""))==0){
                                        return "Montant vide !";
                                      }else{
                                        montant = value;
                                        //_userTextController.text = montant;
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration.collapsed(
                                      hintText: 'Montant de la recharger',
                                      hintStyle: TextStyle(
                                          color: couleur_libelle_champ,
                                          fontSize: taille_champ+3,
                                          fontFamily: police_champ
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
                        padding: EdgeInsets.only(top:20,left: gauch, right: droit),
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              if(country != "CMR" && country != "COG")
                                indik = 2;
                              _code = '$indik';
                              //String code;
                              switch(indik){
                                case 0: code = "MOMO_TO_WALLET";break;
                                case 1: code = country == "COG"?"CARD_TO_WALLET" :"OM_TO_WALLET";country == "COG"?_code = '2':_code='$indik';break;
                                case 3: code = "PAYPAL_TO_WALLET";break;
                                case 2: code = "CARD_TO_WALLET";break;
                              }
                              if(_formKey.currentState.validate()) {
                                var getrateAmount = getRateAmount(
                                    countryCible: "$country",
                                    amount: int.parse(this.montant.replaceAll(".", "")),
                                    deviseLocale: deviseLocale
                                );
                                print(json.encode(getrateAmount));
                                this.getRateAmountByCurrency(json.encode(getrateAmount));
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
                              borderRadius: new BorderRadius.circular(10.0),
                            ),
                            child: new Center(child:isLoading==false? new Text('Poursuivre', style: new TextStyle(fontSize: taille_text_bouton+3, color: couleur_text_bouton),):
                            Theme(
                                data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.dark)),
                                child: CupertinoActivityIndicator(radius: 20,)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  void _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("montant", "${montant.replaceAll(".", "")}");
    prefs.setString("fees", "$fees");
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text(value,style:
        TextStyle(
            color: Colors.white,
            fontSize: taille_description_champ+3
        ),
          textAlign: TextAlign.center,),
          backgroundColor: couleur_fond_bouton,
          duration: Duration(seconds: 5),));
  }


  Widget getMoyen(int index){
    String text, img;
    switch(index){
      case 1: text =country == "COG"?"MTN MOBILE MONEY CONGO": "MTN MOBILE MONEY CMR";img ='images/mtn.jpg';
      break;
      case 2: text = country == "COG"?"CARTE BANCAIRE" :"ORANGE MONEY";img = country == "COG"? 'images/carte.jpg':'images/orange.png';
      break;
      case 3: text = "CARTE BANCAIRE";img = 'images/carte.jpg';
      break;
      case 6: text = "CASH PAR EXPRESS UNION";img = 'images/eu.png';
      break;
      case 5: text = "YUP";img = 'marketimages/yup.jpg';
      break;
      case 4: text = "CARTE PAYPAL";img = 'images/paypal.jpg';
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
                height:MediaQuery.of(context).size.width>1000?210: 80,
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
                      fontSize: _taill,
                      fontWeight: FontWeight.bold
                  ),):Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('$text',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: _taill,
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
}
