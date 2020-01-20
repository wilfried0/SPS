import 'dart:convert';
import 'package:http/http.dart' as http;

import 'BaseController.dart';

class CountryController extends BaseController {
  List _countries;

  Future getList(Function onSuccess, Function onFailure,
      Function onRequestComplete) async {
    try {
      if (await deviceHasInternet())
        throw new NoInternetException("Please connect to internet");
      var httpClient = await http.get(
          Uri.encodeFull("https://restcountries.eu/rest/v2/all"),
          headers: header);
      _countries = jsonDecode(utf8.decode(httpClient.bodyBytes));
      if (httpClient.statusCode == 200) {
        onSuccess(_countries);
      }
    } on NoInternetException catch (e) {
      print(e.message);
      onFailure();
    } finally {
      onRequestComplete();
    }
  }
}
