import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:services/composants/components.dart';
import 'package:services/monprofile.dart';
import 'confirma.dart';
import 'echec.dart';
import 'transfert2.dart';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'transfert22.dart';


// ignore: must_be_immutable
class Transfert3 extends StatefulWidget {
  Transfert3(this._code);
  String _code;
  @override
  _Transfert3State createState() => new _Transfert3State(_code);
}

class _Transfert3State extends State<Transfert3> {
  _Transfert3State(this._code);
  String _code;
  bool isLoading = false;
  String _name, _to, _username, fromLastname, _password, montant, amount, devisebenef, description, deviseLocale, fees, _lieu, _adresse, _fromCountryISO, _fromCardType, _fromCardNumber, _fromCardIssuingDate, _fromCardExpirationDate, _fromPays, _pays;
  var _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String url, _id, _payst, _urlc, nomPays, codeIso2;
  var _feesController, _montantController, _motifController, _nameController, _toController, _descriptionController, _deviseLocaleController, _adresseController, _fromCountryISOController, _fromCardTypeController, _fromCardNumberController, _fromCardIssuingDateController, _fromCardExpirationDateController, _fromPaysController, _fromPaysNameController;
  int temps = 200;
  final navigatorKey = GlobalKey<NavigatorState>();


  @override
  void initState(){
    this.read();
    super.initState();
    url = '$base_url/transfert/wallet';
    _urlc = "$base_url/user/soldeBeneficiaire/";
    _feesController = TextEditingController();
    _montantController = TextEditingController();
    _motifController = TextEditingController();
    _nameController = TextEditingController();
    _toController = TextEditingController();
    _descriptionController = TextEditingController();
    _deviseLocaleController = TextEditingController();
    _adresseController = TextEditingController();
    _fromCountryISOController = TextEditingController();
    _fromCardTypeController = TextEditingController();
    _fromCardNumberController = TextEditingController();
    _fromCardIssuingDateController = TextEditingController();
    _fromCardExpirationDateController = TextEditingController();
    _fromPaysController = TextEditingController();
    _fromPaysNameController = TextEditingController();
  }

  @override
  void dispose() {
    _feesController.dispose();
    _montantController.dispose();
    _motifController.dispose();
    _nameController.dispose();
    _toController.dispose();
    _descriptionController.dispose();
    _deviseLocaleController.dispose();
    _adresseController.dispose();
    _fromCountryISOController.dispose();
    _fromCardTypeController.dispose();
    _fromCardNumberController.dispose();
    _fromCardIssuingDateController.dispose();
    _fromCardExpirationDateController.dispose();
    _fromPaysController.dispose();
    _fromPaysNameController.dispose();
    super.dispose();
  }

  Future<void> getCode() async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.getUrl(Uri.parse(_urlc));
    request.headers.set('Accept', 'application/json');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print("voilà**************************************************** $_urlc $reply");
    if(response.statusCode == 200){
      var responseJson = json.decode(reply);
      setState(() {
        amount = "${responseJson['balance'].toString()}" ;
        devisebenef = "${responseJson['formattedBalance'].toString()}";
      });
    }else{
      amount = null;
    }
    return null;
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lieu = prefs.getString("lieu");
      _username = prefs.getString("username");
      fromLastname = prefs.getString("nom");
      print("lieu $_lieu");
      montant = prefs.getString("montant");
      _montantController.text = montant;
      fees = prefs.getString("fees");
      _feesController.text = fees;
      _to = prefs.getString("to");
      _toController.text = _to;
      _name = prefs.getString("nomd")==null||prefs.getString("nomd").isEmpty||prefs.getString("nomd")==" "?null:prefs.getString("nomd");
      print("name: $_name");
      _nameController.text = _name;
      description = prefs.getString("motif");
      print("ma description: $description");
      _descriptionController.text = description;
      montant = prefs.getString("montant");
      deviseLocale = prefs.getString("deviseLocale");
      _payst = prefs.getString("payst");

      nomPays = prefs.getString("nomPays");
      codeIso2 = prefs.getString("codeIso2");

