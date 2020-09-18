class Amount {
  static getCommission(String context, double commission, double amount) {
    if (context.contains("RATE")) {
      print("*********************** Rate ${amount * commission}");
      return amount * commission;
    } else {
      return commission;
    }
  }
}