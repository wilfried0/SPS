import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:page_transition/page_transition.dart';
import 'package:services/auth/profile.dart';
import 'package:services/composants/components.dart';
import 'package:services/paiement/carte2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'getsoldewidget.dart';

class Carte1 extends StatefulWidget {
  @override
  _Carte1State createState() => _Carte1State();
}

class _Carte1State extends State<Carte1> {
  int choice = 0;
  String _iso3, _firstname, _lastname, deviseLocale, _name, jr, mo, an, lieu_naiss, _username, flagUri, _phone, _sername, _mySelection, _password, montant, local, fromCardType, idOrPassport, expiryDate="";
  var _formKey = GlobalKey<FormState>(), firstController, lastController, adressController, lieuController, phoneTextController, montantController, _categorie = ['Carte Nationale d\'identité', 'Passeport'], _annee = ['1930'], _mois = ['01'], _jour = ['01'];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double _taill, ad=3, newSolde, fees;
  bool _isLoding = false, isClicked = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    read();
    firstController = new TextEditingController();
    lastController = new TextEditingController();
    phoneTextController = new TextEditingController();
    montantController = new MoneyMaskedTextController(decimalSeparator: '', thousandSeparator: '.', precision: 0);
    //this.ChargeAnnee();
    this.ChargeMois();
    //this.ChargeJour();
  }

  @override
  void dispose() {
    firstController.dispose();
    lastController.dispose();
    phoneTextController.dispose();
    montantController.dispose();
    super.dispose();
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString("username");
      _sername = prefs.getString("sername");
      phoneTextController.text = _sername;
      deviseLocale = prefs.getString("deviseLocale");
      flagUri = prefs.getString("flag");
      _mySelection = prefs.getString("dial");
      local = prefs.getString("local");
      _iso3 = prefs.getString("iso3");
    });
    geUserByPhone(_username);
  }

  ChargeAnnee(){
    _annee.clear();
    for(int i=DateTime.now().year;i<=DateTime.now().year+3;i++){
      _annee.add(i.toString());
    }
    print(_annee);
  }

  ChargeMois(){
    for(int i=2;i<=40;i++){
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
    double fromHeight = 200;
    final _large = MediaQuery.of(context).size.width;
    final _haut = MediaQuery.of(context).size.height;
    if(_large<=320){
      _taill = taille_description_champ-2;
      ad = 3;
    }else if(_large>320 && _large<=360 && _haut==738){
      _taill = taille_description_champ-1;
      ad = 3;
    }else if(_large>320 && _large<=360){
      _taill = taille_description_champ+3;
      ad = 3;
    }else if(_large == 375.0){
      _taill = taille_description_champ;
      ad = 0;
    }else if(_large>360){
      _taill = taille_description_champ;
      ad = 3;
    }else if(_large>411 && _large<412){
      _taill = taille_description_champ;
      ad = 3;
    }

    return Scaffold(
      key: _scaffoldKey,
        backgroundColor: GRIS,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(fromHeight),
          child: new Container(
            color: bleu_F,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 23, left: 20, right: 20),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                          onPressed: (){
                            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Profile('')));
                          },
                          icon: Icon(Icons.arrow_back_ios,color: Colors.white,)
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Profile('')));
                        },
                        child: Text('Retour',
                          style: TextStyle(color: Colors.white, fontSize: taille_champ),),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Commander une carte\nprépayée",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: taille_titre-2,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                getSoldeWidget(),
              ],
            ),
          ),
        ),
        body: getView(context),
        bottomNavigationBar: barreBottom
    );
  }

  // ignore: missing_return
  Widget getView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: ListView(
        shrinkWrap: true,
        children: [
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        choice = 0;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                            ) ,
                            color: choice == 0?Colors.white:couleur_champ,
                            border: Border.all(
                                color: choice == 0?orange_F:couleur_bordure
                            )
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: 50,
                                width: 50,
                                child: new Image.asset('images/credit-card.png')),
                            new Text("Virtuelle",style: TextStyle(
                                color:choice == 0? orange_F:couleur_bordure,
                                fontSize:MediaQuery.of(context).size.width>=1000?20: _taill,
                                fontWeight: FontWeight.bold
                            ),)
                          ],
                        ),
                      ),
                    ),
                  )
              ),

              Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        choice = 1;
                      });
                      showInSnackBar("Service bientôt disponible", _scaffoldKey, 5);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width-30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                            ) ,
                            color: choice == 1?Colors.white:couleur_champ,
                            border: Border.all(
                                color: choice == 1?orange_F:couleur_bordure
                            )
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: 50,
                                width: 50,
                                child: new Image.asset('images/credit-card-2.png')),
                            new Text("Physique",style: TextStyle(
                                color: choice == 1? orange_F:couleur_bordure,
                                fontSize:MediaQuery.of(context).size.width>=1000?20: _taill,
                                fontWeight: FontWeight.bold
                            ),)
                          ],
                        ),
                      ),
                    ),
                  )
              )
            ],
          ),



          choice == 1?Container(
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/3),
              child: Text("Service pas encore disponible.", style: TextStyle(),
                textAlign: TextAlign.center,
              ),
            ),
          )
              :Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
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

                  Container(
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
                                  return "Numéro de la pièce d\'identité vide!";
                                }else{
                                  idOrPassport = value;
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

                  Container(
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
                            child: new Icon(Icons.person, color: couleur_decription_page,),//
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
                                fontSize: taille_champ+ad,
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
                                hintText: 'Prénom(s)',
                                hintStyle: TextStyle(color: couleur_libelle_champ,
                                    fontSize: taille_champ+ad
                                ),
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
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
                            child: new Icon(Icons.person, color: couleur_decription_page,),//Image.asset('images/Groupe177.png'),
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
                                fontSize: taille_champ+ad,
                                color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return "Champ nom vide !";
                                }else{
                                  _lastname = value;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Nom(s)',
                                hintStyle: TextStyle(color: couleur_libelle_champ,
                                    fontSize: taille_champ+ad
                                ),
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: couleur_bordure,
                          width: bordure
                      ),
                    ),
                    height: hauteur_champ,
                    child:_mySelection==null?Container(): Row(
                      children: <Widget>[
                        Expanded(
                            flex: 5,
                            child: CountryCodePicker(
                              showFlag: true,
                              textStyle: TextStyle(
                                  fontSize: taille_libelle_champ+ad,
                                  color: couleur_libelle_champ
                              ),
                              initialSelection:_mySelection,
                              onChanged: (CountryCode code) {
                                setState(() {
                                  _mySelection = code.dialCode.toString();
                                  _iso3 = code.codeIso;
                                });
                              },
                            )
                        ),
                        new Expanded(
                          flex:10,
                          child: new TextFormField(
                            controller: phoneTextController,
                            keyboardType: TextInputType.phone,
                            style: TextStyle(
                              fontSize: taille_libelle_champ+ad,
                              color: couleur_libelle_champ,
                            ),
                            validator: (String value){
                              if(value.isEmpty){
                                return "Numéro de téléphone invalide !";//SitLocalizations.of(context).invalid_phone;
                              }else{
                                if(_mySelection == "+33" && value.startsWith("0")){
                                  _phone = _mySelection+value.substring(1);// _mySelection.substring(1)+value.substring(1);
                                  _sername = value.substring(1);
                                }else{
                                  _phone = _mySelection+value;//_mySelection.substring(1)+value;
                                  _sername = value;
                                }
                                return null;
                              }
                            },
                            decoration: InputDecoration.collapsed(
                              hintText:"Numéro de téléphone",// SitLocalizations.of(context).phone,
                              hintStyle: TextStyle(
                                fontSize: taille_libelle_champ+ad,
                                color: couleur_libelle_champ,
                              ),
                              //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  Container(
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
                            child: new Icon(Icons.monetization_on, color: couleur_decription_page,),//Image.asset('images/Groupe177.png'),
                          ),
                        ),
                        new Expanded(
                          flex:10,
                          child: Padding(
                            padding: EdgeInsets.only(left:0.0),
                            child: new TextFormField(
                              controller: montantController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: taille_champ+ad,
                                color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                if(value.isEmpty || value == "0"){
                                  return "Champ montant vide !";
                                }else{
                                  montant = value;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Montant',
                                hintStyle: TextStyle(color: couleur_libelle_champ,
                                    fontSize: taille_champ+ad
                                ),
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  isClicked == true?Container():Container(
                    margin: EdgeInsets.only(top: 0.0),
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.only(
                        bottomRight: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
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
                            child: new Icon(Icons.calendar_today, color: couleur_decription_page,),//Image.asset('images/Groupe177.png'),
                          ),
                        ),
                        new Expanded(
                          flex:10,
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                isClicked = true;
                              });
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
                                        fontSize: taille_champ+ad,
                                        color: couleur_libelle_champ,
                                      ),
                                      validator: (String value){
                                        if(value.isEmpty){
                                          return null;
                                        }else{
                                          expiryDate = value;
                                          return null;
                                        }

                                      },
                                      decoration: InputDecoration.collapsed(
                                        hintText: expiryDate.isEmpty?'Nombre de mois de la virtuelle carte':expiryDate,
                                        hintStyle: TextStyle(color: couleur_libelle_champ,
                                          fontSize: taille_champ+ad,
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

                  isClicked == false?Container():Container(
                    margin: EdgeInsets.only(top: 0.0),
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.only(
                        bottomRight: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
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
                            padding: EdgeInsets.only(left: 15, top: 10, right: 10, bottom: 10),
                            child: new Icon(Icons.calendar_today, color: couleur_decription_page,),//Image.asset('images/Groupe177.png'),
                          ),
                        ),
                        /*Expanded(
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
                        ),*/
                        Expanded(
                          flex:12,
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isDense: true,
                                elevation: 1,
                                isExpanded: true,
                                onChanged: (String selected){
                                  setState(() {
                                    mo = selected;
                                    expiryDate = mo;
                                  });
                                },
                                value: mo,
                                hint: Text('Mois',
                                  style: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize:taille_champ+3,
                                  ),),
                                items: _mois.map((String name){
                                  return DropdownMenuItem<String>(
                                    value: name,
                                    child: Text(name+" mois",
                                      style: TextStyle(
                                          color: couleur_libelle_champ,
                                          fontSize:taille_champ+3,
                                          fontWeight: FontWeight.normal
                                      ),),
                                  );
                                }).toList(),
                              )
                          ),
                        ),
                        /*Expanded(
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
                        ),*/
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10),
                    child: new GestureDetector(
                      onTap: () {
                        setState(() {
                          if(_formKey.currentState.validate()){
                            if(fromCardType == null){
                              showInSnackBar("Veuillez sélectionner le type de pièce!", _scaffoldKey, 5);
                            }else if(expiryDate.isEmpty || expiryDate.contains("null")){
                              showInSnackBar("Date d'expiration de la carte invalide!", _scaffoldKey, 5);
                            }else{
                              var getcommission = getCommission(
                                  typeOperation:"WALLET_TO_WALLET",
                                  country: "$_iso3",
                                  amount: int.parse(this.montant.replaceAll(".", "")),
                                  deviseLocale: deviseLocale
                              );
                              print(json.encode(getcommission));
                              checkConnection(json.encode(getcommission));
                            }
                          }
                        });
                      },
                      child: new Container(
                        height: hauteur_champ,
                        width: MediaQuery.of(context).size.width - 40,
                        decoration: new BoxDecoration(
                          color: couleur_fond_bouton,
                          border: new Border.all(
                            color: Colors.transparent,
                            width: 0.0,
                          ),
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        child: new Center(
                          child: _isLoding == false? new Text('Suivant', style: new TextStyle(fontSize: taille_text_bouton+ad, color: couleur_text_bouton),):
                          Theme(
                              data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.dark)),
                              child: CupertinoActivityIndicator(radius: 20,)),
                        ),
                      ),
                    ),
                  ),
                ],
              )
          )
        ],
      ),
    );
  }

  void checkConnection(var body) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      //print("Connected to Mobile");
      setState(() {
        _isLoding = true;
      });
      this.getSoldeCommission(body);
    } else if (connectivityResult == ConnectivityResult.wifi) {
      //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Connexion(_code)));
      setState(() {
        _isLoding = true;
      });
      this.getSoldeCommission(body);
    } else {
      _ackAlert(context);
    }
  }

  Future<void> _ackAlert(BuildContext context) {
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

  Future<String> getSoldeCommission(var body) async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString("username");
    _password = prefs.getString("password");
    print("$_username, $_password");
    String fee = "$base_url/transaction/getFeesTransaction";
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse("$fee"));
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
        _isLoding = false;
      });
      throw new Exception("Error while fetching data");
    }else if(response.statusCode == 200){
      var responseJson = json.decode(reply);
      fees = responseJson['fees'];
      newSolde = double.parse(montant)+fees;
      if(newSolde<=double.parse(local)){
        this._save();
        setState(() {
          _isLoding = false;
        });
        this._save();
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Carte2()));
      }else{
        setState(() {
          _isLoding = false;
        });
        showInSnackBar("Solde insuffisant pour effectuer la commande!", _scaffoldKey, 5);
      }
    }else {
      setState(() {
        _isLoding = false;
      });
      showInSnackBar("Service indisponible!", _scaffoldKey, 5);
    }
  }

  void _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("montant", "${montant.replaceAll(".", "")}");
    prefs.setString("fees", "$fees");
    prefs.setString("firstname", "$_firstname");
    prefs.setString("lastname", "$_lastname");
    prefs.setString("expiredate", "$expiryDate");
    prefs.setString("cellphoneNumber", "$_phone");
    prefs.setString("idOrPassport", "$idOrPassport");
  }
}
