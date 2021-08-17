import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:untitled/user/iu/screen/registrar_actividad.dart';
import 'package:untitled/user/model/TaskReponse.dart';
import 'lista_widget.dart';

class ProfileUser extends StatefulWidget {
  final int userId;
  final String user;

  ProfileUser(this.userId, this.user);

  @override
  _ProfileUser createState() => _ProfileUser();
}

class _ProfileUser extends State<ProfileUser> {
  final listaStream = StreamController<List<TaskReponse>>();
  final _formKey = GlobalKey<FormState>();
  final firstDateController = TextEditingController();
  final secondDateController = TextEditingController();
  final IdController = TextEditingController();
  bool isApiCallProcess = false;
  final f = new DateFormat('yyyy-MM-dd hh:mm');

  @override
  void initState() {
    super.initState();
    firstDateController.text;
    secondDateController.text;
    if(firstDateController.text.isNotEmpty && secondDateController.text.isNotEmpty) {
      getStak();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    getStak();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: (){

            },
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
              size: 30,
            ),
          ),
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (Text(
                widget.user,
                style: TextStyle(color: Colors.black, fontSize: 18),
              )),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        width: 60.0,
                                        height: 30.0,
                                        child: RaisedButton(
                                          elevation: 0,
                                          color: Colors.white,
                                          child: Icon(
                                            Icons.date_range,
                                            color: Colors.green,
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
                                      SizedBox(
                                        width: 60.0,
                                        height: 30.0,
                                        child: RaisedButton(
                                          elevation: 0,
                                          color: Colors.white,
                                          child: Icon(
                                            Icons.date_range,
                                            color: Colors.redAccent,
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
                                  content: RaisedButton(
                                    child: Text("Aceptar"),
                                    onPressed: () {
                                      if (firstDateController.text.isNotEmpty &&
                                          secondDateController
                                              .text.isNotEmpty) {
                                        setState(() {
                                          getStak();
                                        });
                                        Navigator.of(context).pop();
                                      }
                                    },
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
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.add,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        RegistrarActividad(widget.user, widget.userId)));
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
                    FutureBuilder<List<TaskReponse>>(
                        future: getStak(),
                        builder: (BuildContext context,AsyncSnapshot snapshot) {
                          if (firstDateController.text.isNotEmpty &&
                              secondDateController.text.isNotEmpty) {
                            if (snapshot.hasData) {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var taskResponse = snapshot.data[index];
                                      return listaWidget(taskResponse, widget.userId);

                              });
                            } else {
                              return Center(
                                child: Center(child: CircularProgressIndicator(),),
                              );
                            }
                          } else {
                            return Center(
                              child: Text("Sin datos",style: TextStyle(color: Colors.grey),),
                            );
                          }
                        }),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Future<List<TaskReponse>> getStak() async {
    var url = Uri.parse("http://testing.ever-track.com/api/GetTask");
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
}
