// To parse this JSON data, do
//
//     final datasetResponse = datasetResponseFromJson(jsonString);

import 'dart:convert';

DatasetResponse datasetResponseFromJson(String str) => DatasetResponse.fromJson(json.decode(str));

String datasetResponseToJson(DatasetResponse data) => json.encode(data.toJson());

class DatasetResponse {
  DatasetResponse({
    required this.id,
    required this.user,
    required this.knockSound,
    required this.maturityScore,
    required this.createdOn,
  });

  final int id;
  final int user;
  final String knockSound;
  final int maturityScore;
  final DateTime createdOn;

  factory DatasetResponse.fromJson(Map<String, dynamic> json) => DatasetResponse(
    id: json["id"],
    user: json["user"],
    knockSound: json["knock_sound"],
    maturityScore: json["maturity_score"],
    createdOn: DateTime.parse(json["created_on"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user,
    "knock_sound": knockSound,
    "maturity_score": maturityScore,
    "created_on": createdOn.toIso8601String(),
  };
}
