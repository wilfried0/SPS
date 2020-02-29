import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:services/auth/connexion.dart';
import 'package:services/composants/components.dart';
import 'package:services/marketplace/lib/Home.dart';
import 'package:services/monprofile.dart';
import 'package:services/paiement/encaisser1.dart';
import 'package:services/paiement/historique.dart';
import 'package:services/paiement/payst.dart';
import 'package:services/paiement/retrait1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'inscription1.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';


// ignore: must_be_immutable
class Profile extends StatefulWidget {
  Profile(this._code);
  String _code;
  @override
  _ProfileState createState() => new _ProfileState(_code);
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  _ProfileState(this._code);
  String _code;
  PageController pageController;
  int currentPage = 0, choix;
  String solde,urlPath = "", local, idUser, userImage, _pathImage, _nom, _ville, _quartier, _pays, _username, _password, deviseLocale, devise;
  bool isLoding = false, loadImage = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int recenteLenght = 3, archiveLenght = 3, populaireLenght =3, nb, nbNotif = 0;
  int flex4, flex6, taille, enlev, rest, enlev1, enl;
  double haut,ad, _taill,topi, bottomsolde,sold,topo22,top33, top34, top1, top, top2, top3,top4, topo1, topo2, hauteurcouverture, nomright, nomtop, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext;
  final navigatorKey = GlobalKey<NavigatorState>();
  String smsCode, mesNotif;
  List<String> listSms;

  @override
  void initState(){
    //print("************** "+MediaQuery.of(context).size.width.toString()+" **********");
    super.initState();
    //lireNotif();
    this.lire();
    this.getSolde();
  }

