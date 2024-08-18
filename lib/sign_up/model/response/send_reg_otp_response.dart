class SendRegOtpResponse {
  String? errorMessage;
  int? errorCode;
  Data? data;

  SendRegOtpResponse({this.errorMessage, this.errorCode, this.data});

  SendRegOtpResponse.fromJson(Map<String, dynamic> json) {
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
  int? mobVerificationExpiry;
  String? mobVerificationCode;
  Null? emailId;
  Null? emailVerificationExpiry;
  int? id;
  String? mobileNo;
  Null? otpActionType;
  int? domainId;
  Null? emailVerificationCode;

  Data(
      {this.mobVerificationExpiry,
        this.mobVerificationCode,
        this.emailId,
        this.emailVerificationExpiry,
        this.id,
        this.mobileNo,
        this.otpActionType,
        this.domainId,
        this.emailVerificationCode});

  Data.fromJson(Map<String, dynamic> json) {
    mobVerificationExpiry = json['mobVerificationExpiry'];
    mobVerificationCode = json['mobVerificationCode'];
    emailId = json['emailId'];
    emailVerificationExpiry = json['emailVerificationExpiry'];
    id = json['id'];
    mobileNo = json['mobileNo'];
    otpActionType = json['otpActionType'];
    domainId = json['domainId'];
    emailVerificationCode = json['emailVerificationCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobVerificationExpiry'] = this.mobVerificationExpiry;
    data['mobVerificationCode'] = this.mobVerificationCode;
    data['emailId'] = this.emailId;
    data['emailVerificationExpiry'] = this.emailVerificationExpiry;
    data['id'] = this.id;
    data['mobileNo'] = this.mobileNo;
    data['otpActionType'] = this.otpActionType;
    data['domainId'] = this.domainId;
    data['emailVerificationCode'] = this.emailVerificationCode;
    return data;
  }
}
