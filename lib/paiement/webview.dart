import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
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
  String url, uri, _status,transactionId;
  final navigatorKey = GlobalKey<NavigatorState>();
  int temps = 200;
  String _username, _password, payment_url, _id;
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
  double _progress = 0;
  InAppWebViewController webView;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.read();
   /* _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        print("mon url $payment_url et mon id $_id");
        print("Current URL: $url");
        if(url == "https://cargosprint.com/" || url == "http://www.sprintpay.com"){
          print("la valeur de i $i et filet 1");
          if(i == 0){
            this._getStatus(_id);
          }else if(i == 1){
            Navigator.of(context).push(SlideLeftRoute(enterWidget: Confirma("recharge"), oldWidget: Webview(_code)));
          }else if(i == -1){
            Navigator.of(context).push(SlideLeftRoute(enterWidget: Echec("^&"), oldWidget: Webview(_code)));
          }
        }else if(url.split("/").last == "card"){
          i = -1;
          Navigator.of(context).push(SlideLeftRoute(enterWidget: Echec("^&"), oldWidget: Webview(_code)));
        }
      }
    });
   flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged webViewStateChanged){
    url = webViewStateChanged.url;
    print("Current url: $url");
    if(url == "https://cargosprint.com/" || url == "http://www.sprintpay.com"){
      this._getStatus(_id);
    }else if(url.split("/").last == "notification"){
      print("status: $_status");
    }else{
      print("déjà $_status");
    }
   });*/
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
    http.Response response = await http.get(url, headers: headers);
    final int statusCode = response.statusCode;
    print('getStatus voici le statusCode $statusCode');
    print('getStatus voici le body ${response.body}');
    print("le status: $_status");
    if(statusCode == 200){
      var responseJson = json.decode(response.body);
      _status = responseJson['status'];
      if(_status == "CREATED"){
        if(temps <= 0){
          Navigator.of(context).push(SlideLeftRoute(enterWidget: Echec("^&"), oldWidget: Webview(_code)));
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
    //flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //flutterWebviewPlugin.resize(rect);
    /*return WebviewScaffold(
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
      );*/
    //final Completer<WebViewController> _controller = Completer<WebViewController>();
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
                        javaScriptCanOpenWindowsAutomatically: true,
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
                      controller.loadUrl(url: payment_url);
                    },
                    onLoadStart: (InAppWebViewController controller, String url) {
                      print("URL actuelle: $url");
                      if(url == "https://cargosprint.com/" || url == "http://www.sprintpay.com"){
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
            )
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
