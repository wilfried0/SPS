import 'dart:convert';
import 'package:async/async.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:services/auth/connexion.dart';
import 'package:services/composants/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'composants/components.dart';


// ignore: must_be_immutable
class Monprofile extends StatefulWidget {
  Monprofile();
  @override
  _MonprofileState createState() => new _MonprofileState();
}

class _MonprofileState extends State<Monprofile> {
  _MonprofileState();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int currentPage = 0;
  bool masque;
  int choice = 0, indik=1;
  var _formKey = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  int recenteLenght, archiveLenght, populaireLenght, flex1, flex2, id_kitty, montant;
  bool isLoding = false, _isHidden = true,hadSentpieces, _isHidden1 = true, isLoadPiece = false, _isSelfie = false, _isRecto = false, _isVerso = false, _isAvatar = false;
  int flex4, flex6, taille, enlev, rest, enlev1, choix;
  double _tail, hauteurcouverture, nomright, nomtop, right1, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext, left1, social, topo, div1, div2, margeleft, margeright;
  String _image,nameStatus, _selfie, _recto, _verso, _username, _password, _password1, _password2, _passwordold, _url;
  var _nomController, _paysController, _villeController, _quartierController, _emailController, _contactController, _parrainController;
  var _categorie = ['Carte Nationale d\'identité', 'Passeport', 'Carte de séjour'];
  var _cat = ['Facture d\'eau', 'Facture d\'electricite', 'Bulletin de paye', 'Facture de telephone', 'Autre justificatif de revenu'];
  // ignore: non_constant_identifier_names
  String kittyImage,pieceName, _platformVersion, monstatus, momo_url, data, _email, ref, kittyId, country, firstnameBenef, url,momo, card, monnaie, paie_url, endDate, startDate, title, suggested_amount, amount, description, number, nom, email, tel, mot, _nom, _ville, _quartier, _pays;

  @override
  void initState() {
    super.initState();
    _url = "$base_url/user/getInfoKyc";
    _nomController = TextEditingController();
    _paysController = TextEditingController();
    _villeController = TextEditingController();
    _quartierController = TextEditingController();
    _emailController = TextEditingController();
    _contactController = TextEditingController();
    _parrainController = TextEditingController();
    this.checkStatus();
    this.lire();
  }
  

  @override
  void dispose() {
    _nomController.dispose();
    _paysController.dispose();
    _villeController.dispose();
    _quartierController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _parrainController.dispose();
    super.dispose();
  }

