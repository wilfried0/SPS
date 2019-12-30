import 'dart:convert';
import 'package:services/auth/profile.dart';
import 'package:services/composants/components.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';
import 'package:services/composants/services.dart';
import 'package:services/paiement/detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:fl_chart/fl_chart.dart';


// ignore: must_be_immutable
class Historique extends StatefulWidget {
  Historique(this._code);
  String _code;

  @override
  _HistoriqueState createState() => new _HistoriqueState(_code);
}

class _HistoriqueState extends State<Historique> with SingleTickerProviderStateMixin {
  _HistoriqueState(this._code);
  String _code, _url;
  Future<Login> post;
  //TabController _tabController;
  PageController pageController;
  int currentPage = 1, nb1, nb2, nb3, nb;
  String _username,deviseLocale, _password, _date, _fromCountry, _toCountry, _status, _amount, _name, _transactionId, _fees, _heure;
  DateTime date;
  bool isLoding = true;
  int recenteLenght = 3, archiveLenght = 3, populaireLenght =3, xval, choix=1, indik=1, enlvb, enlevt, ind=2017;
  int flex4, flex6, taille, enlev, rest, enlev1, idUser, grand;
  double _width,r,l,_height, filtre,rating,star, hauteurcouverture, nomright, nomtop, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext, _larg;
  var _cagnottes= [], cagnottes = [], _trans = [], _liste = [];
  final Color barBackgroundColor = const Color(0xff72d8bf);
  final Duration animDuration = Duration(milliseconds: 250);
  List data;
  int touchedIndex;

  bool isPlaying = false;

  @override
  void initState(){
    this.getHistorique();
    _url = "http://74.208.183.205:8086/corebanking/rest/transaction/getTransactions";
    super.initState();
  }

  String getLieu(String nature){
    String lieu;
    if(nature == "WALLET_TO_WARI"){
      lieu = "3";
    }else if(nature == "WALLET_TO_WALLET"){
      lieu = "0";
    }else if(nature == "OM_TO_WALLET"){
      lieu = "2";
    }else if(nature == "MOMO_TO_WALLET"){

    }else if(nature == "EU_TO_WALLET"){
      lieu = "2";
    }
  }


