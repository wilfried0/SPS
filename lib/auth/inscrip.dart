import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:services/auth/sendpiece.dart';
import 'package:services/composants/components.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Inscrip extends StatefulWidget {
  @override
  _InscripState createState() => _InscripState();
}

class _InscripState extends State<Inscrip> {

  int ad = 3;
  String _birthday="", _current, _url,jr, mo, an, firstname, lastname, town, email, nature, gender, adress, userImage, newPassword, typeMember;
  int _date = new DateTime.now().year, idUser;
  var _categorie = ['Madame', 'Monsieur', 'Mademoiselle'];
  var _nature = ['Particulier', 'Entreprise', 'Association', 'PME', 'Etablissement'];
  var _formKey = GlobalKey<FormState>();
  var _annee = ['1960'];
  var _mois = ['01'];
  var _jour = ['01'];
  bool isLoding =false, _loadImage = false, isClicked = false;
  String _image;
  DateTime _dateTime = DateTime.now();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState(){
    this.getListNature();
    this.lire();
    _url = '$base_url/member';
    super.initState();
    this.ChargeAnnee();
    this.ChargeMois();
    this.ChargeJour();
  }

  ChargeAnnee(){
    for(int i=1961;i<=DateTime.now().year+30;i++){
      _annee.add(i.toString());
    }
    print(_annee);
  }

  ChargeMois(){
    for(int i=2;i<=12;i++){
      if(i<10){
        _mois.add('0'+i.toString());
      }else
        _mois.add(i.toString());
    }
  }

  ChargeJour(){
    for(int i=2;i<=31;i++){
      if(i<10){
        _jour.add('0'+i.toString());
      }else
        _jour.add(i.toString());
    }
  }

  Future<String> getListNature() async {
    var headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    http.Response response = await http.get("http://74.208.183.205:8086/spkycgateway/api/administration/getNatureClientByService/773", headers: headers);
    final int statusCode = response.statusCode;
    if(statusCode == 200){
      List responseJson = json.decode(response.body);
      _nature = [];
      setState(() {
        for(int i=0; i<responseJson.length; i++)
          _nature.add(responseJson[i]['name']);
      });
    }
    return null;
  }

  bool isEmail(String em) {
    if(em == null){
      return true;
    }else {
      String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp(p);
      return regExp.hasMatch(em);
    }
  }

  Future<String> checkEmail(var body) async {
    var headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    print("mon $email");
    //var url = "${this._url}$email";
    http.Response response = await http.get("$_url/checkEmail/$email", headers: headers);
    final int statusCode = response.statusCode;
    print("1 $_url/checkEmail/$email");
    print("2 $statusCode");
    if(statusCode == 200){
      var responseJson = json.decode(response.body);
      print(responseJson);
      if(responseJson['isExist'] == false){
        createAccount(body);
      }else{
        showInSnackBar("$email existe déjà!");
      }
    }else{
      showInSnackBar("Erreur lors de la récupération des données");
    }
    return null;
  }

