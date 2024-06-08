import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:vivid_estate_frontend_flutter/BuyerScreens/PanoramaView.dart';
import 'package:vivid_estate_frontend_flutter/SellerScreens/360%20Virtual%20Visit/PictureDataset.dart';
import 'dart:io';

class VirtualVisitCapture extends StatefulWidget {
  const VirtualVisitCapture({super.key});

  @override
  State<VirtualVisitCapture> createState() => _VirtualVisitCaptureState();
}

class _VirtualVisitCaptureState extends State<VirtualVisitCapture> {
  CameraController? controller;
  late Future<void> initializeControllerFuture;

  // DataStructure to Store 360 Images
  PictureDataset pictureDataset = PictureDataset();

  var selectedType = "Auto";
  String virtualVisitLocation = "";

  @override
  void initState() {
    super.initState();
    // Initialize and Load the Camera
    initializeControllerFuture = loadCamera();
  }

  // Load the Camera
  Future<void> loadCamera() async {
    List<CameraDescription> cameras = await availableCameras();
    controller =
        CameraController(cameras[0], ResolutionPreset.high, enableAudio: false);
    await controller!.initialize();
    controller!.setFlashMode(FlashMode.auto);
    if (mounted) {
      setState(() {});
    }
  }

  // Capture the Image From Camera
  void captureImage() async {
    try {
      final image = await controller!.takePicture();
      setState(() {
        String imagePath = image.path;

        // Add New Image to Picture Matrix
        pictureDataset.addNewPicture(imagePath);
      });
    } catch (e) {
      print(e);
    }
  }

  // Upload All Images to Server for Panaroma Stitching
  void uploadImagesToServer() {
    pictureDataset.uploadToSever();
  }

