import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/auth/conditions.dart';
import 'package:services/auth/connexion.dart';
import 'package:services/community/lib/paiement/historique.dart';
import 'package:services/composants/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cagnotte.dart';
import 'cagnottes/paysc.dart';
import 'tontines/paysctontine.dart';
import 'tontines/tontine.dart';
import 'utils/components.dart';


class getDrawerContent extends StatefulWidget {



  @override
  _getDrawerContentState createState() => _getDrawerContentState();
}

class _getDrawerContentState extends State<getDrawerContent> {

  String _nom, _ville, _quartier, _pays, avatar, token, urlPath, choix;
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.lecture();
  }

  save() async {
    final prefs = await SharedPreferences.getInstance();
    if(choix == "2")
      prefs.setString(ORIGIN, "tontine");
    else
    prefs.setString(ORIGIN, "cagnotte");
  }

  lecture() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString(TOKEN);
      _nom = prefs.getString('nom');
      _ville = prefs.getString('ville');
      _quartier = prefs.getString('quartier');
      _pays = prefs.getString('pays');
      avatar = prefs.getString('avatar');
      choix = prefs.getString(CHOIX);
      print("Choix vaut =>>>: $choix");
    });
  }

  setDeconnection() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(TOKEN, null);
    prefs.setString('nom', null);
    prefs.setString('ville', null);
    prefs.setString('quartier', null);
    prefs.setString('pays', null);
    prefs.setString('avatar', null);
    this.lecture();
    //_scaffoldKey.currentState.openEndDrawer();
    //showInSnackBar("Deconnexion effectuée avec succès!", _scaffoldKey, 5);
  }

  logOut() async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    String url = "$cagnotte_url/user/auth/signout";
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.set('Accept', 'application/json');
    request.headers.set('Authorization', 'Bearer $token');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print(reply);
    print("Le token: $token");
    if(response.statusCode == 200 || response.statusCode == 401){
      var responseJson = json.decode(reply);
      print(responseJson);
      setState(() {
        isLoading = false;
      });
      this.setDeconnection();
    }else{
      print(response.statusCode);
      setState(() {
        isLoading = false;
      });
      //_scaffoldKey.currentState.openEndDrawer();
      //showInSnackBar("Service indisponible!", _scaffoldKey, 5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: _scaffoldKey,
      padding: EdgeInsets.zero,
      child: Container(
        width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width/6,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20)
            )
        ),
        child: new ListView(
          //padding: EdgeInsets.zero,
          children: <Widget> [
            DrawerHeader(
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_nom==null?"SprintPay":"$_nom", style: TextStyle(
                      color: Colors.white,
                      fontSize: taille_libelle_etape),),
                  SizedBox(
                    child: Container(
                      height:90,
                      width: 90,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: avatar==null || avatar=="null"? AssetImage("images/ellipse1.png"):NetworkImage(avatar),
                              fit: BoxFit.cover
                          )
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _quartier==null && _ville==null && _pays==null?Container():Icon(Icons.location_on,color: Colors.white,size: 15,),
                      Row(
                        children: <Widget>[
                          Text(_quartier==null || _quartier=="null"?"":" $_quartier -", style: TextStyle(
                              color: Colors.white,
                              fontSize: taille_champ-2
                          ),),
                          Text(_ville==null || _ville=="null"?"":" $_ville -", style: TextStyle(
                              color: Colors.white,
                              fontSize: taille_champ-2
                          ),),
                          Text(_pays==null || _pays =="null"?"":" $_pays", style: TextStyle(
                              color: Colors.white,
                              fontSize: taille_champ-2
                          ),),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  color: orange_F
              ),
            ),

            token==null?Container():new ListTile(
              title: Padding(
                padding: EdgeInsets.only(left: 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex:1,
                      child: Icon(Icons.format_list_bulleted, color: bleu_F,),//Image.asset("images/Groupe3.png",height: 50,width: 50,),
                    ),
                    Expanded(
                      flex:11,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        // ignore: unrelated_type_equality_checks
                        child: new Text(choix == "2"?'Mes tontines':'Mes cagnottes',style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: taille_champ+3
                        ),),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                // ignore: unrelated_type_equality_checks
                if(choix == "2")
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Tontine('tontine')));
                else
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Cagnotte('cagnotte')));
              },
            ),
            token==null?Container():Padding(
              padding: EdgeInsets.only(left: 20),
              child: new Divider(
                color: couleur_champ,
              ),
            ),

            token==null?Container():new ListTile(
              title: Padding(
                padding: EdgeInsets.only(left: 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex:1,
                      child: Icon(Icons.local_atm, color: bleu_F,),//Image.asset("images/Groupe3.png",height: 50,width: 50,),
                    ),
                    Expanded(
                      flex:11,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: new Text('Mes transactions',style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: taille_champ+3
                        ),),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Historique("")));
              },
            ),
            token==null?Container():Padding(
              padding: EdgeInsets.only(left: 20),
              child: new Divider(
                color: couleur_champ,
              ),
            ),

            /*new ListTile(
              title: Row(
                children: <Widget>[
                  Expanded(
                      flex:1,
                      child: Icon(Icons.chat_bubble_outline, color: bleu_F,)),//Image.asset("images/Groupe11.png")),
                  Expanded(
                    flex:11,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: new Text('Comment ça marche',style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: taille_champ+3
                      ),),
                    ),
                  ),
                ],
              ),
              onTap: () {},
            ),*/
            /*Padding(
              padding: EdgeInsets.only(left: 20),
              child: new Divider(
                color: couleur_champ,
              ),
            ),
            new ListTile(
              title: Padding(
                padding: EdgeInsets.only(left: 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex:1,
                        child: Icon(Icons.aspect_ratio, color: bleu_F,)),//Image.asset("images/trace3.png")),
                    Expanded(
                      flex:11,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: new Text('A propos',style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: taille_champ+3
                        ),),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {

              },
            ),*/

            /*Padding(
              padding: EdgeInsets.only(left: 20),
              child: new Divider(
                color: couleur_champ,
              ),
            ),*/

            /*new ListTile(
              title: Padding(
                padding: EdgeInsets.only(left: 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex:1,
                      child: Icon(Icons.exit_to_app, color: bleu_F,),),//Image.asset("images/ic_deconnexion.png")),
                    Expanded(
                      flex:11,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child:token!=null && isLoading==true?CupertinoActivityIndicator(): new Text(token==null?'Connexion':'Déconnexion',style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: taille_champ+3
                        ),),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                if(token == null){
                  save();
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Connexion()));
                }else{
                  this.logOut();
                }
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: new Divider(
                color: couleur_champ,
              ),
            ),*/

            new ListTile(
              title: Padding(
                padding: EdgeInsets.only(left: 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex:1,
                        child: Icon(Icons.description, color: bleu_F,)),//Image.asset("images/ic_contact_service.png")),
                    Expanded(
                      flex:11,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: new Text(choix == "2"?'Créer tontine':'Créer cagnotte',style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: taille_champ+3
                        ),),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                if(choix == "1"){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Paysc()));
                }else
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Paysctontine()));
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 20,),
              child: new Divider(
                color: couleur_champ,
              ),
            ),

           /* new ListTile(
              title: Padding(
                padding: EdgeInsets.only(left: 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex:1,
                        child: Icon(Icons.search, color: bleu_F,)),//Image.asset("images/ic_contact_service.png")),
                    Expanded(
                      flex:11,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: new Text(choix == "2"?'Rechercher tontine':'Rechercher cagnotte',style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: taille_champ+3
                        ),),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                if(choix == "2"){
                  Navigator.push(context, MaterialPageRoute(builder:(context)=> Search('2')));
                }else{
                  Navigator.push(context, MaterialPageRoute(builder:(context)=> Search('1')));
                }
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 20,),
              child: new Divider(
                color: couleur_champ,
              ),
            ),*/

            new ListTile(
              title: Padding(
                padding: EdgeInsets.only(left: 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex:1,
                      child: Icon(Icons.security, color: bleu_F,),),//Image.asset("images/ic_conditions.png")),
                    Expanded(
                      flex:11,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: new Text('Conditions générales d\'utilisation',style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: taille_champ+3
                        ),),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Conditions()));
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: new Divider(
                color: couleur_champ,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