  Future<String> getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      print(image);
      setState(() {
        _loadImage = false;
      });
      Upload(image);
    return null;
  }

  void Upload(File imageFile) async {
    var _header = {
      "content-type" : 'multipart/form-data',
    };
    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var multipartFile = new http.MultipartFile('file', stream, length, filename: imageFile.path.split('/').last);
    var uri = Uri.parse('http://74.208.183.205:8086/spkyc-identitymanager/upload');
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(_header);
    request.files.add(multipartFile);
    var response = await request.send();
    print('request ${response.request}');
    print('statuscode ${response.statusCode}');
    if(response.statusCode == 201){
      setState(() {
        _loadImage = false;
      });
      response.stream.transform(utf8.decoder).listen((value) {
        setState(() {
          _image = value;
          _loadImage = false;
        });
      });

    }else{
      print(response.request);
      setState(() {
        _loadImage = false;
      });
    }
  }

  /*Future _selectDate() async {
    print(_date);
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime(1960),
        firstDate: new DateTime(1960),
        //locale : const Locale("fr","FR"),
        lastDate: new DateTime(_date+1)
    );
    if(picked != null) setState(
       () => _birthday = picked.toString().split(" ")[0] //.replaceAll("-", "/")
    );
  }*/

  lire() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      idUser = int.parse(prefs.getString("idUser"));
      newPassword = prefs.getString("password");
      print(idUser);
    });
  }

  void _reg() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('avatar', "$_image");
  }

  //final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white, accentColor: Color(0xFF2A2A42), fontFamily: 'Poppins'),
      /*routes: <String, WidgetBuilder>{
        "/profil": (BuildContext context) =>new Profile(''),
        "/connexion": (BuildContext context) =>new Connexion(),
      },*/
      home: Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    SizedBox(
                      height: 330,
                      width: MediaQuery.of(context).size.width,
                      child: DrawerHeader(
                        decoration: BoxDecoration(
                            color: couleur_fond_bouton
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                child: Container(
                                  height: 230,
                                  width: 230,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: _image==null? AssetImage("images/ellipse1.png"):NetworkImage(_image),
                                          fit: BoxFit.cover
                                      )
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: new EdgeInsets.only(
                        top: 50,
                          right:0.0,
                          left: MediaQuery.of(context).size.width-70),
                      child: InkWell(
                        onTap: () async {
                          setState(() {
                            _loadImage = true;
                          });
                          getImage();
                        },
                        child:_loadImage==false? Icon(Icons.camera_alt,size: 50, color: Colors.white,):
                        CupertinoActivityIndicator(radius: 25,),
                      ),
                    ),
                  ],
                ),

                /*Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                    child: Text("L'adresse email est facultative", style: TextStyle(
                      color: couleur_libelle_champ,
                    ),textAlign: TextAlign.left,),
                  ),
                ),*/

                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                  child: Container(
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                      color: Colors.transparent,
                      border: Border.all(
                          color: couleur_bordure,
                          width: bordure
                      ),
                    ),
                    height: hauteur_champ,
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                          flex:2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new Icon(Icons.group, color: couleur_decription_page,),
                          ),
                        ),
                        Expanded(
                          flex: 10,
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                icon: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: new Icon(Icons.arrow_drop_down_circle,
                                    color: couleur_fond_bouton,),
                                ),
                                isDense: false,
                                elevation: 1,
                                isExpanded: true,
                                onChanged: (String selected){
                                  setState(() {
                                    _current = selected;
                                    print(_current);
                                    gender = getGender(_current);
                                    print(gender);
                                  });
                                },
                                value: _current,
                                hint: Text('Mme/M/Mlle',
                                  style: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize:taille_champ+ad,
                                  ),),
                                items: _categorie.map((String name){
                                  return DropdownMenuItem<String>(
                                    value: name,
                                    child: Text(name,
                                      style: TextStyle(
                                        color: couleur_libelle_champ,
                                        fontSize:taille_champ+ad,
                                      ),),
                                  );
                                }).toList(),
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                  child: Container(
                    decoration: new BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                          color: couleur_bordure,
                          width: bordure
                      ),
                    ),
                    height: hauteur_champ,
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                          flex:2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new Icon(Icons.assignment_ind, color: couleur_decription_page,),
                          ),
                        ),
                        Expanded(
                          flex: 10,
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                icon: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: new Icon(Icons.arrow_drop_down_circle,
                                    color: couleur_fond_bouton,),
                                ),
                                isDense: false,
                                elevation: 1,
                                isExpanded: true,
                                onChanged: (String selected){
                                  setState(() {
                                    nature = selected;
                                  });
                                },
                                value: nature,
                                hint:Text('Sélectionner votre nature',
                                  style: TextStyle(
                                    color: couleur_libelle_champ,
                                    fontSize:taille_champ+ad,
                                  ),),
                                items: _nature.map((String name){
                                  return DropdownMenuItem<String>(
                                    value: name,
                                    child: Text(name,
                                      style: TextStyle(
                                        color: couleur_libelle_champ,
                                        fontSize:taille_champ+ad,
                                      ),),
                                  );
                                }).toList(),
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 0.0),
                    decoration: new BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        width: bordure,
                        color: couleur_bordure,
                      ),
                    ),
                    height: hauteur_champ,
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                          flex:2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new Icon(Icons.person, color: couleur_decription_page,),//
                          ),
                        ),
                        new Expanded(
                          flex:10,
                          child: Padding(
                            padding: EdgeInsets.only(left:0.0),
                            child: new TextFormField(
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                fontSize: taille_champ+ad,
                                color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  firstname = "";
                                  return null;
                                }else{
                                  firstname = value;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Prénom(s)',
                                hintStyle: TextStyle(color: couleur_libelle_champ,
                                    fontSize: taille_champ+ad
                                ),
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 0.0),
                    decoration: new BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        width: bordure,
                        color: couleur_bordure,
                      ),
                    ),
                    height: hauteur_champ,
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                          flex:2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new Icon(Icons.person, color: couleur_decription_page,),//Image.asset('images/Groupe177.png'),
                          ),
                        ),
                        new Expanded(
                          flex:10,
                          child: Padding(
                            padding: EdgeInsets.only(left:0.0),
                            child: new TextFormField(
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                fontSize: taille_champ+ad,
                                color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return "Champ nom vide !";
                                }else{
                                  lastname = value;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Nom(s)',
                                hintStyle: TextStyle(color: couleur_libelle_champ,
                                    fontSize: taille_champ+ad
                                ),
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 0.0),
                    decoration: new BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        width: bordure,
                        color: couleur_bordure,
                      ),
                    ),
                    height: hauteur_champ,
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                          flex:2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new Icon(Icons.email, color: couleur_decription_page,),//Image.asset('images/Groupe177.png'),
                          ),
                        ),
                        new Expanded(
                          flex:10,
                          child: Padding(
                            padding: EdgeInsets.only(left:0.0),
                            child: new TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                fontSize: taille_champ+ad,
                                color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return "Champ email vide!";
                                }else{
                                  email = value;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Email',
                                hintStyle: TextStyle(color: couleur_libelle_champ,
                                    fontSize: taille_champ+ad
                                ),
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /*Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 0.0),
                    decoration: new BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        width: bordure,
                        color: couleur_bordure,
                      ),
                    ),
                    height: hauteur_champ,
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                          flex:2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new Icon(Icons.add_location, color: couleur_decription_page,),//Image.asset('images/Groupe177.png'),
                          ),
                        ),
                        new Expanded(
                          flex:10,
                          child: Padding(
                            padding: EdgeInsets.only(left:0.0),
                            child: new TextFormField(
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                fontSize: taille_champ+ad,
                                color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return "Champ ville vide !";
                                }else{
                                  town = value;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Ville',
                                hintStyle: TextStyle(color: couleur_libelle_champ,
                                    fontSize: taille_champ+ad
                                ),
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),*/

                /*Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 0.0),
                    decoration: new BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        width: bordure,
                        color: couleur_bordure,
                      ),
                    ),
                    height: hauteur_champ,
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                          flex:2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new Icon(Icons.location_on, color: couleur_decription_page,),//Image.asset('images/Groupe177.png'),
                          ),
                        ),
                        new Expanded(
                          flex:10,
                          child: Padding(
                            padding: EdgeInsets.only(left:0.0),
                            child: new TextFormField(
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                fontSize: taille_champ+ad,
                                color: couleur_libelle_champ,
                              ),
                              validator: (String value){
                                if(value.isEmpty){
                                  return "Champ adresse vide !";
                                }else{
                                  adress = value;
                                  return null;
                                }
                              },
                              decoration: InputDecoration.collapsed(
                                hintText: 'Adresse/Quartier',
                                hintStyle: TextStyle(color: couleur_libelle_champ,
                                    fontSize: taille_champ+ad
                                ),
                                //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),*/

                isClicked == true?Container():Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 0.0),
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.only(
                        bottomRight: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                      ),
                      color: Colors.transparent,
                      border: Border.all(
                        width: bordure,
                        color: couleur_bordure,
                      ),
                    ),
                    height: hauteur_champ,
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                          flex:2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new Icon(Icons.calendar_today, color: couleur_decription_page,),//Image.asset('images/Groupe177.png'),
                          ),
                        ),
                        new Expanded(
                          flex:10,
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                isClicked = true;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 0.0),
                              decoration: new BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                  width: bordure,
                                  color: Colors.transparent,
                                ),
                              ),
                              height: hauteur_champ,
                              child: Row(
                                children: <Widget>[
                                  new Expanded(
                                    flex:12,
                                    child: new TextFormField(
                                      keyboardType: TextInputType.text,
                                      enabled: false,
                                      style: TextStyle(
                                        fontSize: taille_champ+ad,
                                        color: couleur_libelle_champ,
                                      ),
                                      validator: (String value){
                                        if(value.isEmpty){
                                          return null;
                                        }else{
                                          _birthday = value;
                                          return null;
                                        }

                                      },
                                      decoration: InputDecoration.collapsed(
                                        hintText: _birthday.isEmpty?'Date de naissance':_birthday,
                                        hintStyle: TextStyle(color: couleur_libelle_champ,
                                          fontSize: taille_champ+ad,
                                        ),
                                        //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                isClicked == false?Container():Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 0.0),
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.only(
                        bottomRight: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                      ),
                      color: Colors.transparent,
                      border: Border.all(
                        width: bordure,
                        color: couleur_bordure,
                      ),
                    ),
                    height: hauteur_champ,
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                          flex:2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new Icon(Icons.calendar_today, color: couleur_decription_page,),//Image.asset('images/Groupe177.png'),
                          ),
                        ),
                        Expanded(
                          flex:3,
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isDense: true,
                                elevation: 1,
                                isExpanded: true,
                                onChanged: (String selected){
                                  setState(() {
                                    jr = selected;
                                  });
                                },
                                value: jr,
                                hint: Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text('Jour',
                                    style: TextStyle(
                                      color: couleur_libelle_champ,
                                      fontSize:taille_champ+3,
                                    ),),
                                ),
                                items: _jour.map((String name){
                                  return DropdownMenuItem<String>(
                                    value: name,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text(name,
                                        style: TextStyle(
                                            color: couleur_libelle_champ,
                                            fontSize:taille_champ+3,
                                            fontWeight: FontWeight.normal
                                        ),),
                                    ),
                                  );
                                }).toList(),
                              )
                          ),
                        ),
                        Expanded(
                          flex:3,
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isDense: true,
                                elevation: 1,
                                isExpanded: true,
                                onChanged: (String selected){
                                  setState(() {
                                    mo = selected;
                                  });
                                },
                                value: mo,
                                hint: Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text('Mois',
                                    style: TextStyle(
                                      color: couleur_libelle_champ,
                                      fontSize:taille_champ+3,
                                    ),),
                                ),
                                items: _mois.map((String name){
                                  return DropdownMenuItem<String>(
                                    value: name,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text(name,
                                        style: TextStyle(
                                            color: couleur_libelle_champ,
                                            fontSize:taille_champ+3,
                                            fontWeight: FontWeight.normal
                                        ),),
                                    ),
                                  );
                                }).toList(),
                              )
                          ),
                        ),
                        Expanded(
                          flex:4,
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isDense: true,
                                elevation: 1,
                                isExpanded: true,
                                onChanged: (String selected){
                                  setState(() {
                                    an = selected;
                                  });
                                },
                                value: an,
                                hint: Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text('Année',
                                    style: TextStyle(
                                      color: couleur_libelle_champ,
                                      fontSize:taille_champ+3,
                                    ),),
                                ),
                                items: _annee.map((String name){
                                  return DropdownMenuItem<String>(
                                    value: name,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text(name,
                                        style: TextStyle(
                                            color: couleur_libelle_champ,
                                            fontSize:taille_champ+3,
                                            fontWeight: FontWeight.normal
                                        ),),
                                    ),
                                  );
                                }).toList(),
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10),
                  child: new GestureDetector(
                    onTap: () {
                      setState(() {
                        if(_formKey.currentState.validate()){
                          if(isEmail(email)==true){
                            if(jr != null && mo != null && an != null){
                              _birthday = "$an-$mo-$jr";
                              if(gender != null){
                                if(nature != null){
                                  var createAccount = new createMemberAccount(
                                      id_user: this.idUser,
                                      firstname: this.firstname,
                                      lastname: this.lastname,
                                      town: "",
                                      birthday: this._birthday,
                                      email: this.email==null?"":this.email,
                                      nature: this.nature,
                                      gender: this.gender,
                                      adress: "",
                                      userImage: "$_image",
                                      newPassword: this.newPassword,
                                      typeMember: "MSP",
                                      roleId: 1
                                  );
                                  print(json.encode(createAccount));
                                  this.checkConnection(json.encode(createAccount));
                                }else{
                                  showInSnackBar("Sélectionner la nature du client");
                                }
                              }else{
                                showInSnackBar("Sélectionner un genre Mme/M/Mlle");
                              }
                            }else{
                              showInSnackBar("Date de naissance vide!");
                            }
                          }else{
                            showInSnackBar("Email invalide!");
                          }
                        }
                      });
                    },
                    child: new Container(
                      height: hauteur_champ,
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: new BoxDecoration(
                        color: couleur_fond_bouton,
                        border: new Border.all(
                          color: Colors.transparent,
                          width: 0.0,
                        ),
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      child: new Center(
                          child: isLoding == false? new Text('Valider', style: new TextStyle(fontSize: taille_text_bouton+ad, color: couleur_text_bouton),):
                              CupertinoActivityIndicator()
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: barreBottom,
      ),
    );
  }

  void checkConnection(var body) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      //print("Connected to Mobile");
      setState(() {
        isLoding = true;
        this.checkEmail(body);
      });
      //this.getUser();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Connexion(_code)));
      setState(() {
        isLoding = true;
        this.checkEmail(body);
      });
      //this.getUser();
    } else {
      _ackAlert(context);
    }
  }

  Future<String> createAccount(var body) async {
    var _header = {
      "accept": "application/json",
      "content-type" : "application/json"
    };
    print("$_url/createMember");
    return await http.post("$_url/createMember", body: body, headers: _header, encoding: Encoding.getByName("utf-8")).then((http.Response response) {
      final int statusCode = response.statusCode;
      print('voici le statusCode $statusCode');
      print('voici le body ${response.body}');
      if (statusCode < 200 || json == null) {
        setState(() {
          isLoding =false;
        });
        throw new Exception("Error while fetching data");
      }else if(statusCode == 200){
        var responseJson = json.decode(response.body);
        print(responseJson);
        setState(() {
          isLoding =false;
        });
        if(responseJson['username'] == "CLIENT_NOT_MATURE"){
          showInSnackBar("Echec de la création. Client immature!");
        }else{
          this._reg();
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Sendpiece()));
        }
        //    navigatorKey.currentState.pushNamed("/connexion");
      }else {
        setState(() {
          isLoding =false;
        });
        showInSnackBar("Service indisponible!");
      }
      return response.body;
    });
  }

  Future<void> _ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Oops!'),
          content: const Text('Vérifier votre connexion internet.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String getGender(String selected){
    if(selected == 'Madame'){
      gender = 'Mme';
    }else if(selected == 'Monsieur'){
      gender = 'M';
    }else{
      gender = 'Mlle';
    }
    return gender;
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text(value,style:
        TextStyle(
            color: Colors.white,
            fontSize: taille_description_champ+ad
        ),
          textAlign: TextAlign.center,),
          backgroundColor: couleur_fond_bouton,
          duration: Duration(seconds: 5),));
  }
}

