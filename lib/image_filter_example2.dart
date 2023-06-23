import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:photo_editor/filtered_image.dart';
import 'package:photo_editor/filters.dart';

class ImageFilerScreen2 extends StatefulWidget {
  ImageFilerScreen2({super.key, required this.imageFileList});
  List<XFile> imageFileList;
  @override
  State<ImageFilerScreen2> createState() => _ImageFilerScreen2State();
}

class _ImageFilerScreen2State extends State<ImageFilerScreen2> {
  late List<List<double>> selectedImageFilter = [];
  late List<GlobalKey> _containerKey = [];

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < widget.imageFileList.length; i++) {
      selectedImageFilter.add(NoFilter);
      _containerKey.add(GlobalKey());
    }
  }

  void convertWidgetToImage(context) async {
    print("Function Called");
    print(_containerKey);
    for (var i = 0; i < _containerKey.length; i++) {
      print(_containerKey[i].currentContext);
    }
    List<Uint8List> uint8lists = [];
    for (var i = 0; i < widget.imageFileList.length; i++) {
      RenderRepaintBoundary repaintBoundary = await _containerKey[i]
          .currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      ui.Image boxImage = await repaintBoundary.toImage(pixelRatio: 5);
      ByteData? byteData =
          await boxImage.toByteData(format: ui.ImageByteFormat.png);
      uint8lists.add(byteData!.buffer.asUint8List());
      // = byteData!.buffer.asUint8List();
    }

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => FilteredImage(imageData: uint8lists)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit your Image"),
          centerTitle: true,
        ),
        bottomSheet: BottomAppBar(
          elevation: 0.0,
          color: Colors.transparent,
          height: 80.h,
          child: Container(
            width: 1.sw,
            margin: EdgeInsets.symmetric(horizontal: 100, vertical: 0.016.sh),
            child: ElevatedButton(
              onPressed: () {
                print("Button Pressed");
                convertWidgetToImage(context);
              },
              child: Text('Save Your Image'),
            ),
          ),
        ),
        body: PageView.builder(
            itemCount: widget.imageFileList.length,
            itemBuilder: (context, mainIndex) {
              // _containerKey[mainIndex] = GlobalKey();
              print(widget.imageFileList.length);
              print(mainIndex);
              print(_containerKey);
              print(_containerKey[mainIndex]);
              print(_containerKey[mainIndex].currentContext);
              return
                  //  _containerKey[mainIndex].currentContext != null
                  //     ?
                  Container(
                child: Column(
                  children: [
                    Container(
                      height: 1.sw,
                      width: 1.sw,
                      child: RepaintBoundary(
                        key: _containerKey[mainIndex],
                        child: ColorFiltered(
                          colorFilter: ColorFilter.matrix(
                              selectedImageFilter[mainIndex]),
                          child: Image.file(
                            File(widget.imageFileList[mainIndex].path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    0.053.sh.verticalSpace,
                    Container(
                      width: 1.sw,
                      height: 0.2.sh,
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 0.046.sw),
                        scrollDirection: Axis.horizontal,
                        itemCount: filters.length,
                        itemBuilder: (context, index) {
                          // print(filters[index]);
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedImageFilter[mainIndex] = filters[index];
                              });
                            },
                            child: ColorFiltered(
                              colorFilter: ColorFilter.matrix(filters[index]),
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage: FileImage(
                                    File(widget.imageFileList[mainIndex].path)),
                                // child: ColorFiltered(
                                //   colorFilter: ColorFilter.matrix(BlackWhite),

                                //   // child: Image.file(
                                //   //   File(widget.imageFileList![0].path),
                                //   //   fit: BoxFit.cover,
                                //   // ),
                                // ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            0.055.sw.horizontalSpace,
                      ),
                    )
                  ],
                ),
              )
                  // : Container()
                  ;
            }));
  }
}
