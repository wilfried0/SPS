class ServerResponseValidator {
  int _code;
  String _codeDetails;
  Map<String, dynamic> _data;
  String _status;

  ServerResponseValidator();

  int get code => _code;

  set code(int code) => _code = code;

  String get codeDetails => _codeDetails;

  set codeDetails(String codeDetails) => _codeDetails = codeDetails;

  Map<String, dynamic> get data => _data;

  set data(Map<String, dynamic> data) => _data = data;

  String get status => _status;

  set status(String status) => _status = status;

  ServerResponseValidator.fromJson(Map<String, dynamic> json) {
    _code = json['code'];
    _codeDetails = json['codeDetails'];
    _data = json['data'];
    _status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this._code;
    data['codeDetails'] = this._codeDetails;
    data['data'] = this._data;
    data['status'] = this._status;
    return data;
  }

  getJson() {
    return _data;
  }

  getList() {
    return data.values;
  }

  bool isError() {
    return _status.toString().contains(Status().error);
  }

  bool isSuccess() {
    return _status.toString().contains(Status().success);
  }
}

class Status {
  final String error = "ERROR";
  final String success = "SUCCESS";
}
