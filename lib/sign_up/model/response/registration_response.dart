class RegistrationResponse {
  int? firstDepositCampTrackId;
  // Mapping? mapping;
  String? domainName;
  String? responseMessage;
  String? errorMessage;
  String? firstDepositReferSource;
  PlayerLoginInfo? playerLoginInfo;
  int? firstDepositReferSourceId;
  String? profileStatus;
  int? errorCode;
  int? firstDepositSubSourceId;
  RamPlayerInfo? ramPlayerInfo;
  String? playerToken;

  // RegistrationResponse({this.firstDepositCampTrackId, this.mapping, this.domainName,  this.responseMessage, this.firstDepositReferSource, this.playerLoginInfo, this.firstDepositReferSourceId, this.profileStatus, this.errorCode, this.firstDepositSubSourceId, this.ramPlayerInfo, this.playerToken});
  RegistrationResponse({this.firstDepositCampTrackId, this.domainName, this.responseMessage, this.errorMessage, this.firstDepositReferSource, this.playerLoginInfo, this.firstDepositReferSourceId, this.profileStatus, this.errorCode, this.firstDepositSubSourceId, this.ramPlayerInfo, this.playerToken});

  RegistrationResponse.fromJson(Map<String, dynamic> json) {
    firstDepositCampTrackId = json['firstDepositCampTrackId'];
    // mapping = json['mapping'] != null ? new Mapping.fromJson(json['mapping']) : null;
    domainName = json['domainName'];
    responseMessage = json['responseMessage'];
    errorMessage = json['errorMessage'];
    firstDepositReferSource = json['firstDepositReferSource'];
    playerLoginInfo = json['playerLoginInfo'] != null ? new PlayerLoginInfo.fromJson(json['playerLoginInfo']) : null;
    firstDepositReferSourceId = json['firstDepositReferSourceId'];
    profileStatus = json['profileStatus'];
    errorCode = json['errorCode'];
    firstDepositSubSourceId = json['firstDepositSubSourceId'];
    ramPlayerInfo = json['ramPlayerInfo'] != null ? new RamPlayerInfo.fromJson(json['ramPlayerInfo']) : null;
    playerToken = json['playerToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstDepositCampTrackId'] = this.firstDepositCampTrackId;
    /*if (this.mapping != null) {
      data['mapping'] = this.mapping!.toJson();
    }*/
    data['domainName'] = this.domainName;
    data['responseMessage'] = this.responseMessage;
    data['errorMessage'] = this.errorMessage;
    data['firstDepositReferSource'] = this.firstDepositReferSource;
    if (this.playerLoginInfo != null) {
      data['playerLoginInfo'] = this.playerLoginInfo!.toJson();
    }
    data['firstDepositReferSourceId'] = this.firstDepositReferSourceId;
    data['profileStatus'] = this.profileStatus;
    data['errorCode'] = this.errorCode;
    data['firstDepositSubSourceId'] = this.firstDepositSubSourceId;
    if (this.ramPlayerInfo != null) {
      data['ramPlayerInfo'] = this.ramPlayerInfo!.toJson();
    }
    data['playerToken'] = this.playerToken;
    return data;
  }
}

/*class Mapping {


  Mapping({});

Mapping.fromJson(Map<String, dynamic> json) {
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  return data;
}
}*/

class PlayerLoginInfo {
  int? unreadMsgCount;
  String? country;
  WalletBean? walletBean;
  String? regDevice;
  String? ageVerified;
  String? lastLoginDate;
  String? firstLoginDate;
  String? countryCode;
  String? playerType;
  String? registrationDate;
  String? state;
  String? playerStatus;
  String? referSource;
  String? addressVerified;
  int? playerId;
  String? referFriendCode;
  String? phoneVerified;
  String? avatarPath;
  String? mobileNo;
  String? userName;
  String? registrationIp;
  String? olaPlayer;
  String? isPlay2x;
  String? emailVerified;
  String? commonContentPath;
  String? firstDepositDate;
  String? campaignName;

  String? firstName;
  String? lastName;
  String? gender;
  String? dob;
  String? emailId;
  String? addressLine1;

  PlayerLoginInfo({this.unreadMsgCount, this.country, this.walletBean, this.regDevice, this.ageVerified, this.lastLoginDate, this.firstLoginDate, this.countryCode, this.playerType, this.registrationDate, this.state, this.playerStatus, this.referSource, this.addressVerified, this.playerId, this.referFriendCode, this.phoneVerified, this.avatarPath, this.mobileNo, this.userName, this.registrationIp, this.olaPlayer, this.isPlay2x, this.emailVerified, this.commonContentPath, this.firstDepositDate, this.campaignName, this.firstName, this.lastName, this.emailId, this.addressLine1, this.gender, this.dob});

