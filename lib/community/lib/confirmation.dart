import 'package:flutter/material.dart';
import 'package:services/composants/components.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'cagnotte.dart';

// ignore: must_be_immutable
class Confirmation extends StatefulWidget {
  Confirmation(this._code);
  String _code;

  @override
  _ConfirmationState createState() => new _ConfirmationState(_code);
}

class _ConfirmationState extends State<Confirmation> {

  _ConfirmationState(this._code);
  String _code;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _formKey = GlobalKey<FormState>();
  bool _isHidden = true;
  double rating;
  String url;

  @override
  void initState(){
    super.initState();
    print(_code);
    rating = 0.0;
  }

  @override
  Widget build(BuildContext context) {

    final espace = (MediaQuery.of(context).size.height - 533.3333333333334)<0?0.0:MediaQuery.of(context).size.height - 533.3333333333334;
    final pas = (MediaQuery.of(context).size.height - 533.3333333333334)<0?0.0:42.0;

    return new Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: new AppBar(
          title: Text('Confirmation',style: TextStyle(
            color: couleur_titre,
            fontSize: taille_libelle_etape,
          ),),
          elevation: 0.0,
          backgroundColor: couleur_appbar,
          flexibleSpace: barreTop,

          leading: InkWell(
              onTap: (){
                setState(() {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte(_code)));
                  //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Confirmation(_code)));
                });
                //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Verification3(_code)));
              },
              child: Icon(Icons.arrow_back_ios,)),
          iconTheme: new IconThemeData(color: couleur_fond_bouton),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          return Future.value(false); //return a `Future` with false value so this route cant be popped or closed.
        },
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Form(
                key: _formKey,
                child: new Column(
                  children: <Widget>[
                    Container(
                      height: hauteur_logo,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                        child: new Image.asset('images/logo_sprint.png'),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: marge_apres_logo),),

                    Padding(
                        padding: EdgeInsets.only(top:(espace - 65)>0?(espace-65)/2:0.0,)),

                    Column(
                      children: <Widget>[
                        Text('Noter la cagnotte', style: TextStyle(
                            color: couleur_titre,
                            fontSize: taille_description_page,
                            fontFamily: police_titre,
                            fontWeight: FontWeight.normal
                        ),),
                        SmoothStarRating(
                              allowHalfRating: false,
                              rating: rating,
                              size: 40,
                              starCount: 5,
                              color: orange_F,
                              borderColor: orange_F,
                              spacing:5.0,
                              onRated: (value) {
                                setState(() {
                                  rating = value;
                                  print(rating);
                                });
                              },
                            ),
                      ],
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: marge_apres_titre),),

                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: new Text('Merci!\nVotre participation a été enregistrée!',
                            style: TextStyle(
                                color: couleur_titre,
                                fontSize: taille_titre,
                                fontFamily: police_titre,
                                fontWeight: FontWeight.bold
                            )),
                      ),
                    ),


                    Padding(
                      padding: EdgeInsets.only(left:20.0, top:20.0, right: 20),
                      child: new Text("Cliquez pour retourner à l'accueil Sprint Pay",
                        style: TextStyle(
                            color: couleur_decription_page,
                            fontSize: taille_description_page,
                            fontFamily: police_description_page
                        ),),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: pas/2),
                      child: new InkWell(
                        onTap: () async {
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Cagnotte(_code)));
                        },
                        child: new Container(
                          height: hauteur_champ,
                          width: MediaQuery.of(context).size.width-40,
                          decoration: new BoxDecoration(
                            color: couleur_fond_bouton,
                            border: new Border.all(
                              color: Colors.transparent,
                              width: 0.0,
                            ),
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          child: Center(child: new Text("Retourner à l'accueil", style: new TextStyle(fontSize: taille_text_bouton, color: Colors.white, fontFamily: police_bouton),)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: barreBottom,
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text(value,style:
        TextStyle(
            color: Colors.white,
            fontSize: taille_description_champ
        ),
          textAlign: TextAlign.center,),
          backgroundColor: couleur_fond_bouton,
          duration: Duration(seconds: 5),));
  }
}