import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'connexion.dart';
import 'package:http/http.dart' as http;
import 'activation.dart';
import 'package:services/composants/components.dart';

// ignore: must_be_immutable
class Inscription1 extends StatefulWidget {
  Inscription1(this._code);
  String _code;
  @override
  _Inscription1State createState() => new _Inscription1State(_code);
}

class _Inscription1State extends State<Inscription1> {
  _Inscription1State(this._code);
  String _code;
  bool _check1=false, _check2=false;
  String _password, _verfiPassword, _url, iso3;
  var _usernameController = new TextEditingController();
  String _username, urlPath = "";
  var _formKey = GlobalKey<FormState>(), flagUri;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isHidden = true, isLoding = false;
  int idUser;

  lire() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      flagUri = prefs.getString("flag");
      _username = prefs.getString("username");
      iso3 = prefs.getString("iso3");
      print(iso3);
      _usernameController.text = _username;
    });
  }


  bool myInterceptor(bool stopDefaultButtonEvent) {
    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Connexion()));
    return true;
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


  void _reg() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('password', "$_password");
  }

  void reg() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('idUser', "$idUser");
  }

  void checkConnection(var body) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        isLoding =true;
        createMember(body);
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        isLoding =true;
        createMember(body);
      });
    } else {
      ckAlert(context);
    }
  }

  Future<String> createMember(var body) async {
    var _header = {
      "accept": "application/json",
      "content-type" : "application/json"
    };
    return await http.post(_url, body: body, headers: _header, encoding: Encoding.getByName("utf-8")).then((http.Response response) {
      final int statusCode = response.statusCode;
      print('voici le statusCode $statusCode');
      print('voici le body ${response.body}');
      if (statusCode < 200 || json == null) {
        setState(() {
          isLoding =false;
        });
        //throw new Exception("Error while fetching data");
      }else if(statusCode == 200){
        var responseJson = json.decode(response.body);
        idUser = responseJson['id_user'];
        if(responseJson['username'] == "USERNAME_ALREADY_USED"){
          setState(() {
            isLoding =false;
          });
          //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Activation()));
          showInSnackBar("Utilisateur déjà existant!", _scaffoldKey);
        }else{
          this.reg();
          setState(() {
            isLoding =false;
          });
          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Activation()));
        }
      }else {
        setState(() {
          isLoding =false;
        });
        showInSnackBar("$statusCode ${response.body}", _scaffoldKey);
      }
      return response.body;
    });
  }

  Future<void> ckAlert(BuildContext context) {
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
  void initState(){
    //BackButtonInterceptor.add(myInterceptor);
    this.lire();
    super.initState();
    _url = "$base_url/member/createMemberTemp";
    getPdfFromUrl("https://sprint-pay.com/wp-content/uploads/2018/11/CGU-Afrique-CEMAC-%E2%80%93-Sprint-Pay-2018.pdf").then((f) {
      urlPath = f.path;
    });
  }

  void _toggleVisibility(){
    setState((){
      _isHidden = !_isHidden;
    });
  }

  @override
  void dispose() {
    super.dispose();
    //BackButtonInterceptor.remove(myInterceptor);
  }



  bool isEmail(String em) {
    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }

  int ad = 3;

  @override
  Widget build(BuildContext context) {
    final marge = (5*MediaQuery.of(context).size.width)/414;

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: couleur_appbar,
        flexibleSpace: barreTop,
        leading: GestureDetector(
            onTap: (){
              setState(() {
                Navigator.pop(context);
                //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Connexion(_code)));
                //Navigator.of(context).push(SlideLeftRoute(enterWidget: Connexion(_code), oldWidget: Inscription(_code)));
              });
            },
            child: Icon(Icons.arrow_back_ios,)),
        iconTheme: new IconThemeData(color: couleur_fond_bouton),
      ),
      body:ListView(
        children: <Widget>[
          Container(
            height: hauteur_logo,
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 40.0, right: 40.0),
              child: new Image.asset('images/logo.png'),
            ),
          ),

          Padding(padding: EdgeInsets.only(top: marge_apres_logo),),

          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: new Text("Inscrivez-vous.\nC'est gratuit",
                  style: TextStyle(
                      color: couleur_titre,
                      fontSize: taille_titre,
                      fontWeight: FontWeight.bold
                  )),
            ),
          ),

          Padding(padding: EdgeInsets.only(top: marge_apres_titre),),

          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Coordonnées de connexion",
                      style: TextStyle(
                          color: couleur_libelle_champ,
                          fontSize: taille_libelle_champ+ad,
                          fontWeight: FontWeight.bold
                      ),),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: marge_libelle_champ),),

                /*Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Votre mot de passe doit comporter au moins 8 caractères',
                      style: TextStyle(
                          color: couleur_description_champ,
                          fontSize: taille_description_champ+ad
                      ),),
                  ),
                ),*/

                Padding(padding: EdgeInsets.only(top: marge_libelle_champ),),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                      color: Colors.transparent,
                      border: Border.all(
                          width: bordure,
                          color: couleur_bordure
                      ),
                    ),
                    height: hauteur_champ,
                    child: Padding(
                      padding: EdgeInsets.only(left: 0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex:2,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child:flagUri==null?Container(): new Image.asset('$flagUri'),
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: TextFormField(
                              enabled: false,
                              controller: _usernameController,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                  fontSize: taille_libelle_champ+ad,
                                  color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return 'Téléphone vide !';
                                }else{
                                  //tel = '$value';
                                  //_userTextController3.text = tel;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Contact téléphonique',
                                hintStyle: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize: taille_libelle_champ+ad
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 0.0),
                    decoration: new BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                          width: bordure,
                          color: couleur_bordure
                      ),
                    ),
                    height: hauteur_champ,
                    child: Padding(
                      padding: EdgeInsets.only(left: marge,),
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                            flex:2,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: new Image.asset('images/Groupe180.png'),
                            ),
                          ),
                          new Expanded(
                            flex:10,
                            child: Padding(
                              padding: EdgeInsets.only(left:marge),
                              child: new TextFormField(
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                    fontSize: taille_champ+ad,
                                    color: couleur_libelle_champ,
                                ),
                                validator: (String value){
                                  if(value.isEmpty){
                                    return 'Champ mot de passe vide !';
                                  }else/* if(value.length>=7){
                                    _password = value;
                                    return null;
                                  }else*/{
                                    _password = value;
                                    return null;
                                  }
                                },
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Mot de passe',
                                  hintStyle: TextStyle(color: couleur_libelle_champ, fontSize: taille_champ+ad,),
                                  //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                ),
                                obscureText: _isHidden,
                                /*textAlign: TextAlign.end,*/
                              ),
                            ),
                          ),
                          Expanded(
                            flex:2,
                            child: new IconButton(
                              onPressed: _toggleVisibility,
                              icon: _isHidden? new Icon(Icons.visibility_off,):new Icon(Icons.visibility,),
                              color: couleur_titre,
                              iconSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 0.0),
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                      color: Colors.transparent,
                      border: Border.all(
                          width: bordure,
                          color: couleur_bordure
                      ),
                    ),
                    height: hauteur_champ,
                    child: Padding(
                      padding: EdgeInsets.only(left: marge,),
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                            flex:2,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: new Image.asset('images/Groupe180.png'),
                            ),
                          ),
                          new Expanded(
                            flex:10,
                            child: Padding(
                              padding: EdgeInsets.only(left:marge),
                              child: new TextFormField(
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                    fontSize: taille_champ+ad,
                                    color: couleur_libelle_champ,
                                ),
                                validator: (String value){
                                  if(value.isEmpty){
                                    return 'Vérification du mot de passe vide !';
                                  }else{
                                    _verfiPassword = value;
                                    if(_verfiPassword == _password){
                                      return null;
                                    }else{
                                      return 'Les mots de passe ne sont pas identiques';
                                    }
                                  }
                                },
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Vérification du mot de passe',
                                  hintStyle: TextStyle(color: couleur_libelle_champ,fontSize: taille_champ+ad,),
                                  //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                ),
                                obscureText: _isHidden,
                                /*textAlign: TextAlign.end,*/
                              ),
                            ),
                          ),
                          Expanded(
                            flex:2,
                            child: new IconButton(
                              onPressed: _toggleVisibility,
                              icon: _isHidden? new Icon(Icons.visibility_off,):new Icon(Icons.visibility,),
                              color: couleur_titre,
                              iconSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(padding: EdgeInsets.only(top: marge_champ_libelle),),

                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 20),
                  child: Row(
                    children: <Widget>[
                      Checkbox(
                          activeColor: couleur_fond_bouton,
                          value: _check1,
                          onChanged: (bool val){
                            setState(() {
                              _check1 = val;
                            });
                          }
                      ),
                      GestureDetector(
                        onTap: (){
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                            FocusScope.of(context).requestFocus(new FocusNode());
                          }
                          if(urlPath!="") {
                            print(urlPath);
                            Navigator.push(context, PageTransition(type: PageTransitionType.fade,
                                child: PdfViewPage(path: urlPath,))
                            );
                          }else{
                            setState(() {
                              getPdfFromUrl("https://sprint-pay.com/wp-content/uploads/2018/11/CGU-Afrique-CEMAC-%E2%80%93-Sprint-Pay-2018.pdf").then((f) {
                                setState(() {
                                  urlPath = f.path;
                                  print("mon path: $urlPath");
                                });
                              });
                            });
                            Navigator.push(context, PageTransition(type: PageTransitionType.fade,
                                child: PdfViewPage(path: urlPath,))
                            );
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Accepter les conditions générales d'utilisation",style: TextStyle(
                                color: couleur_fond_bouton,
                                fontSize: taille_description_champ,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.italic
                            ),),
                            Text("et la politique de confidentialité de SPRINT PAY",style: TextStyle(
                                color: couleur_fond_bouton,
                                fontSize: taille_description_champ,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.italic
                            ),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                /*Padding(
                  padding: const EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
                  child: Text("En soumettant ce formulaire, vous autorisez également SPRINT PAY à vous contacter et à vous envoyer des communications marketing en utilisant les coordonnées que vous avez fournies",
                    style: TextStyle(
                        color: couleur_description_champ,
                        fontSize: taille_description_champ,
                        fontFamily: police_description_champ
                    ),textAlign: TextAlign.justify,),
                ),*/

                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 20),
                  child: Row(
                    children: <Widget>[
                      Checkbox(
                          activeColor: couleur_fond_bouton,
                          value: _check2,
                          onChanged: (bool val){
                            setState(() {
                              _check2 = val;
                            });
                          }
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Cochez cette case si vous ne souhaitez pas\nrecevoir les propositions commerciales de\nSPRINT PAY et de ses partenaires.",style: TextStyle(
                            color: couleur_description_champ,
                            fontSize: taille_description_champ,
                            fontWeight: FontWeight.normal
                        ),),
                      ),
                    ],
                  ),
                ),

                Padding(padding: EdgeInsets.only(top: marge_champ_libelle),),

                GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState.validate()) {
                      if(_check1 == true){
                        this._reg();
                        print(iso3);
                        print(_username);
                        print(_password);
                        print(_url);
                        var MemberTemp = new createMemberTemp(
                          country: this.iso3,
                          username: this._username,
                          password: this._password
                        );
                        print(json.encode(MemberTemp));
                        this.checkConnection(json.encode(MemberTemp));
                      }else{
                        showInSnackBar("Veuillez d'abord valider les conditions d'utilisation", _scaffoldKey);
                      }
                    }
                  },
                  child: new Container(
                    height: hauteur_champ,
                    width: MediaQuery.of(context).size.width-40,
                    decoration: new BoxDecoration(
                      color: couleur_fond_bouton,
                      border: new Border.all(
                        color: Colors.transparent,
                        width: 0.0,
                      ),
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    child: Center(
                        child: isLoding==false? new Text('Je m\'inscris', style: new TextStyle(fontSize: taille_text_bouton+ad, color: Colors.white),):CupertinoActivityIndicator()
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top:20.0),
            child: GestureDetector(
              onTap: (){
                setState(() {
                  showInSnackBar("Pas encore disponible", _scaffoldKey);
                });
              },
              child: Text('Contactez-nous',
                style: TextStyle(
                    color: couleur_fond_bouton,
                    fontSize: taille_description_champ+ad,
                  fontWeight: FontWeight.bold
                ),textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: barreBottom,
    );
  }
}
void showInSnackBar(String value, GlobalKey<ScaffoldState> _scaffoldKey) {
  _scaffoldKey.currentState.showSnackBar(
      new SnackBar(content: new Text(value,style:
      TextStyle(
          color: Colors.white,
          fontSize: taille_champ+3
      ),
        textAlign: TextAlign.center,),
        backgroundColor: couleur_fond_bouton,
        duration: Duration(seconds: 5),));
}

class createMemberTemp{
  final String country;
  final String username;
  final String password;

  createMemberTemp({this.country, this.username, this.password});

  createMemberTemp.fromJson(Map<String, dynamic> json)
      : country = json['country'],
        username = json['username'],
        password = json['password'];

  Map<String, dynamic> toJson() =>
      {
        "country": country,
        "username": username,
        "password": password,
      };
}

class PdfViewPage extends StatefulWidget {
  final String path;

  const PdfViewPage({Key key, this.path}) : super(key: key);
  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {

  int _totalPages = 0, _currentPage = 0;
  bool pdfReady = false;
  PDFViewController _pdfViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conditions d'utilisation SprintPay", style: TextStyle(
          fontSize: taille_description_champ+3,
          color: couleur_fond_bouton
        ),),
        elevation: 0.0,
        leading: GestureDetector(
            onTap: (){
              setState(() {
                Navigator.pop(context);
              });
            },
            child: Icon(Icons.arrow_back_ios,)),
        iconTheme: new IconThemeData(color: couleur_fond_bouton),
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
              filePath: widget.path,
            autoSpacing: true,
            enableSwipe: true,
            pageSnap: true,
            swipeHorizontal: true,
            onError: (e){
                print(e);
            },
            onRender: (_pages){
                setState(() {
                  _totalPages = _pages;
                  pdfReady = true;
                });
            },
            onViewCreated: (PDFViewController vc){
                _pdfViewController = vc;
            },

            onPageChanged: (int page, int total){
                setState(() {

                });
            },
            onPageError: (page, e){

            },
          ),
          !pdfReady?Center(
            child: CupertinoActivityIndicator(radius: 30,),):Offstage(
          )
        ]
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _currentPage>0?FloatingActionButton.extended(
            backgroundColor: orange_F,
            label: Icon(Icons.arrow_back_ios),
              onPressed: (){
                _currentPage -= 1;
                _pdfViewController.setPage(_currentPage);
              },
          ):Offstage(),

          _currentPage<_totalPages?FloatingActionButton.extended(
            backgroundColor: bleu_F,
            label: Icon(Icons.arrow_forward_ios),
            onPressed: (){
              _currentPage += 1;
              _pdfViewController.setPage(_currentPage);
            },
          ):Offstage(),
        ],
      ),
    );
  }
}

