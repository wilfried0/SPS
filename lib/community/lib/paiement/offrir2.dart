import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:services/community/lib/confirm.dart';
import 'package:services/composants/components.dart';
import '../echec.dart';
import 'offrir1.dart';
import 'package:flutter/material.dart';
import '../utils/components.dart';
import '../utils/services.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class Offrir2 extends StatefulWidget {
  Offrir2(this._code);
  String _code;
  @override
  _Offrir2State createState() => new _Offrir2State(_code);
}

class _Offrir2State extends State<Offrir2> {
  _Offrir2State(this._code);
  String _code;

  int choice = 0;
  int recenteLenght, archiveLenght, populaireLenght, id_kitty;
  var _formKey = GlobalKey<FormState>();
  int flex4, flex6, taille, enlev, rest, enlev1, _id, temps = 600;
  double _tail,_taill,gauch, droit, _width, hauteurcouverture, nomright, nomtop, right1, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext, _larg, left1, social, topo, div1, div2, margeleft, margeright;
  File _image;
  List data, list;
  bool isLoading = false;
  var _userTextController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String currency, kittyImage,_xaf,_token,country, previsional_amount,_username, phone, kittyId,particip, amount_collected, firstnameBenef, endDate, startDate, title, suggested_amount, amount, description, number, nom="", tel="", email="", montant="", mot="";
  var _mySelection='+237';

  @override
  void initState() {
    super.initState();
    this.read();
    kittyImage = _code.split('^')[1];
    firstnameBenef = _code.split('^')[2];
    endDate = _code.split('^')[3];
    startDate = _code.split('^')[4];
    title = _code.split('^')[5];
    previsional_amount = _code.split('^')[6]; //previsional_amount
    amount_collected = _code.split('^')[7]; //amount_collected
    description = _code.split('^')[8];
    number = _code.split('^')[9];
    kittyId = _code.split('^')[10];
    particip = _code.split('^')[11];
    //remain = _code.split('^')[13];
    _xaf = _code.split('^')[12];

  }


  @override
  void dispose() {
    _userTextController.dispose();
    super.dispose();
  }

