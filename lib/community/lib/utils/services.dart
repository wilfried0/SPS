import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'dart:async';

class Composantes {
  String fileUrl;
  String name;

  Composantes({
    this.fileUrl,
    this.name,
  });

  factory Composantes.fromJson(Map<String, dynamic> json) => Composantes(
    fileUrl: json["fileUrl"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "fileUrl": fileUrl,
    "name": name,
  };
}


class Piece {
  List<Composantes> composantes;
  String pieceName;

  Piece({
    this.composantes,
    this.pieceName,
  });

  factory Piece.fromJson(Map<String, dynamic> json) => Piece(
    composantes: List<Composantes>.from(json["composantes"].map((x) => Composantes.fromJson(x))),
    pieceName: json["pieceName"],
  );

  Map<String, dynamic> toJson() => {
    "composantes": List<dynamic>.from(composantes.map((x) => x.toJson())),
    "pieceName": pieceName,
  };
}

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
  final int id_kitty;
  final String kittyImage;
  final String firstnameBenef;
  final String endDate;
  final String startDate;
  final String title;
  final String amount;
  final String suggested_amount;
  final String description;

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

class Type{
  final String wording;
  final int idType;
  Type({this.idType, this.wording});

  Type.fromJson(Map<String, dynamic> json)
      : idType = json['idRole'],
        wording = json['roleName'];

  Map<String, dynamic> toJson() =>
      {
        "idRole": idType,
        "roleName": wording,
      };
}


class Kitty{
  final String title;
  final String startDate;
  final String endDate;
  final String description;
  final String firstnameBenef;
  final String lastnameBenef;
  final String number;
  final String kittyImage;
  final String currency;
  final double previsional_amount;
  final bool visibility;
  final bool status;
  final double suggested_amount;
  final double amount;
  final bool hide_amount_kitty;
  final bool hide_amount_contribution;
  final bool suggest_amount_to_guest;
  final bool notify_of_participation;
  final bool notify_of_comments;
  final bool notify_participants_when_spending;
  final String username;
  final int type;


  Kitty({this.title, this.startDate, this.endDate, this.amount, this.description, this.firstnameBenef, this.lastnameBenef, this.number, this.kittyImage, this.currency, this.previsional_amount, this.visibility, this.status, this.suggested_amount, this.suggest_amount_to_guest,
  this.hide_amount_kitty, this.hide_amount_contribution, this.notify_of_comments, this.notify_of_participation, this.username, this.notify_participants_when_spending, this.type,});
  Kitty.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        endDate = json['endDate'],
        startDate = json['startDate'],
        description = json['description'],
        firstnameBenef = json['firstnameBenef'],
        lastnameBenef = json['lastnameBenef'],
        number = json['number'],
        kittyImage = json['kittyImage'],
        currency = json['currency'],
        previsional_amount = json['previsional_amount'],
        visibility = json['visibility'],
        status = json['status'],
        suggested_amount = json['suggested_amount'],
        amount = json['amount'],
        suggest_amount_to_guest = json['suggest_amount_to_guest'],
        hide_amount_kitty = json['hide_amount_kitty'],
        hide_amount_contribution = json['hide_amount_contribution'],
        notify_of_comments = json['notify_of_comments'],
        notify_of_participation = json['notify_of_participation'],
        username = json['username'],
        notify_participants_when_spending = json['notify_participants_when_spending'],
        type = json['type'];


  Map<String, dynamic> toJson() =>
      {
        "title": title,
        "endDate": endDate,
        "startDate": startDate,
        "description": description,
        "firstnameBenef": firstnameBenef,
        "lastnameBenef": lastnameBenef,
        "number": number,
        "kittyImage": kittyImage,
        "currency": currency,
        "previsional_amount": previsional_amount,
        "visibility":visibility,
        "status":status,
        "suggested_amount": suggested_amount,
        "amount": amount,
        "suggest_amount_to_guest": suggest_amount_to_guest,
        "hide_amount_kitty": hide_amount_kitty,
        "hide_amount_contribution": hide_amount_contribution,
        "notify_of_comments": notify_of_comments,
        "notify_of_participation": notify_of_participation,
        "username": username,
        "notify_participants_when_spending": notify_participants_when_spending,
        "type":type
      };
}

class TontineC{
  final double amount;
  final String avatar;
  final double delayTimes;
  final String description;
  final List invitations;
  final String name;
  final double paticipationDuration;
  final String startDate;
  final String currency;
  final double sanctionPercentage;

  TontineC({this.amount, this.avatar, this.delayTimes, this.description, this.invitations, this.name, this.paticipationDuration, this.startDate,this.currency, this.sanctionPercentage});
  TontineC.fromJson(Map<String, dynamic> json)
      : amount = json['amount'],
        avatar = json['avatar'],
        delayTimes = json['delayTimes'],
        description = json['description'],
        invitations = json['invitations'],
        name = json['name'],
        currency = json['currency'],
        sanctionPercentage = json['sanctionPercentage'],
        paticipationDuration = json['paticipationDuration'],
        startDate = json['startDate'];