  void reg() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('notif', null);
  }

  void save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('BALANCE', local);
    print("saved: $local");
  }

  Future<void> _ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: ListView.builder(
              itemCount: listSms == null?0:listSms.length,
              itemBuilder: (BuildContext context, int i){
                String sms = listSms[i];
                return AlertDialog(
                  title:i == 0? Center(child: Column(
                    children: <Widget>[
                      Text("Notifications"),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Divider(color: Colors.black,
                          height: 5,),
                      )
                    ],
                  )):Container(),
                  content: Padding(
                    padding: EdgeInsets.only(top:i == 0? 20:0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text("$sms",style: TextStyle(
                          color: Colors.black,
                          fontSize: taille_champ+3
                        ),textAlign: TextAlign.justify,),
                        i==listSms.length-1?Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                listSms = null;
                                nbNotif = 0;
                                mesNotif = null;
                                this.reg();
                              });
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              height: hauteur_champ,
                              width: MediaQuery.of(context).size.width - 40,
                              decoration: new BoxDecoration(
                                color: couleur_fond_bouton,
                                border: new Border.all(
                                  color: Colors.transparent,
                                  width: 0.0,
                                ),
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              child: new Center(
                                  child: new Text('Valider', style: new TextStyle(fontSize: taille_champ+3, color: couleur_text_bouton),)
                              ),
                            ),
                          ),
                        ):Container(),
                      ],
                    ),
                  ),
                );
              }
            ),
        );
      },
    );
  }

  Future<File> getPdfFromUrl(String url) async {
    try{
      var data = await http.get(url);
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/sprintpayconditions.pdf");

      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    }catch(e){
      throw Exception("Erreur lors de l'ouverture du fichier");
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

  lire() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pays = prefs.getString("pays");
      _nom = prefs.getString("nom");
      _ville = prefs.getString("ville");
      _quartier = prefs.getString("quartier");
      _pathImage = prefs.getString("avatar");
      print("mon avatar: $_pathImage");
    });
  }

  Future<void> getSolde() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString("username");
    _password = prefs.getString("password");
    String sold = "$base_url/transaction/getSoldeUser";
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    var headers = {
      "Accept": "application/json",
      "Authorization": "Basic $credentials"
    };
    var response = await http.get(Uri.encodeFull(sold), headers: headers,);
    if(response.statusCode == 200){
      print(response.body);
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        solde = "${responseJson['amount']}";
        devise = " ${responseJson['devise']}";
        local = "${responseJson['amountLocale']}";
        deviseLocale = "${responseJson['deviseLocale']}";
        this._reg();
      });
    } else{
      showInSnackBar(json. decode(utf8.decode(response.bodyBytes)));
    }
  }

  void _reg() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('solde', "$solde");
    prefs.setString('devise', "$devise");
    prefs.setString('local', "$local");
    prefs.setString('deviseLocale', "$deviseLocale");
    print("Mon solde $solde");
  }

  lireNotif() async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getString("notif")!=null && prefs.getString("notif")!= "null")
      prefs.getString("notif") != "null" && prefs.getString("notif") != null?mesNotif = prefs.getString("notif"):mesNotif=null;

    if(mesNotif == null){
      nbNotif = 0;
    }else{
      listSms = mesNotif.split("^");
      nbNotif = listSms.length;
    }
  }
  @override
  void dispose() {
    super.dispose();
    //BackButtonInterceptor.remove(myInterceptor);
  }


  @override
  Widget build(BuildContext context) {
    lireNotif();
    final _large = MediaQuery.of(context).size.width;
    final _haut = MediaQuery.of(context).size.height;
    double ad=100;
    if(_large<=320){
      bottomsolde = 400;
      sold = 330;
      _taill = taille_description_champ-2;
      top1 = 65+ad;
      top = 100;
      topo1 = 133;
      top2 = 142+ad;
      top3 = 297;
      top4 = 220+ad;
      top33 = 211;
      topo2 = 70;
      topo22 = 100;
      top34 = 288;
      haut=5;
      topi = 2;
      enl = 2;
      ad = 3;
    }else if(_large>320 && _large<=360 && _haut==738){
      bottomsolde = 400;
      sold = 330;
      _taill = taille_description_champ-1;
      top1 = 75+ad;
      top = 100;
      topo1 = 172;
      top2 = 190+ad;
      top3 = 410;
      top4 = 300+ad;
      top33 = 285;
      top34 = 395;
      topo2 = 90;
      topo22 = 100;
      haut=20;
      topi = 2;
      enl = 2;
      ad = 3;
    }else if(_large>320 && _large<=360){
      bottomsolde = 400;
      sold = 330;
      _taill = taille_description_champ-1;
      top1 = 75+ad;
      top = 100;
      topo1 = 155;
      top2 = 165+ad;
      top3 = 345;
      top4 = 255+ad;
      top33 = 245;
      top34 = 335;
      topo2 = 80;
      topo22 = 100;
      haut=10;
      topi = 2;
      enl = 2;
      ad = 3;
    }else if(_large == 375.0){
      bottomsolde = 400;
      sold = 330;
      _taill = taille_description_champ;
      top1 = 75+ad;
      top = 100;
      topo1 = 172;
      top2 = 190+ad;
      top3 = 410;
      top4 = 300+ad;
      top33 = 285;
      top34 = 395;
      topo2 = 90;
      topo22 = 100;
      haut=20;
      topi = 0;
      enl = 2;
      ad = 0;
    }else if(_large>360){
      bottomsolde = 400;
      sold = 330;
      _taill = taille_description_champ;
      top1 = 75+ad;
      top = 100;
      topo1 = 172;
      top2 = 190+ad;
      top3 = 410;
      top4 = 300+ad;
      top33 = 285;
      top34 = 395;
      topo2 = 90;
      topo22 = 100;
      haut=20;
      topi = 0;
      enl = 2;
      ad = 3;
    }else if(_large>411 && _large<412){
      bottomsolde = 400;
      sold = 330;
      _taill = taille_description_champ;
      top1 = 75+ad;
      top = 100;
      topo1 = 172;
      top2 = 190+ad;
      top3 = 410;
      top4 = 300+ad;
      top33 = 285;
      top34 = 395;
      topo2 = 90;
      topo22 = 100;
      haut=20;
      topi = 2;
      enl = 2;
      ad = 3;
    }


    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white, accentColor: Color(0xFF2A2A42), fontFamily: 'Poppins'),
      home: new Scaffold(
        key: _scaffoldKey,
        backgroundColor: bleu_F,
        appBar: new AppBar(
          backgroundColor: bleu_F,
          elevation: 0.0,
          title: Padding(
            padding: EdgeInsets.only(top: 22),
            child: Column(
              children: <Widget>[
                Text(_nom==null?"":"$_nom", style: TextStyle(
                    color: Colors.white,
                    fontSize: taille_champ
                ),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _quartier=="null" && _ville=="null" && _pays=="null"?Container():Icon(Icons.location_on,color: orange_F,size: 15,),
                    Row(
                      children: <Widget>[
                        Text(_quartier=="null"?"":" $_quartier -", style: TextStyle(
                            color: orange_F,
                            fontSize: taille_champ-2
                        ),),
                        Text(_ville=="null"?"":" $_ville -", style: TextStyle(
                            color: orange_F,
                            fontSize: taille_champ-2
                        ),),
                        Text(_pays=="null"?"":" $_pays", style: TextStyle(
                            color: orange_F,
                            fontSize: taille_champ-2
                        ),),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  this.lire();
                  getMonSolde(_scaffoldKey, _username, _password);
                  //deviseLocale=="EUR"?deviseLocale="XAF":deviseLocale="EUR";
                });
              },
              child: GestureDetector(
                onTap: (){
                  if(nbNotif == 0){
                    showInSnackBar("Aucune notification enregistrée");
                  }else
                  this._ackAlert(context);
                },
                child: Stack(
                  children: <Widget>[
                    nbNotif==0?Container():Padding(
                      padding: EdgeInsets.only(bottom: 23, left: 3.5),
                      child: Container(
                        width: 18,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: nbNotif==0?8:10, top: 8),
                      child: Text(nbNotif.toString(),style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20,top: 20),
                      child: Icon(Icons.email,color: orange_F),
                    ),
                  ],
                ),
              ),
            ),
          ],
          iconTheme: new IconThemeData(color: Colors.white),
        ),
        drawer: _drawer(context, _scaffoldKey),
        body: Container(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: (MediaQuery.of(context).size.width/2)-50, right: (MediaQuery.of(context).size.width/2)-50,top: 10),
                child: SizedBox(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: _pathImage==null || _pathImage=="null"? AssetImage("images/ellipse1.png"):NetworkImage(_pathImage), //AssetImage("images/ellipse1.png"),
                            fit: BoxFit.cover
                        )
                    ),
                    child:_pathImage==null || _pathImage=="null"?Container(): Image.network(_pathImage, fit: BoxFit.contain,
                        loadingBuilder: (BuildContext ctx, Widget child, ImageChunkEvent loadingProgress){
                          if (loadingProgress == null) return Container();
                          return Center(
                            child: CircularProgressIndicator(backgroundColor: orange_F,
                              value: loadingProgress.expectedTotalBytes != null ?
                              loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                  : null,
                            ),
                          );
                        }
                    ),
                  ),
                ),
              ),
              deviseLocale == null?Padding(
                padding: EdgeInsets.only(top: 110, ),
                child: Center(
                  child: Theme(
                      data: Theme.of(context).copyWith(accentColor: orange_F),
                      child: CupertinoActivityIndicator(radius: 20)),
                ),
              ):Padding(
                padding: EdgeInsets.only(top: 110, ),//solde du compte
                child:deviseLocale=='EUR'? Column(
                  children: <Widget>[
                    Text('SOLDE', style: TextStyle(
                        color: Colors.white,
                        fontSize: taille_libelle_etape,
                        fontWeight: FontWeight.bold
                    ),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(solde==null?"0,0":"${getMillis('$solde')}", style: TextStyle(//Montant du solde
                            color: orange_F,
                            fontSize: taille_titre-5,
                            fontWeight: FontWeight.bold
                        ),),
                        Text(devise==null?" EUR":" $devise", style: TextStyle(//Montant du solde
                            color: orange_F,
                            fontSize: taille_titre-5,
                            fontWeight: FontWeight.bold
                        ),),
                      ],
                    ),
                  ],
                )
                    :Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: Column(
                        children: <Widget>[
                          Text('SOLDE', style: TextStyle(
                              color: Colors.white,
                              fontSize: taille_libelle_etape,
                            fontWeight: FontWeight.bold
                          ),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(solde==null?"0,0":"${getMillis('$solde')}", style: TextStyle(//Montant du solde
                                  color: orange_F,
                                  fontSize: taille_titre-5,
                                  fontWeight: FontWeight.bold
                              ),),
                              Text(devise==null?" EUR":" $devise", style: TextStyle(//Montant du solde
                                  color: orange_F,
                                  fontSize: taille_titre-5,
                                  fontWeight: FontWeight.bold
                              ),),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      flex: 6,
                      child: Column(
                        children: <Widget>[
                          Text('MONNAIE LOCALE', style: TextStyle(
                              color: Colors.white,
                              fontSize: taille_libelle_etape,
                              fontWeight: FontWeight.bold
                          ),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(local==null?"0,0":getMillis('$local'), style: TextStyle(//Montant du solde
                                  color: orange_F,
                                  fontSize: taille_titre-5,
                                  fontWeight: FontWeight.bold
                              ),),
                              Text(deviseLocale==null?" XAF":" $deviseLocale", style: TextStyle(//Montant du solde
                                  color: orange_F,
                                  fontSize: taille_titre-5,
                                  fontWeight: FontWeight.bold
                              ),),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 200),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: new EdgeInsets.only(top: top1, right: 20.0, left: 20.0),
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          height: topo2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                            ),
                            border: Border.all(
                                color: bleu_F
                            ),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: haut),
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Encaisser1('$_code')));
                                });
                              },
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      height: 50,
                                      width: 50,
                                      child: new Image.asset('images/growth.png')),
                                  Text('Recharger mon compte',
                                    style: TextStyle(
                                        color: couleur_libelle_etape,
                                        fontSize: _taill,
                                        fontWeight: FontWeight.bold
                                    ),)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: new EdgeInsets.only(top:top1, right: 20.0, left: 20.0),
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          height: topo2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                            ),
                            border: Border.all(
                                color: bleu_F
                            ),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: haut),
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  deviseLocale != "XAF"?showInSnackBar("Service pas encore disponible pour le pays $_pays"):
                                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Retrait1('$_code')));
                                });
                              },
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      height: 50,
                                      width: 50,
                                      child: new Image.asset('images/hand.png')),
                                  Text('Faire un retrait',
                                    style: TextStyle(
                                        color: couleur_libelle_etape,
                                        fontSize: _taill,
                                        fontWeight: FontWeight.bold
                                    ),)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              /*Padding(
                 padding: EdgeInsets.only(top: topo1, left: 20, right: 20),
                 child: Divider(
                   color:bleu_F,
                   height: 10,
                 ),
               ),*/

              Row(
                children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: new EdgeInsets.only(top:top2, right: 20.0, left: 20.0),
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          height: topo2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                            ),
                            border: Border.all(
                                color: bleu_F
                            ),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: haut),
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Historique(_code)));
                                });
                              },
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      height: 50,
                                      width: 50,
                                      child: new Image.asset('images/exchange.png')),
                                  Text('Mes transactions',
                                    style: TextStyle(
                                        color: couleur_libelle_etape,
                                        fontSize: _taill,
                                        fontWeight: FontWeight.bold
                                    ),)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: new EdgeInsets.only(top:top2, right: 20.0, left: 20.0),
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          height: topo2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                            ),
                            border: Border.all(
                                color: bleu_F
                            ),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: haut),
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Payst()));
                                  //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Profile('')));
                                });
                              },
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      height: 50,
                                      width: 50,
                                      child: new Image.asset('images/payment-method.png')),
                                  Text('Transfert d\'argent',
                                    style: TextStyle(
                                        color: couleur_libelle_etape,
                                        fontSize: _taill,
                                        fontWeight: FontWeight.bold
                                    ),)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              /*Padding(
                 padding: EdgeInsets.only(top: top33, left: 20, right: 20),
                 child: Divider(
                   color:bleu_F,
                   height: 10,
                 ),
               ),*/

              Row(
                children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: new EdgeInsets.only(top: top4, right: 20.0, left: 20.0),
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          height: topo2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                            ),
                            border: Border.all(
                                color: bleu_F
                            ),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: haut),
                            child: GestureDetector(
                              onTap: (){
                                showInSnackBar("Pas encore disponible.");
                              },
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      height: 50,
                                      width: 100,
                                      child: new Image.asset('images/logo_sprint.png')),
                                  Text("Community",
                                    style: TextStyle(
                                        color: couleur_libelle_etape,
                                        fontSize: _taill,
                                        fontWeight: FontWeight.bold
                                    ),)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: new EdgeInsets.only(top:top4, right: 20.0, left: 20.0),
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          height: topo2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                            ),
                            border: Border.all(
                                color: bleu_F
                            ),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: haut),
                            child: GestureDetector(
                              onTap: () {
                                this.save();
                                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Home()));
                              },
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      height: 50,
                                      width: 100,
                                      child: new Icon(Icons.add_shopping_cart, color: couleur_fond_bouton,size: 50,)),//Image.asset('images/ellipse1.png')),
                                  Text('MarketPlace',
                                    style: TextStyle(
                                        color: couleur_libelle_etape,
                                        fontSize: _taill,
                                        fontWeight: FontWeight.bold
                                    ),)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              /*Padding(
                 padding: EdgeInsets.only(top: top33, left: 20, right: 20),
                 child: Divider(
                   color:bleu_F,
                   height: 10,
                 ),
               ),


               Row(
                 children: <Widget>[
                   Expanded(
                     flex: 6,
                     child: Padding(
                       padding: new EdgeInsets.only(top: top4, right: 20.0, left: 20.0),
                       child: Container(
                         height: topo2,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.only(
                             topLeft: Radius.circular(10.0),
                             topRight: Radius.circular(10.0),
                             bottomRight: Radius.circular(10.0),
                             bottomLeft: Radius.circular(10.0),
                           ),
                           border: Border.all(
                               color: bleu_F
                           ),
                           color: Colors.white,
                         ),
                         child: Padding(
                           padding: EdgeInsets.only(top: haut),
                           child: GestureDetector(
                             onTap: (){
                               setState(() {
                                 print("Apropos");
                               });
                             },
                             child: Column(
                               children: <Widget>[
                                 Container(
                                     height: 50,
                                     width: 50,
                                     child: new Image.asset('images/Groupe12.png')),
                                 Text('Achat de crédit',
                                   style: TextStyle(
                                       color: couleur_libelle_etape,
                                       fontSize: _taill,
                                       fontWeight: FontWeight.bold
                                   ),)
                               ],
                             ),
                           ),
                         ),
                       ),
                     ),
                   ),
                   Expanded(
                     flex: 6,
                     child: Padding(
                       padding: new EdgeInsets.only(top: top4, right: 20.0, left: 20.0),
                       child: Container(
                         height: topo2,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.only(
                             topLeft: Radius.circular(10.0),
                             topRight: Radius.circular(10.0),
                             bottomRight: Radius.circular(10.0),
                             bottomLeft: Radius.circular(10.0),
                           ),
                           border: Border.all(
                               color: bleu_F
                           ),
                           color: Colors.white,
                         ),
                         child: Padding(
                           padding: EdgeInsets.only(top: haut),
                           child: GestureDetector(
                             onTap: (){
                               setState(() {
                                 print("Apropos");
                               });
                             },
                             child: Column(
                               children: <Widget>[
                                 Container(
                                     height: 50,
                                     width: 50,
                                     child: new Image.asset('images/Groupe15.png')),
                                 Text('Localiser un agent',
                                   style: TextStyle(
                                       color: couleur_libelle_etape,
                                       fontSize: _taill,
                                       fontWeight: FontWeight.bold
                                   ),)
                               ],
                             ),
                           ),
                         ),
                       ),
                     ),
                   ),
                 ],
               ),
               Padding(
                 padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/2-5, top: top),
                 child: VerticalDivider(
                   color:bleu_F,
                   width: 10,
                 ),
               )*/
            ],
          ),
        ),
        bottomNavigationBar: bottomNavigate(context, enl, _scaffoldKey),
      ),
    );
  }

  _drawer(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey){
    return new Drawer(
      child: new ListView(
        padding: EdgeInsets.zero,
        children: <Widget> [
          DrawerHeader(
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Sprint-Pay', style: TextStyle(
                    color: Colors.white,
                    fontSize: taille_libelle_etape),),
                SizedBox(
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: _pathImage==null || _pathImage=="null"? AssetImage("images/ellipse1.png"):NetworkImage(_pathImage),
                            fit: BoxFit.cover
                        )
                    ),
                  ),
                ),
                Text(_nom==null?"":"$_nom", style: TextStyle(
                    color: Colors.white,
                    fontSize: taille_champ
                ),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _quartier=="null" && _ville=="null" && _pays=="null"?Container():Icon(Icons.location_on,color: Colors.white,size: 15,),
                    Row(
                      children: <Widget>[
                        Text(_quartier=="null"?"":" $_quartier -", style: TextStyle(
                            color: Colors.white,
                            fontSize: taille_champ-2
                        ),),
                        Text(_ville=="null"?"":" $_ville -", style: TextStyle(
                            color: Colors.white,
                            fontSize: taille_champ-2
                        ),),
                        Text(_pays=="null"?"":" $_pays", style: TextStyle(
                            color: Colors.white,
                            fontSize: taille_champ-2
                        ),),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            decoration: BoxDecoration(
                color: orange_F
            ),
          ),
          new ListTile(
            title: Padding(
              padding: EdgeInsets.only(left: 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex:1,
                      child: Icon(Icons.account_box, color: couleur_fond_bouton,)),//Image.asset("images/Groupe12.png")),
                  Expanded(
                    flex:11,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: new Text('Mon profil',style: TextStyle(
                          color: couleur_fond_bouton,
                          fontWeight: FontWeight.bold,
                          fontFamily: police_titre
                      ),),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Monprofile()));
            },
          ),

          Padding(
            padding: EdgeInsets.only(left: 20),
            child: new Divider(
              color: couleur_champ,
            ),
          ),


          new ListTile(
            title: Padding(
              padding: EdgeInsets.only(left: 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex:1,
                    child: Icon(Icons.shopping_cart, color: couleur_fond_bouton,),//Image.asset("images/ic_conditions.png")
                  ),
                  Expanded(
                    flex:11,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: new Text('Recharger mon compte',style: TextStyle(
                          color: couleur_fond_bouton,
                          fontWeight: FontWeight.bold,
                          fontFamily: police_titre
                      ),),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Encaisser1(_code)));
            },
          ),

          Padding(
            padding: EdgeInsets.only(left: 20),
            child: new Divider(
              color: couleur_champ,
            ),
          ),

          new ListTile(
            title: Padding(
              padding: EdgeInsets.only(left: 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex:1,
                    child: Icon(Icons.remove_shopping_cart, color: couleur_fond_bouton,),//Image.asset("images/ic_conditions.png")
                  ),
                  Expanded(
                    flex:11,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: new Text('Faire un retrait',style: TextStyle(
                          color: couleur_fond_bouton,
                          fontWeight: FontWeight.bold,
                          fontFamily: police_titre
                      ),),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              deviseLocale != "XAF"?showInSnackBar("Service pas encore disponible pour le pays $_pays"):
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Retrait1(_code)));
            },
          ),

          Padding(
            padding: EdgeInsets.only(left: 20),
            child: new Divider(
              color: couleur_champ,
            ),
          ),

          new ListTile(
            title: Padding(
              padding: EdgeInsets.only(left: 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex:1,
                    child: Icon(Icons.euro_symbol, color: couleur_fond_bouton,),//Image.asset("images/ic_conditions.png")
                  ),
                  Expanded(
                    flex:11,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: new Text('Transfert d\'argent',style: TextStyle(
                          color: couleur_fond_bouton,
                          fontWeight: FontWeight.bold,
                          fontFamily: police_titre
                      ),),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Payst()));
            },
          ),

          Padding(
            padding: EdgeInsets.only(left: 20),
            child: new Divider(
              color: couleur_champ,
            ),
          ),

          new ListTile(
            title: Padding(
              padding: EdgeInsets.only(left: 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex:1,
                    child: Icon(Icons.monetization_on, color: couleur_fond_bouton,),//Image.asset("images/ic_conditions.png")
                  ),
                  Expanded(
                    flex:11,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: new Text('Mes transactions',style: TextStyle(
                          color: couleur_fond_bouton,
                          fontWeight: FontWeight.bold,
                          fontFamily: police_titre
                      ),),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Historique(_code)));
            },
          ),

          Padding(
            padding: EdgeInsets.only(left: 20),
            child: new Divider(
              color: couleur_champ,
            ),
          ),

          new ListTile(
            title: Padding(
              padding: EdgeInsets.only(left: 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex:1,
                    child: Icon(Icons.add_shopping_cart, color: couleur_fond_bouton,),//Image.asset("images/ic_conditions.png")
                  ),
                  Expanded(
                    flex:11,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: new Text('Marketplace',style: TextStyle(
                          color: couleur_fond_bouton,
                          fontWeight: FontWeight.bold,
                          fontFamily: police_titre
                      ),),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              this.save();
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Home()));
            },
          ),

          Padding(
            padding: EdgeInsets.only(left: 20),
            child: new Divider(
              color: couleur_champ,
            ),
          ),

          new ListTile(
            title: Padding(
              padding: EdgeInsets.only(left: 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex:1,
                    child: Icon(Icons.language, color: couleur_fond_bouton,),//Image.asset("images/ic_conditions.png")
                  ),
                  Expanded(
                    flex:11,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: new Text('Community',style: TextStyle(
                          color: couleur_fond_bouton,
                          fontWeight: FontWeight.bold,
                          fontFamily: police_titre
                      ),),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              scaffoldKey.currentState.openEndDrawer();
              showInSnackBar("Service pas encore disponible");
              //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Payst()));
            },
          ),

          Padding(
            padding: EdgeInsets.only(left: 20),
            child: new Divider(
              color: couleur_champ,
            ),
          ),

          new ListTile(
            title: Padding(
              padding: EdgeInsets.only(left: 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex:1,
                    child: Icon(Icons.g_translate, color: couleur_fond_bouton,),//Image.asset("images/ic_conditions.png")
                  ),
                  Expanded(
                    flex:11,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: new Text('Changer de langue',style: TextStyle(
                          color: couleur_fond_bouton,
                          fontWeight: FontWeight.bold,
                          fontFamily: police_titre
                      ),),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              scaffoldKey.currentState.openEndDrawer();
              showInSnackBar("Service pas encore disponible");
            },
          ),

          Padding(
            padding: EdgeInsets.only(left: 20),
            child: new Divider(
              color: couleur_champ,
            ),
          ),

          new ListTile(
            title: Padding(
              padding: EdgeInsets.only(left: 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex:1,
                    child: Icon(Icons.description, color: couleur_fond_bouton,),//Image.asset("images/ic_conditions.png")
                  ),
                  Expanded(
                    flex:11,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: new Text('Conditions & politiques',style: TextStyle(
                          color: couleur_fond_bouton,
                          fontWeight: FontWeight.bold,
                          fontFamily: police_titre
                      ),),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              setState(() {
                getPdfFromUrl("https://sprint-pay.com/wp-content/uploads/2018/11/CGU-Afrique-CEMAC-%E2%80%93-Sprint-Pay-2018.pdf").then((f) {
                  setState(() {
                    urlPath = f.path;
                    print(urlPath);
                  });
                });
              });
              Navigator.push(context, PageTransition(type: PageTransitionType.fade,
                  child: PdfViewPage(path: urlPath,))
              );
              //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Payst()));
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: new Divider(
              color: couleur_champ,
            ),
          ),

          new ListTile(
            title: Padding(
              padding: EdgeInsets.only(left: 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex:1,
                    child: Icon(Icons.lock, color: couleur_fond_bouton,),//Image.asset("images/ic_conditions.png")
                  ),
                  Expanded(
                    flex:11,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: new Text('Déconnexion',style: TextStyle(
                          color: couleur_fond_bouton,
                          fontWeight: FontWeight.bold,
                          fontFamily: police_titre
                      ),),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(context, PageTransition(type: PageTransitionType.fade,
                  child: Connexion())
              );
            },
          ),

          Padding(
            padding: EdgeInsets.only(left: 20),
            child: new Divider(
              color: couleur_champ,
            ),
          ),
        ],
      ),
    );
  }
}
