class SendVerificationEmailRequest {
  String? domainName;
  String? emailId;
  String? isOtpVerification;
  String? playerId;

  SendVerificationEmailRequest(
      {this.domainName, this.emailId, this.isOtpVerification, this.playerId});

  SendVerificationEmailRequest.fromJson(Map<String, dynamic> json) {
    domainName = json['domainName'];
    emailId = json['emailId'];
    isOtpVerification = json['isOtpVerification'];
    playerId = json['playerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['domainName'] = this.domainName;
    data['emailId'] = this.emailId;
    data['isOtpVerification'] = this.isOtpVerification;
    data['playerId'] = this.playerId;
    return data;
  }
}
