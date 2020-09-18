import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:services/composants/components.dart';
import 'package:services/marketplace/lib/models/CommonServiceItem.dart';
import 'package:services/marketplace/lib/models/Services.dart';
import 'package:services/marketplace/lib/operator.dart';
import 'package:services/marketplace/lib/system/AppState.dart';



class PharmacyBox extends StatefulWidget {
  PharmacyBox(
      {Key key,
        this.pharmacies,
        this.data,
        this.cities,
        this.scaffoldKey,
        this.listOfServices})
      : super(key: key);

  final HashSet<String> cities;
  final List<CommonServiceItem> listOfServices;
  HashSet<String> selectedDistricts = new HashSet(),
      selectedPharmacies = new HashSet();
  List pharmacies;
  var data;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  _PharmacyBoxState createState() => new _PharmacyBoxState();
}

class _PharmacyBoxState extends State<PharmacyBox> {
  var _formKey = GlobalKey<FormState>();
  String _current = null,
      _current1 = null,
      _current2 = null;
  int _id, pharmacyId;
  CommonServiceItem selectedServiceItem;

  @override
  void initState() {
    super.initState();
    print("cities ${widget.cities}");
    widget.selectedDistricts.add("quartier non repertorié");
    widget.selectedPharmacies.add("aucune pharmacie");
  }

  getDistricts(String ville) {
    widget.selectedDistricts.clear();
    widget.selectedPharmacies.clear();
    for (int i = 0; i < widget.pharmacies.length; i++) {
      if (widget.pharmacies[i]['city'] == "$ville"){
        widget.selectedDistricts.add(widget.pharmacies[i]['neighborhood']);
        print("****************${widget.pharmacies[i]['neighborhood']}");
      }else{
        print("++++++++++++++++++++++++ ${widget.pharmacies[i]['neighborhood']}");
      }
    }
  }

  getPharmacies(String ville, String quartier) {
    widget.selectedPharmacies.clear();
    for (int i = 0; i < widget.pharmacies.length; i++) {
      if (widget.pharmacies[i]['city'] == "$ville" && widget.pharmacies[i]['neighborhood'] == "$quartier") {
        widget.selectedPharmacies.add(widget.pharmacies[i]['name']);
        pharmacyId = widget.pharmacies[i]['id'];
        _id = widget.pharmacies[i]['id'];
        AppState.putInt(Data.MERCHANT_ID, pharmacyId);
        AppState.putInt(Data.SELLABLE_ITEM, pharmacyId);
        getService(widget.pharmacies[i]);
        break;
        //print("ce que je cherche: ${selectedServiceItem.name}");
      }
    }
  }

  getService(var obj){
    print("******** voici l'objet à comparer: $obj et la taille de la liste vaut: ${widget.listOfServices.length}");
    for(int i=0; i<widget.listOfServices.length; i++){
      var obj2 = widget.listOfServices[i].toJson()["merchant"];
      print("je compare avec: $obj2");
       //ignore: unrelated_type_equality_checks
      if(obj.toString() == obj2.toString()){
        selectedServiceItem = widget.listOfServices[i];
        print("******************************************* les valeurs: $selectedServiceItem");
      }
    }
  }


  List<String> listSort(List<String> list) {
    print("Entry list $list");
    if (list.length > 1)
      for (int i = 0; i < list.length - 1; i++) {
        int next = i + 1;
        if (sort(list[i], list[next]) > 0) {
          String temp = list[i];
          list[i] = list[next];
          list[next] = temp;
        }
      }
    print("Exit list $list");
    return list;
  }

  int sort(String a, String b) {
    int length = a.length > b.length ? b.length : a.length;

    for (int i = 0; i < length; i++) {
      print("${a[i]} => ${b[i]} = ${a[i].compareTo(b[i])}");
      if (a[i].compareTo(b[i]) != 0) return a[i].compareTo(b[i]);
    }
    return a.length.compareTo(b.length);
  }

