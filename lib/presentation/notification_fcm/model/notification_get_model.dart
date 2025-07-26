// To parse this JSON data, do
//
//     final notificationGetModel = notificationGetModelFromJson(jsonString);

import 'dart:convert';

NotificationGetModel notificationGetModelFromJson(String str) =>
    NotificationGetModel.fromJson(json.decode(str));

String notificationGetModelToJson(NotificationGetModel data) =>
    json.encode(data.toJson());

class NotificationGetModel {
  bool? success;
  String? message;
  List<Datum>? data;

  NotificationGetModel({this.success, this.message, this.data});

  factory NotificationGetModel.fromJson(Map<String, dynamic> json) =>
      NotificationGetModel(
        success: json["success"],
        message: json["message"],
        data:
            json["data"] == null
                ? []
                : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data":
        data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? id;
  String? agentId;
  String? title;
  String? body;
  Data? data;
  bool? read;
  dynamic readAt;
  DateTime? sentAt;
  int? v;

  Datum({
    this.id,
    this.agentId,
    this.title,
    this.body,
    this.data,
    this.read,
    this.readAt,
    this.sentAt,
    this.v,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    agentId: json["agentId"],
    title: json["title"],
    body: json["body"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    read: json["read"],
    readAt: json["readAt"],
    sentAt: json["sentAt"] == null ? null : DateTime.parse(json["sentAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "agentId": agentId,
    "title": title,
    "body": body,
    "data": data?.toJson(),
    "read": read,
    "readAt": readAt,
    "sentAt": sentAt?.toIso8601String(),
    "__v": v,
  };
}

class Data {
  String? type;
  String? orderId;
  String? assignedBy;

  Data({this.type, this.orderId, this.assignedBy});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    type: json["type"],
    orderId: json["orderId"],
    assignedBy: json["assignedBy"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "orderId": orderId,
    "assignedBy": assignedBy,
  };
}
