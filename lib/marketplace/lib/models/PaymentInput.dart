class PaymentInput {
  bool _isPasswordRequired = false;
  bool _isPhoneRequired = true;
  bool _isEmailRequired = false;

  String _phone;
  String _password;
  String _email;
  String _image;

  PaymentInput(this._isPhoneRequired, this._isEmailRequired,
      this._isPasswordRequired, this._image);

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get phone => _phone;

  set phone(String value) {
    _phone = value;
  }

  bool get isEmailRequired => _isEmailRequired;

  bool get isPhoneRequired => _isPhoneRequired;

  bool get isPasswordRequired => _isPasswordRequired;
}
