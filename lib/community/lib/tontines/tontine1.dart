import 'package:services/community/lib/tontines/paysctontine.dart';
import 'package:services/community/lib/tontines/tontine.dart';
import 'package:services/community/lib/tontines/tontine2.dart';
import 'package:services/composants/components.dart';
import 'package:flutter/material.dart';
import '../utils/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';


class Tontine1 extends StatefulWidget {
  Tontine1();
  @override
  _Tontine1State createState() => new _Tontine1State();
}

class _Tontine1State extends State<Tontine1> {
  _Tontine1State();
  String amounttontine, currency, type, currencySymbol;
  var _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var controlleramount;
  //var isKeyboardOpen = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.read();
    controlleramount = new MoneyMaskedTextController(decimalSeparator: '', thousandSeparator: '.', precision: 0);
  }

  @override
  void dispose() {
    controlleramount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      // ignore: missing_return
      onWillPop: (){
        print("hello tontinard");
        Navigator.push(context, MaterialPageRoute(builder:(context)=> Tontine('')));
      },
      child: new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: Text('Montant de la tontine',
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
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Paysctontine()));
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
                      child: new Text('Créer une Tontine',
                        style: TextStyle(
                            color: couleur_titre,
                            fontSize: taille_titre,
                            fontWeight: FontWeight.bold
                        ),),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: new Text('Etape 1 sur 5',
                          style: TextStyle(
                              color: couleur_libelle_etape,
                              fontSize: taille_libelle_etape,
                              fontWeight: FontWeight.bold
                          )),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: new Text("Quel est le montant de cotisation de la Tontine ?",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: taille_description_page,
                        ),),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: new Text("Le montant à saisir doit être en monaie locale.",
                        style: TextStyle(
                          color: bleu_F,
                          fontSize: taille_champ+3,
                        ),
                        textAlign: TextAlign.justify,),
                    ),

                    currencySymbol==null?Container():Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: new TextFormField(
                        controller: controlleramount,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                            color: couleur_libelle_champ,
                            fontSize: taille_champ+3,
                            fontWeight: FontWeight.bold
                        ),
                        validator: (String value){
                          if(value.isEmpty || double.parse(value.replaceAll(".", ""))==0){
                            return null;
                          }else{
                            setState(() {
                              amounttontine = value;
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
                          labelText: 'Montant',
                          suffixText: '$currencySymbol',
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
                      child: new Text("Toute création de Tontine, quelque soit le pays et le montant est",
                        style: TextStyle(
                            color: bleu_F,
                            fontSize: taille_description_page,
                            fontWeight: FontWeight.normal
                        ),
                        textAlign: TextAlign.justify,),
                    ),

                    Row(
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
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: new InkWell(
                        onTap: () {
                          setState(() {
                            if(_formKey.currentState.validate() && amounttontine != null){
                              _save();
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Tontine2()));
                            }else{
                              showInSnackBar("Veuillez renseigner le montant", _scaffoldKey, 5);
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
      ),
    );
  }

  void _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(MONTANT_TONTINE, amounttontine);
    controlleramount.text = amounttontine;
    print('saveamount $amounttontine');
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currencySymbol = prefs.getString(CURRENCYSYMBOLT);
      amounttontine = prefs.getString(MONTANT_TONTINE);
    });
    print('currencySymbol: $currencySymbol');
  }
}