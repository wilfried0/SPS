import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:services/auth/connexion.dart';
import 'package:services/community/lib/paiement/participationtontine2.dart';
import 'package:services/community/lib/utils/components.dart';
import 'package:services/composants/components.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'participation2.dart';

class Paiementtontine1 extends StatefulWidget {
  Paiementtontine1(codetontine);
 String codetontine;
  @override
  _Paiementtontine1State createState() => _Paiementtontine1State(codetontine);
}

class _Paiementtontine1State extends State<Paiementtontine1> {
  _Paiementtontine1State(_code);
  String amounttontine, _code, avatar, kittyId, country, montant,_user_kitty, dial_code="+237", _token, _username, username, title, prenom, nom, email, description, mobileNumber, _url, currency, currencySymbol="CFA", _tel, flagUri="flags/cm.png";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();
  var nomController, descriptionController, phoneController, emailController, montantController;
  int indik=2;
  int flex4, flex6, taille, enlev, rest, enlev1, _id, choix, choice = 0;

  File _image;
  bool _value1 = false;
  double _tail,_taill,haut, _width, hauteurcouverture, nomright, nomtop, right1, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext, _larg, left1, social, topo, div1, div2, margeleft, margeright;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    montantController = new MoneyMaskedTextController(decimalSeparator: '', thousandSeparator: '.', precision: 0);
    nomController = new TextEditingController();
    emailController = new TextEditingController();
    phoneController = new TextEditingController();
    descriptionController = new TextEditingController();
    this.lire();
  }

  @override
  void dispose() {
    montantController.dispose();
    nomController.dispose();
    emailController.dispose();
    phoneController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  lire() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      kittyId = prefs.getString(ID_KITTY);
      amounttontine = prefs.getString(MONTANT_TONTINE);
      avatar = prefs.getString(AVATAR_X);
      //dial_code = prefs.getString(DIAL_CODE);
      _token = prefs.getString(TOKEN);
      _username = prefs.getString("username");
      _user_kitty = prefs.getString(USER_KITTY);
      title = prefs.getString(TITLE_KITTY);
    });
  }
  bool tryParse(String str) {
    if(str == null) {
      return false;
    }
    return int.tryParse(str) != null;
  }

  void save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(MONTANT_PART, "$montant");
    prefs.setString(PRENOM_PART, "$prenom");
    prefs.setString(NOM_PART, "$nom");
    prefs.setString(TEL_PART, "$_tel");
    prefs.setString(MOTIF_PART, "$description");
    prefs.setString(EMAIL_PART, "$email");
    prefs.setString(MASK_PART, "$_value1");
    prefs.setString(CHOIX_PART, "$indik");
    prefs.setString(ORIGIN, "Paiementtontine1");
    prefs.setString(DIAL_CODE, "$dial_code");
    print("Mon dial_code: $dial_code");
    prefs.setString(CURRENCYSYMBOL, "$currencySymbol");
    prefs.setString(CURRENCY, "$currency");
  }

  void _onChanged1(bool value) => setState(() => _value1 = value);

  getCurrency() async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    print("$_url");
    HttpClientRequest request = await client.getUrl(Uri.parse(_url));
    request.headers.set('Accept', 'application/json');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print(reply);
    if(response.statusCode == 200){
      var responseJson = json.decode(reply);
      print(responseJson);
      setState(() {
        currency = responseJson['currency']['currencyCode'];
        currencySymbol = responseJson['currency']['currencySymbol'];
      });
      //this._save();
      //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Cagnotte1()));
    }else{
      print(response.statusCode);
      showInSnackBar("Service indisponible!", _scaffoldKey, 5);
    }
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
      _larg = 30;
      enlev1 = 243;
      right1 = 120;
      left1 = 0;
      social = 25;
      topo = 470;
      div1 = 387;
      margeleft = 11.5;
      margeright = 11;
      _tail = taille_description_champ-1;
      _taill = taille_description_champ-3;
      haut = 75;
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
      _larg = 40;
      enlev1 = 260;
      social = 30;
      topo = 480;
      div1 = 388;
      margeleft = 12.5;
      margeright = 12.5;
      _tail = taille_description_champ-1;
      _taill = taille_description_champ-1;
      haut=75;
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
      _larg = 40;
      enlev1 = 260;
      social = 30;
      topo = 480;
      div1 = 387;
      margeleft = 13;
      margeright = 13;
      _tail = taille_description_champ;
      _taill = taille_description_champ;
      haut = 75;
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
      _larg = 40;
      enlev1 = 260;
      social = 30;
      topo = 480;
      div1 = 387;
      margeleft = 15;
      margeright = 14;
      _tail = taille_description_champ;
      _taill = taille_description_champ;
      haut = 75;
    }

    return Scaffold(
      key: _scaffoldKey,

      body: _buildBody(context),
      bottomNavigationBar: barreBottom,
    );
  }

  _buildBody(BuildContext context) {
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
            child: Form(
              key: _formKey,
              child: Stack(
                children: <Widget>[
                  avatar == null?Container(): Container(
                    height: 300,
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
                            image:NetworkImage(avatar),
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
                              top: 300.0-45,
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
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 335),
                    child: Divider(
                      height: 5,
                      color: couleur_bordure,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 23, left: 20, right: 20),
                    child: Row(
                      children: <Widget>[
                        InkWell(
                            onTap: (){
                            },
                            child: Icon(Icons.arrow_back_ios,color: Colors.white,)
                        ),
                        InkWell(
                          onTap: (){
                          },
                          child: Text('Retour',
                            style: TextStyle(color: Colors.white, fontSize: taille_champ),),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 355, left: 20),
                    child:title==null?CupertinoActivityIndicator(): Text(title,
                      style: TextStyle(
                          color: couleur_fond_bouton,
                          fontSize: taille_text_bouton,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 385),
                    child: Divider(
                      height: 5,
                      color: couleur_bordure,
                    ),
                  ),

                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(top: div1),
                          child: Container(color: couleur_bordure, height: haut, margin: EdgeInsets.only(left: margeleft, right: margeright),),
                        ),
                      ),

                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.only(top: 380 ),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.shopping_cart,
                                color: couleur_fond_bouton,
                                size: 40,
                              ),
                              Text('PARTICIPATION',
                                style: TextStyle(
                                    color: couleur_fond_bouton,
                                    fontSize: _tail,
                                    fontWeight: FontWeight.bold
                                ),)
                            ],
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(top: div1),
                          child: Container(color: couleur_bordure, height: haut, margin: EdgeInsets.only(left: margeleft, right: margeright),),
                        ),
                      ),

                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: EdgeInsets.only(top: 380),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.check_circle_outline,
                                color: couleur_libelle_champ,
                                size: 40,
                              ),
                              Text('VERIFICATION',
                                style: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize: _tail,
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
                          child: Container(color: couleur_bordure, height: haut, margin: EdgeInsets.only(left: margeleft, right: margeright),),
                        ),
                      ),

                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.only(top: 380),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.payment,
                                color: couleur_libelle_champ,
                                size: 40,
                              ),
                              Text('PAIEMENT',
                                style: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize: _tail,
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
                          child: Container(color: couleur_bordure, height: haut, margin: EdgeInsets.only(left: margeleft, right: margeright),),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 460),
                    child: Divider(
                      height: 5,
                      color: couleur_bordure,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 462),
                    child: Container(
                      height: hauteur_champ,
                      width: MediaQuery.of(context).size.width,
                      color: couleur_champ,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, top: 15),
                        child: Text("Choix du moyen de paiement",
                          style: TextStyle(
                              color: couleur_libelle_champ,
                              fontSize: taille_champ+3,
                              fontWeight: FontWeight.normal
                          ),),
                      ),
                    ),
                  ),

                  country != "CMR" && country != null?Padding(
                    padding: EdgeInsets.only(top: 520, left: 20, right: 20),
                    child: CarouselSlider(
                      enlargeCenterPage: true,
                      autoPlay: false,
                      enableInfiniteScroll: false,
                      onPageChanged: (value){},
                      height: 105.0,
                      items: [3,4].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return getMoyen(i);
                          },
                        );
                      }).toList(),
                    ),
                  ):Padding(
                    padding: EdgeInsets.only(top: 520, left: 0, right: 0),
                    child: CarouselSlider(
                      enlargeCenterPage: true,
                      autoPlay: false,
                      enableInfiniteScroll: true,
                      initialPage: 2,
                      onPageChanged: (value){
                        setState(() {
                          indik = value;
                          print(indik);
                        });
                      },
                      height: 105.0,
                      items: [1,2,3,4].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return getMoyen(i);
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 630),
                    child: Divider(
                      height: 5,
                      color: couleur_bordure,
                    ),
                  ),

                  Padding(
                      padding: EdgeInsets.only(top: 633, left: 20),
                      child: TextFormField(
                        controller: nomController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: taille_champ+3,
                            color: couleur_libelle_champ,
                        ),
                        validator: (String value){
                          if(value.isEmpty){
                            return null;
                          }else{
                            nom = value;
                            return null;
                          }
                        },
                        decoration: InputDecoration.collapsed(
                          hintText: 'Nom et prénom du tontineur',
                          hintStyle: TextStyle(
                              color: couleur_libelle_champ,
                            fontSize: taille_champ+3,
                          ),
                        ),
                      )
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 677),
                    child: Divider(
                      height: 5,
                      color: couleur_bordure,
                    ),
                  ),

                  Padding(
                      padding: EdgeInsets.only(top: 678, left: 20),
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          fontSize: taille_champ+3,
                            color: couleur_libelle_champ,
                        ),
                        validator: (String value){
                          if(value.isEmpty){
                            return null;
                          }else{
                            email = value;
                            return null;
                          }
                        },
                        decoration: InputDecoration.collapsed(
                          hintText: 'Adresse email du tontineur',
                          hintStyle: TextStyle(
                              color: couleur_libelle_champ,
                            fontSize: taille_champ+3,
                          ),
                        ),
                      )
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 724),
                    child: Divider(
                      height: 5,
                      color: couleur_bordure,
                    ),
                  ),

                  Padding(
                      padding: EdgeInsets.only(top: 726, left: 20),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 4,
                              child: CountryCodePicker(
                                showFlag: true,
                                showOnlyCountryWhenClosed: false,
                                showCountryOnly: false,
                                textStyle: TextStyle(
                                    fontSize: taille_champ+3,
                                    color: couleur_libelle_champ
                                ),
                                initialSelection:dial_code,
                                onChanged: (CountryCode code) {
                                  dial_code = code.dialCode.toString();
                                  flagUri = "${code.flagUri}";
                                  _url = "$cagnotte_url/user/currencyUser/${code.codeIso}";
                                  getCurrency();
                                },
                              )
                          ),
                          Expanded(
                            flex: 8,
                            child: TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                fontSize: taille_champ+3,
                                  color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return null;
                                }else{
                                  _tel = '$value';
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Téléphone du tontineur',
                                hintStyle: TextStyle(
                                    color: couleur_libelle_champ,
                                  fontSize: taille_champ+3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 771),
                    child: Divider(
                      height: 5,
                      color: couleur_bordure,
                    ),
                  ),

                  Padding(
                      padding: EdgeInsets.only(top: 773, left: 20),
                      child: TextFormField(
                        controller: descriptionController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: taille_champ+3,
                            color: couleur_libelle_champ,
                        ),
                        validator: (String value){
                          if(value.isEmpty){
                            return null;
                          }else{
                            description = value;
                            return null;
                          }
                        },
                        decoration: InputDecoration.collapsed(
                          hintText: 'Un mot pare rapport à votre contribution',
                          hintStyle: TextStyle(
                              color: couleur_libelle_champ,
                            fontSize: taille_champ+3,
                          ),
                        ),
                      )
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 818),
                    child: Divider(
                      height: 5,
                      color: couleur_bordure,
                    ),
                  ),

                  Padding(
                      padding: EdgeInsets.only(top: 820, left: 20, right: 20),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 10,
                            child: TextFormField(
                              controller: montantController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: taille_champ+3,
                                  color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return null;
                                }else{
                                  montant = value;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Montant de votre contribution',
                                hintStyle: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize: taille_champ+3
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Expanded(
                              flex: 2,
                              child: Text('$currencySymbol',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: couleur_libelle_champ,
                                    fontSize: taille_champ+3
                                ),)
                          )
                        ],
                      )
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 865),
                    child: Divider(
                      height: 5,
                      color: couleur_bordure,
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 865, left: 5),
                    child: new SwitchListTile(
                      value: _value1,
                      onChanged: _onChanged1,
                      activeColor: couleur_fond_bouton,
                      title: new Text('Masquer ma participation', style: new TextStyle(fontWeight: FontWeight.normal, color: couleur_libelle_champ, fontSize: taille_champ+3)),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 920),
                    child: Container(
                      height: hauteur_champ,
                      width: MediaQuery.of(context).size.width,
                      color: couleur_champ,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, top: 15),
                        child: Text(""),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top:960,bottom: 0),
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          _save3();
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Paiementtontine2(_code)));
                          if(_formKey.currentState.validate()){
                            if(indik == 2 && _token == null){
                              this.ackAlert(context, "Vous devez être connecté pour ce mode de paiement.");
                            }else if(isEmail(email) == false){
                              showInSnackBar("Adresse email invalide!", _scaffoldKey, 5);
                            }else{
                              if(_tel == null){
                                showInSnackBar("Numéro de téléphone invalide!", _scaffoldKey, 5);
                              }else if(nom == null){
                                showInSnackBar("Veuillez renseigner le nom!", _scaffoldKey, 5);
                              }else if(description == null){
                                showInSnackBar("Veuillez renseigner la description!", _scaffoldKey, 5);
                              }else if(montant == null || int.parse(montant.replaceAll(".", ""))<=0){
                                showInSnackBar("Veuillez renseigner le montant!", _scaffoldKey, 5);
                              }else if(email == null){
                                showInSnackBar("Veuillez renseigner l'email est invalide!", _scaffoldKey, 5);
                              }else {
                                save();
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Paiementtontine2(_code)));
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
                          borderRadius: new BorderRadius.circular(0.0),
                        ),
                        child: new Center(child: new Text('Vérification', style: new TextStyle(color: couleur_text_bouton,),),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _save3() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(DESCRIPTION_P, description);
    descriptionController.text = description;
    prefs.setString(PHONE_P, description);
    phoneController.text = _username;
    prefs.setString(EMAIL_P, email);
    emailController.text = email;
    print('saveamount $amounttontine');
  }

  Widget getMoyen(int index){
    String text, img;
    switch(index){
      case 1: text = "ORANGE MONEY";img = 'images/orange.png';
      break;
      case 2: text = "MTN MOBILE MONEY";img = 'images/mtn.jpg';
      break;
      case 3: text = "SPRINT-PAY WALLET";img = 'images/sps.png';
      break;
      case 4: text = "CARTE PAYPAL";img = 'images/carte.jpg';
      break;
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
        ),
        border: Border.all(
            color: index-1==indik?orange_F:bleu_F
        ),
        color: Colors.white,//index-1==indik&&(indik==2||indik==3)?Colors.white:index-1==indik?orange_F:bleu_F,
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 0),
        child: GestureDetector(
          onTap: (){
            setState(() {
              //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Retrait1('$_code')));
            });
          },
          child: Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                ),
                image: DecorationImage(
                  image: AssetImage('$img'),
                  fit: BoxFit.fill,
                )
            ),),
        ),
      ),
    );
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
                //Navigator.of(context).push(SlideLeftRoute(enterWidget: Pays(), oldWidget: Configuration('$_code')));
              },
            ),
          ],
        );
      },
    );
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
