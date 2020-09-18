import 'dart:convert';
import 'package:services/community/lib/tontines/tontine.dart';
import 'package:services/composants/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../getDrawerContent.dart';
import 'package:flutter/material.dart';
import '../utils/components.dart';
import '../cagnotte.dart';
import 'dart:io';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;

import 'listemembres.dart';

class ParticiperMembretontine extends StatefulWidget {
  ParticiperMembretontine(this._code);
  String _code;
  @override
  _ParticiperMembretontineState createState() => new _ParticiperMembretontineState(_code);
}

class _ParticiperMembretontineState extends State<ParticiperMembretontine> {
  _ParticiperMembretontineState(this._code);
  String _code;
  final _url = '$base_url/kitty/all/desc';
  PageController pageController;
  int currentPage = 0;
  String _token;
  int recenteLenght, archiveLenght, populaireLenght;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int flex4,roundId, flex6, taille, enlev, rest, enlev1, xval, titre, tai, choix;
  double _tail,_taill,haut, _width, hauteurcouverture, nomright, nomtop, right1, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext, _larg, left1, social, topo, div1, div2, margeleft, margeright;
  List _cagnottes;
  List<String> listtontine = new List<String>();
  File _image;
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
    return new Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: getDrawerContent(),
      ),
      endDrawer: getDrawerContent(),
      body: _buildCarousel(context),
      bottomNavigationBar: bottomNavigation(context, _scaffoldKey,  choix, _token),
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
                  padding: const EdgeInsets.only(top: 515),
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
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 565),
                  child: Container(
                    height: hauteur_champ,
                    color: couleur_champ,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Icon(
                              Icons.account_box, color: orange_F,),
                          ),
                        ),

                        Expanded(
                          flex: 10,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text("Informations sur l'organisateur",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal
                              ),),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 630),
                  child: Row(
                    children: [
                      Icon(Icons.person, color: orange_F,),
                      Text(name==null?"":'$name',
                        style: TextStyle(
                            color: couleur_bordure,
                            fontSize: taille_champ,
                            fontWeight: FontWeight.bold
                        ),),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 665.0, left: 20, right: 20),
                  child: Row(
                    children: [
                      Icon(Icons.phone_android, color: orange_F,),
                      Text(owner==null?"":'$owner',
                        style: TextStyle(
                            color: couleur_bordure,
                            fontSize: taille_champ,
                            fontWeight: FontWeight.bold
                        ),),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 700.0, left: 20, right: 20),
                  child: Row(
                    children: [
                      Icon(Icons.email, color: orange_F,),
                      Text(email==null?"":'$email',
                        style: TextStyle(
                            color: couleur_bordure,
                            fontSize: taille_champ,
                            fontWeight: FontWeight.bold
                        ),),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top:740, bottom: 20),
                  child: ((DateTime.parse(startDate.toString().split("T")[0])).difference(DateTime.parse(DateTime.now().toString().split(" ")[0]))).inDays>=0?
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 10),
                        child: InkWell(
                          onTap: (){

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
                            ),
                            child: new Center(child: new Text('Je participe à la tontine', style: new TextStyle(color: couleur_text_bouton),),),
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 20),
                        child: InkWell(
                          onTap: (){

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
                            ),
                            child: new Center(child: new Text('Partager la tontine', style: new TextStyle(color: couleur_text_bouton),),),
                          ),
                        ),
                      ),
                    ],
                  ):
                  InkWell(
                    onTap: (){

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
                      ),
                      child: new Center(child: new Text('Je participe à la tontine', style: new TextStyle(color: couleur_text_bouton),),),
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

  Future<String> JeVeuxetreMemnre() async {
    //roundId = int.parse();
    var urlj = "$BaseUrlTontine/memberships/sendMembershipRequest/$roundId";
    print("$_username, $_password");
    print(roundId);
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse(urlj));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json');
    request.headers.set("Authorization", "Basic $credentials");
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print(credentials);
    print("statusCode ${response.statusCode}");
    print("body $reply");
    if(response.statusCode==200){
      showInSnackBar("Votre demande à été envoyée avec succes", _scaffoldKey, 5);
    }else if(response.statusCode==200){
      showInSnackBar("Problème serveur", _scaffoldKey, 5);
    }else{
      showInSnackBar("Il y a un soucis", _scaffoldKey, 5);
    }
  }
}