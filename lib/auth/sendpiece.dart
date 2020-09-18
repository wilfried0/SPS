import 'dart:convert';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:services/auth/inscrip.dart';
import 'package:services/composants/components.dart';
import 'package:services/composants/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:async/async.dart';
import 'connexion.dart';
import 'package:http_parser/http_parser.dart';

class Sendpiece extends StatefulWidget {
  @override
  _SendpieceState createState() => _SendpieceState();
}

class _SendpieceState extends State<Sendpiece> {

  var _categorie = ['Carte Nationale d\'identité', 'Passeport', 'Carte de séjour'];
  bool isLoding = false, isLoadPiece = false, _isSelfie = false, _isRecto = false, _isVerso = false;
  String _selfie, _recto, _verso, _username, _password, pieceName;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Dio dio = new Dio();

  void checkConnection(var body) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      //print("Connected to Mobile");
      setState(() {
        isLoadPiece = true;
      });
      sendPiece(body);
    } else if (connectivityResult == ConnectivityResult.wifi) {
      //Navigator.of(context).push(SlideLeftRoute(enterWidget: Cagnotte(_code), oldWidget: Connexion(_code)));
      setState(() {
        isLoadPiece = true;
      });
      sendPiece(body);
    } else {
      _ackAlert(context, -1);
    }
  }

  Future<String> sendPiece(var body) async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString("username");
    _password = prefs.getString("password");
    var bytes = utf8.encode('$_username:$_password');
    var credentials = base64.encode(bytes);
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse("$base_url/sendPiece"));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json');
    request.headers.set('Authorization', 'Basic $credentials');
    request.add(utf8.encode(body));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print("statusCode ${response.statusCode}");
    print("body $reply");
      if (response.statusCode < 200 || json == null) {
        setState(() {
          isLoadPiece =false;
        });
      }else if(response.statusCode == 200){
        var responseJson = json.decode(reply);
        print(responseJson);
        setState(() {
          isLoadPiece =false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Connexion()));
      }else{
        setState(() {
          isLoadPiece =false;
        });
        showInSnackBar("Service indisponible!", _scaffoldKey, 5);
      }
      return null;
  }

  /*Future getImage(int q) async {
    var image = await ImagePickerGC.pickImage(
        context: context,
        source: q==1||q==2||q ==3?ImgSource.Gallery:ImgSource.Camera,
        cameraIcon: Icon(
          Icons.camera_alt,
          color: Colors.red,
        ),//cameraIcon and galleryIcon can change. If no icon provided default icon will be present
    );
    if(q == 1){
      setState(() {
        _isSelfie = true;
      });
    }else if(q == 2){
      setState(() {
        _isRecto = true;
      });
    }else if(q == 3){
      setState(() {
        _isVerso = true;
      });
    }else if(q == 4){
      print("q vaut: $q");
      setState(() {
        //_isAvatar = true;
      });
    }else if(q == 5){
      setState(() {
        _isSelfie = true;
      });
    }else if(q == 6){
      setState(() {
        _isRecto = true;
      });
    }else if(q == 7){
      setState(() {
        _isVerso = true;
      });
    }
    print("%%%%%%%%%%%%%%%%%%%%%%%%%% $image");
    if(image == null){
      setState(() {
        _isSelfie = false;
        _isRecto = false;
        _isVerso = false;
      });
    }else
      Upload(image, q);
  }*/


  Future<String> getImage(int q) async {
      var image;
      if(q == 1){
        image = await ImagePicker.pickImage(source: ImageSource.gallery);
        setState(() {
          _isSelfie = true;
        });
      }else if(q == 2){
        image = await ImagePicker.pickImage(source: ImageSource.gallery);
        setState(() {
          _isRecto = true;
        });
      }else if(q == 3){
        image = await ImagePicker.pickImage(source: ImageSource.gallery);
        setState(() {
          _isVerso = true;
        });
      }else if(q == 4){
        print("q vaut: $q");
        image = await ImagePicker.pickImage(source: ImageSource.camera);
        setState(() {
          //_isAvatar = true;
        });
      }else if(q == 5){
        image = await ImagePicker.pickImage(source: ImageSource.camera);
        setState(() {
          _isSelfie = true;
        });
      }else if(q == 6){
        image = await ImagePicker.pickImage(source: ImageSource.camera);
        setState(() {
          _isRecto = true;
        });
      }else if(q == 7){
        image = await ImagePicker.pickImage(source: ImageSource.camera);
        setState(() {
          _isVerso = true;
        });
      }
      print("%%%%%%%%%%%%%%%%%%%%%%%%%% $image");
      if(image == null){
        setState(() {
          //_isAvatar = false;
          _isSelfie = false;
          _isRecto = false;
          _isVerso = false;
        });
      }else
        Upload(image, q);
      return null;
    }


    Future<void> _ackAlert(BuildContext context, int q) {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(q == -1?'Oops!':'Caméra/Galerie'),
            content: Text(q == -1?'Vérifier votre connexion internet.':'Prendre l\'image depuis la Galerie ou la caméra'),
            actions: <Widget>[
              FlatButton(
                child: Text(q == -1?'Ok':'Galerie'),
                onPressed: () {
                  if(q == 0){//Galerie pour avatar
                    Navigator.of(context).pop();
                    getImage(0);
                  }else if(q == -1){
                    Navigator.of(context).pop();
                  }else if(q == 1){//Galerie pour selfie
                    Navigator.of(context).pop();
                    getImage(1);
                  }else if(q == 2){//Galerie pour recto
                    Navigator.of(context).pop();
                    getImage(2);
                  }else if(q == 3){//Galerie pour recto
                    Navigator.of(context).pop();
                    getImage(3);
                  }
                },
              ),
              q == -1?Container():FlatButton(
                child: Text('Caméra'),
                onPressed: () {
                  if(q == 0){//Caméra pour l'avatar
                    Navigator.of(context).pop();
                    getImage(4);
                  }else if(q == 1){//Caméra pour le selfie
                    Navigator.of(context).pop();
                    getImage(5);
                  }else if(q == 2){//Caméra pour le recto
                    Navigator.of(context).pop();
                    getImage(6);
                  }else if(q == 3){//Caméra pour le verso
                    Navigator.of(context).pop();
                    getImage(7);
                  }
                },
              ),
              q == -1?Container():FlatButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  }, child: Text('Annuler')
              )
            ],
          );
        },
      );
    }

  /*Future compressNow(File _imageFile, int q) async {
    print("FILE SIZE BEFORE: " + _imageFile.lengthSync().toString());
    await CompressImage.compress(imageSrc: _imageFile.path, desiredQuality: 80); //desiredQuality ranges from 0 to 100
    print("FILE SIZE  AFTER: " + _imageFile.lengthSync().toString());
    Upload(_imageFile, q);
  }*/

    void _Upload(File imageFile, int q) async {
      var _header = {
        "content-type" :  "multipart/form-data",
      };

      var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      print("taille: $length");
      var multipartFile = new http.MultipartFile('file', stream, length, filename: imageFile.path.split('/').last);
      var uri = Uri.parse('$base');
      print("endpoint upload: $base");
      var request = new http.MultipartRequest("POST", uri);
      request.headers.addAll(_header);
      request.files.add(multipartFile);
      //request.files.add(await http.MultipartFile.fromPath('file', imageFile.path, contentType: new MediaType('image', 'jpeg')));
      var response = await request.send();
      print('la valeur de q: $q');
      print('statuscode ${response.statusCode}');
      if(response.statusCode == 201){
        response.stream.transform(utf8.decoder).listen((value) {
          print("la valeur: $value");
          if(q == 1 || q == 5){
            setState(() {
              _selfie = value;
              _isSelfie = false;
            });
          }else if(q == 2 || q == 6){
            setState(() {
              _recto = value;
              _isRecto = false;
            });
          }else if(q == 3 || q == 7){
            setState(() {
              _verso = value;
              print("Mon verso $_verso");
              _isVerso = false;
              print("Mon versoooooo $value");
            });
          }
        });
      } else{
        response.stream.transform(utf8.decoder).listen((value) {
          print("la valeur: $value");
        });
        if(q == 1 || q == 5){
          setState(() {
            _isSelfie = false;
          });
        }else if(q == 2 || q == 6){
          setState(() {
            _isRecto = false;
          });
        }else if(q == 3 || q == 7){
          setState(() {
            _isVerso = false;
          });
        }
        showInSnackBar("Veuillez sélectionner une image de petite taille", _scaffoldKey, 5);
      }
    }

  // ignore: non_constant_identifier_names
  Upload(File image, int q) async{
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
    };
    Response response;
    try{
      String filename = image.path.split('/').last;
      var formData = new FormData.fromMap({
        "file": await MultipartFile.fromFile(image.path, filename: filename, contentType: MediaType('image', 'jpg')),
      });
      response = await dio.post("$base",data: formData, options: Options(
          headers: {
            'Content-type': 'multipart/form-data',
            'Accept': 'application/json'
          }
      ));
      if(response.statusCode == 200){
        if(q == 1 || q == 5){
          setState(() {
            _selfie = response.data['url'];
            _isSelfie = false;
          });
        }else if(q == 2 || q == 6){
          setState(() {
            _recto = response.data['url'];
            _isRecto = false;
          });
        }else if(q == 3 || q == 7){
          setState(() {
            _verso = response.data['url'];
            print("Mon verso $_verso");
            _isVerso = false;
          });
        }
        showInSnackBar("Téléchargement de l'image réussi avec succès.", _scaffoldKey, 5);
      }else{
        if(q == 1 || q == 5){
          setState(() {
            _isSelfie = false;
          });
        }else if(q == 2 || q == 6){
          setState(() {
            _isRecto = false;
          });
        }else if(q == 3 || q == 7){
          setState(() {
            _isVerso = false;
          });
        }
        showInSnackBar("Service indisponible, reessayez plus tard!", _scaffoldKey, 5);
      }
    }catch(e){
      print("l'erreur dio: $e");
      if(q == 1 || q == 5){
        setState(() {
          _isSelfie = false;
        });
      }else if(q == 2 || q == 6){
        setState(() {
          _isRecto = false;
        });
      }else if(q == 3 || q == 7){
        setState(() {
          _isVerso = false;
        });
      }
      showInSnackBar("Service indisponible, reessayez plus tard!", _scaffoldKey, 5);
    }
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: GRIS,
        key: _scaffoldKey,
        appBar: new AppBar(
          title: Center(child: Text("Envoyer vos pièces",style: TextStyle(
              color: couleur_libelle_champ,
              fontSize: taille_champ+3
          ),)),
          elevation: 0.0,
          backgroundColor: GRIS,
          flexibleSpace: barreTop,
          iconTheme: new IconThemeData(color: couleur_fond_bouton),
          leading: IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Inscrip()));
              },
              icon: Icon(Icons.arrow_back_ios,color: couleur_fond_bouton,)
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Text("Pour effectuer vos opérations, vous devez envoyer votre photo (taille 4X4), appelée selfie, le recto et le verso d'une des pièces d'identité citées.\n\nVotre photo selfie ne doit pas contenir de lunettes, encore moins de chapeau ni de filtre.\n\nLes données incrites sur la pièce à envoyer doivent être lisibles.", style: TextStyle(
                    color: couleur_libelle_champ,
                    fontSize: taille_champ+3,
                    fontWeight: FontWeight.bold
                ),textAlign: TextAlign.justify,),
              ),

              Padding(
                padding: EdgeInsets.only(top: 30),
                child:_selfie==null?GestureDetector(
                  onTap: () async {
                    _ackAlert(context, 1);
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      _isSelfie == false?Icon(Icons.camera_alt, color: couleur_champ,size: 250,):CupertinoActivityIndicator(radius: 40,),
                      Padding(
                        padding: EdgeInsets.only(top: 205),
                        child: Text("Ma photo", style: TextStyle(
                            color: couleur_fond_bouton,
                            fontSize: taille_champ+3
                        ),),
                      )
                    ],
                  ),
                ): Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.width,
                      //width: 200,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                            image: NetworkImage(_selfie),
                            fit: BoxFit.cover,
                          )
                      ),
                      child: Image.network(_selfie, fit: BoxFit.contain,
                          loadingBuilder: (BuildContext ctx, Widget child, ImageChunkEvent loadingProgress){
                            if (loadingProgress == null) return Container();
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null ?
                                loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            );
                          }
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        _ackAlert(context, 1);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Modifier le selfie"),
                          Icon(Icons.camera_alt, color: couleur_champ,size: 50,),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: Container(
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    ),
                    color: Colors.white,
                    border: Border.all(
                        color: couleur_bordure,
                        width: bordure
                    ),
                  ),
                  height: hauteur_champ,
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        icon: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: new Icon(Icons.arrow_drop_down_circle,
                            color: couleur_fond_bouton,),
                        ),
                        isDense: true,
                        elevation: 1,
                        isExpanded: true,
                        onChanged: (String selected){
                          setState(() {
                            pieceName = "$selected";
                          });
                        },
                        value: pieceName,
                        hint: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text('Choisissez la nature de votre pièce d\'identité',
                            style: TextStyle(
                              color: couleur_libelle_champ,
                              fontSize:taille_champ+3,
                            ),),
                        ),
                        items: _categorie.map((String name){
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
              ),


              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: GestureDetector(
                  onTap: () async {
                    _ackAlert(context, 2);
                    //getImage(2);
                  },
                  child: Container(
                    height: 40,
                    color: orange_F,
                    child: Center(child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Recto de votre pièce d'identité", style: TextStyle(
                            color: Colors.white,
                            fontSize: taille_champ+3
                        ),),
                        _isRecto == false?Icon(Icons.attach_file, color: Colors.white,):CupertinoActivityIndicator()
                      ],
                    )),
                  ),
                ),
              ),

              _recto==null?Container():
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: Container(
                  height: MediaQuery.of(context).size.width,
                  //width: 200,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                          image: NetworkImage(_recto),
                          fit: BoxFit.cover
                      )
                  ),
                  child: Image.network(_recto, fit: BoxFit.contain,
                      loadingBuilder: (BuildContext ctx, Widget child, ImageChunkEvent loadingProgress){
                        if (loadingProgress == null) return Container();
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null ?
                            loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        );
                      }
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: GestureDetector(
                  onTap: () async {
                    _ackAlert(context, 3);
                    //getImage(3);
                  },
                  child: Container(
                    height: 40,
                    color: orange_F,
                    child: Center(child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Verso de votre pièce d'identité", style: TextStyle(
                            color: Colors.white,
                            fontSize: taille_champ+3
                        ),),
                        _isVerso == false?Icon(Icons.attach_file, color: Colors.white,):CupertinoActivityIndicator()
                      ],
                    )),
                  ),
                ),
              ),
              _verso==null?Container():
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Container(
                  height: MediaQuery.of(context).size.width,
                  //width: 200,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                          image: NetworkImage(_verso),
                          fit: BoxFit.cover
                      )
                  ),
                  child: Image.network(_verso, fit: BoxFit.contain,
                      loadingBuilder: (BuildContext ctx, Widget child, ImageChunkEvent loadingProgress){
                        if (loadingProgress == null) return Container();
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null ?
                            loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        );
                      }
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                child: GestureDetector(
                  onTap: () {
                    if(pieceName == null){
                      showInSnackBar("Veuillez choisir la nature de la pièce à enregistrer", _scaffoldKey, 5);
                    }else{
                      if(_selfie == null || _recto == null || _verso == null){
                        showInSnackBar("Veuillez entrer toutes les 3 pièces (photo, recto et le verso de la pièce d'identité)", _scaffoldKey, 5);
                      }else{
                        Composantes composante1, composante2, composante3;
                        composante1 = new Composantes(
                            fileUrl: "$_selfie",
                            name: "selfie"
                        );
                        composante2 = new Composantes(
                            fileUrl: "$_recto",
                            name: "recto"
                        );
                        composante3 = new Composantes(
                            fileUrl: "$_verso",
                            name: "verso"
                        );
                        List<Composantes> composantes = [composante1,composante2,composante3];
                        var piece = new Piece(
                            composantes: composantes,
                            pieceName: pieceName!="Carte Nationale d'identité"?pieceName:"CNI"
                        );
                        print(json.encode(piece));
                        checkConnection(json.encode(piece));
                      }
                    }
                  },
                  child: Container(
                    decoration: new BoxDecoration(
                      color: couleur_fond_bouton,
                      borderRadius: new BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                        topLeft: Radius.circular(10.0),
                      ),
                    ),
                    height: 50,
                    child: Center(
                        child:isLoadPiece==false? Text("Valider mes pièces", style: TextStyle(color: Colors.white, fontSize: taille_champ+3),):
                        Theme(
                            data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.dark)),
                            child: CupertinoActivityIndicator(radius: 20,)),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new Connexion()));
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 20),
                  child: Text("Passer >>",style: TextStyle(
                      color: couleur_fond_bouton,
                      fontSize: taille_champ+3,
                      fontWeight: FontWeight.bold
                  ),),
                ),
              )
            ],
          ),
        ),
      );
    }
  }