  Map<String, dynamic> toJson() =>
      {
        "amount": amount,
        "avatar": avatar,
        "delayTimes": delayTimes,
        "description": description,
        "invitations": invitations,
        "name": name,
        "sanctionPercentage": sanctionPercentage,
        "currency": currency,
        "paticipationDuration": paticipationDuration,
        "startDate": startDate,
      };
}


class FindUser{
  final String keyword;
  FindUser({this.keyword});
  FindUser.fromJson(Map<String, dynamic> json)
      : keyword = json['keyword'];
  Map<String, dynamic> toJson() =>
      {
        "keyword": keyword,
      };
}

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
  final String cancel_url;
  final String return_url;
  final int kittyID;
  final bool maskpart;

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

class OMoMo{
  final int amount;
  final double fees;
  final String firstname;
  final String lastname;
  final String description;
  final String country;
  final String mobileNumber;
  final String to;
  final String email;
  final String successUrl;
  final String failureUrl;
  final int kittyID;
  final bool maskpart;

  OMoMo({this.amount, this.fees, this.firstname, this.lastname, this.description, this.country, this.mobileNumber, this.email, this.to, this.successUrl, this.failureUrl, this.kittyID, this.maskpart});

  OMoMo.fromJson(Map<String, dynamic> json)
      : amount = json['amount'],
        fees = json['fees'],
        firstname = json['firstname'],
        lastname = json['lastname'],
        description = json['description'],
        country = json['country'],
        to = json['to'],
        mobileNumber = json['mobileNumber'],
        email = json['email'],
        successUrl = json['successUrl'],
        failureUrl = json['failureUrl'],
        kittyID = json['kittyID'],
        maskpart = json['maskpart'];

  Map<String, dynamic> toJson() =>
      {
        "amount": amount,
        "fees": fees,
        "firstname": firstname,
        "lastname": lastname,
        "description": description,
        "mobileNumber": mobileNumber,
        "country": country,
        "email": email,
        "to":to,
        "failureUrl": failureUrl,
        "successUrl": successUrl,
        "kittyID": kittyID,
        "maskpart":maskpart
      };
}

class OMoMoTontine{
  final int fees;
  final String description;
  final String mobileNumber;
  final String email;
  final String successUrl;
  final String failureUrl;
  final int roundId;

  OMoMoTontine({this.fees,  this.description, this.mobileNumber, this.email, this.successUrl, this.failureUrl, this.roundId});

  OMoMoTontine.fromJson(Map<String, dynamic> json)
      :
        fees = json['fees'],
        description = json['description'],
        mobileNumber = json['mobileNumber'],
        email = json['email'],
        successUrl = json['successUrl'],
        failureUrl = json['failureUrl'],
        roundId = json['kittyId'];

  Map<String, dynamic> toJson() =>
      {
        "fees": fees,
        "description": description,
        "mobileNumber": mobileNumber,
        "email": email,
        "failureUrl": failureUrl,
        "successUrl": successUrl,
        "roundId": roundId
      };
}


class InviteTontine{
  final List<String> members;
  final int tontineId;

  InviteTontine({this.members, this.tontineId});

  InviteTontine.fromJson(Map<String, dynamic> json)
      :
        members = json['members'],
        tontineId = json['tontineId'];

  Map<String, dynamic> toJson() =>
      {
        "members": members,
        "tontineId": tontineId
      };
}

class createMemberTemp{
  final String country;
  final String username;
  final String password;

  createMemberTemp({this.country, this.username, this.password});

  createMemberTemp.fromJson(Map<String, dynamic> json)
      : country = json['country'],
        username = json['username'],
        password = json['password'];

  Map<String, dynamic> toJson() =>
      {
        "country": country,
        "username": username,
        "password": password,
      };
}

class walletConfirm{
  final int id;
  final int confirmCode;
  final String username;

  walletConfirm({this.id, this.confirmCode, this.username});

  walletConfirm.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        confirmCode = json['confirmCode'],
        username = json['username'];

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "confirmCode": confirmCode,
        "username": username,
      };
}

class Participant{
  final double amount;
  final int firstname;
  final String lastname;
  final String phoneNumber;
  final String email;
  final String description;
  final String currency;
  final String type;

  Participant({this.amount, this.firstname, this.lastname, this.phoneNumber, this.email, this.description, this.currency, this.type});

  Participant.fromJson(Map<String, dynamic> json)
      : amount = json['amount'],
        firstname = json['firstname'],
        lastname = json['lastname'],
        phoneNumber = json['phoneNumber'],
        email = json['email'],
        description = json['description'],
        currency = json['currency'],
        type = json['type'];
}