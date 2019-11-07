import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'dart:async';

class Role{
  final String roleName;
  final int idRole;
  Role({this.idRole, this.roleName});

  Role.fromJson(Map<String, dynamic> json)
      : idRole = json['idRole'],
        roleName = json['roleName'];

  Map<String, dynamic> toJson() =>
      {
        "idRole": idRole,
        "roleName": roleName,
      };
}

class Post{
  final String firstname;
  final String lastname;
  final String town;
  final String birthday;
  final String country;
  final String email;
  final String username;
  final String password;
  final String userImage;
  final Role role;


  Post({this.firstname, this.lastname, this.town, this.birthday, this.country, this.email, this.username, this.password, this.userImage, this.role});
  Post.fromJson(Map<String, dynamic> json)
    : firstname = json['firstname'],
      lastname = json['lastname'],
      town = json['town'],
      birthday = json['birthday'],
      country = json['country'],
      email = json['email'],
      username = json['username'],
      password = json['password'],
      userImage = json['userImage'],
      role = Role.fromJson(json);

  Map<String, dynamic> toJson() =>
      {
        "firstname": firstname,
        "lastname": lastname,
        "town": town,
        "birthday": birthday,
        "country": country,
        "email": email,
        "username": username,
        "password": password,
        "userImage": userImage,
        "role": role
      };
}

class Login {
  final String phone;
  final String password;
  final String body;

  Login({this.phone, this.password, this.body});

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      phone: json['phone'],
      password: json['password'],
      body: json['body'],
    );
  }
}


class ConnectivityService {
  //
  StreamController<ConnectivityResult> connectionStatusController =
  StreamController<ConnectivityResult>();
  // Stream is like a pipe, you add the changes to the pipe, it will come
  // out on the other side.
  // Create the Constructor
  ConnectivityService() {
    // Subscribe to the connectivity changed stream
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      connectionStatusController.add(result);
    });
  }
}

class Cagnottes {
  // ignore: non_constant_identifier_names
  final int id_kitty;
  final String kittyImage;
  final String firstnameBenef;
  final String endDate;
  final String startDate;
  final String title;
  final String amount;
  // ignore: non_constant_identifier_names
  final String suggested_amount;
  final String description;

  // ignore: non_constant_identifier_names
  Cagnottes({this.id_kitty, this.kittyImage, this.firstnameBenef, this.endDate, this.startDate, this.title, this.amount, this.suggested_amount, this.description});

  Cagnottes.fromJson(Map<String, dynamic> data)
      : id_kitty = data['id_kitty'],
        kittyImage = data['kittyImage'],
        firstnameBenef = data['firstnameBenef'],
        endDate = data['endDate'],
        startDate = data['startDate'],
        title = data['title'],
        amount = data['amount'],
        suggested_amount = data['suggested_amount'],
        description = data['description'];
}

