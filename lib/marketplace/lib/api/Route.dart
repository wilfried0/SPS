class Route {
  static const String baseUrl = "http://74.208.183.205:8086/marketplace";//"https://pcs.sprint-pay.com/marketplace";

  static String pay = "payment";
  static String merchantServices = "items";
  static String merchantList = "merchants";
  static String pharmacyCities = "merchants";
  static String quincaillerieCities = "merchants";
  static String getReceipt = "successfulpayments";
  static String spConfirm = "confirmsppayment";
  static String verifyPayment = "verifypayment";

  static build(String route) {
    return baseUrl + "/" + route;
  }
}
