import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vehicle/addvehicle.dart';
import 'package:vehicle/main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  dynamic _controller;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:
          AppBar(
            title: Text("MyVehicle"),
            centerTitle: true,
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/car.json',
                width: width*0.7,
                height: height*0.4,
                repeat: true,
              ),
               Text("No Vehicles Found"),
            ],
          ),
        ),
        floatingActionButton:
    GestureDetector(
    onTap: () {
    // Navigate to the second page
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Addvehicle()),
    );
    },
    child:
        Container(
           height: height*0.05,
           width: width*0.89,
           decoration: BoxDecoration(
               color: Colors.black,
             borderRadius: BorderRadius.circular(5)
           ),
           child: Center(
             child: Text("Add New Vehicle",style: TextStyle(
               color: Colors.white,

             ),),
           ),
        ),
    ),
      ),
    );
  }
}
