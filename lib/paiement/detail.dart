import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:page_transition/page_transition.dart';
import 'package:services/composants/components.dart';
import 'package:services/paiement/encaisser2.dart';
import 'package:services/paiement/historique.dart';
import 'package:flutter/material.dart';
import 'package:services/paiement/retrait2.dart';
import 'dart:async';
import 'package:services/paiement/transfert3.dart';
import 'package:shared_preferences/shared_preferences.dart';


// ignore: must_be_immutable
class Detail extends StatefulWidget {
  Detail(this._code);
  String _code;
  @override
  _DetailState createState() => new _DetailState(_code);
}

class _DetailState extends State<Detail> with SingleTickerProviderStateMixin {
  _DetailState(this._code);
  String _code;
  int currentPage = 0, choix;
  String solde, idUser, _lieu, fromMember,exp,numero, banque,_villed, _villef, _typeOper, expName,_toMember, codeIso2, nomPays, iso, namePays, _url, toMember, userImage, deviseLocale, _serviceName, _name, _nomd, _amount, _fees, _status, _transactionid, _date, _payst, _paysf, _username;
  bool isLoding = false, replay = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int recenteLenght = 3, archiveLenght = 3, populaireLenght =3, nb;
  int flex4, flex6, taille, enlev, rest, enlev1, enl;
  double haut, topi, bottomsolde,sold,topo22,top33, top34, top1, top, top2, top3,top4, topo1, topo2, hauteurcouverture, nomright, nomtop, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext;
  //final navigatorKey = GlobalKey<NavigatorState>();
  List data;

  @override
  void initState(){
    super.initState();
    this.read();
    this.getTrans();
  }


  Future<bool>loadMap(int q) async {
    final prefs = await SharedPreferences.getInstance();
    var jsonText = await rootBundle.loadString('images/map.json');
    this.data = json.decode(jsonText);
      for(var i=0; i<data.length; i++){
        if(q == 0){
          print("mes data0000000 ${data.toString()}");
          if(_payst.length>2){
            String iso3 = data[i]['code3'];
            if(iso3 == "$_payst"){
              nomPays = data[i]['name'];
              codeIso2 = data[i]['code'];
              prefs.setString("codeIso2", codeIso2);
              prefs.setString("nomPays", nomPays);
              print("codeIso2 $codeIso2");
              break;
            }
          }else{
            String iso2 = data[i]['code'];
            if(iso2 == "$_payst"){
              nomPays = data[i]['name'];
              codeIso2 = data[i]['code'];
              prefs.setString("codeIso2", codeIso2);
              prefs.setString("nomPays", nomPays);
              prefs.setString("payst", data[i]['code3'].toString());
              break;
            }
          }
        }else{
          print("mes data111111111 ${data.toString()}");
          String iso2 = data[i]['code'];
          if(iso == iso2){
            namePays = data[i]['name'];
            prefs.setString("fromPaysName", namePays);
            break;
          }
        }
      }
    return true;
  }


