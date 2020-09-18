import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:services/composants/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pays.dart';
import 'package:flutter/material.dart';
import 'tontines/tontine.dart';
import 'utils/components.dart';
import 'package:http/http.dart' as http;
import 'utils/services.dart';
import 'dart:async';
import 'package:async/async.dart';

import 'transaction.dart';


// ignore: must_be_immutable
class Profiletontine extends StatefulWidget {
  Profiletontine(this._codetontine);
  String _codetontine;
  @override
  _ProfiletontineState createState() => new _ProfiletontineState(_codetontine);
}

class _ProfiletontineState extends State<Profiletontine> with SingleTickerProviderStateMixin {
  _ProfiletontineState(this._codetontine);
  String _codetontine;
  final logout = '$base_url/user/Auth/signout';
  Future<Login> post;
  TabController _tabController;
  PageController pageController;
  int currentPage = 0, choix;
  String _token, solde, idUser, userImage;
  DateTime date;
  bool isLoding = false, loadImage = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int recenteLenght = 3, archiveLenght = 3, populaireLenght =3, nb;
  int id, flex4, flex6, taille, enlev, rest, enlev1;
  double haut, _taill,topi, bottomsolde,sold,topo22,top33, top34, top1, top, top2, top3,top4, topo1, topo2, hauteurcouverture, nomright, nomtop, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext;
  File _image;

  @override
  void initState(){
    this._lire();
    date = new DateTime.now();
    super.initState();
    _tabController = new TabController(length: 1, vsync: this);
    this._read();
    this.lire();
    this.lecture();
    pageController = PageController(
        initialPage: currentPage,
        keepPage: false,
        viewportFraction: 1
    );
  }

  Future<String> getImage() async {
    if(_token == null){
      ackAlert(context, "Vous devez être connecté pour charger une image à cette cagnotte");
    }else {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      print(image);
      setState(() {
        loadImage = true;
      });
      print(loadImage);
      Upload(image);
    }
    return null;
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'monToken';
    _token = prefs.getString(key);
  }

