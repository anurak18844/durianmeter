import 'package:file/file.dart';
class PredictRequest{
  final String userId;
  final File knockSound;
  final String locationLat;
  final String locationLong;

  PredictRequest({ required this.userId, required this.knockSound, required this.locationLat, required this.locationLong});

}