class createMemberAccount {
  final int id_user;
  final String firstname;
  final String lastname;
  final String town;
  final String birthday;
  final String email;
  final String nature;
  final String gender;
  final String adress;
  final String userImage;
  final String newPassword;
  final String typeMember;
  final int roleId;


  createMemberAccount({this.id_user, this.firstname, this.lastname, this.town, this.birthday, this.email, this.nature, this.gender, this.adress, this.userImage, this.newPassword, this.typeMember, this.roleId});

  createMemberAccount.fromJson(Map<String, dynamic> json)
      : id_user = json['id_user'],
        firstname = json['firstname'],
        lastname = json['lastname'],
        town = json['town'],
        birthday = json['birthday'],
        email = json['email'],
        nature = json['nature'],
        gender = json['gender'],
        adress = json['adress'],
        userImage = json['userImage'],
        newPassword = json['newPassword'],
        typeMember = json['typeMember'],
        roleId = json['roleId'];

  Map<String, dynamic> toJson() =>
      {
        "id_user": id_user,
        "firstname": firstname,
        "lastname": lastname,
        "town": town,
        "birthday": birthday,
        "email": email,
        "nature": nature,
        "gender": gender,
        "adress": adress,
        "userImage": userImage,
        "newPassword": newPassword,
        "typeMember": typeMember,
        "roleId": roleId,
      };
}