  // ignore: non_constant_identifier_names
  void Upload(File imageFile) async {
    var _header = {
      "content-type" : 'multipart/form-data',
      "Authorization": "Bearer $_token"
    };
    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var multipartFile = new http.MultipartFile('file', stream, length, filename: imageFile.path.split('/').last);
    String val1, val2;
    var uri = Uri.parse('$base_url/file/uploadImage/user');
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(_header);
    request.files.add(multipartFile);
    var response = await request.send();
    print('request ${response.request}');
    print('statuscode ${response.statusCode}');
    if(response.statusCode == 200){
      setState(() {
        loadImage = false;
      });
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
        val1 = value.split(',')[1];
        val2 = val1.substring(19, val1.length-1);
        userImage = val2;
        print('userimage: $userImage');
        UploadUser(userImage);
      });
      _image = imageFile;
      setState(() {
        loadImage = false;
      });
    }else{
      setState(() {
        loadImage = false;
      });
      showInSnackBar("Echec de l'opération réessayer plus tard!");
    }
  }

  // ignore: non_constant_identifier_names
  void UploadUser(String userImage) async {
    String url ="$base_url/user/Auth/updateMember";
    var _header = {
      "accept": "application/json",
      "content-type" : "application/json"
    };
    var corps = {
      "id_user": int.parse(idUser),
      "userImage":"$userImage"
    };
    print('corps: ${jsonEncode(corps)}');
    print('url: $url');
    var responses = await http.put(Uri.encodeFull(url), body: json.encode(corps), headers: _header,);
    print(responses.statusCode);
    print(responses.body);
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
          duration: Duration(seconds: 5),));
  }

  onDoneLoading() async {
    setState(() {
      isLoding = false;
      this.sava();
      _codetontine = "";
    });
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Tontine(_codetontine)));
    //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Profile(_code)));
  }

  Future<void> logOut() async {
    var response = await http.get(Uri.encodeFull(logout), headers: {"Accept": "application/json", "Authorization": "Bearer $_token"},);
    print('logout status: ${response.statusCode}');
    if(response.statusCode == 200){
      showInSnackBar("Déconnexion effectuée avec succès!");
      Timer(Duration(seconds: 1), onDoneLoading);
    }else if(response.statusCode == 401){
      setState(() {
        isLoding = false;
      });
      showInSnackBar("Désolé mais vous n'êtes plus connecté!");
    }
    else{
      setState(() {
        isLoding = false;
      });
      showInSnackBar("Désolé mais vous n'êtes pas connecté!");
    }
  }

  Future<void> getSolde() async {
    String sold = "$base_url/trans/totalcashOfUser/$idUser";
    var response = await http.get(Uri.encodeFull(sold), headers: {"Accept": "application/json"},);
    if(response.statusCode == 200){
      print(response.body);
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        solde = "${responseJson['amount']} ${responseJson['currency']}";
      });
    } else{
      showInSnackBar(json.decode(utf8.decode(response.bodyBytes)));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final _large = MediaQuery.of(context).size.width;
    final _haut = MediaQuery.of(context).size.height;
    double fromHeight, leftcagnotte, rightcagnotte, topcagnotte, bottomcagnotte;
    if(_large<=320){
      fromHeight = 120;
      leftcagnotte = 20;
      rightcagnotte = 30;
      topcagnotte = 50; //espace entre mes tabs et le slider
      bottomcagnotte = 30;
      bottomsolde = 400;
      sold = 330;
      _taill = taille_description_champ-2;
      top1 = 65;
      top = 100;
      topo1 = 133;
      top2 = 142;
      top3 = 297;
      top4 = 220;
      top33 = 288;
      topo2 = 70;
      topo22 = 100;
      top34 = 211;
      haut=5;
      topi = 2;
    }else if(_large>320 && _large<=360 && _haut==738){
      fromHeight = 130;
      leftcagnotte = 20;
      rightcagnotte = 40;
      topcagnotte = 50;
      bottomcagnotte = 50;
      bottomsolde = 400;
      sold = 330;
      _taill = taille_description_champ-1;
      top1 = 75;
      top = 100;
      topo1 = 172;
      top2 = 190;
      top3 = 410;
      top4 = 300;
      top33 = 285;
      top34 = 395;
      topo2 = 90;
      topo22 = 100;
      haut=20;
      topi = 2;
    }else if(_large>320 && _large<=360){
      fromHeight = 130;
      leftcagnotte = 20;
      rightcagnotte = 40;
      topcagnotte = 50;
      bottomcagnotte = 50;
      bottomsolde = 400;
      sold = 330;
      _taill = taille_description_champ-1;
      top1 = 75;
      top = 100;
      topo1 = 155;
      top2 = 165;
      top3 = 345;
      top4 = 255;
      top33 = 245;
      top34 = 335;
      topo2 = 80;
      topo22 = 100;
      haut=10;
      topi = 2;
    }else if(_large>411 && _large<412){
      fromHeight = 130;
      leftcagnotte = 20;
      rightcagnotte = 40;
      topcagnotte = 50;
      bottomcagnotte = 40;
      bottomsolde = 400;
      sold = 330;
      _taill = taille_description_champ;
      top1 = 75;
      top = 100;
      topo1 = 172;
      top2 = 190;
      top3 = 410;
      top4 = 300;
      top33 = 285;
      top34 = 395;
      topo2 = 90;
      topo22 = 100;
      haut=20;
      topi = 2;
    }else if(_large>360){
      fromHeight = 130;
      leftcagnotte = 20;
      rightcagnotte = 40;
      topcagnotte = 50;
      bottomcagnotte = 50;
      bottomsolde = 400;
      sold = 330;
      _taill = taille_description_champ;
      top1 = 75;
      top = 100;
      topo1 = 172;
      top2 = 190;
      top3 = 410;
      top4 = 300;
      top33 = 285;
      top34 = 395;
      topo2 = 90;
      topo22 = 100;
      haut=20;
      topi = 15;
    }

    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: bleu_F,
      appBar: new PreferredSize(
        preferredSize: Size.fromHeight(fromHeight),
        child: new Padding(
            padding: EdgeInsets.only(top: topcagnotte, bottom: bottomcagnotte, left: leftcagnotte, right: rightcagnotte),
            child: new Row(
              children: <Widget>[
                _image == null?SizedBox(
                  child: InkWell(
                    onTap: () async {
                      getImage();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage("images/ellipse1.png"),
                              fit: BoxFit.cover
                          )
                      ),
                    ),
                  ),
                ):SizedBox(
                  child: InkWell(
                    onTap: () async {
                      getImage();
                    },
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: FileImage(_image),
                              fit: BoxFit.cover
                          )
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 10, top: topi),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: loadImage == false?Text(_codetontine.split('^')[0]!=null?'${_codetontine.split('^')[0]}':'',//Nom du connecté
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: taille_libelle_etape+3,
                              color: Colors.white),
                        ):Row(
                          children: <Widget>[
                            CupertinoActivityIndicator(),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text("Patientez SVP...", style: TextStyle(
                                  color: Colors.white,
                                  fontSize: taille_description_champ,
                                  fontFamily: police_description_champ
                              ),),
                            )
                          ],
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: loadImage == false?Text(_codetontine.split('^').length>1?'${_codetontine.split('^')[1]}':"",//Ville du connecté
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: taille_libelle_etape,
                              color: couleur_fond_bouton),
                        ):Container(),
                      )
                    ],
                  ),
                ),

              ],
            )),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 80),//solde du compte
            child: Text('SOLDE DU COMPTE', style: TextStyle(
                color: Colors.white,
                fontSize: taille_libelle_etape
            ),),
          ),
          Padding(
            padding: EdgeInsets.only(left: 80, top: 20),
            child: Text(solde==null?"0":getMillis('$solde'), style: TextStyle(//Montant du solde
                color: Colors.white,
                fontSize: taille_titre+5,
                fontWeight: FontWeight.bold
            ),),
          ),
          Padding(
            padding: EdgeInsets.only(top: 100),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: couleur_champ,
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 6,
                child: Padding(
                  padding: new EdgeInsets.only(top: top1, right: 20.0, left: 20.0),
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
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            print('mes transactions');
                            //Navigator.of(context).push(SlideLeftRoute(enterWidget: Paiement(_code), oldWidget: Profile(_code)));
                          });
                        },
                        child: Column(
                          children: <Widget>[
                            Container(
                                height: 50,
                                width: 50,
                                child: new Image.asset('images/Groupe3.png')),
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

              Expanded(
                flex: 6,
                child: Padding(
                  padding: new EdgeInsets.only(top:top1, right: 20.0, left: 20.0),
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
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            if(id == null || id == '-1'){
                              this.save1('tontines');
                              this.ackAlert(context, "Vous devez être connecté pour voir vos cagnottes.");
                              //Navigator.of(context).push(SlideLeftRoute(enterWidget: Pays(), oldWidget: Profile('')));
                            }else
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Tontine('true')));
                            //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte('true'), oldWidget: Profile('')));
                          });
                        },
                        child: Column(
                          children: <Widget>[
                            Container(
                                height: 50,
                                width: 50,
                                child: new Image.asset('images/ic_changer_lang.png')),
                            Text('Mes tontines',
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
            padding: EdgeInsets.only(top: topo1, left: 20, right: 20),
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
                  padding: new EdgeInsets.only(top:top2, right: 20.0, left: 20.0),
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
                      child: InkWell(
                        onTap: (){
                          setState(() {
                          });
                        },
                        child: Column(
                          children: <Widget>[
                            Container(
                                height: 50,
                                width: 50,
                                child: new Image.asset('images/Groupe7.png')),
                            Text('Tarifs',
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
                  padding: new EdgeInsets.only(top:top2, right: 20.0, left: 20.0),
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
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            print('toutes les tontines');
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Tontine(_codetontine)));
                            //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Profile('')));
                          });
                        },
                        child: Column(
                          children: <Widget>[
                            Container(
                                height: 50,
                                width: 50,
                                child: new Image.asset('images/Groupe12.png')),
                            Text('Toutes les tontines',
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
            padding: EdgeInsets.only(top: top34, left: 20, right: 20),
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
                  padding: new EdgeInsets.only(top: top3, right: 20.0, left: 20.0),
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
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            this.fermer(context, "Êtes-vous sûr de vouloir quitter l'application SprintPay Community?");
                            //Navigator.of(context).push(SlideLeftRoute(enterWidget: Paiement(_code), oldWidget: Profile(_code)));
                          });
                        },
                        child: Column(
                          children: <Widget>[
                            Container(
                                height: 50,
                                width: 50,
                                child: new Image.asset('images/ellipse1.png')),
                            Text("Quitter",
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
                  padding: new EdgeInsets.only(top:top3, right: 20.0, left: 20.0),
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
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            //print(MediaQuery.of(context).size.width);
                            isLoding = true;
                            this.logOut();
                          });
                        },
                        child: Column(
                          children: <Widget>[
                            isLoding==false?Container(
                                height: 50,
                                width: 50,
                                child: new Image.asset('images/ic_deconnexion.png')):CupertinoActivityIndicator(),
                            Text('Déconnexion',
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
                      child: InkWell(
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
                                child: new Image.asset('images/Groupe11.png')),
                            Text('Comment ça marche',
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
                      child: InkWell(
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
                                child: new Image.asset('images/trace3.png')),
                            Text('A propos',
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
          )
        ],
      ),
      bottomNavigationBar: bottomNavigation(context, _scaffoldKey,  choix, _token),
    );
  }

  lecture() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final key = 'choix';
      choix = int.parse(prefs.getString(key));
      print('je lis le choix: $choix');
    });
  }

  _read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final key = 'monToken';
      _token = prefs.getString(key);
    });
  }

  lire() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final key = 'id';
      id = prefs.getString(key) as int;
    });
  }

  void sava() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('monToken', null);
    prefs.setString('idUser', '-1');
  }

  _lire() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final key = 'idUser';
      id = (prefs.getString(key)=='-1'?'-1':prefs.getString(key)) as int;
      this.getSolde();
    });
  }

  void save1(String route) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'route';
    final value = '$route';
    prefs.setString(key, value);
    print('route $value');
  }

  Future<void> ackAlert(BuildContext context, String text) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: <Widget>[
              Icon(Icons.lock_outline,color: couleur_fond_bouton,),
              Text("Connectez-vous!", style: TextStyle(
                  fontSize: taille_libelle_etape,
                  color: couleur_fond_bouton
              ),),
            ],
          ),
          content: Text(text,
            style: TextStyle(
              fontSize: taille_champ,
            ),
            textAlign: TextAlign.justify,),
          actions: <Widget>[
            FlatButton(
              child: Text('Annuler'),
              onPressed: () {
                //this.savAll();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Me connecter'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Pays()));
                //Navigator.of(context).push(SlideLeftRoute(enterWidget: Pays(), oldWidget: Profile('$_code')));
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> fermer(BuildContext context, String text) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: <Widget>[
              Icon(Icons.lock_outline,color: couleur_fond_bouton,),
              Text("Quitter l'application!", style: TextStyle(
                  fontSize: taille_libelle_etape,
                  color: couleur_fond_bouton
              ),),
            ],
          ),
          content: Text(text,
            style: TextStyle(
              fontSize: taille_champ,
            ),
            textAlign: TextAlign.justify,),
          actions: <Widget>[
            FlatButton(
              child: Text('Annuler'),
              onPressed: () {
                //this.savAll();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Quitter'),
              onPressed: () {
                exit(0);
              },
            ),
          ],
        );
      },
    );
  }
}