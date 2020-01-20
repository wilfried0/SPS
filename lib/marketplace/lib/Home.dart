import 'dart:collection';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:services/marketplace/lib/services.dart';
import 'api/PharmacyController.dart';
import 'api/ServerResponseValidator.dart';
import 'colors.dart';
import 'models/CommonServiceItem.dart';
import 'models/Services.dart';
import 'operator.dart';
import 'recu.dart';
import 'screen/item/ItemSubService.dart';
import 'system/AppState.dart';
import 'utils/SysSnackBar.dart';
import 'validation.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int indik = 0;
  List data, unfilterData;
  var _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _current, _current1, _current2, _url, url;
  HashSet<String> _cities = new HashSet<String>();
  var donnees, _data;
  List _pharmacies = new List();
  List<CommonServiceItem> _listOfServices = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _url = "$baseUrl/merchants?category=PHARMACY";
    //this.getData(url);
    _cities.add("ville non repertoriée");
  }

  Future<String> getData(String my_url) async {
    var _header = {
      "accept": "application/json",
      "content-type": "application/json",
    };
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var response = await http.get(
        Uri.encodeFull(my_url),
        headers: _header,
      );
      print('statuscode ${response.statusCode}');
      print('url $my_url');
      if (response.statusCode == 200) {
        if (my_url == "$_url") {
          setState(() {
            donnees = json.decode(utf8.decode(response.bodyBytes));
          });

          print("liste: ${donnees.toString()}");
          this.ckAlert(context);
        } else {
          setState(() {
            _data = json.decode(utf8.decode(response.bodyBytes));
          });
          print("liste: ${_data.toString()}");
        }
      } else
        print(response.body);
    } else {
      ackAlert(context);
    }
    return "success";
  }

  searchData(str) {
    var strExist = str.length > 0 ? true : false;
    if (strExist) {
      var filterData = [];
      for (var i = 0; i < unfilterData.length; i++) {
        String titre = unfilterData[i]['info']['titre'].toUpperCase();
        if (titre.contains(str.toUpperCase())) {
          filterData.add(unfilterData[i]);
        }
      }
      setState(() {
        this.data = filterData;
      });
    } else {
      setState(() {
        this.data = this.unfilterData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          decoration: BoxDecoration(
              color: couleur_champ, borderRadius: BorderRadius.circular(10)),
          width: MediaQuery.of(context).size.width - 40,
          height: hauteur_champ,
          child: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Center(
              child: TextFormField(
                keyboardType: TextInputType.text,
                style: TextStyle(
                  fontSize: taille_libelle_etape,
                  color: couleur_libelle_champ,
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return null;
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Recherher dans la Marketplace',
                  hintStyle: TextStyle(
                    fontSize: taille_libelle_etape - 2,
                    color: couleur_libelle_champ,
                  ),
                  //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        //ici on return une column avec un text et une row
          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: ListView(
            children: <Widget>[
              Text(
                "Communication",
                style: TextStyle(
                    fontSize: taille_libelle_etape,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    ItemSubService(Services().getMerchant(5)),
                    ItemSubService(Services().getMerchant(9)),
                    ItemSubService(Services().getMerchant(6)),
                    ItemSubService(Services().getMerchant(7)),
                    ItemSubService(Services().getMerchant(8)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "Energie & Eau",
                  style: TextStyle(
                      fontSize: taille_libelle_etape,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: ItemSubService(Services().getMerchant(3))),
                  Expanded(
                    flex: 1,
                    child: ItemSubService(Services().getMerchant(4)),
                  ),
                ],
              ),
              Center(
                child: Card(
                  elevation: 0.8,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: CarouselSlider(
                      enlargeCenterPage: true,
                      autoPlay: true,
                      viewportFraction: 1.0,
                      autoPlayAnimationDuration: Duration(milliseconds: 1),
                      enableInfiniteScroll: true,
                      onPageChanged: (value) {
                        setState(() {});
                      },
                      height: 300.0,
                      items: [1, 2, 3, 4, 5].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return getMoyen2(i, context, indik);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "Cable & TV",
                  style: TextStyle(
                      fontSize: taille_libelle_etape,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: ItemSubService(Services().getMerchant(1)),
                  ),
                  Expanded(
                    flex: 1,
                    child: ItemSubService(Services().getMerchant(2)),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "Pharmacies",
                  style: TextStyle(
                      fontSize: taille_libelle_etape,
                      fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                onTap: () {
                  this.getPharmacies();
                },
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("marketimages/pharmacie.png"),
                          )),
                    ),
                  ),
                ),
              ),
            ],
          )),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.white,
            primaryColor: Colors.white,
            textTheme: Theme
                .of(context)
                .textTheme
                .copyWith(caption: new TextStyle(color: Colors.white))
        ),
        child: BottomNavigationBar(
          elevation: 4,
          items: [
            BottomNavigationBarItem(
              icon: GestureDetector(
                  onTap: (){
                    Navigator.push(context,
                        PageTransition(type: PageTransitionType.fade, child: Recu()));
                  },
                  child: Icon(Icons.receipt, color: orange_F,)),
              title: GestureDetector(
                  onTap: (){
                    Navigator.push(context,
                        PageTransition(type: PageTransitionType.fade, child: Recu()));
                  },
                  child: Text('Mes Reçus', style: TextStyle(
                    color: orange_F
                  ),)),
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.receipt, color: Colors.white,),
              title: Text(''),
            ),
          ],
        ),
      ),
    );
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _selectedIndex == 1
        ? Navigator.push(context,
        PageTransition(type: PageTransitionType.fade, child: Validation()))
        : Navigator.push(context,
        PageTransition(type: PageTransitionType.fade, child: Recu()));
  }

  Future<void> ckAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: MyDialogContent(
              cities: _cities,
              //selectedDistricts: _districts,
              //selectedPharmacies: _pharmacies,
              listOfServices: _listOfServices,
              pharmacies: _pharmacies,
              data: donnees,
              scaffoldKey: _scaffoldKey,
            ),
          ),
        );
      },
    );
  }

  getPharmacies() {
    if (donnees != null) {
      ckAlert(context);
    } else {
      SysSnackBar().show(
          _scaffoldKey, "Un instant recupération de la liste des pharmacies");
      _cities.clear();
      PharmacyController().getList((List<dynamic> json) {
        donnees = json;
        json.forEach((city) => {
          _cities.add(city["merchant"]['address']),
          _pharmacies.add(city["merchant"]),
          _listOfServices.add(CommonServiceItem.fromJson(city))
        });
        print(_pharmacies);
        ckAlert(context);
        LinkedHashSet<String>.from(_cities).toList();
      }, (ServerResponseValidator validator) {
        print(validator.isError());
        SysSnackBar().error(_scaffoldKey);
      }, (ServerResponseValidator validator) {
        print(validator.isError());
      }).catchError((error) {
        SysSnackBar().show(
            _scaffoldKey, "Verifier votre connexion internet et réessayer !!");
      });
    }
  }
}

