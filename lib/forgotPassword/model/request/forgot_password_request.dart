class ForgotPasswordRequest {
  String? mobileNo;
  String? domainName;

  ForgotPasswordRequest({this.mobileNo, this.domainName});

  ForgotPasswordRequest.fromJson(Map<String, dynamic> json) {
    mobileNo = json['mobileNo'];
    domainName = json['domainName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobileNo'] = this.mobileNo;
    data['domainName'] = this.domainName;
    return data;
  }
}
