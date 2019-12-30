import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/material.dart';
import 'package:services/composants/components.dart';
import 'package:services/composants/transition.dart';
import 'package:services/paiement/encaisser2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'confirma.dart';
import 'echec.dart';

class Webview extends StatefulWidget {
  Webview(this._code);
  String _code;
  @override
  _WebviewState createState() => _WebviewState(_code);
}

class _WebviewState extends State<Webview> {
  _WebviewState(this._code);
  String _code;

  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChanged;
  String url, _url, _reference, uri, _status,transactionId;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final navigatorKey = GlobalKey<NavigatorState>();
  int temps = 100, i = 0;
  String _username, _password, payment_url, _id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.read();
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        print("mon url $payment_url et mon id $_id");
        print("Current URL: $url");
        if(url.contains("card/notification")){
          Navigator.of(context).push(SlideLeftRoute(enterWidget: Confirma("recharge"), oldWidget: Webview(_code)));
        }else if(url=="http://www.sprintpay.com/" || url=="https://cargosprint.com/"){
          print("la valeur de i $i et filet 1");
          if(i == 0){
            this._getStatus(_id);
          }else if(i == 1){
            Navigator.of(context).push(SlideLeftRoute(enterWidget: Confirma("recharge"), oldWidget: Webview(_code)));
          }else if(i == -1){
            Navigator.of(context).push(SlideLeftRoute(enterWidget: Echec("^&"), oldWidget: Webview(_code)));
          }

        }else if(url.contains("FAILURE")){
          i = -1;
          Navigator.of(context).push(SlideLeftRoute(enterWidget: Echec("^&"), oldWidget: Webview(_code)));
        } else {//echec
          print("bonjour ");
          //i = -1;
          //        Navigator.of(context).push(SlideLeftRoute(enterWidget: Echec("^&"), oldWidget: Webview()));
        }
      }
    });
  }

  _getStatus(String id) async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString("username");
    _password = prefs.getString("password");
    print("$_username, $_password");
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    var headers = {
      "Accept": "application/json",
      "Authorization": "Basic $credentials",
      "content-type":"application/json"
    };
    var url = "$base_url/transaction/checkStatus/$id";
    print(url);
    http.Response response = await http.get(url, headers: headers);
    final int statusCode = response.statusCode;
    print('getStatus voici le statusCode $statusCode');
    print('getStatus voici le body ${response.body}');
    if(statusCode == 200){
      var responseJson = json.decode(response.body);
      if(responseJson['status'] == "CREATED"){
        if(temps == 0){
          i = -1;
          Navigator.of(context).push(SlideLeftRoute(enterWidget: Echec("^&"), oldWidget: Webview(_code)));
        }else if(temps > 0){
          temps--;
          _getStatus(id);
        }
      }else if(responseJson['status'] == "PROCESSED"){
        i = 1;
        Navigator.of(context).push(SlideLeftRoute(enterWidget: Confirma("recharge"), oldWidget: Webview(_code)));
        //navigatorKey.currentState.pushNamed("/confirma");
      }else if(responseJson['status'] == "REFUSED"){
        i = -1;
        Navigator.of(context).push(SlideLeftRoute(enterWidget: Echec("^&"), oldWidget: Webview(_code)));
      }else{
        i = -1;
        Navigator.of(context).push(SlideLeftRoute(enterWidget: Echec("^&"), oldWidget: Webview(_code)));
      }
    }else{
      i = -1;
      Navigator.of(context).push(SlideLeftRoute(enterWidget: Echec("^&"), oldWidget: Webview(_code)));
    }
  }

  @override
  void dispose() {
    _onUrlChanged.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //flutterWebviewPlugin.resize(rect);
    return WebviewScaffold(
            key: _scaffoldKey,
            url: payment_url,
            clearCache: true,
            appCacheEnabled: false,
            withLocalStorage: true,
            hidden: true,
            appBar: AppBar(
              title: Text("Sprint-pay paiement",style: TextStyle(
                color: couleur_titre,
                fontSize: taille_libelle_etape,
              ),),
              elevation: 0.0,
              backgroundColor: couleur_appbar,
              flexibleSpace: barreTop,
              leading: InkWell(
                  onTap: (){
                    setState(() {
                      Navigator.of(context).push(SlideLeftRoute(enterWidget: Encaisser2(_code), oldWidget: Webview(_code)));
                    });
                    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Pays()));
                  },
                  child: Icon(Icons.arrow_back_ios,)),
              iconTheme: new IconThemeData(color: couleur_fond_bouton),
            ),
            //supportMultipleWindows: true,
            initialChild:Center(
                child: CupertinoActivityIndicator(radius: 30,)
            )
      );
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      payment_url = prefs.getString("payment_url");
      _id = prefs.getString("id");
      print("mon url $payment_url et mon id $_id");
    });
  }
}
