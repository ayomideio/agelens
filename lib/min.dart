import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path_provider/path_provider.dart';

// void main() {
//   runApp(AgeDetectorApp());
// }

// class AgeDetectorApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Age Detector',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: AgeDetectorScreen(),
//     );
//   }
// }

class AgeDetectorScreen extends StatefulWidget {
  @override
  _AgeDetectorScreenState createState() => _AgeDetectorScreenState();
}

class _AgeDetectorScreenState extends State<AgeDetectorScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String _ageEstimate = "No face detected";
  bool _isProcessing = false;

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _isProcessing = true;
      });

      // Call the face detection method
      await _detectFace(_image!);
    }
  }

  Future<void> _detectFace(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final faceDetector = GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
      enableClassification: true,  // Enable to detect smile and eye openness
      enableTracking: false,
    ));

    try {
      final List<Face> faces = await faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        setState(() {
          _ageEstimate = "No faces detected";
          _isProcessing = false;
        });
        return;
      }

      // Use custom logic to estimate age
      Face face = faces.first; // For simplicity, taking only the first detected face
      String estimatedAge = _estimateAgeFromFace(face);

      setState(() {
        _ageEstimate = "Estimated Age Range: $estimatedAge";
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _ageEstimate = "Error detecting face: ${e.toString()}";
        _isProcessing = false;
      });
    } finally {
      faceDetector.close(); // Close the face detector after use
    }
  }

  // Custom logic to estimate age
  String _estimateAgeFromFace(Face face) {
    double smileProb = face.smilingProbability ?? 0.0;
    double leftEyeOpenProb = face.leftEyeOpenProbability ?? 0.0;
    double rightEyeOpenProb = face.rightEyeOpenProbability ?? 0.0;

    if (smileProb > 0.6 && leftEyeOpenProb > 0.6 && rightEyeOpenProb > 0.6) {
      return "18-25 (Youthful)";
    } else if (smileProb > 0.4) {
      return "26-35 (Middle-aged)";
    } else if (smileProb < 0.4 && (leftEyeOpenProb < 0.5 || rightEyeOpenProb < 0.5)) {
      return "36-50 (Older)";
    } else {
      return "50+ (Elderly)";
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null
                ? Text('No image selected',
                style: TextStyle(
                  color: Color(0xff737491)
                ),
                )
                : Image.file(
                    _image!,
                    width: 300,
                    height: 300,
                    fit: BoxFit.fill,
                  ),
            SizedBox(height: 20),
            _isProcessing
                ? CircularProgressIndicator()
                : Text(
                    _ageEstimate,
                    style: TextStyle(fontSize: 20,
                     color: Color(0xff737491)
                    ),
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick an Image from Gallery' ,style: TextStyle(
                  color: Color(0xff737491)
                ),),
            ),
          ],
        ),
      
    );
  }
}
