class WithdrawalRequest {
  double? amount;
  String? currencyCode;
  String? pgCurrencyCode;
  String? deviceType;
  String? domainName;
  String? merchantCode;
  int? paymentTypeId;
  int? playerId;
  String? playerToken;
  int? subTypeId;
  String? txnType;
  String? accNum;

  WithdrawalRequest(
      {this.amount,
        this.currencyCode,
        this.pgCurrencyCode,
        this.deviceType,
        this.domainName,
        this.merchantCode,
        this.paymentTypeId,
        this.playerId,
        this.playerToken,
        this.subTypeId,
        this.txnType,
        this.accNum});

  WithdrawalRequest.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    currencyCode = json['currencyCode'];
    pgCurrencyCode = json['pgCurrencyCode'];
    deviceType = json['deviceType'];
    domainName = json['domainName'];
    merchantCode = json['merchantCode'];
    paymentTypeId = json['paymentTypeId'];
    playerId = json['playerId'];
    playerToken = json['playerToken'];
    subTypeId = json['subTypeId'];
    txnType = json['txnType'];
    accNum = json['accNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['currencyCode'] = this.currencyCode;
    data['pgCurrencyCode'] = this.pgCurrencyCode;
    data['deviceType'] = this.deviceType;
    data['domainName'] = this.domainName;
    data['merchantCode'] = this.merchantCode;
    data['paymentTypeId'] = this.paymentTypeId;
    data['playerId'] = this.playerId;
    data['playerToken'] = this.playerToken;
    data['subTypeId'] = this.subTypeId;
    data['txnType'] = this.txnType;
    data['accNum'] = this.accNum;
    return data;
  }
}
