class ScanWithdrawalRequest {
  String? amount;
  String? currencyCode;
  String? description;
  String? domainName;
  String? merchantCode;
  String? subTypeId;
  String? paymentTypeId;
  String? txnType;
  String? pgCurrencyCode;
  String? deviceType;
  String? userAgent;
  String? playerToken;
  int? playerId;

  ScanWithdrawalRequest(
      {this.amount,
        this.currencyCode,
        this.description,
        this.domainName,
        this.merchantCode,
        this.subTypeId,
        this.paymentTypeId,
        this.txnType,
        this.pgCurrencyCode,
        this.deviceType,
        this.userAgent,
        this.playerToken,
        this.playerId});

  ScanWithdrawalRequest.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    currencyCode = json['currencyCode'];
    description = json['description'];
    domainName = json['domainName'];
    merchantCode = json['merchantCode'];
    subTypeId = json['subTypeId'];
    paymentTypeId = json['paymentTypeId'];
    txnType = json['txnType'];
    pgCurrencyCode = json['pgCurrencyCode'];
    deviceType = json['deviceType'];
    userAgent = json['userAgent'];
    playerToken = json['playerToken'];
    playerId = json['playerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['currencyCode'] = this.currencyCode;
    data['description'] = this.description;
    data['domainName'] = this.domainName;
    data['merchantCode'] = this.merchantCode;
    data['subTypeId'] = this.subTypeId;
    data['paymentTypeId'] = this.paymentTypeId;
    data['txnType'] = this.txnType;
    data['pgCurrencyCode'] = this.pgCurrencyCode;
    data['deviceType'] = this.deviceType;
    data['userAgent'] = this.userAgent;
    data['playerToken'] = this.playerToken;
    data['playerId'] = this.playerId;
    return data;
  }
}
