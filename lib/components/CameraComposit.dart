import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class CameraPhotoCapture extends StatefulWidget {
  final Function(File) onPhotoTaken;
  final String title;
  final String description;

  const CameraPhotoCapture({
    Key? key,
    required this.onPhotoTaken,
    this.title = "Take Photo",
    this.description = "Capture a photo of the robot",
  }) : super(key: key);

  @override
  _CameraPhotoCaptureState createState() => _CameraPhotoCaptureState();
}

class _CameraPhotoCaptureState extends State<CameraPhotoCapture>
    with WidgetsBindingObserver {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _processingPhoto = false;

  @override
  void initState() {
    super.initState();
    // Add observer to detect when app resumes
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Remove observer when widget is disposed
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle changes
    if (state == AppLifecycleState.resumed && _processingPhoto) {
      _processingPhoto = false;
      // Check if we need to retry loading an image
      // This helps in cases where the camera was opened but the app was paused
    }
  }

  // Use a dedicated method to launch the camera using system intent
  Future<void> _launchCamera() async {
    try {
      setState(() {
        _processingPhoto = true;
      });

      // Use image_picker to launch the camera in a separate process
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      // Handle the result when the app is brought back to foreground
      if (!mounted) return;

      setState(() {
        _processingPhoto = false;
      });

      if (photo != null) {
        final File imageFile = File(photo.path);
        setState(() {
          _image = imageFile;
        });
        widget.onPhotoTaken(imageFile);
      }
    } catch (e) {
      setState(() {
        _processingPhoto = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.camera_alt, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                widget.title.toUpperCase(),
                style: GoogleFonts.museoModerno(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.description,
            style: GoogleFonts.museoModerno(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Image Preview or Placeholder
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: _image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _image!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  )
                : Center(
                    child: Icon(
                      Icons.image,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                  ),
          ),

          const SizedBox(height: 16),

          // Camera Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _processingPhoto ? null : _launchCamera,
              icon: _processingPhoto
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ))
                  : const Icon(Icons.camera_alt),
              label: Text(
                _image == null ? "Take Photo" : "Retake Photo",
                style: GoogleFonts.museoModerno(
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.blue.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Optional function to easily use the widget
Widget buildCameraCapture(
  Function(File) onPhotoTaken, {
  String title = "Take Photo",
  String description = "Capture a photo of the robot",
}) {
  return CameraPhotoCapture(
    onPhotoTaken: onPhotoTaken,
    title: title,
    description: description,
  );
}
