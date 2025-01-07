import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import '../db_helper.dart';

final Logger logger = Logger('CameraScreenLogger');

/// Camera example home widget.
class CameraScreen extends StatefulWidget {
  final String placeName;

  const CameraScreen({Key? key, required this.placeName}) : super(key: key);

  @override
  State<CameraScreen> createState() {
    return _CameraScreenState();
  }
}

class _CameraScreenState extends State<CameraScreen>
with WidgetsBindingObserver {

  List<CameraDescription> cameras = <CameraDescription>[];
  CameraController? cameraController;
  XFile? imageFile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setupCameraController();
  }

  Future<void> _setupCameraController()async {
    List<CameraDescription> _cameras = await availableCameras();
    if(_cameras.isNotEmpty){
      setState(() {
        cameras=_cameras;
      cameraController = CameraController(
          _cameras.first,ResolutionPreset.high
        );
      });
      try {
      await cameraController?.initialize();
        if (mounted) {
          setState(() {});
        }
      } catch (e) {
      debugPrint('Error initializing camera: $e');
      }
    }else{
      logger.warning('No cameras available');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: Colors.grey,
                  width: 3.0,
                ),
              ),
              child: Center(
                child: _cameraPreviewWidget(),
              ),
            ),
          ),
          _captureControlRowWidget(),
          if (imageFile != null) _thumbnailWidget(),
        ],
      ),
    );
  }

  Widget _cameraPreviewWidget() {
    final CameraController? cameraControllerr = cameraController;

    if (cameraControllerr == null || !cameraControllerr.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return CameraPreview(cameraControllerr);
    }
  }

  Widget _thumbnailWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 100.0,
        child: kIsWeb
            ? Image.network(imageFile!.path)
            : Image.file(File(imageFile!.path)),
      ),
    );
  }

  Widget _captureControlRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.camera_alt),
          color: Colors.blue,
          onPressed: cameraController != null && cameraController!.value.isInitialized
              ? onTakePictureButtonPressed
              : null,
        ),
      ],
    );
  }

  void onTakePictureButtonPressed() async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      try {
        final XFile file = await cameraController!.takePicture();
        setState(() {
          imageFile = file;
        });
        
        await DatabaseHelper().insert('photos', {
          'path': file.path,
          'placeName': widget.placeName,
        });
        logger.info(DatabaseHelper().getAll('photos'));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Picture saved for ${widget.placeName} to ${file.path}')),
        );
      } catch (e) {
        debugPrint('Error taking picture: $e');
      }
    }
  }

}




