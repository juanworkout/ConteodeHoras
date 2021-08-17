import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:untitled/user/iu/screen/editar_form.dart';
import 'package:untitled/user/model/TaskReponse.dart';
import 'package:flutter/material.dart';

class listaWidget extends StatefulWidget {
  final TaskReponse ts;
  final UserId;

  listaWidget(this.ts, this.UserId);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _listaWidget(ts);
  }
}

class _listaWidget extends State<listaWidget> {
  final TaskReponse ts;

  _listaWidget(this.ts);

  String fecha;

  @override
  void initState() {
    super.initState();
    //El formato de fecha lo reseteo aqui uno por uno en ete caso la fecha de inicio
    DateTime now = DateTime.parse(ts.DateStart);
    String formattedDate = DateFormat('dd/MM/yyyy hh:mm').format(now);
    // Aqui se esta formateando la fecha
    fecha = formattedDate;
  }
    //Este metodo pinta los datos de la lista apartir del metadata
  datosSub() {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      EditarForm(widget.UserId)));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.work_outlined,
                  size: 15.0,
                  color: Colors.grey,
                ),
                Text('  ${ts.Metadata1}'),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.date_range,
                  size: 15.0,
                  color: Colors.grey,
                ),
                Text('  ${fecha}'),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 15.0,
                      color: Colors.grey,
                    ),
                    Text('  ${ts.Metadata2}'),
                  ],
                ),
                Container(
                  child: selector(),
                ),
              ],
            ),
          ],
        ));

    //
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      margin: EdgeInsets.only(left: 1, right: 1, top: 8, bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 10.0,
      color: Colors.grey[150],
      //Creacion de la lista se encuentra la lista el nombre y subtitulo
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
            title: Text(
              ts.Name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: datosSub(),
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Text(
                ts.Name[0].toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget selector() {
      if (ts.Metadata3.isNotEmpty && ts.Metadata3[0] == "P") {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  ts.Metadata3,
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        );
      } else if (ts.Metadata3.isNotEmpty && ts.Metadata3[0] == "F") {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  ts.Metadata3,
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        );
      }else if (ts.Metadata3.isNotEmpty && ts.Metadata3[0] == "E") {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  ts.Metadata3,
                  style: TextStyle(
                      color: Colors.yellow, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        );
    } if (ts.Metadata3.isNotEmpty && ts.Metadata3[0] == "C") {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  ts.Metadata3,
                  style: TextStyle(
                      color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        );
    }
  }
}
