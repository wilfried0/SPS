import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';
import 'package:services/composants/components.dart';
import 'package:services/paiement/getsoldewidget.dart';
import 'package:services/paiement/webview.dart';
import 'confirma.dart';
import 'echec.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'retrait1.dart';


// ignore: must_be_immutable
class Retrait2 extends StatefulWidget {
  Retrait2(this._code);
  String _code;
  @override
  _Retrait2State createState() => new _Retrait2State(_code);
}

class _Retrait2State extends State<Retrait2> {
  _Retrait2State(this._code);
  String _code;
  int currentPage = 0;
  int choice = 0;
  int recenteLenght, archiveLenght, populaireLenght;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int flex4, flex6, taille, enlev, rest, enlev1, indik;
  double aj,fees, ajj,gauch, droit,_taill, hauteurcouverture, nomright, nomtop, right1, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext, left1, social, topo, div1, div2, margeleft, margeright;
  List data, list;
  GlobalKey<ScaffoldState> _scaffoldKey0 = new GlobalKey<ScaffoldState>();
  var _userTextController = new TextEditingController();
  var _phoneTextController = new TextEditingController();
  bool isLoading =false;
  String url, _id, _to, payment_url, echec;
  int temps = 600;
  // ignore: non_constant_identifier_names
  String kittyImage,solde, previsional_amount, amount_collected, kittyId, firstnameBenef,particip, endDate, startDate, title, suggested_amount, amount, description, number, nom="", tel="", email="", montant="", mot="",  _username, _password, deviseLocale;

  @override
  void initState() {
    super.initState();
    this.read();
    switch(int.parse(_code)){
      case 0:url = '$base_url/transfert/cashinMtn';break;
      case 1:url = '$base_url/transfert/cashinOM';break;
      //case 3:url = '$base_url/transfert/refillByCard'; break;
    }
    indik = int.parse(_code)+1;
    print(indik);
  }

  @override
  void dispose() {
    _userTextController.dispose();
    _phoneTextController.dispose();
    super.dispose();
  }