  int getId() {
    return _id;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Choisissez une pharmacie!',
            style: TextStyle(color: Colors.green, fontSize: taille_champ + 3),
            textAlign: TextAlign.center,
          ),
          Container(
            color: Colors.green,
            height: 2,
            width: MediaQuery.of(context).size.width,
          ),
        ],
      ),
      content: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                    color: Colors.transparent,
                    border: Border.all(color: couleur_bordure, width: bordure),
                  ),
                  height: hauteur_champ,
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        icon: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: new Icon(
                            Icons.arrow_drop_down_circle,
                            color: Colors.green,
                          ),
                        ),
                        isDense: true,
                        elevation: 1,
                        isExpanded: true,
                        onChanged: (String selected) {
                          setState(() {
                            _current = selected;
                            print("la valeur sélectionnée: $selected");
                            _current1 = null;
                            _current2 = null;
                            this.getDistricts(selected);
                          });
                        },
                        value: null,
                        hint: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            _current == null ? "Ville" : _current,
                            style: TextStyle(
                              color: couleur_libelle_champ,
                              fontSize: taille_libelle_champ,
                            ),
                          ),
                        ),
                        items: listSort(widget.cities.toList()).map((
                            String name) {
                          return DropdownMenuItem<String>(
                            value: name,
                            child: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                name,
                                style: TextStyle(
                                    color: couleur_fond_bouton,
                                    fontSize: taille_libelle_champ,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        }).toList(),
                      )),
                ),
                Container(
                  decoration: new BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: couleur_bordure, width: bordure),
                  ),
                  height: hauteur_champ,
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        icon: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: new Icon(
                            Icons.arrow_drop_down_circle,
                            color: Colors.green,
                          ),
                        ),
                        isDense: true,
                        elevation: 1,
                        isExpanded: true,
                        onChanged: (String selected) {
                          setState(() {
                            _current1 = selected;
                            _current2 = null;
                            this.getPharmacies(_current, _current1);
                          });
                        },
                        value: null,
                        hint: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(_current1 == null ? "Quartier" : _current1,
                            style: TextStyle(
                              color: couleur_libelle_champ,
                              fontSize: taille_libelle_champ,
                            ),
                          ),
                        ),
                        items: listSort(widget.selectedDistricts.toList()).map((String name) {
                          return DropdownMenuItem<String>(
                            value: name,
                            child: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(name,
                                style: TextStyle(
                                    color: couleur_fond_bouton,
                                    fontSize: taille_libelle_champ,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        }).toList(),
                      )),
                ),
                Container(
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                    color: Colors.transparent,
                    border: Border.all(color: couleur_bordure, width: bordure),
                  ),
                  height: hauteur_champ,
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        icon: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: new Icon(
                            Icons.arrow_drop_down_circle,
                            color: Colors.green,
                          ),
                        ),
                        isDense: true,
                        elevation: 1,
                        isExpanded: true,
                        onChanged: (String selected) {
                          setState(() {
                            _current2 = selected;
                          });
                        },
                        value: null,
                        hint: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            _current2 == null ? "Votre pharmacie" : _current2,
                            style: TextStyle(
                              color: couleur_libelle_champ,
                              fontSize: taille_libelle_champ,
                            ),
                          ),
                        ),
                        items: listSort(widget.selectedPharmacies.toList()).map((String name) {
                          return DropdownMenuItem<String>(
                            value: name,
                            child: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                name,
                                style: TextStyle(
                                    color: couleur_fond_bouton,
                                    fontSize: taille_libelle_champ,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        }).toList(),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: new Container(
                              height: hauteur_champ,
                              width: MediaQuery.of(context).size.width - 80,
                              decoration: new BoxDecoration(
                                color: couleur_libelle_champ,
                                border: new Border.all(
                                  color: Colors.transparent,
                                  width: 0.0,
                                ),
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              child: new Center(
                                  child: Text(
                                    'Annuler',
                                    style: new TextStyle(
                                        fontSize: taille_text_bouton,
                                        color: couleur_text_bouton),
                                  )),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_current == null && _current1 == null && _current2 == null) {
                                  showInSnackBar("Veuillez sélectionner une ville, un quartier ainsi qu'une pharmacie");
                                } else if (_current != null && _current1 == null && _current2 == null) {
                                  this.showInSnackBar("Veuillez sélectionner un quartier ainsi qu'une pharmacie");
                                } else if (_current != null && _current1 != null && _current2 == null) {
                                  this.showInSnackBar("Veuillez sélectionner une pharmacie");
                                } else if (_current == null || _current1 == null || _current2 == null) {
                                  this.showInSnackBar("Veuillez renseigner tous les champs");
                                } else {
                                  AppState.putInt(Data.SERVICE_NUMBER, _id);
                                  AppState.putString(Data.MERCHANT_ID, "$_id");
                                  AppState.putString(Data.CITY, "$_current");
                                  AppState.putString(Data.DISTRICT, "$_current1");
                                  AppState.putString(Data.TYPE, "$_current2");
                                  Navigator.pop(context, true);
                                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Operator(Services().getMerchant(_id), selectedServiceItem)));
                                }
                              });
                            },
                            child: new Container(
                              height: hauteur_champ,
                              width: MediaQuery.of(context).size.width - 80,
                              decoration: new BoxDecoration(
                                color: Colors.green,
                                border: new Border.all(
                                  color: Colors.transparent,
                                  width: 0.0,
                                ),
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              child: new Center(
                                  child: Text(
                                    'Valider',
                                    style: new TextStyle(
                                        fontSize: taille_text_bouton,
                                        color: couleur_text_bouton),
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showInSnackBar(String value) {
    widget.scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        style: TextStyle(color: Colors.white, fontSize: taille_champ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: couleur_fond_bouton,
      duration: Duration(seconds: 5),
    ));
  }
}