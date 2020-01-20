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
  String text;

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Service client"),
          elevation: 0.0,
        ),
        body: new Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 10,
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 0, top: 20),
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
                Expanded(
                  flex: 2,
                  child: IconButton(iconSize: 30,
                    onPressed: (){
                    setState(() {
                      if(_formKey.currentState.validate()){
                        litems.add(text);
                        eCtrl.clear();
                      }
                    });
                  },
                  icon: Icon(Icons.play_arrow, color: bleu_F,)),
                )
              ],
            ),
            Expanded(
              child: new ListView.builder
                (
                  itemCount: litems.length,
                  itemBuilder: (BuildContext context, int Index) {
                    return Padding(
                      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                      child: new Text(litems[Index]),
                    );
                  }
              ),
            ),
          ],
        ),
    );
  }
}