import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:services/composants/components.dart';
import 'package:services/composants/services.dart';
import 'package:services/monprofile.dart';
import 'package:services/paiement/encaisser1.dart';
import 'package:services/paiement/historique.dart';
import 'package:services/paiement/payst.dart';
import 'package:services/paiement/retrait1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pays.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:async/async.dart';


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
  int flex4, flex6, taille, enlev, rest, enlev1, enl;
  double haut,ad, _taill,topi, bottomsolde,sold,topo22,top33, top34, top1, top, top2, top3,top4, topo1, topo2, hauteurcouverture, nomright, nomtop, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext;
  File _image;

  @override
  void initState(){
    this._lire();
    date = new DateTime.now();
    super.initState();
    _tabController = new TabController(length: 1, vsync: this);
    this._read();
    this.lire();
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
      _code = "";
    });
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
    double fromHeight, leftcagnotte, rightcagnotte, topcagnotte, bottomcagnotte, ad=100;
    if(_large<=320){
      fromHeight = 120;
      leftcagnotte = 20;
      rightcagnotte = 30;
      topcagnotte = 50; //espace entre mes tabs et le slider
      bottomcagnotte = 30;
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
      fromHeight = 130;
      leftcagnotte = 20;
      rightcagnotte = 40;
      topcagnotte = 50;
      bottomcagnotte = 50;
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
      fromHeight = 130;
      leftcagnotte = 20;
      rightcagnotte = 40;
      topcagnotte = 50;
      bottomcagnotte = 50;
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
      fromHeight = 130;
      leftcagnotte = 20;
      rightcagnotte = 40;
      topcagnotte = 50;
      bottomcagnotte = 50;
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
      fromHeight = 130;
      leftcagnotte = 20;
      rightcagnotte = 40;
      topcagnotte = 50;
      bottomcagnotte = 50;
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
      fromHeight = 130;
      leftcagnotte = 20;
      rightcagnotte = 40;
      topcagnotte = 50;
      bottomcagnotte = 40;
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
      /*routes:<String, WidgetBuilder>{
      "/connexion": (BuildContext context) =>new Profile(_code)
    },*/
      debugShowCheckedModeBanner: false,
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
                Text("Wilfried ASSAM ENGOZO'O", style: TextStyle(
                  color: Colors.white,
                  fontSize: taille_champ
                ),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.location_on,color: orange_F,size: 15,),
                    Text(" Yaoundé - Cameroun", style: TextStyle(
                        color: orange_F,
                        fontSize: taille_champ-2
                    ),),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 8, top: 8),
                  child: Text("0",style: TextStyle(
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
          ],
          iconTheme: new IconThemeData(color: Colors.white),
        ),
        drawer: _drawer(context),
         body: Stack(
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
                           image: AssetImage("images/ellipse1.png"),
                           fit: BoxFit.cover
                       )
                   ),
                 ),
               ),
             ),
             Padding(
               padding: EdgeInsets.only(top: 110, ),//solde du compte
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: <Widget>[
                   Text('SOLDE DU COMPTE', style: TextStyle(
                     color: Colors.white,
                     fontSize: taille_libelle_etape
                   ),),
                 ],
               ),
             ),
             Padding(
               padding: EdgeInsets.only(top: 125),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: <Widget>[
                   Text(solde==null?"1.500,0":getMillis('$solde'), style: TextStyle(//Montant du solde
                     color: orange_F,
                     fontSize: taille_titre+5,
                     fontWeight: FontWeight.bold
                   ),),
                   Text(solde==null?" XAF":getMillis('$solde'), style: TextStyle(//Montant du solde
                       color: orange_F,
                       fontSize: taille_titre+5,
                       fontWeight: FontWeight.bold
                   ),),
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
                                   child: new Image.asset('images/import_down_blue.png')),
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
                         child: GestureDetector(
                           onTap: (){
                             setState(() {
                               Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Retrait1('$_code')));
                             });
                           },
                           child: Column(
                             children: <Widget>[
                               Container(
                                   height: 50,
                                   width: 50,
                                   child: new Image.asset('images/import_up_blue.png')),
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
                                   child: new Image.asset('images/Groupe6.png')),
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
                             print("Hello: ${MediaQuery.of(context).size.width}");
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

                 Expanded(
                   flex: 6,
                   child: Padding(
                     padding: new EdgeInsets.only(top:top4, right: 20.0, left: 20.0),
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
                             //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: _Drawer()));
                           },
                           child: Column(
                             children: <Widget>[
                               Container(
                                   height: 50,
                                   width: 100,
                                   child: new Icon(Icons.add_shopping_cart, color: couleur_fond_bouton,size: 50,)),//Image.asset('images/ellipse1.png')),
                               Text('Market Place',
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
         bottomNavigationBar: bottomNavigate(context, enl),
      ),
    );
  }

  _drawer(BuildContext context){
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
                            image: AssetImage("images/ellipse1.png"),
                            fit: BoxFit.cover
                        )
                    ),
                  ),
                ),
                Text("Wilfried ASSAM ENGOZO'O", style: TextStyle(
                    color: Colors.white
                ),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.location_on, size: 20,color: couleur_fond_bouton,),
                    Text("Yaoundé - Cameroun", style: TextStyle(
                        color: couleur_champ,
                      fontSize: taille_champ
                    ),),
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
                      child: new Text('Mon profile',style: TextStyle(
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
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Monprofile("")));
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
                    child: Icon(Icons.lock_open, color: couleur_fond_bouton,),//Image.asset("images/ic_conditions.png")
                  ),
                  Expanded(
                    flex:11,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: new Text('Déconnection',style: TextStyle(
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
      final key = 'idUser';
      idUser = prefs.getString(key);
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
      idUser = prefs.getString(key)=='-1'?'-1':prefs.getString(key);
      this.getSolde();
    });
  }

  void save(String route) async {
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
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Pays()));
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

