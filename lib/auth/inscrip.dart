import 'package:flutter/material.dart';
import 'package:services/auth/connexion.dart';
import 'package:services/auth/profile.dart';
import 'package:services/composants/components.dart';

class Inscrip extends StatefulWidget {
  @override
  _InscripState createState() => _InscripState();
}

class _InscripState extends State<Inscrip> {

  int ad = 3;
  String _birthday;
  int _date = new DateTime.now().year;

  Future _selectDate() async {
    print(_date);
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime(1900),
        firstDate: new DateTime(1900),
        lastDate: new DateTime(_date+1)
    );
    if(picked != null) setState(
            () => _birthday = picked.toString().split(" ")[0].replaceAll("-", "/")
    );
  }

  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white, accentColor: Color(0xFF2A2A42), fontFamily: 'Poppins'),
      routes: <String, WidgetBuilder>{
        "/connexion": (BuildContext context) =>new Connexion(),
      },
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  SizedBox(
                    height: 330,
                    width: MediaQuery.of(context).size.width,
                    child: DrawerHeader(
                      decoration: BoxDecoration(
                          color: couleur_fond_bouton
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              child: Container(
                                height: 230,
                                width: 230,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: AssetImage("images/ellipse1.png"),
                                        fit: BoxFit.cover
                                    )
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: new EdgeInsets.only(
                      top: 50,
                        right:0.0,
                        left: MediaQuery.of(context).size.width-70),
                    child: InkWell(
                      onTap: (){

                      },
                      child: Icon(Icons.camera_alt,size: 50, color: Colors.white,),
                    ),
                  ),
                ],
              ),

              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: Text("L'adresse email est facultative", style: TextStyle(
                    color: couleur_libelle_champ,
                  ),textAlign: TextAlign.left,),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: Container(
                  margin: EdgeInsets.only(top: 0.0),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                    color: Colors.transparent,
                    border: Border.all(
                      width: bordure,
                      color: couleur_bordure,
                    ),
                  ),
                  height: hauteur_champ,
                  child: Row(
                    children: <Widget>[
                      new Expanded(
                        flex:2,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: new Icon(Icons.person, color: couleur_decription_page,),//Image.asset('images/Groupe177.png'),
                        ),
                      ),
                      new Expanded(
                        flex:10,
                        child: Padding(
                          padding: EdgeInsets.only(left:0.0),
                          child: new TextFormField(
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              fontSize: taille_champ+ad,
                              color: couleur_libelle_champ,
                            ),
                            validator: (String value){
                              if(value.isEmpty){
                                return "Champ nom vide !";
                              }else{
                                return null;
                              }
                            },
                            decoration: InputDecoration.collapsed(
                              hintText: 'Nom(s) et prénom(s)',
                              hintStyle: TextStyle(color: couleur_libelle_champ,
                                  fontSize: taille_champ+ad
                              ),
                              //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Container(
                  margin: EdgeInsets.only(top: 0.0),
                  decoration: new BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      width: bordure,
                      color: couleur_bordure,
                    ),
                  ),
                  height: hauteur_champ,
                  child: Row(
                    children: <Widget>[
                      new Expanded(
                        flex:2,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: new Icon(Icons.email, color: couleur_decription_page,),//Image.asset('images/Groupe177.png'),
                        ),
                      ),
                      new Expanded(
                        flex:10,
                        child: Padding(
                          padding: EdgeInsets.only(left:0.0),
                          child: new TextFormField(
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              fontSize: taille_champ+ad,
                              color: couleur_libelle_champ,
                            ),
                            validator: (String value){
                              if(value.isEmpty){
                                return "Champ email vide !";
                              }else{
                                return null;
                              }
                            },
                            decoration: InputDecoration.collapsed(
                              hintText: 'Email',
                              hintStyle: TextStyle(color: couleur_libelle_champ,
                                  fontSize: taille_champ+ad
                              ),
                              //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                child: Container(
                  margin: EdgeInsets.only(top: 0.0),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.only(
                      bottomRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    ),
                    color: Colors.transparent,
                    border: Border.all(
                      width: bordure,
                      color: couleur_bordure,
                    ),
                  ),
                  height: hauteur_champ,
                  child: Row(
                    children: <Widget>[
                      new Expanded(
                        flex:2,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: new Icon(Icons.calendar_today, color: couleur_decription_page,),//Image.asset('images/Groupe177.png'),
                        ),
                      ),
                      new Expanded(
                        flex:10,
                        child: GestureDetector(
                          onTap: (){
                            _selectDate();
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 0.0),
                            decoration: new BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                width: bordure,
                                color: Colors.transparent,
                              ),
                            ),
                            height: hauteur_champ,
                            child: Row(
                              children: <Widget>[
                                new Expanded(
                                  flex:12,
                                  child: new TextFormField(
                                    keyboardType: TextInputType.text,
                                    enabled: false,
                                    style: TextStyle(
                                      fontSize: taille_champ+ad,
                                      color: couleur_libelle_champ,
                                    ),
                                    validator: (String value){
                                      if(_birthday == null){
                                        return 'Date de début vide';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration.collapsed(
                                      hintText: _birthday == null?'Date de début':_birthday,
                                      hintStyle: TextStyle(color: couleur_libelle_champ,
                                        fontSize: taille_champ+ad,
                                      ),
                                      //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: new GestureDetector(
                  onTap: () {
                    setState(() {
                      navigatorKey.currentState.pushNamed("/connexion");
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
                    child: new Center(child: new Text('Valider', style: new TextStyle(fontSize: taille_text_bouton+ad, color: couleur_text_bouton),)),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: barreBottom,
      ),
    );
  }
}
