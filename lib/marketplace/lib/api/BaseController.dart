import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';

import 'Route.dart';
import 'ServerResponseValidator.dart';

class BaseController {
  /*var _header = {
    "accept": "application/json",
    "content-type": "application/json",
  };*/

  var _statusCode = 0;

  get statusCode => _statusCode;

  ///Make a post request
  /*Future<ServerResponseValidator> post(
      String route, Map<String, dynamic> json) async {
    if (await deviceHasInternet())
      throw new NoInternetException("Please connect to internet");
    var httpClient = await http.post(Uri.encodeFull(Route.build(route)),
        headers: _header, body: jsonEncode(json));
    print("Sending data ${json.toString()}");
    _statusCode = httpClient.statusCode;
    var jsonResponse = utf8.decode(httpClient.bodyBytes);
    print(jsonResponse);
    return ServerResponseValidator.fromJson(jsonDecode(jsonResponse));
  }*/

  Future<ServerResponseValidator> post(
      String route, Map<String, dynamic> json) async {
    if (await deviceHasInternet())
      throw new NoInternetException("Please connect to internet");
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse(Route.build(route)));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(jsonEncode(json)));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print("Sending data post $reply");
    _statusCode = response.statusCode;
    return ServerResponseValidator.fromJson(jsonDecode(reply));
  }

  ///Make a post request
  /*Future<ServerResponseValidator> get(String route,
      {String baseUrl = Route.baseUrl}) async {
    if (await deviceHasInternet())
      throw new NoInternetException("Please connect to internet");
    print(_buildRoute(baseUrl, route));
    var httpClient = await http.get(Uri.encodeFull(_buildRoute(baseUrl, route)),
        headers: _header);
    print("Sending data ${json.toString()}");
    _statusCode = httpClient.statusCode;
    var jsonResponse = utf8.decode(httpClient.bodyBytes);
    print(jsonResponse);
    return ServerResponseValidator.fromJson(jsonDecode(jsonResponse));
  }*/

  Future<ServerResponseValidator> get(String route,
      {String baseUrl = Route.baseUrl}) async {
    if (await deviceHasInternet())
      throw new NoInternetException("Please connect to internet");
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.getUrl(Uri.parse(_buildRoute(baseUrl, route)));
    request.headers.set('accept', 'application/json');
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print("Sending data get $reply");
    print("Ma route $baseUrl/$route");
    _statusCode = response.statusCode;
    return ServerResponseValidator.fromJson(jsonDecode(reply));
  }

  ///Check if the device has internet access
  Future<bool> deviceHasInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi;
  }

  String _buildRoute(String baseUrl, String route) {
    return "$baseUrl/$route";
  }

  String _getBaseUrl(String custom) {
    return custom != null ? custom : Route.baseUrl;
  }

  //get header => _header;
}

class NoInternetException extends ControllerException {
  NoInternetException(String message) : super(message);
}

class InvalidResponseFormatException extends ControllerException {
  InvalidResponseFormatException(String message) : super(message);
}

class ControllerException with Exception {
  String _message;

  ControllerException(this._message);

  String get message => _message;
}
