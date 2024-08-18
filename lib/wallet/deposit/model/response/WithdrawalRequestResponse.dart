class WithdrawalRequestResponse {
  int? errorCode;
  String? errorMsg;

  WithdrawalRequestResponse({this.errorCode, this.errorMsg});

  WithdrawalRequestResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    return data;
  }
}