  PlayerLoginInfo.fromJson(Map<String, dynamic> json) {
    unreadMsgCount = json['unreadMsgCount'];
    country = json['country'];
    walletBean = json['walletBean'] != null ? new WalletBean.fromJson(json['walletBean']) : null;
    regDevice = json['regDevice'];
    ageVerified = json['ageVerified'];
    lastLoginDate = json['lastLoginDate'];
    firstLoginDate = json['firstLoginDate'];
    countryCode = json['countryCode'];
    playerType = json['playerType'];
    registrationDate = json['registrationDate'];
    state = json['state'];
    playerStatus = json['playerStatus'];
    referSource = json['referSource'];
    addressVerified = json['addressVerified'];
    playerId = json['playerId'];
    referFriendCode = json['referFriendCode'];
    phoneVerified = json['phoneVerified'];
    avatarPath = json['avatarPath'];
    mobileNo = json['mobileNo'];
    userName = json['userName'];
    registrationIp = json['registrationIp'];
    olaPlayer = json['olaPlayer'];
    isPlay2x = json['isPlay2x'];
    emailVerified = json['emailVerified'];
    commonContentPath = json['commonContentPath'];
    firstDepositDate = json['firstDepositDate'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    emailId = json['emailId'];
    addressLine1 = json['addressLine1'];
    gender = json['gender'];
    dob = json['dob'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unreadMsgCount'] = this.unreadMsgCount;
    data['country'] = this.country;
    if (this.walletBean != null) {
      data['walletBean'] = this.walletBean!.toJson();
    }
    data['regDevice'] = this.regDevice;
    data['ageVerified'] = this.ageVerified;
    data['lastLoginDate'] = this.lastLoginDate;
    data['firstLoginDate'] = this.firstLoginDate;
    data['countryCode'] = this.countryCode;
    data['playerType'] = this.playerType;
    data['registrationDate'] = this.registrationDate;
    data['state'] = this.state;
    data['playerStatus'] = this.playerStatus;
    data['referSource'] = this.referSource;
    data['addressVerified'] = this.addressVerified;
    data['playerId'] = this.playerId;
    data['referFriendCode'] = this.referFriendCode;
    data['phoneVerified'] = this.phoneVerified;
    data['avatarPath'] = this.avatarPath;
    data['mobileNo'] = this.mobileNo;
    data['userName'] = this.userName;
    data['registrationIp'] = this.registrationIp;
    data['olaPlayer'] = this.olaPlayer;
    data['isPlay2x'] = this.isPlay2x;
    data['emailVerified'] = this.emailVerified;
    data['commonContentPath'] = this.commonContentPath;
    data['firstDepositDate'] = this.firstDepositDate;
    data['campaignName'] = this.campaignName;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['emailId'] = this.emailId;
    data['addressLine1'] = this.addressLine1;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    return data;
  }
}

class WalletBean {
  double? totalBalance;
  double? cashBalance;
  double? depositBalance;
  double? winningBalance;
  double? bonusBalance;
  double? withdrawableBal;
  double? practiceBalance;
  double? totalWithdrawableBalance;
  String? currency;
  String? currencyDisplayCode;
  String? preferredWallet;

  WalletBean({this.totalBalance, this.cashBalance, this.depositBalance, this.winningBalance, this.bonusBalance, this.withdrawableBal, this.practiceBalance, this.currency, this.currencyDisplayCode, this.preferredWallet});

  WalletBean.fromJson(Map<String, dynamic> json) {
    totalBalance = json['totalBalance'];
    cashBalance = json['cashBalance'];
    depositBalance = json['depositBalance'];
    winningBalance = json['winningBalance'];
    bonusBalance = json['bonusBalance'];
    withdrawableBal = json['withdrawableBal'];
    practiceBalance = json['practiceBalance'];
    totalWithdrawableBalance = json['totalWithdrawableBalance'];
    currency = json['currency'];
    currencyDisplayCode = json['currencyDisplayCode'];
    preferredWallet = json['preferredWallet'];
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
    data['totalWithdrawableBalance'] = this.totalWithdrawableBalance;
    data['currency'] = this.currency;
    data['currencyDisplayCode'] = this.currencyDisplayCode;
    data['preferredWallet'] = this.preferredWallet;
    return data;
  }
}

class RamPlayerInfo {
  int? id;
  int? merchantId;
  int? domainId;
  int? playerId;
  String? addressVerified;
  String? nameVerified;
  String? emailVerified;
  String? mobileVerified;
  String? ageVerified;
  String? taxationIdVerified;
  String? securityQuestionVerified;
  String? idVerified;
  String? bankVerified;
  String? addressVerifiedAt;
  String? profileStatus;
  String? kycStatus;
  String? emailVerifiedAt;
  String? mobileVerifiedAt;
  String? ageVerifiedAt;
  String? taxationIdVerifiedAt;
  String? securityQuestionVerifiedAt;
  String? idVerifiedAt;
  String? bankVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? profileExpiredAt;
  String? docUploaded;
  Null? uploadPendingDate;
  Null? verifiedBy;
  Null? verificationAssignAt;
  Null? verificationModeAt;
  Null? addressVerifiedBy;
  Null? idVerifiedBy;
  Null? bankVerifiedBy;
  String? aliasName;

  RamPlayerInfo({this.id, this.merchantId, this.domainId, this.playerId, this.addressVerified, this.nameVerified, this.emailVerified, this.mobileVerified, this.ageVerified, this.taxationIdVerified, this.securityQuestionVerified, this.idVerified, this.bankVerified, this.addressVerifiedAt, this.profileStatus, this.kycStatus, this.emailVerifiedAt, this.mobileVerifiedAt, this.ageVerifiedAt, this.taxationIdVerifiedAt, this.securityQuestionVerifiedAt, this.idVerifiedAt, this.bankVerifiedAt, this.createdAt, this.updatedAt, this.profileExpiredAt, this.docUploaded, this.uploadPendingDate, this.verifiedBy, this.verificationAssignAt, this.verificationModeAt, this.addressVerifiedBy, this.idVerifiedBy, this.bankVerifiedBy});

  RamPlayerInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    merchantId = json['merchantId'];
    domainId = json['domainId'];
    playerId = json['playerId'];
    addressVerified = json['addressVerified'];
    nameVerified = json['nameVerified'];
    emailVerified = json['emailVerified'];
    mobileVerified = json['mobileVerified'];
    ageVerified = json['ageVerified'];
    taxationIdVerified = json['taxationIdVerified'];
    securityQuestionVerified = json['securityQuestionVerified'];
    idVerified = json['idVerified'];
    bankVerified = json['bankVerified'];
    addressVerifiedAt = json['addressVerifiedAt'];
    profileStatus = json['profileStatus'];
    kycStatus = json['kycStatus'];
    emailVerifiedAt = json['emailVerifiedAt'];
    mobileVerifiedAt = json['mobileVerifiedAt'];
    ageVerifiedAt = json['ageVerifiedAt'];
    taxationIdVerifiedAt = json['taxationIdVerifiedAt'];
    securityQuestionVerifiedAt = json['securityQuestionVerifiedAt'];
    idVerifiedAt = json['idVerifiedAt'];
    bankVerifiedAt = json['bankVerifiedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    profileExpiredAt = json['profileExpiredAt'];
    docUploaded = json['docUploaded'];
    uploadPendingDate = json['uploadPendingDate'];
    verifiedBy = json['verifiedBy'];
    verificationAssignAt = json['verificationAssignAt'];
    verificationModeAt = json['verificationModeAt'];
    addressVerifiedBy = json['addressVerifiedBy'];
    idVerifiedBy = json['idVerifiedBy'];
    bankVerifiedBy = json['bankVerifiedBy'];
    aliasName = json['aliasName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['merchantId'] = this.merchantId;
    data['domainId'] = this.domainId;
    data['playerId'] = this.playerId;
    data['addressVerified'] = this.addressVerified;
    data['nameVerified'] = this.nameVerified;
    data['emailVerified'] = this.emailVerified;
    data['mobileVerified'] = this.mobileVerified;
    data['ageVerified'] = this.ageVerified;
    data['taxationIdVerified'] = this.taxationIdVerified;
    data['securityQuestionVerified'] = this.securityQuestionVerified;
    data['idVerified'] = this.idVerified;
    data['bankVerified'] = this.bankVerified;
    data['addressVerifiedAt'] = this.addressVerifiedAt;
    data['profileStatus'] = this.profileStatus;
    data['kycStatus'] = this.kycStatus;
    data['emailVerifiedAt'] = this.emailVerifiedAt;
    data['mobileVerifiedAt'] = this.mobileVerifiedAt;
    data['ageVerifiedAt'] = this.ageVerifiedAt;
    data['taxationIdVerifiedAt'] = this.taxationIdVerifiedAt;
    data['securityQuestionVerifiedAt'] = this.securityQuestionVerifiedAt;
    data['idVerifiedAt'] = this.idVerifiedAt;
    data['bankVerifiedAt'] = this.bankVerifiedAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['profileExpiredAt'] = this.profileExpiredAt;
    data['docUploaded'] = this.docUploaded;
    data['uploadPendingDate'] = this.uploadPendingDate;
    data['verifiedBy'] = this.verifiedBy;
    data['verificationAssignAt'] = this.verificationAssignAt;
    data['verificationModeAt'] = this.verificationModeAt;
    data['addressVerifiedBy'] = this.addressVerifiedBy;
    data['idVerifiedBy'] = this.idVerifiedBy;
    data['bankVerifiedBy'] = this.bankVerifiedBy;
    data['aliasName'] = this.aliasName;
    return data;
  }
}
