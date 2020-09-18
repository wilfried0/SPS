import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:services/marketplace/lib/services.dart';
import 'api/PharmacyController.dart';
import 'api/ServerResponseValidator.dart';
import 'colors.dart';
import 'models/CommonServiceItem.dart';
import 'models/Services.dart';
import 'recu.dart';
import 'screen/dialog/PharmacyBox.dart';
import 'screen/dialog/QuincailleryBox.dart';
import 'screen/item/ItemSubService.dart';
import 'utils/SysSnackBar.dart';


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
  List _quincailleries = new List();
  List<CommonServiceItem> _listOfServices = new List();
  bool isLoadPharmacies = false;
  bool isLoadQuincailleries = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                enabled: false,
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
                  hintText: 'Rechercher dans la Marketplace',
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
                    //ItemSubService(Services().getMerchant(7)),
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
                  this.checkConnection(0);
                  //getPharmacies();
                },
                child: Card(
                  elevation: 4,
                  child: isLoadPharmacies == false? Container(
                    height: 70,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("marketimages/pharmacie.png"),
                        )),
                  ):CupertinoActivityIndicator(radius: 30,),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "Quincailleries",
                  style: TextStyle(
                      fontSize: taille_libelle_etape,
                      fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                onTap: () {
                  this.checkConnection(1);
                },
                child: Card(
                  elevation: 4,
                  child: isLoadQuincailleries == false? Container(
                    height: 70,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("marketimages/quincaillerie.jpg"),
                        )),
                  ):CupertinoActivityIndicator(radius: 30,),
                ),
              ),
            ],
          )),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.white,
            primaryColor: Colors.white,
            textTheme: Theme.of(context).textTheme.copyWith(caption: new TextStyle(color: Colors.white))),
        child: BottomNavigationBar(
          elevation: 4,
          items: [
            BottomNavigationBarItem(
              icon: GestureDetector(
                  onTap: () {
                    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Recu()));
                  },
                  child: Icon(Icons.receipt,
                    color: orange_F,
                  )),
              title: GestureDetector(
                  onTap: () {
                    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Recu()));
                  },
                  child: Text('Mes Reçus',
                    style: TextStyle(color: orange_F),
                  )),
            ),
            BottomNavigationBarItem(
              icon: Container(),
              title: Container()
            ),
          ],
        ),
      ),
    );
  }

  getPharmacies() {
    if (donnees != null) {
      PharmacyAlert(context);
    } else {
      SysSnackBar().show(
          _scaffoldKey, "Un instant recupération de la liste des pharmacies");
      _cities.clear();
      PharmacyController().getList((List<dynamic> json) {
        donnees = json;
        print("************************ Les fameuses données: $donnees");
        json.forEach((city) => {
          _cities.add(city["merchant"]['address']),
          _pharmacies.add(city["merchant"]),
          _listOfServices.add(CommonServiceItem.fromJson(city))
        });
        print("voilà _listOfPharmacieServices ${_listOfServices.toString()}");
        PharmacyAlert(context);
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

  Future<void> PharmacyAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: PharmacyBox(
              cities: _cities,
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

  Future<void> QuincailleryAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: QuicailleryBox(
              cities: _cities,
              listOfServices: _listOfServices,
              quincailleries: _quincailleries,
              data: donnees,
              scaffoldKey: _scaffoldKey,
            ),
          ),
        );
      },
    );
  }

  void checkConnection(int q) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      if(q == 0){
        setState(() {
          isLoadPharmacies = true;
        });
      } else{
        setState(() {
          isLoadQuincailleries = true;
        });
      }
      this.getElements(q);
    } else if (connectivityResult == ConnectivityResult.wifi) {
      if(q == 0){
        setState(() {
          isLoadPharmacies = true;
        });
      } else{
        setState(() {
          isLoadQuincailleries = true;
        });
      }
      this.getElements(q);
    } else {
      notConnection(context);
    }
  }

  getElements(int q) async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    String url;
    if(q == 0){
      url = "$baseUrl/merchants?category=PHARMACY&countryCode=CMR";
    }else{
      url ="$baseUrl/merchants?category=HARDWARESTORE&countryCode=CMR";
    }
    print("$url");
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.set('Accept', 'application/json');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print(response.statusCode);
    print(reply);
    if(response.statusCode == 200){
      if(reply.isEmpty){
        setState(() {
          if(q == 0)
            isLoadPharmacies = false;
          else
            isLoadQuincailleries = false;
        });
        SysSnackBar().show(_scaffoldKey, "Aucune pharmacie repertoriée");
      }else{
        var responseJson = json.decode(reply);
        for(int i=0; i<responseJson["data"]["merchants"].length; i++){
          _cities.add(responseJson["data"]["merchants"][i]['city']);
          if(q == 0)
            _pharmacies.add(responseJson["data"]["merchants"][i]);
          else
            _quincailleries.add(responseJson["data"]["merchants"][i]);
        }
        getData(q);
      }
    }else{
      print(response.statusCode);
      if(q == 0)
        isLoadPharmacies = false;
      else
        isLoadQuincailleries = false;
      SysSnackBar().show(_scaffoldKey, "Service indisponible");
    }
  }

  getData(int q) async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    String url;
    if(q == 0)
      url ="$baseUrl/items?category=PHARMACY";
    else
      url ="$baseUrl/items?category=HARDWARESTORE";
    print("$url");
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.set('Accept', 'application/json');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print(response.statusCode);
    print(reply);
    if(response.statusCode == 200){
      //ServerResponseValidator
        var responseJson = ServerResponseValidator.fromJson(json.decode(reply));
        List _items = responseJson.getJson()["items"];
        if(_items.length <= 0){
          setState(() {
            if(q == 0){
              isLoadPharmacies = false;
              SysSnackBar().show(_scaffoldKey, "Aucune pharmacie repertoriée");
            } else{
              isLoadQuincailleries = false;
              SysSnackBar().show(_scaffoldKey, "Aucune quincaillerie repertoriée");
            }
          });
        }else{
          print("effectivement c'est une liste de taille: ${_items.length}\n et ayant pour valeurs ${_items.toString()}");
          _listOfServices.clear();
          for(int i=0; i<_items.length; i++){
            CommonServiceItem item = CommonServiceItem.fromJson(_items[i]);
            print("voilà l'objet à ajouter': $item");
            _listOfServices.add(item);
          }
          print("liste finale dont la taille est: ${_items.length} et les valeurs: ${_items.toString()}");
          setState(() {
            if(q == 0){
              isLoadPharmacies = false;
              this.PharmacyAlert(context);
            } else{
              isLoadQuincailleries = false;
              this.QuincailleryAlert(context);
            }
          });
        }
    }else{
      print(response.statusCode);
      SysSnackBar().show(_scaffoldKey, "Service indisponible");
    }
  }
}