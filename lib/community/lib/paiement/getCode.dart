import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/community/lib/confirm.dart';
import 'package:services/community/lib/utils/components.dart';
import 'package:services/community/lib/utils/services.dart';
import 'package:services/composants/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../echec.dart';


class GetCode extends StatefulWidget {

  GetCode({this.id, this.scaffold});
  String id;
  GlobalKey<ScaffoldState> scaffold = new GlobalKey<ScaffoldState>();

  @override
  _GetCodeState createState() => _GetCodeState();
}

class _GetCodeState extends State<GetCode> {
  var _formKey = GlobalKey<FormState>(), codeController;
  String code, _token, _url, _username;
  bool isLoading = false;
  int temps = 600;


  @override
  void initState() {
    // TODO: implement initState
    this.lire();
    super.initState();
    _url = "$cagnotte_url/cashin/walletpayment/confirm";
    codeController = new TextEditingController();
  }

  lire() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString(TOKEN);
      _username = prefs.getString("username");
    });
  }

  Future<String> getStatus(String id) async {
    var url = "$cagnotte_url/check/status/$id";
    print(url);
    print("Mon token :$_token");
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json'); //"Authorization": "Bearer $_token"
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
          sav();
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Echec('part')));
        }else if(temps > 0){
          temps--;
          getStatus(id);
        }
      }else if(responseJson['status'] == "PROCESSED"){
        setState(() {
          isLoading = false;
        });
        sav();
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Confirm('part')));
      }else if(responseJson['status'] == "REFUSED"){
        setState(() {
          isLoading = false;
        });
        sav();
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Echec('part')));
      }else{
        setState(() {
          isLoading = false;
        });
        showInSnackBar("Service indisponible!", widget.scaffold, 5);
      }
    }else{
      setState(() {
        isLoading = false;
      });
      showInSnackBar("Service indisponible", widget.scaffold, 5);
    }
    return null;
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    codeController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('Code de validation', style: TextStyle(
                  color: couleur_fond_bouton,
                  fontSize: taille_champ+3
              ),textAlign: TextAlign.center,),
              Container(
                color: couleur_fond_bouton,
                height: 2,
                width: MediaQuery.of(context).size.width,
              ),
            ],
          ),
          content: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                    color: Colors.transparent,
                    border: Border.all(
                        width: bordure,
                        color: couleur_libelle_champ
                    ),
                  ),
                  height: hauteur_champ,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex:2,
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new Icon(Icons.lock, color: couleur_libelle_champ,)
                        ),
                      ),
                      new Expanded(
                        flex:12,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: new TextFormField(
                            keyboardType: TextInputType.text,
                            enabled: true,
                            style: TextStyle(
                              fontSize: taille_libelle_champ+3,
                              color: couleur_libelle_champ,
                            ),
                            validator: (String value){
                              if(value.isEmpty){
                                return null;
                              }else{
                                code = value;
                                return null;
                              }
                            },
                            decoration: InputDecoration.collapsed(
                              hintText: 'Code',
                              hintStyle: TextStyle(color: couleur_libelle_champ,
                                  fontSize: taille_libelle_champ+3),
                              //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            ),
                            /*textAlign: TextAlign.end,*/
                          ),
                        ),
                        //),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20),
                  child: new GestureDetector(
                    onTap: () {
                      setState(() {
                        if(_formKey.currentState.validate()){
                          isLoading = true;
                          var walletConf = new walletConfirm(
                            confirmCode: int.parse(code),
                            id: int.parse(widget.id),
                            username: _username
                          );
                          print(json.encode(walletConf));
                          confirmWallet(json.encode(walletConf));
                        }
                      });
                    },
                    child: new Container(
                      height: hauteur_champ,
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: new BoxDecoration(
                        color: couleur_fond_bouton,
                        border: new Border.all(
                          color: Colors.transparent,
                          width: 0.0,
                        ),
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      child: new Center(
                          child:isLoading==false? new Text('Valider', style: new TextStyle(color: couleur_text_bouton),):CupertinoActivityIndicator()),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void sav() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(CONFIRMATION, "participation");
  }

  Future<String> confirmWallet(var body) async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString("username");
    String _password = prefs.getString("password");
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);

    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse("$_url"));
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
      getStatus(responseJson['id'].toString());
    }else {
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
      showInSnackBar("Echec de l'opération!", widget.scaffold, 5);
    }
    return null;
  }
}