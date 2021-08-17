import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/api/api_service.dart';
import 'package:untitled/progressHUD.dart';
import 'package:untitled/user/iu/screen/profileUser.dart';
import 'package:untitled/user/model/login_model.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginRequestModel loginRequestModel;
  final _formKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    loginRequestModel = new LoginRequestModel();
    final scaffoldKey = GlobalKey<ScaffoldState>();
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
          SizedBox(
              height: 100,
              child: Center(child: Image.asset("assets/img/logorp.png"))),
          SizedBox(
            height: 40.0,
          ),
          Expanded(
              child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        onSaved: (input) => loginRequestModel.user = input,
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
                        //controller: controlerPass,
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
                              onPressed: () {},
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
                              if (validateAndSave()) {
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
                                      isApiCallProcess = false;
                                    });
                                    if (value.user.isNotEmpty) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  ProfileUser(value.userId,
                                                      value.user)));
                                      print("Logeado");
                                      print(value.userId);
                                      print(value.user);
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
