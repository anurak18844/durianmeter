// To parse this JSON data, do
//
//     final authUse = authUseFromJson(jsonString);

import 'dart:convert';

AuthUserResponse authUseFromJson(String str) =>
    AuthUserResponse.fromJson(json.decode(str));

String authUseToJson(AuthUserResponse data) => json.encode(data.toJson());

class AuthUserResponse {
  AuthUserResponse({
    required this.id,
    this.username,
    this.email,
    this.maturityPrefer,
    this.quota,
    this.firstname,
    this.lastname,
    this.tel,
    required this.recentDurians,
  });

  int id;
  String? username;
  String? email;
  int? maturityPrefer;
  int? quota;
  String? firstname;
  String? lastname;
  String? tel;
  List<RecentDurian> recentDurians;

  factory AuthUserResponse.fromJson(Map<String, dynamic> json) =>
      AuthUserResponse(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        maturityPrefer: json["maturity_prefer"],
        quota: json["quota"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        tel: json["tel"],
        recentDurians: List<RecentDurian>.from(
            json["recent_durians"].map((x) => RecentDurian.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "maturity_prefer": maturityPrefer,
        "quota": quota,
        "firstname": firstname,
        "lastname": lastname,
        "tel": tel,
        "recent_durians":
            List<dynamic>.from(recentDurians.map((x) => x.toJson())),
      };
}

class RecentDurian {
  RecentDurian({
    required this.id,
    required this.user,
    required this.knockSound,
    this.maturityScore,
    required this.createdOn,
    required this.locationLat,
    required this.locationLng,
  });

  int id;
  int user;
  String knockSound;
  int? maturityScore;
  DateTime createdOn;
  String locationLat;
  String locationLng;

  factory RecentDurian.fromJson(Map<String, dynamic> json) => RecentDurian(
        id: json["id"],
        user: json["user"],
        knockSound: json["knock_sound"],
        maturityScore: json["maturity_score"] ?? 0,
        createdOn: DateTime.parse(json["created_on"]),
        locationLat: json["location_lat"] ?? "",
        locationLng: json["location_lng"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "knock_sound": knockSound,
        "maturity_score": maturityScore,
        "created_on": createdOn.toIso8601String(),
        "location_lat": locationLat,
        "location_lng": locationLng,
      };
}
