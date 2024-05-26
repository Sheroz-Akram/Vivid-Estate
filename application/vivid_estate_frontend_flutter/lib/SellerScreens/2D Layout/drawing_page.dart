import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:vivid_estate_frontend_flutter/SellerScreens/2D%20Layout/drawing_canvas/drawing_canvas.dart';
import 'package:vivid_estate_frontend_flutter/SellerScreens/2D%20Layout/drawing_canvas/models/drawing_mode.dart';
import 'package:vivid_estate_frontend_flutter/SellerScreens/2D%20Layout/drawing_canvas/models/sketch.dart';
import 'package:vivid_estate_frontend_flutter/SellerScreens/2D%20Layout/drawing_canvas/widgets/canvas_side_bar.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DrawingPage extends HookWidget {
  const DrawingPage({super.key});

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

    ValueNotifier<Sketch?> currentSketch = useState(null);
    ValueNotifier<List<Sketch>> allSketches = useState([]);
    var mainScrollController = ScrollController();

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 150),
      initialValue: 1,
    );
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          controller: mainScrollController,
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
              Positioned(
                top: 70,
                child: SlideTransition(
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.black),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: InteractiveViewer(
                      panEnabled: false,
                      boundaryMargin: const EdgeInsets.all(0),
                      scaleEnabled: false,
                      child: DrawingCanvas(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 200,
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
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                width: 150,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(color: Colors.black, width: 2),
                    shadowColor: Colors.black26,
                    backgroundColor: const Color(0XFF146479),
                  ),
                  onPressed: () {
                    print('Save');
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
