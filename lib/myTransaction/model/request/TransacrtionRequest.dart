class TransactionRequest {
  String? txnType;
  String? fromDate;
  String? toDate;
  String? offset;
  String? limit;
  String? domainName;
  String? playerToken;
  String? playerId;

  TransactionRequest(
      {this.txnType,
        this.fromDate,
        this.toDate,
        this.offset,
        this.limit,
        this.domainName,
        this.playerToken,
        this.playerId});

  TransactionRequest.fromJson(Map<String, dynamic> json) {
    txnType = json['txnType'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    offset = json['offset'];
    limit = json['limit'];
    domainName = json['domainName'];
    playerToken = json['playerToken'];
    playerId = json['playerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['txnType'] = this.txnType;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['offset'] = this.offset;
    data['limit'] = this.limit;
    data['domainName'] = this.domainName;
    data['playerToken'] = this.playerToken;
    data['playerId'] = this.playerId;
    return data;
  }
}
