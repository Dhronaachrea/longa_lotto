class VersionControlResponse {
  int? errorCode;
  String? respMsg;
  AppDetails? appDetails;
  GameEngineInfo? gameEngineInfo;
  Profile? profile;
  bool? isplayerLogin;
  bool? staticLogoDisplay;

  VersionControlResponse(
      {this.errorCode,
        this.respMsg,
        this.appDetails,
        this.gameEngineInfo,
        this.profile,
        this.isplayerLogin,
        this.staticLogoDisplay});

  VersionControlResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    respMsg = json['respMsg'];
    appDetails = json['appDetails'] != null
        ? new AppDetails.fromJson(json['appDetails'])
        : null;
    gameEngineInfo = json['gameEngineInfo'] != null
        ? new GameEngineInfo.fromJson(json['gameEngineInfo'])
        : null;
    profile =
    json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
    isplayerLogin = json['isplayerLogin'];
    staticLogoDisplay = json['staticLogoDisplay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['respMsg'] = this.respMsg;
    if (this.appDetails != null) {
      data['appDetails'] = this.appDetails!.toJson();
    }
    if (this.gameEngineInfo != null) {
      data['gameEngineInfo'] = this.gameEngineInfo!.toJson();
    }
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    data['isplayerLogin'] = this.isplayerLogin;
    data['staticLogoDisplay'] = this.staticLogoDisplay;
    return data;
  }
}

class AppDetails {
  String? os;
  String? appType;
  String? version;
  String? versionCode;
  String? versionDate;
  String? url;
  bool? mandatory;
  String? message;
  String? versionType;
  bool? isUpdateAvailable;

  AppDetails(
      {this.os,
        this.appType,
        this.version,
        this.versionCode,
        this.versionDate,
        this.url,
        this.mandatory,
        this.message,
        this.versionType,
        this.isUpdateAvailable});

  AppDetails.fromJson(Map<String, dynamic> json) {
    os = json['os'];
    appType = json['appType'];
    version = json['version'];
    versionCode = json['versionCode'];
    versionDate = json['versionDate'];
    url = json['url'];
    mandatory = json['mandatory'];
    message = json['message'];
    versionType = json['version_type'];
    isUpdateAvailable = json['isUpdateAvailable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['os'] = this.os;
    data['appType'] = this.appType;
    data['version'] = this.version;
    data['versionCode'] = this.versionCode;
    data['versionDate'] = this.versionDate;
    data['url'] = this.url;
    data['mandatory'] = this.mandatory;
    data['message'] = this.message;
    data['version_type'] = this.versionType;
    data['isUpdateAvailable'] = this.isUpdateAvailable;
    return data;
  }
}

class GameEngineInfo {
  GMW? gMW;
  GMW? dGE;
  GMW? sBS;
  GMW? iGE;
  GMW? mRSLOTTY;
  GMW? betGames;
  GMW? sLE;
  GMW? vS;

  GameEngineInfo(
      {this.gMW,
        this.dGE,
        this.sBS,
        this.iGE,
        this.mRSLOTTY,
        this.betGames,
        this.sLE,
        this.vS});

  GameEngineInfo.fromJson(Map<String, dynamic> json) {
    gMW = json['GMW'] != null ? new GMW.fromJson(json['GMW']) : null;
    dGE = json['DGE'] != null ? new GMW.fromJson(json['DGE']) : null;
    sBS = json['SBS'] != null ? new GMW.fromJson(json['SBS']) : null;
    iGE = json['IGE'] != null ? new GMW.fromJson(json['IGE']) : null;
    mRSLOTTY =
    json['MRSLOTTY'] != null ? new GMW.fromJson(json['MRSLOTTY']) : null;
    betGames =
    json['BetGames'] != null ? new GMW.fromJson(json['BetGames']) : null;
    sLE = json['SLE'] != null ? new GMW.fromJson(json['SLE']) : null;
    vS = json['VS'] != null ? new GMW.fromJson(json['VS']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.gMW != null) {
      data['GMW'] = this.gMW!.toJson();
    }
    if (this.dGE != null) {
      data['DGE'] = this.dGE!.toJson();
    }
    if (this.sBS != null) {
      data['SBS'] = this.sBS!.toJson();
    }
    if (this.iGE != null) {
      data['IGE'] = this.iGE!.toJson();
    }
    if (this.mRSLOTTY != null) {
      data['MRSLOTTY'] = this.mRSLOTTY!.toJson();
    }
    if (this.betGames != null) {
      data['BetGames'] = this.betGames!.toJson();
    }
    if (this.sLE != null) {
      data['SLE'] = this.sLE!.toJson();
    }
    if (this.vS != null) {
      data['VS'] = this.vS!.toJson();
    }
    return data;
  }
}

class GMW {
  String? serverUrl;

  GMW({this.serverUrl});

  GMW.fromJson(Map<String, dynamic> json) {
    serverUrl = json['serverUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serverUrl'] = this.serverUrl;
    return data;
  }
}

class Profile {
  int? errorCode;
  String? playerToken;
  PlayerLoginInfo? playerLoginInfo;
  String? domainName;

