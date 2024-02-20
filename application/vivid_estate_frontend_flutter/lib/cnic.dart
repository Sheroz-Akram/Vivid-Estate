import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vivid_estate_frontend_flutter/User.dart';
import 'package:image_cropper/image_cropper.dart';

class CnicPage extends StatefulWidget {
  const CnicPage({super.key, required this.userInfo});

  final User userInfo;

  @override
  State<CnicPage> createState() => _CnicPageState();
}

class _CnicPageState extends State<CnicPage> {
  // Store Our CNIC Image in File
  File? cnicImage;

  // Select a image from the prefered source whether camera or gallery
  Future pickImage(ImageSource imageSource, BuildContext myContext) async {
    final image = await ImagePicker().pickImage(source: imageSource);

    // If Image not Selected
    if (image == null) {
      ScaffoldMessenger.of(myContext).showSnackBar(
          const SnackBar(content: Text("Please select or take a image!!")));
    } else {
      // Save our Image in Temporary Files
      File? croppedImage = await ImageCropper().cropImage(
        sourcePath: image.path,
        compressFormat: ImageCompressFormat.png,
        compressQuality: 100,
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Crop CNIC',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          title: 'Crop CNIC',
        ),
      );

      // Check if User Cropped the Image or Not
      if (croppedImage == null) {
        ScaffoldMessenger.of(myContext).showSnackBar(
            const SnackBar(content: Text("Please select or take a image!!")));
      }
      // Display the new Image
      else {
        setState(() {
          this.cnicImage = croppedImage;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
            title: const Text("Back",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF5093A1),
                  fontFamily: "Berlin Sans", // Use a standard font
                )),
            leading: IconButton(
              icon: Image.asset(
                "assets/UI/backButtonImage.png",
                height: 50,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                // Page Information
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 50, right: 50),
                  child: Column(
                    children: <Widget>[
                      Image.asset("assets/UI/cnicImage.png", width: 150),

                      // Page Information
                      const Text("Scan CNIC",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 36.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF006E86),
                            fontFamily: "Berlin Sans", // Use a standard font
                          )),
                      const Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF006E86)),
                          "Please take picture of your cnic only and also make sure to crop it to contains CNIC card only."),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  width: 270,
                  child: Column(
                    children: <Widget>[
                      // Take Picture from Camera Button
                      ElevatedButton(
                          onPressed: () {
                            // take picture from camera
                            pickImage(ImageSource.camera, context);
                          },
                          child: const Row(
                            children: <Widget>[
                              Icon(Icons.camera_alt),
                              SizedBox(width: 10),
                              Text("Take Picture From Camera")
                            ],
                          )),

                      Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          child: const Text("---------- OR ----------")),

                      // Take Picture from Galery Button
                      ElevatedButton(
                          onPressed: () {
                            // take picture from gallery
                            pickImage(ImageSource.gallery, context);
                          },
                          child: const Row(
                            children: <Widget>[
                              Icon(Icons.photo_size_select_actual_rounded),
                              SizedBox(width: 10),
                              Text("Select Picture From Gallery")
                            ],
                          )),

                      // Display Our CNIC Image if Taken
                      cnicImage != null
                          ? Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Column(
                                children: [
                                  const Align(
                                    alignment: Alignment.topLeft,
                                    child: Text("Image Preview",
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF5093A1),
                                          fontFamily:
                                              "Berlin Sans", // Use a standard font
                                        )),
                                  ),
                                  Image.file(cnicImage!,
                                      width: 300, fit: BoxFit.fitWidth),
                                ],
                              ),
                            )
                          : const SizedBox(height: 20),

                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: TextButton(
                            style: ButtonStyle(
                                backgroundColor: const MaterialStatePropertyAll(
                                    Color(0xFF146479)),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                  // Rounded border
                                  side: const BorderSide(
                                      color: Color(0xFF0E0F33),
                                      width: 2.0), // Border style
                                  borderRadius: BorderRadius.circular(4.0),
                                ))),
                            onPressed: () {
                              // Send CNIC to Server for OCR

                              // To Be Implemented
                            },
                            child: Container(
                              width: 200,
                              padding: const EdgeInsets.all(10),
                              child: const Text("Save",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily:
                                        "Berlin Sans", // Use a standard font
                                  )),
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
