import 'package:durianmeter/Utils/constant.dart';
import 'package:file/file.dart';
import 'package:http/http.dart' as http;
import 'Models/predictRequest.dart';

class CallPredictRequest {
  String _url = baseApiUrl+ 'api/durian/';

  void sendRequest(PredictRequest predictRequest) async {
    print("From sendRequest()");
    // print("File length: ${await file.length()}");
    var request = http.MultipartRequest('POST', Uri.parse(_url));
    request.files.add(
      http.MultipartFile(
        'knock_sound',
        predictRequest.knockSound.readAsBytes().asStream(),
        predictRequest.knockSound.lengthSync(),
        filename: predictRequest.knockSound.path.split("/").last,
      ),
    );
    request.fields["user"]="1";
    request.fields["location_lat"]="3.555877";
    request.fields["location_long"]="6.475788";
    print(request.files[0].filename);

    request.fields.forEach((key, value) => print("k: $key, v: $value"));

    var res = await request.send();

    if(res.statusCode==200){
      //grab output
    }

  }
}
