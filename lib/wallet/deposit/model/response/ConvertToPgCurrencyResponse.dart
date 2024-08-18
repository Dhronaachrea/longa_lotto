class ConvertToPgCurrencyResponse {
  int? errorCode;
  String? respMsg;
  String? errorMsg;
  Data? data;
  String? exchangeType;

  ConvertToPgCurrencyResponse(
      {this.errorCode, this.respMsg, this.errorMsg, this.data, this.exchangeType});

  ConvertToPgCurrencyResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    respMsg = json['respMsg'];
    errorMsg = json['errorMsg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    exchangeType = json['exchangeType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['respMsg'] = this.respMsg;
    data['errorMsg'] = this.errorMsg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['exchangeType'] = this.exchangeType;
    return data;
  }
}

class Data {
  double? amount;
  double? processChargeValue;
  double? exchangeChargeValue;
  double? convertedAmount;
  double? netConvertedAmount;
  String? convertCurrencyCode;
  String? reqCurrencyCode;
  String? plrCurrencyCode;
  double? plrNetAmount;
  double? plrCurrExchangeRate;
  double? pgCurrExchangeRate;

  Data(
      {this.amount,
        this.processChargeValue,
        this.exchangeChargeValue,
        this.convertedAmount,
        this.netConvertedAmount,
        this.convertCurrencyCode,
        this.reqCurrencyCode,
        this.plrCurrencyCode,
        this.plrNetAmount,
        this.plrCurrExchangeRate,
        this.pgCurrExchangeRate});

  Data.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    processChargeValue = json['processChargeValue'];
    exchangeChargeValue = json['exchangeChargeValue'];
    convertedAmount = json['convertedAmount'];
    netConvertedAmount = json['netConvertedAmount'];
    convertCurrencyCode = json['convertCurrencyCode'];
    reqCurrencyCode = json['reqCurrencyCode'];
    plrCurrencyCode = json['plrCurrencyCode'];
    plrNetAmount = json['plrNetAmount'];
    plrCurrExchangeRate = json['plrCurrExchangeRate'];
    pgCurrExchangeRate = json['pgCurrExchangeRate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['processChargeValue'] = this.processChargeValue;
    data['exchangeChargeValue'] = this.exchangeChargeValue;
    data['convertedAmount'] = this.convertedAmount;
    data['netConvertedAmount'] = this.netConvertedAmount;
    data['convertCurrencyCode'] = this.convertCurrencyCode;
    data['reqCurrencyCode'] = this.reqCurrencyCode;
    data['plrCurrencyCode'] = this.plrCurrencyCode;
    data['plrNetAmount'] = this.plrNetAmount;
    data['plrCurrExchangeRate'] = this.plrCurrExchangeRate;
    data['pgCurrExchangeRate'] = this.pgCurrExchangeRate;
    return data;
  }
}
