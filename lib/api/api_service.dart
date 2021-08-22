import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:untitled/user/model/login_model.dart';

class APIService {
  /*******************************LOGIN****************************************/

  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    var url = Uri.parse("https://testing.ever-track.com/api/LoginTask");
    final response = await http.post(url, body: requestModel.toJson());
    Future.delayed(Duration(seconds: 5), () {
      print("error");
    });
    if (response.statusCode == 200 || response.statusCode == 400) {
      print(response.body);
      return LoginResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception('Failed to load data!');
    }
  }

/****************************FIN LOGIN***************************************/

}
