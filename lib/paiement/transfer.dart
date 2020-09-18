import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:services/composants/components.dart';
import 'package:services/paiement/transfert2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'transfert3.dart';

class Transfer extends StatefulWidget {
  Transfer(this._code);
  String _code;
  @override
  _TransferState createState() => _TransferState(_code);
}

class _TransferState extends State<Transfer> {
  _TransferState(this._code);
  String _code, _firstname, _lastname, _adresse, _name, lieu_naiss, _username;
  String  _fromCountryISO, jr, mo, an,_lieu = "3", jr1, mo1, an1, _pays,_fromPays, _fromCardType, fromCardType, _fromCardNumber, _fromCardIssuingDate="", _fromCardExpirationDate="";
  var _formKey = GlobalKey<FormState>(), firstController, lastController, adressController, lieuController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final navigatorKey = GlobalKey<NavigatorState>();
  double marge;
  var _categorie = ['Carte Nationale d\'identité', 'Passeport', 'Carte de séjour'];
  var _paystt = ['hi'];
  var _annee = ['1930'];
  var _mois = ['01'];
  var _jour = ['01'];
  List data;
  bool isClicked1 = false, isClicked2 = false;

  @override
  void initState() {
    this.loadMap();
    read();
    // TODO: implement initState
    super.initState();
    this.ChargeAnnee();
    this.ChargeMois();
    this.ChargeJour();
    firstController = new TextEditingController();
    lastController = new TextEditingController();
    adressController = new TextEditingController();
    lieuController = new TextEditingController();
  }

  @override
  void dispose(){
    super.dispose();
    firstController.dispose();
    lastController.dispose();
    adressController.dispose();
    lieuController.dispose();
  }

  ChargeAnnee(){
    for(int i=1931;i<=DateTime.now().year+30;i++){
      _annee.add(i.toString());
    }
    print(_annee);
  }

  ChargeMois(){
    for(int i=2;i<=12;i++){
      if(i<10){
        _mois.add('0'+i.toString());
      }else
        _mois.add(i.toString());
    }
  }

