class TransactionResponse {
  int? errorCode;
  String? respMsg;
  double? txnTotalAmount;
  List<TxnList>? txnList;

  TransactionResponse({this.errorCode, this.txnList, this.respMsg, this.txnTotalAmount});

  TransactionResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    respMsg = json['respMsg'];
    txnTotalAmount = json['txnTotalAmount'];
    if (json['txnList'] != null) {
      txnList = <TxnList>[];
      json['txnList'].forEach((v) {
        txnList!.add(new TxnList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['respMsg'] = this.respMsg;
    data['txnTotalAmount'] = this.txnTotalAmount;
    if (this.txnList != null) {
      data['txnList'] = this.txnList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TxnList {
  int? transactionId;
  String? transactionDate;
  String? particular;
  String? txnType;
  int? currencyId;
  double? creditAmount;
  double? debitAmount;
  double? txnAmount;
  double? balance;
  double? openingBalance;
  String? subwalletTxn;
  String? currency;
  double? withdrawableBalance;

  TxnList(
      {this.transactionId,
        this.transactionDate,
        this.particular,
        this.txnType,
        this.currencyId,
        this.creditAmount,
        this.debitAmount,
        this.txnAmount,
        this.balance,
        this.openingBalance,
        this.subwalletTxn,
        this.currency,
        this.withdrawableBalance});

  TxnList.fromJson(Map<String, dynamic> json) {
    transactionId = json['transactionId'];
    transactionDate = json['transactionDate'];
    particular = json['particular'];
    txnType = json['txnType'];
    currencyId = json['currencyId'];
    creditAmount = json['creditAmount'];
    debitAmount = json['debitAmount'];
    txnAmount = json['txnAmount'];
    balance = json['balance'];
    openingBalance = json['openingBalance'];
    subwalletTxn = json['subwalletTxn'];
    currency = json['currency'];
    withdrawableBalance = json['withdrawableBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transactionId'] = this.transactionId;
    data['transactionDate'] = this.transactionDate;
    data['particular'] = this.particular;
    data['txnType'] = this.txnType;
    data['currencyId'] = this.currencyId;
    data['creditAmount'] = this.creditAmount;
    data['debitAmount'] = this.debitAmount;
    data['txnAmount'] = this.txnAmount;
    data['balance'] = this.balance;
    data['openingBalance'] = this.openingBalance;
    data['subwalletTxn'] = this.subwalletTxn;
    data['currency'] = this.currency;
    data['withdrawableBalance'] = this.withdrawableBalance;
    return data;
  }
}
