import 'package:file/file.dart';
class DatasetRequest{
  final File knockSound;
  final int maturityScore;
  final int? no;
  final bool? do_prediction;


  DatasetRequest({required this.knockSound, required this.maturityScore,this.no,this.do_prediction});

}