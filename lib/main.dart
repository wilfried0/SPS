import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:services/accueil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [
      const Locale('en', 'US'), // English
      const Locale('fr', 'FR'), // French
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

  String test;

  @override
  void initState(){
    super.initState();
    this.lire("first");
    Timer(Duration(seconds: 5), onDoneLoading);
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
    setState(() {
      test = prefs.getString(v)==null?'true':prefs.getString(v);
    });
  }
}