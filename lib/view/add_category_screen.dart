import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../components/common_widget.dart';
import '../constant/color_const.dart';
import '../constant/text_styel.dart';
import '../controller/handle_screen_controller.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({Key? key}) : super(key: key);

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  double progress = 0.0;

  List<Uint8List> _listOfImage = [];
  bool isLoading = true;

  final categoryTitle = TextEditingController();

  HandleScreenController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 8,
      child: Padding(
        padding: EdgeInsets.only(left: 13.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonWidget.commonSizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GetBuilder<HandleScreenController>(
                  builder: (controller) => IconButton(
                    onPressed: () {
                      controller.changeTapped2(false);
                    },
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                ),
                Spacer(),
                Center(
                  child: CommonText.textBoldWight700(
                      text: 'Add New Category', fontSize: 10.sp),
                ),
                Spacer(),
              ],
            ),
            CommonWidget.commonSizedBox(height: 20),
            CommonText.textBoldWight500(
                text: 'Upload Category Icon', fontSize: 7.sp),
            CommonWidget.commonSizedBox(height: 10),
            InkWell(
              onTap: () async {
                FilePickerResult? selectedImages =
                    await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['jpg', 'png', 'webp', 'jpeg'],
                );

                if (selectedImages != null) {
                  selectedImages.files.forEach((element) {
                    _listOfImage.add(element.bytes!);
                  });
                  //Uint8List? file = selectedImages!.files.first.bytes;

                  print('selectedImages  image of  ${selectedImages}');
                  //print("Image List Length:${_listOfImage.length}");
                  setState(() {});
                }
              },
              child: Container(
                height: 200,
                width: 200,
                child: _listOfImage.length != 0
                    ? Image.memory(
                        _listOfImage[0],
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.add),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
              ),
            ),
            CommonWidget.commonSizedBox(height: 35),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText.textBoldWight500(
                    text: 'Category Name', fontSize: 7.sp),
                CommonWidget.commonSizedBox(height: 10),
                CommonWidget.textFormField(controller: categoryTitle),
              ],
            ),
            CommonWidget.commonSizedBox(height: 50),
            SizedBox(
              width: 50.sp,
              child: isLoading
                  ? MaterialButton(
                      onPressed: () async {
                        if (_listOfImage.length != 0 &&
                            categoryTitle.text.isNotEmpty) {
                          isLoading = false;
                          setState(() {});

                          var getAllURL = await uploadFiles(_listOfImage);
                          print('url of image $getAllURL');

                          await FirebaseFirestore.instance
                              .collection('Admin')
                              .doc('categories')
                              .collection('categories_list')
                              .add({
                            'category_name': categoryTitle.text,
                            'category_image': getAllURL,
                          });

                          categoryTitle.clear();
                          _listOfImage.clear();

                          _listOfImage.clear();
                          isLoading = true;
                          setState(() {});

                          //Get.back();
                          //Navigator.pop(context);
                          controller.changeTapped2(false);

                          CommonWidget.getSnackBar(
                              color: themColors309D9D,
                              duration: 2,
                              title: 'Successful!',
                              message: 'Your Category Added Successfully');
                        } else {
                          CommonWidget.getSnackBar(
                              duration: 2,
                              title: 'Required',
                              message: 'Please Enter All Valid Details');
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      color: themColors309D9D,
                      height: 20.sp,
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CommonText.textBoldWight500(
                                  text: "Add Category",
                                  color: Colors.white,
                                  fontSize: 5.sp)
                            ]),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                      color: themColors309D9D,
                    )),
            ),
            CommonWidget.commonSizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Future<List<String>> uploadFiles(List _images) async {
    var imageUrls =
        await Future.wait(_images.map((_image) => uploadFile(_image)));
    print('all url  ${imageUrls}');
    return imageUrls;
  }

  Future<String> uploadFile(Uint8List _image) async {
    String finalImage = '';

    String getUrl = "files/${DateTime.now()}";
    var task = FirebaseStorage.instance.ref().child(getUrl);

    await task
        .putData(_image, SettableMetadata(contentType: 'image/jpeg'))
        .then((p0) async {
      finalImage = await p0.storage.ref(getUrl).getDownloadURL();
    });
    return finalImage;
  }
}