  void checkConnection(var body) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      //print("Connected to Mobile");
      setState(() {
        isLoadPiece = true;
      });
      sendPiece(body);
    } else if (connectivityResult == ConnectivityResult.wifi) {
      //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Connexion(_code)));
      setState(() {
        isLoadPiece = true;
      });
      sendPiece(body);
    } else {
      _ackAlert(context, -1);
    }
  }


  Future<String> changePass(String newPass) async {
    print('Username: $_username');
    print('Password: $_password');
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    var url = "$base_url/member/resetPassword/$newPass";
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.set('accept', 'application/json');
    request.headers.set('Authorization', 'Basic $credentials');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print("statusCode ${response.statusCode}");
    print("body $reply");
    if(response.statusCode == 200){
      var responseJson = json.decode(reply);
      int code = responseJson['code'];
      if(code == 200){
        setState(() {
          isLoding = false;
        });
        Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Connexion()));
      }else if(code == 100){
        setState(() {
          isLoding = false;
        });
        showInSnackBar("Service indisponible!", _scaffoldKey, 5);
      }else if(code == 101){
        setState(() {
          isLoding = false;
        });
        showInSnackBar("Utilisateur inexistant!", _scaffoldKey, 5);
      }
    }else{
      setState(() {
        isLoding = false;
      });
      showInSnackBar("Service indisponible!", _scaffoldKey, 5);
    }
    return null;
  }

  void _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('avatar', "$_image");
    print("saved $_image");
  }

  Future<String> sendPiece(var body) async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString("username");
    _password = prefs.getString("password");
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);

    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse("$base_url/sendPiece"));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json');
    request.headers.set('Authorization', 'Basic $credentials');
    request.add(utf8.encode(body));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print("statusCode ${response.statusCode}");
    print("body $reply");
      if (response.statusCode < 200 || json == null) {
        setState(() {
          isLoadPiece =false;
        });
      }else if(response.statusCode == 200){
        setState(() {
          isLoadPiece =false;
        });
        showInSnackBar("Pièces envoyées avec succès!\nVous pourrez effectuer vos opérations dès que vos pièces seront approuvées.", _scaffoldKey, 10);
      }else {
        setState(() {
          isLoadPiece =false;
        });
        showInSnackBar("Service indisponible!", _scaffoldKey, 5);
      }
      return null;
  }


  Future<void> _ackAlert(BuildContext context, int q) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(q == -1?'Oops!':'Caméra/Galerie'),
          content: Text(q == -1?'Vérifier votre connexion internet.':'Prendre l\'image depuis la Galerie ou la caméra'),
          actions: <Widget>[
            FlatButton(
              child: Text(q == -1?'Ok':'Galerie'),
              onPressed: () {
                if(q == 0){//Galerie pour avatar
                  Navigator.of(context).pop();
                  getImage(0);
                }else if(q == -1){
                  Navigator.of(context).pop();
                }else if(q == 1){//Galerie pour selfie
                  Navigator.of(context).pop();
                  getImage(1);
                }else if(q == 2){//Galerie pour recto
                  Navigator.of(context).pop();
                  getImage(2);
                }else if(q == 3){//Galerie pour recto
                  Navigator.of(context).pop();
                  getImage(3);
                }
              },
            ),
            q == -1?Container():FlatButton(
              child: Text('Caméra'),
              onPressed: () {
                if(q == 0){//Caméra pour l'avatar
                  Navigator.of(context).pop();
                  getImage(4);
                }else if(q == 1){//Caméra pour le selfie
                  Navigator.of(context).pop();
                  getImage(5);
                }else if(q == 2){//Caméra pour le recto
                  Navigator.of(context).pop();
                  getImage(6);
                }else if(q == 3){//Caméra pour le verso
                  Navigator.of(context).pop();
                  getImage(7);
                }
              },
            ),
            q == -1?Container():FlatButton(
                onPressed: (){
                  Navigator.of(context).pop();
                }, child: Text('Annuler')
            )
          ],
        );
      },
    );
  }

  lire() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString("username");
      _password = prefs.getString("password");
      _contactController.text = prefs.getString("username");
      _pays = prefs.getString("pays");
      _paysController.text = _pays;
      _nom = prefs.getString("nom");
      _nomController.text = _nom;
      _ville = prefs.getString("ville");
      _villeController.text = _ville;
      _quartier = prefs.getString("quartier");
      _quartierController.text = _quartier;
      _image = prefs.getString("avatar");
      _email = prefs.getString("email");
      _emailController.text = _email;
    });
  }

  void _toggleVisibility(){
    setState((){
      _isHidden = !_isHidden;
    });
  }

  void _toggleVisibility1(){
    setState((){
      _isHidden1 = !_isHidden1;
    });
  }

  Future<void> checkStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString("username");
    _password = prefs.getString("password");
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.getUrl(Uri.parse("$_url"));
    request.headers.set('accept', 'application/json');
    request.headers.set('Authorization', 'Basic $credentials');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print("statusCode ${response.statusCode}");
    print("body $reply");
    if(response.statusCode == 200){
      var responseJson = json.decode(reply);
      setState(() {
        hadSentpieces = responseJson['hadSentpieces'];
        nameStatus = responseJson['profil']['name'].toString().toUpperCase();
      });
    }
  }

  /*Future<void> checkStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString("username");
    _password = prefs.getString("password");
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    var headers = {
      "Accept": "application/json",
      "Authorization": "Basic $credentials"
    };
    var response = await http.get(Uri.encodeFull("$_url"), headers: headers,);
    if(response.statusCode == 200){
      print(response.body);
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        hadSentpieces = responseJson['hadSentpieces'];
        nameStatus = responseJson['profil']['name'].toString().toUpperCase();
      });
    }
  }*/

  Future<String> getImage(int q) async {
    var image;
      if(q == 0){
        image = await ImagePicker.pickImage(source: ImageSource.gallery);
        setState(() {
          _isAvatar = true;
        });
      }else if(q == 1){
        image = await ImagePicker.pickImage(source: ImageSource.gallery);
        setState(() {
          _isSelfie = true;
        });
      }else if(q == 2){
        image = await ImagePicker.pickImage(source: ImageSource.gallery);
        setState(() {
          _isRecto = true;
        });
      }else if(q == 3){
        image = await ImagePicker.pickImage(source: ImageSource.gallery);
        setState(() {
          _isVerso = true;
        });
      }else if(q == 4){
        print("q vaut: $q");
        image = await ImagePicker.pickImage(source: ImageSource.camera);
        setState(() {
          _isAvatar = true;
        });
      }else if(q == 5){
        image = await ImagePicker.pickImage(source: ImageSource.camera);
        print("hello selfie 5");
        setState(() {
          _isSelfie = true;
        });
      }else if(q == 6){
        image = await ImagePicker.pickImage(source: ImageSource.camera);
        setState(() {
          _isRecto = true;
        });
      }else if(q == 7){
        image = await ImagePicker.pickImage(source: ImageSource.camera);
        setState(() {
          _isVerso = true;
        });
      }
    print("%%%%%%%%%%%%%%%%%%%%%%%%%% $image");
      if(image == null){
        setState(() {
          _isAvatar = false;
          _isSelfie = false;
          _isRecto = false;
          _isVerso = false;
        });
      }else
      Upload(image, q);
    return null;
  }

  void Upload(File imageFile, int q) async {
    var _header = {
      "content-type" :  "multipart/form-data",
    };

    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var multipartFile = new http.MultipartFile('file', stream, length, filename: imageFile.path.split('/').last);
    var uri = Uri.parse('$base');
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(_header);
    request.files.add(multipartFile);
    //request.files.add(await http.MultipartFile.fromPath('file', imageFile.path, contentType: new MediaType('image', 'jpeg')));
    var response = await request.send();
    print('la valeur de q: $q');
    print('statuscode ${response.statusCode}');
    if(response.statusCode == 201){
      response.stream.transform(utf8.decoder).listen((value) {
        print("la valeur: $value");
        if(q == 0 || q == 4){
          setState(() {
            _image = value;
            _isAvatar = false;
          });
          _save();
        }else if(q == 1 || q == 5){
          setState(() {
            _selfie = value;
            _isSelfie = false;
          });
        }else if(q == 2 || q == 6){
          setState(() {
            _recto = value;
            _isRecto = false;
          });
        }else if(q == 3 || q == 7){
          setState(() {
            _verso = value;
            print("Mon verso $_verso");
            _isVerso = false;
            print("Mon versoooooo $value");
          });
        }
      });
    }else{
      response.stream.transform(utf8.decoder).listen((value) {
        print("la valeur: $value");
      });
      if(q == 0 || q == 4){
        setState(() {
          _isAvatar = false;
        });
      }else if(q == 1 || q == 5){
        setState(() {
          _isSelfie = false;
        });
      }else if(q == 2 || q == 6){
        setState(() {
          _isRecto = false;
        });
      }else if(q == 3 || q == 7){
        setState(() {
          _isVerso = false;
        });
      }
      showInSnackBar("Veuillez sélectionner une image de petite taille", _scaffoldKey, 5);
    }
  }

  /*Future<File> compressNow(File _imageFile, int q) async {

    print("FILE SIZE BEFORE: " + _imageFile.lengthSync().toString());
    var result = await FlutterImageCompress.compressAndGetFile(
      _imageFile.absolute.path,
      '${_imageFile.absolute.path.replaceFirst(".", "_.", _imageFile.absolute.path.lastIndexOf("."))}',
      minHeight: int.tryParse('${MediaQuery.of(context).size.width.toString()}'),
      minWidth: int.tryParse('${MediaQuery.of(context).size.width.toString()}'),
      quality: 80,
    );
    print("FILE SIZE BEFORE: " + result.lengthSync().toString());
    Upload(result, q);
    return result;
  }*/


  @override
  Widget build(BuildContext context) {
    final _large = MediaQuery.of(context).size.width;
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
      flex1 = 8;
      flex2 = 4;
    }else if(_large>320 && _large<=360){
      left1 = 0;
      right1 = 150;
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
      div1 = 388;
      margeleft = 12.5;
      margeright = 12.5;
      flex1 = 8;
      flex2 = 3;
    }else if(_large == 375){
      flex1 = 8;
      flex2 = 4;
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
      margeleft = 13;
      margeright = 13;
    }else if(_large>360){
      flex1 = 9;
      flex2 = 3;
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
    }
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new DefaultTabController(
        length: 1,
        child: new Scaffold(
          key: _scaffoldKey,
          body: _buildCarousel(context),
          //bottomNavigationBar: bottomNavigate(context, _code, choix, getWidgetTontine(choix, context), Verification(_code), Pays()),
        ),
      ),
    );
  }


  _buildCarousel(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                //borderRadius: BorderRadius.circular(10.0)
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  height: 215,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                        color: bleu_F
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            onTap: (){
                              _ackAlert(context, 0);
                            },
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: _image==null || _image=="null"? AssetImage("images/ellipse1.png"):NetworkImage(_image),
                                      fit: BoxFit.cover
                                  ),
                                border: new Border.all(
                                  color: Colors.white,
                                  width: 5.0,
                                ),
                              ),
                              child:_image==null || _image=="null"?Container(): Image.network(_image, fit: BoxFit.contain,
                                  loadingBuilder: (BuildContext ctx, Widget child, ImageChunkEvent loadingProgress){
                                    if (loadingProgress == null) return Container();
                                    return Center(
                                      child: CircularProgressIndicator(backgroundColor: bleu_F,
                                        value: loadingProgress.expectedTotalBytes != null ?
                                        loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                            : null,
                                      ),
                                    );
                                  }
                              ),
                            ),
                          ),

                          /*Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(_nom==null?"":"$_nom", style: TextStyle(
                                color: Colors.white,
                                fontSize: taille_champ+3
                            ),),
                          ),*/
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _quartier=="null" && _ville=="null" && _pays=="null"?Container():Container(),//Icon(Icons.location_on,color: orange_F,size: 15,),
                              /*Row(
                                children: <Widget>[
                                  Text(_quartier=="null"?"":" $_quartier -", style: TextStyle(
                                      color: orange_F,
                                      fontSize: taille_champ
                                  ),),
                                  Text(_ville=="null"?"":" $_ville -", style: TextStyle(
                                      color: orange_F,
                                      fontSize: taille_champ
                                  ),),
                                  Text(_pays=="null"?"":" $_pays", style: TextStyle(
                                      color: orange_F,
                                      fontSize: taille_champ
                                  ),),
                                ],
                              ),*/
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: new EdgeInsets.only(
                      top: 150,
                      right:0.0,
                      left: MediaQuery.of(context).size.width-70),
                  child: _isAvatar == false? InkWell(
                      onTap: (){
                        _ackAlert(context, 0);
                      },
                      child: Icon(Icons.camera_alt,size: 50, color: Colors.white,)):
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                      child: CupertinoActivityIndicator(radius: 20,)
                  ),
                ),

                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: new Container(
                    child: Padding(
                      padding: new EdgeInsets.only(top: 40, left: 20),
                      child: Icon(Icons.arrow_back_ios,color: Colors.white,),
                    ),
                  ),
                ),
                getView(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getMoyen(int index){
    String text;
    switch(index){
      case 0: text = "MES INFOS";
      break;
      case 1: text = "PARRAINAGE";
      break;
      case 2: text = "SÉCURITÉ";
      break;
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      //height: 70,
      decoration: BoxDecoration(
        borderRadius: new BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
        ),
        //color: couleur_fond_bouton,
        border: Border.all(
            color: couleur_fond_bouton,
            width: 2
        ),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: getIcon(choice),
          ),
          Text("$text",
            style: TextStyle(
                color:orange_F,
                fontSize: _tail,
                fontWeight: FontWeight.bold
            ),)
        ],
      ),
    );
  }

  Widget getIcon(int index){
    switch(index){
      case 0: return Icon(
        Icons.person,
        color: orange_F,
        size: 40,
      );
      case 1: return Icon(
        Icons.supervised_user_circle,
        color: orange_F,
        size: 40,
      );
      case 2: return Icon(
        Icons.security,
        color: orange_F,
        size: 40,
      );

      default: return Container();
    }
  }

  Widget getView(){
    //if(choice == 0){
    return Padding(
        padding: EdgeInsets.only(top: 210, left: 0, right: 0),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 20, left: 0, right: 0),
              child: CarouselSlider(
                enlargeCenterPage: true,
                autoPlay: false,
                enableInfiniteScroll: true,
                onPageChanged: (value){
                  setState(() {
                    choice = value;
                    print(choice);
                  });
                },
                height: 80.0,
                items: [0,1,2].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return getMoyen(i);
                    },
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top:90),
              child: SingleChildScrollView(
                child:choice == 0? Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Container(
                        margin: EdgeInsets.only(top: 0.0),
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                          color: Colors.transparent,
                          border: Border.all(
                            width: .5,
                            color: couleur_fond_bouton,
                          ),
                        ),
                        height: 50,
                        child: Row(
                          children: <Widget>[
                            new Expanded(
                              flex:2,
                              child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: new Icon(Icons.person, color: couleur_champ,)
                              ),
                            ),
                            new Expanded(
                              flex:10,
                              child: Padding(
                                padding: EdgeInsets.only(left:0.0),
                                child: new TextFormField(
                                  controller: _nomController,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    fontSize: taille_champ+3,
                                    color: Colors.black,
                                  ),
                                  validator: (String value){
                                    if(value.isEmpty){
                                      return "Champ prénom et nom vide !";
                                    }else{
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'prénom (s) et nom(s)',
                                    hintStyle: TextStyle(color: Colors.grey,
                                      fontSize: taille_champ+3,
                                    ),
                                    //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                      child: Container(
                        margin: EdgeInsets.only(top: 0.0),
                        decoration: new BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            width: .5,
                            color: couleur_fond_bouton,
                          ),
                        ),
                        height: 50,
                        child: Row(
                          children: <Widget>[
                            new Expanded(
                              flex:2,
                              child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: new Icon(Icons.location_on, color: couleur_champ,)
                              ),
                            ),
                            new Expanded(
                              flex:10,
                              child: Padding(
                                padding: EdgeInsets.only(left:0.0),
                                child: new TextFormField(
                                  controller: _paysController,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                      fontSize: taille_champ+3,
                                      color: Colors.black
                                  ),
                                  validator: (String value){
                                    if(value.isEmpty){
                                      return "Champ pays vide !";
                                    }else{
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'Pays de résidence',
                                    hintStyle: TextStyle(color: Colors.grey,
                                      fontSize: taille_champ+3,
                                    ),
                                    //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                      child: Container(
                        margin: EdgeInsets.only(top: 0.0),
                        decoration: new BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            width: .5,
                            color: couleur_fond_bouton,
                          ),
                        ),
                        height: 50,
                        child: Row(
                          children: <Widget>[
                            new Expanded(
                              flex:2,
                              child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: new Icon(Icons.add_location, color: couleur_champ,)
                              ),
                            ),
                            new Expanded(
                              flex:10,
                              child: Padding(
                                padding: EdgeInsets.only(left:0.0),
                                child: new TextFormField(
                                  controller: _ville=="null"||_ville==null?null:_villeController,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                      fontSize: taille_champ+3,
                                      color: Colors.black
                                  ),
                                  validator: (String value){
                                    if(value.isEmpty){
                                      return "Champ ville vide !";
                                    }else{
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'Ville de résidence',
                                    hintStyle: TextStyle(color: Colors.grey,
                                      fontSize: taille_champ+3,
                                    ),
                                    //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                      child: Container(
                        margin: EdgeInsets.only(top: 0.0),
                        decoration: new BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            width: .5,
                            color: couleur_fond_bouton,
                          ),
                        ),
                        height: 50,
                        child: Row(
                          children: <Widget>[
                            new Expanded(
                              flex:2,
                              child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: new Icon(Icons.directions, color: couleur_champ,)
                              ),
                            ),
                            new Expanded(
                              flex:10,
                              child: Padding(
                                padding: EdgeInsets.only(left:0.0),
                                child: new TextFormField(
                                  controller: _quartier == "null" || _quartier == null ?null:_quartierController,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    fontSize: taille_champ+3,
                                    color: Colors.black,
                                  ),
                                  validator: (String value){
                                    if(value.isEmpty){
                                      return "Quartier vide";
                                    }else{
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'Quartier de résidence',
                                    hintStyle: TextStyle(color: Colors.grey,
                                      fontSize: taille_champ+3,
                                    ),
                                    //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                      child: Container(
                        margin: EdgeInsets.only(top: 0.0),
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                          color: Colors.transparent,
                          border: Border.all(
                            width: .5,
                            color: couleur_fond_bouton,
                          ),
                        ),
                        height: 50,
                        child: Row(
                          children: <Widget>[
                            new Expanded(
                              flex:2,
                              child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: new Icon(Icons.email, color: couleur_champ,)
                              ),
                            ),
                            new Expanded(
                              flex:10,
                              child: Padding(
                                padding: EdgeInsets.only(left:0.0),
                                child: new TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                    fontSize: taille_champ+3,
                                    color: Colors.black,
                                  ),
                                  validator: (String value){
                                    if(value.isEmpty){
                                      return "Champ email vide !";
                                    }else{
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'Email',
                                    hintStyle: TextStyle(color: Colors.grey,
                                      fontSize: taille_champ+3,
                                    ),
                                    //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    /*Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                      child: Container(
                        margin: EdgeInsets.only(top: 0.0),
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                          color: Colors.transparent,
                          border: Border.all(
                            width: .5,
                            color: couleur_fond_bouton,
                          ),
                        ),
                        height: 50,
                        child: Row(
                          children: <Widget>[
                            new Expanded(
                              flex:2,
                              child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: new Icon(Icons.phone_android, color: couleur_champ,)
                              ),
                            ),
                            new Expanded(
                              flex:10,
                              child: Padding(
                                padding: EdgeInsets.only(left:0.0),
                                child: new TextFormField(
                                  controller: _contactController,
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(
                                    fontSize: taille_champ+3,
                                    color: Colors.black,
                                  ),
                                  validator: (String value){
                                    if(value.isEmpty){
                                      return "Champ téléphone vide !";
                                    }else{
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'Contact téléphonique',
                                    hintStyle: TextStyle(color: Colors.grey,
                                      fontSize: taille_champ+3,
                                    ),
                                    //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),*/
                    Padding(
                      padding: const EdgeInsets.only(top:20,bottom: 20, right: 20, left: 20),
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            showInSnackBar("Service pas encore disponible.", _scaffoldKey, 5);
                            //isLoding = true;
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
                            borderRadius: new BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0),
                            ),
                          ),
                          child: new Center(
                            child:isLoding==false?new Text('Modifier  mon profil', style: new TextStyle(fontSize: taille_champ+3, color: couleur_text_bouton),):CupertinoActivityIndicator(),
                          ),
                        ),
                      ),
                    ),

                    nameStatus !="OCCASIONNEL"?Container(): Padding(
                      padding: EdgeInsets.only(top: 0),
                      child:_selfie==null?GestureDetector(
                        onTap: () async {
                          _ackAlert(context, 1);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            _isSelfie == false?Icon(Icons.camera_alt, color: couleur_champ,size: 250,):CupertinoActivityIndicator(radius: 40,),
                            Padding(
                              padding: EdgeInsets.only(top: 205),
                              child: Text("Ma photo", style: TextStyle(
                                  color: couleur_fond_bouton,
                                  fontSize: taille_champ+3
                              ),),
                            )
                          ],
                        ),
                      ): Column(
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.width,
                            //width: 200,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                    image: NetworkImage(_selfie),
                                    fit: BoxFit.cover,
                                )
                            ),
                            child: Image.network(_selfie, fit: BoxFit.contain,
                              loadingBuilder: (BuildContext ctx, Widget child, ImageChunkEvent loadingProgress){
                                if (loadingProgress == null) return Container();
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null ?
                                    loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                        : null,
                                  ),
                                );
                              }
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              _ackAlert(context, 1);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Modifier le selfie"),
                                Icon(Icons.camera_alt, color: couleur_champ,size: 50,),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    nameStatus != "OCCASIONNEL"?Container():Padding(
                      padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                      child: Container(
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                          ),
                          color: Colors.transparent,
                          border: Border.all(
                              color: couleur_bordure,
                              width: bordure
                          ),
                        ),
                        height: hauteur_champ,
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              icon: Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: new Icon(Icons.arrow_drop_down_circle,
                                  color: couleur_fond_bouton,),
                              ),
                              isDense: true,
                              elevation: 1,
                              isExpanded: true,
                              onChanged: (String selected){
                                setState(() {
                                  pieceName = "$selected";
                                });
                              },
                              value: pieceName,
                              hint: Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text('Choisissez la nature de votre pièce d\'identité',
                                  style: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize:taille_champ+3,
                                  ),),
                              ),
                              items: _categorie.map((String name){
                                return DropdownMenuItem<String>(
                                  value: name,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text(name,
                                      style: TextStyle(
                                          color: couleur_libelle_champ,
                                          fontSize:taille_champ+3,
                                          fontWeight: FontWeight.normal
                                      ),),
                                  ),
                                );
                              }).toList(),
                            )
                        ),
                      ),
                    ),

                    nameStatus != "PERMANENT"?Container():Padding(
                      padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                      child: Container(
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                          ),
                          color: Colors.transparent,
                          border: Border.all(
                              color: couleur_bordure,
                              width: bordure
                          ),
                        ),
                        height: hauteur_champ,
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              icon: Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: new Icon(Icons.arrow_drop_down_circle,
                                  color: couleur_fond_bouton,),
                              ),
                              isDense: true,
                              elevation: 1,
                              isExpanded: true,
                              onChanged: (String selected){
                                setState(() {
                                  pieceName = "$selected";
                                });
                              },
                              value: pieceName,
                              hint: Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text('Choisissez la nature de votre pièce justificative',
                                  style: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize:taille_champ+3,
                                  ),),
                              ),
                              items: _cat.map((String name){
                                return DropdownMenuItem<String>(
                                  value: name,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text(name,
                                      style: TextStyle(
                                          color: couleur_libelle_champ,
                                          fontSize:taille_champ+3,
                                          fontWeight: FontWeight.normal
                                      ),),
                                  ),
                                );
                              }).toList(),
                            )
                        ),
                      ),
                    ),


                    nameStatus =="BUSINESS"?Container():Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: GestureDetector(
                        onTap: () async {
                          _ackAlert(context, 2);
                          //getImage(2);
                        },
                        child: Container(
                          height: 40,
                          color: orange_F,
                          child: Center(child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(nameStatus =="PERMANENT"?"Pièce justificative":"Recto de votre pièce d'identité", style: TextStyle(
                                  color: Colors.white,
                                  fontSize: taille_champ+3
                              ),),
                              _isRecto == false?Icon(Icons.attach_file, color: Colors.white,):CupertinoActivityIndicator()
                            ],
                          )),
                        ),
                      ),
                    ),
