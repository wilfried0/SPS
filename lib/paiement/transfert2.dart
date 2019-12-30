import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:services/composants/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'transfert1.dart';
import 'transfert3.dart';

// ignore: must_be_immutable
class Transfert2 extends StatefulWidget {
  Transfert2(this._code);
  String _code;
  @override
  _Transfert2State createState() => new _Transfert2State(_code);
}



class _Transfert2State extends State<Transfert2> {
  double marge;
  List data;
  _Transfert2State(this._code);
  String _code;
  String _firstname, _lastname, _to, _adresse, _lieu;
  var _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _name, _sername;

  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState(){
    this.read();
    super.initState();
  }

  void _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("to", "$_sername");
    prefs.setString("nomd", "$_name");
    if(_lieu == "3"){
      prefs.setString("adresse", "$_adresse");
    }
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lieu = prefs.getString("lieu");
    });
  }

  @override
  Widget build(BuildContext context) {
    marge = (5*MediaQuery.of(context).size.width)/414;

    return new MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white, accentColor: Color(0xFF2A2A42), fontFamily: 'Poppins'),
      routes: <String, WidgetBuilder>{
        "/transfert": (BuildContext context) =>new Transfert1(_code),
        "/transfert3": (BuildContext context) =>new Transfert3(_code),
      },
      home: new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          elevation: 0.0,
          backgroundColor: couleur_appbar,
          flexibleSpace: barreTop,
          leading: InkWell(
              onTap: (){
                setState(() {
                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfert1(_code)));
                  //Navigator.of(context).push(SlideLeftRoute(enterWidget: Connexion(_code), oldWidget: Inscription(_code)));
                });
              },
              child: Icon(Icons.arrow_back_ios,)),
          iconTheme: new IconThemeData(color: couleur_fond_bouton),
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
                child: new Text(_lieu=="3"?"Informations sur le bénéficiaire":"Ajouter un bénéficiaire",
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

                  Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 0.0, right: 20.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Veuillez écrire le nom légal complet, comme indiqué sur le passeport, permi de conduire, ou CNI (Carte Nationale d'Identité) du bénéficiaire.",
                        style: TextStyle(
                            color: couleur_titre,
                            fontSize: taille_champ
                        ),textAlign: TextAlign.justify,),
                    ),
                  ),

                  Padding(padding: EdgeInsets.only(top: marge_libelle_champ),),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Container(
                      margin: EdgeInsets.only(top: 0.0),
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                        color: Colors.transparent,
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
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                    child: Container(
                      margin: EdgeInsets.only(top: 0.0),
                      decoration: new BoxDecoration(
                        color: Colors.transparent,
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
                  ),

                  _lieu=="3"?Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                    child: Container(
                      margin: EdgeInsets.only(top: 0.0),
                      decoration: new BoxDecoration(
                        color: Colors.transparent,
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
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
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
                              child: new Image.asset('flags/'+_code.split('^')[1].toLowerCase()+'.png'),
                            ),
                          ),
                          Expanded(
                            flex:2,
                            child: Padding(
                                padding: const EdgeInsets.only(left:0.0,),
                                child: new Text(this._code.split('^')[0],
                                  style: TextStyle(
                                    color: couleur_champ,
                                    fontSize: taille_champ+3,
                                  ),)
                            ),
                          ),
                          new Expanded(
                            flex:8,
                            child: new TextFormField(
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                fontSize: taille_champ+3,
                                color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return "Champ téléphone vide !";
                                }else{
                                  _to = this._code.split('^')[0].substring(1)+value;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Numéro de téléphone',
                                hintStyle: TextStyle(
                                    fontSize: taille_champ+3,
                                    color: couleur_libelle_champ
                                ),
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  Padding(padding: EdgeInsets.only(top: marge_champ_libelle),),

                  InkWell(
                    onTap: () async {
                      setState(() {
                        if(_formKey.currentState.validate()){
                          _name = "$_firstname $_lastname";
                          _sername = _to;
                          if(_lieu=="3"){
                            this._save();
                            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfer(_code)));
                          }else{
                            this._save();
                            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfert3(_code)));
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
                          color: Colors.transparent,
                          width: 0.0,
                        ),
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      child: Center(child: new Text('Poursuivre', style: new TextStyle(fontSize: taille_text_bouton+3, color: Colors.white),)
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


class Transfer extends StatefulWidget {
  Transfer(this._code);
  String _code;
  @override
  _TransferState createState() => _TransferState(_code);
}

class _TransferState extends State<Transfer> {
  _TransferState(this._code);
  String _code;
  String _firstname, _lastname, _to, _fromCountryISO, _pays,_fromPays, _fromCardType, _fromCardNumber, _fromCardIssuingDate="", _fromCardExpirationDate="";
  var _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _name, _sername;
  final navigatorKey = GlobalKey<NavigatorState>();
  double marge;
  var _categorie = ['Carte Nationale d\'identité', 'Passeport', 'Carte de séjour'];
  var _paystt = ['hi'];
  var _flag;
  List data;
  int _date = new DateTime.now().year;

  @override
  void initState() {
    this.loadMap();
    // TODO: implement initState
    super.initState();
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

  Future _selectDate(int q) async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime(1960),
        firstDate: new DateTime(1960),
        //locale : const Locale("fr","FR"),
        lastDate: new DateTime(_date+1)
    );
    if(picked != null){
      if(q == 0){
        setState(() {
          _fromCardIssuingDate = picked.toString().split(" ")[0].replaceAll("-", "/");
        });
      }else{
        setState(() {
          _fromCardExpirationDate = picked.toString().split(" ")[0].replaceAll("-", "/");
        });
      }
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
        key: _scaffoldKey,
        appBar: new AppBar(
          elevation: 0.0,
          backgroundColor: couleur_appbar,
          flexibleSpace: barreTop,
          leading: InkWell(
              onTap: (){
                setState(() {
                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfert2(_code)));
                  //Navigator.of(context).push(SlideLeftRoute(enterWidget: Connexion(_code), oldWidget: Inscription(_code)));
                });
              },
              child: Icon(Icons.arrow_back_ios,)),
          iconTheme: new IconThemeData(color: couleur_fond_bouton),
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

                 Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 0.0, right: 20.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Pays où la pièce a été établi, correspond au pays où la pièce d'identification (CNI, carte de séjour, passeport) a été établi.",
                        style: TextStyle(
                            color: couleur_titre,
                            fontSize: taille_champ
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
                                _fromCardType = selected;
                              });
                            },
                            value: _fromCardType,
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
                        color: Colors.transparent,
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


                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                    child: Container(
                      margin: EdgeInsets.only(top: 0.0),
                      decoration: new BoxDecoration(
                        color: Colors.transparent,
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
                                _selectDate(0);
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 0.0),
                                decoration: new BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                    width: bordure,
                                    color: Colors.transparent,
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

                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                    child: Container(
                      margin: EdgeInsets.only(top: 0.0),
                      decoration: new BoxDecoration(
                        color: Colors.transparent,
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
                                _selectDate(1);
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 0.0),
                                decoration: new BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                    width: bordure,
                                    color: Colors.transparent,
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

                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Container(
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
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

                  Padding(padding: EdgeInsets.only(top: marge_champ_libelle),),

                  InkWell(
                    onTap: () async {
                      setState(() {
                        if(_formKey.currentState.validate()) {
                          if (_fromCardType!=null) {
                            if (_fromCardIssuingDate.isNotEmpty) {
                              if (_fromCardExpirationDate.isNotEmpty) {
                                if(_fromCountryISO.isNotEmpty){
                                  this._save();
                                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfert3(_code)));
                                }else{
                                  showInSnackBar("Pays d'établissement de la pièce d'identification vide!", _scaffoldKey);
                                }
                              } else {
                                showInSnackBar("Date d'expiration vide!", _scaffoldKey);
                              }
                            } else {
                              showInSnackBar("Date de délivrance vide!", _scaffoldKey);
                            }
                          }else{
                            showInSnackBar("Nature de la pièce d'identification vide!", _scaffoldKey);
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
                          color: Colors.transparent,
                          width: 0.0,
                        ),
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      child: Center(child: new Text('Poursuivre', style: new TextStyle(fontSize: taille_text_bouton+3, color: Colors.white),)
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
