import 'dart:convert';
import 'package:async/async.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:services/auth/connexion.dart';
import 'package:services/community/lib/utils/components.dart';
import 'package:services/composants/components.dart';
import '../confirm.dart';
import '../utils/services.dart';
import 'cagnotte5.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Configuration extends StatefulWidget {
  Configuration();

  @override
  _ConfigurationState createState() => new _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {
  _ConfigurationState();
  String kittyImage, _conf, url, _url, _token, _finish, defaultImage = "http://negprod-env.c7qjxf2msg.eu-west-3.elasticbeanstalk.com/api/file/viewImage/kitty/237691127446/cover-cagnotte-001.jpg";
  int currentPage = 0;
  var _formKey = GlobalKey<FormState>();
  var _formKey2 = GlobalKey<FormState>();
  int flex4, flex6, taille, enlev, rest, enlev1, idUser, type;
  bool _value1 = false, _value2 = false, _value3 = false, _value4 = false, _value5 = false, _value6 = false, status = true, hide_amount_kitty, notify_of_comments, notify_participants_when_spending, notify_of_participation, hide_amount_contribution, suggest_amount_to_guest, visibility, isLoding = false, isLoadImage=false;
  double _width,_suggest, suggested_amount, amount, previsional_amount, hauteurcouverture, nomright, nomtop, right1, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext, _larg, left1, social, topo, div1, div2, margeleft, margeright;
  String libelle, _username, endDate, description, firstnameBenef, lastnameBenef, phone, number, currency, titre, previsionl_amount;
  File _image;
  Dio dio = new Dio();
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
    this._reading();
    url = '$cagnotte_url/kitty/createkitty';
    _url = '$cagnotte_url/file/uploadImage';//cagnotte_url/file/uploadImage/kitty
    print("kitty ********************************* $kittyImage");
    //kittyImage = 'http://negprod-env.c7qjxf2msg.eu-west-3.elasticbeanstalk.com/api/file/viewImage/kitty/237691127446/cover-cagnotte-001.jpg';
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
      backgroundColor: GRIS,
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
                              image: kittyImage!=null && kittyImage!="null"? NetworkImage(kittyImage):AssetImage("images/cover.jpg"),
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
                                  top: 300-36.0,
                                  right: 20.0,
                                  left: 20.0),
                              child: isLoadImage==false? Icon(Icons.camera_alt, color: couleur_description_champ, size: 50,):CupertinoActivityIndicator(radius: 20,),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 270, right:isLoadImage==false? MediaQuery.of(context).size.width-enlev1:MediaQuery.of(context).size.width-enlev1-15),
                                child: Text(isLoadImage==false?"Modifier l'image":"Chargement en cours ...",
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
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte5()));
                      },color: Colors.white,),
                    ),

                    Padding(
                        padding: const EdgeInsets.only(top: 330),
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                            child: Text('Réglages de la cagnotte',
                              style: TextStyle(
                                  color: couleur_fond_bouton,
                                  fontWeight: FontWeight.bold,
                                fontSize: taille_libelle_etape
                              ),),
                          ),
                        )
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 390),
                      child: Container(
                        color: couleur_champ,
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                          child: Text('Configuration sur le montant',
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
                          title: new Text('Masquer le montant de la cagnotte', style: new TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: taille_libelle_champ)),
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
                            child: Text('Configuration sur les notifications',
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
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top:810,left: 0, right: 0),
                      child: InkWell(
                        onTap: () async {
                          if(_formKey.currentState.validate()){
                            suggested_amount = _suggest==null?0:_suggest;
                            amount = 0;
                            suggest_amount_to_guest = _value3;
                            hide_amount_kitty = _value1;
                            hide_amount_contribution = _value2;
                            notify_of_comments = _value5;
                            notify_participants_when_spending = _value6;
                            notify_of_participation = _value4;
                            //type = _conf.split('^')[1];
                            var kitty = new Kitty(
                                title: this.libelle,
                                endDate: this.endDate,
                                description: this.description,
                                firstnameBenef: this.firstnameBenef,
                                lastnameBenef: this.lastnameBenef,
                                number: this.number,
                                kittyImage: this.kittyImage == null || this.kittyImage == "null"?defaultImage:this.kittyImage,
                                status: this.status,
                                currency: this.currency,
                                previsional_amount: this.previsional_amount,
                                visibility: this.visibility,
                                suggested_amount: this.suggested_amount,
                                //amount: this.amount,
                                username: this._username,
                                suggest_amount_to_guest: this.suggest_amount_to_guest,
                                hide_amount_kitty: this.hide_amount_kitty,
                                hide_amount_contribution: this.hide_amount_contribution,
                                notify_of_comments: this.notify_of_comments,
                                notify_of_participation: this.notify_of_participation,
                                notify_participants_when_spending: this.notify_participants_when_spending,
                                type: this.type
                                //type: this.type
                            );
                            print('title == $libelle');
                            print('endDate == $endDate');
                            print('description == $description');
                            print('firstnameBenef == $firstnameBenef');
                            print('lastnameBenef == $lastnameBenef');
                            print('number == $number');
                            print('phone == $phone');
                            print('kittyImage == $kittyImage');
                            print('currency == $currency');
                            print('previsional_amount == $previsional_amount');
                            print('visibility == $visibility');
                            print('suggested_amount == $suggested_amount');
                            //print('amount == $amount');
                            print('suggest_amount_to_guest == $suggest_amount_to_guest');
                            print('hide_amount_kitty == $hide_amount_kitty');
                            print('hide_amount_contribution == $hide_amount_contribution');
                            print('notify_of_comments == $notify_of_comments');
                            print('notify_of_participation == $notify_of_participation');
                            print('idUser == $idUser');
                            print('notify_participants_when_spending == $notify_participants_when_spending');
                            print('type == $type');
                            print(json.encode(kitty));
                            //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte('')));
                            checkConnection(json.encode(kitty));
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
                          child: new Center(child: isLoding==false?new Text('Je valide ma cagnotte', style: new TextStyle(fontSize: taille_text_bouton+3, color: couleur_text_bouton),):CupertinoActivityIndicator()
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


  _reading() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      libelle = prefs.getString(LIBELLE);
      endDate = prefs.getString(DATE_CAGNOTTE);
      firstnameBenef = prefs.getString(PRENOM_CAGNOTTE);
      lastnameBenef = prefs.getString(NOM_CAGNOTTE);
      number = prefs.getString(PHONE_CAGNOTTE_CRE);
      currency = prefs.getString(CURRENCYSYMBOL_CONNEXION);
      description = prefs.getString(DESCRIPTION_CAGNOTTE);
      kittyImage = prefs.getString(KITTY_IMAGE);
      _token = prefs.getString(TOKEN);
      _username = prefs.getString("username");
      previsional_amount = double.parse(prefs.getString(PREVISIONAL_AMOUNT).replaceAll(".", ""));
      if(prefs.getString(VISIBLE) == "Publique"){
        visibility = true;
      }else{
        visibility = false;
      }
      type = int.parse(prefs.getString(CATEGORIE).split('^')[1]);
      final key = 'finish';
      _finish = prefs.getString(key);
      if(_finish==null){

      }else{
        //description = _finish.split('^')[0];
        _value1 = getStringToBool(_finish.split('^')[1]);
        _value2 = getStringToBool(_finish.split('^')[2]);
        _value3 = getStringToBool(_finish.split('^')[3]);
        _suggest = double.parse(_finish.split('^')[4]);
        _value4 = getStringToBool(_finish.split('^')[5]);
        _value5 = getStringToBool(_finish.split('^')[6]);
        _value6 = getStringToBool(_finish.split('^')[7]);
      }
      print('read: $_finish');
    });
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

  Future<String> createKitty(var body) async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse("$url"));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json');
    request.headers.set('Authorization', 'Bearer $_token');
    request.add(utf8.encode(body));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print("statusCode ${response.statusCode}");
    print("body $reply");
    if (response.statusCode < 200 || json == null) {
      setState(() {
        isLoding =false;
      });
      throw new Exception("Error while fetching data");
    }else if(response.statusCode == 200){
      setState(() {
        isLoding =false;
      });
      this.savAll();
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Confirm('')));
      //Navigator.of(context).push(SlideLeftRoute(enterWidget: Confirm('$_code'), oldWidget: Configuration('$_code')));
    }else if(response.statusCode == 401){
      setState(() {
        isLoding =false;
      });
      this.ackAlert(context, "Votre connexion a expiré. Veuillez vous reconnecter");
    }else if(response.statusCode == 500){
      setState(() {
        isLoding =false;
      });
      this.save();
      //ackAlert(context, "Vous devez être connecté pour valider votre création.");
    }else {
      setState(() {
        isLoding =false;
      });
      showInSnackBar("Service indisponible.");
      //ackAlert(context, "Vous devez être connecté pour valider votre création.");
    }
    return null;
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

  void save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(ORIGIN, "configuration");
    prefs.setString(KITTY_IMAGE, "$kittyImage");
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
              fontSize: taille_champ+3,
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
                //Navigator.of(context).push(SlideLeftRoute(enterWidget: Pays(), oldWidget: Configuration('$_code')));
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
    prefs.setString(CONFIRMATION, "configuration");
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

  /*Future<void> uploadFile(File file) async {
    var uri = Uri.parse('$_url/kitty');
    Dio dio = new Dio();
    var formData = FormData();
    formData.files.add(MapEntry("Picture", await MultipartFile.fromFile(file.path, filename: file.path.split('/').last), ));
    var response = await dio.client.post('v1/post', data: formdata);
  }*/

  void _Upload(File imageFile) async {
      var _header = {
        "content-type" : 'multipart/form-data',
        "Authorization": "Bearer $_token"
      };

      var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      print("taille: $length");
      var multipartFile = new http.MultipartFile('file', stream, length, filename: imageFile.path.split('/').last);
      var uri = Uri.parse('$_url/kitty');
      print("endpoint upload: $_url/kitty");
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
            kittyImage = responseJson['fileDownloadUri'];
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

  // ignore: non_constant_identifier_names
  Upload(File image) async{
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
    };
    Response response;
    try{
      String filename = image.path.split('/').last;
      var formData = new FormData.fromMap({
        "file": await MultipartFile.fromFile(image.path, filename: filename, contentType: MediaType('image', 'jpg')),
      });
      response = await dio.post("$_url/kitty",data: formData, options: Options(
          headers: {
            'Content-type': 'multipart/form-data',
            'Accept': 'application/json',
            'Authorization': 'Bearer $_token'
          }
      ));
      if(response.statusCode == 200){
        print("La réponse: ${response.data}");
        setState(() {
          isLoadImage = false;
          kittyImage = response.data['fileDownloadUri'];
        });
        print("La valeur de l'image: ${kittyImage.toString()}");
        showInSnackBar("Téléchargement de l'image réussi avec succès.");
      }else{
        setState(() {
          isLoadImage = false;
        });
        showInSnackBar("Service indisponible, reessayez plus tard!");
      }
    }catch(e){
      print("l'erreur dio: $e");
      setState(() {
        isLoadImage = false;
      });
      if(e.toString().contains("401")){
        this.ackAlert(context, "Votre connexion a expiré, veuillez vous reconnecter");
      }else{
        showInSnackBar("Service indisponible, reessayez plus tard!");
      }
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
        //Navigator.of(context).push(SlideLeftRoute(enterWidget: Pays(), oldWidget: Configuration('$_code')));
      }
    }*/

  void checkConnection(var body) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        isLoding =true;
        createKitty(body);
      });

    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        isLoding =true;
        createKitty(body);
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