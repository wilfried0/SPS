import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:services/composants/components.dart';
import 'package:services/paiement/getsoldewidget.dart';
import 'package:services/paiement/payst.dart';
import 'package:services/paiement/transfert22.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'transfert2.dart';


// ignore: must_be_immutable
class Transfert1 extends StatefulWidget {
  Transfert1(this._code);
  String _code;
  @override
  _Transfert1State createState() => new _Transfert1State(_code);
}

class _Transfert1State extends State<Transfert1> {
  _Transfert1State(this._code);
  String _code;
  int currentPage = 0;
  int choice = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // ignore: non_constant_identifier_names
  int recenteLenght, archiveLenght, populaireLenght, id_kitty;
  var _formKey = GlobalKey<FormState>();
  var _categorie = ['Soutien familial', 'Frais medicaux', 'Achat marchandise', 'Financement projet', 'Investissement', 'Autre'];
  int flex4, flex6, taille, enlev, rest, enlev1, indik=0, lieu, selectedRadio;
  double ad,_taill,gauch,fees,newSolde, droit, hauteurcouverture, nomright, nomtop, right1, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext, left1, social, topo, div1, div2, margeleft, margeright;
  final navigatorKey = GlobalKey<NavigatorState>();
  List data, list;
  Color color;
  bool isLoadClient = false, isLoadDirect = false;
  // ignore: non_constant_identifier_names
  String kittyImage,_motif,nomPays,codeIso2, from, firstnameBenef,solde,kittyId,remain, particip, previsional_amount,amount_collected, endDate, startDate, title, suggested_amount, amount, description, number, nom="", tel="", email="", montant="", mot="", _username, _password, deviseLocale, local, devise, country;

  @override
  void initState() {
    //from = _code.split('^')[4];
    super.initState();
    _code = "$_code^$indik";
    this.read();
    //_userTextController = new MoneyMaskedTextController(decimalSeparator: '', thousandSeparator: '.', precision: 0);
  }