      _adresse = prefs.getString("adresse");
      _adresseController.text = _adresse;
      _fromCountryISO = prefs.getString("fromCountryISO");
      _fromCountryISOController.text = _fromCountryISO;
      _fromCardType = prefs.getString("fromCardType");
      if(_fromCardType == "CNI"){
        _fromCardTypeController.text = "Carte Nationale d'identité";
      }else if(_fromCardType == "Carte de sejour"){
        _fromCardTypeController.text = "Carte de séjour";
      }else _fromCardTypeController.text = _fromCardType;
      //_fromCardTypeController.text = _fromCardType;
      _fromCardNumber = prefs.getString("fromCardNumber");
      _fromCardNumberController.text = _fromCardNumber;
      _fromCardIssuingDate = prefs.getString("fromCardIssuingDate");
      _fromCardIssuingDateController.text = _fromCardIssuingDate;
      _fromCardExpirationDate = prefs.getString("fromCardExpirationDate");
      _fromCardExpirationDateController.text = _fromCardExpirationDate;
      _fromPays = prefs.getString("fromPays");
      _fromPaysController.text = _fromPays;
      _pays = prefs.getString("fromPaysName");
      _fromPaysNameController.text = _pays;
      _urlc = "${this._urlc}$deviseLocale/${double.parse(montant)}/$_payst";
      this.getCode();
    });
  }

  void checkConnection(var body) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      //print("Connected to Mobile");
      setState(() {
        isLoading = true;
        this.getId(body);
      });
      //this.getUser();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Connexion(_code)));
      setState(() {
        isLoading = true;
        this.getId(body);
      });
      //this.getUser();
    } else {
      _ackAlert(context, 0);
    }
  }

  Future<String> getId(var body) async {
    final prefs = await SharedPreferences.getInstance();
    _lieu = prefs.getString("lieu");
    _username = prefs.getString("username");
    _password = prefs.getString("password");
    print("$_username, $_password");
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    if(_lieu == "0"){
      url = '$base_url/transfert/user/wallettowallet';
    }else if(_lieu == "2"){
      url = '$base_url/transfert/eu/cashin';
    }else if(_lieu == "3"){
      url = '$base_url/transfert/wari/sendMoney';
    }else
      url = '$base_url/transfert/eu/sendMoney';
    print(url);
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json');
    request.headers.set('Authorization', 'Basic $credentials');
    request.add(utf8.encode(body));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print("statusCode ${response.statusCode}");
    print("body $reply");
      if (response.statusCode < 200 || json == null) {
        setState(() {
          isLoading = false;
        });
        throw new Exception("Error while fetching data");
      }else if(response.statusCode == 200){
        var responseJson = json.decode(reply);
        _id = responseJson['id'];
        if(_id == "INTERNAL_SERVER_ERROR"){
          setState(() {
            isLoading = false;
          });
          showInSnackBar("Montant non autorisé!", _scaffoldKey, 5);
        }else if(responseJson['payment_url'] == "THIS_CUSTOMER_HAS_EXCEEDED_HIS_LIMIT_NUMBER_OF_OPERATION"){
          setState(() {
            isLoading = false;
          });
          showInSnackBar("Vous avez atteint le nombre max d'opérations!", _scaffoldKey, 5);
        }else if(responseJson['payment_url'] == "THE_AMOUNT_OF_THIS_TRANSACTION_IS_GRATER_THAN_THE_THE_MAXIMUM_AMOUNT_PLANNED_FOR_YOUR_PROFILE"){
          setState(() {
            isLoading = false;
          });
          showInSnackBar("Le montant de la transaction est supérieur à celui autorisé à votre profil", _scaffoldKey, 5);
        }else if(responseJson['payment_url'] == "CLIENT_IS_BLACKLISTED"){
          setState(() {
            isLoading = false;
          });
          showInSnackBar("Vos opérations ont été suspendues pour des raisons de conformité. Veuillez contacter le service client !", _scaffoldKey, 5);
        }else if(responseJson['payment_url'] == "CLIENT_LOCKED_BY_SYSTEM"){
          setState(() {
            isLoading = false;
          });
          this._ackAlert(context, 1);
          //showInSnackBar("Veuillez compléter vos informations dans mon profil pour continuer à effectuer les opérations", _scaffoldKey);
        }else if(responseJson['payment_url'] == "CLIENT_LOCKED_BY_BACK_OFFICE"){
          setState(() {
            isLoading = false;
          });
          showInSnackBar("Votre compte a été bloqué veuillez contacyer le service client!", _scaffoldKey, 5);
        }else if(responseJson['id'] == "NOT_FOUND"){
          setState(() {
            isLoading = false;
          });
          showInSnackBar("Service indisponible!", _scaffoldKey, 5);
        }else{
          this.getStatus(_id);
        }
      }else {
        setState(() {
          isLoading = false;
        });
        showInSnackBar("Echec de l'opération!", _scaffoldKey, 5);
      }
      return null;
  }

  Future<String> getStatus(String id) async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString("username");
    _password = prefs.getString("password");
    print("$_username, $_password");
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    var url = "$base_url/transaction/checkStatus/$id";
    print(url);
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json');
    request.headers.set('Authorization', 'Basic $credentials');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print("statusCode ${response.statusCode}");
    print("body $reply");
    if(response.statusCode == 200){
      var responseJson = json.decode(reply);
      if(responseJson['status'] == "CREATED"){
        if(temps == 0){
          setState(() {
            isLoading = false;
          });
          navigatorKey.currentState.pushNamed("/echec");
        }else if(temps > 0){
          temps--;
          getStatus(id);
        }
      }else if(responseJson['status'] == "PROCESSED"){
        setState(() {
          isLoading = false;
        });
        navigatorKey.currentState.pushNamed("/confirma");
      }else if(responseJson['status'] == "REFUSED"){
        setState(() {
          isLoading = false;
        });
        navigatorKey.currentState.pushNamed("/echec");
      }
    }else{
      setState(() {
        isLoading = false;
      });
      showInSnackBar("Service indisponible", _scaffoldKey, 5);
    }
    return null;
  }


  Future<void> _ackAlert(BuildContext context, int q) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(q==0?'Oops!':'Compléter vos informations'),
          content: Text(q==0?'Vérifier votre connexion internet.':"Veuillez compléter vos informations pour continuer à effectuer les opérations"),
          actions: <Widget>[
            FlatButton(
              child: Text(q==0?'Ok':'Compléter'),
              onPressed: () {
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Monprofile()));
              },
            ),

            q==0?Container():FlatButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
    navigatorKey: navigatorKey,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primaryColor: Colors.white, accentColor: Color(0xFF2A2A42), fontFamily: 'Poppins'),
    routes: <String, WidgetBuilder>{
    "/echec": (BuildContext context) =>new Echec("_code^t"),
    "/confirma": (BuildContext context) =>new Confirma("transfert"),
    "/transfert": (BuildContext context) =>new Transfert22(_code)
    },
    home: new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        elevation: 0.0,
        title: Text('Vérification', style: TextStyle(
          color: couleur_description_champ,
          fontSize: taille_champ
        ),),
        backgroundColor: couleur_appbar,
        flexibleSpace: barreTop,

        leading: InkWell(
            onTap: (){
              setState(() {
                if(_lieu == "0"){
                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfert22(_code)));
                }else
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfert2(_code)));
              });
            },
            child: Icon(Icons.arrow_back_ios,)),
        iconTheme: new IconThemeData(color: couleur_fond_bouton),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text('Transférer de l\'argent',
              style: TextStyle(
                  color: couleur_titre,
                  fontSize: taille_titre,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Text('Etape 3 sur 3',
              style: TextStyle(
                  color: couleur_libelle_etape,
                  fontSize: taille_libelle_etape,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: marge_apres_titre),),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Divider(
                    color: couleur_champ,
                    height: 2,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 6,
                        child: Text("Commission de la transaction", style: TextStyle(
                            color: couleur_libelle_champ,
                            fontSize: taille_champ+3
                        ),),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(fees==null?"":"${getMillis(double.parse(fees).toString())} $deviseLocale", style: TextStyle(
                          color: couleur_fond_bouton,
                          fontSize: taille_champ+3,
                          fontWeight: FontWeight.bold
                        ),textAlign: TextAlign.end,),
                      )
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Divider(
                    color: couleur_champ,
                    height: 2,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 6,
                        child: Text("Montant total à débiter", style: TextStyle(
                            color: couleur_libelle_champ,
                            fontSize: taille_champ+3
                        ),),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(montant==null || fees==null?"":"${getMillis((double.parse(montant)+double.parse(fees)).toString())} $deviseLocale", style: TextStyle(
                          color: couleur_fond_bouton,
                          fontSize: taille_champ+3,
                          fontWeight: FontWeight.bold
                        ),textAlign: TextAlign.end,),
                      )
                    ],
                  ),
                ),

                amount==null?Container():Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Divider(
                    color: couleur_champ,
                    height: 2,
                  ),
                ),
                amount==null?Container() :Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 6,
                        child: Text("Le bénéficiaire recevra", style: TextStyle(
                            color: couleur_libelle_champ,
                            fontSize: taille_champ+3
                        ),),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text("${getMillis(double.parse(amount).toString())} $devisebenef", style: TextStyle(
                            color: couleur_fond_bouton,
                            fontSize: taille_champ+3,
                            fontWeight: FontWeight.bold
                        ),textAlign: TextAlign.end,),
                      )
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Divider(
                    color: couleur_champ,
                    height: 2,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: marge_champ_libelle),),

                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Vous transférez vers',
                      style: TextStyle(
                          color: couleur_libelle_champ,
                          fontSize: taille_libelle_champ,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Container(
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
                          color: couleur_bordure,
                          width: bordure
                      ),
                    ),
                    height: hauteur_champ,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child:codeIso2==null?Container(): new Image.asset('flags/'+codeIso2.toLowerCase()+'.png'),
                          ),
                        ),

                        Expanded(
                          flex:12,
                          child: Padding(
                              padding: const EdgeInsets.only(left:10.0,),
                              child:nomPays==null?Container(): new Text(nomPays,
                                style: TextStyle(
                                  color: couleur_description_champ,
                                  fontSize: taille_champ+3,
                                ),)
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(padding: EdgeInsets.only(top: marge_champ_libelle),),

                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Motif de l\'opération',
                      style: TextStyle(
                          color: couleur_libelle_champ,
                          fontSize: taille_libelle_champ,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Container(
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
                          color: couleur_bordure,
                          width: bordure
                      ),
                    ),
                    height: hauteur_champ,
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: new TextFormField(
                              enabled: false,
                              controller:description==null || description=="null"?null: _descriptionController,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  color: couleur_libelle_champ,
                                  fontSize: taille_champ+3,
                              ),
                              validator: (String value){
                                return null;
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Motif non renseigné',
                                hintStyle: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize: taille_champ+3,
                                ),
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: marge_champ_libelle),),

                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(_lieu=="3"?"Informations sur le bénéficiaire":'Identité & contact',
                      style: TextStyle(
                          color: couleur_libelle_champ,
                          fontSize: taille_libelle_champ,
                          fontWeight: FontWeight.bold
                      ),),
                  ),
                ),

                Padding(padding: EdgeInsets.only(top: marge_libelle_champ),),
                _name==null?Container():Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 0.0),
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                      color: Colors.transparent,
                      border: Border.all(
                        width: bordure,
                        color: couleur_bordure,
                      ),
                    ),
                    height: hauteur_champ,
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                          flex:2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new Icon(Icons.person, color: couleur_description_champ,),
                          ),
                        ),
                        new Expanded(
                          flex:10,
                          child: Padding(
                            padding: EdgeInsets.only(left:0.0),
                            child: new TextFormField(
                              enabled: false,
                              controller: _nameController,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  fontSize: taille_champ+3,
                                  color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                return null;
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Nom',
                                hintStyle: TextStyle(color: couleur_libelle_champ,
                                  fontSize: taille_champ+3,
                                ),
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _lieu!="3"?Container():Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 0.0),
                    decoration: new BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        width: bordure,
                        color: couleur_bordure,
                      ),
                    ),
                    height: hauteur_champ,
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                          flex:2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new Icon(Icons.location_on, color: couleur_description_champ,),
                          ),
                        ),
                        new Expanded(
                          flex:10,
                          child: Padding(
                            padding: EdgeInsets.only(left:0.0),
                            child: new TextFormField(
                              enabled: false,
                              controller: _adresseController,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                fontSize: taille_champ+3,
                                color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                return null;
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Adresse',
                                hintStyle: TextStyle(color: couleur_libelle_champ,
                                  fontSize: taille_champ+3,
                                ),
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 0.0),
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                        topRight: Radius.circular(_name==null?10.0:0.0),
                        topLeft: Radius.circular(_name==null?10.0:0.0),
                      ),
                      color: Colors.transparent,
                      border: Border.all(
                        width: bordure,
                        color: couleur_bordure,
                      ),
                    ),
                    height: hauteur_champ,
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                          flex:2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new Icon(Icons.phone_iphone, color: couleur_description_champ,),
                          ),
                        ),
                        new Expanded(
                          flex:10,
                          child: new TextFormField(
                            enabled: false,
                            controller: _toController,
                            keyboardType: TextInputType.phone,
                            style: TextStyle(
                              fontSize: taille_champ+3,
                              color: couleur_libelle_champ,
                            ),
                            validator: (String value){
                              return null;
                            },
                            decoration: InputDecoration.collapsed(
                              hintText: 'Numéro de téléphone',
                              hintStyle: TextStyle(
                                fontSize: taille_champ+3,
                                color: couleur_libelle_champ,
                              ),
                              //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                _lieu=="3"?Padding(padding: EdgeInsets.only(top: marge_champ_libelle),):Container(),

                _lieu!="3"?Container():Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Informations sur l'expéditeur",
                      style: TextStyle(
                          color: couleur_libelle_champ,
                          fontSize: taille_libelle_champ,
                          fontWeight: FontWeight.bold
                      ),),
                  ),
                ),

                _lieu!="3"?Container():Padding(padding: EdgeInsets.only(top: marge_libelle_champ),),

                _lieu!="3"?Container():Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 0.0),
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                      color: Colors.transparent,
                      border: Border.all(
                        width: bordure,
                        color: couleur_bordure,
                      ),
                    ),
                    height: hauteur_champ,
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                          flex:2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new Icon(Icons.assignment_ind, color: couleur_description_champ,),
                          ),
                        ),
                        new Expanded(
                          flex:10,
                          child: Padding(
                            padding: EdgeInsets.only(left:0.0),
                            child: new TextFormField(
                              enabled: false,
                              controller: _fromCardTypeController,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                fontSize: taille_champ+3,
                                color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                return null;
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Nature de la pièce d\'identité',
                                hintStyle: TextStyle(color: couleur_libelle_champ,
                                  fontSize: taille_champ+3,
                                ),
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _lieu!="3"?Container():Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 0.0),
                    decoration: new BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        width: bordure,
                        color: couleur_bordure,
                      ),
                    ),
                    height: hauteur_champ,
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                          flex:2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new Icon(Icons.assignment_ind, color: couleur_description_champ,),
                          ),
                        ),
                        new Expanded(
                          flex:10,
                          child: Padding(
                            padding: EdgeInsets.only(left:0.0),
                            child: new TextFormField(
                              enabled: false,
                              controller: _fromCardNumberController,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                fontSize: taille_champ+3,
                                color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                return null;
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Numéro de la carte',
                                hintStyle: TextStyle(color: couleur_libelle_champ,
                                  fontSize: taille_champ+3,
                                ),
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _lieu!="3"?Container():Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 0.0),
                    decoration: new BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        width: bordure,
                        color: couleur_bordure,
                      ),
                    ),
                    height: hauteur_champ,
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                          flex:2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new Icon(Icons.calendar_today, color: couleur_description_champ,),
                          ),
                        ),
                        new Expanded(
                          flex:10,
                          child: Padding(
                            padding: EdgeInsets.only(left:0.0),
                            child: new TextFormField(
                              enabled: false,
                              controller: _fromCardIssuingDateController,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                fontSize: taille_champ+3,
                                color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                return null;
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Date de délivrance',
                                hintStyle: TextStyle(color: couleur_libelle_champ,
                                  fontSize: taille_champ+3,
                                ),
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _lieu!="3"?Container():Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 0.0),
                    decoration: new BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        width: bordure,
                        color: couleur_bordure,
                      ),
                    ),
                    height: hauteur_champ,
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                          flex:2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new Icon(Icons.calendar_today, color: couleur_description_champ,),
                          ),
                        ),
                        new Expanded(
                          flex:10,
                          child: Padding(
                            padding: EdgeInsets.only(left:0.0),
                            child: new TextFormField(
                              enabled: false,
                              controller: _fromCardExpirationDateController,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                fontSize: taille_champ+3,
                                color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                return null;
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Date d\'expiration',
                                hintStyle: TextStyle(color: couleur_libelle_champ,
                                  fontSize: taille_champ+3,
                                ),
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _lieu!="3"?Container():Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 0.0),
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                      color: Colors.transparent,
                      border: Border.all(
                        width: bordure,
                        color: couleur_bordure,
                      ),
                    ),
                    height: hauteur_champ,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex:2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child:_fromPays==null?Container(): new Image.asset('$_fromPays'),
                          ),
                        ),
                        new Expanded(
                          flex:10,
                          child: Padding(
                            padding: EdgeInsets.only(left:0.0),
                            child: new TextFormField(
                              enabled: false,
                              controller: _fromPaysNameController,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                fontSize: taille_champ+3,
                                color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                return null;
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Pays où la pièce a été établie',
                                hintStyle: TextStyle(color: couleur_libelle_champ,
                                  fontSize: taille_champ+3,
                                ),
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding:  EdgeInsets.only(top: marge_champ_libelle, bottom: 20),
                  child: InkWell(
                    onTap: () async {
                      setState(() {
                        if(isLoading == true){

                        }else{
                          if(_lieu == "3") {
                            var _wariTrans = new wariTrans(
                                to: this._to,
                                amount: int.parse(this.montant),
                                fees: double.parse(fees),
                                description: this.description,
                                deviseLocale: this.deviseLocale,
                                toFirstname: ".",
                                toCountryCode: this._payst,
                                fromCardExpirationDate: _fromCardExpirationDate,
                                fromCardIssuingDate: _fromCardIssuingDate,
                                fromCardNumber: _fromCardNumber,
                                fromCardType: _fromCardType,
                                fromCountryISO: _fromCountryISO,
                                toAdress: _adresse,
                                toLastname: this._name
                            );
                            print(json.encode(_wariTrans));
                            checkConnection(json.encode(_wariTrans));
                          }else if(_lieu == "1"){//sendMoney
                            var walletTr = new eucTrans(
                              to:this._to,
                              amount: int.parse(this.montant),
                              fees: double.parse(fees),
                              description: this.description,
                              deviseLocale: this.deviseLocale,
                              toFirstname: this._name,
                              toCountryCode: this._payst,
                              from: _username,
                              fromFirstname: null,
                              fromLastname: fromLastname
                            );
                            print(json.encode(walletTr));
                            checkConnection(json.encode(walletTr));
                          }else{
                            var walletTr = new walletTrans(
                              to:this._to,
                              amount: int.parse(this.montant),
                              fees: double.parse(fees),
                              description: this.description,
                              deviseLocale: this.deviseLocale,
                              toFirstname: this._name,
                              toCountryCode: this._payst,
                            );
                            print(json.encode(walletTr));
                            checkConnection(json.encode(walletTr));
                          }
                        }
                      });
                    },
                    child: new Container(
                      height: hauteur_champ,
                      width: MediaQuery.of(context).size.width-40,
                      decoration: new BoxDecoration(
                        color: couleur_fond_bouton,
                        border: new Border.all(
                          color: Colors.transparent,
                          width: 0.0,
                        ),
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      child: Center(child: isLoading == false? new Text('valider le transfert', style: new TextStyle(fontSize: taille_text_bouton+3, color: Colors.white),):
                          CupertinoActivityIndicator()
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: barreBottom,
    )
    );
  }
}