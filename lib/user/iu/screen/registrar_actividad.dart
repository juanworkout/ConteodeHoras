import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/user/iu/screen/profileUser.dart';
import 'package:untitled/user/iu/widget/upload_file.dart';
import 'package:uuid/uuid.dart';
import '../../../progressHUD.dart';
import '../widget/custom_dialog.dart';
import '../widget/delete_widget.dart';
import '../widget/gallery_Item.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../widget/generate_image_url.dart';

const Color kErrorRed = Colors.redAccent;
const Color kDarkGray = Color(0xFFA3A3A3);
const Color kLightGray = Color(0xFFF1F0F5);

class RegistrarActividad extends StatefulWidget {
  final String user;
  final int userId;
  final String imagen;
  final String email;

  RegistrarActividad(this.user, this.userId, this.imagen, this.email);

  @override
  _RegistrarActividad createState() => _RegistrarActividad();
}

enum PhotoStatus { LOADING, ERROR, LOADED }
enum PhotoSource { FILE, NETWORK }

class _RegistrarActividad extends State<RegistrarActividad> {
  List<File> _photos = List<File>();
  List<String> _photosUrls = List<String>();

  List<PhotoStatus> _photosStatus = List<PhotoStatus>();
  List<PhotoSource> _photosSources = List<PhotoSource>();
  List<GalleryItem> _galleryItems = List<GalleryItem>();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
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
    loadImages();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: registrar(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }
  @override
  Widget registrar(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
        title: Text("Tarea"),
        backgroundColor: Colors.blueAccent,
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

        Container(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _photos.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildAddPhoto();
              }
              File image = _photos[index - 1];
              PhotoSource source = _photosSources[index - 1];
              return Stack(
                children: <Widget>[
                  InkWell(
                    onTap: () => _onPhotoClicked(index - 1),
                    child: Container(
                      margin: EdgeInsets.all(5),
                      height: 100,
                      width: 100,
                      color: kLightGray,
                      child: source == PhotoSource.FILE
                          ? Image.file(image)
                          : Image.network(_photosUrls[index - 1]),
                    ),
                  ),
                  Visibility(
                    visible: _photosStatus[index - 1] == PhotoStatus.LOADING,
                    child: Positioned.fill(
                      child: SpinKitWave(
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _photosStatus[index - 1] == PhotoStatus.ERROR,
                    child: Positioned.fill(
                      child: Icon(
                        MaterialIcons.error,
                        color: kErrorRed,
                        size: 35,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      padding: EdgeInsets.all(6),
                      alignment: Alignment.topRight,
                      child: DeleteWidget(
                        () => _onDeleteReviewPhotoClicked(index - 1),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),

        SizedBox(
          height: 30.0,
        ),
        //imagePath == null ? Center() : Image.file(imagePath),
        GestureDetector(
            onTap: () {
                if (validateAndSave()) {
                  setState(() {
                    isApiCallProcess = true;
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
                  });
                  addTask();

                  Fluttertoast.showToast(
                    msg: "Tarea registrada con éxito",
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
    var url = Uri.parse("https://testing.ever-track.com/api/addTask");
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

  loadImages() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    List<String> photos = sharedPreferences.getStringList("images");
    if (photos == null) {
      return;
    }

    int length = photos.length;

    _galleryItems = List.generate(
      length,
          (index) => GalleryItem(
        isSvg: false,
        id: Uuid().v1(),
        resource: photos[index],
      ),
    );
    _photos = List.generate(
      length,
          (index) => File(
        photos[index],
      ),
    );
    _photosUrls = List.generate(
      length,
          (index) => photos[index],
    );
    _photosStatus = List.generate(
      length,
          (index) => PhotoStatus.LOADED,
    );
    _photosSources = List.generate(
      length,
          (index) => PhotoSource.NETWORK,
    );
    setState(() {});
  }
  _buildAddPhoto() {
    return InkWell(
      onTap: () => _onAddPhotoClicked(context),
      child: Container(
        margin: EdgeInsets.all(5),
        height: 100,
        width: 100,
        color: kDarkGray,
        child: Center(
          child: Icon(
            MaterialIcons.add_to_photos,
            color: kLightGray,
          ),
        ),
      ),
    );
  }

  _onAddPhotoClicked(context) async {
    Permission permission;

    if (Platform.isIOS) {
      permission = Permission.photos;
    } else {
      permission = Permission.storage;
    }

    PermissionStatus permissionStatus = await permission.status;

    print(permissionStatus);

    if (permissionStatus == PermissionStatus.restricted) {
      _showOpenAppSettingsDialog(context);

      permissionStatus = await permission.status;

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted
        return;
      }
    }

    if (permissionStatus == PermissionStatus.permanentlyDenied) {
      _showOpenAppSettingsDialog(context);

      permissionStatus = await permission.status;

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted
        return;
      }
    }

    if (permissionStatus == PermissionStatus.undetermined) {
      permissionStatus = await permission.request();

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted
        return;
      }
    }

    if (permissionStatus == PermissionStatus.denied) {
      if (Platform.isIOS) {
        _showOpenAppSettingsDialog(context);
      } else {
        permissionStatus = await permission.request();
      }

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted
        return;
      }
    }

    if (permissionStatus == PermissionStatus.granted) {
      print('Permission granted');

      File image = await ImagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (image != null) {
        int length;
        length = _photos.length + 1;

        String fileExtension = path.extension(image.path);

        _galleryItems.add(
          GalleryItem(
            id: Uuid().v1(),
            resource: image.path,
            isSvg: fileExtension.toLowerCase() == ".svg",
          ),
        );

        setState(() {
          _photos.add(image);
          _photosStatus.add(PhotoStatus.LOADING);
          _photosSources.add(PhotoSource.FILE);
        });

        try {
          GenerateImageUrl generateImageUrl = GenerateImageUrl();
          await generateImageUrl.call(fileExtension);

          String uploadUrl;
          if (generateImageUrl.isGenerated != null &&
              generateImageUrl.isGenerated) {
            uploadUrl = generateImageUrl.uploadUrl;
          } else {
            throw generateImageUrl.message;
          }

          bool isUploaded = await uploadFile(context, uploadUrl, image);
          if (isUploaded) {
            print('Uploaded');
            setState(() {
              _photosUrls.add(generateImageUrl.downloadUrl);
              _photosStatus
                  .replaceRange(length - 1, length, [PhotoStatus.LOADED]);
              _galleryItems[length - 1].resource = generateImageUrl.downloadUrl;
            });
          }
        } catch (e) {
          print(e);
          setState(() {
            _photosStatus[length - 1] = PhotoStatus.ERROR;
          });
        }
      }
    }
  }

  Future<bool> uploadFile(context, String url, File image) async {
    try {
      UploadFile uploadFile = UploadFile();
      await uploadFile.call(url, image);

      if (uploadFile.isUploaded != null && uploadFile.isUploaded) {
        return true;
      } else {
        throw uploadFile.message;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<bool> _onDeleteReviewPhotoClicked(int index) async {
    if (_photosStatus[index] == PhotoStatus.LOADED) {
      _photosUrls.removeAt(index);
    }
    _photos.removeAt(index);
    _photosStatus.removeAt(index);
    _photosSources.removeAt(index);
    _galleryItems.removeAt(index);
    setState(() {});
    return true;
  }

  _showOpenAppSettingsDialog(context) {
    return CustomDialog.show(
      context,
      'Permission needed',
      'Photos permission is needed to select photos',
      'Open settings',
      openAppSettings,
    );
  }

  _onPhotoClicked(int index) {
    if (_photosStatus[index] == PhotoStatus.ERROR) {
      print("Try uploading again");
      return;
    }
  }
}
