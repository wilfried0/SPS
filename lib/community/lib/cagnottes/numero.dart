import 'package:flutter/material.dart';
import 'package:services/composants/components.dart';
import '../utils/components.dart';
import 'cagnotte1.dart';
import 'cagnotte2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';


class Numero extends StatefulWidget {
  Numero();
  @override
  _NumeroState createState() => new _NumeroState();
}

class _NumeroState extends State<Numero> {
  _NumeroState();
  String numero, currency, type, currencySymbol;
  var _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var controller;
  //var isKeyboardOpen = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.read();
    controller = new MoneyMaskedTextController(decimalSeparator: '', thousandSeparator: '.', precision: 0);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text('Numero du bénéficiaire',
        style: TextStyle(
          color: couleur_titre,
          fontSize: taille_champ+3,
        ),),
        elevation: 0.0,
        backgroundColor: couleur_appbar,
        flexibleSpace: barreTop,
        leading: IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: couleur_fond_bouton,),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte1()));
          },
        ),
        //iconTheme: new IconThemeData(color: couleur_fond_bouton),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: new Text('Créer une cagnotte',
                    style: TextStyle(
                        color: couleur_titre,
                        fontSize: taille_titre,
                        fontWeight: FontWeight.bold
                    ),),
                ),

                /*Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: new Text('Etape 1 sur 5',
                      style: TextStyle(
                          color: couleur_libelle_etape,
                          fontSize: taille_libelle_etape,
                          fontWeight: FontWeight.bold
                      )),
                ),*/

                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: new Text("renseigner le numero du bénéficiaire",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: taille_description_page,
                    ),),
                ),

                /*Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: new Text("Le montant à saisir doit être en monaie locale du bénéficiaire.",
                    style: TextStyle(
                      color: bleu_F,
                      fontSize: taille_champ+3,
                    ),
                  textAlign: TextAlign.justify,),
                ),*/

                currencySymbol==null?Container():Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: new TextFormField(
                    controller: controller,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(
                        color: couleur_libelle_champ,
                        fontSize: taille_champ+3,
                      fontWeight: FontWeight.bold
                    ),
                    validator: (String value){
                      if(value.isEmpty){
                        return null;
                      }else{
                        setState(() {
                          numero = value;
                        });
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        //borderRadius: new BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: couleur_bordure, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: couleur_bordure),
                      ),
                      //labelText: 'Montant',
                      //suffixText: '$currencySymbol',
                      labelStyle: new TextStyle(
                          color: couleur_libelle_champ,
                        fontWeight: FontWeight.normal
                      ),
                      hintStyle: TextStyle(
                          color: couleur_libelle_champ,
                          fontSize: taille_champ+3,
                      ),
                      //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 40, bottom: 20),
                  child: new Text("Cette personne encaissera la cagnote à la fin des participations",
                    style: TextStyle(
                        color: bleu_F,
                        fontSize: taille_description_page,
                        fontWeight: FontWeight.normal
                    ),
                  textAlign: TextAlign.justify,),
                ),

                /*Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(Icons.check, size: 30, color: Colors.green,),
                    ),
                    Text("gratuite", style: TextStyle(
                      color: Colors.black,
                      fontSize: taille_champ+3
                    ),)
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(Icons.check, size: 30, color: Colors.green,),
                      ),
                      Text("sans frais de commission", style: TextStyle(
                          color: Colors.black,
                          fontSize: taille_champ+3
                      ))
                    ],
                  ),
                ),*/
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: new InkWell(
                    onTap: () {
                      setState(() {
                        if(_formKey.currentState.validate() && numero != null){
                          _save();
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte2()));
                        }else{
                          showInSnackBar("Veuillez renseigner le numero", _scaffoldKey, 5);
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
                      child: Center(child: new Text("Continuer", style: new TextStyle(fontSize: taille_champ+3, color: Colors.white,),)),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ),
      bottomNavigationBar: barreBottom,
    );
  }

  void _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(NUMERO_BEN_CAGNOTTE, numero);
    prefs.setString(CURRENCYSYMBOLT, currencySymbol);
    controller.text = numero;
    print('saved $numero');
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currencySymbol = prefs.getString(CURRENCYSYMBOL);
    });
    print('currencySymbol: $currencySymbol');
  }
}