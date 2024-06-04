import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

class VirtualVisitCapture extends StatefulWidget {
  const VirtualVisitCapture({super.key});

  @override
  State<VirtualVisitCapture> createState() => _VirtualVisitCaptureState();
}

class _VirtualVisitCaptureState extends State<VirtualVisitCapture> {
  CameraController? controller;
  String imagePath = "";

  // Store the List of All Images
  List<String> imagesPath = [];
  int selectedImage = 0;

  @override
  void initState() {
    super.initState();

    // Inialize and Load the Camera
    loadCamera();
  }

  // Load the Camera
  Future<void> loadCamera() async {
    List<CameraDescription>? cameras = await availableCameras();
    controller =
        CameraController(cameras[1], ResolutionPreset.high, enableAudio: false);
    controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  // Capture the Image From Camera
  void captureImage() async {
    try {
      final image = await controller!.takePicture();
      setState(() {
        imagePath = image.path;

        // Add new image to list of images
        imagesPath.add(imagePath);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller!.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left Side Button To Go Previous
                  IconButton(
                    onPressed: () {
                      // Increment the Selected Image
                      setState(() {
                        selectedImage--;
                      });
                    },
                    icon: Icon(
                        selectedImage >= 0 && selectedImage < imagesPath.length
                            ? Icons.add
                            : Icons.arrow_back_ios_new),
                    iconSize: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: AspectRatio(
                        aspectRatio: controller!.value.aspectRatio,
                        child: imagesPath.length < selectedImage + 1
                            ? CameraPreview(controller!)
                            : Image.file(File(imagesPath[selectedImage]))),
                  ),

                  // Right Side Button to Go Forward
                  IconButton(
                      onPressed: () {
                        // Increment the Selected Image
                        setState(() {
                          selectedImage++;
                        });
                      },
                      icon: const Icon(Icons.add)),
                ],
              ),
              TextButton(
                  onPressed: () async {
                    captureImage();
                  },
                  child: const Text("Take Photo")),
            ],
          ),
        ),
      ),
    );
  }
}
