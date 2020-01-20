import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../colors.dart';

class ProcessStep extends StatelessWidget {
  static const CONFIG = 1;
  static const CONFIRM = 2;
  static const PAYMENT = 3;
  final int _step;
  final String _logo;

  ProcessStep(this._step, this._logo);

  getColor(int index) {
    if (_step == index)
      return orange_F;
    else if (_step > index)
      return Colors.green;
    else
      return couleur_libelle_champ;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(_logo),
              )),
            ),
          ),
          Card(
            elevation: 8,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          flex: 4,
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.description, color: getColor(CONFIG)),
                              Text(
                                "Sélection",
                                style: TextStyle(color: getColor(CONFIG)),
                              )
                            ],
                          )),
                      Expanded(
                          flex: 4,
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.beenhere,
                                color: getColor(CONFIRM),
                              ),
                              Text(
                                "Confirmation",
                                style: TextStyle(color: getColor(CONFIRM)),
                              )
                            ],
                          )),
                      Expanded(
                          flex: 4,
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.credit_card,
                                color: getColor(PAYMENT),
                              ),
                              Text(
                                "Paiement",
                                style: TextStyle(color: getColor(PAYMENT)),
                              )
                            ],
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
