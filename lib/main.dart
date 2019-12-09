import 'dart:async';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:services/accueil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth/connexion.dart';
import 'composants/components.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  runApp(new MaterialApp(
    title: '',
    theme: ThemeData(primaryColor: Colors.white, accentColor: Color(0xFF2A2A42), fontFamily: 'Poppins'),
    debugShowCheckedModeBanner: false,
    routes: <String, WidgetBuilder>{
      "/connexion": (BuildContext context) =>new Connexion(),
      "/accueil": (BuildContext context) =>new Accueil()
    },
    /*localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: [
      const Locale('en', ''),
      const Locale('fr', ''),
    ],*/
    home: SplashScreen(),
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String _token;
  String test;

  @override
  void initState(){
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
    ///
    /// Let's save a pointer to this method, should the user wants to change its language
    /// We would then call: applic.onLocaleChanged(new Locale('en',''));
    ///
    this.lire("first");
    //applic.onLocaleChanged = onLocaleChange;
    Timer(Duration(seconds: 5), onDoneLoading);
  }

  bool myInterceptor(bool stopDefaultButtonEvent) {
    Navigator.pop(context);
    //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Cagnotte('')));
    //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(''), oldWidget: SplashScreen()));
    return true;
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
                  data: Theme.of(context).copyWith(accentColor: Colors.white),
                  child: Center(
                      child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: couleur_fond_bouton,
                          ),
                          child: CupertinoActivityIndicator()
                      )
                  )
              ),//new CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  onDoneLoading() async {
    test == 'true'?Navigator.of(context).pushNamed("/accueil"):Navigator.of(context).pushNamed("/connexion");
  }

  lire(String v) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      test = prefs.getString(v)==null?'true':prefs.getString(v);
    });
  }
}