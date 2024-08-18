class EditProfileResponse {
  String? errorMessage;
  int? errorCode;
  Data? data;

  EditProfileResponse({this.errorMessage, this.errorCode, this.data});

  EditProfileResponse.fromJson(Map<String, dynamic> json) {
    errorMessage = json['errorMessage'];
    errorCode = json['errorCode'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorMessage'] = this.errorMessage;
    data['errorCode'] = this.errorCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Null>? latestDocuments;
  PlayerVerificationStatus? playerVerificationStatus;
  PlayerInfo? playerInfo;
  PlayerMaster? playerMaster;

  Data(
      {this.latestDocuments,
        this.playerVerificationStatus,
        this.playerInfo,
        this.playerMaster});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['latestDocuments'] != null) {
      latestDocuments = <Null>[];
      json['latestDocuments'].forEach((v) {
        //latestDocuments!.add(new Null.fromJson(v));
      });
    }
    playerVerificationStatus = json['playerVerificationStatus'] != null
        ? new PlayerVerificationStatus.fromJson(
        json['playerVerificationStatus'])
        : null;
    playerInfo = json['playerInfo'] != null
        ? new PlayerInfo.fromJson(json['playerInfo'])
        : null;
    playerMaster = json['playerMaster'] != null
        ? new PlayerMaster.fromJson(json['playerMaster'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.latestDocuments != null) {
      //data['latestDocuments'] = this.latestDocuments!.map((v) => v.toJson()).toList();
    }
    if (this.playerVerificationStatus != null) {
      data['playerVerificationStatus'] =
          this.playerVerificationStatus!.toJson();
    }
    if (this.playerInfo != null) {
      data['playerInfo'] = this.playerInfo!.toJson();
    }
    if (this.playerMaster != null) {
      data['playerMaster'] = this.playerMaster!.toJson();
    }
    return data;
  }
}

class PlayerVerificationStatus {
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
  String? uploadPendingDate;
  String? verifiedBy;
  String? verificationAssignAt;
  String? verificationModeAt;
  String? addressVerifiedBy;
  String? idVerifiedBy;
  String? bankVerifiedBy;

  PlayerVerificationStatus(
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
        this.bankVerifiedBy});

  PlayerVerificationStatus.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}

class PlayerInfo {
  int? id;
  int? playerId;
  int? domainId;
  int? aliasId;
  String? gender;
  String? dateOfBirth;
  String? firstName;
  String? middleName;
  String? lastName;
  String? addressOne;
  String? addressTwo;
  String? city;
  String? town;
  String? state;
  String? country;
  String? zip;
  String? currencyCode;
  String? regCity;
  String? regCountryCode;
  String? regIp;
  String? reason;
  int? invalidChangepwdTry;
  String? invalidChangepwdDate;
  int? playerAge;
  String? smsOpted;
  String? emailOpted;
  String? fcmIdAndroid;
  String? fcmIdIos;
  String? currAppVer;
  String? primaryIdValue;
  bool? isPep;
  String? nationality;

  PlayerInfo(
      {this.id,
        this.playerId,
        this.domainId,
        this.aliasId,
        this.gender,
        this.dateOfBirth,
        this.firstName,
        this.middleName,
        this.lastName,
        this.addressOne,
        this.addressTwo,
        this.city,
        this.town,
        this.state,
        this.country,
        this.zip,
        this.currencyCode,
        this.regCity,
        this.regCountryCode,
        this.regIp,
        this.reason,
        this.invalidChangepwdTry,
        this.invalidChangepwdDate,
        this.playerAge,
        this.smsOpted,
        this.emailOpted,
        this.fcmIdAndroid,
        this.fcmIdIos,
        this.currAppVer,
        this.primaryIdValue,
        this.isPep,
        this.nationality});

  PlayerInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    playerId = json['playerId'];
    domainId = json['domainId'];
    aliasId = json['aliasId'];
    gender = json['gender'];
    dateOfBirth = json['dateOfBirth'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    addressOne = json['addressOne'];
    addressTwo = json['addressTwo'];
    city = json['city'];
    town = json['town'];
    state = json['state'];
    country = json['country'];
    zip = json['zip'];
    currencyCode = json['currencyCode'];
    regCity = json['regCity'];
    regCountryCode = json['regCountryCode'];
    regIp = json['regIp'];
    reason = json['reason'];
    invalidChangepwdTry = json['invalidChangepwdTry'];
    invalidChangepwdDate = json['invalidChangepwdDate'];
    playerAge = json['playerAge'];
    smsOpted = json['smsOpted'];
    emailOpted = json['emailOpted'];
    fcmIdAndroid = json['fcmIdAndroid'];
    fcmIdIos = json['fcmIdIos'];
    currAppVer = json['currAppVer'];
    primaryIdValue = json['primaryIdValue'];
    isPep = json['isPep'];
    nationality = json['nationality'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['playerId'] = this.playerId;
    data['domainId'] = this.domainId;
    data['aliasId'] = this.aliasId;
    data['gender'] = this.gender;
    data['dateOfBirth'] = this.dateOfBirth;
    data['firstName'] = this.firstName;
    data['middleName'] = this.middleName;
    data['lastName'] = this.lastName;
    data['addressOne'] = this.addressOne;
    data['addressTwo'] = this.addressTwo;
    data['city'] = this.city;
    data['town'] = this.town;
    data['state'] = this.state;
    data['country'] = this.country;
    data['zip'] = this.zip;
    data['currencyCode'] = this.currencyCode;
    data['regCity'] = this.regCity;
    data['regCountryCode'] = this.regCountryCode;
    data['regIp'] = this.regIp;
    data['reason'] = this.reason;
    data['invalidChangepwdTry'] = this.invalidChangepwdTry;
    data['invalidChangepwdDate'] = this.invalidChangepwdDate;
    data['playerAge'] = this.playerAge;
    data['smsOpted'] = this.smsOpted;
    data['emailOpted'] = this.emailOpted;
    data['fcmIdAndroid'] = this.fcmIdAndroid;
    data['fcmIdIos'] = this.fcmIdIos;
    data['currAppVer'] = this.currAppVer;
    data['primaryIdValue'] = this.primaryIdValue;
    data['isPep'] = this.isPep;
    data['nationality'] = this.nationality;
    return data;
  }
}

class PlayerMaster {
  int? playerId;
  int? merchantId;
  int? domainId;
  int? aliasId;
  String? merchantPlayerId;
  String? autoPassword;
  String? mobileNo;
  String? username;
  String? password;
  String? emailId;
  String? userImagePath;
  int? vipLevelId;
  String? registrationDate;
  String? lastLoginCity;
  String? lastLoginCountryCode;
  String? lastLoginIp;
  String? lastLoginThrough;
  String? profileStatus;
  String? plrStatus;
  String? profileExpiredAt;
  String? affiliateBind;
  String? affiliateId;
  String? affiliateReference;
  String? referFriendCode;
  String? regDevice;
  String? profileType;
  String? userAgent;
  int? invalidLoginTry;
  String? lastLoginDate;
  String? uploadPendingDate;
  String? createdAt;
  String? updatedAt;
  int? securityQuestionCount;
  String? inactiveDate;
  String? accountStatus;
  String? failedLoginBlockDate;

  PlayerMaster(
      {this.playerId,
        this.merchantId,
        this.domainId,
        this.aliasId,
        this.merchantPlayerId,
        this.autoPassword,
        this.mobileNo,
        this.username,
        this.password,
        this.emailId,
        this.userImagePath,
        this.vipLevelId,
        this.registrationDate,
        this.lastLoginCity,
        this.lastLoginCountryCode,
        this.lastLoginIp,
        this.lastLoginThrough,
        this.profileStatus,
        this.plrStatus,
        this.profileExpiredAt,
        this.affiliateBind,
        this.affiliateId,
        this.affiliateReference,
        this.referFriendCode,
        this.regDevice,
        this.profileType,
        this.userAgent,
        this.invalidLoginTry,
        this.lastLoginDate,
        this.uploadPendingDate,
        this.createdAt,
        this.updatedAt,
        this.securityQuestionCount,
        this.inactiveDate,
        this.accountStatus,
        this.failedLoginBlockDate});

