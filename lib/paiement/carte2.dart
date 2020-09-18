import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:services/composants/components.dart';
import 'package:services/paiement/carte1.dart';
import 'package:services/paiement/confirma.dart';
import 'package:services/paiement/echec.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'getsoldewidget.dart';

class Carte2 extends StatefulWidget {
  @override
  _Carte2State createState() => _Carte2State();
}

class _Carte2State extends State<Carte2> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double _taill,
      ad = 3;
  int choice = 0,
      temps = 600,
      _id;
  String _iso3,
      _firstname,
      _lastname,
      montant = "",
      idOrPassport,
      expiryDate,
      cellphoneNumber,
      fees = "",
      deviseLocale,
      _password,
      _username,
      _phone;
  bool _isLoading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    read();
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString("username");
      _iso3 = prefs.getString("iso3");
      _firstname = prefs.getString("firstname");
      _lastname = prefs.getString("lastname");
      montant = prefs.getString("montant");
      fees = prefs.getString("fees");
      _phone = prefs.getString("cellphoneNumber");
      deviseLocale = prefs.getString("deviseLocale");
      expiryDate = prefs.getString("expiredate");
      idOrPassport = prefs.getString("idOrPassport");
    });
  }

  void checkConnection(var body) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      //print("Connected to Mobile");
      setState(() {
        _isLoading = true;
      });
      this.getId(body);
    } else if (connectivityResult == ConnectivityResult.wifi) {
      //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Connexion(_code)));
      setState(() {
        _isLoading = true;
      });
      this.getId(body);
    } else {
      _ackAlert(context);
    }
  }

  Future<void> _ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Oops!'),
          content: const Text('Vérifier votre connexion internet.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double fromHeight = 200;
    final _large = MediaQuery
        .of(context)
        .size
        .width;
    final _haut = MediaQuery
        .of(context)
        .size
        .height;
    if (_large <= 320) {
      _taill = taille_description_champ - 2;
      ad = 3;
    } else if (_large > 320 && _large <= 360 && _haut == 738) {
      _taill = taille_description_champ - 1;
      ad = 3;
    } else if (_large > 320 && _large <= 360) {
      _taill = taille_description_champ + 3;
      ad = 3;
    } else if (_large == 375.0) {
      _taill = taille_description_champ;
      ad = 0;
    } else if (_large > 360) {
      _taill = taille_description_champ;
      ad = 3;
    } else if (_large > 411 && _large < 412) {
      _taill = taille_description_champ;
      ad = 3;
    }

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: GRIS,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(fromHeight),
          child: new Container(
            color: bleu_F,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 23, left: 20, right: 20),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context, PageTransition(type: PageTransitionType
                                .fade, child: Carte1()));
                          },
                          icon: Icon(Icons.arrow_back_ios, color: Colors.white,)
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, PageTransition(
                              type: PageTransitionType.fade, child: Carte1()));
                        },
                        child: Text('Retour',
                          style: TextStyle(
                              color: Colors.white, fontSize: taille_champ),),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Commander une carte\nprépayée",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: taille_titre - 2,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                getSoldeWidget(),
              ],
            ),
          ),
        ),
        body: getView(context),
        bottomNavigationBar: barreBottom
    );
  }

  Widget getView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: ListView(
        children: [
          Text("Type de carte à commander", style: TextStyle(
              fontWeight: FontWeight.bold
          ),),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              children: [
                Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                            ),
                            color: Colors.white,
                            border: Border.all(
                                color: orange_F
                            )
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: 50,
                                child: new Image.asset(choice == 0
                                    ? 'images/credit-card.png'
                                    : 'images/credit-card-2.png')),
                            new Text(choice == 0 ? "Virtuelle" : "Physique",
                              style: TextStyle(
                                  color: choice == 0
                                      ? orange_F
                                      : couleur_bordure,
                                  fontSize: MediaQuery
                                      .of(context)
                                      .size
                                      .width >= 1000 ? 20 : _taill,
                                  fontWeight: FontWeight.bold
                              ),)
                          ],
                        ),
                      ),
                    )
                ),
              ],
            ),
          ),

          Text("Coût de la carte", style: TextStyle(
              fontWeight: FontWeight.bold
          ),),

          Text(montant == "" ? "" : '${getMillis(
              double.parse(montant).toString())} $deviseLocale',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: couleur_libelle_etape,
              fontSize: MediaQuery
                  .of(context)
                  .size
                  .width <= 320 && montant.length >= 6
                  ? taille_titre + 10
                  : taille_titre + 15,
            ),),

          Text("Commission", style: TextStyle(
              fontWeight: FontWeight.bold
          ),),

          Text(fees == "" ? "" : '${getMillis(
              double.parse(fees).toString())} $deviseLocale', style: TextStyle(
            fontWeight: FontWeight.bold,
            color: couleur_libelle_etape,
            fontSize: MediaQuery.of(context).size.width <= 320 && montant.length >= 6 ? taille_titre + 10 : taille_titre + 15,
          ),),

          Text("Montant total", style: TextStyle(
              fontWeight: FontWeight.bold
          ),),

          Text(montant==""?"":'${getMillis((double.parse(montant)+double.parse(fees)).toString())} $deviseLocale',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: couleur_libelle_etape,
              fontSize: MediaQuery.of(context).size.width <= 320 && montant.length >= 6 ? taille_titre + 10 : taille_titre + 15,
            ),),

          Text("Nombre de mois de validité de la carte", style: TextStyle(
              fontWeight: FontWeight.bold
          ),),

          Text("$expiryDate mois", style: TextStyle(
            fontWeight: FontWeight.bold,
            color: couleur_libelle_etape,
            fontSize: MediaQuery
                .of(context)
                .size
                .width <= 320 && montant.length >= 6
                ? taille_titre + 10
                : taille_titre + 15,
          ),),

          Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10),
            child: new GestureDetector(
              onTap: () {
                var request = RequestCard(
                  amount: int.parse(montant),
                  username: _username,
                  fees: double.parse(fees),
                  cellphoneNumber: _phone,
                  countryCodeISO3: _iso3,
                  expiryDate: expiryDate,
                  firstName: _firstname,
                  idOrPassport: idOrPassport,
                  lastName: _lastname
                );
                print(json.encode(request));
                checkConnection(json.encode(request));
              },
              child: new Container(
                height: hauteur_champ,
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 40,
                decoration: new BoxDecoration(
                  color: couleur_fond_bouton,
                  border: new Border.all(
                    color: Colors.transparent,
                    width: 0.0,
                  ),
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                child: new Center(
                  child: _isLoading == false ? new Text('Valider',
                    style: new TextStyle(fontSize: taille_text_bouton + ad,
                        color: couleur_text_bouton),) :
                  Theme(
                      data: ThemeData(
                          cupertinoOverrideTheme: CupertinoThemeData(
                              brightness: Brightness.dark)),
                      child: CupertinoActivityIndicator(radius: 20,)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> getId(var body) async {
    final prefs = await SharedPreferences.getInstance();
    _password = prefs.getString("password");
    print("$_username, $_password");
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse("$carte_url/createVirtualCard"));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json');
    request.headers.set('Authorization', 'Basic $credentials');
    request.add(utf8.encode(body));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print("statusCode ${response.statusCode}");
    print("body $reply");
    if (reply.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      showInSnackBar("Service indisponible!", _scaffoldKey, 5);
    } else if (response.statusCode == 200) {
      var responseJson = json.decode(reply);
      _id = responseJson['transactionID'];
      getStatus(_id);
    }else if(response.statusCode == 400){
      setState(() {
        _isLoading = false;
      });
      showInSnackBar("Echec de l'opération: ${json.decode(reply)['error']}", _scaffoldKey, 5);
    } else{
      setState(() {
        _isLoading = false;
      });
      showInSnackBar("Echec de l'opération!", _scaffoldKey, 5);
    }
  }

    Future<String> getStatus(int id) async {
      final prefs = await SharedPreferences.getInstance();
      _password = prefs.getString("password");
      print("$_username, $_password");
      var bytes = utf8.encode('$_username:$_password');
      var credentials = base64.encode(bytes);
      var url = "$carte_url/checkTransaction/$id";
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      request.headers.set('accept', 'application/json');
      request.headers.set('Authorization', 'Basic $credentials');
      request.headers.set('content-type', 'application/json');
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      print("statusCode au statusCode ${response.statusCode}");
      print("body au statusCode $reply");
      if (response.statusCode == 200) {
        var responseJson = json.decode(reply);
        if (responseJson['status'] == "CREATED" || responseJson['status'] == "PENDING") {
          if (temps == 0) {
            setState(() {
              _isLoading = false;
            });
            showInSnackBar("Votre transaction est en cours...", _scaffoldKey, 5);
          } else if (temps > 0) {
            temps--;
            getStatus(id);
          }
        } else if (responseJson['status'] == "PROCESSED") {
          setState(() {
            _isLoading = false;
          });
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Confirma(choice == 0?"cartev":"cartep")));
        } else if (responseJson['status'] == "REFUSED") {
          setState(() {
            _isLoading = false;
          });
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Echec(choice == 0?"_code^c":"_code^v")));
        } else {
          setState(() {
            _isLoading = false;
          });
          showInSnackBar("Service indisponible!", _scaffoldKey, 5);
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        showInSnackBar("Service indisponible", _scaffoldKey, 5);
      }
      return null;
    }
  }