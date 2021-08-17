import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/user/model/model_addTask.dart';
import 'package:http/http.dart' as http;

class RegistrarActividad extends StatefulWidget {
  final String user;
  final int userId;

  RegistrarActividad(this.user, this.userId);

  @override
  _RegistrarActividad createState() => _RegistrarActividad();
}

class _RegistrarActividad extends State<RegistrarActividad> {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addTask();
  }

  Future selImagen(op) async {
    var pickerFile;
    if (op == 1) {
      pickerFile = await picker.getImage(source: ImageSource.camera);
    } else {
      pickerFile = await picker.getImage(source: ImageSource.gallery);
    }
    setState(() {
      if (pickerFile != null) {
        imagePath = File(pickerFile.path);
      } else {
        print("No se selecciono foto");
      }
    });
  }

  opciones(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      selImagen(1);
                    },
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 1, color: Colors.grey))),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Tomar una foto",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Icon(
                            Icons.camera_alt,
                            color: Colors.blueAccent,
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      selImagen(2);
                    },
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 1, color: Colors.grey))),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Seleccionar foto",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Icon(
                            Icons.image,
                            color: Colors.blueAccent,
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(color: Colors.redAccent),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Cancelar",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          Icon(
                            Icons.cancel,
                            color: Colors.redAccent,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Tarea"),
        backgroundColor: Colors.blueAccent,
      ),
      body: new SingleChildScrollView(
        child: new Container(
          margin: new EdgeInsets.only(left: 25.0,right: 25.0,top: 5.0),
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
                labelText: 'Nombre',
              ),
              validator: validateName,
            )),
        formItemsDesign(
            Icons.palette_rounded,
            TextFormField(
              controller: descCtrl,
              decoration: new InputDecoration(
                labelText: 'Descripción',
              ),
              keyboardType: TextInputType.text,
              maxLength: 300,
              validator: validateName,
            )),
        formItemsDesign(
            Icons.stacked_line_chart,
            Column(children: <Widget>[
              DropdownButtonFormField(
                hint: Text("Estatus"),
                value: valor,
                onChanged: (nuevoValor) {
                  setState(() {
                    valor = nuevoValor;
                  });
                },
                items: listItems.map((valorItem) {
                  return DropdownMenuItem(
                      value: valorItem,
                      child: Text(
                          valorItem
                      )
                  );
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
       /* SizedBox(
          width: 300.0,
          child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: () {
                opciones(context);
              },
              child: Text(
                "Cargar imagen",
                style: TextStyle(color: Colors.black),
              )),
        ),
        */
        SizedBox(
          height: 30.0,
        ),
        //imagePath == null ? Center() : Image.file(imagePath),
        GestureDetector(
            onTap: () {
              if (validateAndSave()) {
                  addTask();
                  print(estatusCtrl.text);
                  print(valor);

              }
            },
            child: Container(
              margin: new EdgeInsets.all(30.0),
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
            ))
      ],
    );
  }

  Future addTask() async {
    var url = Uri.parse("http://testing.ever-track.com/api/addTask");
    final response = await http.post(url,
        body: ({
          'Name': nameCtrl.text,
          'Description': descCtrl.text,
          'DateStart': fechaInicioCtrl.text,
          'DateFin': fechaFinCtrl.text,
          'Metadata1': proyectoCtrl.text,
          'Metadata2': ubicacionCtrl.text,
          'Metadata3': estatusCtrl.text = valor,
          'UserId': widget.userId.toString(),
        }));

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception('Failed to load data!');
    }
  }

  String validateName(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Campo vacío";
    } else if (!regExp.hasMatch(value)) {
      return "El nombre debe de ser a-z y A-Z";
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
