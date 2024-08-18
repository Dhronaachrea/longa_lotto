class ResetPasswordResponse {
  int? errorCode;
  String? respMsg;

  ResetPasswordResponse({this.errorCode, this.respMsg});

  ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
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