  PlayerMaster.fromJson(Map<String, dynamic> json) {
    playerId = json['playerId'];
    merchantId = json['merchantId'];
    domainId = json['domainId'];
    aliasId = json['aliasId'];
    merchantPlayerId = json['merchantPlayerId'];
    autoPassword = json['autoPassword'];
    mobileNo = json['mobileNo'];
    username = json['username'];
    password = json['password'];
    emailId = json['emailId'];
    userImagePath = json['userImagePath'];
    vipLevelId = json['vipLevelId'];
    registrationDate = json['registrationDate'];
    lastLoginCity = json['lastLoginCity'];
    lastLoginCountryCode = json['lastLoginCountryCode'];
    lastLoginIp = json['lastLoginIp'];
    lastLoginThrough = json['lastLoginThrough'];
    profileStatus = json['profileStatus'];
    plrStatus = json['plrStatus'];
    profileExpiredAt = json['profileExpiredAt'];
    affiliateBind = json['affiliateBind'];
    affiliateId = json['affiliateId'];
    affiliateReference = json['affiliateReference'];
    referFriendCode = json['referFriendCode'];
    regDevice = json['regDevice'];
    profileType = json['profileType'];
    userAgent = json['userAgent'];
    invalidLoginTry = json['invalidLoginTry'];
    lastLoginDate = json['lastLoginDate'];
    uploadPendingDate = json['uploadPendingDate'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    securityQuestionCount = json['securityQuestionCount'];
    inactiveDate = json['inactiveDate'];
    accountStatus = json['accountStatus'];
    failedLoginBlockDate = json['failedLoginBlockDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['playerId'] = this.playerId;
    data['merchantId'] = this.merchantId;
    data['domainId'] = this.domainId;
    data['aliasId'] = this.aliasId;
    data['merchantPlayerId'] = this.merchantPlayerId;
    data['autoPassword'] = this.autoPassword;
    data['mobileNo'] = this.mobileNo;
    data['username'] = this.username;
    data['password'] = this.password;
    data['emailId'] = this.emailId;
    data['userImagePath'] = this.userImagePath;
    data['vipLevelId'] = this.vipLevelId;
    data['registrationDate'] = this.registrationDate;
    data['lastLoginCity'] = this.lastLoginCity;
    data['lastLoginCountryCode'] = this.lastLoginCountryCode;
    data['lastLoginIp'] = this.lastLoginIp;
    data['lastLoginThrough'] = this.lastLoginThrough;
    data['profileStatus'] = this.profileStatus;
    data['plrStatus'] = this.plrStatus;
    data['profileExpiredAt'] = this.profileExpiredAt;
    data['affiliateBind'] = this.affiliateBind;
    data['affiliateId'] = this.affiliateId;
    data['affiliateReference'] = this.affiliateReference;
    data['referFriendCode'] = this.referFriendCode;
    data['regDevice'] = this.regDevice;
    data['profileType'] = this.profileType;
    data['userAgent'] = this.userAgent;
    data['invalidLoginTry'] = this.invalidLoginTry;
    data['lastLoginDate'] = this.lastLoginDate;
    data['uploadPendingDate'] = this.uploadPendingDate;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['securityQuestionCount'] = this.securityQuestionCount;
    data['inactiveDate'] = this.inactiveDate;
    data['accountStatus'] = this.accountStatus;
    data['failedLoginBlockDate'] = this.failedLoginBlockDate;
    return data;
  }
}
