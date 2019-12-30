import 'dart:collection';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:services/auth/inscrip.dart';
import 'package:services/composants/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'transfert1.dart';
import 'transfert3.dart';

// ignore: must_be_immutable
class Transfert22 extends StatefulWidget {
  Transfert22(this._code);
  String _code;
  @override
  _Transfert22State createState() => new _Transfert22State(_code);
}


class _Transfert22State extends State<Transfert22> {
  double marge;

  _Transfert22State(this._code);
  String _code;
  String _user;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final navigatorKey = GlobalKey<NavigatorState>();
  String url, _username, _password, user;
  List data, liste;
  List unfilterData, unfilterData2;
  String _name, _sername;
  var _formKey = GlobalKey<FormState>();
  bool displayButton = true, isLoading=false;

  @override
  void initState(){
    this.getListUser();
    super.initState();
  }

  searchData(str){
    var strExist = str.length>0?true:false;
    if(strExist){
      var filterData = [];
      for(var i=0; i<unfilterData.length; i++){
        String name = unfilterData[i]['name'].toUpperCase();
        String username = unfilterData[i]['username'].toUpperCase();
        if(username.contains(str.toUpperCase()) || name.contains(str.toUpperCase())){
          filterData.add(unfilterData[i]);
        }
      }
      setState(() {
        this.data = filterData;
      });
    }else{
      setState(() {
        this.data = this.unfilterData;
      });
    }
  }

  searchData2(str){
    var strExist = str.length>0?true:false;
    if(strExist){
      var filterData = [];
      for(var i=0; i<unfilterData2.length; i++){
        String name = unfilterData2[i]['name'].toUpperCase();
        String username = unfilterData2[i]['username'].toUpperCase();
        if(username.contains(str.toUpperCase()) || name.contains(str.toUpperCase())){
          filterData.add(unfilterData2[i]);
        }
      }
      setState(() {
        this.data = filterData;
      });
    }else{
      setState(() {
        this.data = this.unfilterData;
      });
    }
  }

