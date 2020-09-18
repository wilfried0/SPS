import 'dart:convert';
import 'package:services/community/lib/utils/services.dart';
import 'package:services/composants/components.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../getDrawerContent.dart';
import 'package:flutter/material.dart';
import '../utils/components.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'adherants.dart';
import 'listemembres.dart';
import 'tontine.dart';

class DetailTontine extends StatefulWidget {
  DetailTontine(this._code);
  String _code;
  @override
  _DetailTontineState createState() => new _DetailTontineState(_code);
}

class _DetailTontineState extends State<DetailTontine> {
  _DetailTontineState(this._code);
  String _code;
  final _url = '$base_url/kitty/all/desc';
  PageController pageController;
  int currentPage = 0;
  String _token;
  int recenteLenght, archiveLenght, populaireLenght, choice = -1;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int flex4,roundId, flex6, taille, enlev, rest, enlev1, xval, titre, tai, choix;
  double _tail,_taill,haut, _width, hauteurcouverture, nomright, nomtop, right1, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext, _larg, left1, social, topo, div1, div2, margeleft, margeright;
  List<String> listtontine = new List<String>();
  List<String> invitations = new List<String>();
  bool isLoding=false;
  var _formKey2 = GlobalKey<FormState>();
  String nom, owner, _username, _password, description, montant, periode, retard, nextCash, startDate, avatar, currency, id, email, name, country;
  //String kittyImage,currency, firstnameBenef,remain,title, endDate, previsional_amount, amount_collected, number, particip, kittyId;

  @override
  void initState() {
    super.initState();
    this.lecture();
  }

