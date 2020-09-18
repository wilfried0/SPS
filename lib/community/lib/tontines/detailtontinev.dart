import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:services/community/lib/paiement/participationtontine1.dart';
import 'package:services/community/lib/tontines/tontine.dart';
import 'package:services/community/lib/utils/services.dart';
import 'package:services/composants/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../getDrawerContent.dart';
import 'package:flutter/material.dart';
import '../utils/components.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'inviter.dart';
import 'listemembres.dart';

class Detailtontinev extends StatefulWidget {
  Detailtontinev(this._codetontine);
  String _codetontine;
  @override
  _DetailtontinevState createState() => new _DetailtontinevState(_codetontine);
}

class _DetailtontinevState extends State<Detailtontinev> {
  _DetailtontinevState(this._codetontine);
  String _codetontine;
  final _url = '$base_url/kitty/all/desc';

  List<String> invitations = new List<String>(), flagUris = new List();
  PageController pageController;
  int currentPage = 0;
  bool isLoading;
  String urli, _token, _username, _password, code3 = "+237", invitation, flagUri = "flags/cm.png";
  int recenteLenght, archiveLenght, populaireLenght;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int roundId, flex4, flex6, taille, enlev, rest, enlev1, xval, titre, tai, choix;
  double _tail,_taill,haut, _width, hauteurcouverture, nomright, nomtop, right1, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext, _larg, left1, social, topo, div1, div2, margeleft, margeright;
  List _cagnottes;
  File _image;
  List<String> listtontine = new List<String>();
  List<String> listdemande = new List<String>();
  String nom, owner, description, montant, periode, retard, nextCash, startDate, avatar, id;
  var _formKey = GlobalKey<FormState>();
  var controller;
  //String kittyImage,currency, firstnameBenef,remain,title, endDate, , montant, montant, description, number, particip, kittyId;

  @override
  void initState() {
    super.initState();
    this.lecture();
    controller = new TextEditingController();
  }


