// To parse this JSON data, do
//
//     final ticketRequest = ticketRequestFromJson(jsonString);

import 'dart:convert';

TicketRequest ticketRequestFromJson(String str) => TicketRequest.fromJson(json.decode(str));

String ticketRequestToJson(TicketRequest data) => json.encode(data.toJson());

class TicketRequest {
  TicketRequest({
    this.domainName,
    this.fromDate,
    this.limit,
    this.offset,
    this.playerId,
    this.playerToken,
    this.toDate,
    this.txnType,
    this.orderBy,
  });

  String? domainName;
  String? fromDate;
  String? limit;
  String? offset;
  String? playerId;
  String? playerToken;
  String? toDate;
  String? txnType;
  String? orderBy;

  factory TicketRequest.fromJson(Map<String, dynamic> json) => TicketRequest(
    domainName: json["domainName"],
    fromDate: json["fromDate"],
    limit: json["limit"],
    offset: json["offset"],
    playerId: json["playerId"],
    playerToken: json["playerToken"],
    toDate: json["toDate"],
    txnType: json["txnType"],
  );

  Map<String, dynamic> toJson() => {
    "domainName": domainName,
    "fromDate": fromDate,
    "limit": limit,
    "offset": offset,
    "playerId": playerId,
    "playerToken": playerToken,
    "toDate": toDate,
    "txnType": txnType,
  };
}
