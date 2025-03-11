//import 'dart:convert';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vehicle/constants/color_pallette.dart';
import 'package:vehicle/vehiclelist.dart';
import 'constants/custom_text.dart';
import 'main.dart';
import 'models/usermodel.dart';


class Addvehicle extends StatefulWidget {
  const Addvehicle({super.key});

  @override
  State<Addvehicle> createState() => _AddvehicleState();
}

class _AddvehicleState extends State<Addvehicle> {
  int? _selectedItem;
  List<int> _filteredItems = [];
  final List<int> items = [
    10,
    15,
    20,
    25,
    30
  ];

  TextEditingController nameController = TextEditingController();
  TextEditingController yearController = TextEditingController();

  DateTime? _selectedYear;
  int? _selectedYearStr;
  String? base64String;
  
  showMsg(String msg){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> selectYear(BuildContext context) async {
    DateTime currentDate = DateTime.now();

    await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.dark(
              primary: ColorPallette.buttonColor, // Selected year background color
              onPrimary: ColorPallette.accentColor, // Selected year text color
              surface: ColorPallette.secondaryColor, // Dialog background
              onSurface: ColorPallette.textColor, // Text color
            ),
          ),
          child: Dialog(
            backgroundColor: ColorPallette.secondaryColor, // Dialog background
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: SizedBox(
              height: 300,
              child: YearPicker(
                firstDate: DateTime(2000),
                lastDate: DateTime(2030),
                selectedDate: _selectedYear ?? currentDate,
                onChanged: (DateTime date) {
                  setState(() {
                    _selectedYear = date;
                    _selectedYearStr = date.year;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        );
      },
    );
  }


  Future<void> addVehicleFunction() async {
    UserModel vehicles =UserModel(
        name:nameController.text,
        mileage: _selectedItem!,
        year: _selectedYearStr!,
      imageData: base64String!,
    );
    //print(vehicles);
   print(vehicles.toMap());

try{
  FirebaseFirestore.instance.collection("vehicles").add(vehicles.toMap());
}
    catch(e){
  print("Firebase error while uploading");
  print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _filteredItems = items;
  }

  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      List<int> imageBytes = await _image!.readAsBytes();
      base64String = base64Encode(imageBytes);

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Vehicle"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: Icon(Icons.arrow_back) ,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: ColorPallette.buttonColor,
                hintText: "Please enter your name",
                hintStyle: TextStyle(fontWeight: FontWeight.normal,
                    color: ColorPallette.textColorinbutton),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(width * 0.03)),
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),


        DropdownButtonFormField<int>(
          dropdownColor: ColorPallette.buttonColor, // Matching theme
          value: _selectedItem,
          hint: Text('Mileage in Km/Litre', style: TextStyle(color: ColorPallette.textColorinbutton,
              fontSize:width*0.04,fontWeight: FontWeight.normal),),
          items: _filteredItems.map((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(value.toString(), style: TextStyle(color: ColorPallette.textColor)),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedItem = newValue;
            });
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: ColorPallette.buttonColor, // Background color
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(width * 0.03),
              borderSide: BorderSide.none, // No outline
            ),
          ),
        ),

        SizedBox(
              height: height * 0.01,
            ),

            CustomButton(

              height: height*0.67,
              title: _selectedYearStr == null
                  ? "Pick a Date"
                  : "${_selectedYearStr!}",

              color: ColorPallette.textColorinbutton,

              backgroundColor: ColorPallette.buttonColor,
              borderRadius: 12.0,
              fontSize: width*0.04,
              onPressed: () => selectYear(context),
              fontWeight: FontWeight.normal,
            ),

            SizedBox(
              height: height * 0.01,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _image != null
                    ? Image.file(_image!, width: 200, height: 200, fit: BoxFit.cover)
                    : Text('No image selected'),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
    CustomButton(
      height: height*0.67,
    title: 'Pick from Gallery',
    backgroundColor: ColorPallette.textColorinbutton,
    borderRadius: 8.0,
    fontSize: 16.0,
        onPressed: () => _pickImage(ImageSource.gallery),
    ),
                SizedBox(width: width*0.03),
    CustomButton(
      height: height*0.67,
    title: 'Capture Image',
    backgroundColor: ColorPallette.textColorinbutton,
    borderRadius: 8.0,
    fontSize: 16.0,
    onPressed: () => _pickImage(ImageSource.camera),
    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: height*0.1,
            ),
            FloatingActionButton.extended(
              icon: Icon(Icons.save),
              backgroundColor: ColorPallette.textColorinbutton,
              foregroundColor: Colors.white,
              onPressed: () {
                addVehicleFunction();
                if(nameController!="" && _selectedItem!=null && _selectedYearStr!=null && _image!=null){
                  Navigator.push(

                    context,
                    MaterialPageRoute(builder: (context) => CarGridScreen()),
                  );
                }
                else{
                  nameController.text==""?showMsg("Please enter name"):
                  _selectedItem==null?showMsg("Please select mileage"):
                      _selectedYearStr==null?showMsg("Please pick a year"):
                          showMsg("Please select an image");
                }



              }, label:  Text("Add Vehicle"),


            ),

          ],

        ),
      ),
    );
  }
}