  void _sava(String valeur) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'wallet';
    final value = valeur;
    prefs.setString(key, value);
    prefs.setString("offre", null);
    print('saved $value');
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
      key: _scaffoldKey,
          backgroundColor: GRIS,
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
                color: GRIS,
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
                      child: Text('Etape 3 sur 3',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: taille_libelle_etape,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 200, left: gauch, right: droit),
                    child: Center(
                      child: Text('Offrir ma cagnotte',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: taille_titre,
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
                              top: topphoto,
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
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Offrir1(_code)));
                                //Navigator.of(context).push(SlideLeftRoute(enterWidget: Offrir1(_code), oldWidget: Offrir2(_code)));
                              });
                            },
                            child: Icon(Icons.arrow_back_ios,color: Colors.white,)
                        ),
                        InkWell(
                          onTap: (){
                            setState(() {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Offrir1(_code)));
                              //Navigator.of(context).push(SlideLeftRoute(enterWidget: Offrir1(_code), oldWidget: Offrir2(_code)));
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
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Moyen par lequel votre bénéficiaire recevra les fonds',
                            style: TextStyle(
                                color: couleur_libelle_champ,
                                fontSize: taille_champ+3,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text('Sprint Pay Wallet',
                              style: TextStyle(
                                  color: couleur_libelle_etape,
                                  fontSize: taille_libelle_etape,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Divider(
                            height: 10,
                            color: couleur_decription_page,
                          ),
                        ),
                      ],
                    ),
                  ),


                  Padding(
                    padding: EdgeInsets.only(top: 445, left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Le bénéficiaire',
                          style: TextStyle(
                              color: couleur_libelle_champ,
                              fontSize: taille_champ+3,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("numéro",
                              style: TextStyle(
                                  color: couleur_libelle_etape,
                                  fontSize: taille_libelle_etape,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Divider(
                            height: 10,
                            color: couleur_decription_page,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 525, left: 20, right: 20),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 6,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Frais de la commission',
                                    style: TextStyle(
                                        color: couleur_libelle_champ,
                                        fontSize: taille_champ+3,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: currency==null?Container(): Text('${double.parse(this.montant.replaceAll(".", ""))*0.05}$currency',
                                    style: TextStyle(
                                        color: couleur_libelle_etape,
                                        fontSize: taille_libelle_etape,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Divider(
                            height: 10,
                            color: couleur_decription_page,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 605, left: 20, right: 20),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Votre bénéficiaire recevra',
                            style: TextStyle(
                                color: couleur_libelle_champ,
                                fontSize: taille_champ+3,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 6,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('${double.parse(this.montant.replaceAll(".", ""))}',
                                    style: TextStyle(
                                        color: couleur_libelle_etape,
                                        fontSize: taille_libelle_etape,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text('$currency',
                                    style: TextStyle(
                                        color: couleur_libelle_etape,
                                        fontSize: taille_libelle_etape,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Divider(
                            height: 10,
                            color: couleur_decription_page,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 685, left: 20, right: 20),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Net total à payer',
                            style: TextStyle(
                                color: couleur_libelle_champ,
                                fontSize: taille_champ+3,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 6,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('${double.parse(this.montant.replaceAll(".", ""))*0.05+double.parse(this.montant.replaceAll(".", ""))}',
                                    style: TextStyle(
                                        color: couleur_libelle_etape,
                                        fontSize: taille_libelle_etape,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text('$currency',
                                    style: TextStyle(
                                        color: couleur_libelle_etape,
                                        fontSize: taille_libelle_etape,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Divider(
                            height: 10,
                            color: couleur_decription_page,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top:765,left: 20, right: 20, bottom: 20),
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          if(_formKey.currentState.validate()){
                            var cardsp = new OMoMo(
                                amount: int.parse(montant.replaceAll(".", "")),
                                fees: double.parse(montant.replaceAll(".", ""))*0.05,
                                maskpart: false,
                                to: this.phone,
                                firstname: "",
                                lastname: '$nom',
                                description: this.description,
                                mobileNumber: _username,
                                country: country,
                                email: this.email,
                                failureUrl: 'https://sprint-pay.com/',
                                successUrl: 'https://sprint-pay.com/',
                                kittyID: int.parse(this.kittyId)
                            );
                            print(json.encode(cardsp));
                            checkConnection(json.encode(cardsp));
                            //Navigator.of(context).push(SlideLeftRoute(enterWidget: PassCodeScreen(), oldWidget: Encaisser2(_code)));
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
                        child: new Center(child:isLoading == false? new Text('Confirmer et payer', style: new TextStyle(color: couleur_text_bouton),):
                        Theme(
                            data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.dark)),
                            child: CupertinoActivityIndicator(radius: 20,)),),
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
      montant = prefs.getString(MONTANT_OFFRE)==null?"":prefs.getString(MONTANT_OFFRE);
      phone = prefs.getString(PHONE_OFFRE)==null?"":prefs.getString(PHONE_OFFRE);
      nom = prefs.getString("nom");
      country = prefs.getString(COUNTRY_OFFRE);
      _username = prefs.getString("username");
      _token = prefs.getString(TOKEN);
      currency = prefs.getString(CURRENCY);
      print("!!!!!!!!!!$currency");
    });
  }

  Future<String> getOffre(var body) async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString("username");
    String _password = prefs.getString("password");
    print("$_username, $_password");
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    String url = "$cagnotte_url/cashout/offer";
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse("$url"));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json');
    request.headers.set('Authorization', 'Basic $credentials');
    request.add(utf8.encode(body));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print("body $reply");
    print('voici le statusCode ${response.statusCode}');

    if (response.statusCode < 200 || json == null) {
      setState(() {
        isLoading = false;
      });
      print(response.statusCode);
      throw new Exception("Error while fetching data");
    }else if(response.statusCode == 200){
      setState(() {
        isLoading = false;
      });
      var responseJson = json.decode(reply);
      print(responseJson);
      _id = responseJson['id'];
      getStatus(_id.toString());
    }else if(response.statusCode == 403){
      setState(() {
        isLoading = false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Echec('offre')));
    }
    else Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Echec('offre')));
  return null;
  }

  Future<String> getStatus(String id) async {
    var url = "$checkPayUrl/payment/status/$id";
    print(url);
    print("Mon token :$_token");
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json');
    request.headers.set('Authorization', 'Bearer $_token');//"Authorization": "Bearer $_token"
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
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Echec('offre')));
        }else if(temps > 0){
          temps--;
          getStatus(id);
        }
      }else if(responseJson['status'] == "PROCESSED"){
        setState(() {
          isLoading = false;
        });
        save();
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Confirm('offre')));
      }else if(responseJson['status'] == "REFUSED"){
        setState(() {
          isLoading = false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Echec('offre')));
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

  void checkConnection(var body) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        isLoading =true;
        getOffre(body);
      });

    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        isLoading =true;
        getOffre(body);
      });
    } else {
      showInSnackBar("Service indisponible!", _scaffoldKey, 5);
    }
  }
}