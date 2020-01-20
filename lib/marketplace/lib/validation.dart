import 'colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Validation extends StatefulWidget {
  @override
  _ValidationState createState() => _ValidationState();
}

class _ValidationState extends State<Validation> {

  bool isLoding = false;
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vérifier une transaction", style: TextStyle(
          color: couleur_libelle_champ
        ),),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 0.0),
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  color: Colors.transparent,
                  border: Border.all(
                      width: bordure,
                      color: Colors.green
                  ),
                ),
                height: hauteur_champ,
                child: Align(
                  alignment: Alignment.center,
                  child: new TextFormField(
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                        fontSize: taille_libelle_champ+3,
                        color: couleur_libelle_champ
                    ),
                    validator: (String value){
                      if(value.isEmpty){
                        return 'Champ code de référence vide !';
                      }else{
                        return null;
                      }
                    },
                    decoration: InputDecoration.collapsed(
                      hintText: 'Code de référence',
                      hintStyle: TextStyle(color: couleur_libelle_champ,
                          fontSize: taille_libelle_champ+3),
                      //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Profile('')));
                      if(_formKey.currentState.validate()){

                      }
                    });
                  },
                  child: new Container(
                    height: hauteur_champ,
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: new BoxDecoration(
                      color: Colors.green,
                      border: new Border.all(
                        color: Colors.transparent,
                        width: 0.0,
                      ),
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    child: new Center(child: isLoding==false?new Text('Vérifier', style: new TextStyle(fontSize: taille_text_bouton+3, color: couleur_text_bouton),):
                    CupertinoActivityIndicator(),),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