  read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _payst = prefs.getString("payst");
      _username = prefs.getString("username");
      _paysf = prefs.getString("paysf");
      _typeOper = prefs.getString("typeOper");
      _serviceName = prefs.getString("serviceName");
      _name = prefs.getString("named");
      _nomd = prefs.getString("nomd");
      _amount = prefs.getString("montant");
      _fees = prefs.getString("fees");
      _status = prefs.getString("status");
      _transactionid = prefs.getString("transactionid");
      _date = prefs.getString("date");
      deviseLocale = prefs.getString("deviseLocale");
      _url = "$base_url/transaction/getTransactionById/$deviseLocale/$_transactionid";
    });
    //this.loadMap(0);
  }

  save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("lieu", _lieu);
    prefs.setString("bankName", "$banque");
    prefs.setString("accountNumber", "$numero");
    prefs.setString("villed", "$_villed");
    prefs.setString("villef", "$_villef");
    //prefs.setString("villed", "$_villed");
    if(_serviceName == "WALLET_TO_BRM" && banque == null)
      prefs.setString("type", "Cash");
    else if(_serviceName == "WALLET_TO_BRM" && banque != null)
      prefs.setString("type", "Account");
  }

  Future<void> getTrans() async {
    final prefs = await SharedPreferences.getInstance();
    String _password = prefs.getString("password");
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    print("xxxxxxxxxx $_url");
    HttpClientRequest request = await client.getUrl(Uri.parse("$_url"));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json');
    request.headers.set('Authorization', 'Basic $credentials');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print("statusCode ${response.statusCode}");
    print("body $reply");
    if(response.statusCode == 200){
      var responseJson = json.decode(reply);
      setState(() {
        _toMember = responseJson['toMember'];
        prefs.setString("to", responseJson['toMember']);
        toMember = responseJson['toMember'].toString();
        prefs.setString("adresse", responseJson['toAdress']);
        prefs.setString("motif", responseJson['description']);
        prefs.setString("fromCardType", responseJson['fromCardType']);
        prefs.setString("fromCardNumber", responseJson['fromCardNumber']);
        prefs.setString("fromCardNumber", responseJson['fromCardNumber']);
        if(responseJson['toFirstName'] == "." || responseJson['toFirstName'] == null || responseJson['toFirstName'] == "null"){
          prefs.setString("nomd",responseJson['toLastName']);
        }else if(responseJson['toLastName'] == "." || responseJson['toLastName'] == null || responseJson['toLastName'] == "null"){
          prefs.setString("nomd",responseJson['toFirstName']);
        } else
          prefs.setString("nomd", responseJson['toFirstName'] + responseJson['toLastName']);
        prefs.setString("nomt", responseJson['toLastName']);
        prefs.setString("prenomt", responseJson['toFirstName']);
        prefs.setString("prenomf", responseJson['fromFirstName']);
        prefs.setString("nomf", responseJson['fromLastName']);
        prefs.setString("naissancef", responseJson['fromPlaceOfBith']);
        prefs.setString("adressef", responseJson['fromAdress']);

        prefs.setString("fromCardIssuingDate", responseJson['fromCardIssuingDate'].toString().split("T")[0].replaceAll("-", "/"));
        prefs.setString("fromCardExpirationDate", responseJson['fromCardExpirationDate'].toString().split("T")[0].replaceAll("-", "/"));
        prefs.setString("fromPays", "flags/${responseJson['fromCountryISO'].toString().toLowerCase()}.png");
        iso = responseJson['fromCountryISO'].toString();
        fromMember = responseJson['fromMemeber'];
        exp = responseJson['username'];
        //numero, banque
        numero = responseJson['accountNumber'];
        banque = responseJson['bankName'];
        _villed = responseJson['toTown'];
        _villef = responseJson['fromTown'];
        print("exp exp exp $exp");
      });
      this.geUserByPhone(exp);
      prefs.setString("to", _toMember);
    }
  }

  String getMonth(String date){
    String mois;
    switch(int.parse(date.split("-")[1])){
      case 1: mois = "Janvier";break;
      case 2: mois = "Février";break;
      case 3: mois = "Mars";break;
      case 4: mois = "Avril";break;
      case 5: mois = "Mai";break;
      case 6: mois = "Juin";break;
      case 7: mois = "Juillet";break;
      case 8: mois = "Août";break;
      case 9: mois = "Septembre";break;
      case 10: mois = "Octobre";break;
      case 11: mois = "Novembre";break;
      case 12: mois = "Décembre";break;
    }
    return "${date.split("-")[0]} $mois ${date.split("-")[2]}";
  }


  String getStatus(String status){
    String _status;
    if(status == "PROCESSED")
      _status = "Approuvé";
    else
      _status = "Echoué";
    return _status;
  }

  String getNature(String nature, String typeOper){
    String _nature = "";
    if(nature == "WALLET_TO_WALLET" || nature == "WALLET_TO_WARI" || nature == "WALLET_TO_EU" || nature == "AGENT_TO_USER" || nature == "WALLET_TO_ATPS" || nature == "WALLET_TO_BRM"){
      _nature = "Transfert d'argent";
    }else if(nature == "EU_TO_WALLET" || nature == "CARD_TO_WALLET" || nature == "PAYPAL_TO_WALLET" || nature == "OM_TO_WALLET" || nature == "MOMO_TO_WALLET" || nature == "WALLET_TO_YUP"){
      _nature = "Recharge d'argent";
    }else if(nature == "WALLET_TO_MTN" || nature == "WALLET_TO_ORANGE" || nature == "WALLET_TO_MOMO" || nature == "WALLET_TO_OM" || nature == "TRANSFERT" || (nature == "RETRAIT" && typeOper == "WALLET_TO_OM")){
      _nature = "Retrait d'argent";
    }else if(nature == "SPRINTPAY_TO_WALLET_CODEREQUEST" || nature == "WALLET_PAYMENT_CODEREQUEST" || nature == "SPRINTPAY_TO_WALLET" || nature == "SPAPI_TO_WALLET"){
      _nature = "Paiement marketplace";
    }
    return _nature;
  }

  String getMoyen(String nature, String typeOper){
    String _natures = "";
    if(nature == "WALLET_TO_WALLET" || nature == "AGENT_TO_USER"){
      _natures = "Wallet SprintPay";
      _code = "";
      _lieu = "0";
      //this.getTransactionById();
    }else if(nature == "SPRINTPAY_TO_WALLET_CODEREQUEST"|| nature == "WALLET_PAYMENT_CODEREQUEST"){
      _natures = "Wallet SprintPay";
      _code = "";
      _lieu = "-1";
      //this.getTransactionById();
    }else if(nature == "WALLET_TO_EU"){//Ici _lieu ==2(Cashin) || _lieu == 1(SendMoney)
      _natures = "Wallet -> Express Union";
      //this.getTransactionById();
      print("il esixte: $fromMember");
      if(fromMember == null){
        _lieu = "1";
      }else{
        _lieu = "2";
      }
      _code = "";
      //this.loadMap(0);
    }else if(nature == "PAYPAL_TO_WALLET"){
      _natures = "Paypal -> Wallet";
      _code = "2";
      _lieu = "-1";
    }else if(nature == "OM_TO_WALLET"){
      _natures = "ORANGE Money -> Wallet";
      _code = "1";
      _lieu = "-1";
    }else if(nature == "MOMO_TO_WALLET"){
      _natures = "MTN Mobile Money -> Wallet";
      _code = "0";
      _lieu = "-1";
    }/*else if(nature == "TRANSFERT"){
      _natures = "YUP -> Wallet";
      _code = "4";
      _lieu = "-1";
    }*/else if(nature == "WALLET_TO_MTN"){
      _natures = "Wallet -> MTN Mobile Money";
      _code = "0";
      _lieu = "-2";
    }else if(nature == "WALLET_TO_OM" || nature == "WALLET_TO_MOMO" || nature == "WALLET_TO_ORANGE" || nature == "TRANSFERT" || (nature == "RETRAIT" && typeOper == "WALLET_TO_OM")){
      _natures = "Wallet -> ORANGE Money";
      _code = "1";
      _lieu = "-2";
    }else if(nature == "WALLET_TO_YUP"){
      _natures = "YUP -> Wallet";
      _code = "4";
      _lieu = "-2";
    }else if(nature == "WALLET_TO_WARI"){
      _natures = "Wallet -> WARI";
      _code = "";
      _lieu = "3";
      //this.getTransactionById();
      //this.loadMap(0);
    }else if(nature == "WALLET_TO_ATPS"){
      _natures = "Wallet -> ATPS";
      _code = "";
      _lieu = "4";
    }else if(nature == "WALLET_TO_BRM"){
      _natures = "Wallet -> BRM";
      _code = "";
      _lieu = "5";
    }
    return _natures;
  }

  getRoute(String code, String lieu) {
    //lieu == -1 pour la rechage (Encaisser)
    //lieu == -2 pour le retrait (Encaisser)
    if(code == "0" && lieu == "-1"){
      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Encaisser2('$code')));
    }else if(code == "1" && lieu == "-1"){
      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Encaisser2('$code')));
    }else if(code == "2" && lieu == "-1"){
      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Encaisser2('$code')));
    }else if(code == "4" && lieu == "-1"){
      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Encaisser2('$code')));
    }else if(code == "0" && lieu == "-2"){
      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Retrait2('$code')));
    }else if(code == "1" && lieu == "-2"){
      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Retrait2('$code')));
    }else if(code == "" && lieu == "0"){
      //showInSnackBar("Les transferts ne sont pas encore disponible!");
      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfert3(_code)));
    }else if(code == "" && lieu == "1"){
      //showInSnackBar("Les transferts ne sont pas encore disponible!");
      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfert3(_code)));
    }else if(code == "" && lieu == "2"){
      //showInSnackBar("Les transferts ne sont pas encore disponible!");
      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfert3(_code)));
    }else if(code == "" && lieu == "3"){
      //showInSnackBar("Les transferts ne sont pas encore disponible!");
      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfert3(_code)));
    }else if(code == "" && lieu == "4"){
      //showInSnackBar("Les transferts ne sont pas encore disponible!");
      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfert3(_code)));
    }else if(code == "" && lieu == "5"){
      //showInSnackBar("Les transferts ne sont pas encore disponible!");
      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfert3(_code)));
    }
  }


  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text(value,style:
        TextStyle(
            color: Colors.white,
            fontSize: taille_champ+3
        ),
          textAlign: TextAlign.center,),
          backgroundColor: couleur_fond_bouton,
          duration: Duration(seconds: 5),));
  }


  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final _large = MediaQuery.of(context).size.width;
    final _haut = MediaQuery.of(context).size.height;
    double fromHeight;
    if(_large<=320){
      fromHeight = 120;
      bottomsolde = 400;
      sold = 330;
      top1 = 65;
      top = 100;
      topo1 = 133;
      top2 = 142;
      top3 = 297;
      top4 = 220;
      top33 = 288;
      topo2 = 70;
      topo22 = 100;
      top34 = 211;
      haut=5;
      topi = 2;
      enl = 2;
    }else if(_large>320 && _large<=360 && _haut==738){
      fromHeight = 130;
      bottomsolde = 400;
      sold = 330;
      top1 = 75;
      top = 100;
      topo1 = 172;
      top2 = 190;
      top3 = 410;
      top4 = 300;
      top33 = 285;
      top34 = 395;
      topo2 = 90;
      topo22 = 100;
      haut=20;
      topi = 2;
      enl = 2;
    }else if(_large>320 && _large<=360){
      fromHeight = 130;
      bottomsolde = 400;
      sold = 330;
      top1 = 75;
      top = 100;
      topo1 = 155;
      top2 = 165;
      top3 = 345;
      top4 = 255;
      top33 = 245;
      top34 = 335;
      topo2 = 80;
      topo22 = 100;
      haut=10;
      topi = 2;
      enl = 2;
    }else if(_large>411 && _large<412){
      fromHeight = 130;
      bottomsolde = 400;
      sold = 330;
      top1 = 75;
      top = 100;
      topo1 = 172;
      top2 = 190;
      top3 = 410;
      top4 = 300;
      top33 = 285;
      top34 = 395;
      topo2 = 90;
      topo22 = 100;
      haut=20;
      topi = 2;
      enl = 2;
    }else if(_large>360){
      fromHeight = 130;
      bottomsolde = 400;
      sold = 330;
      top1 = 75;
      top = 100;
      topo1 = 172;
      top2 = 190;
      top3 = 410;
      top4 = 300;
      top33 = 285;
      top34 = 395;
      topo2 = 90;
      topo22 = 100;
      haut=20;
      topi = 15;
      enl = 2;
    }

    return new Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        backgroundColor: bleu_F,
        appBar: new PreferredSize(
            preferredSize: Size.fromHeight(fromHeight), //200
            child: new Container(
              color: bleu_F,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: IconButton(
                              onPressed: (){
                                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Historique('$_code')));
                              },
                              icon: Icon(Icons.arrow_back_ios,color: couleur_fond_bouton,)
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Historique('$_code')));
                              //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Detail(_code)));
                            },
                            child: Text('Retour',
                              style: TextStyle(color: Colors.white, fontSize: taille_champ),),
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: Text('détail de la transaction',
                            style: TextStyle(color: Colors.white, fontSize: taille_champ),),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:40, left: 20, right: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: couleur_fond_bouton,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(15),
                              topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            topLeft: Radius.circular(15),
                          )
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Text(_transactionid==null?"":_transactionid.startsWith("REF")?"$_transactionid":"REF $_transactionid", style: TextStyle(
                            color: orange_F,
                            fontSize: taille_champ,
                            fontWeight: FontWeight.bold
                        ),),
                      ) /*CarouselSlider(
                        enlargeCenterPage: true,
                        autoPlay: false,
                        enableInfiniteScroll: true,
                        viewportFraction: 1.0,
                        onPageChanged: (value){},
                        height: 35.0,
                        items: _liste.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return getMoyen(i);
                            },
                          );
                        }).toList(),
                      ),*/
                    ),
                  ),
                ],
              ),
            )
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: couleur_champ,
                ),
              ),
              Padding(
                padding: new EdgeInsets.only(top: top1-60, right: 20.0, left: 20.0),
                child: Card(
                  elevation: 5,
                  child: Container(
                    height: topo2+30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                      ),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: haut),
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                          });
                        },
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 0, bottom: 10, right: 20),
                              child: Container(
                                width: 5,
                                height: topo2+25,
                                decoration: BoxDecoration(
                                    color:_status == "PROCESSED"? Colors.green:Colors.red,
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(10),
                                        topRight: Radius.circular(10)
                                    )
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(getNature(_serviceName, _typeOper),
                                  style: TextStyle(
                                      color: couleur_titre,
                                      fontSize: taille_champ+3,
                                      fontWeight: FontWeight.bold
                                  ),),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(_amount==null?"":"${getMillis(double.parse(_amount).toString())} $deviseLocale",
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: taille_champ+3,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    _toMember == _username?Container():GestureDetector(
                                      onTap: (){
                                        this.loadMap(0);
                                        if(_lieu == "3") this.loadMap(1);
                                        save();
                                        getRoute(_code, _lieu);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/2-80),
                                        child:replay == false? Icon(Icons.cached, color: orange_F,size: 30,):CupertinoActivityIndicator(),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 15),
                                  child: Container(
                                    height: 2,
                                    width: MediaQuery.of(context).size.width-100,
                                    decoration: BoxDecoration(
                                      color: couleur_description_champ,
                                    ),
                                  ),
                                ),
                                Text(_date==null?"":getMonth(_date),
                                  style: TextStyle(
                                      color: couleur_champ,
                                      fontSize: taille_champ,
                                      fontWeight: FontWeight.bold
                                  ),textAlign: TextAlign.right,)
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 0, bottom: 10, left: 22),
                              child: Container(
                                width: 5,
                                height: topo2+25,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        topLeft: Radius.circular(10)
                                    )
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _serviceName == "SPRINTPAY_TO_WALLET_CODEREQUEST" || _serviceName == "WALLET_PAYMENT_CODEREQUEST"?Container():Padding(
                padding: EdgeInsets.only(top: top1+70, left: 50, right: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Text("Pays", style: TextStyle(
                      fontSize: taille_champ+2
                      ),),
                    ),
                    Expanded(
                      flex: 9,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(_paysf=="null"?"":"$_paysf ", style: TextStyle(
                              color: couleur_fond_bouton,
                              fontSize: taille_champ+2
                            ),),
                            Text(_payst=="null"?"":"vers ", style: TextStyle(
                                fontSize: taille_champ+2
                            ),),
                            Text(_payst=="null"?"":"$_payst ", style: TextStyle(
                                color: couleur_fond_bouton,
                                fontSize: taille_champ+2
                            ),),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: top1+105, left: 30, right: 30),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width-40,
                  decoration: BoxDecoration(
                    color: couleur_decription_page,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: top1+120, left: 50, right: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Moyen de paiement", style: TextStyle(
                            fontSize: taille_champ+2
                        ),),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(getMoyen(_serviceName, _typeOper), style: TextStyle(
                              color: couleur_fond_bouton,
                              fontSize: taille_champ+2,
                            fontWeight: FontWeight.bold
                          ),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: top1+170, left: 30, right: 30),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width-40,
                  decoration: BoxDecoration(
                    color: couleur_decription_page,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: top1+190, left: 50, right: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(_toMember == _username?"Expéditeur":"Destinataire", style: TextStyle(
                            fontSize: taille_champ+2
                        ),),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            _serviceName == "EU_TO_WALLET" || _serviceName == "CARD_TO_WALLET" || _serviceName == "PAYPAL_TO_WALLET" || _serviceName == "OM_TO_WALLET" || _serviceName == "TRANSFERT" || _serviceName == "MOMO_TO_WALLET" || _serviceName == "SPRINTPAY_TO_WALLET_CODEREQUEST" || _serviceName == "WALLET_PAYMENT_CODEREQUEST"?
                            _toMember == null?Container():Text(_toMember, style: TextStyle(
                                color: couleur_fond_bouton,
                                fontSize: taille_champ+2,
                                fontWeight: FontWeight.bold
                            ),)
                            :Column(
                              children: <Widget>[
                                _toMember == null?Container():_toMember==_username?exp == null?Container():Text(exp, style: TextStyle(
                                  color: couleur_fond_bouton,
                                  fontSize: taille_champ+2,
                                  fontWeight: FontWeight.bold
                              ),):Text(_toMember, style: TextStyle(
                                    color: couleur_fond_bouton,
                                    fontSize: taille_champ+2,
                                    fontWeight: FontWeight.bold
                                ),),
                                _serviceName == null|| getDestinataire()==null?Container():Text(getDestinataire(), style: TextStyle(
                                    color: couleur_fond_bouton,
                                    fontSize: taille_champ+2,
                                    fontWeight: FontWeight.bold
                                ),),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: top1+230, left: 30, right: 30),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width-40,
                  decoration: BoxDecoration(
                    color: couleur_decription_page,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: top1+250, left: 50, right: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Montant", style: TextStyle(
                            fontSize: taille_champ+2
                        ),),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(_amount==null?"":"${getMillis(double.parse(_amount).toString())} $deviseLocale", style: TextStyle(
                              color: couleur_fond_bouton,
                              fontSize: taille_champ+2,
                              fontWeight: FontWeight.bold
                          ),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: top1+290, left: 30, right: 30),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width-40,
                  decoration: BoxDecoration(
                    color: couleur_decription_page,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: top1+310, left: 50, right: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Commission", style: TextStyle(
                            fontSize: taille_champ+2
                        ),),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(_fees==null?"":"${getMillis(_fees.toString())} $deviseLocale", style: TextStyle(
                              color: couleur_fond_bouton,
                              fontSize: taille_champ+2,
                              fontWeight: FontWeight.bold
                          ),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: top1+350, left: 30, right: 30),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width-40,
                  decoration: BoxDecoration(
                    color: couleur_decription_page,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: top1+370, left: 50, right: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Montant total de la transaction", style: TextStyle(
                            fontSize: taille_champ+2
                        ),),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(_fees==null || _amount==null?"":"${getMillis((double.parse(_fees)+double.parse(_amount)).toString())} $deviseLocale", style: TextStyle(
                              color: couleur_fond_bouton,
                              fontSize: taille_champ+2,
                              fontWeight: FontWeight.bold
                          ),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: top1+415, left: 30, right: 30),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width-40,
                  decoration: BoxDecoration(
                    color: couleur_decription_page,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: top1+435, left: 50, right: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Statut de la requête", style: TextStyle(
                            fontSize: taille_champ+2,
                        ),),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(getStatus(_status), style: TextStyle(
                              color:_status == "PROCESSED"? Colors.green:Colors.red,
                              fontSize: taille_champ+2,
                            fontWeight: FontWeight.bold
                          ),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: top1+475, left: 30, right: 30),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width-40,
                  decoration: BoxDecoration(
                    color: couleur_decription_page,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  String getDestinataireWari(){
    if(toMember==null){
      return "...";
    }else{
      return toMember;
    }
  }

  getDestinataire(){
    if(_toMember == _username){
      return expName == null?"...":expName.length>12?expName.substring(0,12):expName;
    }else{
      if(_serviceName == "EU_TO_WALLET" || _serviceName == "CARD_TO_WALLET" || _serviceName == "PAYPAL_TO_WALLET" || _serviceName == "OM_TO_WALLET" || _serviceName == "MOMO_TO_WALLET"){
        return _username == null?"...":_username.length>12?_username.substring(0,12):_username;
      }else if(_serviceName == "WALLET_TO_WALLET" || _serviceName == "WALLET_TO_EU" || _serviceName == "WALLET_TO_WARI" || _serviceName == "TRANSFERT" || _serviceName == "AGENT_TO_USER"){
        return _nomd== null?"...":_nomd.length>12?_nomd.substring(0,12):_nomd;
      }else if(_serviceName == "SPRINTPAY_TO_WALLET_CODEREQUEST" || _serviceName == "WALLET_PAYMENT_CODEREQUEST"){
        return _username == null?"...":_username.length>12?_username.substring(0,12):_username;
      }
    }
  }

  Future<void> geUserByPhone(String phone) async {
    print("url: $base_url/transaction/getUserByUsername/$phone");
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.getUrl(Uri.parse("$base_url/transaction/getUserByUsername/$phone"));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print("statusCode ${response.statusCode}");
    print("body $reply");

    if(response.statusCode == 200){
      var responseJson = json.decode(reply);
      if(responseJson['firstname']==null && responseJson['lastname']==null){
        setState(() {
          expName = "...";
        });
      }else if(responseJson['firstname']!=null && responseJson['lastname']==null){
        setState(() {
          expName = responseJson['firstname'];
        });
      }else if(responseJson['firstname']!=null && responseJson['lastname']!=null){
        setState(() {
          expName = "${responseJson['firstname'] +' '+ responseJson['lastname']}";
        });
      }else if(responseJson['firstname']==null && responseJson['lastname']!=null){
        setState(() {
          expName = responseJson['lastname'];
        });
      }
    }
  }
  //_serviceName == "WALLET_TO_WARI"?toMember==null?Container():toMember  _serviceName == "WALLET_TO_WALLET"?_nomd
}