import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:services/composants/components.dart';
import '../utils/components.dart';
import 'cagnotte3.dart';
import 'cagnotte5.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Cagnotte4 extends StatefulWidget {
  Cagnotte4();

  @override
  _Cagnotte4State createState() => new _Cagnotte4State();
}

class _Cagnotte4State extends State<Cagnotte4> {
  _Cagnotte4State();

  String _prenom, _nom, _tel,_tel1, flagUri, dial_code, iso3, pays, _mySelection;
  int ad=3;
  var _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.read();
    this.lire();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      backgroundColor: GRIS,
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text('Ajout bénéficiaire',
          style: TextStyle(
            color: couleur_titre,
            fontSize: taille_libelle_etape,
          ),),
        elevation: 0.0,
        backgroundColor: GRIS,
        flexibleSpace: barreTop,
        leading: IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: couleur_fond_bouton,),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte3()));
          },
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text('Nouveau bénéficiaire',
                    style: TextStyle(
                        color: couleur_titre,
                        fontSize: taille_titre,
                        fontWeight: FontWeight.bold
                    ),),


                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: new Text('Etape 4 sur 5',
                          style: TextStyle(
                              color: couleur_libelle_etape,
                              fontSize: taille_libelle_etape,
                              fontWeight: FontWeight.bold
                          )),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: new Text("Bénéficiaire de la cagnotte",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: taille_description_page,
                      ),),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 20,),
                    child: Text('Identité',
                      style: TextStyle(
                          color: bleu_F,
                          fontSize: taille_champ+3,
                          fontWeight: FontWeight.bold
                      ),),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text("Veuillez écrire le nom légal et complet, comme indiqué sur le passeport ou le permi de conduire du bénéficiaire.",
                      style: TextStyle(
                        color: bleu_F,
                        fontSize: taille_champ,
                      ),),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 10),
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
                              child: new Image.asset('communityimages/Groupe177.png'),
                            ),
                          ),
                          new Expanded(
                            flex:10,
                            child: new TextFormField(
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  fontSize: taille_champ+3,
                                  color: couleur_libelle_champ,
                                  fontWeight: FontWeight.normal
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return 'Prénom vide !';
                                }else{
                                  _prenom = value;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Prénom',
                                hintStyle: TextStyle(
                                    fontSize: taille_champ+3,
                                    color: couleur_libelle_champ,
                                    fontWeight: FontWeight.normal
                                ),
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  Container(
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                      color: Colors.white,
                      border: Border.all(
                          width: bordure,
                          color: couleur_bordure
                      ),
                    ),
                    height: hauteur_champ,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex:2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new Image.asset('communityimages/Groupe177.png'),
                          ),
                        ),
                        new Expanded(
                          flex:10,
                          child: new TextFormField(
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                                fontSize: taille_champ+3,
                                color: couleur_libelle_champ,
                                fontWeight: FontWeight.normal
                            ),
                            validator: (String value){
                              if(value.isEmpty){
                                return 'Champ nom vide !';
                              }else{
                                _nom = value;
                                return null;
                              }
                            },
                            decoration: InputDecoration.collapsed(
                              hintText: 'Nom',
                              hintStyle: TextStyle(color: couleur_libelle_champ,
                                 fontSize: taille_champ+3,
                                 fontWeight: FontWeight.normal),
                              //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            ),
                            /*textAlign: TextAlign.end,*/
                          ),
                          //),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 20,),
                    child: Text('Coordonnées de contact',
                      style: TextStyle(
                          color: bleu_F,
                          fontSize: taille_champ+3,
                          fontWeight: FontWeight.bold
                      ),),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text("Le contact doit correspondre au compte SprintPay du bénéficiaire.",
                      style: TextStyle(
                        color: bleu_F,
                        fontSize: taille_champ,
                      ),),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 10,),
                    child: Container(
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0)
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
                          /*new Expanded(
                            flex:2,
                            child: Padding(
                              padding: EdgeInsets.only(left: 15.0),
                              child:flagUri == null?Container(): new Image.asset('$flagUri'),
                            ),
                          ),*/
                          Expanded(
                              flex: 5,
                              child: CountryCodePicker(
                                showFlag: true,
                                showCountryOnly: false,
                                showOnlyCountryWhenClosed: false,
                                textStyle: TextStyle(
                                    fontSize: taille_libelle_champ+ad,
                                    color: couleur_libelle_champ
                                ),
                                initialSelection:_mySelection,
                                onChanged: (CountryCode code) {
                                  _mySelection = code.dialCode.toString();
                                  flagUri = "${code.flagUri}";
                                  iso3 = "${code.codeIso}";

                                  print('mon iso3: $iso3');
                                  print('mon dial: $_mySelection');
                                  pays = "${code.name}";
                                },
                              )
                            /*flex:3,
                            child: Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: new Text(dial_code==null?"":dial_code,
                                  style: TextStyle(
                                      fontSize: taille_champ+3,
                                      color: couleur_libelle_champ,
                                      fontWeight: FontWeight.bold
                                  ),)
                            ),*/
                          ),
                          new Expanded(
                            flex:7,
                            child: new TextFormField(
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                  fontSize: taille_champ+3,
                                  color: couleur_libelle_champ,
                                  fontWeight: FontWeight.normal
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return 'Champ téléphone vide !';
                                }else{
                                  _tel = '${_mySelection.substring(1)}$value';
                                  print('mon tel: $_tel');
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Numéro de téléphone',
                                hintStyle: TextStyle(
                                    fontSize: taille_champ+3,
                                    color: couleur_libelle_champ,
                                    fontWeight: FontWeight.normal
                                ),
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: new InkWell(
                      onTap: () {
                        if(_formKey.currentState.validate()){
                          _save();
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte5()));
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
                        child: Center(child: new Text("Poursuivre", style: new TextStyle(fontSize: taille_text_bouton+3, color: Colors.white,),)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
      bottomNavigationBar: barreBottom,
    );
  }


  read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      dial_code = prefs.getString(DIAL_CODE);
      flagUri = prefs.getString(FLAG_CAGNOTTE);
      _tel = prefs.getString(PHONE_CAGNOTTE_CRE);
      print('mon tel: $_tel');
      print(flagUri);
    });
  }

  void _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(NOM_CAGNOTTE, _nom);
    prefs.setString(PRENOM_CAGNOTTE, _prenom);
    prefs.setString(PHONE_CAGNOTTE_CRE, _tel);
  }

  lire() async {
    final prefs = await SharedPreferences.getInstance();
    //currencyConnexion = prefs.getString(CURRENCYSYMBOL_CONNEXION);
    print("*********************** ${prefs.getString("coched")}");

    if(prefs.getString("pays") == null){
      pays="Cameroun";
    }else{
      pays = prefs.getString("pays");
    }
    print("pays: $pays");

    if(prefs.getString("iso3") == null){
      iso3="CMR";
    }else{
      iso3 = prefs.getString("iso3");
    }
    print("iso3: $iso3");
    if(prefs.getString("flag") == null){
      flagUri="flags/cm.png";
    }else{
      flagUri = prefs.getString("flag");
    }
    print("flagURI: $flagUri");

    if(prefs.getString("dial") == null){
      _mySelection="+237";
    }else{
      print("Mon dial"+prefs.getString("dial"));
      setState(() {
        _mySelection=prefs.getString("dial");
      });
    }
    print("dial: $_mySelection");
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text(value,style:
        TextStyle(
            color: Colors.white,
            fontSize: taille_description_champ
        ),
          textAlign: TextAlign.center,),
          backgroundColor: couleur_fond_bouton,
          duration: Duration(seconds: 5),));
  }
}