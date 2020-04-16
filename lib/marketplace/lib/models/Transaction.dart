class Transaction {
  String amount;
  String beneficiaryEmail;
  String beneficiaryPhoneNumber;
  String buyerEmail;
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
        this.beneficiaryEmail,
        this.beneficiaryPhoneNumber,
        this.buyerEmail,
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
    beneficiaryEmail = json['beneficiaryEmail'];
    beneficiaryPhoneNumber = json['beneficiaryPhoneNumber'];
    buyerEmail = json['buyerEmail'];
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
    data['beneficiaryEmail'] = this.beneficiaryEmail;
    data['beneficiaryPhoneNumber'] = this.beneficiaryPhoneNumber;
    data['buyerEmail'] = this.buyerEmail;
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