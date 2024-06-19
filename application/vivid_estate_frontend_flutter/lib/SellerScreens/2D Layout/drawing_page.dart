import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/rendering.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vivid_estate_frontend_flutter/Classes/Seller.dart';
import 'package:vivid_estate_frontend_flutter/SellerScreens/2D%20Layout/drawing_canvas/drawing_canvas.dart';
import 'package:vivid_estate_frontend_flutter/SellerScreens/2D%20Layout/drawing_canvas/models/drawing_mode.dart';
import 'package:vivid_estate_frontend_flutter/SellerScreens/2D%20Layout/drawing_canvas/models/sketch.dart';
import 'package:vivid_estate_frontend_flutter/SellerScreens/2D%20Layout/drawing_canvas/widgets/canvas_side_bar.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DrawingPage extends HookWidget {
  final Function(String) updateParentData;
  const DrawingPage({super.key, required this.updateParentData});

  @override
  Widget build(BuildContext context) {
    final selectedColor = useState(Colors.black);
    final strokeSize = useState<double>(5);
    final eraserSize = useState<double>(30);
    final drawingMode = useState(DrawingMode.pencil);
    final filled = useState<bool>(false);
    final polygonSides = useState<int>(3);
    final backgroundImage = useState<Image?>(null);

    final canvasGlobalKey = GlobalKey();

    // Seller Object to Perform Seller Functionality
    Seller seller = Seller();

    ValueNotifier<Sketch?> currentSketch = useState(null);
    ValueNotifier<List<Sketch>> allSketches = useState([]);
    final mainScrollController = useScrollController();
    final isDrawing = useState(false);

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 150),
      initialValue: 1,
    );

    void onPointerDown(PointerDownEvent details) {
      isDrawing.value = true;
    }

    void onPointerUp(PointerUpEvent details) {
      isDrawing.value = false;
    }

    // Generate Image from Canvas c
    Future<File?> getFileFromCanvas() async {
      try {
        // Find the render object and get the image from the repaint boundary
        RenderRepaintBoundary boundary = canvasGlobalKey.currentContext
            ?.findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage();
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List? pngBytes = byteData?.buffer.asUint8List();

        if (pngBytes == null) {
          return null;
        }

        // Get the temporary directory of the device
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;

        // Generate a random filename
        String fileName = 'canvas_${DateTime.now().millisecondsSinceEpoch}.png';

        // Create a new file in the temporary directory
        File file = File('$tempPath/$fileName');

        // Write the bytes to the file
        await file.writeAsBytes(pngBytes, flush: true);

        return file;
      } catch (e) {
        print("Error while getting file from canvas: $e");
        return null;
      }
    }

    // Pick File from User Local Storage
    Future<File?> pickFile() async {
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp'],
        );

        if (result != null && result.files.isNotEmpty) {
          PlatformFile file = result.files.first;

          // Check if file path is available
          if (file.path != null) {
            // Create a File object with the retrieved path
            File pickedFile = File(file.path!);
            return pickedFile;
          } else if (file.bytes != null) {
            // Retrieve file bytes if the file path is not available
            Uint8List bytes = file.bytes!;

            // Create a temporary file
            String tempPath = (await getTemporaryDirectory()).path;
            File tempFile = File('$tempPath/${file.name}');
            await tempFile.writeAsBytes(bytes);

            return tempFile;
          } else {
            print('File has no path or bytes');
            return null;
          }
        } else {
          print('No file picked');
          return null;
        }
      } catch (e) {
        print('Error picking file: $e');
        return null;
      }
    }

    Future<File?> cropImageFile(File? imageFile) async {
      try {
        File? croppedFile = await ImageCropper().cropImage(
          sourcePath: imageFile!.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Crop 2D Layout',
            backgroundColor: Colors.white,
            toolbarColor: Color(0XFF146479),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          iosUiSettings: const IOSUiSettings(
            minimumAspectRatio: 1.0,
          ),
        );

        if (croppedFile != null) {
          return File(croppedFile.path);
        } else {
          print('Image cropping cancelled or failed');
          return null;
        }
      } catch (e) {
        print('Error cropping image: $e');
        return null;
      }
    }

    // Save the 2D Layout of the User in Server
    void submit2DLayout(File? userLayoutImageFile) async {
      // Check if the Image is not null
      if (userLayoutImageFile == null) {
        seller.displayHelper.displaySnackBar(
            "Please Create or Select 2D Layout", false, context);
        return;
      }

      // Open Image Cropper to Crop the Image
      File? croppedImage = await cropImageFile(userLayoutImageFile);
      if (croppedImage == null) {
        seller.displayHelper.displaySnackBar(
            "Please confirm to save the image", false, context);
        return;
      }

      // Now Upload to the Sever and Save There
      await seller.getAuthData();
      String responseMessage = await seller.uploadLayout(userLayoutImageFile);

      // Check the Response
      if (responseMessage == "error") {
        seller.displayHelper
            .displaySnackBar("Unable to save layout file", false, context);
        return;
      }
      updateParentData(responseMessage);
      Navigator.pop(context);
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                if (isDrawing.value) {
                  return true;
                }
                return false;
              },
              child: SingleChildScrollView(
                controller: mainScrollController,
                physics: isDrawing.value
                    ? const NeverScrollableScrollPhysics()
                    : const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 5,
                        left: 15,
                        right: 15,
                        bottom: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Create 2D Layout',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0XFF006E86),
                            ),
                          ),
                          // Move to the Previous Screen
                          CloseButton(
                            onPressed: () {
                              // POP The Current Screen from Navigator
                              Navigator.pop(context);
                            },
                            color: const Color(0XFF006E86),
                          ),
                        ],
                      ),
                    ),
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(-1, 0),
                        end: Offset.zero,
                      ).animate(animationController),
                      child: CanvasSideBar(
                        drawingMode: drawingMode,
                        selectedColor: selectedColor,
                        strokeSize: strokeSize,
                        eraserSize: eraserSize,
                        currentSketch: currentSketch,
                        allSketches: allSketches,
                        canvasGlobalKey: canvasGlobalKey,
                        filled: filled,
                        polygonSides: polygonSides,
                        backgroundImage: backgroundImage,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: ClipRRect(
                          child: FittedBox(
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 2, color: Colors.black),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Listener(
                                onPointerDown: onPointerDown,
                                onPointerUp: onPointerUp,
                                child: DrawingCanvas(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height - 200,
                                  drawingMode: drawingMode,
                                  selectedColor: selectedColor,
                                  strokeSize: strokeSize,
                                  eraserSize: eraserSize,
                                  sideBarController: animationController,
                                  currentSketch: currentSketch,
                                  allSketches: allSketches,
                                  canvasGlobalKey: canvasGlobalKey,
                                  filled: filled,
                                  polygonSides: polygonSides,
                                  backgroundImage: backgroundImage,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 20, left: 15, right: 15, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              side: const BorderSide(
                                  color: Colors.black, width: 2),
                              shadowColor: Colors.black26,
                              backgroundColor: const Color(0XFF146479),
                            ),
                            onPressed: () async {
                              submit2DLayout(await getFileFromCanvas());
                            },
                            child: const Text(
                              'Save',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              side: const BorderSide(
                                  color: Colors.black, width: 2),
                              shadowColor: Colors.black26,
                              backgroundColor: const Color(0XFF146479),
                            ),
                            onPressed: () async {
                              submit2DLayout(await pickFile());
                            },
                            child: const Text(
                              'Upload Map',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
