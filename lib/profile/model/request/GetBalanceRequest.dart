class GetBalanceRequest {
  String? domainName;
  String? playerId;
  String? playerToken;

  GetBalanceRequest({this.domainName, this.playerId, this.playerToken});

  GetBalanceRequest.fromJson(Map<String, dynamic> json) {
    domainName = json['domainName'];
    playerId = json['playerId'];
    playerToken = json['playerToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['domainName'] = this.domainName;
    data['playerId'] = this.playerId;
    data['playerToken'] = this.playerToken;
    return data;
  }
}
