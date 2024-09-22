import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  //const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String extractedText = '';
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      String? text = await _extractText(file);
      setState(() {
        extractedText = text!;
      });
    }
  }

  Future<String?> _extractText(File file) async {
    final textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );
    final InputImage inputImage = InputImage.fromFile(file);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    String text = recognizedText.text;
    textRecognizer.close();
    return text;
  }

  // Future<String> _extractTextFromImage(String path) async {
  //   final inputImage = InputImage.fromFilePath(path);
  //   final textDetector = GoogleMlKit.vision.textDetector();

  //   final RecognisedText recognisedText = await textDetector.processImage(inputImage);
  //   StringBuffer textBuffer = StringBuffer();

  //   for (TextBlock block in recognisedText.blocks) {
  //     textBuffer.writeln(block.text);
  //   }

  //   textDetector.close();
  //   return textBuffer.toString();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hc Note Order'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Extracted Text:', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                extractedText.isEmpty
                    ? 'No text extracted yet.'
                    : extractedText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => _pickImage(ImageSource.camera),
                  child: Card(
                    elevation: 4,
                    child: Container(
                      width: 10,
                      height: 150,
                      alignment: Alignment.center,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 40),
                          SizedBox(height: 10),
                          Text('Camera', style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _pickImage(ImageSource.gallery),
                  child: Card(
                    elevation: 4,
                    child: Container(
                      width: 150,
                      height: 150,
                      alignment: Alignment.center,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.photo, size: 40),
                          SizedBox(height: 10),
                          Text('Gallery', style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