  void _reg(String echec) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('echec', "$echec");
  }

  void checkConnection(var body) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      //print("Connected to Mobile");
      setState(() {
        isLoading = true;
        this.getId(body);
      });
      //this.getUser();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Connexion(_code)));
      setState(() {
        isLoading = true;
        this.getId(body);
      });
      //this.getUser();
    } else {
      _ackAlert(context);
    }
  }

  void _save(String id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("id", "$id");
    print("mon id $id");
  }

  void save(String payment_url) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("payment_url", "$payment_url");
    print("mon payment_url $payment_url");
  }

  Future<String> getId(var body) async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString("username");
    _password = prefs.getString("password");
    print("$_username, $_password");
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    print(url);
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse("$url"));
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
        _id = responseJson['id'];
        String payment_url = responseJson['payment_url'];
        if(_id == "INTERNAL_SERVER_ERROR"){
          setState(() {
            isLoading = false;
          });
          showInSnackBar("Montant non autorisé!", _scaffoldKey0);
        }else if(responseJson['payment_url'] == "THIS_CUSTOMER_HAS_EXCEEDED_HIS_LIMIT_NUMBER_OF_OPERATION"){
          setState(() {
            isLoading = false;
          });
          showInSnackBar("Vous avez atteint le nombre max d'opérations!", _scaffoldKey0);
        }else if(responseJson['payment_url'] == "THE_AMOUNT_OF_THIS_TRANSACTION_IS_GRATER_THAN_THE_THE_MAXIMUM_AMOUNT_PLANNED_FOR_YOUR_PROFILE"){
          setState(() {
            isLoading = false;
          });
          showInSnackBar("Le montant de la transaction est supérieur à celui autorisé à votre profil", _scaffoldKey0);
        }else if(responseJson['payment_url'] == "CLIENT_LOCKED_BY_SYSTEM"){
          setState(() {
            isLoading = false;
          });
          showInSnackBar("Veuillez compléter vos informations dans mon profil pour continuer à effectuer les opérations", _scaffoldKey0);
        }else if(responseJson['payment_url'] == "CLIENT_LOCKED_BY_BACK_OFFICE"){
          setState(() {
            isLoading = false;
          });
          showInSnackBar("Votre compte a été bloqué veuillez contacyer le service client!", _scaffoldKey0);
        }else if(responseJson['id'] == "NOT_FOUND"){
          setState(() {
            isLoading = false;
          });
          showInSnackBar("Service indisponible!", _scaffoldKey0);
        }else if(payment_url != null){
          setState(() {
            save(payment_url);
            _save(_id);
          });
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Webview(_code)));
        }else{
          this.getStatus(_id);
        }
      }else {
        setState(() {
          isLoading = false;
        });
        showInSnackBar("Echec de l'opération!", _scaffoldKey0);
      }
      return null;
  }

  Future<String> getStatus(String id) async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString("username");
    _password = prefs.getString("password");
    print("$_username, $_password");
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    var url = "$base_url/transaction/checkStatus/$id";
    print(url);
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json');
    request.headers.set('Authorization', 'Basic $credentials');
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
          this._reg(responseJson['description'].toString());
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Echec('_code^§')));
        }else if(temps > 0){
          temps--;
          getStatus(id);
        }
      }else if(responseJson['status'] == "PROCESSED"){
        setState(() {
          isLoading = false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Confirma('retrait')));
      }else if(responseJson['status'] == "REFUSED"){
        setState(() {
          isLoading = false;
        });
        this._reg(responseJson['description'].toString());
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Echec('_code^§')));
      }else{
        setState(() {
          isLoading = false;
        });
        showInSnackBar("Service indisponible!", _scaffoldKey0);
      }
    }else{
      setState(() {
        isLoading = false;
      });
      showInSnackBar("Service indisponible", _scaffoldKey0);
    }
    return null;
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
    double fromHeight = 200;
    switch(indik){
      case 1:aj=100; ajj=100;break;
      case 2:aj=100; ajj=100;break;
      case 4:aj=100; ajj=200; break;
      default:aj=100;ajj=0;
    }
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
      gauch = 20;
      droit = 20;
      _taill = taille_description_champ-3;
    }else if(_large>320 && _large<=414){
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
      gauch = 20;
      droit = 20;
      _taill = taille_description_champ-1;
    }
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white, accentColor: Color(0xFF2A2A42), fontFamily: 'Poppins'),
      home: new Scaffold(
        key: _scaffoldKey0,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(fromHeight),
            child: new Container(
              color: bleu_F,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 23, left: 20, right: 20),
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                            onTap: (){
                              setState(() {
                                Navigator.pop(context);
                              });
                            },
                            child: Icon(Icons.arrow_back_ios,color: Colors.white,)
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              //Navigator.pop(context);
                              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Retrait1('$_code')));
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
                      child: Text('Etape 2 sur 2',
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
                      child: Text('Retirer de l\'argent',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: taille_titre-2,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  getSoldeWidget(),
                ],
              ),
            ),
          ),
          body: _buildCarousel(context),
          bottomNavigationBar: barreBottom
      ),
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
            child:  Form(
              key: _formKey,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: gauch, right: droit),
                    child: Text('Moyen par lequel vous allez faire un retrait de votre compte.',
                      style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_libelle_etape,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:70),
                    child: CarouselSlider(
                      enlargeCenterPage: true,
                      autoPlay: false,
                      enableInfiniteScroll: false,
                      onPageChanged: (value){},
                      height: 135.0,
                      items: [indik].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return getMoyen(indik);
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 230, left: gauch, right: droit),
                    child: Text("Vous êtes sur le point de retirer de votre compte un montant de",
                      style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_libelle_etape,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 270, left: gauch, right: droit),
                    child: Text(montant==""?'':'${getMillis(double.parse(montant).toString())} $deviseLocale',
                      style: TextStyle(
                          color: couleur_libelle_etape,
                          fontSize: taille_titre+15,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 330, left: gauch, right: droit),
                    child: Text("Commission de la transaction",
                      style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_libelle_etape,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 350, left: gauch, right: droit),
                    child: Text(fees==null?"":'${getMillis(fees.toString())} $deviseLocale',
                      style: TextStyle(
                          color: couleur_libelle_etape,
                          fontSize: taille_titre+15,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 310+aj, left: gauch, right: droit),
                    child: Text("Montant total à débiter",
                      style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_libelle_etape,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 330+aj, left: gauch, right: droit),
                    child: Text(montant==""?"":'${getMillis((double.parse(montant)+fees).toString())} $deviseLocale',
                      style: TextStyle(
                          color: couleur_libelle_etape,
                          fontSize: taille_titre+15,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  indik==1||indik==4||indik==2?Padding(
                    padding: EdgeInsets.only(top: 395+aj, left: gauch, right: droit),
                    child: Text("Informations sur le bénéficiaire",
                      style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_libelle_etape,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ):Container(),

                  indik==1||indik==4||indik==2?Padding(
                    padding: EdgeInsets.only(top: 425+aj, left: gauch, right: droit),
                    child: Container(
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(indik==1|| indik==2?10.0:0),
                          bottomRight: Radius.circular(indik==1|| indik==2?10.0:0),
                        ),
                        color: Colors.transparent,
                        border: Border.all(
                            color: couleur_bordure,
                            width: bordure
                        ),
                      ),
                      height: hauteur_champ,
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                            flex:2,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: new Icon(Icons.phone_iphone, color: couleur_description_champ,),
                            ),
                          ),
                          new Expanded(
                            flex:10,
                            child: new TextFormField(
                              controller: _phoneTextController,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                fontSize: taille_libelle_champ+3,
                                color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return 'Champ téléphone vide !';
                                }else{
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Numéro de téléphone',
                                hintStyle: TextStyle(
                                  fontSize: taille_libelle_champ,
                                  color: couleur_libelle_champ,
                                ),
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ):Container(),

                  indik==4?Padding(
                    padding: EdgeInsets.only(left: gauch, right: droit, top: 475+aj),
                    child: Container(
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          topLeft: Radius.circular(0.0),
                          topRight: Radius.circular(0.0),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                        ),
                        color: Colors.transparent,
                        border: Border.all(
                            color: couleur_bordure,
                            width: bordure
                        ),
                      ),
                      height: hauteur_champ,
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                            flex:2,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: new Icon(Icons.person, color: couleur_description_champ,),
                            ),
                          ),
                          new Expanded(
                            flex:10,
                            child: new TextFormField(
                              //controller: _userTextController,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                fontSize: taille_libelle_champ,
                                color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return 'Champ prénom vide !';
                                }else{
                                  _userTextController.text = value;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Prénom',
                                hintStyle: TextStyle(
                                  fontSize: taille_libelle_champ,
                                  color: couleur_libelle_champ,
                                ),
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ):Container(),
                  indik==4?Padding(
                    padding: EdgeInsets.only(left: gauch, right: droit, top: 525+aj),
                    child: Container(
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          topLeft: Radius.circular(0.0),
                          topRight: Radius.circular(0.0),
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                        color: Colors.transparent,
                        border: Border.all(
                            color: couleur_bordure,
                            width: bordure
                        ),
                      ),
                      height: hauteur_champ,
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                            flex:2,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: new Icon(Icons.person, color: couleur_description_champ,),
                            ),
                          ),
                          new Expanded(
                            flex:10,
                            child: new TextFormField(
                              //controller: _userTextController,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                fontSize: taille_libelle_champ,
                                color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return 'Champ nom vide !';
                                }else{
                                  _userTextController.text = value;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Nom',
                                hintStyle: TextStyle(
                                  fontSize: taille_libelle_champ,
                                  color: couleur_libelle_champ,
                                ),
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ):Container(),

                  Padding(
                    padding: EdgeInsets.only(top:405+aj+ajj,left: gauch, right: droit, bottom: 20),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          if(isLoading == true){

                          }else{
                            if(_formKey.currentState.validate()){
                              var walletTr = _code == "0"? new walletTrans(
                                to:'$_to',
                                amount: int.parse(this.montant),
                                fees: fees,
                                description: this.description,
                                deviseLocale: this.deviseLocale,
                                toFirstname: this._to,
                                toCountryCode: "CMR",
                              ):new orangeRetrait(
                                  to:this._to,
                                  amount: int.parse(this.montant),
                                  fees: fees,
                                  description: this.description,
                                  deviseLocale: this.deviseLocale
                              );
                              print(json.encode(walletTr));
                              checkConnection(json.encode(walletTr));
                            }
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
                        child: new Center(child:isLoading==false? new Text('Confirmer le retrait', style: new TextStyle(fontSize: taille_text_bouton+3, color: couleur_text_bouton),):
                            CupertinoActivityIndicator()
                        ),
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

  read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      montant = prefs.getString("montant");
      _to = prefs.getString("to");
      _phoneTextController.text = _to;
      fees = double.parse(prefs.getString("fees"));
      deviseLocale = prefs.getString("deviseLocale");
    });
  }

  Widget getMoyen(int index){
    String text, img;
    switch(index){
      case 1: text = "MTN MOBILE MONEY";img = 'mtn.jpg';
      break;
      case 2: text = "ORANGE MONEY";img = 'orange.png';
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
        color: orange_F,
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
                height: 90,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    ),
                    image: DecorationImage(
                      image: AssetImage('images/$img'),
                      fit: BoxFit.cover,
                    )
                ),),
              Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text('$text',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: _taill,
                        fontWeight: FontWeight.bold
                    ),)
              )
            ],
          ),
        ),
      ),
    );
  }
}

void showInSnackBar(String value, GlobalKey<ScaffoldState> _scaffoldKey0) {
  _scaffoldKey0.currentState.showSnackBar(
      new SnackBar(content: new Text(value,style:
      TextStyle(
          color: Colors.white,
          fontSize: taille_description_champ+3
      ),
        textAlign: TextAlign.center,),
        backgroundColor: couleur_fond_bouton,
        duration: Duration(seconds: 5),));
}