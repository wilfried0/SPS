import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:services/auth/profile.dart';
import 'package:services/composants/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'transfert1.dart';

class Payst extends StatefulWidget {
  @override
  _PaystState createState() => new _PaystState();
}

class _PaystState extends State<Payst> {

  List data;
  List unfilterData;
  String _code, route, deviseLocale, nomPays, codeIso3, codeIso2, from, dial;
  final navigatorKey = GlobalKey<NavigatorState>();


  @override
  void initState(){
    _code = "";
    super.initState();
    this._read();
  }

  void _reg() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('payst', "$codeIso3");
    prefs.setString('codeIso2', "$codeIso2");
    prefs.setString('nomPays', "$nomPays");
    prefs.setString('from', "$from");
    prefs.setString('DIAL', "$dial");
  }

  searchData(str){
    var strExist = str.length>0?true:false;
    if(strExist){
      var filterData = [];
      for(var i=0; i<unfilterData.length; i++){
        String name = unfilterData[i]['name'].toUpperCase();
        if(name.contains(str.toUpperCase())){
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

  Future<bool>loadMap() async {
    var jsonText = await rootBundle.loadString('images/map.json');
    setState(() => this.data = json.decode(jsonText));
    if(deviseLocale != "EUR"){
      var filterData = [];
      for(var i=0; i<data.length; i++){
        String continent = data[i]['continent'];
        if(continent == "AFRIQUE"){
          filterData.add(data[i]);
        }
      }
      setState(() {
        this.data = filterData;
      });
    }
    this.unfilterData = this.data;
    return true;
  }

  String url = "$base_url/user/Auth/signout";

  @override
  Widget build(BuildContext context) {
    final marge = (14*MediaQuery.of(context).size.width)/414;
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white, accentColor: Color(0xFF2A2A42), fontFamily: 'Poppins'),
      routes: <String, WidgetBuilder>{
        "/transfert": (BuildContext context) =>new Transfert1(_code),
        "/profil": (BuildContext context) =>new Profile(_code),
      },
      home: Scaffold(
        appBar: new AppBar(
          elevation: 0.0,
          backgroundColor: couleur_appbar,
          flexibleSpace: barreTop,

          leading: InkWell(
              onTap: (){
                setState(() {
                  navigatorKey.currentState.pushNamed("/profil");
                });
              },
              child: Icon(Icons.arrow_back_ios,)),
          iconTheme: new IconThemeData(color: bleu_F),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: new Text('Vous envoyez vers quel pays ?',
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
            Expanded(child:
            ListView.builder(
              itemCount: data==null?0:data.length,
              itemBuilder: (BuildContext context, int i){
                var name = data[i]['name'];
                var dialCode = data[i]['dial_code'];
                var code = data[i]['code'];
                var code3 = data[i]['code3'];
                var flagUri = 'flags/${data[i]['code'].toLowerCase()}.png';
                var currency = data[i]['currency'];
                if(i == 0){
                  return InkWell(
                    child:
                    Column(
                      children: <Widget>[
                        Divider(color: couleur_bordure,
                          height: .1,),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                              child: SizedBox(
                                height: 30,
                                width: 40,
                                child: Image.asset(flagUri),
                              ),
                            ),
                            SizedBox(
                              child: Text(name,
                                style: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize: taille_champ,
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
                    ),
                    onTap: (){
                      setState(() {
                        _code = '$dialCode^$code^$name^$code3^$currency';
                        codeIso3 = code3.toString();
                        nomPays = name.toString();
                        codeIso2 = code.toString();
                        dial = dialCode.toString();
                        from = _code.split('^')[4];
                        print("Zone pays d'envoi $from");
                        _reg();
                        navigatorKey.currentState.pushNamed("/transfert");
                      });
                      //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Connexion(_code)));
                    },
                  );
                }else{
                  return InkWell(
                    child:
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                              child: SizedBox(
                                height: 30,
                                width: 40,
                                child: Image.asset(flagUri),
                              ),
                            ),
                            SizedBox(
                              child: Text(name.toString().length>35?name.toString().substring(0, 35)+'...':name.toString(),
                                style: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize: taille_champ,
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
                    ),
                    onTap: (){
                      setState(() {
                        _code = '$dialCode^$code^$name^$code3^$currency';
                        codeIso3 = code3.toString();
                        nomPays = name.toString();
                        codeIso2 = code.toString();
                        dial = dialCode.toString();
                        from = _code.split('^')[4];
                        print("Zone pays d'envoi $from");
                        _reg();
                        navigatorKey.currentState.pushNamed("/transfert");
                        //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Transfert1(_code)));
                        //Navigator.of(context).push(SlideLeftRoute(enterWidget: Connexion(_code), oldWidget: Pays()));
                      });
                      //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Connexion(_code)));
                    },
                  );
                }
              },
            ))
          ],
        ),
        bottomNavigationBar: barreBottom,
      ),
    );
  }


  _read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      deviseLocale = prefs.getString("deviseLocale");
    });
    this.loadMap();
  }
}