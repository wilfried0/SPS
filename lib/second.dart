import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:services/auth/connexion.dart';
import 'package:services/composants/components.dart';
import 'package:services/third.dart';

class Second extends StatelessWidget {

  int ad = 5;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.white, accentColor: Color(0xFF2A2A42), fontFamily: 'Poppins'),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.black,
                  Colors.black,
                ],
            ),
            image: DecorationImage(
              image: AssetImage("images/markertplac.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20, right: MediaQuery.of(context).size.width/3, top: 20),
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/logo-sp-marketplace.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              /*CircleAvatar(
                backgroundImage: ExactAssetImage('images/comm.jpg'),
                radius: 80,
              ),*/
              Container(
                  height: 100.0,
                  width: 100.0,
                  child: Padding(
                      padding: EdgeInsets.all(0),
                      child: CircleAvatar(
                        backgroundImage: ExactAssetImage('images/comm.jpg'),
                        //radius: 20,
                      )),
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    border: new Border.all(
                      color: Colors.white,
                      width: 3.0,
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text("BIENVENUE SUR SPRINT-PAY MARKETPLACE", style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: taille_champ+ad-1
                ),),
              ),
              Container(
                color: Colors.white,
                height: 2,
                width: MediaQuery.of(context).size.width/2,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Text("Nos clients accèdent à un espace de vente virtuel international dans un cadre de confiance, de transparence et de sécurité.",style: TextStyle(
                    color: Colors.white,
                    fontSize: taille_champ+ad-2
                ),textAlign: TextAlign.center,),
              ),

              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Text("Nos partenaires commerciaux accèdent à des millions d'utilisateurs et leur mettent à disposition leurs expertises de vente en ligne.",style: TextStyle(
                    color: Colors.white,
                    fontSize: taille_champ+ad-2
                ),textAlign: TextAlign.center,),
              ),

              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30.0,
                          child: new Image.asset('images/hand.png'),
                        ),
                        Text("BOUTIQUES EN LIGNE", style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),)
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 30.0,
                            child: new Image.asset('images/money-2.png'),
                          ),
                        ),
                        Text("PAIEMENT DES FACTURES", style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),)
                      ],
                    ),
                  ),
                ],
              ),

              Column(
                children: <Widget>[
                  Container(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30.0,
                      child: new Image.asset('images/money-2.png'),
                    ),
                  ),
                  Text("PHARMACIES EN LIGNE", style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),)
                ],
              ),

              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: Third()));
                            },
                            child: Container(
                              height: hauteur_champ-10,
                              width: MediaQuery.of(context).size.width-40,
                              decoration: new BoxDecoration(
                                color: Colors.transparent,
                                border: new Border.all(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                                borderRadius: new BorderRadius.circular(20.0),
                              ),
                              child: Center(child: new Text("Suivant", style: new TextStyle(fontSize: taille_text_bouton+ad, color: Colors.white, fontFamily: police_bouton),)),
                            ),
                          ),
                        )
                    ),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: Connexion()));
                            },
                            child: Container(
                              height: hauteur_champ-10,
                              width: MediaQuery.of(context).size.width-40,
                              decoration: new BoxDecoration(
                                color: Colors.transparent,
                                border: new Border.all(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                                borderRadius: new BorderRadius.circular(20.0),
                              ),
                              child: Center(child: new Text("Passer", style: new TextStyle(fontSize: taille_text_bouton+ad, color: Colors.white, fontFamily: police_bouton),)),
                            ),
                          ),
                        )
                    )
                  ],
                ),
              )
            ],
          ) ,
        ),
      ),
    );
  }
}