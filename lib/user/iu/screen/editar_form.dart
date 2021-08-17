import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/user/model/model_addTask.dart';

class EditarForm extends StatefulWidget {
  final UserId;
  EditarForm(this.UserId);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EditarForm();
  }
}

class _EditarForm extends State <EditarForm> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Editar tarea"),
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

  Future <List<ModelAddTask>> addTask() async {
    var url = Uri.parse("http://testing.ever-track.com/api/addTask");
    final response = await http.post(url,
        body: ({
          'Name': nameCtrl.text,
          'Description': descCtrl.text,
          'DateStart': fechaInicioCtrl.text,
          'DateFin': fechaFinCtrl.text,
          'Metadata1': proyectoCtrl.text,
          'Metadata2': ubicacionCtrl.text,
          'Metadata3': estatusCtrl.text,
          'UserId': widget.UserId.toString(),
        }));

    if (response.statusCode == 200) {
      print(response.body);
      var jsonList = json.decode(response.body) as List;
      return jsonList.map((e) => ModelAddTask.fromJson(e)).toList();
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