import 'dart:convert';

class DeviceDetails {
  String? deviceId;
  String? fcmToken;
  String? deviceCompany;
  String? deviceName;
  String? os;
  String? appVersion;
  String? osVersion;

  DeviceDetails({
    this.deviceId,
    this.fcmToken,
    this.deviceCompany,
    this.deviceName,
    this.os,
    this.appVersion,
    this.osVersion,
  });

  factory DeviceDetails.fromRawJson(String str) => DeviceDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DeviceDetails.fromJson(Map<String, dynamic> json) => DeviceDetails(
    deviceId: json["deviceId"],
    fcmToken: json["fcmToken"],
    deviceCompany: json["deviceCompany"],
    deviceName: json["deviceName"],
    os: json["os"],
    appVersion: json["appVersion"],
    osVersion: json["osVersion"],
  );

  Map<String, dynamic> toJson() => {
    "deviceId": deviceId,
    "fcmToken": fcmToken,
    "deviceCompany": deviceCompany,
    "deviceName": deviceName,
    "os": os,
    "appVersion": appVersion,
    "osVersion": osVersion,
  };
}
