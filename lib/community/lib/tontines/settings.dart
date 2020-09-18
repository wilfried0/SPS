import 'dart:convert';
import 'package:async/async.dart';
import 'package:services/auth/connexion.dart';
import 'package:services/community/lib/tontines/tontine4.dart';
import 'package:services/community/lib/utils/services.dart';
import 'package:services/composants/components.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../confirm.dart';
import '../utils/components.dart';


class Settings extends StatefulWidget {
  Settings();

  @override
  _SettingsState createState() => new _SettingsState();
}

class _SettingsState extends State<Settings> {
  _SettingsState();
  String kittyImage, _conf, url, _url, _token, _finish, avatar;
  PageController pageController;
  List invitations;
  int currentPage = 0;
  var _formKey = GlobalKey<FormState>();
  var _formKey2 = GlobalKey<FormState>();
  int flex4, flex6, taille, enlev, rest, enlev1, idUser, type;
  bool _value1 = false, _value2 = false, _value3 = false, _value4 = false, _value5 = false, _value6 = false, status = true, hide_amount_kitty, notify_of_comments, notify_participants_when_spending, notify_of_participation, hide_amount_contribution, suggest_amount_to_guest, visibility, isLoding = false, isLoadImage=false;
  double _width, sanctionPercentage, delayTimes, paticipationDuration, _suggest, suggested_amount, amounttontine, previsional_amount, hauteurcouverture, nomright, nomtop, right1, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext, _larg, left1, social, topo, div1, div2, margeleft, margeright;
  String libelle, paticipationDuration1, name, startDate, _username,_password, endDate, descriptiontontine, firstnameBenef, lastnameBenef, number, currency, titre, previsionl_amount;
  File _image;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<String> getImage(int q) async {
    var image;
    if(_token == null)
      this.ackAlert(context, "Vous devez vous connecter pour charger votre image");
    else{
      if(q == 1){
        image = await ImagePicker.pickImage(source: ImageSource.camera);
      }else {
        image = await ImagePicker.pickImage(source: ImageSource.gallery);
      }
      setState(() {
        isLoadImage = true;
      });
      Upload(image);
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    this.read();
    url = '$tontine_url/tontines/createTotine';
    _url = '$cagnotte_url/file/uploadImage';
    print(_conf);
    avatar = 'http://negprod-env.c7qjxf2msg.eu-west-3.elasticbeanstalk.com/api/file/viewImage/kitty/237691127446/cover-cagnotte-001.jpg';
    pageController = PageController(
        initialPage: currentPage,
        keepPage: false,
        viewportFraction: 0.8
    );
  }

  void _onChanged1(bool value) => setState(() => _value1 = value);
  void _onChanged2(bool value) => setState(() => _value2 = value);
  void _onChanged3(bool value) => getValue(value);
  void _onChanged4(bool value) => setState(() => _value4 = value);
  void _onChanged5(bool value) => setState(() => _value5 = value);
  void _onChanged6(bool value) => setState(() => _value6 = value);

  @override
  void dispose() {
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
      topphoto = 264;
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
      _larg = 30;
      enlev1 = 263;
      right1 = 120;
      left1 = 0;
      social = 25;
      topo = 470;
      div1 = 410;
      margeleft = 11.5;
      margeright = 11;
    }else if(_large>320 && _large<=360){
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
      topphoto = 264;
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
      _larg = 40;
      enlev1 = 270;
      social = 30;
      topo = 475;
      div1 = 410;
      margeleft = 15;
      margeright = 14;
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
      topphoto = 264;
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
      _larg = 40;
      enlev1 = 270;
      social = 30;
      topo = 475;
      div1 = 410;
      margeleft = 15;
      margeright = 14;
    }
    return new Scaffold(
        key: _scaffoldKey,
        body: _buildBody(context),
        bottomNavigationBar: barreBottom
    );
  }


