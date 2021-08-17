import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:untitled/user/model/login_model.dart';

class APIService {
  /*******************************LOGIN****************************************/

  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    var url = Uri.parse("http://testing.ever-track.com/api/Login");
    final response = await http.post(url, body: requestModel.toJson());

    if (response.statusCode == 200 || response.statusCode == 400) {
      return LoginResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception('Failed to load data!');
    }
  }

/****************************FIN LOGIN***************************************/

}
