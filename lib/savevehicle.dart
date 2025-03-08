// //import 'dart:convert';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:vehicle/vehiclelist.dart';
// import 'main.dart';
// import 'models/usermodel.dart';
//
//
// class Addvehicle extends StatefulWidget {
//   const Addvehicle({super.key});
//
//   @override
//   State<Addvehicle> createState() => _AddvehicleState();
// }
//
// class _AddvehicleState extends State<Addvehicle> {
//   String? _selectedItem;
//   List<String> _filteredItems = [];
//   final List<String> items = [
//     '10Km/litre ',
//     '15km/litre ',
//     '20km/litre ',
//     '25km/litre ',
//     '30km/litre ',
//   ];
//
//   TextEditingController nameController = TextEditingController();
//   TextEditingController yearController = TextEditingController();
//
//   DateTime? _selectedDate;
//   String? base64String;
//   Future<void> _selectDate(BuildContext context) async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2030),
//     );
//
//     if (pickedDate != null) {
//       setState(() {
//         _selectedDate = pickedDate;
//       });
//     }
//   }
//
//   Future<void> addVehicleFunction() async {
//     UserModel vehicles =UserModel(
//       name:nameController.text,
//       mileage: _selectedItem.toString(),
//       year: _selectedDate!,
//       imagePath:  _image.toString(),
//     );
//     //print(vehicles);
//     print(vehicles.toMap());
//
//
//     FirebaseFirestore.instance.collection("vehicles").add(vehicles.toMap());
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _filteredItems = items;
//   }
//
//   File? _image;
//   final ImagePicker _picker = ImagePicker();
//
//   Future<void> _pickImage(ImageSource source) async {
//     final pickedFile = await _picker.pickImage(source: source);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//       List<int> imageBytes = await _image!.readAsBytes();
//       base64String = base64Encode(imageBytes);
//
//       await uploadToFirebaseStorage(_image!);
//     }
//   }
//   Future<void> uploadToFirebaseStorage(File image) async {
//     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//     Reference storageRef =
//     FirebaseStorage.instance.ref().child('vehicles/$fileName.jpg');
//     UploadTask uploadTask = storageRef.putFile(image);
//     await uploadTask.whenComplete(() async {
//       //     //String downloadURL = await storageRef.getDownloadURL();
//       //
//       //     // Save download URL in Firestore
//       //     // await FirebaseFirestore.instance.collection('vehicles').add({
//       //     //   'image_url': downloadURL,
//       //     //   'timestamp': FieldValue.serverTimestamp(),
//       //     // });
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Add Vehicle"),
//         backgroundColor: Colors.black,
//         foregroundColor: Colors.white,
//         leading: Icon(Icons.arrow_back),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             TextFormField(
//               controller: nameController,
//               decoration: InputDecoration(
//                 filled: true,
//                 fillColor: Colors.grey[200],
//                 hintText: "Please enter your name",
//                 border: OutlineInputBorder(
//                     borderSide: BorderSide.none,
//                     borderRadius: BorderRadius.circular(width * 0.03)),
//               ),
//             ),
//             SizedBox(
//               height: height * 0.01,
//             ),
//             DropdownButtonFormField<String>(
//               dropdownColor: Colors.grey[200],
//               focusColor: Colors.grey[200],
//               value: _selectedItem,
//               hint: Text('Mileage'),
//               items: _filteredItems.map((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               onChanged: (newValue) {
//                 setState(() {
//                   _selectedItem = newValue;
//                 });
//               },
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(
//               height: height * 0.01,
//             ),
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(width*0.3),
//                 color: Colors.grey,
//
//               ),
//
//             ),
//             SizedBox(
//               height: height * 0.01,
//             ),
//             ElevatedButton(
//               onPressed: () => _selectDate(context),
//               child: Text( _selectedDate == null
//                   ? "Pick a Date"
//                   : "Year : ${_selectedDate!.year}",),
//             ),
//             SizedBox(
//               height: height * 0.01,
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _image != null
//                     ? Image.file(_image!, width: 200, height: 200, fit: BoxFit.cover)
//                     : Text('No image selected'),
//                 SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () => _pickImage(ImageSource.gallery),
//                       child: Text('Pick from Gallery'),
//                     ),
//                     SizedBox(width: 10),
//                     ElevatedButton(
//                       onPressed: () => _pickImage(ImageSource.camera),
//                       child: Text('Capture Image'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: height*0.1,
//             ),
//             FloatingActionButton.extended(
//               icon: Icon(Icons.save),
//               backgroundColor: Colors.black,
//               foregroundColor: Colors.white,
//               onPressed: () => {
//                 addVehicleFunction(),
//                 Navigator.push(
//
//                   context,
//                   MaterialPageRoute(builder: (context) => CarGridScreen()),
//                 ),
//               }, label:  Text("Add Vehicle"),
//
//
//             ),
//
//           ],
//
//         ),
//       ),
//     );
//   }
// }
//
//
//