  void checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
    } else if (connectivityResult == ConnectivityResult.wifi) {
    } else {
      ackAlert(context);
    }
  }

  void _save(String _fromCountry, String _toCountry, String _serviceName, String _name, String _amount, String _fees, String _status, String _nature, String _transactionid, String _date) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("payst", "$_toCountry");
    prefs.setString("paysf", "$_fromCountry");
    prefs.setString("serviceName", "$_serviceName");
    prefs.setString("named", "$_name");
    prefs.setString("montant", "$_amount");
    prefs.setString("fees", "$_fees");
    prefs.setString("status", "$_status");
    prefs.setString("nature", "$_nature");
    prefs.setString("transactionid", "$_transactionid");
    prefs.setString("date", "$_date");
  }

  Future<void> getHistorique() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString("username");
    _password = prefs.getString("password");
    deviseLocale = prefs.getString("deviseLocale");
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    var headers = {
      "Accept": "application/json",
      "Authorization": "Basic $credentials"
    };
    var response = await http.get(Uri.encodeFull("$_url/$deviseLocale"), headers: headers,);
    if(response.statusCode == 200){
      print(response.body);
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        data = responseJson;
      });
    }
  }

  Future<void> ackAlert(BuildContext context) {
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _large = MediaQuery.of(context).size.width;
    final _haut = MediaQuery.of(context).size.height;
    double fromHeight, leftcagnotte, rightcagnotte, topcagnotte, bottomcagnotte;
    if(_large<=320){
      _width = MediaQuery.of(context).size.width-124;
      _height = MediaQuery.of(context).size.height;
      filtre = taille_libelle_etape-1.5;
      if(_height <= 568)
        fromHeight = 204.333333333333333333334;
      else
        fromHeight = 215;
      leftcagnotte = 30;
      rightcagnotte = 30;
      topcagnotte = 10; //espace entre mes tabs et le slider
      bottomcagnotte = 50;
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
      topphoto = 0;
      bottomphoto = 80;
      desctop = 320; //pour l'étoile et Agriculture
      descbottom = 0;
      flex4 = 8;
      flex6 = 7;
      bottomtext = 35;
      toptext = 260;
      taille = 150;
      enlev = 0;
      rest = 30;
      _larg = 30;
      enlev1 = 3;
      xval = 34;
      star = 30;
      grand = 0;
      enlvb = 0;
      enlevt = 0;
      r = 0.9;l=0.9;
    }else if(_large>320 && _large<=360 && _haut==738){
      _width = MediaQuery.of(context).size.width-132;
      filtre = taille_libelle_etape;
      fromHeight = 185;
      leftcagnotte = 40;
      rightcagnotte = 40;
      topcagnotte = 40;
      bottomcagnotte = 70;
      hauteurcouverture = 203;
      nomright =  MediaQuery.of(context).size.width-330;
      nomtop = 180;
      datetop = 10;
      titretop = 240;
      titreleft = 20;
      amounttop = 260;
      amountleft = 20;
      amountright = 20;
      topcolect = 280;
      topphoto = 0;
      bottomphoto = 90;
      desctop = 410;
      descbottom = 0;
      flex4 = 4;
      flex6 = 6;
      bottomtext = 50;
      toptext = 310;
      taille = 437;
      enlev = 104;
      rest = 40;
      _larg = 40;
      enlev1 = 2;
      xval = 40;
      star = 30;
      grand = 0;
      enlvb = 60;
      enlevt = 20;
      r = 1;l=1;
    }else if(_large>320 && _large<360){
      _width = MediaQuery.of(context).size.width-132;
      filtre = taille_libelle_etape;
      fromHeight = 185;
      leftcagnotte = 40;
      rightcagnotte = 40;
      topcagnotte = 40;
      bottomcagnotte = 70;
      hauteurcouverture = 203;
      nomright =  MediaQuery.of(context).size.width-330;
      nomtop = 180;
      datetop = 10;
      titretop = 240;
      titreleft = 20;
      amounttop = 260;
      amountleft = 20;
      amountright = 20;
      topcolect = 280;
      topphoto = 0;
      bottomphoto = 60;
      desctop = 320;
      descbottom = 0;
      flex4 = 4;
      flex6 = 6;
      bottomtext = 50;
      toptext = 310;
      taille = 437;
      enlev = 104;
      rest = 40;
      _larg = 40;
      enlev1 = 2;
      xval = 40;
      star = 30;
      grand = 0;
      enlvb = 60;
      enlevt = 20;
      r = 1;l=1;
    }else if(_large==360){
      _width = MediaQuery.of(context).size.width-132;
      filtre = taille_libelle_etape;
      fromHeight = 189;
      leftcagnotte = 40;
      rightcagnotte = 40;
      topcagnotte = 40;
      bottomcagnotte = 70;
      hauteurcouverture = 203;
      nomright =  MediaQuery.of(context).size.width-330;
      nomtop = 180;
      datetop = 10;
      titretop = 240;
      titreleft = 20;
      amounttop = 260;
      amountleft = 20;
      amountright = 20;
      topcolect = 280;
      topphoto = 12;
      bottomphoto = 0;
      desctop = 320;
      descbottom = 0;
      flex4 = 4;
      flex6 = 6;
      bottomtext = 50;
      toptext = 310;
      taille = 437;
      enlev = 104;
      rest = 40;
      _larg = 40;
      enlev1 = 2;
      xval = 40;
      star = 30;
      grand = 0;
      enlvb = 60;
      enlevt = 20;
      r = 1;l=1;
    }else if(_large == 375){//    >=Iphone 8 && 6
      _width = MediaQuery.of(context).size.width-143;
      filtre = taille_libelle_etape;
      fromHeight = 200;
      leftcagnotte = 40;
      rightcagnotte = 40;
      topcagnotte = 40;
      bottomcagnotte = 70;
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
      topphoto = 95;
      bottomphoto = 0;
      desctop = 430;
      descbottom = 0;
      flex4 = 4;
      flex6 = 6;
      bottomtext = 50;
      toptext = 420;
      taille = 437;
      enlev = 104;
      rest = 40;
      _larg = 40;
      enlev1 = 2;
      xval = 40;
      star = 30;
      grand = 3;
      enlvb = 57;
      enlevt = 20;
      r = 1;l=1;
    }else if(_large> 411 && _large<412){
      _width = MediaQuery.of(context).size.width-143;
      filtre = taille_libelle_etape;
      fromHeight = 200;
      leftcagnotte = 40;
      rightcagnotte = 40;
      topcagnotte = 40;
      bottomcagnotte = 70;
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
      topphoto = 62;
      bottomphoto = 0;
      desctop = 470;
      descbottom = 0;
      flex4 = 4;
      flex6 = 6;
      bottomtext = 50;
      toptext = 420;
      taille = 437;
      enlev = 104;
      rest = 40;
      _larg = 40;
      enlev1 = 2;
      xval = 40;
      star = 30;
      enlvb = 60;
      enlevt = 20;
      r = 1;l=1;
    }
    else if(_large>360){
      _width = MediaQuery.of(context).size.width-143;
      filtre = taille_libelle_etape;
      fromHeight = 200;
      leftcagnotte = 40;
      rightcagnotte = 40;
      topcagnotte = 40;
      bottomcagnotte = 100;
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
      topphoto = 10;
      bottomphoto = 0;
      desctop = 510;
      descbottom = 0;
      flex4 = 4;
      flex6 = 6;
      bottomtext = 50;
      toptext = 420;
      taille = 437;
      enlev = 104;
      rest = 40;
      _larg = 40;
      enlev1 = 2;
      xval = 40;
      star = 30;
      grand = 0;
      enlvb = 60;
      enlevt = 20;
      r = 1;l=1;
    }
    return new Scaffold(
          appBar: new PreferredSize(
              preferredSize: Size.fromHeight(fromHeight+180), //200
              child: new Container(
                color: bleu_F,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 43, left: 20, right: 20),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                                onTap: (){
                                    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Profile('$_code')));
                                    //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Detail(_code)));
                                },
                                child: Icon(Icons.arrow_back_ios,color: Colors.white,)
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: GestureDetector(
                              onTap: (){
                                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Profile('$_code')));
                                  //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Detail(_code)));
                              },
                              child: Text('Retour',
                                style: TextStyle(color: Colors.white, fontSize: taille_champ),),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Text('Mes transactions',
                              style: TextStyle(color: Colors.white, fontSize: taille_champ),),
                          ),
                        ],
                      ),
                    ),
                    new Padding(
                        padding: EdgeInsets.only(top: topcagnotte-enlevt, bottom: bottomcagnotte-enlvb, left: 20, right: 20),
                        child: Text('Historique de compte',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: taille_titre+grand,
                            color: Colors.white,),
                          textAlign: TextAlign.right,)),
                    AspectRatio(
                      aspectRatio: 1.5,
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                        color: bleu_F,
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 16, right: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Expanded(
                                    child: BarChart(mainBarData(),
                                      swapAnimationDuration: animDuration,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ),
          body:data == null?Center(child: CupertinoActivityIndicator(radius: 30,)):ListView.builder(
              itemCount: data == null?0:data.length,
              itemBuilder: (BuildContext context, int i){
               var _amount = data[i]['amount'];
               var _date = data[i]['date'].split(" ")[0];
               var _heure = data[i]['date'].split(" ")[1];
               var _fees = data[i]['fees'];
               var _toCountry = data[i]['tocountry'];
               var _status = data[i]['status'];
               var _nature = data[i]['typeOper'];
               var _fromCountry = data[i]['fromcountry'];
               var _tocountry = data[i]['tocountry'];
               var _tofirstname = data[i]['tofirstname'];
               var _serviceName = data[i]['serviceName'];
               var _transactionid = data[i]['transactionid'];
               var _tolastname = data[i]['tolastname'];
               var _name;
               if(data[i]['tofirstname'] == null || data[i]['tofirstname'] == "null")
                  _name = "${data[i]['tolastname']}";
               else if(data[i]['tolastname'] == null || data[i]['tolastname'] == "null"){
                 _name = "${data[i]['tofirstname']}";
               }else if((data[i]['tofirstname'] == null || data[i]['tofirstname'] == "null") && (data[i]['tolastname'] == null || data[i]['tolastname'] == "null")){
                 _name="";
               }else
                 _name = "${data[i]['tofirstname']} ${data[i]['tolastname']}";
               var _transactionId = data[i]['transactionid'];
                return Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: GestureDetector(
                    onTap: (){
                      _save(_fromCountry, _toCountry, _serviceName ,_name,_amount.toString(), _fees.toString(), _status, _nature ,_transactionid, _date);
                      Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Detail('$_code')));
                    },
                    child: Card(
                      elevation: .5,
                      color: couleur_appbar,
                      child: Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                flex: 6,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 5,
                                      height: 30.0,
                                      decoration: BoxDecoration(
                                          color:getStatus(_status)=="Approuvé"? Colors.green:Colors.red,
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(10),
                                              topRight: Radius.circular(10)
                                          )
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(getNature(_serviceName), style: TextStyle(
                                              color: couleur_titre,
                                              fontWeight: FontWeight.bold,
                                              fontSize: taille_champ
                                          ),),
                                          Text(getStatus(_status), style: TextStyle(
                                              color: getStatus(_status)=="Approuvé"?Colors.green: Colors.red,
                                              fontSize: taille_champ-2
                                          ),),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                            ),

                            Expanded(
                                flex: 6,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text("${getMillis(_amount.toString())} $deviseLocale", style: TextStyle(
                                          color:getStatus(_status)=="Approuvé"? Colors.green:Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: taille_champ
                                      ),),
                                      Text(getMonth(_date), style: TextStyle(
                                          color: couleur_titre,
                                          fontSize: taille_champ-2
                                      ),),
                                    ],
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
          )
        );
  }



  Widget getMoyen(String index){
    return Padding(
      padding: EdgeInsets.only(top: 0),
      child: Text("$index", style: TextStyle(
        color: orange_F,
        fontSize: taille_titre,
        fontWeight: FontWeight.bold
      ),),
    );
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

  String getNature(String nature){
    String _nature = "";
    if(nature == "WALLET_TO_WALLET" || nature == "WALLET_TO_WARI"){
      _nature = "Transfert d'argent";
    }else if(nature == "EU_TO_WALLET" || nature == "CARD_TO_WALLET" || nature == "OM_TO_WALLET" || nature == "MOMO_TO_WALLET"){
      _nature = "Recharge d'argent";
    }else if(nature == "WALLET_TO_MOMO" || nature == "WALLET_TO_OM"){
      _nature = "Retrait d'argent";
    }
    return _nature;
  }

  BarChartGroupData makeGroupData(
      int x,
      double y, {
        bool isTouched = false,
        Color barColor = Colors.white,
        double width = 20,
        List<int> showTooltips = const [],
      }) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
        y: isTouched ? y + 1 : y,
        color: isTouched ? orange_F: couleur_fond_bouton,
        width: width,
        isRound: false,
        backDrawRodData: BackgroundBarChartRodData(
          show: true,
          y: 10,
          color: bleu_F,
        ),
      ),
    ], showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(12, (i) {
    switch (i) {
      case 0:
        return makeGroupData(0, 5, isTouched: i == touchedIndex);
      case 1:
        return makeGroupData(1, 6.5, isTouched: i == touchedIndex);
      case 2:
        return makeGroupData(2, 5, isTouched: i == touchedIndex);
      case 3:
        return makeGroupData(3, 7.5, isTouched: i == touchedIndex);
      case 4:
        return makeGroupData(4, 9, isTouched: i == touchedIndex);
      case 5:
        return makeGroupData(5, 11.5, isTouched: i == touchedIndex);
      case 6:
        return makeGroupData(6, 8.5, isTouched: i == touchedIndex);
      case 7:
        return makeGroupData(7, 6, isTouched: i == touchedIndex);
      case 8:
        return makeGroupData(8, 6.5, isTouched: i == touchedIndex);
      case 9:
        return makeGroupData(9, 2.5, isTouched: i == touchedIndex);
      case 10:
        return makeGroupData(10, 1.0, isTouched: i == touchedIndex);
      case 11:
        return makeGroupData(11, 3.5, isTouched: i == touchedIndex);
      default:
        return null;
    }
  });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: couleur_fond_bouton,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String weekDay;
                switch (group.x.toInt()) {
                  case 0:
                    weekDay = 'Jan';
                    break;
                  case 1:
                    weekDay = 'Fev';
                    break;
                  case 2:
                    weekDay = 'Mar';
                    break;
                  case 3:
                    weekDay = 'Avr';
                    break;
                  case 4:
                    weekDay = 'Mai';
                    break;
                  case 5:
                    weekDay = 'Jun';
                    break;
                  case 6:
                    weekDay = 'Jul';
                    break;
                  case 7:
                    weekDay = 'Aou';
                    break;
                  case 8:
                    weekDay = 'Sep';
                    break;
                  case 9:
                    weekDay = 'Oct';
                    break;
                  case 10:
                    weekDay = 'Nov';
                    break;
                  case 11:
                    weekDay = 'Dec';
                    break;
                }
                return BarTooltipItem(weekDay + '\n' + (rod.y - 1).toString(),
                    TextStyle(color: orange_F));
              }),
          touchCallback: (barTouchResponse) {
            setState(() {
              if (barTouchResponse.spot != null &&
                  barTouchResponse.touchInput is! FlPanEnd &&
                  barTouchResponse.touchInput is! FlLongPressEnd) {
                touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
              } else {
                touchedIndex = -1;
              }
            });
          }
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
            showTitles: true,
            textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: taille_description_champ),
            margin: 5,
            getTitles: (double value) {
              switch (value.toInt()) {
                case 0:
                  return 'Jan';
                case 1:
                  return 'Fev';
                case 2:
                  return 'Mar';
                case 3:
                  return 'Avr';
                case 4:
                  return 'Mai';
                case 5:
                  return 'Jui';
                case 6:
                  return 'Jul';
                case 7:
                  return 'Aou';
                case 8:
                  return 'Sep';
                case 9:
                  return 'Oct';
                case 10:
                  return 'Nov';
                case 11:
                  return 'Dec';
                default:
                  return '';
              }
            }),
        leftTitles: const SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
        //border: Border(),
      ),
      barGroups: showingGroups(),
    );
  }
}