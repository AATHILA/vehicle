//import 'dart:convert';
//import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vehicle/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'addvehicle.dart';


class CarGridScreen extends StatefulWidget {

  @override
  State<CarGridScreen> createState() => _CarGridScreenState();
}

class _CarGridScreenState extends State<CarGridScreen> {

  bool isLoaded = false;

  @override
  void initState() {

    super.initState();


  }

  Widget actualScreen(BuildContext context){
   return

      StreamBuilder(
          stream: FirebaseFirestore.instance.doc('vehicles').snapshots(),
          builder: (context, snapshot) {
            var data=snapshot.data!.docs;
            return GridView.builder(
              itemCount: data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two columns
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.65, // Aspect ratio of items
              ),

              itemBuilder: (context, index) {
                String status=" ";
                //  final car = cars[index];
                int mileage=data[index]["mileage"];
                int year=data[index]["year"];
                int currentYear=DateTime.now().year;
                Color backgroundColor=Colors.white;

                if(mileage>=15 &&  (currentYear-year)<=5){
                  backgroundColor=Colors.green;
                  status="Fuel efficient\nLow pollutant";

                }
                else if(mileage<15 && (currentYear-year)>5){
                  backgroundColor=Colors.amber;
                  status="Fuel efficient\nModerately Pollutant";
                }
                else{
                  backgroundColor=Colors.red;
                  status="";
                }
                return Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: backgroundColor,

                    borderRadius: BorderRadius.circular(width * 0.03),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: height * 0.15,
                          width: width * 0.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(width * 0.3),
                            image:
                            DecorationImage(
                              image: MemoryImage(
                                Uint8List.fromList(base64Decode(data[index]['imageData'])),
                              ),
                              fit: BoxFit.cover,
                            ),
                          )
                      ),
                      SizedBox(height: height * 0.01),
                      Text(
                        data[index]["name"],
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: height * 0.01),
                      Text("Mileage: ${data[index]["mileage"]} Km/litre"),
                      SizedBox(height: height * 0.01),
                      Text("Year: ${data[index]["year"]}"),
                      Container(
                          decoration:BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.circular(width*0.01),
                          ),
                          child: Text(status,style: TextStyle(fontWeight: FontWeight.bold,fontSize: width*0.03,fontStyle: FontStyle.italic),)),
                    ]
                    ,
                  )
                  ,
                );
              },
            );
          }
      );


  }

  Widget loadingScreen(){
    return
    Center(
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
    );
  }
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
        body:
        isLoaded?actualScreen(context):loadingScreen(),
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



