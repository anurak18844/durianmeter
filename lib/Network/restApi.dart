import 'package:durianmeter/Models/loginModel.dart';
import 'package:durianmeter/Utils/constant.dart';
import 'package:http/http.dart' as http;


class CallApi {
  //API header
  _setHeaders() =>
      {"Content-Type": "application/json", "Accept": "application/json"};
      _setHeadersAuth() => {"Content-Type": "application/x-www-form-urlencoded"};

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
}