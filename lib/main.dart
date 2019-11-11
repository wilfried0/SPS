import 'dart:async';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth/connexion.dart';
import 'composants/components.dart';
import 'package:http/http.dart' as http;

void main() async{

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  runApp(new MaterialApp(
    title: '',
    theme: ThemeData(primaryColor: Colors.white, accentColor: Color(0xFF2A2A42), fontFamily: 'Poppins'),
    debugShowCheckedModeBanner: false,
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

  @override
  void initState(){
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
    ///
    /// Let's save a pointer to this method, should the user wants to change its language
    /// We would then call: applic.onLocaleChanged(new Locale('en',''));
    ///
    this._read();
    //applic.onLocaleChanged = onLocaleChange;
    Timer(Duration(seconds: 5), onDoneLoading);
  }

  bool myInterceptor(bool stopDefaultButtonEvent) {
    Navigator.pop(context);
    //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Cagnotte('')));
    //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(''), oldWidget: SplashScreen()));
    return true;
  }

  /*onLocaleChange(Locale locale){
    setState((){
    });
  }*/

  void savAll() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('finish', null);
    prefs.setString('route', null);
    prefs.setString('montant', null);
    prefs.setString('libelle', null);
    prefs.setString('myvisible', null);
    prefs.setString('kitty', null);
    prefs.setString('cagnotte', null);
    prefs.setString('macagnot', null);
    prefs.setString('newcagnot', null);
    prefs.setString('codeiso', null);
    prefs.setString('idUser', '-1');
    prefs.setString('descrip', null);
    prefs.setString('monToken', null);
    prefs.setString('wallet', null);
    prefs.setString('montant', null);
    prefs.setString('xaf', null);
  }

  final logout = '$base_url/user/Auth/signout';
  Future<void> logOut() async {
    await http.get(Uri.encodeFull(logout), headers: {"Accept": "application/json", "Authorization": "Bearer $_token"},);
    this.savAll();
  }

  _read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final key = 'monToken';
      _token = prefs.getString(key);
      print(_token);
    });
    logOut();
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
                      child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: bleu_F,
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
    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Cagnotte('')));
    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Connexion()));
    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Configuration('')));
  }
}