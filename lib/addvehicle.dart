import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vehicle/constants/color_pallette.dart';
import 'package:vehicle/models/usermodel.dart';
import 'package:vehicle/vehiclelist.dart';
import 'constants/custom_button.dart';
import 'main.dart';

class AddEditVehicle extends StatefulWidget {
  final DocumentSnapshot? vehicleData;

  const AddEditVehicle({super.key, this.vehicleData});

  @override
  State<AddEditVehicle> createState() => _AddEditVehicleState();
}

class _AddEditVehicleState extends State<AddEditVehicle> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mileageController = TextEditingController();
  DateTime? _selectedYear;
  int? _selectedYearStr;
  String? base64String;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.vehicleData != null) {
      nameController.text = widget.vehicleData!['name'];
      _selectedYear = DateTime(widget.vehicleData!['year']);
      _selectedYearStr = widget.vehicleData!['year'];
      mileageController.text = widget.vehicleData!['mileage'].toString();
      assignImageFromBase64(widget.vehicleData!['imageData']);
    }
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> selectYear(BuildContext context) async {
    DateTime currentDate = DateTime.now();

    await showDialog<DateTime>(
      context: context,
      builder: (context) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark(
            primary: ColorPallette.buttonColor,
            onPrimary: ColorPallette.accentColor,
            surface: ColorPallette.secondaryColor,
            onSurface: ColorPallette.textColor,
          ),
        ),
        child: Dialog(
          backgroundColor: ColorPallette.secondaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: YearPicker(
              firstDate: DateTime(2000),
              lastDate: DateTime(2030),
              selectedDate: _selectedYear ?? currentDate,
              onChanged: (date) {
                setState(() {
                  _selectedYear = date;
                  _selectedYearStr = date.year;
                });
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addUpdateVehicleFunction() async {
    if (nameController.text.isEmpty || mileageController.text.isEmpty || _selectedYearStr == null || _image == null) {
      showMsg("Please fill all fields before submitting.");
      return;
    }

    UserModel vehicle = UserModel(
      name: nameController.text,
      mileage: double.parse(mileageController.text),
      year: _selectedYearStr!,
      imageData: base64String!,
    );

    try {
      if(widget.vehicleData!=null){
        await FirebaseFirestore.instance
            .collection("vehicles")
            .doc(widget.vehicleData!.id)
            .update(vehicle.toMap());
      }
      else{
      await FirebaseFirestore.instance.collection("vehicles").add(vehicle.toMap());
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CarGridScreen()));
    } catch (e) {
      showMsg("Firebase error while uploading: $e");
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null) return;

    File imageFile = File(pickedFile.path);
    List<int> imageBytes = await imageFile.readAsBytes();

    setState(() {
      _image = imageFile;
      base64String = base64Encode(imageBytes);
    });
  }

  Future<void> assignImageFromBase64(String base64Str) async {
    Uint8List bytes = base64Decode(base64Str);


    Directory tempDir = await getTemporaryDirectory();


    try {
      tempDir.listSync().forEach((file) {
        if (file is File && file.path.contains('image_')) {
          file.deleteSync();
        }
      });
    } catch (e) {
      print("Error deleting old images: $e");
    }

    String uniqueFileName = 'image_${DateTime.now().millisecondsSinceEpoch}.png';
    String tempPath = '${tempDir.path}/$uniqueFileName';

    File imageFile = File(tempPath);
    await imageFile.writeAsBytes(bytes);

    setState(() {
      _image = imageFile;
      base64String = base64Str;
    });
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Vehicle"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(nameController, "Enter Vehicle Name"),
              SizedBox(height: height * 0.01),
              _buildTextField(mileageController, "Mileage in Km/Litre", keyboardType: TextInputType.number),
              SizedBox(height: height * 0.01),
              CustomButton(
                height: height * 0.69,
                title: _selectedYearStr == null ? "Pick a Date" : "$_selectedYearStr",
                color: _selectedYearStr == null ? ColorPallette.textColorinfield : ColorPallette.cardNameColor,
                backgroundColor: ColorPallette.buttonColor,
                borderRadius: width * 0.03,
                fontSize: width * 0.04,
                onPressed: () => selectYear(context),
                fontWeight: FontWeight.normal,
              ),
              SizedBox(height: height * 0.01),
              _buildImagePicker(),
              SizedBox(height: height * 0.1),
              CustomButton(
                title: widget.vehicleData!=null?"Update Vehicle":"Add Vehicle",
                height: height * 0.67,
                width: width * 0.5,
                alignment: Alignment.center,
                backgroundColor: ColorPallette.textColorinfield,
                color: Colors.white,
                borderRadius: width * 0.03,
                onPressed: addUpdateVehicleFunction,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller,
      String hint, {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: ColorPallette.buttonColor,
        hintText: hint,
        hintStyle: TextStyle(color: ColorPallette.textColorinfield),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide.none),
      ),
      style: TextStyle(color: ColorPallette.textColor),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _image != null
            ? Image.file(_image!, width: 200, height: 200, fit: BoxFit.cover)
            : Text('No image selected', style: TextStyle(color: ColorPallette.textColorinfield)),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              height: height*0.67,
              title: 'Pick from Gallery',
              backgroundColor: ColorPallette.textColorinfield,
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
            SizedBox(width: 10),
            CustomButton(
              height: height*0.67,

              title: 'Capture Image',
              backgroundColor: ColorPallette.textColorinfield,
              onPressed: () => _pickImage(ImageSource.camera),
            ),
          ],
        ),
      ],
    );
  }
}
