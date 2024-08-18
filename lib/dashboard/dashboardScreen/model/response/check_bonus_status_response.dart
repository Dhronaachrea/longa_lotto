class CheckBonusStatusResponse {
  String? errorMessage;
  int? errorCode;
  List<Data>? data;

  CheckBonusStatusResponse({this.errorMessage, this.errorCode, this.data});

  CheckBonusStatusResponse.fromJson(Map<String, dynamic> json) {
    errorMessage = json['errorMessage'];
    errorCode = json['errorCode'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorMessage'] = this.errorMessage;
    data['errorCode'] = this.errorCode;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? domainId;
  int? aliasId;
  int? playerId;
  int? bonusId;
  String? bonusCode;
  double? bonusAmt;
  double? bonusAmtNative;
  double? redeemedBonusAmt;
  double? redeemedBonusAmtNative;
  double? redeemedBonusFreq;
  double? wrTarget;
  double? wrContribution;
  double? pendingWinning;
  double? pendingBonus;
  int? receivedDate;
  Null? expiredDate;
  int? refUsageDate;
  String? isRedeemable;
  String? wrStatus;
  Null? bonusCriteria;

  Data(
      {this.id,
        this.domainId,
        this.aliasId,
        this.playerId,
        this.bonusId,
        this.bonusCode,
        this.bonusAmt,
        this.bonusAmtNative,
        this.redeemedBonusAmt,
        this.redeemedBonusAmtNative,
        this.redeemedBonusFreq,
        this.wrTarget,
        this.wrContribution,
        this.pendingWinning,
        this.pendingBonus,
        this.receivedDate,
        this.expiredDate,
        this.refUsageDate,
        this.isRedeemable,
        this.wrStatus,
        this.bonusCriteria});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    domainId = json['domainId'];
    aliasId = json['aliasId'];
    playerId = json['playerId'];
    bonusId = json['bonusId'];
    bonusCode = json['bonusCode'];
    bonusAmt = json['bonusAmt'];
    bonusAmtNative = json['bonusAmtNative'];
    redeemedBonusAmt = json['redeemedBonusAmt'];
    redeemedBonusAmtNative = json['redeemedBonusAmtNative'];
    redeemedBonusFreq = json['redeemedBonusFreq'];
    wrTarget = json['wrTarget'];
    wrContribution = json['wrContribution'];
    pendingWinning = json['pendingWinning'];
    pendingBonus = json['pendingBonus'];
    receivedDate = json['receivedDate'];
    expiredDate = json['expiredDate'];
    refUsageDate = json['refUsageDate'];
    isRedeemable = json['isRedeemable'];
    wrStatus = json['wrStatus'];
    bonusCriteria = json['bonusCriteria'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['domainId'] = this.domainId;
    data['aliasId'] = this.aliasId;
    data['playerId'] = this.playerId;
    data['bonusId'] = this.bonusId;
    data['bonusCode'] = this.bonusCode;
    data['bonusAmt'] = this.bonusAmt;
    data['bonusAmtNative'] = this.bonusAmtNative;
    data['redeemedBonusAmt'] = this.redeemedBonusAmt;
    data['redeemedBonusAmtNative'] = this.redeemedBonusAmtNative;
    data['redeemedBonusFreq'] = this.redeemedBonusFreq;
    data['wrTarget'] = this.wrTarget;
    data['wrContribution'] = this.wrContribution;
    data['pendingWinning'] = this.pendingWinning;
    data['pendingBonus'] = this.pendingBonus;
    data['receivedDate'] = this.receivedDate;
    data['expiredDate'] = this.expiredDate;
    data['refUsageDate'] = this.refUsageDate;
    data['isRedeemable'] = this.isRedeemable;
    data['wrStatus'] = this.wrStatus;
    data['bonusCriteria'] = this.bonusCriteria;
    return data;
  }
}