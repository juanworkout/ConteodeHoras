import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../../progressHUD.dart';
import 'login.dart';

class RecuperaView extends StatefulWidget {
  @override
  _RecuperaViewState createState() => _RecuperaViewState();
}

class _RecuperaViewState extends State<RecuperaView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailCrt = TextEditingController();
  bool isApiCallProcess = false;

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: recuperar(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  @override
  Widget recuperar(context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.grey,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
              child: Center(
            child: ListView(
              padding: EdgeInsets.only(left: 10, right: 30),
              children: [
                Text(
                  "¿Olvidaste tu contraseña?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Escribe tu correo electrónico para restablecer tu contraseña.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                Image.asset(
                  "assets/img/email.png",
                  height: 160,
                  width: 160,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 50.0, left: 50),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: emailCrt,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        icon: Icon(Icons.email_outlined),
                        border: InputBorder.none,
                        hintText: "Correo electronico",
                      ),
                      validator: validateEmail,
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 60, right: 60),
                  child: RaisedButton(
                      color: Colors.white,
                      elevation: 0,
                      child: Text("Recuperar contraseña"),
                      onPressed: () {
                        if (validateAndSave()) {
                          setState(() {
                            isApiCallProcess = true;
                          });
                          recuperarContrasena();

                          Fluttertoast.showToast(
                              msg: "Realizado, revise su correo",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,

                          );

                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => Login()),
                                  (Route<dynamic> route) => false);
                        }
                      }),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Campo vacío";
    } else if (!regExp.hasMatch(value)) {
      return "Correo invalido";
    } else {
      return null;
    }
  }

  Future recuperarContrasena() async {
    var url = Uri.parse("https://testing.ever-track.com/api/ForgetUser");
    final response = await http.post(url,
    body: ({
    'email': emailCrt.text,
    }));

    if (response.statusCode == 200 || response.statusCode == 400) {
      print(response.body);
    } else {
      throw Exception('Failed to load data!');
    }
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
