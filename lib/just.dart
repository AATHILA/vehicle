import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImageUploader extends StatefulWidget {
  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  File? _image;
  final picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Convert image to Base64
      List<int> imageBytes = await _image!.readAsBytes();
      String base64String = base64Encode(imageBytes);

      // Save to Firebase Firestore
      await FirebaseFirestore.instance.collection('images').add({
        'image_base64': base64String,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Save to Firebase Storage (optional)
      await uploadToFirebaseStorage(_image!);
    }
  }

  Future<void> uploadToFirebaseStorage(File image) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef =
    FirebaseStorage.instance.ref().child('images/$fileName.jpg');

    UploadTask uploadTask = storageRef.putFile(image);
    await uploadTask.whenComplete(() async {
      String downloadURL = await storageRef.getDownloadURL();

      // Save download URL in Firestore
      // await FirebaseFirestore.instance.collection('image_urls').add({
      //   'image_url': downloadURL,
      //   'timestamp': FieldValue.serverTimestamp(),
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Image to Firebase')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? Image.file(_image!, height: 200)
                : Text('No image selected'),
            ElevatedButton(
              onPressed: pickImage,
              child: Text('Pick & Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
