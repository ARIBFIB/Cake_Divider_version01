import 'package:cake_divider/widgets/division_overlay.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  bool isCameraInitialized = false;
  int slices = 4;


  @override
  void initState(){
    super.initState();
    _initializedCamera();
  }


  Future<void> _initializedCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(cameras![0], ResolutionPreset.high);
    await _cameraController!.initialize();
    setState(() {
      isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cake Divider"),),
      body: isCameraInitialized
      ? Stack(
        children: [
          CameraPreview(_cameraController!),
          Positioned.fill(child: DivisionOverlay(slices: slices),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              children: [
                Text("Slices : $slices"),
                Slider(
                  min: 2,
                  max: 12,
                  value: slices.toDouble(),
                  onChanged: (val) {
                    setState(() {
                      slices = val.toInt();
                    });
                  },
                )
              ],
            ),
          )
        ],
      ) : const Center(child: CircularProgressIndicator(),),
    );
  }
}
