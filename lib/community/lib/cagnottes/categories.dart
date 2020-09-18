import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:services/community/lib/utils/components.dart';
import 'package:services/composants/components.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'cagnotte2.dart';
import 'package:http/http.dart' as http;

class Categories extends StatefulWidget {
  Categories();

  @override
  _CategoriesState createState() => new _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  _CategoriesState();

  List data;

  var _categories = [];
  List unfilterData;
  String _url, url, _categorie;
  int taille;
  var _data = [];


  @override
  void initState(){
    super.initState();
    _url = '$cagnotte_url/categorie/allType';
    url = '$cagnotte_url/kitty/type';
    this.loadMap();
  }

  Future<bool>loadMap() async {
    var jsonText = await rootBundle.loadString('communityimages/categories.json');
    setState(() => this._categories = json.decode(jsonText));
    print(_categories.toString());
    return true;
  }

  Future<String> getListTypes() async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.getUrl(Uri.parse("$cagnotte_url/categorie/allType"));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print("statusCode ${response.statusCode}");
    print("body $reply");
    if(response.statusCode == 200){
      List responseJson = json.decode(reply);
      _categories = [];
      setState(() {
        for(int i=0; i<responseJson.length; i++)
          _categories.add(responseJson[i]['content']);
      });
    }
    return null;
  }

  Future<String> getJsonData() async {
    var response = await http.get(Uri.encodeFull(_url), headers: {"Accept": "application/json"},);
    if (response.statusCode == 200) {
      setState(() {
        var convertDataToJson = json.decode(utf8.decode(response.bodyBytes));
        _categories = convertDataToJson['content'];
      });
    }
    return "success";
  }

  Future<String> getJsonNbreData1() async {
    var response = await http.get(Uri.encodeFull('$url/1'), headers: {"Accept": "application/json"},);
      if (response.statusCode == 200) {
        setState(() {
          var convertDataToJson = json.decode(utf8.decode(response.bodyBytes));
          _data.add(convertDataToJson['numberOfElements']);
          print(convertDataToJson);
          print(convertDataToJson['numberOfElements']);
        });
      }
    return "success";
  }
  Future<String> getJsonNbreData2() async {
    var response = await http.get(Uri.encodeFull('$url/2'), headers: {"Accept": "application/json"},);
    if (response.statusCode == 200) {
      setState(() {
        var convertDataToJson = json.decode(utf8.decode(response.bodyBytes));
        _data.add(convertDataToJson['numberOfElements']);
      });
    }
    return "success";
  }

  Future<String> getJsonNbreData3() async {
    var response = await http.get(Uri.encodeFull('$url/3'), headers: {"Accept": "application/json"},);
    if (response.statusCode == 200) {
      setState(() {
        var convertDataToJson = json.decode(utf8.decode(response.bodyBytes));
        _data.add(convertDataToJson['numberOfElements']);
      });
    }
    return "success";
  }

  searchData(str){
    var strExist = str.length>0?true:false;
    if(strExist){
      var filterData = [];
      for(var i=0; i<unfilterData.length; i++){
        String name = unfilterData[i]['wording'].toUpperCase();
        if(name.contains(str.toUpperCase())){
          filterData.add(unfilterData[i]);
        }
      }
      setState(() {
        this._categories = filterData;
      });
    }else{
      setState(() {
        this._categories = this.unfilterData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final marge = (14*MediaQuery.of(context).size.width)/414;
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Catégorie de la cagnotte',
          style: TextStyle(
            color: couleur_titre,
            fontSize: taille_libelle_etape,
          ),),
        elevation: 0.0,
        backgroundColor: couleur_appbar,
        flexibleSpace: barreTop,
        leading: IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: couleur_fond_bouton,),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte2()));
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0, top:15.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: new Text('Sélectionnez une catégorie\npour votre cagnotte',
                  style: TextStyle(
                      color: couleur_titre,
                      fontSize: taille_titre,
                      fontWeight: FontWeight.bold
                  )),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 20.0),
            child: Container(
              margin: EdgeInsets.only(top: 0.0),
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
                  Expanded(
                    flex:1,
                    child: Padding(
                      padding: const EdgeInsets.only(left:15.0),
                      child: new Icon(Icons.search,
                        size: 20.0,
                        color: couleur_bordure,),
                    ),
                  ),
                  new Expanded(
                    flex:10,
                    child: Padding(
                      padding: EdgeInsets.only(left:marge),
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
                          this.searchData(str);
                        },
                        /*textAlign: TextAlign.end,*/
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child:_categories==null?Theme(
            data: Theme.of(context).copyWith(accentColor: orange_F),
            child: Center(
                child: Column(
                  children: <Widget>[
                    new CupertinoActivityIndicator(radius: 20,),
                    Text('Chargement en cours ...', style: TextStyle(
                        fontSize: taille_champ,
                        color: couleur_fond_bouton
                    ),)
                  ],
                )
            ),
          ):
          ListView.builder(
            itemCount: _categories==null?0:_categories.length,
            itemBuilder: (BuildContext context, int i){
              var name = _categories[i]['wording'];
              var idType = _categories[i]['idType'];
              if(i == 0){
                return GestureDetector(
                  onTap: (){
                    this._categorie = name.toString()+'^'+"$idType";
                    this._save();
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte2()));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Divider(color: couleur_bordure,
                          height: .9,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        child: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text("$name",style: TextStyle(
                            color: Colors.black,
                            fontSize: taille_champ+3
                          )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Divider(color: couleur_bordure,
                          height: .9,),
                      ),
                    ],
                  ),
                );
              }else
              return GestureDetector(
                onTap: (){
                  this._categorie = name.toString()+'^'+"$idType";
                  this._save();
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte2()));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text("$name",style: TextStyle(
                            color: Colors.black,
                            fontSize: taille_champ+3
                        )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Divider(color: couleur_bordure,
                        height: .9,),
                    ),
                  ],
                ),
              );
            },
          ))
        ],
      ),
      bottomNavigationBar: barreBottom,
    );
  }

  void _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(CATEGORIE, _categorie);
  }
}