// To parse this JSON data, do
//
//     final inboxResponseModel = inboxResponseModelFromJson(jsonString);

import 'dart:convert';

InboxResponseModel inboxResponseModelFromJson(String str) =>
    InboxResponseModel.fromJson(json.decode(str));

String inboxResponseModelToJson(InboxResponseModel data) =>
    json.encode(data.toJson());

class InboxResponseModel {
  InboxResponseModel({
    this.errorCode,
    this.respMsg,
    this.plrInboxList,
    this.unreadMsgCount,
    this.contentPath,
  });

  int? errorCode;
  String? respMsg;
  List<PlrInboxList>? plrInboxList;
  int? unreadMsgCount;
  String? contentPath;

  factory InboxResponseModel.fromJson(Map<String, dynamic> json) =>
      InboxResponseModel(
        errorCode: json["errorCode"],
        respMsg: json["respMsg"],
        plrInboxList: (json["plrInboxList"] != null) ? List<PlrInboxList>.from(json["plrInboxList"].map((x) => PlrInboxList.fromJson(x))) : null,
        unreadMsgCount: json["unreadMsgCount"],
        contentPath: json["contentPath"],
      );

  Map<String, dynamic> toJson() => {
    "errorCode": errorCode,
    "respMsg": respMsg,
    "plrInboxList": plrInboxList != null
        ? List<PlrInboxList>.from(plrInboxList!.map((x) => x.toJson()))
        : null,
    "unreadMsgCount": unreadMsgCount,
    "contentPath": contentPath,
  };
}

class PlrInboxList {
  PlrInboxList({
    this.from,
    this.subject,
    this.mailSentDate,
    this.status,
    this.contentId,
    this.plrInboxListContentId,
    this.inboxId,
    this.stared,
  });

  String? from;
  String? subject;
  String? mailSentDate;
  String? status;
  String? contentId;
  String? plrInboxListContentId;
  int? inboxId;
  bool? stared;

  factory PlrInboxList.fromJson(Map<String, dynamic> json) => PlrInboxList(
    from: json["from"],
    subject: json["subject"],
    mailSentDate: json["mailSentDate"],
    status: json["status"],
    contentId: json["contentId"],
    plrInboxListContentId: json["content_id"],
    inboxId: json["inboxId"],
    stared: json["stared"],
  );

  Map<String, dynamic> toJson() => {
    "from": from,
    "subject": subject,
    "mailSentDate": mailSentDate,
    "status": status,
    "contentId": contentId,
    "content_id": plrInboxListContentId,
    "inboxId": inboxId,
    "stared": stared,
  };
}
