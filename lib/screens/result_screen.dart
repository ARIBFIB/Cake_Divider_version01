import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

class ResultScreen extends StatelessWidget {
  final List<DetectedObject> detectedObjects;

  const ResultScreen({super.key, required this.detectedObjects});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detection Results")),
      body: detectedObjects.isEmpty
          ? const Center(child: Text("No objects detected."))
          : ListView.builder(
        itemCount: detectedObjects.length,
        itemBuilder: (context, index) {
          final obj = detectedObjects[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text("Object ${index + 1}"),
              subtitle: Text("Bounding Box: ${obj.boundingBox.toString()}"),
            ),
          );
        },
      ),
    );
  }
}
