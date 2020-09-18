import 'package:shared_preferences/shared_preferences.dart';

class AppState {
  static putString(Data data, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(data.toString(), value);
  }

  static getString(Data data) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(data.toString());
  }

  static readString(String data) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(data);
  }

  static getInt(Data data) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(data.toString());
  }

  static putBool(Data data, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(data.toString(), value);
  }

  static putInt(Data data, int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(data.toString(), value);
  }
}

enum Data {
  MERCHANT_ID,
  SERVICE_NUMBER,
  SELLABLE_ITEM,
  SERVICE_DESCRIPTION,
  SERVICE_AMOUNT,
  CURRENCY,
  CITY,
  DISTRICT,
  TYPE
}