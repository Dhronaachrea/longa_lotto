class RegisterPlayerWithScannerResponse {
  int? firstDepositCampTrackId;
  String? domainName;
  String? firstDepositReferSource;
  PlayerLoginInfo? playerLoginInfo;
  String? rummyDeepLink;
  int? firstDepositReferSourceId;
  String? profileStatus;
  int? errorCode;
  int? firstDepositSubSourceId;
  RamPlayerInfo? ramPlayerInfo;
  String? playerToken;

  RegisterPlayerWithScannerResponse(
      {this.firstDepositCampTrackId,
        this.domainName,
        this.firstDepositReferSource,
        this.playerLoginInfo,
        this.rummyDeepLink,
        this.firstDepositReferSourceId,
        this.profileStatus,
        this.errorCode,
        this.firstDepositSubSourceId,
        this.ramPlayerInfo,
        this.playerToken});

  RegisterPlayerWithScannerResponse.fromJson(Map<String, dynamic> json) {
    firstDepositCampTrackId = json['firstDepositCampTrackId'];
    domainName = json['domainName'];
    firstDepositReferSource = json['firstDepositReferSource'];
    playerLoginInfo = json['playerLoginInfo'] != null
        ? new PlayerLoginInfo.fromJson(json['playerLoginInfo'])
        : null;
    rummyDeepLink = json['rummyDeepLink'];
    firstDepositReferSourceId = json['firstDepositReferSourceId'];
    profileStatus = json['profileStatus'];
    errorCode = json['errorCode'];
    firstDepositSubSourceId = json['firstDepositSubSourceId'];
    ramPlayerInfo = json['ramPlayerInfo'] != null
        ? new RamPlayerInfo.fromJson(json['ramPlayerInfo'])
        : null;
    playerToken = json['playerToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstDepositCampTrackId'] = this.firstDepositCampTrackId;
    data['domainName'] = this.domainName;
    data['firstDepositReferSource'] = this.firstDepositReferSource;
    if (this.playerLoginInfo != null) {
      data['playerLoginInfo'] = this.playerLoginInfo!.toJson();
    }
    data['rummyDeepLink'] = this.rummyDeepLink;
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

class PlayerLoginInfo {
  int? unreadMsgCount;
  String? country;
  WalletBean? walletBean;
  String? autoPassword;
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
  int? affilateId;
  String? referFriendCode;
  String? phoneVerified;
  String? avatarPath;
  String? userName;
  String? registrationIp;
  String? olaPlayer;
  String? lastLoginIP;
  String? isPlay2x;
  String? emailVerified;
  String? commonContentPath;
  String? firstDepositDate;

  PlayerLoginInfo(
      {this.unreadMsgCount,
        this.country,
        this.walletBean,
        this.autoPassword,
        this.regDevice,
        this.ageVerified,
        this.lastLoginDate,
        this.firstLoginDate,
        this.countryCode,
        this.playerType,
        this.registrationDate,
        this.state,
        this.playerStatus,
        this.referSource,
        this.addressVerified,
        this.playerId,
        this.affilateId,
        this.referFriendCode,
        this.phoneVerified,
        this.avatarPath,
        this.userName,
        this.registrationIp,
        this.olaPlayer,
        this.lastLoginIP,
        this.isPlay2x,
        this.emailVerified,
        this.commonContentPath,
        this.firstDepositDate});

  PlayerLoginInfo.fromJson(Map<String, dynamic> json) {
    unreadMsgCount = json['unreadMsgCount'];
    country = json['country'];
    walletBean = json['walletBean'] != null
        ? new WalletBean.fromJson(json['walletBean'])
        : null;
    autoPassword = json['autoPassword'];
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
    affilateId = json['affilateId'];
    referFriendCode = json['referFriendCode'];
    phoneVerified = json['phoneVerified'];
    avatarPath = json['avatarPath'];
    userName = json['userName'];
    registrationIp = json['registrationIp'];
    olaPlayer = json['olaPlayer'];
    lastLoginIP = json['lastLoginIP'];
    isPlay2x = json['isPlay2x'];
    emailVerified = json['emailVerified'];
    commonContentPath = json['commonContentPath'];
    firstDepositDate = json['firstDepositDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unreadMsgCount'] = this.unreadMsgCount;
    data['country'] = this.country;
    if (this.walletBean != null) {
      data['walletBean'] = this.walletBean!.toJson();
    }
    data['autoPassword'] = this.autoPassword;
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
    data['affilateId'] = this.affilateId;
    data['referFriendCode'] = this.referFriendCode;
    data['phoneVerified'] = this.phoneVerified;
    data['avatarPath'] = this.avatarPath;
    data['userName'] = this.userName;
    data['registrationIp'] = this.registrationIp;
    data['olaPlayer'] = this.olaPlayer;
    data['lastLoginIP'] = this.lastLoginIP;
    data['isPlay2x'] = this.isPlay2x;
    data['emailVerified'] = this.emailVerified;
    data['commonContentPath'] = this.commonContentPath;
    data['firstDepositDate'] = this.firstDepositDate;
    return data;
  }
}

class WalletBean {
  int? totalBalance;
  int? cashBalance;
  int? depositBalance;
  int? winningBalance;
  int? bonusBalance;
  int? withdrawableBal;
  int? practiceBalance;
  String? currency;
  String? currencyDisplayCode;
  String? preferredWallet;
  int? totalDepositBalance;
  int? totalWithdrawableBalance;

  WalletBean(
      {this.totalBalance,
        this.cashBalance,
        this.depositBalance,
        this.winningBalance,
        this.bonusBalance,
        this.withdrawableBal,
        this.practiceBalance,
        this.currency,
        this.currencyDisplayCode,
        this.preferredWallet,
        this.totalDepositBalance,
        this.totalWithdrawableBalance});

  WalletBean.fromJson(Map<String, dynamic> json) {
    totalBalance = json['totalBalance'];
    cashBalance = json['cashBalance'];
    depositBalance = json['depositBalance'];
    winningBalance = json['winningBalance'];
    bonusBalance = json['bonusBalance'];
    withdrawableBal = json['withdrawableBal'];
    practiceBalance = json['practiceBalance'];
    currency = json['currency'];
    currencyDisplayCode = json['currencyDisplayCode'];
    preferredWallet = json['preferredWallet'];
    totalDepositBalance = json['totalDepositBalance'];
    totalWithdrawableBalance = json['totalWithdrawableBalance'];
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
    data['preferredWallet'] = this.preferredWallet;
    data['totalDepositBalance'] = this.totalDepositBalance;
    data['totalWithdrawableBalance'] = this.totalWithdrawableBalance;
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
  Null? profileExpiredAt;
  String? docUploaded;
  Null? uploadPendingDate;
  Null? verifiedBy;
  Null? verificationAssignAt;
  Null? verificationModeAt;
  Null? addressVerifiedBy;
  Null? idVerifiedBy;
  Null? bankVerifiedBy;
  String? isMpinExist;
  String? aliasName;

  RamPlayerInfo(
      {this.id,
        this.merchantId,
        this.domainId,
        this.playerId,
        this.addressVerified,
        this.nameVerified,
        this.emailVerified,
        this.mobileVerified,
        this.ageVerified,
        this.taxationIdVerified,
        this.securityQuestionVerified,
        this.idVerified,
        this.bankVerified,
        this.addressVerifiedAt,
        this.profileStatus,
        this.kycStatus,
        this.emailVerifiedAt,
        this.mobileVerifiedAt,
        this.ageVerifiedAt,
        this.taxationIdVerifiedAt,
        this.securityQuestionVerifiedAt,
        this.idVerifiedAt,
        this.bankVerifiedAt,
        this.createdAt,
        this.updatedAt,
        this.profileExpiredAt,
        this.docUploaded,
        this.uploadPendingDate,
        this.verifiedBy,
        this.verificationAssignAt,
        this.verificationModeAt,
        this.addressVerifiedBy,
        this.idVerifiedBy,
        this.bankVerifiedBy,
        this.isMpinExist,
        this.aliasName});

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
    isMpinExist = json['isMpinExist'];
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
    data['isMpinExist'] = this.isMpinExist;
    data['aliasName'] = this.aliasName;
    return data;
  }
}
