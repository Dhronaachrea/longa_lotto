class GetBalanceResponse {
  int? errorCode;
  String? respMsg;
  Wallet? wallet;

  GetBalanceResponse({this.errorCode, this.respMsg, this.wallet});

  GetBalanceResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    respMsg = json['respMsg'];
    wallet =
    json['wallet'] != null ? new Wallet.fromJson(json['wallet']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['respMsg'] = this.respMsg;
    if (this.wallet != null) {
      data['wallet'] = this.wallet!.toJson();
    }
    return data;
  }
}

class Wallet {
  double? totalBalance;
  double? cashBalance;
  double? depositBalance;
  double? winningBalance;
  double? bonusBalance;
  double? withdrawableBal;
  double? practiceBalance;
  String? currency;
  String? currencyDisplayCode;
  double? totalDepositBalance;
  double? totalWithdrawableBalance;
  double? totalWinningBalance;

  Wallet(
      {this.totalBalance,
        this.cashBalance,
        this.depositBalance,
        this.winningBalance,
        this.bonusBalance,
        this.withdrawableBal,
        this.practiceBalance,
        this.currency,
        this.currencyDisplayCode,
        this.totalDepositBalance,
        this.totalWithdrawableBalance,
        this.totalWinningBalance});

  Wallet.fromJson(Map<String, dynamic> json) {
    totalBalance = json['totalBalance'];
    cashBalance = json['cashBalance'];
    depositBalance = json['depositBalance'];
    winningBalance = json['winningBalance'];
    bonusBalance = json['bonusBalance'];
    withdrawableBal = json['withdrawableBal'];
    practiceBalance = json['practiceBalance'];
    currency = json['currency'];
    currencyDisplayCode = json['currencyDisplayCode'];
    totalDepositBalance = json['totalDepositBalance'];
    totalWithdrawableBalance = json['totalWithdrawableBalance'];
    totalWinningBalance = json['totalWinningBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalBalance'] = this.totalBalance;
    data['cashBalance'] = this.cashBalance;
    data['depositBalance'] = this.depositBalance;
    data['winningBalance'] = this.winningBalance;
    data['bonusBalance'] = this.bonusBalance;
    data['withdrawableBal'] = this.withdrawableBal;
    data['practiceBalance'] = this.practiceBalance;
    data['currency'] = this.currency;
    data['currencyDisplayCode'] = this.currencyDisplayCode;
    data['totalDepositBalance'] = this.totalDepositBalance;
    data['totalWithdrawableBalance'] = this.totalWithdrawableBalance;
    data['totalWinningBalance'] = this.totalWinningBalance;
    return data;
  }
}
