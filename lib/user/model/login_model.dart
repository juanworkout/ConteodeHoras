class LoginResponseModel {
  final String user;
  final int userId;

  LoginResponseModel({this.user, this.userId});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      user: json["user"],
      userId: json["userId"],
    );
  }
}

class LoginRequestModel {
  String user;
  String pass;

  LoginRequestModel({
    this.user,
    this.pass,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'user': user.trim(),
      'pass': pass.trim(),
    };

    return map;
  }
}
