class LogoutRequest {
  String? domainName;
  String? playerToken;
  int? playerId;

  LogoutRequest({this.domainName, this.playerToken, this.playerId});

  LogoutRequest.fromJson(Map<String, dynamic> json) {
    domainName = json['domainName'];
    playerToken = json['playerToken'];
    playerId = json['playerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['domainName'] = this.domainName;
    data['playerToken'] = this.playerToken;
    data['playerId'] = this.playerId;
    return data;
  }
}
