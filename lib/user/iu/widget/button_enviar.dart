import 'package:flutter/material.dart';

class Button_enviar extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Button_enviar();
  }

}

class _Button_enviar extends State <Button_enviar>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
          width: double.infinity,
          child: OutlineButton(
            child: Container(
                margin: EdgeInsets.symmetric(
                    vertical: 10
                ),
                child: Text(
                    "Enviar",
                    style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black))),
            onPressed: () {

              //Navigator.pop(context);
              //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => crearCuenta()), (Route<dynamic> route) => true);
            },
            textColor: Colors.black,
            borderSide: BorderSide(color: Colors.black),
          )),
    );
  }

}