//nameStatus =="PERMANENT"||nameStatus =="BUSINESS"?Container():
                    _recto==null?Container():
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Container(
                        height: MediaQuery.of(context).size.width,
                        //width: 200,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                image: NetworkImage(_recto),
                                fit: BoxFit.cover
                            )
                        ),
                        child: Image.network(_recto, fit: BoxFit.contain,
                            loadingBuilder: (BuildContext ctx, Widget child, ImageChunkEvent loadingProgress){
                              if (loadingProgress == null) return Container();
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null ?
                                  loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                      : null,
                                ),
                              );
                            }
                        ),
                      ),
                    ),

                    nameStatus !="OCCASIONNEL"?Container():Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: GestureDetector(
                        onTap: () async {
                          _ackAlert(context, 3);
                          //getImage(3);
                        },
                        child: Container(
                          height: 40,
                          color: orange_F,
                          child: Center(child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Verso de votre pièce d'identité", style: TextStyle(
                                  color: Colors.white,
                                  fontSize: taille_champ+3
                              ),),
                              _isVerso == false?Icon(Icons.attach_file, color: Colors.white,):CupertinoActivityIndicator()
                            ],
                          )),
                        ),
                      ),
                    ),
                    _verso==null?Container():
                    Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Container(
                        height: MediaQuery.of(context).size.width,
                        //width: 200,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                image: NetworkImage(_verso),
                                fit: BoxFit.cover
                            )
                        ),
                        child: Image.network(_verso, fit: BoxFit.contain,
                            loadingBuilder: (BuildContext ctx, Widget child, ImageChunkEvent loadingProgress){
                              if (loadingProgress == null) return Container();
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null ?
                                  loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                      : null,
                                ),
                              );
                            }
                        ),
                      ),
                    ),

                    nameStatus=="BUSINESS"?Container():Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
                      child: GestureDetector(
                        onTap: () {
                            if(nameStatus == "OCCASIONNEL"){
                              if(pieceName == null){
                                showInSnackBar("Veuillez choisir la nature de la pièce à enregistrer", _scaffoldKey, 5);
                              }else{
                                if(_selfie == null || _recto == null || _verso == null){
                                  showInSnackBar("Veuillez entrer toutes les 3 pièces jointes (photo, recto et le verso de la pièce d'identité)", _scaffoldKey, 5);
                                }else{
                                  Composantes composante1, composante2, composante3;
                                  composante1 = new Composantes(
                                      fileUrl: "$_selfie",
                                      name: "selfie"
                                  );
                                  composante2 = new Composantes(
                                      fileUrl: "$_recto",
                                      name: "recto"
                                  );
                                  composante3 = new Composantes(
                                      fileUrl: "$_verso",
                                      name: "verso"
                                  );
                                  List<Composantes> composantes = [composante1,composante2,composante3];
                                  var piece = new Piece(
                                      composantes: composantes,
                                      pieceName: pieceName!="Carte Nationale d'identité"?pieceName:"CNI"
                                  );
                                  print(json.encode(piece));
                                  checkConnection(json.encode(piece));
                                }
                              }
                            }else{
                              setState(() {
                                if(pieceName != null){
                                  if(_recto == null){
                                    showInSnackBar("Veuillez filmer/charger la pièce justificative", _scaffoldKey, 5);
                                  }else{
                                    Composantes composante1;
                                    composante1 = new Composantes(
                                        fileUrl: "$_recto",
                                        name: "piece"
                                    );

                                    List<Composantes> composantes = [composante1];
                                    var piece = new Piece(
                                        composantes: composantes,
                                        pieceName: pieceName
                                    );
                                    print(json.encode(piece));
                                    checkConnection(json.encode(piece));
                                  }
                                }else{
                                  showInSnackBar("Veuillez choisir la nature de la pièce à enregistrer", _scaffoldKey, 5);
                                }
                              });
                            }
                        },
                        child: Container(
                          decoration: new BoxDecoration(
                            color: couleur_fond_bouton,
                            borderRadius: new BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0),
                            ),
                          ),
                          height: 50,
                          child: Center(
                              child:isLoadPiece==false? Text(nameStatus=="PERMANENT"?"Valider ma pièce":"Valider mes pièces", style: TextStyle(color: Colors.white, fontSize: taille_champ+3),):
                              CupertinoActivityIndicator()
                          ),
                        ),
                      ),
                    )
                  ],
                ):choice == 1?Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Container(
                        margin: EdgeInsets.only(top: 0.0),
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                          color: Colors.transparent,
                          border: Border.all(
                            width: .5,
                            color: couleur_fond_bouton,
                          ),
                        ),
                        height: 50,
                        child: Row(
                          children: <Widget>[
                            new Expanded(
                              flex:4,
                              child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: new CountryCodePicker(
                                    showFlag: true,
                                    searchStyle: TextStyle(
                                        color: couleur_champ,
                                        fontSize: taille_champ+3
                                    ),
                                    onChanged: (code){

                                    },
                                  )
                              ),
                            ),
                            new Expanded(
                              flex:8,
                              child: Padding(
                                padding: EdgeInsets.only(left:0.0),
                                child: new TextFormField(
                                  controller: _parrainController,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    fontSize: taille_champ+3,
                                    color: Colors.black,
                                  ),
                                  validator: (String value){
                                    if(value.isEmpty){
                                      return "Contact du parrain vide !";
                                    }else{
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'Contact du parrain',
                                    hintStyle: TextStyle(color: Colors.grey,
                                      fontSize: taille_champ+3,
                                    ),
                                    //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:20,bottom: 20, right: 20, left: 20),
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            isLoding = true;
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
                            borderRadius: new BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0),
                            ),
                          ),
                          child: new Center(//580255
                            child:isLoding==false?new Text('Valider', style: new TextStyle(fontSize: taille_champ+3, color: couleur_text_bouton),):CupertinoActivityIndicator(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ):Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Container(
                          margin: EdgeInsets.only(top: 0.0),
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                            color: Colors.transparent,
                            border: Border.all(
                              width: .5,
                              color: couleur_fond_bouton,
                            ),
                          ),
                          height: 50,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex:2,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: new Icon(Icons.vpn_key, color: couleur_description_champ,),
                                ),
                              ),
                              new Expanded(
                                flex:10,
                                //child: Padding(

                                child: new TextFormField(
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                      fontSize: taille_champ+3,
                                      color: couleur_libelle_champ
                                  ),
                                  validator: (String value){
                                    if(value.isEmpty){
                                      return 'Champ mot de passe vide !';
                                    }else{
                                      _passwordold = value;
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'Ancien mot de passe',
                                    hintStyle: TextStyle(color: couleur_libelle_champ,
                                        fontSize: taille_champ+3),
                                    //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                  ),
                                  obscureText: _isHidden1,
                                  /*textAlign: TextAlign.end,*/
                                ),
                                //),
                              ),
                              Expanded(
                                flex:2,
                                child: new IconButton(
                                  onPressed: _toggleVisibility1,
                                  icon: _isHidden1? new Icon(Icons.visibility_off,):new Icon(Icons.visibility,),
                                  color: couleur_bordure,
                                  iconSize: 20.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Container(
                          margin: EdgeInsets.only(top: 0.0),
                          decoration: new BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              width: .5,
                              color: couleur_fond_bouton,
                            ),
                          ),
                          height: 50,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex:2,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: new Icon(Icons.vpn_key, color: couleur_description_champ,),
                                ),
                              ),
                              new Expanded(
                                flex:10,
                                child: new TextFormField(
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                      fontSize: taille_champ+3,
                                      color: couleur_libelle_champ
                                  ),
                                  validator: (String value){
                                    if(value.isEmpty){
                                      return 'Champ mot de passe vide !';
                                    }else{
                                      _password1 = value;
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'Nouveau mot de passe',
                                    hintStyle: TextStyle(color: couleur_libelle_champ,
                                        fontSize: taille_champ+3),
                                    //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                  ),
                                  obscureText: _isHidden,
                                  /*textAlign: TextAlign.end,*/
                                ),
                                //),
                              ),
                              Expanded(
                                flex:2,
                                child: new IconButton(
                                  onPressed: _toggleVisibility,
                                  icon: _isHidden? new Icon(Icons.visibility_off,):new Icon(Icons.visibility,),
                                  color: couleur_bordure,
                                  iconSize: 20.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                        child: Container(
                          margin: EdgeInsets.only(top: 0.0),
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                            ),
                            color: Colors.transparent,
                            border: Border.all(
                              width: .5,
                              color: couleur_fond_bouton,
                            ),
                          ),
                          height: 50,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex:2,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: new Icon(Icons.vpn_key, color: couleur_description_champ),
                                ),
                              ),
                              new Expanded(
                                flex:10,
                                //child: Padding(

                                child: new TextFormField(
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                      fontSize: taille_champ+3,
                                      color: couleur_libelle_champ
                                  ),
                                  validator: (String value){
                                    if(value.isEmpty){
                                      return 'Champ vérification mot de passe vide !';
                                    }else{
                                      _password2 = value;
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'Vérification du mot de passe',
                                    hintStyle: TextStyle(color: couleur_libelle_champ,
                                        fontSize: taille_champ+3),
                                    //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                  ),
                                  obscureText: _isHidden,
                                  /*textAlign: TextAlign.end,*/
                                ),
                                //),
                              ),
                              Expanded(
                                flex:2,
                                child: new IconButton(
                                  onPressed: _toggleVisibility,
                                  icon: _isHidden? new Icon(Icons.visibility_off,):new Icon(Icons.visibility,),
                                  color: couleur_bordure,
                                  iconSize: 20.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:20,bottom: 20, right: 20, left: 20),
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              if(_formKey.currentState.validate()){
                                if(_password != _passwordold){
                                  showInSnackBar("L'ancien mot de passe n'est pas correct!", _scaffoldKey, 5);
                                }else{
                                  if(_password1 == _password2){
                                    isLoding = true;
                                    this.changePass(_password1);
                                  }else{
                                    showInSnackBar("Les mots de passe ne sont pas identiques!", _scaffoldKey, 5);
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
                              borderRadius: new BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                                topLeft: Radius.circular(10.0),
                              ),
                            ),
                            child: new Center(
                              child:isLoding==false?new Text('Modifier mon mot de passe', style: new TextStyle(fontSize: taille_champ+3, color: couleur_text_bouton,),):CupertinoActivityIndicator(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }
}