  void checkConnection(var body) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        isLoading = true;
        this.findUser(body);
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        isLoading = true;
        this.findUser(body);
      });
    } else {
      _ackAlert(context);
    }
  }

  Future<void> addUser(var body) async {
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
    url = '$baseUrl/add';
    print(url);
    return await http.post("$url", body: body, headers: headers, encoding: Encoding.getByName("utf-8")).then((http.Response response) {
      final int statusCode = response.statusCode;
      print('voici le statusCode $statusCode');
      print('voici le body ${response.body}');
      if (statusCode < 200 || json == null) {
        setState(() {
          isLoading = false;
        });
        throw new Exception("Error while fetching data");
      }else if(statusCode == 200){
        var responseJson = json.decode(response.body);
        print(responseJson['result']);
        setState(() {
          isLoading = false;
        });
        if(responseJson['result'] == "Ok"){
          this.getListUser();
          showInSnackBar("Utilisateur ajouté avec succès", _scaffoldKey);
        }else{
          this.getListUser();
          showInSnackBar("Erreur lors de l'ajout de l'utilisateur", _scaffoldKey);
        }
      }else {
        setState(() {
          isLoading = false;
        });
        showInSnackBar("Echec de l'opération!", _scaffoldKey);
      }
      return response.body;
    });
  }

  Future<String> findUser(String str) async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString("username");
    _password = prefs.getString("password");
    print("$_username, $_password");
    String _url = "$baseUrl/all";
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    var headers = {
      "Accept": "application/json",
      "Authorization": "Basic $credentials",
      "content-type":"application/json"
    };
    print("mon url $_url");
    var response = await http.get(Uri.encodeFull(_url), headers: headers,);
    if(response.statusCode == 200){
      print(response.body);
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      this.data = responseJson;
      setState(() {
        this.unfilterData2 = this.data;
        searchData2(str);
      });
    }
  }


  Future<void> getListUser() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString("username");
    _password = prefs.getString("password");
    print("$_username, $_password");
    String _url = "$baseUrl";
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    var headers = {
      "Accept": "application/json",
      "Authorization": "Basic $credentials",
      "content-type":"application/json"
    };
    print("mon url $_url");
    var response = await http.get(Uri.encodeFull(_url), headers: headers,);
    if(response.statusCode == 200){
      print(response.body);
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      setState(() => this.data = responseJson);
      this.unfilterData = this.data;
    }
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

  Future<void> ackAlert(BuildContext context, String _user) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(''),
          content:user == null?Text("Le bénéficiaire du transfert sera $_user") :Text('Ajouter $_user à votre liste de contact?'),
          actions: <Widget>[
            user==null?Container():FlatButton(
              child: Text('ENREGISTRER', style: TextStyle(
                  fontSize: taille_champ+3
              ),),
              onPressed: () {
                setState(() {
                  isLoading = true;
                  var _contact = new contact(
                    username: _user
                  );
                  Navigator.of(context).pop();
                  this.addUser(json.encode(_contact));
                });
              },
            ),
            FlatButton(
              child: Text('SELECTIONNER', style: TextStyle(
                  fontSize: taille_champ+3
              ),),
              onPressed: () {
                _save();
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfert3(_code)));
              },
            ),
            FlatButton(
              child: Text('ANNULER', style: TextStyle(
                fontSize: taille_champ+3
              ),),
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
  Widget build(BuildContext context) {
    marge = (5*MediaQuery.of(context).size.width)/414;
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: couleur_appbar,
        flexibleSpace: barreTop,

        leading: InkWell(
            onTap: (){
              setState(() {
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfert1(_code)));
                //Navigator.of(context).push(SlideLeftRoute(enterWidget: Connexion(_code), oldWidget: Inscription(_code)));
              });
            },
            child: Icon(Icons.arrow_back_ios,)),
        iconTheme: new IconThemeData(color: couleur_fond_bouton),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: hauteur_logo,
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 40.0, right: 40.0),
              child: new Image.asset('images/logo.png'),
            ),
          ),

          Padding(padding: EdgeInsets.only(top: marge_apres_logo),),

          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: new Text("Ajouter le bénéficiaire",
                  style: TextStyle(
                      color: couleur_titre,
                      fontSize: taille_titre,
                      fontWeight: FontWeight.bold
                  )),
            ),
          ),

          Padding(padding: EdgeInsets.only(top: marge_apres_titre),),
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: new Text("Faite une recherche sur le nom, prénom ou le numéro de téléphone.",
                  style: TextStyle(
                      color: couleur_titre,
                      fontSize: taille_description_champ+3,
                      fontWeight: FontWeight.normal
                  ), textAlign: TextAlign.justify,),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Container(
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                color: couleur_champ,
                border: Border.all(
                    width: .1,
                    color: couleur_champ
                ),
              ),
              height: 50.0,
              child: Row(
                children: <Widget>[
                  new Expanded(
                    flex: 6,
                    child: Padding(
                      padding: EdgeInsets.only(left:20),
                      child: new TextField(
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: 14,
                          color: couleur_libelle_champ,
                        ),
                        decoration: InputDecoration.collapsed(
                          hintText: 'Rechercher',
                          hintStyle: TextStyle(color: couleur_libelle_champ,),
                          //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        ),
                        onChanged: (String str){
                          user = str;
                          this.searchData(str);
                        },
                        /*textAlign: TextAlign.end,*/
                      ),
                    ),
                  ),
                  Expanded(
                    flex:1,
                    child: GestureDetector(
                      onTap: (){
                        if(user.isEmpty){
                          showInSnackBar("Veuillez entrer un mot clef!", _scaffoldKey);
                        }else
                        this.findUser(user);
                      },
                      child: Container(
                        height: 50,
                        decoration: new BoxDecoration(
                          color: couleur_fond_bouton,
                          borderRadius: new BorderRadius.only(
                            bottomLeft: Radius.circular(0.0),
                            bottomRight: Radius.circular(10.0),
                            topLeft: Radius.circular(0.0),
                            topRight: Radius.circular(10.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left:15.0, right: 15),
                          child:isLoading==false? new Icon(Icons.search,
                            size: 20.0,
                            color: Colors.white,):CupertinoActivityIndicator(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 20, top: 20),
              child: ListView.builder(
                  itemCount: data==null?0:data.length,
                  itemBuilder: (BuildContext context, int i){
                    var name = data[i]['name'];
                    var username = data[i]['username'];
                    return InkWell(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: Divider(color: couleur_bordure,
                              height: .1,),
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0, top: 10.0, bottom: 10.0),
                                child: SizedBox(
                                  height: 30,
                                  width: 40,
                                  child: Image.asset("images/ellipse1.png"),
                                ),
                              ),
                              SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(name, //vérifier les débordement
                                      style: TextStyle(
                                          color: couleur_libelle_champ,
                                          fontSize: taille_champ,
                                          fontFamily: police_titre,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    Text(username,
                                      style: TextStyle(
                                          color: couleur_libelle_etape,
                                          fontSize: taille_champ,
                                          fontFamily: police_titre
                                      ),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: (){
                        setState(() {
                          _sername = username.toString();
                          _name = name.toString();
                          this.ackAlert(context, username);
                        });
                      },
                    );
                  }
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: barreBottom,
    );
  }

  void _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("to", "$_sername");
    prefs.setString("nomd", "$_name");
    print("$_sername $_name");
  }

  String getNoms(String nom, String prenom){
    if(nom == null && prenom == null){
      return "";
    }else if(nom == null && prenom != null){
      return prenom;
    }else if(nom != null && prenom != null){
      return "$prenom $nom";
    }else if(nom != null && prenom == null){
      return nom;
    }
    return null;
  }

}
void showInSnackBar(String value, GlobalKey<ScaffoldState> _scaffoldKey) {
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


class FindUser{
  final String keyword;
  FindUser({this.keyword});
  FindUser.fromJson(Map<String, dynamic> json)
      : keyword = json['keyword'];
  Map<String, dynamic> toJson() =>
      {
        "keyword": keyword,
      };
}