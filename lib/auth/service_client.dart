import 'package:flutter/material.dart';
import 'package:services/composants/components.dart';

class ListDisplay extends StatefulWidget {
  @override
  State createState() => new DyanmicList();
}

class DyanmicList extends State<ListDisplay> {
  List<String> litems = [];
  final TextEditingController eCtrl = new TextEditingController();
  var _formKey = GlobalKey<FormState>();
  String text, hour, minute;

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Service client"),
          elevation: 0.0,
          leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios,color: couleur_fond_bouton,)
          ),
        ),
        body: new Column(
          children: <Widget>[
            Expanded(
              child: Container(
                height: 300,
                child: new ListView.builder
                  (
                    itemCount: litems.length,
                    itemBuilder: (BuildContext context, int Index) {
                      //List<String> litemsReversed = litems.reversed.toList();
                      hour = "${DateTime.now().hour}";
                      minute = "${DateTime.now().minute}";
                      return Padding(
                        padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: new BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    flex:10,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: new Text(litems[Index]),
                                    )),
                                Expanded(
                                    flex:2,
                                    child: new Text("$hour:$minute")),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                ),
              ),
            ),

            Row(
              children: <Widget>[
                Expanded(
                  flex: 10,
                  child: Form(
                    key: _formKey,
                    child: Container(
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                        color: couleur_champ,
                        border: Border.all(
                            color: Colors.white,
                            width: bordure
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 0),
                        child: new TextFormField(
                            controller: eCtrl,
                            decoration: new InputDecoration.collapsed(
                                hintText: 'Votre message'
                            ),
                            maxLines: null,
                            validator: (String value){
                              if(value.isEmpty){
                                return "Champ message vide !";
                              }else{
                                text = value;
                                return null;
                              }
                            }
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: IconButton(iconSize: 40,
                        onPressed: (){
                          setState(() {
                            if(_formKey.currentState.validate()){
                              litems.add(text);
                              eCtrl.clear();
                            }
                          });
                        },
                        icon: Icon(Icons.play_arrow, color: couleur_decription_page,)),
                  ),
                )
              ],
            ),
          ],
        ),
    );
  }
}