// ignore: must_be_immutable
class MyDialogContent extends StatefulWidget {
  MyDialogContent(
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
  _MyDialogContentState createState() => new _MyDialogContentState();
}

class _MyDialogContentState extends State<MyDialogContent> {
  var _formKey = GlobalKey<FormState>();
  String _current = null, _current1 = null, _current2 = null, _url;
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
    for (int i = 0; i < widget.pharmacies.length; i++) {
      if (widget.pharmacies[i]['address'] == "$ville")
        widget.selectedDistricts.add(widget.pharmacies[i]['neighborhood']);
    }
    return LinkedHashSet<String>.from(widget.selectedDistricts).toList();
  }

  getPharmacies(String ville, String quartier) {
    widget.selectedPharmacies.clear();
    for (int i = 0; i < widget.data.length; i++) {
      if (widget.pharmacies[i]['address'] == "$ville" &&
          widget.pharmacies[i]['neighborhood'] == "$quartier") {
        widget.selectedPharmacies.add(widget.pharmacies[i]['name']);
        pharmacyId = widget.pharmacies[i]['id'];
        AppState.putInt(Data.MERCHANT_ID, pharmacyId);
        print("Pharmacy id : $pharmacyId");
        selectedServiceItem = widget.listOfServices[i];
        print(selectedServiceItem.name);
      }
    }
    return LinkedHashSet<String>.from(widget.selectedPharmacies).toList();
  }

  int getId() {
    for (int i = 0; i < widget.data.length; i++) {
      if (widget.data[i]['merchant']['id'] == pharmacyId) {
        _id = widget.data[i]['id'];
        break;
      }
    }
    AppState.putInt(Data.SELLABLE_ITEM, _id);
    print("Service id : $_id");
    return _id;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Choisissez une pharmacie!',
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
                        items: widget.cities.map((String name) {
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
                          child: Text(
                            _current1 == null ? "Quartier" : _current1,
                            style: TextStyle(
                              color: couleur_libelle_champ,
                              fontSize: taille_libelle_champ,
                            ),
                          ),
                        ),
                        items: widget.selectedDistricts.map((String name) {
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
                        items: widget.selectedPharmacies.map((String name) {
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
                                stopSnackBar();
                                if (_current == null &&
                                    _current1 == null &&
                                    _current2 == null) {
                                  showInSnackBar(
                                      "Veuillez sélectionner une ville, un quartier ainsi qu'une pharmacie");
                                  stopSnackBar();
                                } else if (_current != null &&
                                    _current1 == null &&
                                    _current2 == null) {
                                  this.showInSnackBar(
                                      "Veuillez sélectionner un quartier ainsi qu'une pharmacie");
                                  stopSnackBar();
                                } else if (_current != null &&
                                    _current1 != null &&
                                    _current2 == null) {
                                  this.showInSnackBar(
                                      "Veuillez sélectionner une pharmacie");
                                  stopSnackBar();
                                } else if (_current == null ||
                                    _current1 == null ||
                                    _current2 == null) {
                                  this.showInSnackBar(
                                      "Veuillez renseigner tous les champs");
                                  stopSnackBar();
                                } else {
                                  AppState.putInt(Data.SERVICE_NUMBER, getId());
                                  AppState.putString(Data.MERCHANT_ID, "$_id");
                                  AppState.putString(Data.CITY, "$_current");
                                  AppState.putString(
                                      Data.DISTRICT, "$_current1");
                                  AppState.putString(
                                      Data.PHARMACY, "$_current2");
                                  Navigator.pop(context, true);
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.fade,
                                          child: Operator(
                                              Services().getMerchant(10),
                                              selectedServiceItem)));
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

  void stopSnackBar() {
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        widget.scaffoldKey.currentState.hideCurrentSnackBar();
      });
    });
  }
}
