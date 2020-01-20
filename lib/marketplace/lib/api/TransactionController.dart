import 'package:services/marketplace/lib/models/Transaction.dart';
import 'BaseController.dart';
import 'Route.dart';
import 'ServerResponseValidator.dart';

class TransactionController extends BaseController {
  ServerResponseValidator _responseValidator = new ServerResponseValidator();

  Future pay(Transaction transaction, Function onSuccess, Function onFailure,
      Function onRequestComplete) async {
    try {
      _responseValidator = await post(Route.pay, transaction.toJson());
      if (this.statusCode == 200) {
        if (_responseValidator.isSuccess()) {
          onSuccess(_responseValidator.data);
        } else {
          onFailure(_responseValidator);
        }
      }
    } on NoInternetException catch (e) {
      print(e.message);
      onFailure(_responseValidator);
    } on InvalidResponseFormatException catch (e) {
      print("Wrong format : ${e.message}");
    } finally {
      onRequestComplete(_responseValidator);
    }
  }

  Future spConfirm(SpVerify spVerify, Function onSuccess, Function onFailure,
      Function onRequestComplete) async {
    try {
      _responseValidator = await post(Route.spConfirm, spVerify.toJson());
      if (this.statusCode == 200) {
        if (_responseValidator.isSuccess()) {
          onSuccess(_responseValidator.data);
        } else {
          onFailure(_responseValidator);
        }
      }
    } on NoInternetException catch (e) {
      print(e.message);
      onFailure(_responseValidator);
    } on InvalidResponseFormatException catch (e) {
      print("Wrong format : ${e.message}");
    } finally {
      onRequestComplete(_responseValidator);
    }
  }
}

class SpVerify {
  String secretKey;
  String spauthToken;
  String transactionId;

  SpVerify({this.secretKey, this.spauthToken, this.transactionId});

  SpVerify.fromJson(Map<String, dynamic> json) {
    secretKey = json['secretKey'];
    spauthToken = json['spauthToken'];
    transactionId = json['transactionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['secretKey'] = this.secretKey;
    data['spauthToken'] = this.spauthToken;
    data['transactionId'] = this.transactionId;
    return data;
  }
}