  // Toggle Flash
  void toggleFlash() {}

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<void>(
            future: initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.arrow_back_ios_new,
                                  color: Color(0XFF006E86))),
                          const Text(
                            "Virtual Visit Capture",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 22,
                                color: Color(0XFF006E86)),
                          ),
                        ],
                      ),

                      // Select Flash Mode of the Application
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 15, top: 10),
                              child: const Text(
                                "Flash Mode:",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0XFF8D8D8D),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 15, top: 10, right: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: ['Torch', 'Auto', 'Off']
                                    .map((type) => ChoiceChip(
                                        label: Text(type),
                                        selected: selectedType == type,
                                        onSelected: (bool selected) {
                                          setState(() {
                                            selectedType = type;
                                          });

                                          // Change Flash Mode
                                          if (selectedType == 'Torch') {
                                            controller!
                                                .setFlashMode(FlashMode.torch);
                                          } else if (selectedType == 'Auto') {
                                            controller!
                                                .setFlashMode(FlashMode.auto);
                                          } else if (selectedType == 'Off') {
                                            controller!
                                                .setFlashMode(FlashMode.off);
                                          }
                                        },
                                        selectedColor: const Color(0xFF006E86),
                                        checkmarkColor: Colors.white,
                                        labelStyle: TextStyle(
                                          fontSize: 10,
                                          color: selectedType == type
                                              ? Colors.white
                                              : Colors
                                                  .black, // Adjust 'black' if needed
                                        )))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Top Button
                      Center(
                        child: IconButton(
                            onPressed: () {
                              // Check If Can Move Upward
                              if (pictureDataset.yLocation == 2) {
                                // Display Message
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Already at Top Location")));
                              } else {
                                // Move to Up Location
                                setState(() {
                                  pictureDataset.yLocation++;
                                });
                              }
                            },
                            icon: const Icon(Icons.arrow_upward_rounded)),
                      ),

                      // Display Center Images
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left Button
                          Center(
                            child: IconButton(
                                onPressed: () {
                                  // Check If Can Move Downward
                                  if (pictureDataset.xLocation == 0) {
                                    // Display Message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Already at Most Left Location")));
                                  } else {
                                    // Move to Up Location
                                    setState(() {
                                      pictureDataset.xLocation--;
                                    });
                                  }
                                },
                                icon: const Icon(Icons.arrow_back_rounded)),
                          ),

                          // Take Picture from Camera
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: AspectRatio(
                              aspectRatio: controller!.value.aspectRatio,
                              child:
                                  // Check Have Picture at Current Location
                                  !pictureDataset.havePictureAt(
                                          pictureDataset.xLocation,
                                          pictureDataset.yLocation)
                                      ? Stack(children: [
                                          // Display Camera to Screen
                                          CameraPreview(controller!),

                                          // Display Right Side of the Previous Image on Left
                                          pictureDataset.havePictureAt(
                                                  pictureDataset.xLocation - 1,
                                                  pictureDataset.yLocation)
                                              ? SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.6,
                                                  child: ClipRect(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child:
                                                          FractionalTranslation(
                                                        translation: const Offset(
                                                            -0.95,
                                                            0.0), // Move left by 90% of the width
                                                        child: Opacity(
                                                          opacity: 0.5,
                                                          child: Image.file(File(
                                                              pictureDataset.getImage(
                                                                  pictureDataset
                                                                          .xLocation -
                                                                      1,
                                                                  pictureDataset
                                                                      .yLocation))),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox.shrink(),

                                          // Display Top Side of the Bottom Image on Bottom
                                          pictureDataset.havePictureAt(
                                                  pictureDataset.xLocation,
                                                  pictureDataset.yLocation - 1)
                                              ? Column(
                                                  children: [
                                                    const Spacer(),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                      child: ClipRect(
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child:
                                                              FractionalTranslation(
                                                            translation:
                                                                const Offset(
                                                                    0.0,
                                                                    0.95), // Move Bottom by 90% of the Height
                                                            child: Opacity(
                                                              opacity: 0.5,
                                                              child: Image.file(File(pictureDataset.getImage(
                                                                  pictureDataset
                                                                      .xLocation,
                                                                  pictureDataset
                                                                          .yLocation -
                                                                      1))),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox.shrink(),

                                          // Display Bottom Side of the Top Image on Top
                                          pictureDataset.havePictureAt(
                                                  pictureDataset.xLocation,
                                                  pictureDataset.yLocation + 1)
                                              ? SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.7,
                                                  child: ClipRect(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child:
                                                          FractionalTranslation(
                                                        translation: const Offset(
                                                            0.0,
                                                            -0.95), // Move Top by 90% of the Height
                                                        child: Opacity(
                                                          opacity: 0.5,
                                                          child: Image.file(File(
                                                              pictureDataset.getImage(
                                                                  pictureDataset
                                                                      .xLocation,
                                                                  pictureDataset
                                                                          .yLocation +
                                                                      1))),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox.shrink(),

                                          /**
                                       * Buttom To Capture the Image
                                       */
                                          Center(
                                            child: Column(
                                              children: [
                                                const Spacer(),
                                                InkWell(
                                                  onTap: () {
                                                    // Click the Picture and Store It
                                                    captureImage();
                                                  },
                                                  child: Image.asset(
                                                      width: 70,
                                                      "assets/UI/captureIcon.png"),
                                                ),
                                                const Text(
                                                  "Capture Picture",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 255, 255, 255)),
                                                ),
                                                const SizedBox(
                                                  height: 30,
                                                )
                                              ],
                                            ),
                                          )
                                        ])
                                      : Stack(children: [
                                          InkWell(
                                              onTap: () {
                                                // Display Message
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            "Double Tap to Remove Image")));
                                              },
                                              onDoubleTap: () {
                                                // Remove the Current Image
                                                setState(() {
                                                  pictureDataset
                                                      .removePicture();
                                                });

                                                // Display Message
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            "Picture Removed")));
                                              },
                                              child: Image.file(File(
                                                  pictureDataset.getImage(
                                                      pictureDataset.xLocation,
                                                      pictureDataset
                                                          .yLocation)))),
                                          Column(
                                            children: [
                                              const Spacer(),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 5, bottom: 5),
                                                child: Text(
                                                    "Point: ${pictureDataset.currentlocation()}, Coordinates: (${pictureDataset.xLocation}, ${pictureDataset.yLocation})",
                                                    style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255,
                                                            255,
                                                            255,
                                                            255))),
                                              )
                                            ],
                                          ),
                                        ]),
                            ),
                          ),

                          // Right Button
                          Center(
                            child: IconButton(
                                onPressed: () {
                                  // Move to Next Picture
                                  setState(() {
                                    pictureDataset.xLocation++;
                                  });
                                },
                                icon: const Icon(Icons.arrow_forward_rounded)),
                          ),
                        ],
                      ),

                      // Bottom Button
                      Center(
                        child: IconButton(
                            onPressed: () {
                              // Check If Can Move Downward
                              if (pictureDataset.yLocation == 0) {
                                // Display Message
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Already at Bottom Location")));
                              } else {
                                // Move to Up Location
                                setState(() {
                                  pictureDataset.yLocation--;
                                });
                              }
                            },
                            icon: const Icon(Icons.arrow_downward_rounded)),
                      ),

                      // Buttons to Perform Functions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Upload To Server Button
                          ElevatedButton(
                              onPressed: () async {
                                String response =
                                    await pictureDataset.uploadToSever();

                                // Display Error
                                if (response == "error") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Error has occured while creating virtual visit")));
                                } else {
                                  setState(() {
                                    virtualVisitLocation = response;
                                  });
                                }

                                // Display Preview of Virtual Visit
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PanoramaView(
                                            VisitLocation:
                                                virtualVisitLocation)));
                              },
                              child: const Text("Preview")),

                          // Save the virtual Visit and Exit
                          ElevatedButton(
                              onPressed: () {
                                if (virtualVisitLocation.isNotEmpty) {
                                  Navigator.pop(context, virtualVisitLocation);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "First Create and Preview Virtual Visit")));
                                }
                              },
                              child: const Text("Save")),
                        ],
                      )
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
