import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/material.dart';
import 'package:services/composants/components.dart';
import 'package:services/composants/transition.dart';
import 'package:services/paiement/encaisser2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'confirma.dart';
import 'echec.dart';

class IosWebview extends StatefulWidget {
  IosWebview(this._code);
  String _code;
  @override
  _WebviewState createState() => _WebviewState(_code);
}

class _WebviewState extends State<IosWebview> {
  _WebviewState(this._code);
  String _code;


  String url, uri, _status,transactionId;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final navigatorKey = GlobalKey<NavigatorState>();
  int temps = 200;
  String _username, _password, payment_url, _id;
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.read();
   flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged webViewStateChanged){
    url = webViewStateChanged.url;
    print("Current urls: $url");
    if(url == "https://cargosprint.com/" || url == "https://sprint-pay.com/"){//https://sprint-pay.com/
      if(_status == "PROCESSED" || _status == "REFUSED"){

      } else{
        flutterWebviewPlugin.dispose();
        this._getStatus(_id);
      }
    }else{
      print("déjà $_status");
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
    var url = "$base_url/transaction/checkStatus/$id";
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json');
    request.headers.set('Authorization', 'Basic $credentials');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print("statusCodes ${response.statusCode}");
    print("body $reply");
    print("temps vaut: $temps");
    print("status vaut: $_status");
    if(response.statusCode == 200){
      var responseJson = json.decode(reply);
      setState(() {
        _status = responseJson['status'];
      });
      if(_status == "CREATED"){
        if(temps <= 0){
          flutterWebviewPlugin.dispose();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Echec("^&")));
          //Navigator.of(context).push(SlideLeftRoute(enterWidget: Echec("^&"), oldWidget: IosWebview(_code)));
        }else if(temps > 0){
          temps--;
          _getStatus(id);
        }
      }else if(_status == "PROCESSED"){
        temps = -1;
        _status = "PROCESSED";
        flutterWebviewPlugin.dispose();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Confirma("recharge")));
        //Navigator.of(context).push(SlideLeftRoute(enterWidget: Confirma("recharge"), oldWidget: IosWebview(_code)));
      }else if(_status == "REFUSED"){
        temps = -1;
        _status = "REFUSED";
        flutterWebviewPlugin.dispose();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Echec("^&")));
        //Navigator.of(context).pushReplacement(SlideLeftRoute(enterWidget: Echec("^&"), oldWidget: IosWebview(_code)));
      }
    }else{
      temps = -1;
      flutterWebviewPlugin.dispose();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Echec("^&")));
      //Navigator.of(context).push(SlideLeftRoute(enterWidget: Echec("^&"), oldWidget: IosWebview(_code)));
    }
  }

  @override
  void dispose() {
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              leading: IconButton(
                  onPressed: (){
                    Navigator.of(context).push(SlideLeftRoute(enterWidget: Encaisser2(_code), oldWidget: IosWebview(_code)));
                  },
                  icon: Icon(Icons.arrow_back_ios,color: couleur_fond_bouton,)
              ),
            ),
            //supportMultipleWindows: true,
            initialChild:
            Center(
                child:CupertinoActivityIndicator(radius: 30,)
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