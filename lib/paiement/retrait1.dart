import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:page_transition/page_transition.dart';
import 'package:services/auth/profile.dart';
import 'package:services/composants/components.dart';
import 'package:services/paiement/getsoldewidget.dart';
import 'encaisser2.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'retrait2.dart';


// ignore: must_be_immutable
class Retrait1 extends StatefulWidget {
  Retrait1(this._code);
  String _code;
  @override
  _Retrait1State createState() => new _Retrait1State(_code);
}

class _Retrait1State extends State<Retrait1> {
  _Retrait1State(this._code);
  String _code;
  int currentPage = 0;
  int choice = 0;
  var _userTextController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // ignore: non_constant_identifier_names
  int recenteLenght, archiveLenght, populaireLenght, id_kitty;
  var _formKey = GlobalKey<FormState>();
  int flex4, flex6, taille, enlev, rest, enlev1, indik=0;
  double aj,ajj,_taill,gauch,fees,newSolde, droit, hauteurcouverture, nomright, nomtop, right1, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext, left1, social, topo, div1, div2, margeleft, margeright;
  File _image;
  List data, list;
  Color color;
  bool isLoading = false;
  // ignore: non_constant_identifier_names
  String kittyImage,_username,_to, _mySelection="+237", _password, firstnameBenef,solde,kittyId,remain, particip, previsional_amount,amount_collected, endDate, startDate, title, suggested_amount, amount, description, number, nom="", tel="", email="", montant="", mot="", deviseLocale, local, devise, country;

  @override
  void initState() {
    super.initState();
    this.read();
    _code = "$indik";
    _userTextController = new MoneyMaskedTextController(decimalSeparator: '', thousandSeparator: '.', precision: 0);
//_code = '$index ${_cagnottes[index]["kittyImage"]} ${_cagnottes[index]["firstnameBenef"]} ${_cagnottes[index]["endDate"]} ${_cagnottes[index]["startDate"]} ${_cagnottes[index]["title"]} ${_cagnottes[index]["suggested_amount"]} ${_cagnottes[index]["amount"]} ${_cagnottes[index]["description"]}';
  }

