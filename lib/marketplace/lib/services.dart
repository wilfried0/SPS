import 'package:flutter/material.dart';

class ItemMerchand{
  final int merchantId;
  final String serviceNumber;

  ItemMerchand({this.merchantId, this.serviceNumber});
  ItemMerchand.fromJson(Map<String, dynamic> json)
      : merchantId = json['merchantId'],
        serviceNumber = json['serviceNumber'];

  Map<String, dynamic> toJson() =>
      {
        "merchantId": merchantId,
        "serviceNumber": serviceNumber
      };
}

String BaseUrl = "http://192.168.8.105:8086/marketplace";
String baseUrl = "http://74.208.183.205:8086/marketplace";

Future<void> ackAlert(BuildContext context) {
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