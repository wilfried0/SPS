class Transaction {
  String amount;
  String beneficiaryEmail;
  String beneficiaryCountry;
  String beneficiaryPhoneNumber;
  String buyerCountry;
  String buyerEmail;
  String buyerName;
  String buyerId;
  bool buyerIsBeneficiary;
  String buyerPhoneNumber;
  String currency;
  String description;
  String mobileMoneyPaymentNumber;
  String paymentItemId;
  String paymentType;
  int sellableItemId;
  String serviceNumber;
  String spauthToken;
  String accountType;
  String clientIpAddress;

  Transaction(
      {this.amount,
        this.beneficiaryCountry,
        this.beneficiaryEmail,
        this.beneficiaryPhoneNumber,
        this.buyerCountry,
        this.buyerEmail,
        this.buyerName,
        this.buyerId,
        this.buyerIsBeneficiary,
        this.buyerPhoneNumber,
        this.currency,
        this.description,
        this.mobileMoneyPaymentNumber,
        this.paymentItemId,
        this.paymentType,
        this.sellableItemId,
        this.serviceNumber,
        this.clientIpAddress,
        this.spauthToken});

  Transaction.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    beneficiaryCountry = json['beneficiaryCountry'];
    beneficiaryEmail = json['beneficiaryEmail'];
    beneficiaryPhoneNumber = json['beneficiaryPhoneNumber'];
    buyerCountry = json['buyerCountry'];
    buyerEmail = json['buyerEmail'];
    buyerName = json['buyerName'];
    buyerId = json['buyerId'];
    buyerIsBeneficiary = json['buyerIsBeneficiary'];
    buyerPhoneNumber = json['buyerPhoneNumber'];
    currency = json['currency'];
    description = json['description'];
    mobileMoneyPaymentNumber = json['mobileMoneyPaymentNumber'];
    paymentItemId = json['paymentItemId'];
    paymentType = json['paymentType'];
    sellableItemId = json['sellableItemId'];
    serviceNumber = json['serviceNumber'];
    clientIpAddress = json['clientIpAddress'];
    spauthToken = json['spauthToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['beneficiaryCountry'] = this.beneficiaryCountry;
    data['beneficiaryEmail'] = this.beneficiaryEmail;
    data['beneficiaryPhoneNumber'] = this.beneficiaryPhoneNumber;
    data['buyerCountry'] = this.buyerCountry;
    data['buyerEmail'] = this.buyerEmail;
    data['buyerName'] = this.buyerName;
    data['buyerId'] = this.buyerId;
    data['buyerIsBeneficiary'] = this.buyerIsBeneficiary;
    data['buyerPhoneNumber'] = this.buyerPhoneNumber;
    data['currency'] = this.currency;
    data['description'] = this.description;
    data['mobileMoneyPaymentNumber'] = this.mobileMoneyPaymentNumber;
    data['paymentItemId'] = this.paymentItemId;
    data['paymentType'] = this.paymentType;
    data['sellableItemId'] = this.sellableItemId;
    data['serviceNumber'] = this.serviceNumber;
    data['spauthToken'] = this.spauthToken;
    data['clientIpAddress'] = this.clientIpAddress;
    data['account_type'] = this.accountType;
    return data;
  }
}