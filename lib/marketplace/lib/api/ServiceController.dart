import 'BaseController.dart';
import 'Route.dart';
import 'ServerResponseValidator.dart';

class ServiceController extends BaseController {
  ServerResponseValidator _responseValidator = new ServerResponseValidator();

  Future load(int merchantID, String serviceNumber, Function onSuccess,
      Function onFailure, Function onRequestComplete) async {
    try {
      _responseValidator = await get(
          "${Route.merchantServices}?merchantId=$merchantID&serviceNumber=$serviceNumber");
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
