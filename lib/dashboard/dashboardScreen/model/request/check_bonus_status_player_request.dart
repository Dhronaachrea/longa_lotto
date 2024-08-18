class CheckBonusStatusPlayerRequest {
  String? aliasName;
  String? playerToken;
  int? playerId;

  CheckBonusStatusPlayerRequest(
      {this.aliasName, this.playerToken, this.playerId});

  CheckBonusStatusPlayerRequest.fromJson(Map<String, dynamic> json) {
    aliasName = json['aliasName'];
    playerToken = json['playerToken'];
    playerId = json['playerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aliasName'] = this.aliasName;
    data['playerToken'] = this.playerToken;
    data['playerId'] = this.playerId;
    return data;
  }
}
