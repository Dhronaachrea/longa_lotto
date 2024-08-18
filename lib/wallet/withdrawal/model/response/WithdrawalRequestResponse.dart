class WithdrawalRequestResponse {
  int? errorCode;
  String? respMsg;
  String? errorMsg;
  String? txnId;
  String? txnDate;
  String? regTxnNo;
  int? userTxnId;
  String? isOtpEnabled;

  WithdrawalRequestResponse(
      {this.errorCode,
        this.respMsg,
        this.errorMsg,
        this.txnId,
        this.txnDate,
        this.regTxnNo,
        this.userTxnId,
        this.isOtpEnabled});

  WithdrawalRequestResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    respMsg = json['respMsg'];
    errorMsg = json['errorMsg'];
    txnId = json['txnId'];
    txnDate = json['txnDate'];
    regTxnNo = json['regTxnNo'];
    userTxnId = json['userTxnId'];
    isOtpEnabled = json['isOtpEnabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['respMsg'] = this.respMsg;
    data['errorMsg'] = this.errorMsg;
    data['txnId'] = this.txnId;
    data['txnDate'] = this.txnDate;
    data['regTxnNo'] = this.regTxnNo;
    data['userTxnId'] = this.userTxnId;
    data['isOtpEnabled'] = this.isOtpEnabled;
    return data;
  }
}
