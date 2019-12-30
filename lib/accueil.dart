import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/connexion.dart';
import 'composants/components.dart';

class Accueil extends StatefulWidget {
  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  @override
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var scrollDirection =Axis.horizontal;
  int ad = 3;
  final controller = PageController(
    initialPage: 0
  );

  void _stock(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    print('saved $value');
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.white, accentColor: Color(0xFF2A2A42), fontFamily: 'Poppins'),
      home: new Scaffold(
        key: _scaffoldKey,
        body: PageView(
          controller: controller,
          scrollDirection: scrollDirection,
          pageSnapping: true,
          children: <Widget>[
            First(context),
            Second(context),
            Third(context),
            Connexion()
          ],
          onPageChanged: (index){
            print('rang $index');
            if(index == 3) _stock("first", "false");
          },
        ),
      )
    );
  }

  Widget First(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple,
            Colors.purpleAccent,
          ],
        ),
        image: DecorationImage(
          image: AssetImage("images/ic_communiti.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20, right: MediaQuery.of(context).size.width/3, top: 20),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/logo_community.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Container(
                height: 170.0,
                width: 170.0,
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
              child: Text("BIENVENUE SUR SPRINT-PAY COMMUNITY", style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: taille_champ+ad
              ),),
            ),
            Container(
              color: Colors.white,
              height: 2,
              width: MediaQuery.of(context).size.width/2,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Text("Sprint Pay community est le service pour collecter et gérer de l'argent à plusieurs en toute simplicité.",style: TextStyle(
                  color: Colors.white,
                  fontSize: taille_champ+ad-2
              ),textAlign: TextAlign.center,),
            ),

            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Text("Sprint Pay Community vous accompagne pour tous vos projets personnels, associatifs, caritatifs ou entrepreneuriaux pour garantir les meilleures chances de succès.",style: TextStyle(
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
                      Container(
                          height: 60.0,
                          width: 60.0,
                          child: CircleAvatar(
                            backgroundImage: ExactAssetImage('images/exchange.png'),
                            backgroundColor: Colors.white,
                            //radius: 20,
                          ),
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            border: new Border.all(
                              color: Colors.white,
                              width: 3.0,
                            ),
                          )),
                      Text("CAGNOTTES", style: TextStyle(
                          color: Colors.white,
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
                          height: 60.0,
                          width: 60.0,
                          child: CircleAvatar(
                            backgroundImage: ExactAssetImage('images/growth.png'),
                            backgroundColor: Colors.white,
                            //radius: 20,
                          ),
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            border: new Border.all(
                              color: Colors.white,
                              width: 3.0,
                            ),
                          )),
                      Text("TONTINES", style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),textAlign: TextAlign.center)
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: (){
                            controller.jumpToPage(1);
                            //Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: Second()));
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
                            this._stock("first", "false");
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
        ),
      ) ,
    );
  }

  Widget Second(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.yellow,
            Colors.yellowAccent,
          ],
        ),
        image: DecorationImage(
          image: AssetImage("images/ic_markertplac.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
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
                height: 170.0,
                width: 170.0,
                child: Padding(
                    padding: EdgeInsets.all(0),
                    child: CircleAvatar(
                      backgroundColor: orange_F,
                      backgroundImage: ExactAssetImage('images/market.png'),
                      //radius: 20,
                    )),
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  border: new Border.all(
                    color: Colors.black,
                    width: 3.0,
                  ),
                )),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text("BIENVENUE SUR SPRINT-PAY MARKETPLACE", style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: taille_champ+ad-1
              ),),
            ),
            Container(
              color: Colors.black,
              height: 2,
              width: MediaQuery.of(context).size.width/2,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Text("Nos clients accèdent à un espace de vente virtuel international dans un cadre de confiance, de transparence et de sécurité.",style: TextStyle(
                  color: Colors.black,
                  fontSize: taille_champ+ad-2,
                fontWeight: FontWeight.normal
              ),textAlign: TextAlign.center,),
            ),

            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Text("Nos partenaires commerciaux accèdent à des millions d'utilisateurs et leur mettent à disposition leurs expertises de vente en ligne.",style: TextStyle(
                  color: Colors.black,
                  fontSize: taille_champ+ad-2,
                  fontWeight: FontWeight.normal
              ),textAlign: TextAlign.center,),
            ),

            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Container(
                          height: 60.0,
                          width: 60.0,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: ExactAssetImage('images/coat.png'),
                            //radius: 20,
                          ),
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            border: new Border.all(
                              color: Colors.white,
                              width: 3.0,
                            ),
                          )),
                      Text("BOUTIQUES EN LIGNE", style: TextStyle(
                          color: Colors.black,
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
                          height: 60.0,
                          width: 60.0,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: ExactAssetImage('images/invoice.png'),
                            //radius: 20,
                          ),
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            border: new Border.all(
                              color: Colors.white,
                              width: 3.0,
                            ),
                          )),
                      Text("PAIEMENT DES FACTURES", style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),textAlign: TextAlign.center)
                    ],
                  ),
                ),
              ],
            ),

            Column(
              children: <Widget>[
                Container(
                    height: 60.0,
                    width: 60.0,
                    child: CircleAvatar(
                      backgroundImage: ExactAssetImage('images/medical.png'),
                      backgroundColor: Colors.white,
                      //radius: 20,
                    ),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      border: new Border.all(
                        color: Colors.white,
                        width: 3.0,
                      ),
                    )),
                Text("PHARMACIES EN LIGNE", style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                ),textAlign: TextAlign.center)
              ],
            ),

            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: (){
                            controller.jumpToPage(2);
                            //Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: Third()));
                          },
                          child: Container(
                            height: hauteur_champ-10,
                            width: MediaQuery.of(context).size.width-40,
                            decoration: new BoxDecoration(
                              color: Colors.transparent,
                              border: new Border.all(
                                color: Colors.black,
                                width: 1.5,
                              ),
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                            child: Center(child: new Text("Suivant", style: new TextStyle(fontSize: taille_text_bouton+ad, color: Colors.black, fontFamily: police_bouton),)),
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
                            this._stock("first", "false");
                            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: Connexion()));
                          },
                          child: Container(
                            height: hauteur_champ-10,
                            width: MediaQuery.of(context).size.width-40,
                            decoration: new BoxDecoration(
                              color: Colors.transparent,
                              border: new Border.all(
                                color: Colors.black,
                                width: 1.5,
                              ),
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                            child: Center(child: new Text("Passer", style: new TextStyle(fontSize: taille_text_bouton+ad, color: Colors.black, fontFamily: police_bouton),)),
                          ),
                        ),
                      )
                  )
                ],
              ),
            )
          ],
        ),
      ) ,
    );
  }

  Widget Third(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue,
            Colors.blueAccent,
          ],
        ),
        image: DecorationImage(
          image: AssetImage("images/ic_service.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
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
            Container(
                height: 170.0,
                width: 170.0,
                child: Padding(
                    padding: EdgeInsets.all(0),
                    child: CircleAvatar(
                      backgroundImage: ExactAssetImage('images/servi.jpg'),
                      backgroundColor: bleu_F,
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
              child: Text("Vous pouvez faire vos achats, envoyer, transférer en toute sécurité et gratuitement ainsi que gérer votre argent. Tout celà avec un seul compte Sprint Pay",style: TextStyle(
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
                        Container(
                            height: 60.0,
                            width: 60.0,
                            child: CircleAvatar(
                              backgroundImage: ExactAssetImage('images/hand.png'),
                              backgroundColor: Colors.white,
                              //radius: 20,
                            ),
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              border: new Border.all(
                                color: Colors.white,
                                width: 3.0,
                              ),
                            )),
                        Text("DEPÔT/RETRAIT DE FONDS", style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
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
                            height: 60.0,
                            width: 60.0,
                            child: CircleAvatar(
                              backgroundImage: ExactAssetImage('images/qr-code.png'),
                              backgroundColor: Colors.white,
                              //radius: 20,
                            ),
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              border: new Border.all(
                                color: Colors.white,
                                width: 3.0,
                              ),
                            )),
                        Text("PAIEMENT PAR\nQR CODE", style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
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
                            height: 60.0,
                            width: 60.0,
                            child: CircleAvatar(
                              backgroundImage: ExactAssetImage('images/credit-card-2.png'),
                              backgroundColor: Colors.white,
                              //radius: 20,
                            ),
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              border: new Border.all(
                                color: Colors.white,
                                width: 3.0,
                              ),
                            )),
                        Text("CARTES PRÉPAYÉES", style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
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
                            height: 60.0,
                            width: 60.0,
                            child: CircleAvatar(
                              backgroundImage: ExactAssetImage('images/invoice.png'),
                              backgroundColor: Colors.white,
                              //radius: 20,
                            ),
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              border: new Border.all(
                                color: Colors.white,
                                width: 3.0,
                              ),
                            )),
                        Text("RELEVÉ DE COMPTE", style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
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
                        Container(
                            height: 60.0,
                            width: 60.0,
                            child: CircleAvatar(
                              backgroundImage: ExactAssetImage('images/payment-method.png'),
                              backgroundColor: Colors.white,
                              //radius: 20,
                            ),
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              border: new Border.all(
                                color: Colors.white,
                                width: 3.0,
                              ),
                            )),
                        Text("TRANSFERT GRATUIT D'ARGENT", style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
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
                            height: 60.0,
                            width: 60.0,
                            child: CircleAvatar(
                              backgroundImage: ExactAssetImage('images/payment-mobile.png'),
                              backgroundColor: Colors.white,
                              //radius: 20,
                            ),
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              border: new Border.all(
                                color: Colors.white,
                                width: 3.0,
                              ),
                            )),
                        Text("ACHAT DE CREDIT MOBILE", style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
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
                            height: 60.0,
                            width: 60.0,
                            child: CircleAvatar(
                              backgroundImage: ExactAssetImage('images/network.png'),
                              backgroundColor: Colors.white,
                              //radius: 20,
                            ),
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              border: new Border.all(
                                color: Colors.white,
                                width: 3.0,
                              ),
                            )),
                        Text("RESEAU\nSOCIAL", style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold
                        ),textAlign: TextAlign.center)
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: (){
                            this._stock("first", "false");
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
                            this._stock("first", "false");
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
        ),
      ) ,
    );
  }
}
