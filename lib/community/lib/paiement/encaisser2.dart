import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:services/community/lib/confirm.dart';
import 'package:services/community/lib/utils/services.dart';
import 'package:services/composants/components.dart';
import '../echec.dart';
import 'encaisser1.dart';
import 'package:flutter/material.dart';
import '../utils/components.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';


class Encaisser2 extends StatefulWidget {
  Encaisser2(this._code);
  String _code;
  @override
  _Encaisser2State createState() => new _Encaisser2State(_code);
}

class _Encaisser2State extends State<Encaisser2> {
  _Encaisser2State(this._code);
  String _code;

  int recenteLenght, archiveLenght, populaireLenght;
  var _formKey = GlobalKey<FormState>();
  int flex4, flex6, taille, enlev, rest, enlev1, _id, temps = 600;
  double _tail,_taill,gauch, droit, _width, hauteurcouverture, nomright, nomtop, right1, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext, _larg, left1, social, topo, div1, div2, margeleft, margeright;
  File _image;
  List data, list;
  bool _value1 = false, isLoading = false;
  var _userTextController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String currency, urlf, kittyImage,_xaf="XAF", _myselection = "+237",_password, _username, _token, country, _tel, previsional_amount, amount_collected, kittyId, firstnameBenef,particip, endDate, startDate, title, suggested_amount, amount, description, number, nom="", tel="", email="", montant="", mot="";

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
    amount_collected = _code.split('^')[7];
    print("amount_collected: $amount_collected");//amount_collected
    description = _code.split('^')[8];
    number = _code.split('^')[9];
    kittyId = _code.split('^')[10];
    particip = _code.split('^')[11];
    _xaf = _code.split('^')[12];
  }

  @override
  void dispose() {
    _userTextController.dispose();
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
      backgroundColor: GRIS,
      key: _scaffoldKey,
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
                    padding: EdgeInsets.only(top: 200, left: gauch, right: droit),
                    child: Center(
                      child: Text('Encaisser ma cagnotte',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: taille_titre-2,
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
                              top: 300-45.0,
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
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Encaisser1(_code)));
                                //Navigator.of(context).push(SlideLeftRoute(enterWidget: Encaisser1(_code), oldWidget: Encaisser2(_code)));
                              });
                            },
                            child: Icon(Icons.arrow_back_ios,color: Colors.white,)
                        ),
                        InkWell(
                          onTap: (){
                            setState(() {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Encaisser1(_code)));
                              //Navigator.of(context).push(SlideLeftRoute(enterWidget: Encaisser1(_code), oldWidget: Encaisser2(_code)));
                            });
                          },
                          child: Text('Retour',
                            style: TextStyle(color: Colors.white, fontSize: taille_champ),),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 330, left: 20, right: 20),
                    child: Text("Vous êtes sur le point d'encaisser sur votre compte un montant de",
                      style: TextStyle(
                          color: couleur_libelle_champ,
                          fontSize: taille_champ+3,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 380, left: 20, right: 20),
                    child: Text(montant==null?"":'$montant $currency ',
                      style: TextStyle(
                          color: couleur_libelle_etape,
                          fontSize: taille_titre+10,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 430, left: 20, right: 20),
                    child: Text(montant==null?"":' Avec une Commission de: ${double.parse(this.montant.replaceAll(".", ""))*0.05} $currency',
                      style: TextStyle(
                          color: couleur_libelle_etape,
                          fontSize: taille_titre-10,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 470, left: 20, right: 20),
                    child: Text("Montant net à encaisser",
                      style: TextStyle(
                          color: couleur_libelle_champ,
                          fontSize: taille_champ+3,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 500, left: 20, right: 20),
                    child: Text(montant==null?"":'${double.parse(this.montant.replaceAll(".", ""))*0.05+double.parse(this.montant.replaceAll(".", ""))} $currency ',
                      style: TextStyle(
                          color: couleur_libelle_etape,
                          fontSize: taille_titre+5,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  /*Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 520),
                    child: Container(
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
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
                          Expanded(
                              flex: 5,
                              child: CountryCodePicker(
                                showFlag: true,
                                showOnlyCountryWhenClosed: false,
                                showCountryOnly: false,
                                textStyle: TextStyle(
                                    fontSize: taille_champ+3,
                                    color: couleur_libelle_champ
                                ),
                                initialSelection:_myselection,
                                onChanged: (CountryCode code) {
                                  _myselection = code.dialCode.toString();
                                },
                              )
                          ),
                          new Expanded(
                            flex:10,
                            child: new TextFormField(
                              controller: null,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                fontSize: taille_champ+3,
                                color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return "Champ téléphone vide !";
                                }else{
                                  number = value;
                                  //_sername = value;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: "Numéro de téléphone",
                                hintStyle: TextStyle(
                                  fontSize: taille_champ+3,
                                  color: couleur_libelle_champ,
                                ),
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),*/
                  Padding(
                    padding: EdgeInsets.only(top:600,left: 20, right: 20),
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          if(_formKey.currentState.validate()){
                            var cardsp = new OMoMo(
                                amount: int.parse(this.montant.replaceAll(".", "")),
                                country: country,
                                description: description,
                                email: email,
                                fees: double.parse(this.montant.replaceAll(".", ""))*0.05,
                                kittyID: int.parse(kittyId),
                                maskpart: _value1,
                                firstname: "",
                                lastname: nom,
                                to: _username,
                                mobileNumber: _username,
                                failureUrl: "http://www.sprint-pay.com/",
                                successUrl: "http://www.sprint-pay.com/"
                            );
                            print(json.encode(cardsp));
                            checkConnection(json.encode(cardsp));
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
                        child: new Center(child:isLoading == false? new Text('Valider et payer', style: new TextStyle(color: couleur_text_bouton),):
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
      montant = prefs.getString(MONTANT_ENCAISSE);
      email = prefs.getString("email");
      country = prefs.getString("iso3");
      _token = prefs.getString(TOKEN);
      nom = prefs.getString("nom");
      _username = prefs.getString("username");
      _password = prefs.getString("password");
      currency = prefs.getString(CURRENCY);
    });
  }

  void checkConnection(var body) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        isLoading =true;
        getCaisse(body);
      });

    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        isLoading =true;
        getCaisse(body);
      });
    } else {
      showInSnackBar("Service indisponible!", _scaffoldKey, 5);
    }
  }

  Future<String> getCaisse(var body) async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString("username");
    String _password = prefs.getString("password");
    print("$_username, $_password");
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    String url = "$cagnotte_url/cashout/encash";
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
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Echec('$_code^&')));
      //Navigator.of(context).push(SlideLeftRoute(enterWidget: Echec('$_code^&'), oldWidget: Encaisser2('$_code')));
    } else{
      setState(() {
        isLoading = false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Echec('$_code^&')));
    }
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
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Echec('encaisse')));
        }else if(temps > 0){
          temps--;
          getStatus(id);
        }
      }else if(responseJson['status'] == "PROCESSED"){
        setState(() {
          isLoading = false;
        });
        sav();
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Confirm('encaisse')));
      }else if(responseJson['status'] == "REFUSED"){
        setState(() {
          isLoading = false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Echec('encaisse')));
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


  void sav() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(CONFIRMATION, "encaisse");
  }

}