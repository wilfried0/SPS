import 'BaseController.dart';
import 'Route.dart';
import 'ServerResponseValidator.dart';

class BillController extends BaseController {
  ServerResponseValidator _responseValidator = new ServerResponseValidator();

  Future list(String id, Function onSuccess, Function onFailure,
      Function onRequestComplete) async {
    try {
      _responseValidator = await get("${Route.getReceipt}?buyerId=$id");
      if (this.statusCode == 200) {
        if (_responseValidator.isSuccess()) {
          onSuccess(_responseValidator.data['payments']);
        } else {
          onFailure(_responseValidator);
        }
      }
    } on NoInternetException catch (e) {
      print(e.message);
      onFailure(_responseValidator);
    } on InvalidResponseFormatException catch (e) {
      print("Wrong format : ${e.message}");
      onFailure(_responseValidator);
    } finally {
      onRequestComplete(_responseValidator);
    }
  }
}
