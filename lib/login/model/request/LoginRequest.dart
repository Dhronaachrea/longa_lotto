class LoginRequest {
  String? userName;
  String? password;
  String? deviceType;
  String? domainName;
  String? loginDevice;
  String? loginToken;
  String? requestIp;
  String? trackingCipher;
  String? userAgent;

  LoginRequest(
      {this.userName,
        this.password,
        this.deviceType,
        this.domainName,
        this.loginDevice,
        this.loginToken,
        this.requestIp,
        this.trackingCipher,
        this.userAgent});

  LoginRequest.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    password = json['password'];
    deviceType = json['deviceType'];
    domainName = json['domainName'];
    loginDevice = json['loginDevice'];
    loginToken = json['loginToken'];
    requestIp = json['requestIp'];
    trackingCipher = json['trackingCipher'];
    userAgent = json['userAgent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['password'] = this.password;
    data['deviceType'] = this.deviceType;
    data['domainName'] = this.domainName;
    data['loginDevice'] = this.loginDevice;
    data['loginToken'] = this.loginToken;
    data['requestIp'] = this.requestIp;
    data['trackingCipher'] = this.trackingCipher;
    data['userAgent'] = this.userAgent;
    return data;
  }
}
