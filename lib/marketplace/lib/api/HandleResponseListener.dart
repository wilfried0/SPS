import 'ServerResponseValidator.dart';

abstract class HandleResponseListener {
  ///Fire when response format in invalid
  onFailure(ServerResponseValidator validator);

  ///Fire when response has succeed
  onSuccess(Map<String, dynamic> json);

  /// Fire when request is finish no matter if there is an error or not
  onRequestComplete(ServerResponseValidator validator);
}
