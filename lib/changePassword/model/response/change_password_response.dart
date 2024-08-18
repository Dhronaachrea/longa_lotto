class ChangePasswordResponse {
  int? errorCode;
  String? respMsg;

  ChangePasswordResponse({this.errorCode, this.respMsg});

  ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    respMsg = json['respMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['respMsg'] = this.respMsg;
    return data;
  }
}