  Profile(
      {this.errorCode,
        this.playerToken,
        this.playerLoginInfo,
        this.domainName});

  Profile.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    playerToken = json['playerToken'];
    playerLoginInfo = json['playerLoginInfo'] != null
        ? new PlayerLoginInfo.fromJson(json['playerLoginInfo'])
        : null;
    domainName = json['domainName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['playerToken'] = this.playerToken;
    if (this.playerLoginInfo != null) {
      data['playerLoginInfo'] = this.playerLoginInfo!.toJson();
    }
    data['domainName'] = this.domainName;
    return data;
  }
}

class PlayerLoginInfo {
  String? userName;
  int? playerId;
  WalletBean? walletBean;
  int? unreadMsgCount;
  String? avatarPath;
  String? playerStatus;
  String? emailId;
  String? mobileNo;
  String? firstName;
  String? lastName;
  String? gender;
  String? dob;
  String? country;
  String? regDevice;
  String? registrationDate;
  String? firstDepositDate;
  String? olaPlayer;
  String? commonContentPath;
  String? referSource;
  int? affilateId;
  String? lastLoginIP;
  String? isPlay2x;
  String? referFriendCode;
  String? emailVerified;
  String? phoneVerified;
  String? playerType;
  String? ageVerified;
  String? addressVerified;

  PlayerLoginInfo(
      {this.userName,
        this.playerId,
        this.walletBean,
        this.unreadMsgCount,
        this.avatarPath,
        this.playerStatus,
        this.emailId,
        this.mobileNo,
        this.firstName,
        this.lastName,
        this.gender,
        this.dob,
        this.country,
        this.regDevice,
        this.registrationDate,
        this.firstDepositDate,
        this.olaPlayer,
        this.commonContentPath,
        this.referSource,
        this.affilateId,
        this.lastLoginIP,
        this.isPlay2x,
        this.referFriendCode,
        this.emailVerified,
        this.phoneVerified,
        this.playerType,
        this.ageVerified,
        this.addressVerified});

  PlayerLoginInfo.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    playerId = json['playerId'];
    walletBean = json['walletBean'] != null
        ? new WalletBean.fromJson(json['walletBean'])
        : null;
    unreadMsgCount = json['unreadMsgCount'];
    avatarPath = json['avatarPath'];
    playerStatus = json['playerStatus'];
    emailId = json['emailId'];
    mobileNo = json['mobileNo'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    gender = json['gender'];
    dob = json['dob'];
    country = json['country'];
    regDevice = json['regDevice'];
    registrationDate = json['registrationDate'];
    firstDepositDate = json['firstDepositDate'];
    olaPlayer = json['olaPlayer'];
    commonContentPath = json['commonContentPath'];
    referSource = json['referSource'];
    affilateId = json['affilateId'];
    lastLoginIP = json['lastLoginIP'];
    isPlay2x = json['isPlay2x'];
    referFriendCode = json['referFriendCode'];
    emailVerified = json['emailVerified'];
    phoneVerified = json['phoneVerified'];
    playerType = json['playerType'];
    ageVerified = json['ageVerified'];
    addressVerified = json['addressVerified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['playerId'] = this.playerId;
    if (this.walletBean != null) {
      data['walletBean'] = this.walletBean!.toJson();
    }
    data['unreadMsgCount'] = this.unreadMsgCount;
    data['avatarPath'] = this.avatarPath;
    data['playerStatus'] = this.playerStatus;
    data['emailId'] = this.emailId;
    data['mobileNo'] = this.mobileNo;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['country'] = this.country;
    data['regDevice'] = this.regDevice;
    data['registrationDate'] = this.registrationDate;
    data['firstDepositDate'] = this.firstDepositDate;
    data['olaPlayer'] = this.olaPlayer;
    data['commonContentPath'] = this.commonContentPath;
    data['referSource'] = this.referSource;
    data['affilateId'] = this.affilateId;
    data['lastLoginIP'] = this.lastLoginIP;
    data['isPlay2x'] = this.isPlay2x;
    data['referFriendCode'] = this.referFriendCode;
    data['emailVerified'] = this.emailVerified;
    data['phoneVerified'] = this.phoneVerified;
    data['playerType'] = this.playerType;
    data['ageVerified'] = this.ageVerified;
    data['addressVerified'] = this.addressVerified;
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
  String? currency;

  WalletBean(
      {this.totalBalance,
        this.cashBalance,
        this.depositBalance,
        this.winningBalance,
        this.bonusBalance,
        this.withdrawableBal,
        this.practiceBalance,
        this.currency});

  WalletBean.fromJson(Map<String, dynamic> json) {
    totalBalance = json['totalBalance'];
    cashBalance = json['cashBalance'];
    depositBalance = json['depositBalance'];
    winningBalance = json['winningBalance'];
    bonusBalance = json['bonusBalance'];
    withdrawableBal = json['withdrawableBal'];
    practiceBalance = json['practiceBalance'];
    currency = json['currency'];
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
    return data;
  }
}
