import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/composants/components.dart';
import 'cagnotte.dart';
import 'pays.dart';
import 'utils/components.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Transaction extends StatefulWidget {
  Transaction(this._code);
  final String _code;

  @override
  _TransactionState createState() => new _TransactionState(_code);
}

class _TransactionState extends State<Transaction> {

  _TransactionState(this._code);
  String _code, _url, kittyId, _token;
  List _cagnottes;
  bool b=false;
  int choix, idUser, inc=-1;
  double avata;

  var _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  initState(){
    super.initState();
    _url = "$base_url/trans/allTrans";
    this.lire();
    this.lecture();
    if(b==false){
      this.read();
    }
  }

  lire() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final key = 'idUser';
      idUser = prefs.getString(key)==null?-1:int.parse(prefs.getString(key));
      print("idUser est: $idUser");
    });
  }

  Future<String> getJsonData() async {
    var _header = {
      "accept": "application/json",
      "content-type" : "application/json",
    };
    var response = await http.get(Uri.encodeFull(_url), headers: _header,);
    print('statuscode ${response.statusCode}');
    print('url $_url');
    if (response.statusCode == 200) {
      setState(() {
        var convertDataToJson = json.decode(utf8.decode(response.bodyBytes));
        _cagnottes = convertDataToJson['content'];
        print(_cagnottes.toString());
      });
    }else if(response.statusCode == 401){
      this.save();
      setState(() {
        b = true;
      });
      this.ackAlert(context, "Vous devez être connecté pour voir les commentaires liés à cette cagnotte.");
    }else print(response.body);
    return "success";
  }

  void save() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'route';
    final value = "participants";
    prefs.setString(key, value);
  }

  Future<void> ackAlert(BuildContext context, String text) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: <Widget>[
              Icon(Icons.lock_outline,color: couleur_fond_bouton,),
              Text("Connectez-vous!", style: TextStyle(
                  fontSize: taille_libelle_etape,
                  color: couleur_fond_bouton
              ),),
            ],
          ),
          content: Text(text,
            style: TextStyle(
              fontSize: taille_champ,
            ),
            textAlign: TextAlign.justify,),
          actions: <Widget>[
            FlatButton(
              child: Text('Annuler',style: TextStyle(
                  color: couleur_fond_bouton
              ),),
              onPressed: () {
                //this.savAll();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Me connecter',style: TextStyle(
                  color: couleur_fond_bouton
              ),),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Pays()));
                //Navigator.of(context).push(SlideLeftRoute(enterWidget: Pays(), oldWidget: Participants('$_code')));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _large = MediaQuery.of(context).size.width;
    final _haut = MediaQuery.of(context).size.height;
    if(_large<=320){
      avata = 50;
    }else if(_large>320 && _large<=360 && _haut==738){
      avata = 50;
    }else if(_large>320 && _large<360){
      avata = 50;
    }else if(_large==360){
      avata = 50;
    }else if(_large> 411 && _large<412){
      avata = 60;
    }
    else if(_large>360){
      avata = 60;
    }

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: new AppBar(
          title: Text('Mes transactions',
            style: TextStyle(
              color: couleur_titre,
              fontSize: taille_libelle_etape,
            ),),
          elevation: 0.0,
          backgroundColor: couleur_appbar,
          flexibleSpace: barreTop,

          leading: InkWell(
              onTap: (){
                setState(() {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte('')));
                });
                //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Activation(_code)));
              },
              child: Icon(Icons.arrow_back_ios,)),
          iconTheme: new IconThemeData(color: couleur_fond_bouton),
        ),
      ),
      body:_cagnottes!=null? ListView.builder(
        shrinkWrap: true,
          itemCount: _cagnottes==null?0:_cagnottes.length,
          itemBuilder: (BuildContext context, int i){
            var firstname = _cagnottes[i]['trans']['user']['firstname'];
            var lastname = _cagnottes[i]['trans']['user']['lastname'];
            var date = _cagnottes[i]['trans']['dateTrans'];
            var heure = _cagnottes[i]['trans']['transTime'];
            var status = _cagnottes[i]['trans']['status'];
            var type = _cagnottes[i]['trans']['type'];
            var avatar = _cagnottes[i]['kitty']['user']['userImage'];
            var amount = _cagnottes[i]['trans']['amount'];
            var detail = _cagnottes[i]['trans']['name'];
            var currency = _cagnottes[i]['kitty']['currency'];
            var id = _cagnottes[i]["kitty"]['user']['id_user'];
            print(avatar.toString());

            if(status=="PROCESSED" && id == idUser){
              inc++;
            if(inc == 0 || inc == -1){
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Divider(color: couleur_bordure,
                      height: .1,),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: avata,
                            width: avata,
                            child:avatar!=null && avatar!="url_de_l_image"? Image.asset(avatar):Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage("images/ellipse1.png"),
                                      fit: BoxFit.cover
                                  )
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(getText(firstname, lastname),style: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize:taille_libelle_champ,
                                    fontWeight: FontWeight.bold
                                ),),
                                Text('$date à $heure',style: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize:taille_libelle_champ,
                                    fontWeight: FontWeight.normal
                                ),),
                              ],
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Text('$amount $currency',style: TextStyle(
                                color: couleur_libelle_etape,
                                fontWeight: FontWeight.bold,
                                fontSize: taille_description_champ
                            ),),
                          ),
                        ),

                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Column(
                              children: <Widget>[
                                Text('$type',style: TextStyle(
                                    color: type=="CASHIN"?Colors.green:Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: taille_description_champ
                                ),),
                                Text(getContribute(detail),style: TextStyle(
                                    color: couleur_libelle_etape,
                                    fontWeight: FontWeight.bold,
                                    fontSize: taille_description_champ
                                ),),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
                    child: Divider(color: couleur_bordure,
                      height: .1,),
                  ),
                ],
              );
            }else
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: avata,
                            width: avata,
                            child:avatar!=null && avatar!="url_de_l_image"? Image.asset(avatar):Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage("images/ellipse1.png"),
                                      fit: BoxFit.cover
                                  )
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(getText(firstname, lastname),style: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize:taille_libelle_champ,
                                    fontWeight: FontWeight.bold
                                ),),
                                Text('$date à $heure',style: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize:taille_libelle_champ,
                                    fontWeight: FontWeight.normal
                                ),),
                              ],
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Text('$amount $currency',style: TextStyle(
                                color: couleur_libelle_etape,
                                fontWeight: FontWeight.bold,
                                fontSize: taille_description_champ
                            ),),
                          ),
                        ),

                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Column(
                              children: <Widget>[
                                Text('$type',style: TextStyle(
                                    color: type=="CASHIN"?Colors.green:Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: taille_description_champ
                                ),),
                                Text(getContribute(detail),style: TextStyle(
                                    color: couleur_libelle_etape,
                                    fontWeight: FontWeight.bold,
                                    fontSize: taille_description_champ
                                ),),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
                    child: Divider(color: couleur_bordure,
                      height: .1,),
                  ),
                ],
              );
             }else{
              return Container();
            }
          }
      ):Center(
          child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: bleu_F,
              ),
              child: CupertinoActivityIndicator()
          )
      ),
      bottomNavigationBar: bottomNavigation(context, _scaffoldKey,  choix, _token),
    );
  }

  lecture() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final key = 'choix';
      choix = int.parse(prefs.getString(key));
      getJsonData();
    });
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final key = 'monToken';
      _token = prefs.getString(key);
    });
  }

  String getText(String firstname, String lastname) {
    if(firstname!=null && lastname!=null){
      return '$firstname $lastname';
    }else if(firstname == null && lastname ==null){
      return 'Anonyme';
    }else if(firstname!=null && lastname == null){
      return firstname;
    }else if(firstname==null && lastname!=null){
      return lastname;
    }
    return null;
  }

  String getContribute(String detail){
    String sortie;
    if(detail == "CONTRIBUTE_BY_MOMO")
      sortie = "MTN";
    else if(detail == "CONTRIBUTE_BY_CARD"){
      sortie = "CARD";
    }else if(detail == "CONTRIBUTE_BY_WALLET"){
      sortie = "WALLET";
    }else if(detail == "CONTRIBUTE_BY_OM_WEB"){
      sortie = "ORANGE";
    }else
      sortie = detail;
    return sortie;
  }


  Widget loader(List cagnotte){
    Timer(Duration(seconds: 60), (){});
    if(cagnotte==null && inc != -2){
      setState(() {
        inc = -2;
      });
      return Center(
          child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: bleu_F,
              ),
              child: CupertinoActivityIndicator()
          )
      );
    }else if(inc == -2)
    return Center(
        child: Text("Aucune transaction!",style: TextStyle(
          color: Colors.black,
          fontSize: taille_description_page,
          fontFamily: police_description_page,
        ),)
    );
  }
}