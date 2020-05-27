import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:services/composants/components.dart';
import 'package:services/paiement/transfer.dart';
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
  String _firstname, codeIso2, _lastname, _to, _adresse, _lieu, dial;
  var _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _name, _sername;

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
      codeIso2 = prefs.getString("codeIso2");
      dial = prefs.getString("DIAL");
      print("mon code iso2 ==> $codeIso2");
    });
  }

  @override
  Widget build(BuildContext context) {
    marge = (5*MediaQuery.of(context).size.width)/414;

    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          elevation: 0.0,
          backgroundColor: couleur_appbar,
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
                child: new Text(_lieu=="3" || _lieu == "4"?"Informations sur le bénéficiaire":"Ajouter un bénéficiaire",
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

                  _lieu=="3" || _lieu == "4"?Padding(
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

                  Padding(padding: EdgeInsets.only(top: marge_champ_libelle),),

                  InkWell(
                    onTap: () async {
                      setState(() {
                        if(_formKey.currentState.validate()){
                          _name = "$_firstname $_lastname";
                          _sername = _to;
                          if(_lieu=="3" || _lieu=="4"){
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
      );
  }
}
