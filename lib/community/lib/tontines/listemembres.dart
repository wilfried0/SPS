import 'package:services/community/lib/tontines/participertontine.dart';
import 'package:services/community/lib/utils/components.dart';
import 'package:services/composants/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homme extends StatefulWidget {
  @override
  _HommeState createState() => _HommeState();
}

class _HommeState extends State<Homme> {
  String _token, _username, _password;
  int recenteLenght, archiveLenght, populaireLenght;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int roundId, flex4, flex6, taille, enlev, rest, enlev1, xval, titre, tai, choix;
  double _tail,_taill,haut, _width, hauteurcouverture, nomright, nomtop, right1, datetop, titretop, titreleft, amounttop, amountleft, amountright, topcolect, topphoto, bottomphoto, desctop, descbottom, bottomtext, toptext, _larg, left1, social, topo, div1, div2, margeleft, margeright;
  List _cagnottes;
  List<String> listtontine = new List<String>();
  String nom, owner, description, montant, periode, retard, nextCash, startDate, avatar, id;


  lecture() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      print("la valeur de tite $titre");
      choix = int.parse(prefs.getString(CHOIX));
      avatar = prefs.getString(AVATAR_X);
      nom = prefs.getString(NOM_TONTINE_X);
      owner = prefs.getString(OWNER_USER_TONTINE);
      description = prefs.getString(DESCRIPTION_TONTINE_x);
      montant = prefs.getString(MONTANT_TONTINE_x);
      periode = prefs.getString(PARTICIP_DURATION_TONTINE_X);
      retard = prefs.getString(DELAYTIMES_TONTINE);
      nextCash = prefs.getString(NEXT_CASH_ORDER_TONTINE);
      startDate = prefs.getString(STARTDATE_TONTINE_X);
      listtontine = prefs.getStringList(PARTICIPANTS_X);
    });
  }

  _reading() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      roundId = int.parse(prefs.getString(ID_TONTINE_X));
      _token = prefs.getString(TOKEN);

    });
  }


 /* Future<String> getListparticipants() async {
    //roundId = int.parse();
    var url = "$tontine_url/tontines/randomizeOrder/${roundId}";
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString("username");
    _password = prefs.getString("password");
    print("$_username, $_password");
    print(roundId);
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json');
    request.headers.set("Authorization", "Basic $credentials");
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print(credentials);
    print("statusCode ${response.statusCode}");
    print("body $reply");
  }*/

  @override
  void initState() {
    super.initState();
    this.lecture();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: (){
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Participertontine('')));
      },
      child: Scaffold(
        appBar: AppBar(
          title: new Text(
            'Les participants',
            style: new TextStyle(fontSize: 20.0, color: Colors.white),
          ),
          backgroundColor: bleu_F,
          leading: IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.white,),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Participertontine('')));
            },
          ),
        ),
        body: new Container(
          child: new ListView.builder(
            itemBuilder: (_,int index) => ListDataItem(this.listtontine[index]),
            itemCount: this.listtontine.length,
          ),
        ),
      ),
    );
  }
}

class ListDataItem extends StatelessWidget {

  String itemName;
  ListDataItem(this.itemName);

  @override
  Widget build(BuildContext context) {
    return new Card(

      elevation: 7.0,

      child: Container(

        //margin: EdgeInsets.all(9.0),
        padding: EdgeInsets.all(6.0),

        child: Row(
          children: <Widget>[
              new CircleAvatar(
                child: Icon(Icons.person),
              ),

              new Padding(padding: EdgeInsets.all(8.0)),

              new Text('+'+itemName, style: TextStyle(fontSize: 20.0),)
          ],
        ),
      ),
    );
  }
}





