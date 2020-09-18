import 'dart:convert';
import 'dart:io';
import 'package:services/community/lib/utils/services.dart';
import 'package:services/composants/components.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Inviter extends StatefulWidget {
  @override
  _InviterState createState() => new _InviterState();
}

class _InviterState extends State<Inviter> {

  List data, name;
  int roundId;
  List<String> invitations = new List<String>(), flagUris = new List();
  List<String> listtontine = new List<String>();
  bool isLoading =false;
  String _username, _password, urli, code3 = "+237", invitation, flagUri = "flags/cm.png", _token;
  var _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var controller;

  lecture() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      listtontine = prefs.getStringList(PARTICIPANTS_X);
    });
  }

  @override
  void initState(){
    super.initState();
    //this._reading();
    controller = new TextEditingController();
  }

  @override
  void dispose(){
    super.dispose();
    controller.disposer();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: couleur_appbar,
        flexibleSpace: barreTop,
        title: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Row(
            children: <Widget>[
              //Icon(Icons.arrow_back_ios),
              Text("Retour ",style: TextStyle(
                color: couleur_titre,
                fontSize: taille_champ+3,
              ),),
            ],
          ),

        ),

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: new Text('Inviter les membres',
                  style: TextStyle(
                      color: couleur_titre,
                      fontSize: taille_titre,
                      fontWeight: FontWeight.bold
                  ),),
              ),

              Padding(
                padding: EdgeInsets.only(top: 20, left: 40),
                child: RaisedButton(
                  onPressed: (){
                    setState(() {
                      //_reading();
                      print('nnnnnnnnnnnnnnnn$roundId');
                      var inviteTontine = new InviteTontine(
                          members: invitations,
                          tontineId: roundId
                      );
                      print(json.encode(inviteTontine));
                      checkConnection2(json.encode(inviteTontine));
                    });

                  },
                  color: Colors.green,
                  child: new Text('Inviter maintenant',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: taille_libelle_etape,
                          fontWeight: FontWeight.bold
                      )),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 20),
                child: new Text("Ajouter les emails d'abord avant d\'inviter!",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: taille_description_page,
                  ),),
              ),

              Padding(padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 10,
                      child: Container(
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                          color: Colors.transparent,
                          border: Border.all(
                              color: couleur_bordure,
                              width: 1.5
                          ),
                        ),
                        height: hauteur_champ,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[

                            new Expanded(
                              flex:7,
                              child: Form(
                                key: _formKey,
                                child: new TextFormField(
                                  controller: controller,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                    fontSize: taille_champ+3,
                                    color: couleur_libelle_champ,
                                  ),
                                  validator: (String value){
                                    if(value.isEmpty){
                                      return "Champ téléphone vide !";
                                    }else{
                                      invitation = value;
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration.collapsed(
                                    hintText: "Ajouter l'email en cliquant +",
                                    hintStyle: TextStyle(
                                      fontSize: taille_champ+3,
                                      color: couleur_libelle_champ,
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
                    Expanded(
                      flex: 2,
                      child: IconButton(
                          icon: Icon(Icons.add_circle, size: 35,color: couleur_fond_bouton,),
                          onPressed: (){
                            setState(() {
                              if(_formKey.currentState.validate()){
                                //_reading();
                                print("Voici le flagUri ******************** $flagUri");
                                print("voici les emails: $invitations");
                                invitations.add(invitation);
                                controller.clear();
                              } else
                                showInSnackBar("Veuillez entrer l\'adresse(s) email(s)", _scaffoldKey, 5);
                            });
                          }
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  height: MediaQuery.of(context).size.height/2,
                  child: ListView.builder(
                  itemCount: invitations==null?0:invitations.length,
                  itemBuilder: (BuildContext context, int i){
                    if(i == 0){
                      return Column(
                        children: <Widget>[
                          Divider(color: couleur_bordure,
                            height: .1,),
                          Row(
                            children: <Widget>[

                              SizedBox(
                                child: Text(invitations[i],
                                  style: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize: taille_champ+3,
                                  ),),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Divider(color: couleur_bordure,
                              height: .1,),
                          ),
                        ],
                      );
                    }else{
                      return Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[

                              SizedBox(
                                child: Text(invitations[i],
                                  style: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize: taille_champ+3,
                                  ),),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: Divider(color: couleur_bordure,
                              height: .1,),
                          ),
                        ],
                      );
                    }
                  },
                )),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: barreBottom,
    );
  }

  reading() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      roundId = int.parse(prefs.getString(ID_TONTINE_X));
      _token = prefs.getString(TOKEN);
      invitations = prefs.getStringList(INVITATIONS_TONTINE_X);
    });
  }


  void checkConnection2(var body) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        isLoading =true;
        contribKitty2(body);
      });

    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        isLoading =true;
        contribKitty2(body);
      });
    } else {
      showInSnackBar("Service indisponible!", _scaffoldKey, 5);
    }
  }


  Future<String> contribKitty2(var body) async {
    urli = "$BaseUrlTontine/memberships/addInvitations";
    print("Mon token :$_token");
    print(roundId);
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString("username");
    _password = prefs.getString("password");
    print("$_username, $_password");
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse("$urli"));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json');
    request.headers.set("Authorization", "Basic $credentials");
    request.add(utf8.encode(body));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print("statusCode ${response.statusCode}");
    print("body $reply");

    if(response.statusCode==200){
      showInSnackBar("Votre invitation à été envoyée avec succes", _scaffoldKey, 5);
    }else if(response.statusCode==500){
      showInSnackBar("Service indisponible", _scaffoldKey, 5);
    }

  }
}