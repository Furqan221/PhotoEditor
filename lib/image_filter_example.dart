import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'image_filter_example2.dart';
import 'dart:io';

class ImageFilterScreen extends StatefulWidget {
  ImageFilterScreen({super.key});

  @override
  State<ImageFilterScreen> createState() => _ImageFilterScreenState();
}

class _ImageFilterScreenState extends State<ImageFilterScreen> {
  final ImagePicker imagePicker = ImagePicker();

  List<XFile>? imageFileList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Images"),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomAppBar(
        // color: Colors.red,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: imageFileList!.length > 0
                ? MainAxisAlignment.spaceAround
                : MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  selectImages();
                },
                child: Text('Select Images'),
              ),
              // 50.w.horizontalSpace,
              Visibility(
                visible: imageFileList!.length > 0,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => ImageEditingScreen(
                          imageFileList: imageFileList!,
                        ));
                  },
                  child: Text('Edit Images'),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              children: List.generate(
                  imageFileList!.length,
                  (index) => Container(
                        margin: EdgeInsets.all(10),
                        // color: Colors.red,
                        height: 0.4.sw,
                        width: 0.4.sw,
                        child: Stack(
                          children: [
                            Image.file(
                              height: 0.4.sw,
                              width: 0.4.sw,
                              File(imageFileList![index].path),
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: InkWell(
                                onTap: () {
                                  imageFileList!.remove(imageFileList![index]);
                                  setState(() {});
                                },
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.red,
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
            )

            /*       GridView.builder(
              itemCount: imageFileList!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                crossAxisCount: 3,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color: Colors.red,
                  height: 0.1.sw,
                  width: 0.1.sw,
                  child: Stack(
                    children: [
                      Image.file(
                        File(imageFileList![index].path),
                        fit: BoxFit.cover,
                      ),
                      CircleAvatar(
                        radius: 3,
                      ),
                    ],
                  ),
                );
              }),
   */

            ),
      ),
    );
  }

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    print("Image List Length:" + imageFileList!.length.toString());
    setState(() {});
  }
}
