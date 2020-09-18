import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'alert',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Mapage(),
    );
  }
}


class Mapage extends StatefulWidget {
  @override
  _MapageState createState() => _MapageState();
}

class _MapageState extends State<Mapage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("alert"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new RaisedButton(
              onPressed: () {
                _ackAlert(context);
              },
              child: const Text("Afficher une simple alert"),
            ),


          ],
        ),
      ),
    );
  }
}



Future<void> _ackAlert(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Simple alert'),
        content: const Text('Vous voulez Télécharger quelque chose?'),
        actions: <Widget>[
          FlatButton(
            child: Text('oui'),
            onPressed: () {
              _asyncConfirmDialog(context);
            },
          ),
        ],
      );
    },
  );
}
enum ConfirmAction { CANCEL, ACCEPT }
Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Un bon cours'),
        content: const Text(
            'Téléchargez alors!'),
        actions: <Widget>[
          FlatButton(
            child: const Text('Pas besoin'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.CANCEL);
            },
          ),
          RaisedButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          )
        ],
      );
    },
  );
}



class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _state = 0;

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new AlertDialog(
              title: Text('ALERT!'),
              content: const Text('Vous pouvez Télécharger'),
              actions: <Widget>[
                MaterialButton(
                  child: setUpButtonChild(),
                  onPressed: () {
                    setState(() {
                      if (_state == 0) {
                        animateButton();
                      }
                    });
                  },
                  elevation: 4.0,
                  //minWidth: double.infinity,
                  height: 48.0,
                  color: Colors.blue,
                )
              ],
            )

          ],
        ),
      );

  }

  Widget setUpButtonChild() {
    if (_state == 0) {
      return new Text(
        "Clic ici pour télécharger",
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
      );
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  void animateButton() {
    setState(() {
      _state = 1;
    });

    Timer(Duration(milliseconds: 3300), () {
      setState(() {
        _state = 2;
      });
    });
  }
}




//import 'package:flutter/material.dart';

/*void main() {
  runApp(new MaterialApp(home: new MyApp()));
}


class MyApp extends StatefulWidget {

  MyApp({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("alert"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new RaisedButton(
              onPressed: () {
                _ackAlert(context);
              },
              child: const Text("Afficher une simple alert"),
            ),


          ],
        ),
      ),
    );
  }
}



Future<void> _ackAlert(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Simple alert'),
        content: const Text('Vous voulez Télécharger quelque chose?'),
        actions: <Widget>[
          FlatButton(
            child: Text('oui'),
            onPressed: () {
              _asyncConfirmDialog(context);
            },
          ),
        ],
      );
    },
  );
}
enum ConfirmAction { CANCEL, ACCEPT }
Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Un bon cours'),
        content: const Text(
            'Téléchargez alors!'),
        actions: <Widget>[
          FlatButton(
            child: const Text('Pas besoin'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.CANCEL);
            },
          ),
          RaisedButton(
            child: const Text('Ok'),
            onPressed: () {
              //_cicle(context);
              return new CircularProgressIndicator(
              value: null,
              strokeWidth: 7.0,
              );
            },
          )
        ],
      );
    },
  );
}




Future<String> _cicle(BuildContext context) async {
  String teamName = '';
  return showDialog<String>(
    context: context,
    barrierDismissible: false, // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        content: new Row(
          children: <Widget>[
            new Expanded(
        child: new SizedBox(
          height: 50.0,
          width: 50.0,
          child: new CircularProgressIndicator(
            value: null,
            strokeWidth: 7.0,
          ),
        ),
      ),
      ],
        ),
      );
    },
  );
}*/




/*import 'package:flutter/material.dart';

void main()=>runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("alert"),
      ),

      body: Container(
        child: RaisedButton(
            child: Text("valider ici!"),
            color: Colors.amber,
            elevation: 20,
            onPressed: null
        ),
      ),
    );
  }
}

class Button extends StatefulWidget {
  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text("Valider pou télécharger maintenant"),
          RaisedButton(
              onPressed: null
          )
        ],
      ),
    );
  }
}*/


