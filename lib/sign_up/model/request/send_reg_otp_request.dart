class SendRegOtpRequest {
  String? aliasName;
  String? mobileNo;

  SendRegOtpRequest({this.aliasName, this.mobileNo});

  SendRegOtpRequest.fromJson(Map<String, dynamic> json) {
    aliasName = json['aliasName'];
    mobileNo = json['mobileNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aliasName'] = this.aliasName;
    data['mobileNo'] = this.mobileNo;
    return data;
  }
}
