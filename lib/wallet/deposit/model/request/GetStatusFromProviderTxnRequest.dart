class GetStatusFromProviderTxnRequest {
  String? domainName;
  String? merchantCode;
  int? playerId;
  int? txnId;

  GetStatusFromProviderTxnRequest(
      {this.domainName, this.merchantCode, this.playerId, this.txnId});

  GetStatusFromProviderTxnRequest.fromJson(Map<String, dynamic> json) {
    domainName = json['domainName'];
    merchantCode = json['merchantCode'];
    playerId = json['playerId'];
    txnId = json['txnId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['domainName'] = this.domainName;
    data['merchantCode'] = this.merchantCode;
    data['playerId'] = this.playerId;
    data['txnId'] = this.txnId;
    return data;
  }
}