  lecture() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      print("la valeur de tite $titre");
      choix = int.parse(prefs.getString(CHOIX));
      avatar = prefs.getString(AVATAR_X);
      nom = prefs.getString(NOM_TONTINE_X);
      id = prefs.getString(ID_TONTINE_X);
      owner = prefs.getString(OWNER_USER_TONTINE);
      this.getUserByPhone(owner);
      description = prefs.getString(DESCRIPTION_TONTINE_x);
      montant = prefs.getString(MONTANT_TONTINE_x);
      periode = prefs.getString(PARTICIP_DURATION_TONTINE_X);
      retard = prefs.getString(DELAYTIMES_TONTINE);
      nextCash = prefs.getString(NEXT_CASH_ORDER_TONTINE);
      startDate = prefs.getString(STARTDATE_TONTINE_X);
      listtontine = prefs.getStringList(PARTICIPANTS_X);
      choix = int.parse(prefs.getString(CHOIX));
      roundId = int.parse(prefs.getString(ID_TONTINE_X));
      _token = prefs.getString(TOKEN);
      currency = prefs.getString(CURRENCY);
      _username = prefs.getString("username");
      _password = prefs.getString("password");
    });
  }


  Future<void> getUserByPhone(String phone) async {
    print("le phone vaut: $phone");
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.getUrl(Uri.parse("$base_url/transaction/getUserByUsername/$phone"));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print("statusCode ${response.statusCode}");
    print("body $reply");
    if(reply.isEmpty){
      setState(() {
        name = "";
        email = "";
      });
    }else{
      if(response.statusCode == 200){
        var responseJson = json.decode(reply);
        if(responseJson['firstname']==null && responseJson['lastname']==null){
          setState(() {
            name = "";
            country = "";
          });
        }else if(responseJson['firstname']!=null && responseJson['lastname']==null){
          setState(() {
            name = responseJson['firstname'];
            email = responseJson['email'];
          });
        }else if(responseJson['firstname']!=null && responseJson['lastname']!=null){
          setState(() {
            name = "${responseJson['firstname'] +' '+ responseJson['lastname']}";
            email = responseJson['email'];
          });
        }else if(responseJson['firstname']==null && responseJson['lastname']!=null){
          setState(() {
            name = responseJson['lastname'];
            email = responseJson['email'];
          });
        }
      }else{
        showInSnackBar("Une erreur est survenue lors de la récupération des informations de l'organisateur", _scaffoldKey, 5);
      }
    }
  }




  @override
  void dispose() {
    //_tabController.dispose();
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
      _larg = 45;
      enlev1 = 243;
      right1 = 120;
      left1 = 0;
      social = 25;
      topo = 480;
      div1 = 410;
      margeleft = 11.5;
      margeright = 11;
      _tail = taille_description_champ-1;
      _taill = taille_description_champ-3;
      haut = 75;
      xval = 2;
      titre = 45;
      tai = 25;
    }else if(_large>320 && _large<=360){
      left1 = 0;
      right1 = 150;
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
      _larg = 55;
      enlev1 = 260;
      social = 30;
      topo = 480;
      div1 = 410;
      margeleft = 12.5;
      margeright = 12.5;
      _tail = taille_description_champ-1;
      _taill = taille_description_champ-1;
      haut=75;
      xval = 0;
      titre = 45;
      tai = 25;
    }else if(_large == 375){
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
      _larg = 55;
      enlev1 = 260;
      social = 30;
      topo = 480;
      div1 = 410;
      margeleft = 13;
      margeright = 13;
      _tail = taille_description_champ;
      _taill = taille_description_champ;
      haut = 75;
      xval = 0;
      titre = 45;
      tai = 40;
    }else if(_large>360){
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
      _larg = 55;
      enlev1 = 260;
      social = 30;
      topo = 480;
      div1 = 410;
      margeleft = 14.5;
      margeright = 14.5;
      _tail = taille_description_champ;
      _taill = taille_description_champ;
      haut = 75;
      xval = 0;
      titre = 45;
      tai = 25;
    }
    return WillPopScope(
      // ignore: missing_return
      onWillPop: (){
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Tontine('')));
      },
      child: new Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: getDrawerContent(),
        ),
        endDrawer: getDrawerContent(),
        body: _buildCarousel(context),
        bottomNavigationBar: bottomNavigation(context, _scaffoldKey,  choix, _token),
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
            child: Stack(
              children: <Widget>[
                Container(
                  height: hauteurcouverture,
                  decoration: BoxDecoration(
                      /*gradient: LinearGradient(
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          colors: [
                            bleu_F,
                            Colors.white,
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
                          image: avatar!=null? NetworkImage(avatar):NetworkImage("images/cover.jpg"),
                          fit: BoxFit.cover
                      )
                  ),),
                // The card widget with top padding,
                // incase if you wanted bottom padding to work,
                // set the `alignment` of container to Alignment.bottomCenter
                Padding(
                  padding: const EdgeInsets.only(top: 335),
                  child: Divider(
                    height: 5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 23, left: 20, right: 20),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Tontine('')));
                          },
                          icon: Icon(Icons.arrow_back_ios,color: Colors.white,)
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Tontine('')));
                        },
                        child: Text('Retour',
                          style: TextStyle(color: Colors.white, fontSize: taille_champ),),
                      )
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 360, left: 20),
                  child: nom==null?Container():Text(nom.length>titre?nom.substring(0, titre):nom,
                    style: TextStyle(
                        color: couleur_fond_bouton,
                        fontSize: taille_text_bouton,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),

                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: EdgeInsets.only(top: 400, left: 20, ),
                        child: Column(
                          children: <Widget>[
                            Text(montant==null?"0":getMillis(montant.toString()).toString()+' $currency',
                              style: TextStyle(
                                  color: couleur_libelle_champ,
                                  fontSize: taille_libelle_champ,
                                  fontWeight: FontWeight.bold
                              ),),
                            Text("tous les $periode jours",
                              style: TextStyle(
                                  color: couleur_libelle_champ,
                                  fontSize: taille_libelle_champ-xval,
                                  fontWeight: FontWeight.normal
                              ),)
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(top: div1),
                        child: Container(color: couleur_decription_page, height: 40,
                          margin: EdgeInsets.only(left: margeleft+1, right: margeright+1),),
                      ),
                    ),

                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: EdgeInsets.only(top: 400),
                        child: Column(
                          children: <Widget>[
                            Text("Date limite d'adhésion",
                              style: TextStyle(
                                  color: couleur_libelle_champ,
                                  fontSize: taille_libelle_champ-xval,
                                  fontWeight: FontWeight.normal
                              ),),
                            Text(startDate.toString().split("T")[0],
                              style: TextStyle(
                                  color: couleur_libelle_champ,
                                  fontSize: taille_libelle_champ,
                                  fontWeight: FontWeight.bold
                              ),),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 460),
                  child: Divider(
                    height: 5,
                  ),
                ),

                description.toString().length>=tai?Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 5.0, top: topo-5),
                      child: Text(description.toString().length>=tai? description.toString().substring(0, tai)+'...':description.toString(),
                        style: TextStyle(
                          color: couleur_bordure,
                          fontSize: taille_description_page,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.0, right: 5.0, top: topo-5),
                      child: InkWell(
                        onTap: (){
                          this.ackAlert(context, description.toString());
                        },
                        child: new Container(
                          height: 25,
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
                    )
                  ],
                ):Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: topo),
                  child: Text(description.toString(),
                    style: TextStyle(
                      color: couleur_decription_page,
                      fontSize: taille_champ,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 515),
                  child: Divider(
                    height: 5,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 530, left: 20, right: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 6,
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              isLoding = false;
                              choice = 1;
                              this._ackAlert(context);
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: Container(
                              height: 75,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                  ),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: couleur_champ,
                                  )
                              ),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Icon(
                                      Icons.email,
                                      color: orange_F,
                                      size: 30,
                                    ),
                                  ),
                                  Text('Inviter',
                                    style: TextStyle(
                                        color: couleur_bordure,
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.bold
                                    ),)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              choice = 2;
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Adhesion()));
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Container(
                              height: 75,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                  ),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: couleur_champ,
                                  )
                              ),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Icon(
                                      Icons.check_box,
                                      color: orange_F,
                                      size: 30,
                                    ),
                                  ),
                                  Text('Les adhérants',
                                    style: TextStyle(
                                        color: couleur_bordure,
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.bold
                                    ),)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /*Padding(
                  padding: const EdgeInsets.only(top: 570),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Homme()));
                    },
                    child: Container(
                      height: hauteur_bouton,
                      color: couleur_fond_bouton,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.view_list, color: orange_F,),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text('Liste des membres', style: TextStyle(
                                color: Colors.white,
                              ),),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),*/

                Padding(
                  padding: EdgeInsets.only(top: 618),
                  child: Divider(
                    height: 5,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 617.5),
                  child: Container(
                    color: couleur_champ,
                    height: 205,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top:10, left: 20, right: 20),
                          child: InkWell(
                            onTap: (){

                            },
                            child: Container(
                              height: hauteur_bouton,
                              width: MediaQuery.of(context).size.width - 40,
                              decoration: new BoxDecoration(
                                color: Colors.green,
                                border: new Border.all(
                                  color: Colors.transparent,
                                  width: 0.0,
                                ),
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              child: new Center(child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  new Text('Virer les fonds', style: new TextStyle(color: couleur_text_bouton),),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: new Icon(Icons.arrow_forward, color: orange_F,),
                                  ),
                                ],
                              ),),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top:15, left: 20, right: 20),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: (){
                                  setState(() {
                                    getListparticipants();
                                  });

                                },
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Container(
                                    height: hauteur_bouton,
                                    width: MediaQuery.of(context).size.width/2 - 30,
                                    decoration: new BoxDecoration(
                                      color: couleur_fond_bouton,
                                      border: new Border.all(
                                        color: Colors.transparent,
                                        width: 0.0,
                                      ),
                                      borderRadius: new BorderRadius.circular(10.0),
                                    ),
                                    child: new Center(child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: new Icon(Icons.autorenew, color: orange_F,),
                                        ),
                                        new Text('Trier', style: new TextStyle(color: couleur_text_bouton),),
                                      ],
                                    ),),
                                  ),
                                ),
                              ),

                              InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Homme()));
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10,),
                                  child: Container(
                                    height: hauteur_bouton,
                                    width: MediaQuery.of(context).size.width/2 - 30,
                                    decoration: new BoxDecoration(
                                      color: couleur_fond_bouton,
                                      border: new Border.all(
                                        color: Colors.transparent,
                                        width: 0.0,
                                      ),
                                      borderRadius: new BorderRadius.circular(10.0),
                                    ),
                                    child: new Center(child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: new Icon(Icons.view_list, color: orange_F,),
                                        ),
                                        new Text('Les membres', style: new TextStyle(color: couleur_text_bouton),),
                                      ],
                                    ),),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 750),
                  child: Divider(
                    height: 5,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top:760, bottom: 20, ),
                  child: InkWell(
                    onTap: (){

                    },
                    child: Container(
                      height: hauteur_bouton,
                      width: MediaQuery.of(context).size.width - 0,
                      decoration: new BoxDecoration(
                        //borderRadius: new BorderRadius.circular(10.0),
                        color: couleur_fond_bouton,
                        border: new Border.all(
                          color: Colors.transparent,
                          width: 0.0,
                        ),
                      ),
                      child: new Center(child: new Text('Participer à la tontine', style: new TextStyle(color: couleur_text_bouton),),),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> ackAlert(BuildContext context, String text) {
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

  Future<void> _ackAlert(BuildContext context) {
    String address;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: _formKey2,
          child: AlertDialog(
            title: Text('Email(s) séparée(s) par des virgules.',
              style: TextStyle(
                fontSize: taille_libelle_champ,
                color: couleur_libelle_etape,
              ),
              textAlign: TextAlign.justify,),
            content: Container(
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
              height: 200,
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  maxLines: null,
                  style: TextStyle(
                    color: couleur_libelle_champ,
                    fontSize: taille_champ,
                  ),
                  validator: (String value){
                    if(value.isEmpty){
                      return null;
                    }else{
                      address = value;
                      return null;
                    }
                  },
                  decoration: InputDecoration.collapsed(
                    hintText: 'Emails ici',
                    hintStyle: TextStyle(
                      color: couleur_libelle_champ,
                      fontSize: taille_champ,
                    ),
                    //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              isLoding==false?FlatButton(
                child: Text('Valider'),
                onPressed: () {
                  if(_formKey2.currentState.validate()){
                    if(address.isEmpty || address==null){
                    }else{
                      if(address.contains(' '))
                        address = address.replaceAll(' ', "");
                      if(address.split(",")[address.split(",").length-1] == " "){
                        address = address.split(",")[address.split(",").length-2];
                      }
                      for(int i=0; i<address.split(",").length; i++){
                        if(isEmail(address.split(",")[i])){
                          invitations.add(address.split(",")[i]);
                          if(i == address.split(",").length - 1){
                            var inviteTontine = new InviteTontine(
                                members: invitations,
                                tontineId: int.parse(id)
                            );
                            isLoding = true;
                            print(json.encode(inviteTontine));
                            checkConnection(json.encode(inviteTontine));
                          }
                        } else{
                          showInSnackBar("Email: ${address.split(",")[i]} invalide !", _scaffoldKey, 5);
                          break;
                        }
                      }
                    }
                    setState(() {
                      choice = -1;
                    });
                    Navigator.of(context).pop();
                  }
                },
              ):CupertinoActivityIndicator(),

              FlatButton(
                child: Text('Annuler'),
                onPressed: () {
                  setState(() {
                    choice = -1;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void checkConnection(var body) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        isLoding =true;
        cretaInvite(body);
      });

    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        isLoding =true;
        cretaInvite(body);
      });
    } else {
      showInSnackBar("Service indisponible!", _scaffoldKey, 5);
    }
  }

  Future<String> cretaInvite(var body) async {
    String urli = "$BaseUrlTontine/memberships/addInvitations";
    print("Mon token :$_token");
    print(roundId);
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString("username");
    _password = prefs.getString("password");
    print("$_username, $_password");
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse("$urli"));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json');
    request.headers.set("Authorization", "Basic $credentials");
    request.add(utf8.encode(body));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print("statusCode ${response.statusCode}");
    print("body $reply");

    if(response.statusCode==200){
      setState(() {
        isLoding =true;
      });
      showInSnackBar("Votre invitation à été envoyée avec succes", _scaffoldKey, 5);
    }else{
      setState(() {
        isLoding =true;
      });
      showInSnackBar("Service indisponible", _scaffoldKey, 5);
    }
  }

  Future<String> getListparticipants() async {
    //roundId = int.parse();
    var url = "$tontine_url/tontines/randomizeOrder/${roundId}";
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString("username");
    _password = prefs.getString("password");
    print("$_username, $_password");
    print(roundId);
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json');
    request.headers.set("Authorization", "Basic $credentials");
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print(credentials);
    print("statusCode ${response.statusCode}");
    print("body $reply");
    if(response.statusCode==200){
      showInSnackBar("Tri effectué avec succès.", _scaffoldKey, 5);
    }else{
      showInSnackBar("Service indisponible.", _scaffoldKey, 5);
    }
  }

  bool isEmail(String em) {
    if(em == null){
      return true;
    }else {
      String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp(p);
      return regExp.hasMatch(em);
    }
  }
}