class _Drawer {
  _Drawer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new ListView(
        padding: EdgeInsets.zero,
        children: <Widget> [
          Container(
            height: 140,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage('images/banner.jpg'),
                  fit: BoxFit.cover,
                )),
          ),

          new ListTile(
            title: Padding(
              padding: EdgeInsets.only(left: 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex:1,
                      child: Icon(Icons.home, color: couleur_fond_bouton,)),//Image.asset("images/Groupe12.png")),
                  Expanded(
                    flex:11,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: new Text('Retour à l\'accueil',style: TextStyle(
                          color: bleu_F,
                          fontWeight: FontWeight.bold,
                          fontFamily: police_titre
                      ),),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Pays()));
              Navigator.pop(context);
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
                      child: Image.asset("images/Groupe11.png")),
                  Expanded(
                    flex:11,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: new Text('Comment ça marche',style: TextStyle(
                          color: bleu_F,
                          fontWeight: FontWeight.bold,
                          fontFamily: police_titre
                      ),),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {},
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
                      child: Image.asset("images/trace3.png")),
                  Expanded(
                    flex:11,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: new Text('A propos',style: TextStyle(
                          color: bleu_F,
                          fontWeight: FontWeight.bold,
                          fontFamily: police_titre
                      ),),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {},
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
                      child: Image.asset("images/ic_contact_service.png")),
                  Expanded(
                    flex:11,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: new Text('Service client',style: TextStyle(
                          color: bleu_F,
                          fontWeight: FontWeight.bold,
                          fontFamily: police_titre
                      ),),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
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
                      child: Image.asset("images/ic_conditions.png")),
                  Expanded(
                    flex:11,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: new Text('Conditions générales d\'utilisation',style: TextStyle(
                          color: bleu_F,
                          fontWeight: FontWeight.bold,
                          fontFamily: police_titre
                      ),),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
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