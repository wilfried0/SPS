import 'package:services/community/lib/paiement/participation1.dart';
import 'package:services/composants/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../getDrawerContent.dart';
import 'package:flutter/material.dart';
import '../utils/components.dart';
import 'dart:io';
import 'package:share/share.dart';


class Participer extends StatefulWidget {
  Participer(this._code);
  String _code;
  @override
  _ParticiperState createState() => new _ParticiperState(_code);
}

class _ParticiperState extends State<Participer> {
  _ParticiperState(this._code);
  String _code;
  final _url = '$base_url/kitty/all/desc';
  PageController pageController;
  int currentPage = 0;
  String _token;
  int recenteLenght, archiveLenght, populaireLenght;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int flex4, flex6, taille, enlev, rest, enlev1, xval, titre, tai, choix;
  double _tail,_taill,haut, _width, hauteurcouverture, nomright, nomtop, right1, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext, _larg, left1, social, topo, div1, div2, margeleft, margeright;
  List _cagnottes;
  File _image;
  String kittyImage,currency, firstnameBenef,remain,title, endDate, startDate, previsional_amount, amount_collected, description, number, particip, kittyId;

  @override
  void initState() {
    super.initState();
    this.lecture();
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
    currency = _code.split('^')[12];
    remain = _code.split('^')[13];
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

  lecture() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      choix = int.parse(prefs.getString(CHOIX));
      _token = prefs.getString(TOKEN);
      print('je lis le choix: $choix');
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
                          image: kittyImage!=null? NetworkImage(kittyImage):NetworkImage("images/cover.jpg"),
                          fit: BoxFit.cover
                      )
                  ),),
                // The card widget with top padding,
                // incase if you wanted bottom padding to work,
                // set the `alignment` of container to Alignment.bottomCenter
                new Container(
                  child: new Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly
                    children: <Widget>[
                      Padding(
                        padding: new EdgeInsets.only(
                            top: hauteurcouverture-55,
                            right: 0.0,
                            left: 20.0),
                        child: SizedBox(
                          child: Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: _image == null?AssetImage("images/ellipse1.png"):Image.file(_image),
                                    fit: BoxFit.cover
                                )
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 280, right: MediaQuery.of(context).size.width-enlev1),
                            child: Text('',//firstnameBenef,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: taille_champ
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Container(
                              height: 30,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text((DateTime.parse(endDate).difference(DateTime.parse(startDate))).inDays>=0?
                                  (DateTime.parse(endDate).difference(DateTime.parse(startDate))).inDays.toString():
                                  "",
                                    style: TextStyle(
                                        color: couleur_libelle_champ,
                                        fontSize: taille_libelle_champ,
                                        fontWeight: FontWeight.bold
                                    ),),
                                  Text((DateTime.parse(endDate).difference(DateTime.parse(startDate))).inDays>=0?'Jours Restants':
                                  "Expirée",
                                    style: TextStyle(
                                        color: couleur_libelle_champ,
                                        fontSize: taille_libelle_champ-xval,
                                        fontWeight: FontWeight.normal
                                    ),)
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
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
                      InkWell(
                          onTap: (){
                            setState(() {
                              Navigator.pop(context);
                              //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte(_code)));
                              //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Participer(_code)));
                            });
                          },
                          child: Icon(Icons.arrow_back_ios,color: Colors.white,)
                      ),
                      InkWell(
                        onTap: (){
                          setState(() {
                            Navigator.pop(context);
                            //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte(_code)));
                            //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Participer(_code)));
                          });
                        },
                        child: Text('Retour',
                          style: TextStyle(color: Colors.white, fontSize: taille_champ),),
                      )
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 360, left: 20),
                  child: title==null?Container():Text(title.length>titre?title.substring(0, titre):title,
                    style: TextStyle(
                        color: couleur_fond_bouton,
                        fontSize: taille_text_bouton,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                amount_collected == null || previsional_amount == null?Container():Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 380),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 15,
                        width: double.parse(amount_collected)>0 && double.parse(previsional_amount.toString())>0 && double.parse(amount_collected.toString())<double.parse(previsional_amount.toString())?double.parse(amount_collected.toString())*_width/double.parse(previsional_amount.toString()):_width,
                        color: double.parse(amount_collected.toString())>0 && double.parse(previsional_amount.toString())>0?orange_F:couleur_titre,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 1, right: 5),
                          child: double.parse(amount_collected.toString())>0 && double.parse(previsional_amount.toString())>0?Text((double.parse(amount_collected.toString())*100/double.parse(previsional_amount.toString())).toString().split('.')[0]+"%",
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
                        ),
                      ),
                      Container(
                        color: couleur_titre,
                        height: 15,
                        width: double.parse(amount_collected.toString())>0 && double.parse(previsional_amount.toString())>0 && double.parse(amount_collected.toString())<double.parse(previsional_amount.toString())?_width - double.parse(amount_collected.toString())*_width/double.parse(previsional_amount.toString()):0,
                      )
                    ],
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
                            Text(getMillis(amount_collected.toString()).toString()+' $currency',
                              style: TextStyle(
                                  color: couleur_libelle_champ,
                                  fontSize: taille_libelle_champ,
                                  fontWeight: FontWeight.bold
                              ),),
                            Text(double.parse(amount_collected.toString())>1?'Collectés':'Collecté',
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
                            Text(particip!=null?particip:'0',
                              style: TextStyle(
                                  color: couleur_libelle_champ,
                                  fontSize: taille_libelle_champ,
                                  fontWeight: FontWeight.bold
                              ),),
                            Text(double.parse(particip)>1?'Contributeurs':'Contributeur',
                              style: TextStyle(
                                  color: couleur_libelle_champ,
                                  fontSize: taille_libelle_champ-xval,
                                  fontWeight: FontWeight.normal
                              ),)
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
                      Share.share("$baseUrl$kittyId");
                    },
                    child: Container(
                      height: hauteur_bouton,
                      color: couleur_fond_bouton,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.mobile_screen_share, color: orange_F,),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text('Partager cette cagnotte', style: TextStyle(
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
                            child: Text("Contact de l'organisateur",
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
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 635),
                  child: Text('Téléphone: ${number==null?"":number}',
                    style: TextStyle(
                        color: couleur_bordure,
                        fontSize: taille_champ,
                        fontWeight: FontWeight.bold
                    ),),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 665.0),
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    color: couleur_champ,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top:740, bottom: 20),
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        if((DateTime.parse(endDate).difference(DateTime.parse(startDate))).inDays>=0){
                          this._save();
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Paiement1(_code)));
                        }else
                          showInSnackBar("Vous ne pouvez plus contribuer à cette cagnotte");
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
                      ),
                      child: new Center(child: new Text('Participer à cette cagnotte', style: new TextStyle(color: couleur_text_bouton),),),
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

  void showInSnackBar(String value) {
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
}