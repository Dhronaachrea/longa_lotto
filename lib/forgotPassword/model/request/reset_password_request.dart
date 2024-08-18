class ResetPasswordRequest {
  String? otp;
  String? newPassword;
  String? confirmPassword;
  String? mobileNo;
  String? domainName;

  ResetPasswordRequest(
      {this.otp,
        this.newPassword,
        this.confirmPassword,
        this.mobileNo,
        this.domainName});

  ResetPasswordRequest.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    newPassword = json['newPassword'];
    confirmPassword = json['confirmPassword'];
    mobileNo = json['mobileNo'];
    domainName = json['domainName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp'] = this.otp;
    data['newPassword'] = this.newPassword;
    data['confirmPassword'] = this.confirmPassword;
    data['mobileNo'] = this.mobileNo;
    data['domainName'] = this.domainName;
    return data;
  }
}
