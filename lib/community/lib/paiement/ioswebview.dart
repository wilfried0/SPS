import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/material.dart';
import 'package:services/community/lib/paiement/participation2.dart';
import 'package:services/community/lib/utils/components.dart';
import 'package:services/composants/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../confirma.dart';
import '../echec.dart';


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
    print("Current url ios: $url");
    if(url == "https://cargosprint.com/" || url == "https://www.sprintpay.com" || url == "http://www.sprintpay.com"){
      this._getStatus(_id);
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
    var url = "$checkPayUrl/payment/status/$id";
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
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Echec(_code)));
        }else if(temps > 0){
          temps--;
          _getStatus(id);
        }
      }else if(_status == "PROCESSED"){
        _status = "PROCESSED";
        flutterWebviewPlugin.dispose();
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Confirma(_code)));
      }else if(_status == "REFUSED"){
        _status = "REFUSED";
        flutterWebviewPlugin.dispose();
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Echec(_code)));
      }
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Echec(_code)));
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
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Paiement2(_code)));
                  }
              ),/*InkWell(
                  onTap: (){
                    setState(() {
                      Navigator.of(context).push(SlideLeftRoute(enterWidget: Encaisser2(_code), oldWidget: IosWebview(_code)));
                    });
                    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Pays()));
                  },
                  child: Icon(Icons.arrow_back_ios,)),*/
              //iconTheme: new IconThemeData(color: couleur_fond_bouton),
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