import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? img;
  String txt = "";
  String txt1 = "No image selected";

  // The function that will upload the image as a file
  Future<void> upload(File imageFile) async {
    var stream = http.ByteStream(imageFile.openRead().cast());
    var length = await imageFile.length();

    String base = "https://www.floydlabs.com/serve/spsayak/projects/age-detector";

    var uri = Uri.parse('$base/image');

    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile(
      'file',
      stream,
      length,
      filename: basename(imageFile.path),
    );

    request.files.add(multipartFile);
    var response = await request.send();

    if (response.statusCode == 200) {
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
        int l = value.length;
        txt = value.substring(8, l - 3);
        setState(() {});
      });
    } else {
      print('Upload failed with status code: ${response.statusCode}');
    }
  }

  Future<void> lol() async {
    txt1 = "";
    setState(() {});

    // Use the new ImagePicker API
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      img = File(pickedImage.path);
      txt = "Analysing...";
      upload(img!);
    } else {
      txt = "No image selected";
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("AgeDetector"),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              img == null
                  ? Text(
                      txt1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32.0,
                      ),
                    )
                  : Image.file(
                      img!,
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
              Text(
                txt,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32.0,
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: lol,
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}
