import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

class ObjectDetectorScreen extends StatefulWidget {
  const ObjectDetectorScreen({super.key});

  @override
  State<ObjectDetectorScreen> createState() => _ObjectDetectorScreenState();
}

class _ObjectDetectorScreenState extends State<ObjectDetectorScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  late ObjectDetector _objectDetector;
  bool _isDetecting = false;
  List<DetectedObject> _detectedObjects = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeObjectDetector();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras!.isNotEmpty) {
      _cameraController =
          CameraController(_cameras![0], ResolutionPreset.medium);
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {});
      }
      _startImageStream();
    }
  }

  void _initializeObjectDetector() {
    final options = ObjectDetectorOptions(
      mode: DetectionMode.stream,
      classifyObjects: true,
      multipleObjects: true,
    );
    _objectDetector = ObjectDetector(options: options);
  }

  void _startImageStream() {
    _cameraController!.startImageStream((CameraImage image) async {
      if (_isDetecting) return;
      _isDetecting = true;

      try {
        final inputImage = _convertCameraImageToInputImage(image);
        final List<DetectedObject> objects =
        await _objectDetector.processImage(inputImage);

        if (objects.isNotEmpty) {
          _cameraController!.stopImageStream();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(detectedObjects: objects),
            ),
          );
        }
      } catch (e) {
        print("Error detecting objects: $e");
      } finally {
        _isDetecting = false;
      }
    });
  }

  InputImage _convertCameraImageToInputImage(CameraImage image) {
    final bytes = image.planes[0].bytes;
    final inputImageData = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: InputImageRotation.rotation0deg,
      format: InputImageFormat.nv21,
      bytesPerRow: image.planes[0].bytesPerRow,
    );
    return InputImage.fromBytes(bytes: bytes, metadata: inputImageData);
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _objectDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Object Detector")),
      body: _cameraController != null && _cameraController!.value.isInitialized
          ? CameraPreview(_cameraController!)
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final List<DetectedObject> detectedObjects;

  const ResultScreen({super.key, required this.detectedObjects});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detection Results")),
      body: ListView.builder(
        itemCount: detectedObjects.length,
        itemBuilder: (context, index) {
          final obj = detectedObjects[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text("Object ${index + 1}"),
              subtitle: Text("Bounding Box: ${obj.boundingBox}"),
            ),
          );
        },
      ),
    );
  }
}
