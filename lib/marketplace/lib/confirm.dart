import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'colors.dart';
import 'models/CommonServiceItem.dart';
import 'models/Services.dart';
import 'models/Transaction.dart';
import 'paiement.dart';
import 'screen/item/ProcessStep.dart';

import 'system/AppState.dart';

class Confirm extends StatefulWidget {
  final Merchant _merchant;
  final CommonServiceItem _selectedServiceItem;
  final Transaction _transaction;
  @override
  _ConfirmState createState() => _ConfirmState(
      this._merchant, this._selectedServiceItem, this._transaction);

  Confirm(this._merchant, this._selectedServiceItem, this._transaction);
}

class _ConfirmState extends State<Confirm> {
  final Merchant _merchant;
  final CommonServiceItem _selectedServiceItem;
  final Transaction _transaction;
  String _ville, _quartier, _pharmacy, coched, _currency;

  _ConfirmState(this._merchant, this._selectedServiceItem, this._transaction);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.lire();

    if (_selectedServiceItem != null) {
      _transaction.sellableItemId = _selectedServiceItem.id;
      _transaction.description = _selectedServiceItem.description;
      _transaction.paymentItemId = _selectedServiceItem.paymentId;
    } else {
      print("Null selected service");
    }
    print(_transaction.toJson());
  }

  lire() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      coched = prefs.getString("coched");
      _currency = prefs.getString("deviseLocale");
      _transaction.currency = "$_currency";
      _ville = prefs.getString(Data.CITY.toString());
      _quartier = prefs.getString(Data.DISTRICT.toString());
      _pharmacy = prefs.getString(Data.PHARMACY.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: <Widget>[
            ProcessStep(ProcessStep.CONFIRM, _merchant.logoFileId),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 0,
                  child: _merchant.category == Services.UTILITY_CATEGORY ||
                      _merchant.category == Services.TELCO_CATEGORY
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Text(
                          _merchant.category == Services.TELCO_CATEGORY
                              ? "Achat de crédit téléphonique."
                              : "Paiement de facture",
                          style: TextStyle(color: couleur_libelle_champ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: _transaction.beneficiaryPhoneNumber != null
                            ? Text(
                          "Numéro bénéficiaire: +${_transaction.beneficiaryPhoneNumber}",
                          style: TextStyle(
                              color: couleur_libelle_champ),
                        )
                            : Container(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Text(
                          "Montant: ${_transaction.amount} ${_transaction.currency}",
                          style: TextStyle(color: couleur_libelle_champ),
                        ),
                      ),
                    ],
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Text(
                          _merchant.category == Services.PHARMACY_CATEGORY
                              ? "Paiement d'une ordonnance."
                              : "Paiement de la facture",
                          style: TextStyle(color: couleur_libelle_champ),
                        ),
                      ),
                      _merchant.category == Services.PHARMACY_CATEGORY
                          ? Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Text(
                          "Ville: $_ville",
                          style: TextStyle(
                              color: couleur_libelle_champ),
                        ),
                      )
                          : Container(),
                      _merchant.category == Services.PHARMACY_CATEGORY
                          ? Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Text(
                          "Quartier: $_quartier",
                          style: TextStyle(
                              color: couleur_libelle_champ),
                        ),
                      )
                          : Container(),
                      _merchant.category == Services.PHARMACY_CATEGORY
                          ? Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Text(
                          "Pharmacie: $_pharmacy",
                          style: TextStyle(
                              color: couleur_libelle_champ),
                        ),
                      )
                          : Container(),
                      (_transaction.beneficiaryEmail != null
                          ? Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Column(
                          children: <Widget>[
                            _merchant.category ==
                                Services.PHARMACY_CATEGORY
                                ? Text(
                              "Nom du récepteur: ${_transaction.beneficiaryEmail}",
                              style: TextStyle(
                                  color:
                                  couleur_libelle_champ),
                            )
                                : Text(
                              "Email du récepteur: ${_transaction.beneficiaryEmail}",
                              style: TextStyle(
                                  color:
                                  couleur_libelle_champ),
                            ),
                            Text(
                              "Numéro du récepteur: ${_transaction.beneficiaryPhoneNumber}",
                              style: TextStyle(
                                  color: couleur_libelle_champ),
                            )
                          ],
                        ),
                      )
                          : Container()),
                      Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Text(
                          _merchant.category == Services.PHARMACY_CATEGORY
                              ? "Montant de l'ordonnance: ${_transaction.amount} ${_transaction.currency}"
                              : "Montant: ${_transaction.amount} ${_transaction.currency}",
                          style: TextStyle(
                              color: couleur_libelle_etape,
                              fontWeight: FontWeight.bold,
                              fontSize: taille_libelle_champ + 3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: Row(
                children: <Widget>[
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        print(_transaction.toJson());
                        print("la coche $coched");
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                //TODO pass good parameters
                                child: Paiement(_transaction, _merchant,
                                    _selectedServiceItem)));
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
                        child: new Center(
                            child: new Text(
                              'Confirmer',
                              style: new TextStyle(
                                  fontSize: taille_text_bouton + 3,
                                  color: couleur_text_bouton),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}