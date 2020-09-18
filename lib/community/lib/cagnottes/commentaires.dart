import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/composants/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'detail.dart';
import '../utils/components.dart';


// ignore: must_be_immutable
class Commentaires extends StatefulWidget {
  Commentaires(this._code);
  String _code;

  @override
  _CommentairesState createState() => new _CommentairesState(_code);
}

class _CommentairesState extends State<Commentaires> {

  _CommentairesState(this._code);
  String _code, _token, _url, commentaire;
  bool isLoding = false;
  int choix, kittyId;
  List parts;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lire();
  }

  lire() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      choix = int.parse(prefs.getString(CHOIX));
      _token = prefs.getString(CHOIX);
      kittyId = int.parse(prefs.getString(ID_KITTY));
      getDetailsKitty();
    });
  }

  Future<String> getDetailsKitty() async {
    _url = "$cagnotte_url/kitty/getOneKitty/$kittyId";
    print("$_url");
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.getUrl(Uri.parse("$_url"));
    request.headers.set('Accept', 'application/json');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    if(response.statusCode == 200){
      Map map = json.decode(reply);
      parts = map['parts'];
      //parts = i.map((model) => Participant.fromJson(model)).toList();
      print(parts);
      if(parts.length<=1){
        commentaire = "Commentaire";
      }else{
        commentaire = "Commentaires";
      }
      setState(() {
        isLoding = false;
      });
    }else if(response.statusCode == 401){
      setState(() {
        isLoding = false;
      });
      AlertCon(context);
    }else{
      print(response.statusCode);
      print(reply);
      setState(() {
        isLoding = false;
      });
      showInSnackBar("Service indisponible!", _scaffoldKey, 5);
    }
  }

  @override
  Widget build(BuildContext context) {
    final espace = (MediaQuery.of(context).size.height - 533.3333333333334)<0?0.0:MediaQuery.of(context).size.height - 533.3333333333334;
    final pas = (MediaQuery.of(context).size.height - 533.3333333333334)<0?0.0:42.0;

    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: GRIS,
      appBar: new PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: new AppBar(
          title: Text("$commentaire",
            style: TextStyle(
              color: couleur_titre,
              fontSize: taille_libelle_etape,
            ),),
          elevation: 0.0,
          backgroundColor: GRIS,
          flexibleSpace: barreTop,

          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Detail(_code)));
              }
          ),
          iconTheme: new IconThemeData(color: bleu_F),
        ),
      ),
      body: parts == null && isLoding == true?
      Center(
          child: Column(
            children: <Widget>[
              new CupertinoActivityIndicator(radius: 20,),
              Text('Chargement en cours ...', style: TextStyle(
                  fontSize: taille_champ+3,
                  color: couleur_libelle_champ
              ),)
            ],
          )
      ):parts == null && isLoding == false?
      Center(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text('Aucun commentaire enregistré à cette cagnotte', style: TextStyle(
              fontSize: taille_champ+3,
              color: couleur_libelle_champ
          ),textAlign: TextAlign.center,),
        ),
      ):
      ListView.builder(
          itemCount:parts==null?0: parts.length,
          itemBuilder: (BuildContext context, int i){
            var firstname = parts[i]['firstname'];
            var lastname = parts[i]['lastname'];
            var phoneNumber = parts[i]['phoneNumber'];
            var description = parts[i]['description'];
            var amount = parts[i]['amount'];
            var currency = parts[i]['currency'];
            return Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Card(
                elevation: 0.8,
                color: Colors.white,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: Image.asset("images/ellipse1.png"),
                      ),
                    ),
                    getNom(firstname, lastname) == ""?
                    Text("$phoneNumber", style: TextStyle(
                        fontSize: taille_champ+3
                    ),):Column(
                       children: [
                         Text(getNom(firstname, lastname), style: TextStyle(
                             fontSize: taille_champ+3
                         ),),
                         Text("$phoneNumber", style: TextStyle(
                             fontSize: taille_champ+3
                         ),)
                       ],
                     ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Text("$description", style: TextStyle(
                          color: couleur_fond_bouton,
                          fontWeight: FontWeight.bold
                      ),),
                    )
                  ],
                ),
              ),
            );
          }
      ),
      bottomNavigationBar:bottomNavigation(context, _scaffoldKey, choix, _token),
    );
  }

  getNom(String prenom, String nom){
    if(prenom == "" && nom == ""){
      return "";
    }else if(prenom == "" && nom != ""){
      return nom;
    }else if(prenom != "" && nom == ""){
      return prenom;
    }else return "$nom $prenom";
  }
}