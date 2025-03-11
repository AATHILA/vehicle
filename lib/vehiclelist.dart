import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'addvehicle.dart';
import 'constants/color_pallette.dart';
import 'constants/custom_text.dart';
import 'main.dart';

class CarGridScreen extends StatefulWidget {
  @override
  State<CarGridScreen> createState() => _CarGridScreenState();
}

class _CarGridScreenState extends State<CarGridScreen> {



  void onEdit() {
    print('Edit icon clicked');
  }

  void onDelete() {
    print('Delete icon clicked');
  }



  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3)).then((value) {
      setState(() => isLoaded = true);
    },);
  }

  Widget actualScreen(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(width*0.03,),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('vehicles').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingScreen();
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No Vehicles Found"));
          }

          var data = snapshot.data!.docs;
          return GridView.builder(
            itemCount: data.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.62,
            ),
            itemBuilder: (context, index) {
              var vehicle = data[index].data();
              int mileage = vehicle["mileage"];
              int year = vehicle["year"];
              int currentYear = DateTime.now().year;
              Color backgroundColor = Colors.red;
              String status = "";

              if (mileage >= 15 && (currentYear - year) <= 5) {
                backgroundColor = Colors.green;
                status = "Fuel efficient\nLow pollutant";
              } else if (mileage < 15 && (currentYear - year) > 5) {
                backgroundColor = Colors.amber;
                status = "Moderately Pollutant";
              } else {
                backgroundColor = Colors.red;
              }

              return Container(

                decoration: BoxDecoration(
                  color: ColorPallette.buttonColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 4,
                      spreadRadius: 2,
                      offset: Offset(0, 4)
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: height*0.13,
                      width: width*0.5,
                      decoration: BoxDecoration(

                        borderRadius: BorderRadius.circular(10),

                        image: DecorationImage(

                          image: MemoryImage(
                              Uint8List.fromList(base64Decode(vehicle['imageData']))),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: height*0.002),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        width: width*1,
                        child: Text(vehicle["name"],style: GoogleFonts.outfit(
                          textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: ColorPallette.cardNameColor),
                        ),
                        textAlign: TextAlign.left
                        ),
                      ),
                    ),
                    SizedBox(height: height*0.001),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0,2.0,8.0,0),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Mileage",style: GoogleFonts.outfit(
                                  textStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.bold,color: ColorPallette.textColorinbutton),
                                ),
                                ),
                                Text("${vehicle["mileage"]} Km/litre",
                                  style: GoogleFonts.outfit(
                                    textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                             crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("Year",style: GoogleFonts.outfit(
                                  textStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.bold,color: ColorPallette.textColorinbutton),
                                ),),
                                Text("${vehicle["year"]}",style: GoogleFonts.outfit(
                                  textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                ),),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),


                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(status,style:GoogleFonts.outfit(
                                textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold,
                                    color: ColorPallette.textColor),
                            )),

                          ],
                        )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        child: CircleAvatar(
                          radius: width*0.025,
                          backgroundColor: backgroundColor,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: onDelete,
                          icon:  Icon(Icons.edit, color: Colors.grey[400],size: width*0.05,),
                          tooltip: 'Edit',
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Confirm Deletion"),
                                   content: Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CustomButton(
                                        height: height*0.67,
                                        backgroundColor: ColorPallette.textColor,

                                        title: 'Cancel',
                                        fontSize: width*0.03,
                                        onPressed:  () =>
                                            Navigator.pop(context),
                                        color: ColorPallette.buttonColor,
                                      ),
                                      CustomButton(
                                        height: height*0.67,
                                          title: 'Delete',
                                      backgroundColor: ColorPallette.textColor,
                                      fontSize: width*0.03,
                                      color: ColorPallette.buttonColor,
                                      onPressed: () {
                                          FirebaseFirestore.instance.collection('vehicles').doc(data[index].id).delete();
                                          Navigator.pop(context);

                                      }),
                                    ],
                                   ),
                                  );
                                },
                            );
                          },
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon:  Icon(Icons.delete, color: Colors.grey[400],size: width*0.05,),
                          tooltip: 'Delete',
                        ),
                      ],
                    ),
                  ],
                ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget loadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/car.json',
            width: 200,
            height: 200,
            repeat: true,
          ),
          const Text("Loading Vehicles..."),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("MyVehicle"),
          centerTitle: true,
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        body: isLoaded ? actualScreen(context) :loadingScreen(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Addvehicle())),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
