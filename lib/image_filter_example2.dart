import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:card_swiper/card_swiper.dart';
import 'package:photo_editor/filtered_image.dart';
import 'package:photo_editor/filters.dart';

class ImageEditingScreen extends StatefulWidget {
  ImageEditingScreen({super.key, required this.imageFileList});
  List<XFile> imageFileList;
  @override
  State<ImageEditingScreen> createState() => _ImageEditingScreenState();
}

class _ImageEditingScreenState extends State<ImageEditingScreen> {
  late List<FilteredImage> _containerKey = [];
  late int selectedFilterdImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (var i = 0; i < widget.imageFileList.length; i++) {
      _containerKey.add(FilteredImage(
          key: GlobalKey(), file: widget.imageFileList[i], filter: filters[0]));
// _containerKey
    }
    selectedFilterdImage = 0;
  }

  void convertWidgetToImage(context) async {
    print("Function Called");
    print(_containerKey);
    for (var i = 0; i < _containerKey.length; i++) {}
    List<Uint8List> uint8lists = [];
    for (var i = 0; i < widget.imageFileList.length; i++) {
      RenderRepaintBoundary repaintBoundary = await _containerKey[i]
          .key
          .currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      ui.Image boxImage = await repaintBoundary.toImage(pixelRatio: 5);
      ByteData? byteData =
          await boxImage.toByteData(format: ui.ImageByteFormat.png);
      uint8lists.add(byteData!.buffer.asUint8List());
      // = byteData!.buffer.asUint8List();
    }

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => FilteredImageScreen(imageData: uint8lists)));
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
              for (var i = 0; i < _containerKey.length; i++) {
                print(_containerKey[i].key.currentContext);
              }

              convertWidgetToImage(context);
            },
            child: Text('Save Your Image'),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: 1.sw,
            height: 0.15.sh,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        selectedFilterdImage = index;
                        setState(() {});
                      },
                      child: RepaintBoundary(
                          key: _containerKey[index].key,
                          child: ColorFiltered(
                            colorFilter:
                                ColorFilter.matrix(_containerKey[index].filter),
                            child: Image.file(
                              File(_containerKey[index].file.path),
                              fit: BoxFit.cover,
                            ),
                          ))

                      /*    CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            FileImage(File(widget.imageFileList[index].path))),*/

                      );
                },
                separatorBuilder: (context, index) => 0.055.sw.horizontalSpace,
                itemCount: _containerKey.length),
          ),
          Container(
              width: 1.sw,
              height: 1.sw,
              child: ColorFiltered(
                colorFilter: ColorFilter.matrix(
                    _containerKey[selectedFilterdImage].filter),
                child: Image.file(
                  File(_containerKey[selectedFilterdImage].file.path),
                  fit: BoxFit.cover,
                ),
              )),
          Container(
            width: 1.sw,
            height: 0.15.sh,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return ColorFiltered(
                      colorFilter: ColorFilter.matrix(filters[index]),
                      child: InkWell(
                        onTap: () {
                          _containerKey[selectedFilterdImage].filter =
                              filters[index];
                          setState(() {});
                        },
                        child: CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                AssetImage('assets/images/larki.png')

                            /*    FileImage(
                                      File(widget.imageFileList[index].path)
                                      
                                      ),*/
                            ),
                      ));
                },
                separatorBuilder: (context, index) => 0.055.sw.horizontalSpace,
                itemCount: filters.length),
          ),
        ],
      ),
    );
  }
}

class FilteredImage {
  GlobalKey key;
  XFile file;
  List<double> filter;
  FilteredImage({required this.key, required this.file, required this.filter});
}

/*

class ImageFilerScreen2 extends StatefulWidget {
  ImageFilerScreen2({super.key, required this.imageFileList});
  List<XFile> imageFileList;
  @override
  State<ImageFilerScreen2> createState() => _ImageFilerScreen2State();
}

class _ImageFilerScreen2State extends State<ImageFilerScreen2> {
  late RxList selectedImageFilter = [].obs;
  late RxList currentContext = [].obs;
  late List<GlobalKey> _containerKey = [];

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < widget.imageFileList.length; i++) {
      selectedImageFilter.add(NoFilter);
      _containerKey.add(GlobalKey());
      currentContext.add('');
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
                print(currentContext.toString());
                convertWidgetToImage(context);
              },
              child: Text('Save Your Image'),
            ),
          ),
        ),
        body: PageView.builder(
            itemCount: widget.imageFileList.length,
            onPageChanged: (value) {
              print("furqan" + value.toString());
              currentContext[value] = _containerKey[value].currentContext;
              print(
                  "furqan   =============>" + currentContext[value].toString());
            },
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
                        child: Obx(
                          () => ColorFiltered(
                            colorFilter: ColorFilter.matrix(
                                selectedImageFilter[mainIndex]),
                            child: Image.file(
                              File(widget.imageFileList[mainIndex].path),
                              fit: BoxFit.cover,
                            ),
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
                              for (var i = 0; i < _containerKey.length; i++) {
                                print(_containerKey[i].currentContext);
                              }

                              // setState(() {
                              selectedImageFilter[mainIndex] = filters[index];
                              // });
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
*/
