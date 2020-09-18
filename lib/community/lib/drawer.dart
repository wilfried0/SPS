import 'package:flutter/material.dart';
import 'package:services/auth/connexion.dart';

class MenuLateral extends Drawer{
  MenuLateral({Key key, this.nom, this.solde}):super(key: key);

  final String nom, solde;

  Widget build(BuildContext context) => Drawer(
    child: new Container(
      constraints: new BoxConstraints.expand(
        width: MediaQuery.of(context).size.width - 50,
      ),
      color: Colors.white,
      child: new ListView(
        children: <Widget>[
          //header
          new SizedBox(
            height: 150.0,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: new Icon(
                Icons.account_circle,
                size: 120.0,
                color: Colors.white,
              ),
            ),
          ),
          InkWell(
            onTap: (){
              //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Cagnottes()));
            },
            child: new ListTile(
              title: Text(
                  'SP CAGNOTTES',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  )
              ),
              leading: Icon(
                Icons.language,
                color: Colors.blue,
                size: 35,
              ),
            ),
          ),

          InkWell(
            onTap: (){
              //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Conseils()));
            },
            child: ListTile(
              title: Text('SP TONTINES',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  )),
              leading: Icon(
                Icons.group,
                color: Colors.blue,
                size: 35,
              ),
            ),
          ),

          InkWell(
            onTap: (){
              //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Souscription()));
            },
            child: ListTile(
              title: Text('SP PROJECTS',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  )),
              leading: Icon(
                Icons.account_balance,
                color: Colors.blue,
                size: 35,
              ),
            ),
          ),
          new Divider(
            color: Colors.grey,
          ),
          InkWell(
            onTap: (){
              //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Noservices()));
            },
            child: ListTile(
              title: Text('Service client',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  )),
              leading: Icon(
                Icons.headset_mic,
                color: Colors.blue,
                size: 35,
              ),
            ),
          ),

          InkWell(
            onTap: (){
              //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Sinistre()));
            },
            child: ListTile(
              title: Text('Recommander à un ami',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  )),
              leading: Icon(
                Icons.thumb_up,
                color: Colors.blue,
                size: 35,
              ),
            ),
          ),
          new Divider(
            color: Colors.grey,
          ),
          InkWell(
            onTap: (){
              //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Courriel()));
            },
            child: ListTile(
              title: Text('Configurations',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  )),
              leading: Icon(
                Icons.settings,
                color: Colors.blue,
                size: 35,
              ),
            ),
          ),
          Spacer(),
          InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Connexion()));
            },
            child: ListTile(
              title: Text('Connexion',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  )),
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.blue,
                size: 35,
              ),
            ),
          ),
        ],
      )
    ),
  );
}