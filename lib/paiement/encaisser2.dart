import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:services/composants/components.dart';
import 'package:services/paiement/getsoldewidget.dart';
import 'package:services/paiement/ioswebview.dart';
import 'package:services/paiement/webview.dart';
import 'confirma.dart';
import 'echec.dart';
import 'encaisser1.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:get_ip/get_ip.dart';


// ignore: must_be_immutable
class Encaisser2 extends StatefulWidget {
  Encaisser2(this._code);
  String _code;
  @override
  _Encaisser2State createState() => new _Encaisser2State(_code);
}

class _Encaisser2State extends State<Encaisser2> {
  _Encaisser2State(this._code);
  String _code;
  int currentPage = 0;
  int choice = 0;
  int recenteLenght, archiveLenght, populaireLenght;
  var _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final navigatorKey = GlobalKey<NavigatorState>();
  int flex4, flex6, taille, enlev, rest, enlev1, indik;
  double gauch,fees, droit,_taill, hauteurcouverture, nomright, nomtop, right1, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext, left1, social, topo, div1, div2, margeleft, margeright;
  List data, list;
  bool isLoading = false;
  String url, _id, _to, payment_url, _ip;
  int temps = 600;
  var _userTextController = new TextEditingController();
  // ignore: non_constant_identifier_names
  String kittyImage,solde, previsional_amount, amount_collected, kittyId, firstnameBenef,particip, endDate, startDate, title, suggested_amount, amount, description, number, nom="", tel="", email="", montant="", mot="", _username, _password, deviseLocale, local, devise, country;

  @override
  void initState() {
    print(_code);
    this.read();
    switch(int.parse(_code)){
      case 0:url = '$base_url/transfert/refillByMomo';break;
      case 1:url = '$base_url/transfert/refillByOrange';break;
      case 2:url = '$base_url/transfert/refillByCard'; break;
      //case 4:url = '$base_url/transfert/refillByYup'; break;
    }
    super.initState();
    initPlatformState();
    indik = int.parse(_code)+1;
  }

  Future<void> initPlatformState() async {
    String ipAddress;
    try {
      ipAddress = await GetIp.ipAddress;
    } on PlatformException {
      print("mon adresse: $_ip");
      setState(() {
        initPlatformState();
      });
    }
    if (!mounted) return;
    setState(() {
      _ip = ipAddress;
    });
  }

