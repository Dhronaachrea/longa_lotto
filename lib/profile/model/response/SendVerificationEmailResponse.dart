class SendVerificationEmailResponse {
  String? errorMessage;
  int? errorCode;

  SendVerificationEmailResponse({this.errorMessage, this.errorCode});

  SendVerificationEmailResponse.fromJson(Map<String, dynamic> json) {
    errorMessage = json['errorMessage'];
    errorCode = json['errorCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorMessage'] = this.errorMessage;
    data['errorCode'] = this.errorCode;
    return data;
  }
}
