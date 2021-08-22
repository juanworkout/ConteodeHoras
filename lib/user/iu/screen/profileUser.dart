import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/user/iu/screen/acerca_de.dart';
import 'package:untitled/user/iu/screen/registrar_actividad.dart';
import 'package:untitled/user/model/TaskReponse.dart';
import 'lista_widget.dart';
import 'login.dart';

class ProfileUser extends StatefulWidget {
  final int userId;
  final String user;
  final String imagen;
  final String email;

  ProfileUser(this.userId, this.user, this.imagen, this.email);

  @override
  _ProfileUser createState() => _ProfileUser();
}

class _ProfileUser extends State<ProfileUser> {
  TaskReponse ts;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final firstDateController = TextEditingController();
  final secondDateController = TextEditingController();
  final IdController = TextEditingController();
  bool isApiCallProcess = false;
  final f = new DateFormat('yyyy-MM-dd hh:mm');

  @override
  void initState() {
    super.initState();
    if (widget.userId.toString().isNotEmpty) {
      getNewStak();
    } else if (firstDateController.text.isNotEmpty &&
        secondDateController.text.isNotEmpty &&
        widget.userId.toString().isNotEmpty) {
      getStak();
    }
  }

  closeSesion() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                _scaffoldKey.currentState.openDrawer();
              },
              icon: Icon(
                Icons.more_vert,
                color: Colors.black,
                size: 30,
              ),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: filtrado(),
      ),
      drawer: drawerCompleto(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => RegistrarActividad(
                      widget.user, widget.userId, widget.imagen, widget.email)),
              (Route<dynamic> route) => false);
        },
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(height: 5.0),
                  selectList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget filtrado() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.user,
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 80.0,
              height: 40.0,
              child: Container(
                width: 80,
                child: FlatButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("del"),
                                      SizedBox(
                                        width: 60.0,
                                        height: 30.0,
                                        child: RaisedButton(
                                          elevation: 0,
                                          color: Colors.white,
                                          child: Icon(
                                            Icons.date_range,
                                            color: Colors.blue,
                                          ),
                                          onPressed: () async {
                                            DateTime date = DateTime(2021);
                                            FocusScope.of(context)
                                                .requestFocus(new FocusNode());

                                            date = await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2021),
                                                lastDate: DateTime(2050));
                                            firstDateController.text =
                                                date.toIso8601String();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("al"),
                                    SizedBox(
                                      width: 60.0,
                                      height: 30.0,
                                      child: RaisedButton(
                                        elevation: 0,
                                        color: Colors.white,
                                        child: Icon(
                                          Icons.date_range,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () async {
                                          DateTime date = DateTime(2021);
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());

                                          date = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2021),
                                              lastDate: DateTime(2050));
                                          secondDateController.text =
                                              date.toIso8601String();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                RaisedButton(
                                  child: Text("Aceptar"),
                                  onPressed: () {
                                    if (firstDateController.text.isNotEmpty &&
                                        secondDateController.text.isNotEmpty) {
                                      getStak();
                                      Navigator.of(context).pop();
                                    }
                                  },
                                ),
                                RaisedButton(
                                  child: Text("Cancelar"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    // Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Icon(
                        Icons.filter_frames_outlined,
                        size: 15,
                        color: Colors.grey,
                      ),
                      Text(
                        "Filtrar",
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<List<TaskReponse>> getNewStak() async {
    print("Se esta ejecutando");
    var url = Uri.parse("https://testing.ever-track.com/api/GetTaskTop");
    final response = await http.post(url,
        body: ({
          'UserId': widget.userId.toString(),
        }));

    if (response.statusCode == 200) {
      print(response.body);
      var jsonList = json.decode(response.body) as List;
      return jsonList.map((e) => TaskReponse.fromJson(e)).toList();
    } else {
      throw Exception('Falló al cargar los datos!');
    }
  }

  Future<List<TaskReponse>> getStak() async {
    var url = Uri.parse("https://testing.ever-track.com/api/GetTask");
    final response = await http.post(url,
        body: ({
          'UserId': widget.userId.toString(),
          'From': firstDateController.text,
          'To': secondDateController.text,
        }));

    if (response.statusCode == 200) {
      print(response.body);
      var jsonList = json.decode(response.body) as List;
      return jsonList.map((e) => TaskReponse.fromJson(e)).toList();
    } else {
      throw Exception('Falló al cargar los datos!');
    }
  }

  Widget selectList() {
    if (firstDateController.text.isNotEmpty &&
        secondDateController.text.isNotEmpty) {
      return FutureBuilder<List<TaskReponse>>(
          future: getStak(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var taskResponse = snapshot.data[index];
                    return listaWidget(taskResponse, widget.user, widget.userId,
                        widget.imagen, widget.email);
                  });
            } else {
              return Center(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          });
    } else if (widget.userId.toString().isNotEmpty) {
      return FutureBuilder<List<TaskReponse>>(
          future: getNewStak(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var taskResponse = snapshot.data[index];
                    return listaWidget(taskResponse, widget.user, widget.userId,
                        widget.imagen, widget.email);
                  });

            } else {
              return Center(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          });
    }
  }

  Widget drawerCompleto() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(0),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DrawerHeader(
                child: datosImageDrawer(),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    image: DecorationImage(
                        image: AssetImage("assets/img/drawer.jpg"),
                        fit: BoxFit.cover)),
              ),
              listDrawer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget datosImageDrawer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            width: 80.0,
            height: 80.0,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: new NetworkImage(widget.imagen),
                ))),
        Text(
          widget.user,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        Text(
          widget.email,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
        ),
      ],
    );
  }

  Widget listDrawer() {
    return ListTile(
      title: Text("Menú"),
      subtitle: Column(
        children: [
          SizedBox(
            height: 30.0,
          ),
          InkWell(
            onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("del"),
                                  SizedBox(
                                    width: 60.0,
                                    height: 30.0,
                                    child: RaisedButton(
                                      elevation: 0,
                                      color: Colors.white,
                                      child: Icon(
                                        Icons.date_range,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () async {
                                        DateTime date = DateTime(2021);
                                        FocusScope.of(context)
                                            .requestFocus(new FocusNode());

                                        date = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2021),
                                            lastDate: DateTime(2050));
                                        firstDateController.text =
                                            date.toIso8601String();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("al"),
                                SizedBox(
                                  width: 60.0,
                                  height: 30.0,
                                  child: RaisedButton(
                                    elevation: 0,
                                    color: Colors.white,
                                    child: Icon(
                                      Icons.date_range,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () async {
                                      DateTime date = DateTime(2021);
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());

                                      date = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2021),
                                          lastDate: DateTime(2050));
                                      secondDateController.text =
                                          date.toIso8601String();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RaisedButton(
                              child: Text("Aceptar"),
                              onPressed: () {
                                if (firstDateController.text.isNotEmpty &&
                                    secondDateController.text.isNotEmpty) {
                                  getStak();
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                            RaisedButton(
                              child: Text("Cancelar"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    });
            },
            child: Row(
              children: [
                Icon(Icons.picture_as_pdf),
                Text("  Reporte"),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => AcercaDe()));
            },
            child: Row(
              children: [
                Icon(Icons.circle_notifications),
                Text("  Acerca de"),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Icon(Icons.check_circle_outline),
                Text("  Terminos y condiciones"),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          InkWell(
            onTap: () {
              closeSesion();
              Future.delayed(Duration(seconds: 5), () {
                print("error");
                setState(() {
                  isApiCallProcess = false;
                  final snackBar =
                      SnackBar(content: Text("Intentalo más tarde"));
                  _scaffoldKey.currentState.showSnackBar(snackBar);
                });
              });
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Login()),
                  (Route<dynamic> route) => false);
            },
            child: Row(
              children: [
                Icon(Icons.logout),
                Text("  Cerrar sesión"),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Icon(Icons.power_settings_new),
                Text("  Salir"),
              ],
            ),
          ),
        ],
      ),
      //subtitle: ,
    );
  }
}
