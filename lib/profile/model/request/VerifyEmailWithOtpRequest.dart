class VerifyEmailWithOtpRequest {
  String? domainName;
  String? emailId;
  String? merchantPlayerId;
  String? otp;

  VerifyEmailWithOtpRequest(
      {this.domainName, this.emailId, this.merchantPlayerId, this.otp});

  VerifyEmailWithOtpRequest.fromJson(Map<String, dynamic> json) {
    domainName = json['domainName'];
    emailId = json['emailId'];
    merchantPlayerId = json['merchantPlayerId'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['domainName'] = this.domainName;
    data['emailId'] = this.emailId;
    data['merchantPlayerId'] = this.merchantPlayerId;
    data['otp'] = this.otp;
    return data;
  }
}
