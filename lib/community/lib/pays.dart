import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:services/auth/connexion.dart';
import 'package:services/composants/components.dart';
import 'transition.dart';

class Pays extends StatefulWidget {
  @override
  _PaysState createState() => new _PaysState();
}

class _PaysState extends State<Pays> {

  List data;
  List unfilterData;
  String _code;


  @override
  void initState(){
    _code = "";
    this.loadMap();
    super.initState();
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
    this.unfilterData = this.data;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final marge = (14*MediaQuery.of(context).size.width)/414;
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: couleur_appbar,
        flexibleSpace: barreTop,

        leading: InkWell(
            onTap: (){
              setState(() {
               exit(0);
              });
              //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Pays()));
            },
            child: Icon(Icons.arrow_back_ios,)),
        iconTheme: new IconThemeData(color: bleu_F),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0, top:15.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: new Text('Quel est votre pays de résidence ?',
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
                  var dial_code = data[i]['dial_code'];
                  var code = data[i]['code'];
                  var code3 = data[i]['code3'];
                  var flagUri = 'flags/${data[i]['code'].toLowerCase()}.png';
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
                          _code = '$dial_code $code $name $code3';
                          Navigator.of(context).push(SlideLeftRoute(enterWidget: Connexion(), oldWidget: Pays()));
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
                        _code = '$dial_code $code $name $code3';
                        Navigator.of(context).push(SlideLeftRoute(enterWidget: Connexion(), oldWidget: Pays()));
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
    );
  }
}