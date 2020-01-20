import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/marketplace/lib/api/ServerResponseValidator.dart';
import 'package:services/marketplace/lib/api/TransactionController.dart';

import '../../colors.dart';
import '../BrowserScreen.dart';

class SpConfirmDialog {
  final codeController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  bool _loading = false;
  BuildContext _context;

  show(BuildContext context, SpVerify spVerify) {
    _context = context;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text(
                          "Veuillez saisir le code de validation reçu par sms ci-dessous",
                          style: new TextStyle(
                              color: const Color(0xFF000000),
                              fontWeight: FontWeight.w200,
                              fontFamily: "Roboto")),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.circular(10.0),
                          border: Border.all(
                              color: couleur_bordure, width: bordure),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: codeController,
                                  decoration: InputDecoration.collapsed(
                                      hintText: "Code"),
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return "Saisir un code";
                                    else if (value.length != 6)
                                      return "Code incorrect";
                                    return null;
                                  },
                                  style: new TextStyle(
                                      color: const Color(0xFF000000),
                                      fontWeight: FontWeight.w200,
                                      fontFamily: "Roboto"))
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _loading,
                      child: LinearProgressIndicator(),
                    ),
                    SizedBox(
                      width: 320.0,
                      child: RaisedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              spVerify.secretKey = codeController.text;
                              _loading = true;
                              new TransactionController()
                                  .spConfirm(spVerify, onSuccess, onFailure,
                                      onRequestComplete)
                                  .catchError((e) {});
                            }
                          },
                          color: const Color(0xFF0099ed),
                          child: new Text("Valider",
                              style: new TextStyle(
                                  color: const Color(0xFFffffff),
                                  fontWeight: FontWeight.w200,
                                  fontFamily: "Roboto"))),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  onFailure(ServerResponseValidator _responseValidator) {
    Scaffold.of(_context).showSnackBar(new SnackBar(
      content: new Text(
        "Impossible de traiter votre requete car une erreur est survenue",
        style: TextStyle(color: Colors.white, fontSize: taille_champ + 3),
        textAlign: TextAlign.center,
      ),
      backgroundColor: couleur_fond_bouton,
      duration: Duration(seconds: 5),
    ));
  }

  onSuccess(Map<String, dynamic> json) {
    Navigator.pop(_context);
    Navigator.pop(_context);
    Navigator.pop(_context);
    Navigator.pop(_context);
    BrowserScreen.successPayment(_context);
  }

  onRequestComplete(ServerResponseValidator _responseValidator) {
    _loading = false;
  }
}
