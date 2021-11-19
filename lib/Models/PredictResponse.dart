// To parse this JSON data, do
//
//     final predictResponse = predictResponseFromJson(jsonString);

import 'dart:convert';

PredictResponse predictResponseFromJson(String str) =>
    PredictResponse.fromJson(json.decode(str));

String predictResponseToJson(PredictResponse data) =>
    json.encode(data.toJson());

class PredictResponse {
  PredictResponse({
    required this.id,
    required this.user,
    required this.knockSound,
    this.maturityScore,
    required this.createdOn,
    this.locationLat,
    this.locationLng,
  });

  final int id;
  final int user;
  final String knockSound;
  final int? maturityScore;
  final DateTime createdOn;
  final String? locationLat;
  final String? locationLng;

  factory PredictResponse.fromJson(Map<String, dynamic> json) =>
      PredictResponse(
        id: json["id"],
        user: json["user"],
        knockSound: json["knock_sound"],
        maturityScore: json["maturity_score"],
        createdOn: DateTime.parse(json["created_on"]),
        locationLat: json["location_lat"],
        locationLng: json["location_lng"],
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
