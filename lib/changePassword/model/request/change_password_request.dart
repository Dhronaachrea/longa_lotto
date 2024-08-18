class ChangePasswordRequest {
  String? oldPassword;
  String? newPassword;
  String? domainName;
  String? playerToken;
  int? playerId;

  ChangePasswordRequest(
      {this.oldPassword,
        this.newPassword,
        this.domainName,
        this.playerToken,
        this.playerId});

  ChangePasswordRequest.fromJson(Map<String, dynamic> json) {
    oldPassword = json['oldPassword'];
    newPassword = json['newPassword'];
    domainName = json['domainName'];
    playerToken = json['playerToken'];
    playerId = json['playerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oldPassword'] = this.oldPassword;
    data['newPassword'] = this.newPassword;
    data['domainName'] = this.domainName;
    data['playerToken'] = this.playerToken;
    data['playerId'] = this.playerId;
    return data;
  }
}