Future<Cagnottes> fetchPosts(var url, String token) async {
  final response = await http.get(url, headers: {"Accept": "application/json", "Authorization": "Bearer $token"});

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return Cagnottes.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

/*
* {
  "id_kitty": 0,
  "title": "string",
  "startDate": "2019-08-16T10:26:50.409Z",
  "dateUpdate": "2019-08-16T10:26:50.409Z",
  "endDate": "2019-08-16T10:26:50.409Z",
  "description": "string",
  "firstnameBenef": "string",
  "lastnameBenef": "string",
  "number": "string",
  "kittyImage": "string",
  "currency": "string",
  "visibility": true,
  "previsional_amount": 0,
  "suggested_amount": 0,
  "amount": 0,
  "status": true,
  "hide_amount_kitty": true,
  "hide_amount_contribution": true,
  "suggest_amount_to_guest": true,
  "notify_of_participation": true,
  "notify_of_comments": true,
  "notify_participants_when_spending": true,
  "idUser": 0,
  "type": 0
}
* */

class Invite {
  final int kittyID;
  final String address;
  final String partLink;

  Invite({this.kittyID, this.address, this.partLink});

  Invite.fromJson(Map<String, dynamic> data)
      : kittyID = data['kittyID'],
        address = data['address'],
        partLink = data['partLink'];

  Map<String, dynamic> toJson() =>
      {
        "kittyID": kittyID,
        "address": address,
        "partLink": partLink
      };
}


class Kitty{
  final String title;
  final String endDate;
  final String description;
  final String firstnameBenef;
  final String lastnameBenef;
  final String number;
  final String kittyImage;
  final String currency;
  // ignore: non_constant_identifier_names
  final double previsional_amount;
  final bool visibility;
  // ignore: non_constant_identifier_names
  final double suggested_amount;
  final double amount;
  // ignore: non_constant_identifier_names
  final bool hide_amount_kitty;
  // ignore: non_constant_identifier_names
  final bool hide_amount_contribution;
  // ignore: non_constant_identifier_names
  final bool suggest_amount_to_guest;
  // ignore: non_constant_identifier_names
  final bool notify_of_participation;
  // ignore: non_constant_identifier_names
  final bool notify_of_comments;
  // ignore: non_constant_identifier_names
  final bool notify_participants_when_spending;
  final int idUser;
  final int type;


  // ignore: non_constant_identifier_names
  Kitty({this.title, this.endDate, this.description, this.firstnameBenef, this.lastnameBenef, this.number, this.kittyImage, this.currency, this.previsional_amount, this.visibility, this.suggested_amount, this.amount, this.suggest_amount_to_guest,
  // ignore: non_constant_identifier_names
  this.hide_amount_kitty, this.hide_amount_contribution, this.notify_of_comments, this.notify_of_participation, this.idUser, this.notify_participants_when_spending, this.type,});
  Kitty.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        endDate = json['endDate'],
        description = json['description'],
        firstnameBenef = json['firstnameBenef'],
        lastnameBenef = json['lastnameBenef'],
        number = json['number'],
        kittyImage = json['kittyImage'],
        currency = json['currency'],
        previsional_amount = json['previsional_amount'],
        visibility = json['visibility'],
        suggested_amount = json['suggested_amount'],
        amount = json['amount'],
        suggest_amount_to_guest = json['suggest_amount_to_guest'],
        hide_amount_kitty = json['hide_amount_kitty'],
        hide_amount_contribution = json['hide_amount_contribution'],
        notify_of_comments = json['notify_of_comments'],
        notify_of_participation = json['notify_of_participation'],
        idUser = json['idUser'],
        notify_participants_when_spending = json['notify_participants_when_spending'],
        type = json['type'];


  Map<String, dynamic> toJson() =>
      {
        "title": title,
        "endDate": endDate,
        "description": description,
        "firstnameBenef": firstnameBenef,
        "lastnameBenef": lastnameBenef,
        "number": number,
        "kittyImage": kittyImage,
        "currency": currency,
        "previsional_amount": previsional_amount,
        "visibility":visibility,
        "suggested_amount": suggested_amount,
        "amount": amount,
        "suggest_amount_to_guest": suggest_amount_to_guest,
        "hide_amount_kitty": hide_amount_kitty,
        "hide_amount_contribution": hide_amount_contribution,
        "notify_of_comments": notify_of_comments,
        "notify_of_participation": notify_of_participation,
        "idUser": idUser,
        "notify_participants_when_spending": notify_participants_when_spending,
        "type":type
      };
}

class UploadImage{
  final File file;
  UploadImage({this.file});

  UploadImage.fromJson(Map<String, dynamic> json)
    :file = json['file'];

  Map<String, dynamic> toJson() =>
      {
        "file":file
      };
}

class Cardsp{
  final int amount;
  final String currency;
  final String firstnameBenef;
  final String lastnameBenef;
  final String description;
  final String country;
  final String mobileNumber;
  final String email;
  final String spMerchandUrl;
  final String clientUrl;
  final String failureUrl;
  // ignore: non_constant_identifier_names
  final String cancel_url;
  // ignore: non_constant_identifier_names
  final String return_url;
  final int kittyID;
  final bool maskpart;

  // ignore: non_constant_identifier_names
  Cardsp({this.amount, this.currency, this.firstnameBenef, this.lastnameBenef, this.description, this.country, this.mobileNumber, this.email, this.spMerchandUrl, this.clientUrl, this.failureUrl, this.cancel_url, this.return_url, this.kittyID, this.maskpart});

  Cardsp.fromJson(Map<String, dynamic> json)
      : amount = json['amount'],
        currency = json['currency'],
        firstnameBenef = json['firstnameBenef'],
        lastnameBenef = json['lastnameBenef'],
        description = json['description'],
        country = json['country'],
        mobileNumber = json['mobileNumber'],
        email = json['email'],
        spMerchandUrl = json['spMerchandUrl'],
        clientUrl = json['clientUrl'],
        failureUrl = json['failureUrl'],
        cancel_url = json['cancel_url'],
        return_url = json['return_url'],
        kittyID = json['kittyID'],
        maskpart = json['maskpart'];

  Map<String, dynamic> toJson() =>
      {
        "amount": amount,
        "currency": currency,
        "firstnameBenef": firstnameBenef,
        "lastnameBenef": lastnameBenef,
        "description": description,
        "mobileNumber": mobileNumber,
        "country": country,
        "email": email,
        "spMerchandUrl": spMerchandUrl,
        "clientUrl": clientUrl,
        "failureUrl": failureUrl,
        "cancel_url": cancel_url,
        "return_url":return_url,
        "kittyID": kittyID,
        "maskpart":maskpart
      };
}
