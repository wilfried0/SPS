import 'BaseController.dart';
import 'Route.dart';
import 'ServerResponseValidator.dart';

class PharmacyController extends BaseController {
  ServerResponseValidator _responseValidator = new ServerResponseValidator();

  Future getList(Function onSuccess, Function onFailure,
      Function onRequestComplete) async {
    try {
      var _url = "${Route.merchantServices}?category=PHARMACY";
      _responseValidator = await get(_url);
      if (this.statusCode == 200) {
        if (_responseValidator.isSuccess()) {
          onSuccess(_responseValidator.data['items']);
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
