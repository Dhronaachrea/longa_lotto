class TrackStatusResponseModel {
  int? errorCode;
  String? respMsg;
  List<PlrTrackBonusList>? plrTrackBonusList;

  TrackStatusResponseModel(
      {this.errorCode, this.respMsg, this.plrTrackBonusList});

  TrackStatusResponseModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    respMsg = json['respMsg'];
    if (json['plrTrackBonusList'] != null) {
      plrTrackBonusList = <PlrTrackBonusList>[];
      json['plrTrackBonusList'].forEach((v) {
        plrTrackBonusList!.add(new PlrTrackBonusList.fromJson(v));
      });
    }
    else
    {
      plrTrackBonusList = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['respMsg'] = this.respMsg;
    if (this.plrTrackBonusList != null) {
      data['plrTrackBonusList'] =
          this.plrTrackBonusList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlrTrackBonusList {
  String? userName;
  String? emailId;
  String? referralDate;
  String? mobileNum;
  bool? register;
  bool? depositor;

  PlrTrackBonusList(
      {this.userName,
        this.emailId,
        this.referralDate,
        this.mobileNum,
        this.register,
        this.depositor});

  PlrTrackBonusList.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    emailId = json['emailId'] == null ? json['userName'] : json['emailId'];
    referralDate = json['referralDate'];
    mobileNum = json['mobileNum'];
    register = json['register'];
    depositor = json['depositor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['emailId'] = this.emailId;
    data['referralDate'] = this.referralDate;
    data['mobileNum'] = this.mobileNum;
    data['register'] = this.register;
    data['depositor'] = this.depositor;
    return data;
  }
}