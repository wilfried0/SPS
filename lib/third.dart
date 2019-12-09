import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:services/auth/connexion.dart';
import 'package:services/composants/components.dart';

class Third extends StatelessWidget {

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
              image: AssetImage("images/service.jpg"),
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
                      image: AssetImage("images/logo.png"),
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
                child: Text("BIENVENUE SUR SPRINT-PAY SERVICES", style: TextStyle(
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
                child: Text("Sprint Pay Services, la solution de paiement mobile intégré.",style: TextStyle(
                    color: Colors.white,
                    fontSize: taille_champ+ad-2
                ),textAlign: TextAlign.center,),
              ),

              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Text("Vous pouvez faire vos achats dans plus de 20 dévises, envoyer et gérer votre argent. Tout celà avec un seul compte Sprint Pay",style: TextStyle(
                    color: Colors.white,
                    fontSize: taille_champ+ad-2
                ),textAlign: TextAlign.center,),
              ),

              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
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
                          Text("DEPÔT/RETRAIT DE FONDS", style: TextStyle(
                              color: Colors.white,
                              fontSize: 7,
                              fontWeight: FontWeight.bold
                          ),textAlign: TextAlign.center,)
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
                          Text("PAIEMENT PAR QR CODE", style: TextStyle(
                              color: Colors.white,
                              fontSize: 7,
                              fontWeight: FontWeight.bold
                          ),textAlign: TextAlign.center)
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
                          Text("CARTES PRÉPAYÉES", style: TextStyle(
                              color: Colors.white,
                              fontSize: 7,
                              fontWeight: FontWeight.bold
                          ),textAlign: TextAlign.center)
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
                          Text("RELEVÉ DE COMPTE", style: TextStyle(
                              color: Colors.white,
                              fontSize: 7,
                              fontWeight: FontWeight.bold
                          ),textAlign: TextAlign.center)
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
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
                          Text("TRANSFERT GRATUIT D'ARGENT", style: TextStyle(
                              color: Colors.white,
                              fontSize: 7,
                              fontWeight: FontWeight.bold
                          ),textAlign: TextAlign.center)
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
                          Text("ACHAT DE CREDIT MOBILE", style: TextStyle(
                              color: Colors.white,
                              fontSize: 7,
                              fontWeight: FontWeight.bold
                          ),textAlign: TextAlign.center)
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
                          Text("RESEAU SOCIAL", style: TextStyle(
                              color: Colors.white,
                              fontSize: 7,
                              fontWeight: FontWeight.bold
                          ),textAlign: TextAlign.center)
                        ],
                      ),
                    ),
                  ],
                ),
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