import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class BrowserScreen extends StatefulWidget {
  final String url;

  BrowserScreen(this.url);

  @override
  _BrowserScreenState createState() => _BrowserScreenState(this.url);

  static successPayment(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "Votre transaction a été pris en compte. Vous recevrez une notification après son traitement."),
                    SizedBox(
                      width: 320.0,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Merci",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: const Color(0xFF1BC0C5),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class _BrowserScreenState extends State<BrowserScreen> {
  final String url;
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  _BrowserScreenState(this.url);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: WebviewScaffold(
      url: url,
      appBar: new AppBar(
          automaticallyImplyLeading: false,
          title: new Text("Paiement"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )),
      hidden: true,
      initialChild: Container(
        color: Colors.white,
        child: const Center(
          child: Text('Waiting.....'),
        ),
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      print(url);
      if (url.contains("cancel") || url.contains("updatepayment")) {
        close();
      }
    });
  }

  void close() {
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    flutterWebviewPlugin.close();
    flutterWebviewPlugin.dispose();
    BrowserScreen.successPayment(context);
  }
}
