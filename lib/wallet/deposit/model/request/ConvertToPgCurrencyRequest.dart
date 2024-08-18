class ConvertToPgCurrencyRequest {
  int? amount;
  String? reqAmtCurrencyCode;
  String? pgCurrencyCode;
  String? aliasName;
  String? exchangeType;
  int? paymentTypeId;
  int? subTypeId;
  String? device;

  ConvertToPgCurrencyRequest(
      {this.amount,
        this.reqAmtCurrencyCode,
        this.pgCurrencyCode,
        this.aliasName,
        this.exchangeType,
        this.paymentTypeId,
        this.subTypeId,
        this.device,
      });

  ConvertToPgCurrencyRequest.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    reqAmtCurrencyCode = json['reqAmtCurrencyCode'];
    pgCurrencyCode = json['pgCurrencyCode'];
    aliasName = json['aliasName'];
    exchangeType = json['exchangeType'];
    paymentTypeId = json['paymentTypeId'];
    subTypeId = json['subTypeId'];
    device = json['device'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['reqAmtCurrencyCode'] = this.reqAmtCurrencyCode;
    data['pgCurrencyCode'] = this.pgCurrencyCode;
    data['aliasName'] = this.aliasName;
    data['exchangeType'] = this.exchangeType;
    data['paymentTypeId'] = this.paymentTypeId;
    data['subTypeId'] = this.subTypeId;
    data['device'] = this.device;
    return data;
  }
}
