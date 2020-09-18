import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:services/composants/components.dart';
import 'package:services/paiement/transfer.dart';
import 'package:services/paiement/transferO.dart';
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
  String _firstname, codeIso2, _lastname, _to, _adresse, _lieu, dial, _ville, numero, banque, bank,url;
  var _formKey = GlobalKey<FormState>();
  var _nature = ['Account', 'Cash'];
  var _banks = ['Non repertoriée'];
  var _bankFull = ['Non repertoriée'];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _name, _sername, type;
  bool _enable = true;
  final numberController = TextEditingController();

//Endpoint : http://74.208.183.205:8086/corebanking/rest/transaction/getBankName/{iso2Country}
  @override
  void initState(){
    url = "$base_url/transaction/getBankName/";
    this.read();
    super.initState();
  }

  @override
  void dispose(){
    numberController.dispose();
    super.dispose();
  }


  void _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("to", "$_sername");
    prefs.setString("nomt", "$_lastname");
    prefs.setString("prenomt", "$_firstname");
    prefs.setString("nomd", "$_name");
    prefs.setString("type", "$type");
    prefs.setString("bankName", "$banque");
    prefs.setString("accountNumber", "$numero");
    prefs.setString("villed", "$_ville");
    if(_lieu == "3" || _lieu == "4" || _lieu == "5"){
      prefs.setString("adresse", "$_adresse");
    }
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lieu = prefs.getString("lieu");
      codeIso2 = prefs.getString("codeIso2");
      if(_lieu == "5")
        getBank(codeIso2);
      dial = prefs.getString("DIAL");
      print("mon code iso2 ==> $codeIso2");
    });
  }

  getBank(String iso) async {
    final prefs = await SharedPreferences.getInstance();
    String _username = prefs.getString("username");
    String _password = prefs.getString("password");
    print("$_username, $_password");
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);

    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    print("$url$iso");
    HttpClientRequest request = await client.getUrl(Uri.parse("$url$iso"));
    request.headers.set('Accept', 'application/json');
    request.headers.set('Authorization', 'Basic $credentials');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print(response.statusCode);
    print(reply);
    if(response.statusCode == 200){
      List responseJson = json.decode(reply);
      _banks = [];
      _bankFull = [];
      setState(() {
        for(int i=0; i<responseJson.length; i++){
          _bankFull.add(responseJson[i]['bankNameFull']);
          _banks.add(responseJson[i]['bankName']);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    marge = (5*MediaQuery.of(context).size.width)/414;
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: GRIS,
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: GRIS,
        flexibleSpace: barreTop,
        leading: IconButton(
            onPressed: (){
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfert1(_code)));
            },
            icon: Icon(Icons.arrow_back_ios,color: couleur_fond_bouton,)
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: hauteur_logo,
            child: new Image.asset('images/logo.png'),
          ),

          Padding(padding: EdgeInsets.only(top: marge_apres_logo),),

          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: new Text(_lieu=="3" || _lieu == "4" || _lieu == "5"?"Informations sur le bénéficiaire":"Ajouter un bénéficiaire",
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
                          fontSize: taille_champ+2
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

                _lieu=="3" || _lieu == "4" || _lieu == "5"?Padding(
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
                _lieu=="5" || _lieu == "4"?Padding(
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
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  fontSize: taille_champ+3,
                                  color: couleur_libelle_champ
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return "Champ ville vide!";
                                }else{
                                  _ville = value;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Ville',
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
                      color: Colors.white,
                      border: Border.all(
                        width: bordure,
                        color: couleur_bordure,
                      ),
                    ),
                    height: hauteur_champ,
                    child:codeIso2==null?Container():  Row(
                      children: <Widget>[
                        new Expanded(
                          flex:2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child:new Image.asset('flags/'+codeIso2.toLowerCase()+'.png'),
                          ),
                        ),
                        Expanded(
                          flex:2,
                          child: Padding(
                              padding: const EdgeInsets.only(left:0.0,),
                              child:dial == null?Container(): new Text(dial,
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

                _lieu == "5"?Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 5),
                    child: Text("Moyen de réception des fonds\nAccount: vers un compte bancaire\nCash: pour retirer dans une agence", style: TextStyle(
                        color: couleur_titre,
                        fontSize: taille_champ+2
                    ),),
                  ),
                ):Container(),

                _lieu == "5"?
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                  child: Container(
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: couleur_bordure,
                          width: bordure
                      ),
                    ),
                    height: hauteur_champ,
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                          flex:2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new Icon(Icons.person_add, color: couleur_decription_page,),
                          ),
                        ),
                        Expanded(
                          flex: 10,
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                icon: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: new Icon(Icons.arrow_drop_down_circle,
                                    color: couleur_fond_bouton,),
                                ),
                                isDense: false,
                                elevation: 1,
                                isExpanded: true,
                                onChanged: (String selected){
                                  setState(() {
                                    type = selected;
                                  });
                                },
                                value: type,
                                hint:Text('Moyen de réception',
                                  style: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize:taille_champ+3,
                                  ),),
                                items: _nature.map((String name){
                                  return DropdownMenuItem<String>(
                                    value: name,
                                    child: Text(name,
                                      style: TextStyle(
                                        color: couleur_libelle_champ,
                                        fontSize:taille_champ+3,
                                      ),),
                                  );
                                }).toList(),
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ):Container(),
                type == "Account"?Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Informations sur la banque", style: TextStyle(
                        color: couleur_libelle_champ,
                        fontSize: taille_libelle_champ,
                        fontWeight: FontWeight.bold
                    ),),
                  ),
                ):Container(),
                type == "Account"?Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
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
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                          flex:2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new Icon(Icons.assignment_ind, color: couleur_decription_page,),
                          ),
                        ),
                        Expanded(
                          flex: 10,
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                icon: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: new Icon(Icons.arrow_drop_down_circle,
                                    color: couleur_fond_bouton,),
                                ),
                                isDense: false,
                                elevation: 1,
                                isExpanded: true,
                                onChanged: (String selected){
                                  setState(() {
                                    banque = selected;
                                    bank = _banks[_bankFull.indexOf(selected)];
                                    print("la banque sélectionée: $banque");
                                  });
                                },
                                value: banque,
                                hint:Text('Sélectionner la banque',
                                  style: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize:taille_champ+3,
                                  ),),
                                items: _bankFull.map((String name){
                                  return DropdownMenuItem<String>(
                                    value: name,
                                    child: Text(name.split("-")[0],
                                      style: TextStyle(
                                        color: couleur_libelle_champ,
                                        fontSize:taille_champ+3,
                                      ),),
                                  );
                                }).toList(),
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ):Container(),
                type == "Account"?Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
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
                            child: new Icon(Icons.account_balance_wallet, color: couleur_description_champ,),
                          ),
                        ),
                        new Expanded(
                          flex:10,
                          child: Padding(
                            padding: EdgeInsets.only(left:0.0),
                            child: new TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(27),
                              ],
                              controller: numberController,
                              onChanged: (value){
                                _update(value);
                              },
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.characters,
                              style: TextStyle(
                                fontSize: taille_champ+3,
                                color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return "Numéro de compte vide!";
                                }else{
                                  numero = value;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Numéro de compte',
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
                type == "Account" && banque != null?Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text("$bank", style: TextStyle(
                      color: couleur_titre,
                      fontSize: taille_champ+2,
                    fontStyle: FontStyle.normal
                  ),),
                ):Container(),
                Padding(
                  padding: EdgeInsets.only(top: marge_champ_libelle, bottom: 20),
                  child: InkWell(
                    onTap: () async {
                      setState(() {
                        if(_formKey.currentState.validate()){
                          _name = "$_firstname $_lastname";
                          _sername = _to;
                          if(_lieu=="3" || _lieu=="4"){
                            this._save();
                            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfer(_code)));
                          }else if(_lieu == "5"){
                            if(type == null){
                              showInSnackBar("Veuillez sélectionner le lieu d'envoi", _scaffoldKey, 5);
                            }else{
                              this._save();
                              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: TransfertO(_code)));
                            }
                          } else {
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
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: barreBottom,
    );
  }

  update(String str, int end, int baseOffset) {
    var strExist = str.length>0?true:false;
    if(strExist){
      if(end<0 && baseOffset<0){
        if(str.length == 5 || str.length == 11 || str.length == 24){
          setState(() {
            numberController.text = numberController.text.substring(0, numberController.text.length-1);
            numberController.selection = TextSelection.fromPosition(TextPosition(offset: numberController.text.length));
          });
        }
      }else{
        if(str.length == 5 || str.length == 11 || str.length == 24){
          setState(() {
            numberController.text = numberController.text+'-';
            numberController.selection = TextSelection.fromPosition(TextPosition(offset: numberController.text.length));
          });
        }
      }
    }
  }

  _update(String str){
    var strExist = str.length>0?true:false;
    String old = str;
    if(strExist){
      if(str.length == 6 || str.length == 12 || str.length == 25){
        if(old.substring(old.length-1) != '-'){
          setState(() {
            str = old.substring(0, old.length-1)+'-'+old.substring(old.length-1);
            numberController.text = str;
            numberController.selection = TextSelection.fromPosition(TextPosition(offset: numberController.text.length));
          });
        }
      }
    }
  }
}