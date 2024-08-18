class RegistrationRequest {
  String? countryCode;
  String? currencyCode;
  String? deviceType;
  String? domainName;
  Null? emailId;
  String? loginDevice;
  String? mobileNo;
  String? userName;
  String? otp;
  String? password;
  String? referCode;
  String? referSource;
  String? registrationType;
  String? requestIp;
  String? userAgent;

  RegistrationRequest(
      {this.countryCode,
        this.currencyCode,
        this.deviceType,
        this.domainName,
        this.emailId,
        this.loginDevice,
        this.mobileNo,
        this.userName,
        this.otp,
        this.password,
        this.referCode,
        this.referSource,
        this.registrationType,
        this.requestIp,
        this.userAgent});

  RegistrationRequest.fromJson(Map<String, dynamic> json) {
    countryCode = json['countryCode'];
    currencyCode = json['currencyCode'];
    deviceType = json['deviceType'];
    domainName = json['domainName'];
    emailId = json['emailId'];
    loginDevice = json['loginDevice'];
    mobileNo = json['mobileNo'];
    userName = json['userName'];
    otp = json['otp'];
    password = json['password'];
    referCode = json['referCode'];
    referSource = json['referSource'];
    registrationType = json['registrationType'];
    requestIp = json['requestIp'];
    userAgent = json['userAgent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['countryCode'] = this.countryCode;
    data['currencyCode'] = this.currencyCode;
    data['deviceType'] = this.deviceType;
    data['domainName'] = this.domainName;
    data['emailId'] = this.emailId;
    data['loginDevice'] = this.loginDevice;
    data['mobileNo'] = this.mobileNo;
    data['userName'] = this.userName;
    data['otp'] = this.otp;
    data['password'] = this.password;
    data['referCode'] = this.referCode;
    data['referSource'] = this.referSource;
    data['registrationType'] = this.registrationType;
    data['requestIp'] = this.requestIp;
    data['userAgent'] = this.userAgent;
    return data;
  }
}
