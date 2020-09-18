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
      backgroundColor: GRIS,
        appBar: new AppBar(title: new Text("Service client"),
          elevation: 0.0,
          backgroundColor: GRIS,
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
                        padding: EdgeInsets.only(top: 10, left:Index%2 == 0? MediaQuery.of(context).size.width/4:20, right: Index%2 != 0? MediaQuery.of(context).size.width/4:20),
                        child: Container(
                          decoration: BoxDecoration(
                            color:Index%2 == 0? couleur_champ:Colors.white,
                            border: Border.all(
                                color: couleur_champ,
                                width: bordure
                            ),
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
                                    flex:11,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: new Text(litems[Index]),
                                    )),
                                Expanded(
                                    flex:2,
                                    child: new Text("$hour:$minute", style: TextStyle(
                                      color:Index%2 == 0? Colors.white:couleur_champ
                                    ),)),
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
                      height: taille_champ+40,
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                        color: Colors.white,
                        border: Border.all(
                            color: couleur_champ,
                            width: bordure
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 0, top: 12),
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
                        icon: Icon(Icons.play_arrow, color: couleur_champ,)),
                  ),
                )
              ],
            ),
          ],
        ),
    );
  }
}