  void checkConnection(var body, int q) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      //print("Connected to Mobile");
      setState(() {
        if(q == 0){
          isLoadClient = true;
          getSoldeCommission(body, q);
        }else{
          isLoadDirect = true;
          getSoldeCommission(body, q);
        }
      });
      //this.getUser();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Connexion(_code)));
      setState(() {
        if(q == 0){
          isLoadClient = true;
          getSoldeCommission(body, q);
        }else{
          isLoadDirect = true;
          getSoldeCommission(body, q);
        }
      });
      //this.getUser();
    } else {
     _ackAlert(context);
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text(value,style:
        TextStyle(
            color: Colors.white,
            fontSize: taille_description_champ+3
        ),
          textAlign: TextAlign.center,),
          backgroundColor: couleur_fond_bouton,
          duration: Duration(seconds: 5),));
  }

  @override
  void dispose() {
    //_userTextController.dispose();
    super.dispose();
  }

  Future<String> getSoldeCommission(var body, int q) async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString("username");
    _password = prefs.getString("password");
    print("$_username, $_password");
    String fee = "$base_url/transaction/getFeesTransaction";
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse(fee));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json');
    request.headers.set('Authorization', 'Basic $credentials');
    request.write(body);
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print("statusCode ${response.statusCode}");
    print("body $reply");
      if (response.statusCode < 200 || json == null) {
        setState(() {
          if(q == 0){
            isLoadClient = false;
          }else{
            isLoadDirect = false;
          }
        });
        throw new Exception("Error while fetching data");
      }else if(response.statusCode == 200){
        var responseJson = json.decode(reply);
        fees = responseJson['fees'];
        if(q == 0 && prefs.get("dial") == prefs.get("DIAL")) fees = 0.0;
        newSolde = double.parse(montant)+fees;
        print(newSolde.toString());
        print(double.parse(local));
        if(newSolde<=double.parse(local)){
          lieu = q;
          this._save();
          setState(() {
            if(q == 0){
              isLoadClient = false;
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfert22(_code)));
            }else{
              isLoadDirect = false;
              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfert2(_code)));
            }
          });
        }else{
          setState(() {
            if(q == 0){
              isLoadClient = false;
            }else{
              isLoadDirect = false;
            }
          });
          showInSnackBar("Solde insuffisant pour effectuer cette opération!");
        }
      }else {
        setState(() {
          if(q == 0){
            isLoadClient = false;
          }else{
            isLoadDirect = false;
          }
        });
        showInSnackBar("Service indisponible!");
      }
      return null;
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

  Future<void> _Alert(BuildContext context, int q) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      if(q == 0){
                        Navigator.pop(context);
                        if(int.parse(this.montant)<500){
                          setState(() {
                            isLoadDirect = false;
                          });
                          showInSnackBar("Le montant doit être supérieur ou égal à 500");
                        }else{
                          var getcommission = getCommission(
                              typeOperation: "WALLET_TO_EUC",
                              country: "$country",
                              amount: int.parse(this.montant),
                              deviseLocale: deviseLocale
                          );
                          print(json.encode(getcommission));
                          checkConnection(json.encode(getcommission), 1);
                        }
                      }else{
                        Navigator.pop(context);//Vers un compte mobile WARI
                        showInSnackBar("Pas encore disponible.");
                        /*var getcommission = getCommission(
                            typeOperation: "WARI_TO_WALLET",
                            country: "$country",
                            amount: int.parse(this.montant),
                            deviseLocale: deviseLocale
                        );
                        print(json.encode(getcommission));
                        checkConnection(json.encode(getcommission), 3);*/
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Container(
                        height: hauteur_bouton,
                        width: MediaQuery.of(context).size.width/2-gauch,
                        decoration: new BoxDecoration(
                          color: couleur_fond_bouton,
                          border: new Border.all(
                            color: Colors.transparent,
                            width: 0.0,
                          ),
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        child: new Center(child:new Text(from=="UEMOA"?"Vers un compte mobile WARI":'Vers EU sans compte', style: new TextStyle(fontSize: taille_text_bouton, color: couleur_text_bouton),)
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: GestureDetector(
                      onTap: (){
                        if(q == 0){
                          Navigator.pop(context);
                          if(int.parse(this.montant)<500){
                            setState(() {
                              isLoadDirect = false;
                            });
                            showInSnackBar("Le montant doit être supérieur ou égal à 500");
                          }else{
                            var getcommission = getCommission(
                                typeOperation: "WALLET_TO_EUM",
                                country: "$country",
                                amount: int.parse(this.montant),
                                deviseLocale: deviseLocale
                            );
                            print(json.encode(getcommission));
                            checkConnection(json.encode(getcommission), 2);
                          }
                        }else{
                          Navigator.pop(context);//Vers un compte bancaire WARI
                          showInSnackBar("Pas encore disponible.");
                          /*var getcommission = getCommission(
                              typeOperation: "WARI_TO_WALLET",
                              country: "$country",
                              amount: int.parse(this.montant),
                              deviseLocale: deviseLocale
                          );
                          print(json.encode(getcommission));
                          checkConnection(json.encode(getcommission), 4);*/
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Container(
                          height: hauteur_bouton,
                          width: MediaQuery.of(context).size.width/2-gauch,
                          decoration: new BoxDecoration(
                            color: couleur_fond_bouton,
                            border: new Border.all(
                              color: Colors.transparent,
                              width: 0.0,
                            ),
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          child: new Center(child:new Text(from=="UEMOA"?"Vers un compte bancaire WARI":'Vers un compte EU Mobile', style: new TextStyle(fontSize: taille_text_bouton, color: couleur_text_bouton),)
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool>_onBackPressed(){
    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfert1(_code)));
    return null;
      /*showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Exit ?"),
        actions: <Widget>[
          FlatButton(
            child: Text("No"),
              onPressed: () => Navigator.pop(context, false),
          ),
          FlatButton(
            child: Text("Yes"),
            onPressed: () => Navigator.pop(context, true),
          )
        ],
      )
    );*/
  }

  @override
  Widget build(BuildContext context) {
    final _large = MediaQuery.of(context).size.width;
    double fromHeight = 200;
    ad = 0;
    if(_large<=320){
      hauteurcouverture = 150;
      nomright = 0;
      nomtop = 130;
      datetop = 10;
      titretop = 190;
      titreleft = 20;
      amounttop = 210;
      amountleft = 20;
      amountright = 20;
      topcolect = 235;
      topphoto = 250;
      bottomphoto = 40;
      desctop = 290; //pour l'étoile et Agriculture
      descbottom = 0;
      flex4 = 1;
      flex6 = 5;
      bottomtext = 35;
      toptext = 260;
      taille = 39;
      enlev = 0;
      rest = 30;
      enlev1 = 243;
      right1 = 120;
      left1 = 0;
      social = 25;
      topo = 470;
      div1 = 387;
      margeleft = 11.5;
      margeright = 11;
      _taill = taille_description_champ-3;
      gauch = 20;
      droit = 20;
    }else if(_large>320){
      left1 = 0;
      right1 = 197;
      hauteurcouverture = 300;
      nomright =  MediaQuery.of(context).size.width-330;
      nomtop = 280;
      datetop = 10;
      titretop = 340;
      titreleft = 20;
      amounttop = 360;
      amountleft = 20;
      amountright = 20;
      topcolect = 385;
      topphoto = 250;
      bottomphoto = 0;
      desctop = 490;
      descbottom = 20;
      flex4 = 5;
      flex6 = 6;
      bottomtext = 50;
      toptext = 420;
      taille = 250;
      enlev = 104;
      rest = 40;
      enlev1 = 260;
      social = 30;
      topo = 480;
      div1 = 387;
      margeleft = 15;
      margeright = 14;
      _taill = taille_description_champ-1;
      gauch = 20;
      droit = 20;
    }
    return new Scaffold(
      key: _scaffoldKey,
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
                      GestureDetector(
                          onTap: (){
                            setState(() {
                              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Payst()));
                            });
                          },
                          child: Icon(Icons.arrow_back_ios,color: Colors.white,)
                      ),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            //Navigator.pop(context);
                            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Payst()));
                            //Navigator.of(context).push(SlideLeftRoute(enterWidget: Detail(_code), oldWidget: Encaisser1(_code)));
                          });
                        },
                        child: Text('Retour',
                          style: TextStyle(color: Colors.white, fontSize: taille_champ),),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0, left: gauch, right: droit),
                  child: Center(
                    child: Text('Etape 1 sur 3',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: taille_libelle_etape,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('Transférer de l\'argent',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: taille_titre-2,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
                getSoldeWidget(),
              ],
            ),
          ),
        ),
        body: _buildCarousel(context),
        bottomNavigationBar: barreBottom
    );
  }


  _buildCarousel(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0)
            ),
            child: Form(
              key: _formKey,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 25+ad, left: gauch, right: droit),
                    child: Text('Vous transférer vers',
                      style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_libelle_etape,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: gauch, right: droit, top: 55+ad),
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



                  Padding(
                    padding: EdgeInsets.only(top: 130+ad, left: gauch, right: droit),
                    child: Text('Quel est le montant à transférer ?',
                      style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_libelle_etape,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: gauch, right: droit, top: 160+ad),
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
                                //controller: _userTextController,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize: taille_champ+3,
                                ),
                                validator: (String value){
                                  if(value.isEmpty || int.parse(value.replaceAll(".", ""))==0){
                                    return "Montant vide !";
                                  }else{
                                    montant = value;
                                    //_userTextController.text = montant;
                                    return null;
                                  }
                                },
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Montant à transférer',
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

                  Padding(
                    padding: EdgeInsets.only(top: 240+ad, left: gauch, right: droit),
                    child: Text('Motif de l\'opération',
                      style: TextStyle(
                          color: couleur_titre,
                          fontSize: taille_libelle_etape,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 270+ad, left: gauch, right: droit),
                    child: Container(
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
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            icon: Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: new Icon(Icons.arrow_drop_down_circle,
                                color: couleur_fond_bouton,),
                            ),
                            isDense: true,
                            elevation: 1,
                            isExpanded: true,
                            onChanged: (String selected){
                              setState(() {
                                _motif = selected;
                              });
                            },
                            value: _motif,
                            hint: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text('Choisissez le motif',
                                style: TextStyle(
                                  color: couleur_libelle_champ,
                                  fontSize:taille_libelle_champ+3,
                                ),),
                            ),
                            items: _categorie.map((String name){
                              return DropdownMenuItem<String>(
                                value: name,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text(name,
                                    style: TextStyle(
                                        color: couleur_fond_bouton,
                                        fontSize:taille_libelle_champ+3,
                                        fontWeight: FontWeight.bold
                                    ),),
                                ),
                              );
                            }).toList(),
                          )
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top:355+ad,left: gauch, right: droit,bottom: 20),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 6,
                          child: GestureDetector(
                            onTap: (){
                              if(_formKey.currentState.validate()) {
                                if(_motif == null){
                                  showInSnackBar("Veuillez sélectionner un motif");
                                }else{
                                  var getcommission = getCommission(
                                      typeOperation: "WALLET_TO_WALLET",
                                      country: "$country",
                                      amount: int.parse(this.montant),
                                      deviseLocale: deviseLocale
                                  );
                                  checkConnection(json.encode(getcommission), 0);
                                }
                                //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfert22('$_code')));
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Container(
                                height: hauteur_bouton,
                                width: MediaQuery.of(context).size.width/2-gauch,
                                decoration: new BoxDecoration(
                                  color: orange_F,
                                  border: new Border.all(
                                    color: Colors.transparent,
                                    width: 0.0,
                                  ),
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
                                child: new Center(child: isLoadClient == false? new Text('Client SprintPay', style: new TextStyle(fontSize: taille_text_bouton, color: couleur_text_bouton),):
                                    CupertinoActivityIndicator()
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: GestureDetector(
                            onTap: (){
                              if(_formKey.currentState.validate()) {
                                if(_motif == null){
                                  showInSnackBar("Veuillez sélectionner un motif");
                                }else{
                                  if(from == "CEMAC"){
                                    this._Alert(context, 0);
                                  }else if(from == "UEMOA"){
                                    var getcommission = getCommission(
                                        typeOperation: "WALLET_TO_WARI",
                                        country: "$country",
                                        amount: int.parse(this.montant),
                                        deviseLocale: deviseLocale
                                    );
                                    print(json.encode(getcommission));
                                    checkConnection(json.encode(getcommission), 3);

                                    //this._Alert(context, 1);
                                  }else{
                                    showInSnackBar("Service pas encore disponible vers ce pays.");
                                  }
                                }
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Container(
                                height: hauteur_bouton,
                                width: MediaQuery.of(context).size.width/2-droit-10,
                                decoration: new BoxDecoration(
                                  color: couleur_fond_bouton,
                                  border: new Border.all(
                                    color: Colors.transparent,
                                    width: 0.0,
                                  ),
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
                                child: new Center(child:isLoadDirect == false? new Text('Direct to cash', style: new TextStyle(fontSize: taille_text_bouton, color: couleur_text_bouton),):
                                    CupertinoActivityIndicator()
                                ),
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
          ),
        ),
      ],
    );
  }
  void _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("montant", "$montant");
    prefs.setString("fees", "$fees");
    prefs.setString("motif", "$_motif");
    prefs.setString("lieu", "$lieu");
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      //montant = prefs.getString("wallet")==null?"":prefs.getString("wallet");
      //_userTextController.text = montant==""?"0":montant;
      country = prefs.getString("payst");
      nomPays = prefs.getString("nomPays");
      codeIso2 = prefs.getString("codeIso2");
      from = prefs.getString("from");
      solde = prefs.getString("solde");
      devise = prefs.getString("devise");
      local = prefs.getString("local");
      deviseLocale = prefs.getString("deviseLocale");
    });
  }


  Widget getMoyen(int index){
    String text, img;
    switch(index){
      case 1: text = "MOBILE MONEY";img = 'mobilemoney.jpg';
      break;
      case 2: text = "PORTE MONEY";img = 'wallet.png';
      break;
      case 3: text = "CARTE BANCAIRE";img = 'carte.jpg';
      break;
      case 4: text = "CASH PAR EXPRESS UNION";img = 'eu.png';
      break;
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
        ),
        border: Border.all(
            color: index-1==indik?orange_F:bleu_F
        ),
        color: index-1==indik?orange_F:bleu_F,
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 0),
        child: GestureDetector(
          onTap: (){
            setState(() {
              //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Retrait1('$_code')));
            });
          },
          child: Column(
            children: <Widget>[
              Container(
                height: 90,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    ),
                    image: DecorationImage(
                      image: AssetImage('images/$img'),
                      fit: BoxFit.cover,
                    )
                ),),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: index-1!=indik? Text('$text',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: _taill,
                      fontWeight: FontWeight.bold
                  ),):Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('$text',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: _taill,
                          fontWeight: FontWeight.bold
                      ),),
                    Icon(Icons.check, color: Colors.white,)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

