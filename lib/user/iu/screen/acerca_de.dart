import 'package:flutter/material.dart';

class AcercaDe extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AcercaDe();
  }
}
class _AcercaDe extends State <AcercaDe> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF90B0FA).withOpacity(0.9),
        title: Text("Acerca de",style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF90B0FA).withOpacity(0.9),
                  Color(0xFF8CB3FA).withOpacity(0.8),
                ],
              )
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Padding(padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: [

                          Image.asset("assets/img/logo2rpConpleto.png", width: 180,height: 160,),
                          Text("Versíon 1.0",style: TextStyle(color: Colors.white,fontSize: 23.0),),
                          SizedBox(height: 30,),
                          Text("Compyright © 2021",style: TextStyle(color: Colors.white,fontSize: 14.0),),
                          Text("All rights reserverd by",style: TextStyle(color: Colors.white,fontSize: 14.0),),
                          Text("2RealPeople Solutions, S.A de C.V",style: TextStyle(color: Colors.white,fontSize: 14.0),),
                          Text("El logotipo 2RealPeople es marca registrada mexicana",style: TextStyle(color: Colors.white,fontSize: 14.0),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}