  ChargeJour(){
    for(int i=2;i<=31;i++){
      if(i<10){
        _jour.add('0'+i.toString());
      }else
        _jour.add(i.toString());
    }
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lieu = prefs.getString("lieu");
      _username = prefs.getString("username");
      geUserByPhone(_username);
      if(prefs.getString("quartier") != "null"){
        _adresse = prefs.getString("quartier");
        adressController.text = _adresse;
      }
      if(prefs.getString("adressef") != "null"){
        _adresse = prefs.getString("adressef");
        adressController.text = _firstname;
      }
      if(prefs.getString("naissancef") != "null"){
        lieu_naiss = prefs.getString("naissancef");
        lieuController.text = lieu_naiss;
      }
      if(_lieu == "4"){
        _categorie = ['Carte Nationale d\'identité', 'Passeport'];
      }
    });
  }

  void _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("fromCountryISO", "$_fromCountryISO");
    prefs.setString("fromCardType", "$_fromCardType");
    prefs.setString("fromCardNumber", "$_fromCardNumber");
    prefs.setString("fromCardIssuingDate", "$_fromCardIssuingDate");
    prefs.setString("fromCardExpirationDate", "$_fromCardExpirationDate");
    prefs.setString("fromPays", "$_fromPays");
    prefs.setString("fromPaysName", "$_pays");
    if(_firstname != null){
      prefs.setString("nomf", "$_lastname");
      prefs.setString("prenomf", "$_firstname");
    }else
      prefs.setString("nomf", "$_name");
    prefs.setString("adressef", "$_adresse");
    prefs.setString("prenomf", "$_firstname");
    prefs.setString("naissancef", "$lieu_naiss");
    print("$_fromCountryISO, $_fromCardType, $_fromCardNumber, $_fromCardIssuingDate, $_fromCardExpirationDate");
  }

  Future<bool>loadMap() async {
    var jsonText = await rootBundle.loadString('images/map.json');
    setState(() => this.data = json.decode(jsonText));
    _paystt = [];
    for(var i=0; i<data.length; i++){
      var flagUri = 'flags/${data[i]['code'].toLowerCase()}.png';
      _paystt.add("$flagUri^${data[i]['name']}");
    }
    return true;
  }

  String getFromCountryISO(String pays){
    String sortie;
    for(var i=0; i<data.length; i++){
      if(data[i]['name'] == "$pays"){
        sortie = data[i]['code3'];
        break;
      }
    }
    return sortie;
  }

  String getFromPays(String pays){
    String sortie;
    for(var i=0; i<data.length; i++){
      if(data[i]['name'] == "$pays"){
        sortie = 'flags/${data[i]['code'].toLowerCase()}.png';
        break;
      }
    }
    return sortie;
  }

  Future<void> geUserByPhone(String phone) async {
    print("url: $base_url/transaction/getUserByUsername/$phone");
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.getUrl(Uri.parse("$base_url/transaction/getUserByUsername/$phone"));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print("statusCode ${response.statusCode}");
    print("body $reply");
    if(response.statusCode == 200){
      var responseJson = json.decode(reply);
      setState(() {
        _lastname = responseJson['lastname'];
        lastController.text = _lastname;
        _firstname = responseJson['firstname'];
        firstController.text = _firstname;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    marge = (5*MediaQuery.of(context).size.width)/414;
    return new MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white, accentColor: Color(0xFF2A2A42), fontFamily: 'Poppins'),
      routes: <String, WidgetBuilder>{
        "/transfert": (BuildContext context) =>new Transfert2(_code),
        "/transfert3": (BuildContext context) =>new Transfert3(_code),
      },
      home: new Scaffold(
        backgroundColor: GRIS,
        key: _scaffoldKey,
        appBar: new AppBar(
          elevation: 0.0,
          backgroundColor: GRIS,
          flexibleSpace: barreTop,
          leading: IconButton(
              onPressed: (){
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfert2(_code)));
              },
              icon: Icon(Icons.arrow_back_ios,color: couleur_fond_bouton,)
          ),
        ),
        body: ListView(
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
                child: new Text("Informations sur l'expéditeur",
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
                  Padding(padding: EdgeInsets.only(top: marge_libelle_champ),),

                  _lieu == "4"?Container():Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 0.0, right: 20.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Pays où la pièce a été établi, correspond au pays où la pièce d'identification (CNI, carte de séjour, passeport) a été établi.",
                        style: TextStyle(
                            color: couleur_titre,
                            fontSize: taille_champ+2
                        ),textAlign: TextAlign.justify,),
                    ),
                  ),

                  Padding(padding: EdgeInsets.only(top: marge_libelle_champ),),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Container(
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                        color: Colors.white,
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
                                fromCardType = selected;
                                if(selected == 'Carte Nationale d\'identité'){
                                  _fromCardType = 'CNI';
                                }else if(selected == 'Carte de séjour'){
                                  _fromCardType = 'Carte de sejour';
                                }else
                                  _fromCardType = selected;
                              });
                            },
                            value: fromCardType,
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

                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                    child: Container(
                      margin: EdgeInsets.only(top: 0.0),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: bordure,
                          color: couleur_bordure,
                        ),
                      ),
                      height: hauteur_champ,
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                            flex:2,
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(Icons.assignment_ind, color: couleur_decription_page,)//new Image.asset('images/Groupe177.png'),
                            ),
                          ),
                          new Expanded(
                            flex:10,
                            child: Padding(
                              padding: EdgeInsets.only(left:0.0),
                              child: new TextFormField(
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                    fontSize: taille_champ+3,
                                    color: couleur_libelle_champ
                                ),
                                validator: (String value){
                                  if(value.isEmpty){
                                    return "Champ numéro de la pièce d\'identité vide!";
                                  }else{
                                    _fromCardNumber = value;
                                    return null;
                                  }
                                },
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Numéro de la pièce d\'identité',
                                  hintStyle: TextStyle(color: couleur_libelle_champ,
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

                  isClicked1 == false?Container():Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                    child: Container(
                      margin: EdgeInsets.only(top: 0.0),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: bordure,
                          color: couleur_bordure,
                        ),
                      ),
                      height: hauteur_champ,
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                            flex:2,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: new Icon(Icons.calendar_today, color: couleur_decription_page,),//Image.asset('images/Groupe177.png'),
                            ),
                          ),
                          Expanded(
                            flex:3,
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isDense: true,
                                  elevation: 1,
                                  isExpanded: true,
                                  onChanged: (String selected){
                                    setState(() {
                                      jr = selected;
                                    });
                                  },
                                  value: jr,
                                  hint: Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text('Jour',
                                      style: TextStyle(
                                        color: couleur_libelle_champ,
                                        fontSize:taille_champ+3,
                                      ),),
                                  ),
                                  items: _jour.map((String name){
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
                          Expanded(
                            flex:3,
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isDense: true,
                                  elevation: 1,
                                  isExpanded: true,
                                  onChanged: (String selected){
                                    setState(() {
                                      mo = selected;
                                    });
                                  },
                                  value: mo,
                                  hint: Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text('Mois',
                                      style: TextStyle(
                                        color: couleur_libelle_champ,
                                        fontSize:taille_champ+3,
                                      ),),
                                  ),
                                  items: _mois.map((String name){
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
                          Expanded(
                            flex:4,
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isDense: true,
                                  elevation: 1,
                                  isExpanded: true,
                                  onChanged: (String selected){
                                    setState(() {
                                      an = selected;
                                    });
                                  },
                                  value: an,
                                  hint: Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text('Année',
                                      style: TextStyle(
                                        color: couleur_libelle_champ,
                                        fontSize:taille_champ+3,
                                      ),),
                                  ),
                                  items: _annee.map((String name){
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
                        ],
                      ),
                    ),
                  ),

//_fromCardIssuingDate = DateTime.now().toString().split(" ")[0].split("-")[1]+"/"+DateTime.now().toString().split(" ")[0].split("-")[2]+"/"+DateTime.now().toString().split(" ")[0].split("-")[0];
                  isClicked1==true?Container():Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                    child: Container(
                      margin: EdgeInsets.only(top: 0.0),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: bordure,
                          color: couleur_bordure,
                        ),
                      ),
                      height: hauteur_champ,
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                            flex:2,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: new Icon(Icons.calendar_today, color: couleur_decription_page,),//Image.asset('images/Groupe177.png'),
                            ),
                          ),
                          new Expanded(
                            flex:10,
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  isClicked1 = true;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 0.0),
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    width: bordure,
                                    color: Colors.white,
                                  ),
                                ),
                                height: hauteur_champ,
                                child: Row(
                                  children: <Widget>[
                                    new Expanded(
                                      flex:12,
                                      child: new TextFormField(
                                        keyboardType: TextInputType.text,
                                        enabled: false,
                                        style: TextStyle(
                                          fontSize: taille_champ+3,
                                          color: couleur_libelle_champ,
                                        ),
                                        validator: (String value){
                                          if(value.isEmpty){
                                            return null;
                                          }else{
                                            _fromCardIssuingDate = value;
                                            return null;
                                          }

                                        },
                                        decoration: InputDecoration.collapsed(
                                          hintText: _fromCardIssuingDate.isEmpty?'Date de délivrance':_fromCardIssuingDate,
                                          hintStyle: TextStyle(color: couleur_libelle_champ,
                                            fontSize: taille_champ+3,
                                          ),
                                          //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
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
                    ),
                  ),

                  isClicked2 == true?Container():Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                    child: Container(
                      margin: EdgeInsets.only(top: 0.0),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: bordure,
                          color: couleur_bordure,
                        ),
                      ),
                      height: hauteur_champ,
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                            flex:2,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: new Icon(Icons.calendar_today, color: couleur_decription_page,),//Image.asset('images/Groupe177.png'),
                            ),
                          ),
                          new Expanded(
                            flex:10,
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  isClicked2 = true;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 0.0),
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    width: bordure,
                                    color: Colors.white,
                                  ),
                                ),
                                height: hauteur_champ,
                                child: Row(
                                  children: <Widget>[
                                    new Expanded(
                                      flex:12,
                                      child: new TextFormField(
                                        keyboardType: TextInputType.text,
                                        enabled: false,
                                        style: TextStyle(
                                          fontSize: taille_champ+3,
                                          color: couleur_libelle_champ,
                                        ),
                                        validator: (String value){
                                          if(value.isEmpty){
                                            return null;
                                          }else{
                                            _fromCardExpirationDate = value;
                                            return null;
                                          }

                                        },
                                        decoration: InputDecoration.collapsed(
                                          hintText: _fromCardExpirationDate.isEmpty?'Date d\'expiration':_fromCardExpirationDate,
                                          hintStyle: TextStyle(color: couleur_libelle_champ,
                                            fontSize: taille_champ+3,
                                          ),
                                          //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
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
                    ),
                  ),

                  isClicked2 == false?Container():Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                    child: Container(
                      margin: EdgeInsets.only(top: 0.0),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: bordure,
                          color: couleur_bordure,
                        ),
                      ),
                      height: hauteur_champ,
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                            flex:2,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: new Icon(Icons.calendar_today, color: couleur_decription_page,),//Image.asset('images/Groupe177.png'),
                            ),
                          ),
                          Expanded(
                            flex:3,
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isDense: true,
                                  elevation: 1,
                                  isExpanded: true,
                                  onChanged: (String selected){
                                    setState(() {
                                      jr1 = selected;
                                    });
                                  },
                                  value: jr1,
                                  hint: Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text('Jour',
                                      style: TextStyle(
                                        color: couleur_libelle_champ,
                                        fontSize:taille_champ+3,
                                      ),),
                                  ),
                                  items: _jour.map((String name){
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
                          Expanded(
                            flex:3,
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isDense: true,
                                  elevation: 1,
                                  isExpanded: true,
                                  onChanged: (String selected){
                                    setState(() {
                                      mo1 = selected;
                                    });
                                  },
                                  value: mo1,
                                  hint: Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text('Mois',
                                      style: TextStyle(
                                        color: couleur_libelle_champ,
                                        fontSize:taille_champ+3,
                                      ),),
                                  ),
                                  items: _mois.map((String name){
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
                          Expanded(
                            flex:4,
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isDense: true,
                                  elevation: 1,
                                  isExpanded: true,
                                  onChanged: (String selected){
                                    setState(() {
                                      an1 = selected;
                                    });
                                  },
                                  value: an1,
                                  hint: Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text('Année',
                                      style: TextStyle(
                                        color: couleur_libelle_champ,
                                        fontSize:taille_champ+3,
                                      ),),
                                  ),
                                  items: _annee.map((String name){
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
                        ],
                      ),
                    ),
                  ),

                  _lieu == "4"?Container():Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Container(
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                        color: Colors.white,
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
                                _pays = selected;
                                _fromCountryISO = getFromCountryISO(selected);
                                _fromPays = getFromPays(selected);
                                print(_fromPays);
                              });
                            },
                            value: _pays,
                            hint: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text('Pays où la pièce a été établie',
                                style: TextStyle(
                                  color: couleur_libelle_champ,
                                  fontSize:taille_champ+3,
                                ),),
                            ),
                            items: _paystt.map((String name){
                              return DropdownMenuItem<String>(
                                value:name.split('^').length>1? name.split('^')[1].length>22?name.split('^')[1].substring(0,22)+'...':name.split('^')[1]:"",
                                child: Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 30,
                                        width: 40,
                                        child:name.split('^').length>1? Image.asset(name.split('^')[0]):Container(),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(name.split('^').length>1?name.split('^')[1].length>22?name.split('^')[1].substring(0,22)+'...':name.split('^')[1]:"",
                                          style: TextStyle(
                                              color: couleur_libelle_champ,
                                              fontSize:taille_champ+3,
                                              fontWeight: FontWeight.normal
                                          ),),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          )
                      ),
                    ),
                  ),
                  _lieu == "4"?Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                    child: Container(
                      margin: EdgeInsets.only(top: 0.0),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: bordure,
                          color: couleur_bordure,
                        ),
                      ),
                      height: hauteur_champ,
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                            flex:2,
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(Icons.location_city, color: couleur_decription_page,)//new Image.asset('images/Groupe177.png'),
                            ),
                          ),
                          new Expanded(
                            flex:10,
                            child: Padding(
                              padding: EdgeInsets.only(left:0.0),
                              child: new TextFormField(
                                //controller: lieuController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                    fontSize: taille_champ+3,
                                    color: couleur_libelle_champ
                                ),
                                validator: (String value){
                                  if(value.isEmpty){
                                    return "Champ lieu de naissance vide!";
                                  }else{
                                    lieu_naiss = value;
                                    return null;
                                  }
                                },
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Lieu de naissance',
                                  hintStyle: TextStyle(color: couleur_libelle_champ,
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
                  ):Container(),
                  _lieu == "4"? Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Container(
                      margin: EdgeInsets.only(top: 0.0),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: bordure,
                          color: couleur_bordure,
                        ),
                      ),
                      height: hauteur_champ,
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                            flex:2,
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: new Icon(Icons.person, color: couleur_decription_page,)//Image.asset('images/Groupe177.png'),
                            ),
                          ),
                          new Expanded(
                            flex:10,
                            child: Padding(
                              padding: EdgeInsets.only(left:0.0),
                              child: new TextFormField(
                                controller: firstController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  fontSize: taille_champ+3,
                                  color: couleur_libelle_champ,
                                ),
                                validator: (String value){
                                  if(value.isEmpty){
                                    _firstname = "";
                                    return null;
                                  }else{
                                    _firstname = value;
                                    return null;
                                  }
                                },
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Prénom',
                                  hintStyle: TextStyle(color: couleur_libelle_champ,
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
                  ):Container(),

                  _lieu == "4"?Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                    child: Container(
                      margin: EdgeInsets.only(top: 0.0),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: bordure,
                          color: couleur_bordure,
                        ),
                      ),
                      height: hauteur_champ,
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                            flex:2,
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(Icons.person, color: couleur_decription_page,)//new Image.asset('images/Groupe177.png'),
                            ),
                          ),
                          new Expanded(
                            flex:10,
                            child: Padding(
                              padding: EdgeInsets.only(left:0.0),
                              child: new TextFormField(
                                controller: lastController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                    fontSize: taille_champ+3,
                                    color: couleur_libelle_champ
                                ),
                                validator: (String value){
                                  if(value.isEmpty){
                                    return "Champ nom vide!";
                                  }else{
                                    _lastname = value;
                                    return null;
                                  }
                                },
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Nom',
                                  hintStyle: TextStyle(color: couleur_libelle_champ,
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
                  ):Container(),

                  _lieu == "4"?Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                    child: Container(
                      margin: EdgeInsets.only(top: 0.0),
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                        color: Colors.white,
                        border: Border.all(
                          width: bordure,
                          color: couleur_bordure,
                        ),
                      ),
                      height: hauteur_champ,
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                            flex:2,
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(Icons.location_on, color: couleur_decription_page,)//new Image.asset('images/Groupe177.png'),
                            ),
                          ),
                          new Expanded(
                            flex:10,
                            child: Padding(
                              padding: EdgeInsets.only(left:0.0),
                              child: new TextFormField(
                                controller: adressController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                    fontSize: taille_champ+3,
                                    color: couleur_libelle_champ
                                ),
                                validator: (String value){
                                  if(value.isEmpty){
                                    return "Champ adresse vide!";
                                  }else{
                                    _adresse = value;
                                    return null;
                                  }
                                },
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Adresse',
                                  hintStyle: TextStyle(color: couleur_libelle_champ,
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
                  ):Container(),

                  Padding(
                    padding: EdgeInsets.only(top: marge_champ_libelle, bottom: 20),
                    child: InkWell(
                      onTap: () async {
                        setState(() {
                          if(_formKey.currentState.validate()) {
                            if (_fromCardType!=null) {
                              if (jr != null && mo != null && an != null) {
                                if (jr1 != null && mo1 != null && an1 != null) {
                                  if(_fromCountryISO != null || _lieu == "4"){
                                    _fromCardIssuingDate = jr+'-'+mo+'-'+an;
                                    _fromCardExpirationDate = jr1+'-'+mo1+'-'+an1;
                                    _name = "$_firstname $_lastname";
                                    this._save();
                                    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfert3(_code)));
                                  }else{
                                    print("_lieu vaut: $_lieu");
                                    showInSnackBar("Pays d'établissement de la pièce d'identification vide!", _scaffoldKey, 5);
                                  }
                                } else {
                                  showInSnackBar("Date d'expiration vide!", _scaffoldKey, 5);
                                }
                              } else {
                                showInSnackBar("Date de délivrance vide!", _scaffoldKey, 5);
                              }
                            }else{
                              showInSnackBar("Nature de la pièce d'identification vide!", _scaffoldKey, 5);
                            }
                          }
                        });
                      },
                      child: new Container(
                        height: hauteur_champ,
                        width: MediaQuery.of(context).size.width-40,
                        decoration: new BoxDecoration(
                          color: couleur_fond_bouton,
                          border: new Border.all(
                            color: Colors.white,
                            width: 0.0,
                          ),
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        child: Center(child: new Text('Poursuivre', style: new TextStyle(fontSize: taille_text_bouton+3, color: Colors.white),)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: barreBottom,
      ),
    );
  }
}