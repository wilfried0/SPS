import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:services/accueil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/community/lib/utils/components.dart';
import 'package:services/lang/sit_localizations_delegate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_localizations.dart';
import 'auth/connexion.dart';
import 'composants/components.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(new MaterialApp(
      title: '',
      theme: ThemeData(primaryColor: Colors.white, accentColor: Color(0xFF2A2A42), fontFamily: 'Poppins'),
      debugShowCheckedModeBanner: false,
     localizationsDelegates: [
      // ... app-specific localization delegate[s] here
      const SitLocalizationsDelegate(),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [
      const Locale('fr'), // French
      const Locale('en'), // English
    ],
    localeResolutionCallback: (locale, supportedLocales){
      for(var supportedLocale in supportedLocales){
        if(supportedLocale.languageCode == locale.languageCode && supportedLocale.countryCode == locale.countryCode){
          return supportedLocale;
        }
      }
      return supportedLocales.first;
    },
      home: SplashScreen(),
    ));
  });
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String test, token;

  @override
  void initState(){
    super.initState();
    this.lecture();
    this.save();
    this.lire("first");
    Timer(Duration(seconds: 5), onDoneLoading);
  }

  lecture() async{
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString(TOKEN);
    if(token != null){
      logOut();
    }
  }

  logOut() async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    String url = "$cagnotte_url/user/auth/signout";
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.set('Accept', 'application/json');
    request.headers.set('Authorization', 'Bearer $token');
    HttpClientResponse response = await request.close();
    //String reply = await response.transform(utf8.decoder).join();
  }



  void save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(LIBELLE, null);
    prefs.setString(VISIBLE, null);
    prefs.setString(CATEGORIE, null);
    prefs.setString(MONTANT_CAGNOTTE, null);
    prefs.setString(TOKEN, null);
    prefs.setString(ORIGIN, null);
    prefs.setString(KITTY_IMAGE, null);

    prefs.setString('id', null);
    prefs.setString('nom', null);
    prefs.setString('ville', null);
    prefs.setString('quartier', null);
    prefs.setString('password', null);
    prefs.setString('avatar', null);
    prefs.setString('email', null);
    prefs.setString('pays', null);
    prefs.setString('username', null);
  }


  @override
  Widget build(BuildContext context){
    return new Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            child: new Image.asset('images/logo.png'),
          ),
          new Center(
            child: new Padding(
              padding: EdgeInsets.only(top: 150.0),
              child: Theme(
                  data: Theme.of(context).copyWith(accentColor: couleur_fond_bouton),
                  child: Center(
                      child: CupertinoActivityIndicator(radius: 30,)
                  )
              ),//new CircularProgressIndicator(),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height-40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.copyright, color: couleur_champ,),
                Text("Copyright Sprint-Pay", style: TextStyle(
                    color: couleur_champ,
                  fontStyle: FontStyle.italic
                ),),
              ],
            ),
          )
        ],
      ),
    );
  }

  onDoneLoading() async {
    if(test == 'true'){
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Accueil()));
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Connexion()));
    }
    //Navigator.of(context).pushNamed("/accueil"):Navigator.of(context).pushNamed("/connexion");
  }

  lire(String v) async {
    final prefs = await SharedPreferences.getInstance();
    SharedPreferences.setMockInitialValues({});
    setState(() {
      test = prefs.getString(v)==null?'true':prefs.getString(v);
    });

    print("la valeur test est de ************************** $test");
  }
}