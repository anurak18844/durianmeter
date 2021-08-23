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
    required this.no,
    required this.knockSound,
    required this.maturityScore,
    this.brix,
    this.dryWeight,
    required this.createdOn,
  });

  final int id;
  final int user;
  final int no;
  final String knockSound;
  final int maturityScore;
  final double? brix;
  final double? dryWeight;
  final DateTime createdOn;

  factory DatasetResponse.fromJson(Map<String, dynamic> json) => DatasetResponse(
    id: json["id"],
    user: json["user"],
    no: json["no"],
    knockSound: json["knock_sound"],
    maturityScore: json["maturity_score"],
    brix: json["brix"]??0.0,
    dryWeight: json["dry_weight"]??0.0,
    createdOn: DateTime.parse(json["created_on"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user,
    "no": no,
    "knock_sound": knockSound,
    "maturity_score": maturityScore,
    "brix": brix,
    "dry_weight": dryWeight,
    "created_on": createdOn.toIso8601String(),
  };
}
