class TicketResponse {
  int? errorCode;
  String? respMsg;
  List<TicketList>? ticketList;

  TicketResponse({this.errorCode, this.ticketList});

  TicketResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    respMsg = json['respMsg'];
    if (json['ticketList'] != null) {
      ticketList = <TicketList>[];
      json['ticketList'].forEach((v) {
        ticketList!.add(new TicketList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['respMsg'] = this.respMsg;
    if (this.ticketList != null) {
      data['ticketList'] = this.ticketList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TicketList {
  String? transactionDate;
  String? transactionId;
  String? refTxnNo;
  String? amount;
  String? gameId;
  String? gameType;
  String? gameName;
  String? status;
  String? serviceCode;
  String? walletProvider;

  TicketList(
      {this.transactionDate,
        this.transactionId,
        this.refTxnNo,
        this.amount,
        this.gameId,
        this.gameType,
        this.gameName,
        this.status,
        this.serviceCode,
        this.walletProvider});

  TicketList.fromJson(Map<String, dynamic> json) {
    transactionDate = json['transactionDate'];
    transactionId = json['transactionId'];
    refTxnNo = json['refTxnNo'];
    amount = json['amount'];
    gameId = json['gameId'];
    gameType = json['gameType'];
    gameName = json['gameName'];
    status = json['status'];
    serviceCode = json['serviceCode'];
    walletProvider = json['walletProvider'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transactionDate'] = this.transactionDate;
    data['transactionId'] = this.transactionId;
    data['refTxnNo'] = this.refTxnNo;
    data['amount'] = this.amount;
    data['gameId'] = this.gameId;
    data['gameType'] = this.gameType;
    data['gameName'] = this.gameName;
    data['status'] = this.status;
    data['serviceCode'] = this.serviceCode;
    data['walletProvider'] = this.walletProvider;
    return data;
  }
}