import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:travo_app/app.dart';

late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const TravoApp());
}