  _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
                    _image == null?Container(
                      height: 300,
                      decoration: BoxDecoration(
                          /*gradient: LinearGradient(
                              begin: FractionalOffset.topCenter,
                              end: FractionalOffset.bottomCenter,
                              colors: [
                                Colors.white,
                                bleu_F
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
                              image: avatar!=null? NetworkImage(avatar):AssetImage("images/cover.jpg"),
                              fit: BoxFit.cover
                          )
                      ),
                    ):Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          /*gradient: LinearGradient(
                              begin: FractionalOffset.topCenter,
                              end: FractionalOffset.bottomCenter,
                              colors: [
                                Colors.white,
                                Colors.black
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
                              image: FileImage(_image),
                              fit: BoxFit.cover
                          )
                      ),
                      //child: Image.file(_image),
                    ),
                    // The card widget with top padding,
                    // incase if you wanted bottom padding to work,
                    // set the `alignment` of container to Alignment.bottomCenter
                    new Container(
                      child: new Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly
                        children: <Widget>[
                          InkWell(
                            onTap: () async {
                              this.kAlert(context);
                            },
                            child: Padding(
                              padding: new EdgeInsets.only(
                                  top: 240,
                                  right: 20.0,
                                  left: 20.0),
                              child: isLoadImage==false? Icon(Icons.camera_alt, color: couleur_fond_bouton, size: 50,):CupertinoActivityIndicator(radius: 20,),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 270, right:isLoadImage==false? MediaQuery.of(context).size.width-enlev1:MediaQuery.of(context).size.width-enlev1-15),
                                child: Text(isLoadImage==false?"Modifier l\'image":"Chargement de l'image en cours ...",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: taille_champ
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 33),
                      child: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Tontine4()));
                      },color: Colors.white,),
                    ),

                    /*Padding(
                        padding: const EdgeInsets.only(top: 330),
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                            child: Text('Réglages de la tontine',
                              style: TextStyle(
                                  color: couleur_fond_bouton,
                                  fontWeight: FontWeight.bold,
                                  fontSize: taille_libelle_etape
                              ),),
                          ),
                        )
                    ),*/

                    /*Padding(
                        padding: const EdgeInsets.only(top: 390),
                        child: Container(
                          color: couleur_champ,
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                            child: Text('Settings sur le montant',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                              ),),
                          ),
                        )
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 425, left: 5),
                      child: new SwitchListTile(
                        value: _value1,
                        onChanged: _onChanged1,
                        activeColor: Colors.green,
                        activeTrackColor: couleur_champ,
                        inactiveThumbColor: Colors.red,
                        inactiveTrackColor: couleur_champ,
                        title: new Text('Masquer le montant de la tontine', style: new TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: taille_libelle_champ)),
                      ),
                    ),


                    Padding(
                      padding: EdgeInsets.only(top: 475),
                      child: Divider(
                        height: 5,
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: topo, left: 5),
                      child: new SwitchListTile(
                        value: _value2,
                        onChanged: _onChanged2,
                        activeColor: Colors.green,
                        activeTrackColor: couleur_champ,
                        inactiveThumbColor: Colors.red,
                        inactiveTrackColor: couleur_champ,
                        title: new Text('Masquer les montants des contribuables', style: new TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: taille_libelle_champ)),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 525),
                      child: Divider(
                        height: 5,
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 522, left: 5),
                      child: new SwitchListTile(
                          value: _value3,
                          onChanged: _onChanged3,
                          activeColor: Colors.green,
                          activeTrackColor: couleur_champ,
                          inactiveThumbColor: Colors.red,
                          inactiveTrackColor: couleur_champ,
                          title: new Row(
                            children: <Widget>[
                              Text(_suggest==null?'Suggérer un montant aux invités':'Montant suggéré ', style: new TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: taille_libelle_champ)),
                              Text(_suggest==null?'':' $_suggest', style: new TextStyle(fontWeight: FontWeight.bold, color: couleur_libelle_etape, fontSize: taille_libelle_champ)),
                            ],
                          )
                      ),
                    ),

                    Padding(
                        padding: const EdgeInsets.only(top: 577),
                        child: Container(
                          color: couleur_champ,
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                            child: Text('Settings sur les notifications',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                              ),),
                          ),
                        )
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 615, left: 5),
                      child: new SwitchListTile(
                        value: _value4,
                        onChanged: _onChanged4,
                        activeColor: Colors.green,
                        activeTrackColor: couleur_champ,
                        inactiveThumbColor: Colors.red,
                        inactiveTrackColor: couleur_champ,
                        title: new Text("M'avertir des participations par email", style: new TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: taille_libelle_champ)),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 665),
                      child: Divider(
                        height: 5,
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 665, left: 5),
                      child: new SwitchListTile(
                        value: _value5,
                        onChanged: _onChanged5,
                        activeColor: Colors.green,
                        activeTrackColor: couleur_champ,
                        inactiveThumbColor: Colors.red,
                        inactiveTrackColor: couleur_champ,
                        title: new Text("M'avertir des commentaires par email", style: new TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: taille_libelle_champ)),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 715),
                      child: Divider(
                        height: 5,
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 715, left: 5),
                      child: new SwitchListTile(
                        value: _value6,
                        onChanged: _onChanged6,
                        activeColor: Colors.green,
                        activeTrackColor: couleur_champ,
                        inactiveThumbColor: Colors.red,
                        inactiveTrackColor: couleur_champ,
                        title: new Text("Notifier les participants lors des dépenses", style: new TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: taille_libelle_champ)),
                      ),
                    ),

                    Padding(
                        padding: const EdgeInsets.only(top: 770),
                        child: Container(
                          color: couleur_champ,
                          height: 40,
                          width: MediaQuery.of(context).size.width,

                        )
                    ),*/

                    Padding(
                      padding: EdgeInsets.only(top:410,left: MediaQuery.of(context).size.width/5, right: MediaQuery.of(context).size.width/5),
                      child: InkWell(
                        onTap: () async {
                          if(_formKey.currentState.validate()){
                            var tontineC = new TontineC(
                                amount: this.amounttontine,
                                avatar: this.avatar,
                                delayTimes: this.delayTimes,
                                description: this.descriptiontontine,
                                invitations: this.invitations,
                                name: this.name,
                                paticipationDuration: this.paticipationDuration,
                                startDate: this.startDate,
                                currency: this.currency,
                                sanctionPercentage: this.sanctionPercentage
                            );
                            print('amount == $amounttontine');
                            print('avatar == $avatar');
                            print('delayTimes == $delayTimes');
                            print('description == $descriptiontontine');
                            print('invitations == ${invitations.toString()}');
                            print('name == $name');
                            print('paticipationDuration == $paticipationDuration');
                            print('startDate == $startDate');
                            print(json.encode(tontineC));
                            //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte('')));
                            checkConnection(json.encode(tontineC));
                          }
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
                            borderRadius: new BorderRadius.circular(0.0),
                          ),
                          child: new Center(child: isLoding==false?new Text('Je valide ma tontine', style: new TextStyle(fontSize: taille_text_bouton+3, color: couleur_text_bouton),):CupertinoActivityIndicator()
                            ,),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      paticipationDuration = double.parse(prefs.getString(PARTICIPATIONDURATION).replaceAll(".", ""));
      startDate = prefs.getString(STARTDATE_TONTINE);
      sanctionPercentage = double.parse(prefs.getString(SANCTION));
      invitations = prefs.getStringList(INVITATIONS_TONTINE);
      avatar = prefs.getString(AVATAR_X);
      _username = prefs.getString("username");
      _password = prefs.getString("password");
      amounttontine = double.parse(prefs.getString(MONTANT_TONTINE).replaceAll(".", ""));
      name = prefs.getString(LIBELLE_TONTINE);
      delayTimes = double.parse(prefs.getString(DELAYTIMES).replaceAll(".", ""));
      descriptiontontine = prefs.getString(DESCRIPTION_TONTINE);
      startDate = prefs.getString(STARTDATE_TONTINE);
      paticipationDuration1 = prefs.getString(PARTICIPATIONDURATION);
      print(delayTimes);
      print(paticipationDuration);
      _token = prefs.getString(TOKEN);
      currency = prefs.getString(CURRENCY);
    });
    print(avatar);
    print('participationduration: $paticipationDuration');
    print('startDateTontine: $startDate');
    print('invitations: $invitations');
    // print('password: $_password');
  }

  getStringToBool(String val){
    if(val == "true"){
      return true;
    }else
      return false;
  }

  getValue(bool value) {
    setState(() {
      _value3 = value;
      if(_value3 == true){
        _ackAlert(context);
      }
    });
  }

  Future<void> _ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: _formKey2,
          child: AlertDialog(
            title: Text('Montant suggéré',
              style: TextStyle(
                fontSize: taille_libelle_champ,
                color: couleur_libelle_etape,
              ),
              textAlign: TextAlign.justify,),
            content: TextFormField(
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: taille_libelle_champ,
                color: Colors.black,
              ),
              validator: (String value){
                setState(() {
                  if(value.isEmpty){
                    _suggest = 0;
                  }else{
                    _suggest = double.parse(value);
                  }
                });
                Navigator.of(context).pop();
                return null;
              },
              decoration: InputDecoration(
                hintText: 'Montant',
                hintStyle: TextStyle(
                    fontSize: taille_libelle_champ,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                ),
                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Valider'),
                onPressed: () {
                  if(_formKey2.currentState.validate()){
                    print(_suggest);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String> createTontine(var body) async {
    final credentials = '$_username:$_password';
    final stringToBase64 = utf8.fuse(base64);
    final encodedCredentials = stringToBase64.encode(credentials);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json", // or whatever
      HttpHeaders.authorizationHeader: "Basic $encodedCredentials",
    };
    return await http.post(url, body: body, headers: headers, encoding: Encoding.getByName("utf-8")).then((http.Response response) {
      final int statusCode = response.statusCode;
      print('voici le statusCode $statusCode');
      print('voici le body ${response.body}');
      if (statusCode < 200 || json == null) {
        setState(() {
          isLoding =false;
        });
        throw new Exception("Error while fetching data");
      }else if(statusCode == 200){
        setState(() {
          isLoding =false;
        });
        this.savAll();
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Confirm('')));
      }else if(statusCode == 401){
        setState(() {
          isLoding =false;
        });
        this.save();
      }else if(statusCode == 500){
        setState(() {
          isLoding =false;
        });
        this.save();
        //ackAlert(context, "Vous devez être connecté pour valider votre création.");
      }else {
        setState(() {
          isLoding =false;
        });
        showInSnackBar("$statusCode ${response.body}");
        //ackAlert(context, "Vous devez être connecté pour valider votre création.");
      }
      return response.body;
    });
  }

  void save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(ORIGIN, "Settings");
  }


  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text(value,style:
        TextStyle(
            color: Colors.white,
            fontSize: taille_champ+5
        ),
          textAlign: TextAlign.center,),
          backgroundColor: couleur_fond_bouton,
          duration: Duration(seconds: 5),));
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
                this.save();
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Connexion()));
                //Navigator.of(context).push(SlideLeftRoute(enterWidget: Pays(), oldWidget: Settings('$_code')));
              },
            ),
          ],
        );
      },
    );
  }

  void savAll() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('finish', null);
    prefs.setString('route', null);
    prefs.setString('montant', null);
    prefs.setString('libelle', null);
    prefs.setString('myvisible', null);
    prefs.setString('kitty', null);
    prefs.setString('cagnotte', null);
    prefs.setString('macagnot', null);
    prefs.setString('newcagnot', null);
    prefs.setString('codeiso', null);
    prefs.setString('descrip', null);
    prefs.setString('xaf', null);
    prefs.setString(CONFIRMATION, "settings");
  }


  Future<void> kAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Caméra/Galerie'),
          content: Text('Prendre l\'image depuis la Galerie ou la caméra'),
          actions: <Widget>[
            FlatButton(
              child: Text('Galerie'),
              onPressed: () {
                Navigator.of(context).pop();
                getImage(0);
              },
            ),
            FlatButton(
              child: Text('Caméra'),
              onPressed: () {
                Navigator.of(context).pop();
                getImage(1);
              },
            ),
          ],
        );
      },
    );
  }



  void Upload(File imageFile) async {
    var _header = {
      "content-type" : 'multipart/form-data',
      "Authorization": "Bearer $_token"
    };
    print("taille: $_token");
    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    print("taille: $length");
    var multipartFile = new http.MultipartFile('file', stream, length, filename: imageFile.path.split('/').last);
    var uri = Uri.parse('$cagnotte_url/file/uploadImage/kitty');
    print("endpoint upload: $cagnotte_url/file/uploadImage/kitty");
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(_header);
    request.files.add(multipartFile);
    var response = await request.send();
    print('statuscode ${response.statusCode}');
    if(response.statusCode == 200){
      response.stream.transform(utf8.decoder).listen((value) {
        var responseJson = json.decode(value);
        print("la valeur: $value");
        setState(() {
          isLoadImage = false;
          avatar = responseJson['fileDownloadUri'];
        });
      });
    } else{
      response.stream.transform(utf8.decoder).listen((value) {
        print("la valeur: $value");
      });
      setState(() {
        isLoadImage = false;
      });
      showInSnackBar("Service indisponible!");
    }
  }

  /*void Upload(File imageFile) async {
      var _header = {
        "content-type" : 'multipart/form-data',
        "Authorization": "Bearer $_token"
      };
      var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      var multipartFile = new http.MultipartFile('file', stream, length, filename: imageFile.path.split('/').last);
      String val1, val2;
      var uri = Uri.parse('$_url/kitty');
      var request = new http.MultipartRequest("POST", uri);
      request.headers.addAll(_header);
      request.files.add(multipartFile);
      var response = await request.send();
      print('request ${response.request}');
      print('statuscode ${response.statusCode}');
      if(response.statusCode == 200){
        setState(() {
          isLoadImage = false;
        });
        response.stream.transform(utf8.decoder).listen((value) {
          val1 = value.split(',')[1];
          val2 = val1.substring(19, val1.length-1);
          kittyImage = val2;
        });
        setState(() {
          _image = imageFile;
          isLoadImage = false;
        });
      }else{
        this.save();
        setState(() {
          isLoadImage = false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Connexion()));
        //Navigator.of(context).push(SlideLeftRoute(enterWidget: Pays(), oldWidget: Settings('$_code')));
      }
    }*/

  void checkConnection(var body) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        isLoding =true;
        createTontine(body);
      });

    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        isLoding =true;
        createTontine(body);
      });
    } else {
      ckAlert(context);
    }
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
}

