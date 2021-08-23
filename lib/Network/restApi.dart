import 'package:durianmeter/Models/DatasetRequest.dart';
import 'package:durianmeter/Models/DatasetResponse.dart';
import 'package:durianmeter/Models/PredictResponse.dart';
import 'package:durianmeter/Models/loginModel.dart';
import 'package:durianmeter/Models/predictRequest.dart';
import 'package:durianmeter/Utils/constant.dart';
import 'package:durianmeter/Utils/globalVariables.dart';
import 'package:http/http.dart' as http;


class CallApi {
  String _headerToken = "token " + userToken;
  //API header
  _setHeaders() =>
      {"Content-Type": "application/json", "Accept": "application/json"};
  _setHeadersAuth() => {"Content-Type": "application/x-www-form-urlencoded"};
  // _setHeadersPredict() => {"Content-Type": "multipart/form-data", "Authorization" : "token 31ae2eab50031c4ec29ea2dbf3ba2b8f089ece2b"};
  //Login method
  Future<LoginModel?> loginCustomer(String? username, String? password) async {
    Uri _uri = Uri.parse(baseApiUrl + "login/");
    var response = await http.post(
      _uri,
      headers: _setHeadersAuth(),
      body: {"username": username, "password": password},
    );

    if (response.statusCode == 200) {
      var jsonString = response.body;
      LoginModel loginModel = loginModelFromJson(jsonString);


      return loginModel;
    }

    return null;
  }

  Future<PredictResponse?> getPrediction(PredictRequest predictRequest) async{
    print("HeaderToken " + _headerToken);
    Uri _uri = Uri.parse(baseApiUrl + "api/durian/");
    print("From sendRequest()");
    // print("File length: ${await file.length()}");
    var request = http.MultipartRequest('POST', _uri);
    //define headers
    request.headers['Content-Type'] = "multipart/form-data";
    request.headers['Authorization'] = _headerToken;

    //defind body
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

    var response = await request.send();
    var respStr = await response.stream.bytesToString();
    PredictResponse pResp;
    print("RESPONSE: ${response.statusCode}");
    print(respStr);
    if(response.statusCode==201){
      pResp = predictResponseFromJson(respStr);
      return pResp;
    }
    return null;
  }

  Future<DatasetResponse?> getDatasetResponse(DatasetRequest datasetRequest) async{
    print("HeaderToken " + _headerToken);
    Uri _uri = Uri.parse(baseApiUrl + "dataset/knocksound/");
    var request = http.MultipartRequest('POST', _uri);
    //define headers
    request.headers['Content-Type'] = "multipart/form-data";
    request.headers['Authorization'] = _headerToken;

    request.files.add(
      http.MultipartFile(
        'knock_sound',
        datasetRequest.knockSound.readAsBytes().asStream(),
        datasetRequest.knockSound.lengthSync(),
        filename: datasetRequest.knockSound.path.split("/").last,
      ),
    );

    request.fields["maturity_score"]= datasetRequest.maturityScore.toString();
    request.fields['no'] = datasetRequest.no.toString();

    print(request.files[0].filename);

    request.fields.forEach((key, value) => print("k: $key, v: $value"));

    var response = await request.send();
    var respStr = await response.stream.bytesToString();
    DatasetResponse dResp;
    print("RESPONSE: ${response.statusCode}");
    print(respStr);
    if(response.statusCode==201){
      dResp = datasetResponseFromJson(respStr);
      return dResp;
    }
    return null;
  }
}