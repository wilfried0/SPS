import 'dart:convert';
import 'dart:io';
import 'BaseController.dart';

class CountryController extends BaseController {
  //List _countries;

  Future getList(Function onSuccess, Function onFailure,
      Function onRequestComplete) async {
    try {
      if (await deviceHasInternet())
        throw new NoInternetException("Please connect to internet");
      HttpClient client = new HttpClient();
      client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
      HttpClientRequest request = await client.getUrl(Uri.parse("https://restcountries.eu/rest/v2/all"));
      request.headers.set('accept', 'application/json');
      request.headers.set('content-type', 'application/json');
      HttpClientResponse response = await request.close();
      String _countries = await response.transform(utf8.decoder).join();
      /*
      var httpClient = await http.get(
          Uri.encodeFull("https://restcountries.eu/rest/v2/all"),
          headers: header);
      _countries = jsonDecode(utf8.decode(httpClient.bodyBytes));*/
      if (response.statusCode == 200) {
        onSuccess(jsonDecode(_countries));
      }
    } on NoInternetException catch (e) {
      print(e.message);
      onFailure();
    } finally {
      onRequestComplete();
    }
  }
}
