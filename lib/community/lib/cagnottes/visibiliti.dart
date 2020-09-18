import 'package:flutter/material.dart';
import 'package:services/composants/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cagnotte2.dart';
import '../utils/components.dart';


// ignore: must_be_immutable
class Visibiliti extends StatefulWidget {
  Visibiliti();

  @override
  _VisibilitiState createState() => new _VisibilitiState();
}

class _VisibilitiState extends State<Visibiliti> {

  _VisibilitiState();
  double hauteur1, hauteur2, hauteur3, hauteur4, hauteur5, hauteur6, hauteur7, hauteur8, enlev, left1, right1, hauteur9, hauteur10;


  @override
  Widget build(BuildContext context) {
    final _large = MediaQuery.of(context).size.width;
    if(_large<=320){
      hauteur1 = 130;
      hauteur2 = 130;
      enlev = 290;
      hauteur3 = 175;
      left1 = 85.0;
      hauteur4 = 260;
      hauteur5=265;
      hauteur6 = 310;
      hauteur7=380;
      hauteur8=385;
      hauteur9 = 500;
      hauteur10 = 430;
      right1=40;
    }else if(_large>320 && _large<=360){
      hauteur1 = 100;hauteur2 = 130; enlev = 328; hauteur3 = 175; left1 = 100; hauteur4 = 250;hauteur5=280;hauteur6 = 320;hauteur7=385;hauteur8=420;hauteur9 = 520;hauteur10 = 460; right1=40;
    }
    else if(_large>360){
      hauteur1 = 100;hauteur2 = 130; enlev = 370; hauteur3 = 175; left1 = 100; hauteur4 = 250;hauteur5=280;hauteur6 = 320;hauteur7=385;hauteur8=420;hauteur9 = 520;hauteur10 = 460; right1=40;
    }
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Visibilité de la cagnotte',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text('Quelle visibilité souhaitez-vous\nattribuer à cette cagnotte ?',
                style: TextStyle(
                    color: couleur_titre,
                    fontSize: taille_titre,
                    fontWeight: FontWeight.bold
                ),),

              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Divider(
                  height: .5,
                  color: couleur_libelle_champ,
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Container(
                  height: hauteur_champ,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex:2,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: new Image.asset('communityimages/trace1.png'),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: InkWell(
                            onTap: (){
                              this._savev('Publique');
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte2()));
                              //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte2(_code), oldWidget: Visibiliti(_code)));
                            },
                            child: Text('Publique',
                              style: TextStyle(
                                color: couleur_libelle_champ,
                                fontSize:taille_libelle_champ,
                                fontWeight: FontWeight.bold
                              ),),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width-enlev),
                          child: InkWell(
                            onTap: (){
                              this._savev('Publique');
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte2()));
                              //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte2(_code), oldWidget: Visibiliti(_code)));
                            },
                            child: Container(
                              width: 15.0,
                              height: 15.0,
                              decoration: new BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                    color: couleur_libelle_champ,
                                    width: 1
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 20),
                child: InkWell(
                  onTap: (){
                    this._savev('Publique');
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte2()));
                    //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte2(_code), oldWidget: Visibiliti(_code)));
                  },
                  child: Text('Votre cagnotte sera visible par tout le monde, les inscrits, membres et même les visiteurs non connectés.',
                  style: TextStyle(
                    color: couleur_decription_page,
                    fontSize: taille_champ,
                  ),),
                ),
              ),


              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Divider(
                  height: .5,
                  color: couleur_libelle_champ,
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Container(
                  height: hauteur_champ,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex:2,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: new Image.asset('communityimages/trace2.png'),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: InkWell(
                            onTap: (){
                              this._savev('Privée');
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte2()));
                              //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte2(_code), oldWidget: Visibiliti(_code)));
                            },
                            child: Text('Privée',
                              style: TextStyle(
                                  color: couleur_libelle_champ,
                                  fontSize:taille_libelle_champ,
                                  fontWeight: FontWeight.bold
                              ),),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width-enlev),
                          child: InkWell(
                            onTap: (){
                              this._savev('Privée');
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte2()));
                              //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte2(_code), oldWidget: Visibiliti(_code)));
                            },
                            child: Container(
                              width: 15.0,
                              height: 15.0,
                              decoration: new BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                    color: couleur_libelle_champ,
                                    width: 1
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 20),
                child: InkWell(
                  onTap: (){
                    this._savev('Privée');
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte2()));
                    //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte2(_code), oldWidget: Visibiliti(_code)));
                  },
                  child: Text('Votre cagnotte sera visible uniquement, par les membres inscrits et connectés.',
                    style: TextStyle(
                      color: couleur_decription_page,
                      fontSize: taille_champ,
                    ),),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Divider(
                  height: .5,
                  color: couleur_libelle_champ,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: barreBottom,
    );
  }

  void _savev(String visible) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(VISIBLE, "$visible");
  }
}