  @override
  void dispose() {
    _userTextController.dispose();
    super.dispose();
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      country = prefs.getString("iso3");
      solde = prefs.getString("solde");
      devise = prefs.getString("devise");
      local = prefs.getString("local");
      deviseLocale = prefs.getString("deviseLocale");
    });
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
        }else if(q == 2){//CARD
          getSoldeCommission(body, q);
        }else{
          isLoading = false;
          showInSnackBar("Service non disponible!");
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
        }else if(q == 2){//CARD
          getSoldeCommission(body, q);
        }else{
          isLoading = false;
          showInSnackBar("Service non disponible!");
        }
      });
      //this.getUser();
    } else {
      _ackAlert(context);
    }
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

  void _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("montant", "${montant.replaceAll(".", "")}");
    prefs.setString("fees", "$fees");
    prefs.setString("to", "$_to");
    prefs.setString("iso", "$_mySelection");
  }

  Future<String> getSoldeCommission(var body, int q) async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString("username");
    _password = prefs.getString("password");
    print("$_username, $_password");
    String fee = "$base_url/transaction/getFeesTransaction";
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    var headers = {
      "Accept": "application/json",
      "Authorization": "Basic $credentials",
      "content-type":"application/json"
    };
    return await http.post("$fee", body: body, headers: headers, encoding: Encoding.getByName("utf-8")).then((http.Response response) {
      final int statusCode = response.statusCode;
      print('voici le statusCode $statusCode');
      print('voici le body ${response.body}');
      if (statusCode < 200 || json == null) {
        setState(() {
          isLoading = false;
        });
        throw new Exception("Error while fetching data");
      }else if(statusCode == 200){
        var responseJson = json.decode(response.body);
        fees = responseJson['fees'];
        newSolde = double.parse(montant)+fees;
        print(newSolde.toString());
        print(double.parse(local));
        this._save();
        setState(() {
          isLoading = false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Retrait2(_code)));
        //navigatorKey.currentState.pushNamed("/encaisser");
      }else {
        setState(() {
          isLoading = false;
        });
        showInSnackBar("$statusCode ${response.body}");
      }
      return response.body;
    });
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
    indik==0||indik==2||indik==1? aj = 120:aj=0;
    indik == 2?ajj=100:ajj=0.0;
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
      _taill = taille_description_champ-3;
      gauch = 20;
      droit = 20;
    }else if(_large>320){
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
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white, accentColor: Color(0xFF2A2A42), fontFamily: 'Poppins'),
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
                                  Navigator.pop(context);
                                  //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Detail('$_code')));
                                  //Navigator.of(context).push(SlideLeftRoute(enterWidget: Detail(_code), oldWidget: Encaisser1(_code)));
                                });
                              },
                              child: Icon(Icons.arrow_back_ios,color: Colors.white,)
                          ),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                //Navigator.pop(context);
                                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Profile('$_code')));
                                //Navigator.of(context).push(SlideLeftRoute(enterWidget: Detail(_code), oldWidget: Encaisser1(_code)));
                              });
                            },
                            child: Text('Retour',
                              style: TextStyle(color: Colors.white, fontSize: taille_champ),),
                          )
                        ],
                      ),
                    ),
                    Center(
                      child: Text('Etape 1 sur 2',
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
                    child: Text('Par quel moyen souhaitez-vous receptionner l\'argent ?',
                      style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_libelle_etape,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 75, left: 0, right: 0),
                    child: CarouselSlider(
                      enlargeCenterPage: true,
                      autoPlay: false,
                      enableInfiniteScroll: true,
                      initialPage: 2,
                      onPageChanged: (value){
                        setState(() {
                          indik = value;
                          _code = "$indik";
                          print(indik);
                        });
                      },
                      height: 136.0,
                      items: [1,2].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return getMoyen(i);
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 240, left: gauch, right: droit),
                    child: Text('Quel est le montant à retirer ?',
                      style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_libelle_etape,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: gauch, right: droit, top: 270),
                    child: Container(
                      margin: EdgeInsets.only(top: 0.0),
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
                                ),
                                validator: (String value){
                                  if(value.isEmpty || int.parse(value.replaceAll(".", ""))==0){
                                    return "Montant vide !";
                                  }else{
                                    montant = value;
                                    _userTextController.text = montant;
                                    return null;
                                  }
                                },
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Montant à retirer',
                                  hintStyle: TextStyle(
                                      color: couleur_libelle_champ,
                                      fontSize: taille_champ+3,
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

                  /* ici hein!*/
                  indik==0||indik==2 ||indik==1?Padding(
                    padding: EdgeInsets.only(top: 230+aj, left: gauch, right: droit),
                    child: Text(getText(indik),
                      style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_libelle_etape,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ):Container(),

                  indik==0||indik==2 ||indik==1?Padding(
                    padding: EdgeInsets.only(left: gauch, right: droit, top: 260+aj),
                    child: Container(
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(indik==0||indik==1?10.0:0),
                          bottomRight: Radius.circular(indik==0||indik==1?10.0:0),
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
                          /*new Expanded(
                            flex:2,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: new Image.asset('images/Groupe18.png'),
                            ),
                          ),*/
                          Expanded(
                              flex: 5,
                              child: Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: CountryCodePicker(
                                  showFlag: true,
                                  onChanged: (CountryCode code){
                                    _mySelection = code.dialCode.toString();
                                  },
                                ),
                              )
                          ),
                          new Expanded(
                            flex:10,
                            child: new TextFormField(
                              //controller: _userTextController,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                fontSize: taille_libelle_champ+3,
                                color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return 'Champ téléphone vide !';
                                }else{
                                  _to = "${_mySelection.substring(1)}$value";
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Numéro de téléphone',
                                hintStyle: TextStyle(
                                  fontSize: taille_libelle_champ+3,
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

                  indik==2?Padding(
                    padding: EdgeInsets.only(left: gauch, right: droit, top: 260+aj+50),
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
                              child: new Image.asset('images/Groupe177.png'),
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
                  indik==2?Padding(
                    padding: EdgeInsets.only(left: gauch, right: droit, top: 260+aj+100),
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
                              child: new Image.asset('images/Groupe177.png'),
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
                    padding: EdgeInsets.only(top:340+aj+ajj,left: gauch, right: droit, bottom: 20),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          _code = '$indik';
                          String code;
                          switch(indik){
                            case 0: code = "WALLET_TO_MOMO";break;
                            case 1: code = "WALLET_TO_OM";break;
                          }
                          if(_formKey.currentState.validate()) {
                            if(_code == "1"){
                              showInSnackBar("Service indisponible");
                            }else{
                              if(_to.startsWith('23767') || _to.startsWith('23768') || _to.startsWith('237654') || _to.startsWith('237653') || _to.startsWith('237652') || _to.startsWith('237651') || _to.startsWith('237650')){
                                var getcommission = getCommission(
                                    typeOperation:code,
                                    country: "$country",
                                    amount: int.parse(this.montant.replaceAll(".", "")),
                                    deviseLocale: deviseLocale
                                );
                                print(json.encode(getcommission));
                                checkConnection(json.encode(getcommission), indik);
                              }else{
                                showInSnackBar("Le numéro du bénéficiaire n'est pas un compte MTN MoMo valide!");
                              }
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
                        child: new Center(child: new Text('Poursuivre', style: new TextStyle(fontSize: taille_text_bouton, color: couleur_text_bouton),),),
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
                height: 85,
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

  String getText(int ind){
    String text;
    switch(ind){
      case 0:text="Téléphone du bénéficiaire";break;
      case 1:text="Téléphone du bénéficiaire";break;
      case 2:text="Coordonnées du bénéficiaire";break;
    }
  return text;
  }
}

