import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'jobwidgets.dart';

/// Opens the device camera to capture a photo of the VIN plate.
/// NOTE: requires the `image_picker` package — see the bottom of this file
/// for the one line to add to pubspec.yaml, plus camera permissions.
class ScanVinScreen extends StatefulWidget {
  const ScanVinScreen({super.key});

  @override
  State<ScanVinScreen> createState() => _ScanVinScreenState();
}

class _ScanVinScreenState extends State<ScanVinScreen> {
  File? _capturedImage;
  final _vinCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _openCamera() async {
    try {
      final picker = ImagePicker();
      final shot = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
      if (shot == null) return;
      setState(() {
        _capturedImage = File(shot.path);
        _loading = true;
      });
      // Simulated OCR read of the plate. Swap this for a real VIN-OCR
      // service/ML Kit call when one is wired up.
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      setState(() {
        _loading = false;
        _vinCtrl.text =
        "5YJ3E1EA${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Camera unavailable: $e")));
    }
  }

  @override
  void dispose() {
    _vinCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: inkBlue),
        title: const Text("Scan VIN", style: TextStyle(color: inkBlue, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Container(
              height: 260,
              width: double.infinity,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(20)),
              child: _capturedImage == null
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.camera_alt_outlined, color: Colors.white70, size: 46),
                  SizedBox(height: 10),
                  Text(
                    "Tap below to open the camera\nand scan the VIN plate",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 12.5),
                  ),
                ],
              )
                  : Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(_capturedImage!, fit: BoxFit.cover),
                  if (_loading)
                    Container(
                      color: Colors.black54,
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(color: Colors.white),
                            SizedBox(height: 10),
                            Text("Reading VIN...", style: TextStyle(color: Colors.white, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Container(
              decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [inkBlue, accentBlue]),
                  borderRadius: BorderRadius.circular(14)),
              child: TextButton.icon(
                onPressed: _openCamera,
                icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
                label: Text(_capturedImage == null ? "Open Camera" : "Retake Photo",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _vinCtrl,
              decoration: InputDecoration(
                labelText: "VIN Number",
                prefixIcon: const Icon(Icons.numbers, color: accentBlue),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _vinCtrl.text.trim().isEmpty
                    ? null
                    : () => Navigator.pop(context, _vinCtrl.text.trim()),
                icon: const Icon(Icons.check),
                label: const Text("Use This VIN"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: inkBlue,
                  side: const BorderSide(color: inkBlue),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------
// pubspec.yaml — add under dependencies:
//   image_picker: ^1.1.2
//
// Android (android/app/src/main/AndroidManifest.xml) — add:
//   <uses-permission android:name="android.permission.CAMERA" />
//
// iOS (ios/Runner/Info.plist) — add:
//   <key>NSCameraUsageDescription</key>
//   <string>Used to scan the vehicle VIN plate</string>
// ---------------------------------------------------------------------