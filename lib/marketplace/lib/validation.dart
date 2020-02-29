import 'package:shared_preferences/shared_preferences.dart';
import 'api/BillController.dart';
import 'api/ServerResponseValidator.dart';
import 'colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'utils/SysSnackBar.dart';

class Validation extends StatefulWidget {
  @override
  _ValidationState createState() => _ValidationState();
}

class _ValidationState extends State<Validation> {

  bool isLoding = false;
  var _formKey = GlobalKey<FormState>();
  var ref, verifierId;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool hasError = false;
  ProgressDialog pr;

  @override
  void initState() {
    asyncInit();
    super.initState();
  }

  void asyncInit() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      verifierId = prefs.getString("BUYER_PHONE");
    });
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Traitement encours...");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Vérifier une transaction",
          style: TextStyle(color: couleur_libelle_champ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 0.0),
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  color: Colors.transparent,
                  border: Border.all(width: bordure, color: Colors.green),
                ),
                height: hauteur_champ,
                child: Align(
                  alignment: Alignment.center,
                  child: new TextFormField(
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                        fontSize: taille_libelle_champ + 3,
                        color: couleur_libelle_champ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Champ code de référence vide !';
                      } else {
                        setState(() {
                          ref = value;
                        });
                        return null;
                      }
                    },
                    decoration: InputDecoration.collapsed(
                      hintText: 'Code de référence',
                      hintStyle: TextStyle(
                          color: couleur_libelle_champ,
                          fontSize: taille_libelle_champ + 3),
                      //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      //Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Profile('')));
                      if (_formKey.currentState.validate()) {
                        new BillController().check(ref, verifierId,
                                (List<dynamic> json) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => VerifyDialog(
                                  title: json[0]['requiresMerchantVerification']
                                      ? "Succès"
                                      : "En attente",
                                  description: json[0]
                                  ['requiresMerchantVerification']
                                      ? "Succès"
                                      : "En attente",
                                  buttonText: "Okay",
                                ),
                              );
                            },
                                (ServerResponseValidator validator) {},
                                (ServerResponseValidator
                            validator) {}).catchError((e) {
                          SysSnackBar().error(_scaffoldKey);
                          setState(() {
                            hasError = true;
                          });
                        });
                      }
                    });
                  },
                  child: new Container(
                    height: hauteur_champ,
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: new BoxDecoration(
                      color: Colors.green,
                      border: new Border.all(
                        color: Colors.transparent,
                        width: 0.0,
                      ),
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    child: new Center(
                      child: isLoding == false
                          ? new Text(
                        'Vérifier',
                        style: new TextStyle(
                            fontSize: taille_text_bouton + 3,
                            color: couleur_text_bouton),
                      )
                          : CupertinoActivityIndicator(),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}

class VerifyDialog extends StatelessWidget {
  final String title, description, buttonText;
  final Image image;

  VerifyDialog({
    @required this.title,
    @required this.description,
    @required this.buttonText,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: Consts.padding,
          right: Consts.padding,
          child: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: Consts.avatarRadius,
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            top: Consts.avatarRadius + Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // To close the dialog
                  },
                  child: Text(buttonText),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}