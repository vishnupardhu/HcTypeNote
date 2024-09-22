import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:hctypeorder/screens/scantype_camorder.dart';
import 'package:hctypeorder/screens/texttype_order.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:image_cropper/image_cropper.dart';

class HomeScreenHc extends StatefulWidget {
  const HomeScreenHc({super.key});

  @override
  State<HomeScreenHc> createState() => _HomeScreenHcState();
}

class _HomeScreenHcState extends State<HomeScreenHc> {
  String extractedText = '';
  final ImagePicker _picker = ImagePicker();
  late File _pickedfile;
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      setState(() {
        _pickedfile = file;
      });
      _cropImage();
    }
  }

  Future<void> _cropImage() async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: _pickedfile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPresetCustom(),
          ],
        ),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPresetCustom(),
          ],
        ),
        WebUiSettings(
          context: context,
          presentStyle: WebPresentStyle.dialog,
          size: const CropperSize(
            width: 520,
            height: 520,
          ),
        ),
      ],
    );
    if (croppedFile != null) {
      File pick = File(croppedFile.path);
      String? text = await _extractText(pick);
      setState(() {
        extractedText = text!;
      });
      if (extractedText != '') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ScanCamTypeHcOrder(
                      text: extractedText,
                    )));
      }
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "HC Order",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Card(
                color: Colors.blueAccent,
                child: Container(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        child: const Column(
                          children: [
                            Icon(
                              Icons.text_fields,
                              size: 50,
                              color: Colors.white,
                            ),
                            Text(
                              "Type Order",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15),
                            )
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const TextTypeHcOrder()));
                        },
                      ),
                      InkWell(
                        child: const Column(
                          children: [
                            Icon(
                              Icons.camera,
                              size: 50,
                              color: Colors.white,
                            ),
                            Text(
                              "Scan Order",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15),
                            )
                          ],
                        ),
                        onTap: () {
                          _pickImage(ImageSource.camera);
                        },
                      ),
                      InkWell(
                        child: const Column(
                          children: [
                            Icon(
                              Icons.image_outlined,
                              size: 50,
                              color: Colors.white,
                            ),
                            Text(
                              "Gallery Scan",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15),
                            )
                          ],
                        ),
                        onTap: () {
                          _pickImage(ImageSource.gallery);
                        },
                      )
                    ],
                  ),
                ),
              ),
              extractedText.isEmpty
                  ? Card(
                      //color: Colors.black,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 100,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                              width: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(8),
                              child: Image.asset(
                                'assets/images/welcome.jpg',
                                fit: BoxFit.cover,
                                scale: 2.0,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                              width: 10,
                            ),
                            AnimatedTextKit(
                              animatedTexts: [
                                WavyAnimatedText(
                                  'Welcome to my App ❤️',
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue,
                                    fontFamily: 'Times New Roman',
                                  ),
                                ),
                                WavyAnimatedText(
                                  'Design And Developed by @Pardhu .',
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.blueAccent,
                                    fontFamily: 'Times New Roman',
                                  ),
                                ),
                              ],
                              isRepeatingAnimation: true,
                              onTap: () {
                                //debugPrint("Joseph");
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        const Text('Extracted Text:',
                            style: TextStyle(fontSize: 20)),
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
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '4x3 (customize)';
}