  @override
  void dispose() {
    //_tabController.dispose();
    super.dispose();
    controller.disposer();
  }



  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width-40;
    double fromHeight, leftcagnotte, rightcagnotte, topcagnotte, bottomcagnotte;
    final double _large = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
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
    }else if(_larg == 320){
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

  lecture() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      print("la valeur de tite $titre");
      choix = int.parse(prefs.getString(CHOIX));
      avatar = prefs.getString(AVATAR_X);
      nom = prefs.getString(NOM_TONTINE_X);
      owner = prefs.getString(OWNER_USER_TONTINE);
      description = prefs.getString(DESCRIPTION_TONTINE_x);
      montant = prefs.getString(MONTANT_TONTINE_x);
      periode = prefs.getString(PARTICIP_DURATION_TONTINE_X);
      retard = prefs.getString(DELAYTIMES_TONTINE);
      nextCash = prefs.getString(NEXT_CASH_ORDER_TONTINE);
      startDate = prefs.getString(STARTDATE_TONTINE_X);
      listtontine = prefs.getStringList(PARTICIPANTS_X);
      listdemande = prefs.getStringList(DEMANDES_X);
    });
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
                          image: avatar!=null? NetworkImage(avatar):NetworkImage("images/cover.jpg"),
                          fit: BoxFit.cover
                      )
                  ),),

                Padding(
                  padding: const EdgeInsets.only(top: 23, left: 20, right: 20),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Tontine('')));
                        },
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

                nom==null?Container():Padding(
                  padding: EdgeInsets.only(top: 180, left: 20),
                  child: Text(nom.length>titre?nom.substring(0, titre):nom,
                    style: TextStyle(
                        color: couleur_fond_bouton,
                        fontSize: taille_text_bouton,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                montant == null || montant == null?Container():Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 210),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 15,
                        width: double.parse(montant)>0 && double.parse(montant.toString())>0 && double.parse(montant.toString())<double.parse(montant.toString())?double.parse(montant.toString())*_width/double.parse(montant.toString()):_width,
                        color: double.parse(montant.toString())>0 && double.parse(montant.toString())>0?orange_F:couleur_titre,
                        child: Text('0%',style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: taille_text_bouton
                        ),),/*Padding(
                          padding: const EdgeInsets.only(top: 1, right: 5),
                          child: double.parse(montant.toString())>0 && double.parse(montant.toString())>0?Text((double.parse(montant.toString())*100/double.parse(montant.toString())).toString().split('.')[0]+"%",
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
                        ),*/
                      ),
                      Container(
                        color: couleur_titre,
                        height: 15,
                        width: double.parse(montant.toString())>0 && double.parse(montant.toString())>0 && double.parse(montant.toString())<double.parse(montant.toString())?_width - double.parse(montant.toString())*_width/double.parse(montant.toString()):0,
                      )
                    ],
                  ),
                ),

                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child:montant ==null?Container(): Padding(
                        padding: EdgeInsets.only(top: 80, left: 20, ),
                        child: Column(
                          children: <Widget>[
                            Text(double.parse(montant.toString())>1?'A cotiser':'A cotiser',
                              style: TextStyle(
                                  color: couleur_libelle_champ,
                                  fontSize: taille_libelle_champ-xval,
                                  fontWeight: FontWeight.normal
                              ),),
                            Text(getMillis(montant.toString()).toString(),
                              style: TextStyle(
                                  color: couleur_libelle_champ,
                                  fontSize: taille_libelle_champ,
                                  fontWeight: FontWeight.bold
                              ),),

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
                        padding: EdgeInsets.only(top: 80),
                        child: Column(
                          children: <Widget>[
                            Text(listtontine.isNotEmpty && listtontine.length>1?'Membres':'Membre',
                              style: TextStyle(
                                  color: couleur_libelle_champ,
                                  fontSize: taille_libelle_champ-xval,
                                  fontWeight: FontWeight.normal
                              ),),
                            Text(listtontine.isNotEmpty?'${listtontine.length}':'0',
                              style: TextStyle(
                                  color: couleur_libelle_champ,
                                  fontSize: taille_libelle_champ,
                                  fontWeight: FontWeight.bold
                              ),),

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
                      child:montant ==null?Container(): Padding(
                        padding: EdgeInsets.only(top: 80, left: 20, ),
                        child: Column(
                          children: <Widget>[
                            Text('Date limite',
                              style: TextStyle(
                                  color: couleur_libelle_champ,
                                  fontSize: taille_libelle_champ,
                                  fontWeight: FontWeight.normal
                              ),),
                            Text(startDate.toString().split("T")[0],
                              style: TextStyle(
                                  color: couleur_libelle_champ,
                                  fontSize: taille_libelle_champ-xval,
                                  fontWeight: FontWeight.bold
                              ),)
                          ],
                        ),
                      ),
                    ),

                  ],
                ),


                /*description.toString().length>=tai?Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 5.0, top: 100),
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
                      color: Colors.black,
                      fontSize: taille_champ,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),*/

               /* Padding(
                  padding: const EdgeInsets.only(top: 220),
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        _save1();
                        _reading();
                      });

                      JeVeuxetreMemnre();
                    },
                    child: Container(
                      height: hauteur_bouton,
                      color: couleur_fond_bouton,
                      child: Padding(
                        padding: EdgeInsets.only(left: 50, right: 20),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.accessible, color: Colors.white,),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text('Je veux etre membre', style: TextStyle(
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
                  padding: const EdgeInsets.only(top: 650),
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        lecture();
                        //listtontine = _tontines[index]['participants'];
                        _ackAlert(context);
                      });
                      //_save1();
                      //_reading();
                      //JeVeuxetreMemnre();
                    },
                    child: Container(
                      height: hauteur_bouton,
                      color: couleur_fond_bouton,
                      child: Padding(
                        padding: EdgeInsets.only(left: 50, right: 20),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.playlist_add, color: Colors.white,),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text('La liste de demandes', style: TextStyle(
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
                  padding: const EdgeInsets.only(top: 350),
                  child: InkWell(
                    onTap: (){
                      _save1();
                      _reading();
                      JeVeuxetreMemnre();
                    },
                    child: Container(
                      height: hauteur_bouton,
                      color: couleur_fond_bouton,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          children: <Widget>[

                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text('Il y a une demande d\'adhésion', style: TextStyle(
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
                  padding: const EdgeInsets.only(top: 410),
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
                              Icons.add_to_home_screen, color: orange_F,),
                          ),
                        ),

                        Expanded(
                          flex: 10,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text("Virer les fonds au bénéficiaire",
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

                GestureDetector(
                  onTap: (){
                    setState(() {
                      _reading();
                      getListparticipants();
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 450),
                    child: Container(
                      height: hauteur_champ,
                      color: couleur_fond_bouton,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Icon(
                                Icons.autorenew, color: orange_F,),
                            ),
                          ),

                          Expanded(
                            flex: 10,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text("Trie des membres par ordre",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal
                                ),),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 530),

                  child: InkWell(

                    onTap: (){
                      setState(() {
                        _reading();
                        getListparticipants();
                      });
                    },

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
                                Icons.format_list_numbered_rtl, color: orange_F,),
                            ),
                          ),

                          Expanded(
                            flex: 10,
                            child: InkWell(
                              onTap: (){
                                setState(() {
                                  print("*******************************${listtontine.toString()}");
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Homme()));
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text("Liste des membres" ,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal
                                  ),),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),



                /*Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 625),
                  child: Text('Téléphone de l\'organisteur: ${owner==null?"":owner}',
                    style: TextStyle(
                        color: couleur_bordure,
                        fontSize: taille_champ,
                        fontWeight: FontWeight.bold
                    ),),
                ),*/

                /*Padding(
                  padding: const EdgeInsets.only(top: 665.0),
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    color: couleur_champ,
                    child: Center(child: Text("Envoyer une invitation",
                      style: TextStyle(
                          color: couleur_bordure,
                          fontSize: taille_champ,
                          fontWeight: FontWeight.bold
                      ),)
                    ),
                  ),
                ),*/
                Padding(
                  padding: const EdgeInsets.only(top:290, bottom: 20),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Inviter()));
                      _reading();
                      _save1();
                      print(roundId);
                      var inviteTontine = new InviteTontine(
                          members: invitations,
                          tontineId: roundId
                      );
                      print(json.encode(inviteTontine));
                      checkConnection2(json.encode(inviteTontine));
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
                      child: new Center(child: new Text('Inviter les membres', style: new TextStyle(color: couleur_text_bouton),),),
                    ),
                  ),
                ),

                /*Padding(
                  padding: const EdgeInsets.only(top: 620.0, bottom: 20.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 10,
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
                                width: 1.5
                            ),
                          ),
                          height: hauteur_champ,
                          child: Row(
                            children: <Widget>[

                              new Expanded(
                                flex:10,
                                child: Form(
                                  key: _formKey,
                                  child: new TextFormField(
                                    controller: controller,
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(
                                      fontSize: taille_champ+3,
                                      color: couleur_libelle_champ,
                                    ),
                                    validator: (String value){
                                      if(value.isEmpty){
                                        return "Champ emails vide !";
                                      }else{
                                        invitation = value;
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration.collapsed(
                                      hintText: "Ajouter votre email avant d\'inviter!",
                                      hintStyle: TextStyle(
                                        fontSize: taille_champ+3,
                                        color: couleur_libelle_champ,
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
                      Expanded(
                        flex: 2,
                        child: IconButton(
                            icon: Icon(Icons.add_circle, size: 35,color: couleur_fond_bouton,),
                            onPressed: (){
                              setState(() {
                                _save1();
                                _reading();
                                if(_formKey.currentState.validate()){
                                  print("Voici le flagUri ******************** $flagUri");
                                  print(invitations);
                                  flagUris.add(flagUri);
                                  invitations.add(invitation);
                                  controller.clear();
                                } else
                                  showInSnackBar("Veuillez entrer l'adresse email", _scaffoldKey, 5);
                              });
                            }
                        ),
                      )
                    ],
                  ),
                ),*/

                /*Padding(
                  padding: const EdgeInsets.only(top: 690.0, bottom: 20.0),
                  child: Container(
                      height: MediaQuery.of(context).size.height/2,
                      child: ListView.builder(
                        itemCount: invitations==null?0:invitations.length,
                        itemBuilder: (BuildContext context, int i){
                          if(i == 0){
                            return Column(
                              children: <Widget>[
                                Divider(color: Colors.orange,
                                  height: .1,),
                                Row(
                                  children: <Widget>[
                                    /*Padding(
                                      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                                      child: SizedBox(
                                        height: 30,
                                        width: 40,
                                        child: Image.asset(flagUris1[i]),
                                      ),
                                    ),*/
                                    SizedBox(
                                      child: Text(invitations[i],
                                        style: TextStyle(
                                          color: couleur_libelle_champ,
                                          fontSize: taille_champ+3,
                                        ),),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 2.0),
                                  child: Divider(color: Colors.orange,
                                    height: .1,),
                                ),
                              ],
                            );
                          }else{
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    /*Padding(
                                      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                                      child: SizedBox(
                                        height: 30,
                                        width: 40,
                                        child: Image.asset(flagUris[i]),
                                      ),
                                    ),*/
                                    SizedBox(
                                      child: Text(invitations[i],
                                        style: TextStyle(
                                          color: couleur_libelle_champ,
                                          fontSize: taille_champ+3,
                                        ),),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 2.0),
                                  child: Divider(color: Colors.orange,
                                    height: .1,),
                                ),
                              ],
                            );
                          }
                        },
                      )),
                ),*/

                Padding(
                  padding: const EdgeInsets.only(top:590, bottom: 20),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Paiementtontine1(_codetontine)));
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
                      child: new Center(child: new Text('Je veux cotiser', style: new TextStyle(color: couleur_text_bouton),),),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top:700, bottom: 20),

                    child: Container(
                      height: hauteur_bouton-40,
                      width: MediaQuery.of(context).size.width,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        border: new Border.all(
                          color: Colors.transparent,
                          width: 0.0,
                        ),
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

  void checkConnection2(var body) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        isLoading =true;
        contribKitty2(body);
      });

    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        isLoading =true;
        contribKitty2(body);
      });
    } else {
      showInSnackBar("Service indisponible!", _scaffoldKey, 5);
    }
  }


  Future<String> contribKitty2(var body) async {
    urli = "http://74.208.183.205:8086/spcommunity-tontine/memberships/addInvitations";
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
      showInSnackBar("Votre invitation à été envoyée avec succes", _scaffoldKey, 5);
    }else if(response.statusCode==500){
      showInSnackBar("Problème serveur", _scaffoldKey, 5);
    }else{
      showInSnackBar("Il y a un soucis", _scaffoldKey, 5);
    }

  }

  void showInSnackBar(String value, GlobalKey<ScaffoldState> scaffoldKey, int i) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text(value,style:
        TextStyle(
            color: Colors.white,
            fontSize: taille_description_champ
        ),
          textAlign: TextAlign.center,),
          backgroundColor: couleur_fond_bouton,
          duration: Duration(seconds: 10),));
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

  void _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('paiement', null);
  }

  void _save1() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(INVITATIONS_TONTINE_S, invitations);
    print("saved ${invitations}");
  }

  _reading() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      roundId = int.parse(prefs.getString(ID_TONTINE_X));
      _token = prefs.getString(TOKEN);
      invitations = prefs.getStringList(INVITATIONS_TONTINE_X);
     // invitations1 = prefs.getStringList(INVITATIONS_TONTINE_S);

    });
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
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json');
    request.headers.set("Authorization", "Basic $credentials");
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print(credentials);
    print("statusCode ${response.statusCode}");
    print("body $reply");
    if(response.statusCode==200){
      //showInSnackBar("Votre demande à", _scaffoldKey, 5);
    }
  }

  Future<String> JeVeuxetreMemnre() async {
    //roundId = int.parse();
    var urlj = "http://74.208.183.205:8086/spcommunity-tontine/memberships/sendMembershipRequest/${roundId}";
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString("username");
    _password = prefs.getString("password");
    print("$_username, $_password");
    print(roundId);
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.getUrl(Uri.parse(urlj));
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

  Future<void> _ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('La liste de demande'),
          content:  Text(listdemande.toString()),
          actions: <Widget>[
            FlatButton(
              child: Text('REFUSER'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('ACCEPTER'),
              onPressed: () {
                //_asyncConfirmDialog(context);
              },
            ),
          ],
        );
      },
    );
  }
}