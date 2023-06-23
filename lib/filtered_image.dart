import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FilteredImage extends StatefulWidget {
  final List<Uint8List> imageData;

  const FilteredImage({Key? key, required this.imageData}) : super(key: key);

  @override
  State<FilteredImage> createState() => _FilteredImageState();
}

class _FilteredImageState extends State<FilteredImage> {
  PermissionStatus _storagePermissionStatus = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();
    checkStoragePermission();
  }

  Future<void> checkStoragePermission() async {
    PermissionStatus status = await Permission.storage.status;
    log(_storagePermissionStatus.toString());
    setState(() {
      _storagePermissionStatus = status;
    });
    log(_storagePermissionStatus.toString());
    if (_storagePermissionStatus == PermissionStatus.denied) {
      requestStoragePermission();
    }
  }

  void requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      // Permission granted, you can now access storage.
      setState(() {
        _storagePermissionStatus = status;
      });
    } else {
      // Permission denied.
    }
  }

  Future<void> saveImage(Uint8List imageData) async {
    try {
      final directory = Directory('/storage/emulated/0/Pictures/Photo_Editor');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      final imagePath = '${directory!.path}/my_image(${DateTime.now()}).jpeg';
      final File imageFile = File(imagePath);
      await imageFile.writeAsBytes(imageData);
      // final snackBar = SnackBar(content: Text('Image saved successfully'));
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Get.rawSnackbar(message: 'Image saved successfully');
    } catch (e) {
      print(e);
      Get.rawSnackbar(message: 'Failed to save image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*  bottomSheet: BottomAppBar(
        elevation: 0.0,
        color: Colors.transparent,
        height: 80.h,
        child: Container(
          width: 1.sw,
          margin: EdgeInsets.symmetric(horizontal: 100, vertical: 0.016.sh),
          child: ElevatedButton(
            onPressed: () {
              for (var i = 0; i < widget.imageData.length; i++) {
                saveImage(widget.imageData[i]);
              }
            },
            child: Text('Save to Device'),
          ),
        ),
      ),
   */
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
          width: 1.sw,
          height: 1.6.sw,
          child: PageView.builder(
              itemCount: widget.imageData.length,
              itemBuilder: (context, index) {
                // print(widget.imageData[index]);
                return Container(
                  child: Image.memory(
                    widget.imageData[index],
                    width: 1.sw,
                    height: 1.sh,
                    fit: BoxFit.cover,
                  ),
                );
              }),
        ),
      ),
    );
  }
}

  // 