  @override
  void dispose() {
    _userTextController.dispose();
    super.dispose();
    //BackButtonInterceptor.remove(myInterceptor);
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      montant = prefs.getString("montant");
      fees = double.parse(prefs.getString("fees"));
      deviseLocale = prefs.getString("deviseLocale");
      _to = prefs.getString("username");
    });
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
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
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
          showInSnackBar("Montant non autorisé!", _scaffoldKey);
        }else if(responseJson['payment_url'] == "THIS_CUSTOMER_HAS_EXCEEDED_HIS_LIMIT_NUMBER_OF_OPERATION"){
          setState(() {
            isLoading = false;
          });
          showInSnackBar("Vous avez atteint le nombre max d'opérations!", _scaffoldKey);
        }else if(responseJson['payment_url'] == "THE_AMOUNT_OF_THIS_TRANSACTION_IS_GRATER_THAN_THE_THE_MAXIMUM_AMOUNT_PLANNED_FOR_YOUR_PROFILE"){
          setState(() {
            isLoading = false;
          });
          showInSnackBar("Le montant de la transaction est supérieur à celui autorisé à votre profil", _scaffoldKey);
        }else if(responseJson['payment_url'] == "CLIENT_LOCKED_BY_SYSTEM"){
          setState(() {
            isLoading = false;
          });
          showInSnackBar("Veuillez compléter vos informations dans mon profil pour continuer à effectuer les opérations", _scaffoldKey);
        }else if(responseJson['payment_url'] == "CLIENT_LOCKED_BY_BACK_OFFICE"){
          setState(() {
            isLoading = false;
          });
          showInSnackBar("Veuillez compléter vos informations dans mon profil pour continuer à effectuer les opérations", _scaffoldKey);
        }else if(responseJson['payment_url'] == "CLIENT_CONFIG_NOT_FOUND"){
          setState(() {
            isLoading = false;
          });
          showInSnackBar("Votre compte a été bloqué veuillez contacyer le service client!", _scaffoldKey);
        }else if(responseJson['id'] == "NOT_FOUND"){
          setState(() {
            isLoading = false;
          });
          showInSnackBar("Service indisponible!", _scaffoldKey);
        }else if(payment_url != null){
          setState(() {
            save(payment_url);
            _save(_id);
          });
          if(Platform.isIOS){
            navigatorKey.currentState.pushNamed("/ioswebview");
          }else
          navigatorKey.currentState.pushNamed("/webview");
        }else{
          this.getStatus(_id);
        }
      }else {
        setState(() {
          isLoading = false;
        });
        showInSnackBar("Echec de l'opération!", _scaffoldKey);
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
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.set('accept', 'application/json');
    request.headers.set('Authorization', 'Basic $credentials');
    request.headers.set('content-type', 'application/json');
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
          showInSnackBar("Votre transaction est en cours...", _scaffoldKey);
        }else if(temps > 0){
          temps--;
          getStatus(id);
        }
      }else if(responseJson['status'] == "PROCESSED"){
        setState(() {
          isLoading = false;
        });
        navigatorKey.currentState.pushNamed("/confirma");
      }else if(responseJson['status'] == "REFUSED"){
        setState(() {
          isLoading = false;
        });
        navigatorKey.currentState.pushNamed("/echec");
      }else{
        setState(() {
          isLoading = false;
        });
        showInSnackBar("Service indisponible!", _scaffoldKey);
      }
    }else{
      setState(() {
        isLoading = false;
      });
      showInSnackBar("Service indisponible", _scaffoldKey);
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
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white, accentColor: Color(0xFF2A2A42), fontFamily: 'Poppins'),
      routes: <String, WidgetBuilder>{
        "/echec": (BuildContext context) =>new Echec("_code^&"),
        "/confirma": (BuildContext context) =>new Confirma("recharge"),
        "/encaisser": (BuildContext context) =>new Encaisser1(_code),
        "/webview": (BuildContext context) =>new Webview(_code),
        "/ioswebview": (BuildContext context) =>new IosWebview(_code),
      },
      home: new DefaultTabController(
        length: 1,
        child: new Scaffold(
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
                        GestureDetector(
                            onTap: (){
                              setState(() {
                                navigatorKey.currentState.pushNamed("/encaisser");
                              });
                            },
                            child: Icon(Icons.arrow_back_ios,color: Colors.white,)
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              navigatorKey.currentState.pushNamed("/encaisser");
                            });
                          },
                          child: Text('Retour',
                            style: TextStyle(color: Colors.white, fontSize: taille_champ),),
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: Text('Etape 2 sur 2',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: taille_libelle_etape,
                          fontWeight: FontWeight.bold
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
                ],
              ),
            ),
          ),
            body: _buildCarousel(context),
            bottomNavigationBar: barreBottom
        ),
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
            child: Form(
              key: _formKey,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: gauch, right: droit),
                    child: Text('Moyen par lequel vous allez recharger votre compte.',
                      style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_libelle_etape,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  deviseLocale != "XAF"?Padding(
                    padding: EdgeInsets.only(top: 70, left: 0, right: 0),
                    child: CarouselSlider(
                      enlargeCenterPage: true,
                      autoPlay: false,
                      enableInfiniteScroll: false,
                      onPageChanged: (value){},
                      height: 135.0,
                      items: [3].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return getMoyen(3);
                          },
                        );
                      }).toList(),
                    ),
                  )
                      :Padding(
                      padding: EdgeInsets.only(top: 70, left: 0, right: 0),
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
                    padding: EdgeInsets.only(top: 220, left: gauch, right: droit),
                    child: Text("Vous êtes sur le point de recharger votre compte d'un montant de",
                      style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_libelle_etape,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top:MediaQuery.of(context).size.width<=320?280 :260, left: gauch, right: droit),
                    child: Text(montant==""?"":'${getMillis(double.parse(montant).toString())} $deviseLocale',
                      style: TextStyle(
                          color: couleur_libelle_etape,
                          fontSize:MediaQuery.of(context).size.width<=320 && montant.length>=6? taille_titre+10:taille_titre+15,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top:MediaQuery.of(context).size.width<=320?350: 330, left: gauch, right: droit),
                    child: Text("Commission de la transaction",
                      style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_libelle_etape,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top:MediaQuery.of(context).size.width<=320?370: 350, left: gauch, right: droit),
                    child: Text(fees==null?"":'${getMillis(fees.toString())} $deviseLocale',
                      style: TextStyle(
                          color: couleur_libelle_etape,
                          fontSize:MediaQuery.of(context).size.width<=320 && montant.length>=6? taille_titre+10: taille_titre+15,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top:MediaQuery.of(context).size.width<=320?440: 420, left: gauch, right: droit),
                    child: Text("Montant total de la transaction",
                      style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_libelle_etape,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top:MediaQuery.of(context).size.width<=320?460: 440, left: gauch, right: droit),
                    child: Text(montant==""?"":'${getMillis((double.parse(montant)+fees).toString())} $deviseLocale',
                      style: TextStyle(
                          color: couleur_libelle_etape,
                          fontSize:MediaQuery.of(context).size.width<=320 && montant.length>=6? taille_titre+10: taille_titre+15,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  indik==3||indik==5||deviseLocale!="XAF"?Container():Padding(
                    padding: EdgeInsets.only(top:MediaQuery.of(context).size.width<=320?530: 510, left: gauch, right: droit),
                    child: Text(indik==1?"Téléphone MoMo à débiter":indik==2?"Téléphone OM à débiter":"Téléphone bénéficiaire",
                      style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_libelle_etape,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  indik==3||indik==5||deviseLocale!="XAF"?Container():Padding(
                    padding: EdgeInsets.only(left: gauch, right: droit, top:MediaQuery.of(context).size.width<=320?560 :540),
                    child: Container(
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0)
                        ),
                        color: Colors.transparent,
                        border: Border.all(
                            width: bordure,
                            color: couleur_bordure
                        ),
                      ),
                      height: hauteur_champ,
                      child: Padding(
                        padding: EdgeInsets.only(left: 0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                flex: 5,
                                child: CountryCodePicker(
                                  showFlag: true,
                                  onChanged: (CountryCode code){
                                    //_mySelection = code.dialCode.toString();
                                  },
                                )
                            ),
                            Expanded(
                              flex: 10,
                              child: TextFormField(
                                //controller: _userTextController3,
                                keyboardType: TextInputType.phone,
                                style: TextStyle(
                                    fontSize: taille_libelle_champ+3,
                                    color: couleur_libelle_champ,
                                    fontFamily: police_champ
                                ),
                                validator: (String value){
                                  if(value.isEmpty){
                                    return 'Téléphone vide !';
                                  }else{
                                    _to = '$value';
                                    return null;
                                  }
                                },
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Contact du débiteur',
                                  hintStyle: TextStyle(
                                      color: couleur_libelle_champ,
                                      fontSize: taille_champ+3
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:(MediaQuery.of(context).size.width<=320 && indik==3||indik==5||deviseLocale!="XAF")?520:(MediaQuery.of(context).size.width<=320 && indik!=3)?640:indik==3||deviseLocale!="XAF"?510:620,left: gauch, right: droit, bottom: 20),
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          if(isLoading == true){
                          }else{
                            if(_formKey.currentState.validate()){
                              if(_code == "0"){//MTN
                                if(_to.startsWith('67') || _to.startsWith('68') || _to.startsWith('654') || _to.startsWith('653') || _to.startsWith('652') || _to.startsWith('651') || _to.startsWith('650')){
                                  var walletTr = new mtnTrans(
                                      to:'$_to',
                                      amount: int.parse(this.montant),
                                      fees: fees,
                                      description: this.description,
                                      deviseLocale: this.deviseLocale
                                  );
                                  print(json.encode(walletTr));
                                  checkConnection(json.encode(walletTr));
                                }else{
                                  showInSnackBar("Le numéro à débiter n'est pas un compte MTN MoMo valide!", _scaffoldKey);
                                }
                              }else if(_code == "2"){
                                print("******************* je suis la carte");
                                var walletTr = new cardTrans(
                                    to:this._to,
                                    amount: int.parse(this.montant),
                                    fees: fees,
                                    description: this.description,
                                    ipAddress: this._ip,
                                    deviseLocale: this.deviseLocale,
                                    successUrl: "http://www.sprintpay.com",
                                    failureUrl: "http://www.sprintpay.com"
                                );
                                print(json.encode(walletTr));
                                checkConnection(json.encode(walletTr));
                              }else if(_code == "4"){
                                print("******************* je suis YUP");
                                var walletTr = new yupTrans(
                                    amount: int.parse(this.montant),
                                    fees: fees,
                                    description: this.description,
                                    deviseLocale: this.deviseLocale,
                                    successUrl: "http://www.sprintpay.com",
                                    failureUrl: "http://www.sprintpay.com"
                                );
                                print(json.encode(walletTr));
                                checkConnection(json.encode(walletTr));
                              }else{//ORANGE
                                if(_to.startsWith('69') || _to.startsWith('655') || _to.startsWith('656') || _to.startsWith('657') || _to.startsWith('658') || _to.startsWith('659')){
                                  var walletTr = new orangeTrans(
                                      to:this._to,
                                      amount: int.parse(this.montant),
                                      fees: fees,
                                      description: this.description,
                                      deviseLocale: this.deviseLocale,
                                      successUrl: "http://www.sprintpay.com",
                                      failureUrl: "http://www.sprintpay.com"
                                  );
                                  print(json.encode(walletTr));
                                  checkConnection(json.encode(walletTr));
                                }else{
                                  showInSnackBar("Le numéro à débiter n'est pas un compte ORANGE MONEY valide!", _scaffoldKey);
                                }
                              }
                              /*var walletTr = _code == "0"? new walletTrans(
                                to:'$_to',
                                amount: int.parse(this.montant),
                                description: this.description,
                                deviseLocale: this.deviseLocale
                            ):new orangeTrans(
                                to:this._to,
                                amount: int.parse(this.montant),
                                description: this.description,
                                deviseLocale: this.deviseLocale,
                              successUrl: "http://www.sprintpay.com",
                              failureUrl: "http://www.sprintpay.com"
                            );
                            print(json.encode(walletTr));
                            checkConnection(json.encode(walletTr));*/
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
                        child: new Center(child: isLoading==false? new Text('Confirmer la recharge', style: new TextStyle(fontSize: taille_text_bouton+3, color: couleur_text_bouton, fontFamily: police_bouton),):
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


  Widget getMoyen(int index){
    String text, img;
    switch(index){
      case 1: text = "MTN MOBILE MONEY";img = 'images/mtn.jpg';
      break;
      case 2: text = "ORANGE MONEY";img = 'images/orange.png';
      break;
      case 3: text = "CARTE BANCAIRE";img = 'images/carte.jpg';
      break;
      case 4: text = "CASH PAR EXPRESS UNION";img = 'images/eu.png';
      break;
      case 5: text = "YUP";img = 'marketimages/yup.jpg';
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
                      image: AssetImage('$img'),
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
void showInSnackBar(String value, GlobalKey<ScaffoldState> _scaffoldKey) {
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