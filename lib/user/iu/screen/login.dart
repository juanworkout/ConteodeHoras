import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/api/api_service.dart';
import 'package:untitled/progressHUD.dart';
import 'package:untitled/user/iu/screen/profileUser.dart';
import 'package:untitled/user/iu/screen/recuperar_view.dart';
import 'package:untitled/user/model/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  LoginRequestModel loginRequestModel;
  LoginResponseModel user;
  final _formKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    loginRequestModel = new LoginRequestModel();
    final scaffoldKey = GlobalKey<ScaffoldState>();
  }
  saveUserID() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    await _pref.setInt("id", user.userId);
    await _pref.setString("user", user.user);
    await _pref.setString("imagen", user.imagen);
    await _pref.setString("email", user.email);

  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _loginW(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  @override
  Widget _loginW(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Expanded(
              child: ListView(
            children: <Widget>[
              SizedBox(
                  height: 100,
                  child: Center(child: Image.asset("assets/img/logorp.png"))),
              SizedBox(
                height: 40.0,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        onSaved: (input) => loginRequestModel.user = input,
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: "Nombre de usuario",
                          icon: Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Campo vacío";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        onSaved: (input) => loginRequestModel.pass = input,
                        decoration: InputDecoration(
                          hintText: "Contraseña",
                          icon: Icon(
                            Icons.lock,
                            color: Colors.black,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black),
                        obscureText: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Campo vacío";
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            child: RaisedButton(
                              color: Colors.white,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            RecuperaView()));

                              },
                              elevation: 0,
                              child: Text(
                                "¿Olvidaste tu contraseña?",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      SizedBox(
                          width: double.infinity,
                          child: OutlineButton(
                            child: Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: new Text("Aceptar",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(color: Colors.black))),
                            onPressed: () async {
                              print(nameController.text);
                              if (validateAndSave()) {
                                Future.delayed(Duration(seconds: 10), () {
                                  print("error");
                                  setState(() {
                                    isApiCallProcess = false;
                                    final snackBar = SnackBar(
                                        content:
                                        Text("Intentalo más tarde"));
                                    scaffoldKey.currentState
                                        .showSnackBar(snackBar);
                                  });
                                });
                                print(loginRequestModel.toJson());

                                setState(() {
                                  isApiCallProcess = true;
                                });

                                APIService apiService = new APIService();
                                apiService
                                    .login(loginRequestModel)
                                    .then((value) {
                                  if (value != null) {
                                    setState(() {
                                      user = value;
                                      isApiCallProcess = false;

                                    });
                                    if (value.user.isNotEmpty) {
                                      saveUserID();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  ProfileUser(value.userId,
                                                      value.user, value.imagen, value.email,)));
                                      print("Logeado");
                                      print(value.userId);
                                      print(value.user);
                                      print(value.imagen);
                                      print(value.email);
                                    } else {
                                      final snackBar = SnackBar(
                                          content:
                                              Text("Credenciales no validas"));
                                      scaffoldKey.currentState
                                          .showSnackBar(snackBar);
                                      print("No logeado");
                                    }
                                  }
                                });
                              }
                            },
                            // color: Colors.blue,
                            textColor: Colors.black,
                            borderSide: BorderSide(color: Colors.black),
                          )),
                    ],
                  ),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
