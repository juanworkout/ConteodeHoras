import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/user/iu/screen/login.dart';
import 'package:untitled/user/iu/screen/profileUser.dart';



const Color kErrorRed = Colors.redAccent;
const Color kDarkGray = Color(0xFFA3A3A3);
const Color kPrimaryColor = Color(0xFF000000);

void main() {
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Conteo de Horas',
        theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
        ),
      home: VerifyPage(),
    );
  }
}

class VerifyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, AsyncSnapshot <SharedPreferences> snapshot) {
          if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text(snapshot.error),),);
          } else if (snapshot.hasData) {
            if (snapshot.data.getInt('id') == null) {
              return Login();
            } else {
              int id = snapshot.data.getInt('id');
              String user = snapshot.data.getString('user');
              String imagen = snapshot.data.getString('imagen');
              String email = snapshot.data.getString('email');
              return ProfileUser(id, user, imagen, email);
            }
          }
          return Scaffold(
            body: Center(child: CircularProgressIndicator(),),
          );
        }
    );
  }
}


