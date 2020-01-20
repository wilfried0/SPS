
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/marketplace/lib/models/ServiceConfig.dart';

import '../../colors.dart';

class InputGenerator {
  var inputs = List<Widget>();
  bool showPayByOther = false;

  InputGenerator();

  Widget getForm(
    ServiceConfig config,
    var form, {
    bool showPayByOther = false,
    Function phoneValidator,
    Function amountValidator,
    Function textValidator,
    Function billValidator,
  }) {
    this.showPayByOther = showPayByOther;
    if (config.serviceRequired) if (config.phoneRequired)
      inputs.add(
          baseInput(inputType: TextInputType.phone, validator: phoneValidator));
    if (config.billRequired)
      inputs.add(baseInput(
          inputType: TextInputType.number,
          hint: "Numéro de compteur ou d'bonnement",
          validator: billValidator));
    if (config.canPayByOther && showPayByOther) {
      inputs.add(baseInput(
          hint: "Nom complet du bénéficiaire", validator: textValidator));
      inputs.add(baseInput(
          inputType: TextInputType.phone,
          hint: "Numéro de téléphone du bénéficiaire",
          validator: phoneValidator));
    }
    if (config.amountRequired)
      inputs.add(baseInput(
          inputType: TextInputType.number,
          hint: "Montant à payer ou transferer",
          validator: amountValidator));

    return Form(
      key: form,
      child: Column(children: inputs),
    );
  }

  Widget baseInput(
      {Function validator,
      var inputType = TextInputType.text,
      String hint = "Numéro de téléphone"}) {
    return Container(
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(10.0),
        border: Border.all(color: couleur_bordure, width: bordure),
      ),
      height: hauteur_champ,
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: new TextFormField(
            keyboardType: inputType,
            style: TextStyle(
              fontSize: taille_libelle_champ + 3,
              color: couleur_libelle_champ,
            ),
            validator: (String value) {
              return validator(value);
            },
            decoration: InputDecoration.collapsed(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: taille_libelle_champ + 3,
                color: couleur_libelle_champ,
              ),
              //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            ),
          ),
        ),
      ),
    );
  }
}
