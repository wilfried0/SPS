import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/material.dart';
import 'package:services/composants/components.dart';
import 'package:services/composants/transition.dart';
import 'package:services/paiement/encaisser2.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String url, uri, _status,transactionId;
  final navigatorKey = GlobalKey<NavigatorState>();
  int temps = 600;
  String _username, _password, payment_url, _id;
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
  double _progress = 0;
  InAppWebViewController webView;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.read();
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
    print("statusCode ${response.statusCode}");
    print("body $reply");
    if(response.statusCode == 200){
      var responseJson = json.decode(reply);
      _status = responseJson['status'];
      if(_status == "CREATED"){
        if(temps <= 0){
          Navigator.of(context).push(SlideLeftRoute(enterWidget: Echec('$_code^&'), oldWidget: Webview(_code)));
        }else if(temps > 0){
          temps--;
          _getStatus(id);
        }
      }else if(_status == "PROCESSED"){
        _status = "PROCESSED";
        flutterWebviewPlugin.dispose();
        Navigator.of(context).push(SlideLeftRoute(enterWidget: Confirma("recharge"), oldWidget: Webview(_code)));
      }else if(_status == "REFUSED"){
        _status = "REFUSED";
        flutterWebviewPlugin.dispose();
        Navigator.of(context).push(SlideLeftRoute(enterWidget: Echec("^&"), oldWidget: Webview(_code)));
      }
    }else{
      Navigator.of(context).push(SlideLeftRoute(enterWidget: Echec("^&"), oldWidget: Webview(_code)));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      /*url: payment_url,
      withZoom: true,
      withJavascript: true,
      supportMultipleWindows: true,
      clearCache: true,*/
      body: Container(
        child: Column(
          children: <Widget>[
            (_progress != 1.0)?
                LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: orange_F,
                  valueColor: AlwaysStoppedAnimation<Color>(bleu_F),
                ):null,
            Expanded(
                child: Container(
                  child: InAppWebView(
                    initialUrl: payment_url,
                    initialHeaders: {},
                    initialOptions: InAppWebViewWidgetOptions(
                      inAppWebViewOptions: InAppWebViewOptions(
                        cacheEnabled: true,
                        clearCache: true,
                        debuggingEnabled: true,
                        javaScriptCanOpenWindowsAutomatically: false,
                        javaScriptEnabled: true,
                      ),
                      iosInAppWebViewOptions: IosInAppWebViewOptions(
                      ),
                      androidInAppWebViewOptions: AndroidInAppWebViewOptions(
                        supportZoom: true,
                        allowContentAccess: true,
                        allowFileAccess: true,
                        allowFileAccessFromFileURLs: true,
                        clearSessionCache: true,
                      ),
                    ),
                    onWebViewCreated: (InAppWebViewController controller) {
                      if(url == "https://cargosprint.com/" || url == "http://www.sprintpay.com"){
                        //controller.loadUrl(url: null);
                        controller.stopLoading();
                      }else
                      controller.loadUrl(url: payment_url);
                    },
                    onLoadStart: (InAppWebViewController controller, String url) {
                      print("URL actuelle: $url");
                      if(url == "https://cargosprint.com/" || url == "http://www.sprintpay.com"){
                        controller.stopLoading();
                        this._getStatus(_id);
                      }
                    },
                    onProgressChanged: (InAppWebViewController controller, int progress){
                      setState(() {
                        this._progress = progress / 100;
                      });
                    },
                  ),
                )
            ),
          ].where((Object o) => o != null).toList()
        )
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
