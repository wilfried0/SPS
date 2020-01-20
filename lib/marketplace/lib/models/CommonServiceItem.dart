class CommonServiceItem {
  int id;
  Merchant merchant;
  String paymentId;
  String name;
  String description;
  String priceType;
  String productType;
  String userType;
  String category;
  double priceAmount;
  String currency;
  String minPriceAmount;
  String maxPriceAmount;
  String priceIncrementAmount;
  String commissionType;
  double ccCommissionAmount;
  double omCommissionAmount;
  double momoCommissionAmount;
  double spCommissionAmount;
  double yupCommissionAmount;
  String providedby;

  CommonServiceItem(
      {this.id,
        this.merchant,
        this.paymentId,
        this.name,
        this.description,
        this.priceType,
        this.productType,
        this.userType,
        this.category,
        this.priceAmount,
        this.currency,
        this.minPriceAmount,
        this.maxPriceAmount,
        this.priceIncrementAmount,
        this.commissionType,
        this.ccCommissionAmount,
        this.omCommissionAmount,
        this.momoCommissionAmount,
        this.spCommissionAmount,
        this.yupCommissionAmount,
        this.providedby});

  CommonServiceItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    merchant = json['merchant'] != null
        ? new Merchant.fromJson(json['merchant'])
        : null;
    paymentId = json['paymentId'];
    name = json['name'];
    description = json['description'];
    priceType = json['priceType'];
    productType = json['productType'];
    userType = json['userType'];
    category = json['category'];
    priceAmount = json['priceAmount'];
    currency = json['currency'];
    minPriceAmount = json['minPriceAmount'];
    maxPriceAmount = json['maxPriceAmount'];
    priceIncrementAmount = json['priceIncrementAmount'];
    commissionType = json['commissionType'];
    ccCommissionAmount = json['ccCommissionAmount'];
    omCommissionAmount = json['omCommissionAmount'];
    momoCommissionAmount = json['momoCommissionAmount'];
    spCommissionAmount = json['spCommissionAmount'];
    yupCommissionAmount = json['yupCommissionAmount'];
    providedby = json['providedby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.merchant != null) {
      data['merchant'] = this.merchant.toJson();
    }
    data['paymentId'] = this.paymentId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['priceType'] = this.priceType;
    data['productType'] = this.productType;
    data['userType'] = this.userType;
    data['category'] = this.category;
    data['priceAmount'] = this.priceAmount;
    data['currency'] = this.currency;
    data['minPriceAmount'] = this.minPriceAmount;
    data['maxPriceAmount'] = this.maxPriceAmount;
    data['priceIncrementAmount'] = this.priceIncrementAmount;
    data['commissionType'] = this.commissionType;
    data['ccCommissionAmount'] = this.ccCommissionAmount;
    data['omCommissionAmount'] = this.omCommissionAmount;
    data['momoCommissionAmount'] = this.momoCommissionAmount;
    data['spCommissionAmount'] = this.spCommissionAmount;
    data['yupCommissionAmount'] = this.yupCommissionAmount;
    data['providedby'] = this.providedby;
    return data;
  }
}

class Merchant {
  int id;
  String name;
  String description;
  String logoFileId;
  String address;
  String neighborhood;
  String city;
  String country;
  String countryCode;
  String userType;
  String category;

  Merchant(
      {this.id,
        this.name,
        this.description,
        this.logoFileId,
        this.address,
        this.neighborhood,
        this.city,
        this.country,
        this.countryCode,
        this.userType,
        this.category});

  Merchant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    logoFileId = json['logoFileId'];
    address = json['address'];
    neighborhood = json['neighborhood'];
    city = json['city'];
    country = json['country'];
    countryCode = json['countryCode'];
    userType = json['userType'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['logoFileId'] = this.logoFileId;
    data['address'] = this.address;
    data['neighborhood'] = this.neighborhood;
    data['city'] = this.city;
    data['country'] = this.country;
    data['countryCode'] = this.countryCode;
    data['userType'] = this.userType;
    data['category'] = this.category;
    return data;
  }
}