import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/composants/components.dart';
import 'package:simple_pdf_viewer/simple_pdf_viewer.dart';

class Conditions extends StatefulWidget {
  @override
  _ConditionsState createState() => _ConditionsState();
}

class _ConditionsState extends State<Conditions> {
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Conditions d'utilisation SprintPay", style: TextStyle(
            fontSize: taille_description_champ+3,
            color: couleur_fond_bouton
        ),),
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,),
        onPressed: (){
              Navigator.pop(context);
        },),
        iconTheme: new IconThemeData(color: couleur_fond_bouton),
      ),
      body: SimplePdfViewerWidget(
        initialUrl: "$cond",
      ),
    );
  }
}
