import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/user/iu/screen/profileUser.dart';
import 'package:untitled/user/model/TaskReponse.dart';

import '../../../progressHUD.dart';

class EditarForm extends StatefulWidget {
  final TaskReponse ts;
  final String user;
  final int userId;
  final String imagen;
  final String email;

  EditarForm(this.ts, this.user, this.userId, this.imagen, this.email);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EditarForm();
  }
}

class _EditarForm extends State<EditarForm> {
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  File imagePath;
  final picker = ImagePicker();
  String valor;
  List listItems = ["Pendiente", "Finalizado", "En Proceso", "Cancelada"];

  TextEditingController nameCtrl = TextEditingController();
  TextEditingController descCtrl = TextEditingController();
  TextEditingController estatusCtrl = TextEditingController();
  TextEditingController proyectoCtrl = TextEditingController();
  TextEditingController ubicacionCtrl = TextEditingController();
  TextEditingController fechaInicioCtrl = TextEditingController();
  TextEditingController fechaFinCtrl = TextEditingController();
  TextEditingController imagenCtrl = TextEditingController();
  bool isApiCallProcess = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameCtrl = TextEditingController(text: widget.ts.Name);
    descCtrl = TextEditingController(text: widget.ts.Description);
    estatusCtrl = TextEditingController(text: widget.ts.Metadata3);
    proyectoCtrl = TextEditingController(text: widget.ts.Metadata1);
    ubicacionCtrl = TextEditingController(text: widget.ts.Metadata2);
    fechaInicioCtrl = TextEditingController(text: widget.ts.DateStart);
    fechaFinCtrl = TextEditingController(text: widget.ts.DateFin);
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: editar(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  @override
  Widget editar(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Editar tarea"),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => ProfileUser(widget.userId,
                        widget.user, widget.imagen, widget.email)),
                (Route<dynamic> route) => false);
          },
        ),
      ),
      body: new SingleChildScrollView(
        child: new Container(
          margin: new EdgeInsets.only(left: 25.0, right: 25.0, top: 5.0),
          child: new Form(
            key: _formKey,
            child: formUI(),
          ),
        ),
      ),
    );
  }

  formItemsDesign(icon, item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7),
      child: Card(child: ListTile(leading: Icon(icon), title: item)),
    );
  }

  Widget formUI() {
    return Column(
      children: <Widget>[
        formItemsDesign(
            Icons.drive_file_rename_outline,
            TextFormField(
              controller: nameCtrl,
              decoration: new InputDecoration(
                labelText: "Nombre",
              ),
              validator: validateName,
            )),
        formItemsDesign(
            Icons.palette_rounded,
            TextFormField(
              controller: descCtrl,
              decoration: new InputDecoration(
                labelText: "Descripción",
              ),
              keyboardType: TextInputType.text,
              maxLength: 300,
              validator: validateName,
            )),
        formItemsDesign(
            Icons.stacked_line_chart,
            Column(children: <Widget>[
              DropdownButtonFormField(
                value: valor,
                onChanged: (nuevoValor) {
                  setState(() {
                    valor = nuevoValor;
                  });
                },
                items: listItems.map((valorItem) {
                  return DropdownMenuItem(
                      value: valorItem, child: Text(valorItem));
                }).toList(),
                validator: (value) =>
                    value == null ? 'Debe llenar los campos' : null,
              ),
            ])),
        formItemsDesign(
            Icons.filter_frames,
            TextFormField(
              controller: proyectoCtrl,
              decoration: new InputDecoration(
                labelText: 'Proyecto',
              ),
              validator: validateName,
            )),
        formItemsDesign(
            Icons.add_location,
            TextFormField(
              controller: ubicacionCtrl,
              decoration: InputDecoration(
                labelText: 'Ubicación',
              ),
              validator: validateName,
            )),
        formItemsDesign(
            Icons.date_range,
            TextFormField(
                onTap: () async {
                  DateTime date = DateTime(2021);
                  FocusScope.of(context).requestFocus(new FocusNode());

                  date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2021),
                      lastDate: DateTime(2050));
                  fechaInicioCtrl.text = date.toIso8601String();
                },
                controller: fechaInicioCtrl,
                decoration: InputDecoration(
                  labelText: 'Fecha inicio',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Campo vacío";
                  }
                })),
        formItemsDesign(
            Icons.date_range,
            TextFormField(
              onTap: () async {
                DateTime date = DateTime(2021);
                FocusScope.of(context).requestFocus(new FocusNode());

                date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2021),
                    lastDate: DateTime(2050));
                fechaFinCtrl.text = date.toIso8601String();
              },
              controller: fechaFinCtrl,
              decoration: InputDecoration(
                labelText: 'Fecha fin',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return "Campo vacío";
                }
              },
            )),
        GestureDetector(
            onTap: () {
              if (validateAndSave()) {
                setState(() {
                  isApiCallProcess = true;
                });
                Future.delayed(Duration(seconds: 5), () {
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
                upDateTask();

                Fluttertoast.showToast(
                  msg: "Editado éxitoso",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                );
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => ProfileUser(widget.userId, widget.user,
                        widget.imagen, widget.email)),
                        (Route<dynamic> route) => false);
              }
            },
            child: Container(
              margin: new EdgeInsets.all(10.0),
              alignment: Alignment.center,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                gradient: LinearGradient(colors: [
                  Color(0xFF0EDED2),
                  Color(0xFF03A0FE),
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              child: Text("Guardar",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500)),
              padding: EdgeInsets.only(top: 16, bottom: 16),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: new EdgeInsets.only(top: 10.0, bottom: 40.0),
              child: SizedBox(
                width: 120.0,
                child: InkWell(
                  onTap: () {
                    alertaEliminar();
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 33,
                      ),
                      Text(
                        "Eliminar",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
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

  Future upDateTask() async {
    print("Inicioando future");
    var url = Uri.parse("https://testing.ever-track.com/api/updateTask");
    final response = await http.post(url,
        body: ({
          'Name': nameCtrl.text ?? "",
          'Description': descCtrl.text ?? "",
          'DateStart': fechaInicioCtrl.text ?? "",
          'DateFin': fechaFinCtrl.text ?? "",
          'Metadata1': proyectoCtrl.text ?? "",
          'Metadata2': ubicacionCtrl.text ?? "",
          'Metadata3': estatusCtrl.text = valor ?? "",
          'IdTask': widget.ts.TaskId.toString() ?? "",
        }));
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception('Failed to load data!');
    }
  }

  Widget alertaEliminar() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.warning_amber_outlined,
                size: 30,
                color: Colors.red,
              ),
              Text(
                '   Eliminar',
              ),
            ],
          ),
          content: Text(
            "¿Estas seguro que quieres eliminar?",
            style: TextStyle(color: Colors.grey),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                    color: Colors.white,
                    elevation: 0,
                    child: Text("Aceptar"),
                    onPressed: () {
                      Future.delayed(Duration(seconds: 5), () {
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
                      deleteTask();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => ProfileUser(widget.userId,
                                  widget.user, widget.imagen, widget.email)),
                          (Route<dynamic> route) => false);
                    }),
                RaisedButton(
                    color: Colors.white,
                    elevation: 0,
                    child: Text("Cancelar"),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
            ),
          ],
        );
      },
    );
  }
  Future deleteTask() async {
    print("Inicioando future");
    var url = Uri.parse("https://testing.ever-track.com/api/deleteTask");
    final response = await http.post(url,
        body: ({
          'IdTask': widget.ts.TaskId.toString() ?? "",
        }));
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception('Failed to load data!');
    }
  }

  String validateName(String value) {
    if (value.length == 0) {
      return "Campo vacío";
    }
    return null;
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
