class CheckAvailabilityRequest {
  String? mobileNo;
  String? userName;
  String? domainName;

  CheckAvailabilityRequest({this.mobileNo, this.userName, this.domainName});

  CheckAvailabilityRequest.fromJson(Map<String, dynamic> json) {
    mobileNo = json['mobileNo'];
    userName = json['userName'];
    domainName = json['domainName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobileNo'] = this.mobileNo;
    data['userName'] = this.userName;
    data['domainName'] = this.domainName;
    return data;
  }
}
