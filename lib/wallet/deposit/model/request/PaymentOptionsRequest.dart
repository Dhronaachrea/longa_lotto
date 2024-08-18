class PaymentOptionsRequest {
  String? deviceType;
  String? domainName;
  int? playerId;
  String? txnType;
  String? userAgent;

  PaymentOptionsRequest(
      {this.deviceType,
        this.domainName,
        this.playerId,
        this.txnType,
        this.userAgent});

  PaymentOptionsRequest.fromJson(Map<String, dynamic> json) {
    deviceType = json['deviceType'];
    domainName = json['domainName'];
    playerId = json['playerId'];
    txnType = json['txnType'];
    userAgent = json['userAgent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceType'] = this.deviceType;
    data['domainName'] = this.domainName;
    data['playerId'] = this.playerId;
    data['txnType'] = this.txnType;
    data['userAgent'] = this.userAgent;
    return data;
  }
}
