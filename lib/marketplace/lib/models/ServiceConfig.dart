class ServiceConfig {
  final bool amountRequired; // true
  final bool billRequired; // true
  final bool canPayByOther; // true
  final bool phoneRequired; // true
  final bool serviceRequired; // true

  ServiceConfig(
      {this.amountRequired = false,
      this.billRequired = false,
      this.canPayByOther = false,
      this.phoneRequired = false,
      this.serviceRequired = false});

  factory ServiceConfig.fromJson(Map<String, dynamic> json) {
    return ServiceConfig(
      amountRequired: json['amountRequired'],
      billRequired: json['billRequired'],
      canPayByOther: json['canPayByOther'],
      phoneRequired: json['phoneRequired'],
      serviceRequired: json['serviceRequired'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amountRequired'] = this.amountRequired;
    data['billRequired'] = this.billRequired;
    data['canPayByOther'] = this.canPayByOther;
    data['phoneRequired'] = this.phoneRequired;
    data['serviceRequired'] = this.serviceRequired;
    return data;
  }
}
