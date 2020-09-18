import 'package:services/community/lib/tontines/tontine3.dart';
import 'package:services/community/lib/tontines/tontine5.dart';
import 'package:services/composants/components.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tontine4 extends StatefulWidget {
  @override
  _Tontine4State createState() => new _Tontine4State();
}

class _Tontine4State extends State<Tontine4> {

  List data, name;
  List<String> invitations = new List<String>(), flagUris = new List();
  bool isLoading =false;
  String code3 = "+237", invitation, flagUri = "flags/cm.png";
  var _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var controller;



  @override
  void initState(){
    super.initState();
    controller = new TextEditingController();
  }

  @override
  void dispose(){
    super.dispose();
    controller.disposer();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: couleur_appbar,
        flexibleSpace: barreTop,
        title: Text("Liste des participants",style: TextStyle(
          color: couleur_titre,
          fontSize: taille_champ+3,
        ),),
        leading: IconButton(
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Tontine3()));
            },
            icon: Icon(Icons.arrow_back_ios,)),
        iconTheme: new IconThemeData(color: bleu_F),
        actions: [
          InkWell(
            onTap: (){
              this._save();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Tontine5()));
            },
            child: Padding(
              padding: EdgeInsets.only(right: 20, top: 20),
              child: Text("SUIVANT", style: TextStyle(
                fontWeight: FontWeight.bold,
                color: couleur_fond_bouton
              ),),
            )
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: new Text('Créer une Tontine',
                  style: TextStyle(
                      color: couleur_titre,
                      fontSize: taille_titre,
                      fontWeight: FontWeight.bold
                  ),),
              ),

              Padding(
                padding: EdgeInsets.only(top: 20),
                child: new Text('Etape 4 sur 5',
                    style: TextStyle(
                        color: couleur_libelle_etape,
                        fontSize: taille_libelle_etape,
                        fontWeight: FontWeight.bold
                    )),
              ),

              Padding(
                padding: EdgeInsets.only(top: 20),
                child: new Text("Ajouter les participants.",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: taille_description_page,
                  ),),
              ),

              Padding(padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 10,
                      child: Container(
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                          color: Colors.transparent,
                          border: Border.all(
                              color: couleur_bordure,
                              width: 1.5
                          ),
                        ),
                        height: hauteur_champ,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                                flex: 5,
                                child: CountryCodePicker(
                                  showFlag: true,
                                  showCountryOnly: false,
                                  showOnlyCountryWhenClosed: false,
                                  textStyle: TextStyle(
                                      fontSize: taille_champ+3,
                                      color: couleur_libelle_champ
                                  ),
                                  onChanged: (CountryCode code) {
                                    flagUri = "${code.flagUri}";
                                    code3 = code.dialCode;
                                  },
                                )
                            ),
                            new Expanded(
                              flex:7,
                              child: Form(
                                key: _formKey,
                                child: new TextFormField(
                                  controller: controller,
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(
                                    fontSize: taille_champ+3,
                                    color: couleur_libelle_champ,
                                  ),
                                  validator: (String value){
                                    if(value.isEmpty){
                                      return "Champ téléphone vide !";
                                    }else{
                                      invitation = code3.substring(1)+value;
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration.collapsed(
                                    hintText: "Numéro de téléphone",
                                    hintStyle: TextStyle(
                                      fontSize: taille_champ+3,
                                      color: couleur_libelle_champ,
                                    ),
//contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: IconButton(
                          icon: Icon(Icons.add_circle, size: 35,color: couleur_fond_bouton,),
                          onPressed: (){
                            setState(() {
                              if(_formKey.currentState.validate()){
                                print("Voici le flagUri ******************** $flagUri");
                                flagUris.add(flagUri);
                                invitations.add(invitation);
                                controller.clear();
                              } else
                                showInSnackBar("Veuillez entrer le numéro de téléphone", _scaffoldKey, 5);
                            });
                          }
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height/2,
                  child: ListView.builder(
                  itemCount: invitations==null?0:invitations.length,
                  itemBuilder: (BuildContext context, int i){
                    if(i == 0){
                      return Column(
                        children: <Widget>[
                          Divider(color: couleur_bordure,
                            height: .1,),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                                child: SizedBox(
                                  height: 30,
                                  width: 40,
                                  child: Image.asset(flagUris[i]),
                                ),
                              ),
                              SizedBox(
                                child: Text(invitations[i],
                                  style: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize: taille_champ+3,
                                  ),),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Divider(color: couleur_bordure,
                              height: .1,),
                          ),
                        ],
                      );
                    }else{
                      return Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                                child: SizedBox(
                                  height: 30,
                                  width: 40,
                                  child: Image.asset(flagUris[i]),
                                ),
                              ),
                              SizedBox(
                                child: Text(invitations[i],
                                  style: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize: taille_champ+3,
                                  ),),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Divider(color: couleur_bordure,
                              height: .1,),
                          ),
                        ],
                      );
                    }
                  },
                )),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: barreBottom,
    );
  }

  void _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(INVITATIONS_TONTINE, invitations);
    print("saved ${invitations}");
  }
}