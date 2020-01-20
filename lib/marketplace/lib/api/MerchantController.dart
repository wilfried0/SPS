import 'BaseController.dart';
import 'Route.dart';
import 'ServerResponseValidator.dart';

class MerchantController extends BaseController {
  ServerResponseValidator _responseValidator = new ServerResponseValidator();

  Future getList(String countryCode, Function onSuccess, Function onFailure,
      Function onRequestComplete) async {
    try {
      _responseValidator =
          await get("${Route.merchantList}?countryCode=$countryCode");
      if (this.statusCode == 200) {
        if (_responseValidator.isSuccess()) {
          onSuccess(_responseValidator.toJson());
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

  Future getItems(String category, Function onSuccess, Function onFailure,
      Function onRequestComplete) async {
    try {
      _responseValidator =
          await get("${Route.merchantServices}?category=$category");
      if (this.statusCode == 200) {
        if (_responseValidator.isSuccess()) {
          onSuccess(_responseValidator.toJson());
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
