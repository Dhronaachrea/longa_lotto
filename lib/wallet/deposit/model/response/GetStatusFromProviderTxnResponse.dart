class GetStatusFromProviderTxnResponse {
  int? errorCode;
  String? errorMsg;
  String? txnId;
  double? netAmount;
  String? status;
  String? txnType;
  String? responseUrl;
  bool? firstDeposit;
  String? domainName;
  String? userName;

  GetStatusFromProviderTxnResponse(
      {this.errorCode,
        this.errorMsg,
        this.txnId,
        this.netAmount,
        this.status,
        this.txnType,
        this.responseUrl,
        this.firstDeposit,
        this.domainName,
        this.userName});

  GetStatusFromProviderTxnResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
    txnId = json['txnId'];
    netAmount = json['netAmount'];
    status = json['status'];
    txnType = json['txnType'];
    responseUrl = json['responseUrl'];
    firstDeposit = json['firstDeposit'];
    domainName = json['domainName'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    data['txnId'] = this.txnId;
    data['netAmount'] = this.netAmount;
    data['status'] = this.status;
    data['txnType'] = this.txnType;
    data['responseUrl'] = this.responseUrl;
    data['firstDeposit'] = this.firstDeposit;
    data['domainName'] = this.domainName;
    data['userName'] = this.userName;
    return data;
  }
}
