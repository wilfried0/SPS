import 'package:flutter/material.dart';
import 'package:services/composants/components.dart';
import '../utils/components.dart';
import 'cagnotte4.dart';
import 'configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Cagnotte5 extends StatefulWidget {
  Cagnotte5();

  @override
  _Cagnotte5State createState() => new _Cagnotte5State();
}

class _Cagnotte5State extends State<Cagnotte5> {
  _Cagnotte5State();

  String motif;
  var _motifTextController = new TextEditingController();
  var _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _motifTextController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      backgroundColor: GRIS,
      key: scaffoldKey,
      appBar: new AppBar(
        title: Text('Description de la cagnotte',
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
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte4()));
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
                  new Text('Créer une cagnotte',
                    style: TextStyle(
                        color: couleur_titre,
                        fontSize: taille_titre,
                        fontWeight: FontWeight.bold
                    ),),

                  Padding(
                    padding: EdgeInsets.only(top: marge_libelle_champ),),

                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: new Text('Etape 5 sur 5',
                          style: TextStyle(
                              color: couleur_libelle_etape,
                              fontSize: taille_libelle_etape,
                              fontWeight: FontWeight.bold
                          )),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: new Text("À propos de la cagnotte",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: taille_description_page,
                      ),),
                  ),

                  Container(
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                      color: Colors.white,
                      border: Border.all(
                          color: couleur_bordure,
                          width: bordure
                      ),
                    ),
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0.0, left: 10, right: 10),
                      child: new TextFormField(
                        controller: _motifTextController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: taille_champ+3,
                        ),
                        validator: (String value){
                          if(value.isEmpty){
                            motif = "";
                            return "Description est obligatoire!";
                          }else{
                            setState(() {
                              motif = value;
                              _motifTextController.text = motif;
                            });
                            return null;
                          }
                        },
                        decoration: InputDecoration.collapsed(
                          hintText: 'Votre description ici',
                          hintStyle: TextStyle(
                              color: couleur_libelle_champ,
                              fontSize: taille_champ,
                          ),
                          //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: new InkWell(
                      onTap: () {
                        setState(() {
                          if(_formKey.currentState.validate()){
                            this.save();
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Configuration()));
                            //Navigator.of(context).push(SlideLeftRoute(enterWidget: Configuration(_code), oldWidget: Cagnotte5(_code)));
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

  void save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(DESCRIPTION_CAGNOTTE, motif);
  }
}