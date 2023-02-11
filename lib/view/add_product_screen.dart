import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inzoid_admin_panel/components/common_widget.dart';
import 'package:inzoid_admin_panel/constant/text_styel.dart';
import 'package:sizer/sizer.dart';
import '../constant/color_const.dart';
import '../constant/text_const.dart';
import '../controller/handle_screen_controller.dart';
import '../model/req_model/add_product_req_model.dart';
import 'package:http/http.dart' as http;

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  double progress = 0.0;

  List<Uint8List> _listOfImage = [];

  String category = "Deal";
  String subCategory = "Shirts";

  String season = "Summer";
  String material = "Cotton";

  List selectedColors = [];

  List<String> categoryList = [
    'Deal',
    'Men',
    'Women',
    'Kids',
    'Sport Wear',
  ];

  List<String> subCategoryList = [
    'Shirts',
    'Trousers',
    'Suit',
    'Jeans',
  ];

  List<String> seasonList = ['Summer', 'Winter', 'Monsoon', 'All'];

  List<String> materialList = [
    'Cotton',
    'Crepe',
    'Denim',
    'Lace',
    'Satin',
    'Linen',
  ];

  List<String> colorList = [
    "0xff808080",
    "0xff000000",
    "0xffFFFFFF",
    "0xffFF0000",
    "0xffFFFF00",
    "0xff0000FF",
    "0xffFFC0CB",
    "0xffA020F0",
    "0xff964B00",
    "0xffFFA500",
  ];

  List sizList = [
    'XS',
    'S',
    'M',
    'L',
    'XL',
  ];

  List selectedSizes = [];

  HandleScreenController handleScreenController = Get.find();

  final productName = TextEditingController();
  final brand = TextEditingController();
  final price = TextEditingController();
  final oldPrice = TextEditingController();
  final description = TextEditingController();
  final quantity = TextEditingController();

  AddProductReqModel _addProductReqModel = AddProductReqModel();
  bool isLoading = true;
  int? productId;
  getProductAddCount() async {
    var getOldCount =
        FirebaseFirestore.instance.collection('Admin').doc('product_count');
    var fetchCount = await getOldCount.get();

    print('product_count old ${fetchCount['total_count']}');
    FirebaseFirestore.instance.collection('Admin').doc('product_count').update({
      'total_count': FieldValue.increment(1),
    }).then((value) {
      productId = fetchCount['total_count'] + 1;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  CroppedFile? croppedFiles;

  Future<void> _cropImage({String? filePath, int? index}) async {
    final croppedFile = await ImageCropper().cropImage(
      cropStyle: CropStyle.rectangle,
      sourcePath: filePath!,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        WebUiSettings(
          enableResize: true,
          mouseWheelZoom: true,
          barrierColor: Colors.transparent,
          enableOrientation: true,
          enforceBoundary: true,
          context: context,
          presentStyle: CropperPresentStyle.dialog,
          boundary: const CroppieBoundary(
            width: 400,
            height: 400,
          ),
          enableExif: true,
          enableZoom: true,
          showZoomer: true,
        ),
      ],
    );
    if (croppedFile != null) {
      croppedFiles = croppedFile;
      Uint8List cropFileData = await croppedFiles!.readAsBytes();
      _listOfImage.removeAt(index!);
      _listOfImage.insert(index, cropFileData);
      setState(() {});
      print('------IAMGE PATH----${_listOfImage}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 6,
      child: Padding(
        padding: EdgeInsets.only(top: 6.sp, left: 10.sp),
        child: SingleChildScrollView(
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
                        controller.changeTapped(false);
                      },
                      icon: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  Spacer(),
                  Center(
                    child: CommonText.textBoldWight700(
                        text: 'Add New Product', fontSize: 10.sp),
                  ),
                  Spacer(),
                ],
              ),
              CommonWidget.commonSizedBox(height: 20),
              Row(
                children: [
                  _listOfImage.length != 0
                      ? Row(
                          children: List.generate(
                            _listOfImage.length,
                            (index) => Container(
                              height: 200,
                              width: 200,
                              alignment: Alignment.topRight,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: MemoryImage(_listOfImage[index]),
                                    fit: BoxFit.cover),
                                border: Border.all(
                                  color: Colors.black,
                                ),
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  var magePath =
                                      XFile.fromData(_listOfImage[index]);
                                  print('----IMAGE PATH----${magePath.path}');
                                  _cropImage(
                                      filePath: magePath.path, index: index);
                                },
                                icon: Icon(Icons.edit),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                  InkWell(
                    onTap: () async {
                      FilePickerResult? selectedImages =
                          await FilePicker.platform.pickFiles(
                        allowMultiple: true,
                        type: FileType.custom,
                        allowedExtensions: ['jpg', 'png', 'webp', 'jpeg'],
                      );
                      // final List<XFile>? selectedImages =
                      //     await _picker.pickMultiImage();

                      if (selectedImages != null) {
                        selectedImages.files.forEach((element) {
                          _listOfImage.add(element.bytes!);
                        });

                        // Uint8List? file = selectedImages.files.first.bytes;

                        print('selectedImages  image of  ${selectedImages}');
                      }
                      print("Image List :${_listOfImage}");
                      print("Image List Length:${_listOfImage.length}");
                      setState(() {});
                    },
                    child: Container(
                      height: 200,
                      width: 200,
                      child: Icon(Icons.add),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                    ),
                  ),
                ],
              ),
              CommonWidget.commonSizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText.textBoldWight500(
                          text: 'Product Name', fontSize: 7.sp),
                      CommonWidget.commonSizedBox(height: 10),
                      CommonWidget.textFormField(controller: productName),
                    ],
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //CommonWidget.commonSizedBox(height: 18),
                      CommonText.textBoldWight500(
                          text: 'Select Category', fontSize: 7.sp),
                      CommonWidget.commonSizedBox(height: 10),
                      Container(
                        height: 14.sp,
                        width: 50.sp,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(color: Colors.grey)),
                        child: Center(
                          child: DropdownButton(
                            underline: SizedBox(),
                            value: category,
                            items: categoryList.map((e) {
                              return DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                category = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      CommonWidget.commonSizedBox(height: 30),
                    ],
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //CommonWidget.commonSizedBox(height: 20),
                      CommonText.textBoldWight500(
                          text: 'Brand', fontSize: 7.sp),
                      CommonWidget.commonSizedBox(height: 10),
                      CommonWidget.textFormField(controller: brand),
                      CommonWidget.commonSizedBox(height: 20),
                    ],
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText.textBoldWight500(
                          text: 'Select Sub Category', fontSize: 7.sp),
                      CommonWidget.commonSizedBox(height: 10),
                      Container(
                        height: 14.sp,
                        width: 50.sp,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(color: Colors.grey)),
                        child: Center(
                          child: DropdownButton(
                            underline: SizedBox(),
                            value: subCategory,
                            items: subCategoryList.map((e) {
                              return DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                subCategory = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      CommonWidget.commonSizedBox(height: 30),
                    ],
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText.textBoldWight500(
                          text: 'Price', fontSize: 7.sp),
                      CommonWidget.commonSizedBox(height: 10),
                      CommonWidget.textFormField(
                        controller: price,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText.textBoldWight500(
                          text: 'Select Season', fontSize: 7.sp),
                      CommonWidget.commonSizedBox(height: 10),
                      Container(
                        height: 14.sp,
                        width: 50.sp,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(color: Colors.grey)),
                        child: Center(
                          child: DropdownButton(
                            underline: SizedBox(),
                            value: season,
                            items: seasonList.map((e) {
                              return DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                season = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      CommonWidget.commonSizedBox(height: 20),
                    ],
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonWidget.commonSizedBox(height: 20),
                      CommonText.textBoldWight500(
                          text: 'Old Price', fontSize: 7.sp),
                      CommonWidget.commonSizedBox(height: 10),
                      CommonWidget.textFormField(
                        controller: oldPrice,
                      ),
                      CommonWidget.commonSizedBox(height: 20),
                    ],
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonWidget.commonSizedBox(height: 20),
                      CommonText.textBoldWight500(
                          text: 'Select Material', fontSize: 7.sp),
                      CommonWidget.commonSizedBox(height: 10),
                      Container(
                        height: 14.sp,
                        width: 50.sp,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(color: Colors.grey)),
                        child: Center(
                          child: DropdownButton(
                            underline: SizedBox(),
                            value: material,
                            items: materialList.map((e) {
                              return DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                material = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              CommonText.textBoldWight500(text: 'Quantity', fontSize: 7.sp),
              CommonWidget.commonSizedBox(height: 10),
              SizedBox(
                width: 60.sp,
                child: CommonWidget.textFormField(
                  inpuFormator: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  controller: quantity,
                ),
              ),
              CommonWidget.commonSizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText.textBoldWight500(
                      text: 'Select Sizes', fontSize: 7.sp),
                  CommonWidget.commonSizedBox(height: 10),
                  Row(
                    children: List.generate(
                      sizList.length,
                      (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selectedSizes.contains(sizList[index])) {
                              selectedSizes.remove(sizList[index]);
                            } else {
                              selectedSizes.add(sizList[index]);
                            }
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: selectedSizes.contains(sizList[index])
                                ? themColors309D9D
                                : Color(0xffF2F4F5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              sizList[index],
                              style: TextStyle(
                                color: selectedSizes.contains(sizList[index])
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonWidget.commonSizedBox(height: 30),
                  CommonText.textBoldWight500(
                      text: 'Select Colors', fontSize: 7.sp),
                  CommonWidget.commonSizedBox(height: 10),
                  Row(
                    children: List.generate(
                      colorList.length,
                      (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selectedColors.contains(colorList[index])) {
                              selectedColors.remove(colorList[index]);
                            } else {
                              selectedColors.add(colorList[index]);
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(4),
                          margin: EdgeInsets.only(right: 10),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Color(
                              int.parse(
                                colorList[index],
                              ),
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 2,
                              color: selectedColors.contains(colorList[index])
                                  ? themColors309D9D
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  CommonWidget.commonSizedBox(height: 30),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText.textBoldWight500(
                      text: 'Description', fontSize: 7.sp),
                  CommonWidget.commonSizedBox(height: 10),
                  SizedBox(
                    width: 150.sp,
                    child: TextFormField(
                      controller: description,
                      maxLines: 5,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: TextConst.fontFamily,
                      ),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 7.sp, left: 6.sp),
                        filled: true,
                        fillColor: Colors.white,
                        // hintText: "Write Description here",
                        hintStyle: TextStyle(
                            fontFamily: TextConst.fontFamily,
                            fontWeight: FontWeight.w500,
                            color: CommonColor.hinTextColor),
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: themColors309D9D),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 50,
              ),
              CommonWidget.commonSizedBox(height: 50),
              SizedBox(
                width: 50.sp,
                child: isLoading
                    ? MaterialButton(
                        onPressed: () async {
                          if (_listOfImage.length != 0 &&
                              price.text.isNotEmpty &&
                              brand.text.isNotEmpty &&
                              oldPrice.text.isNotEmpty &&
                              description.text.isNotEmpty &&
                              productName.text.isNotEmpty) {
                            isLoading = false;
                            setState(() {});

                            var getAllURL = await uploadFiles(_listOfImage);
                            print('url of image $getAllURL');
                            var getOldCount = FirebaseFirestore.instance
                                .collection('Admin')
                                .doc('product_count');
                            var fetchCount = await getOldCount.get();

                            print(
                                'product_count old ${fetchCount['total_count']}');
                            await FirebaseFirestore.instance
                                .collection('Admin')
                                .doc('product_count')
                                .update({
                              'total_count': FieldValue.increment(1),
                            });
                            _addProductReqModel.listOfImage = getAllURL;
                            _addProductReqModel.price = price.text;
                            _addProductReqModel.brand = brand.text;
                            _addProductReqModel.oldPrice = oldPrice.text;
                            _addProductReqModel.description = description.text;
                            _addProductReqModel.category = category;
                            _addProductReqModel.subCategory = subCategory;
                            _addProductReqModel.season = season;
                            _addProductReqModel.material = material;
                            _addProductReqModel.color = selectedColors;
                            _addProductReqModel.productName = productName.text;
                            _addProductReqModel.quantity =
                                int.parse(quantity.text);
                            _addProductReqModel.sizes = selectedSizes;
                            _addProductReqModel.productId =
                                '${fetchCount['total_count'] + 1}';

                            await FirebaseFirestore.instance
                                .collection('Admin')
                                .doc('all_product')
                                .collection('product_data')
                                .add(_addProductReqModel.toJson());

                            sendMessageForAlluser(
                                msg: 'New Product Added',
                                data: _addProductReqModel.toJson());

                            price.clear();
                            brand.clear();
                            oldPrice.clear();
                            description.clear();
                            productName.clear();
                            quantity.clear();
                            category = "Deal";
                            subCategory = "Shirts";

                            season = "Summer";
                            material = "Cotton";

                            selectedColors = [];
                            _listOfImage.clear();
                            isLoading = true;
                            setState(() {});

                            handleScreenController.changeTapped(false);
                            CommonWidget.getSnackBar(
                                color: CommonColor.themColor309D9D,
                                duration: 2,
                                title: 'Successfully',
                                message: 'Your product Uploaded');
                          } else {
                            CommonWidget.getSnackBar(
                                title: 'Required',
                                message: 'Please Enter Valid Details');
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        color: CommonColor.themColor309D9D,
                        height: 20.sp,
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CommonText.textBoldWight500(
                                    text: "Add",
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
              CommonWidget.commonSizedBox(height: 50),
            ],
          ),
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
      //   _uploadOfImage.add(await p0.storage.ref(getUrl).getDownloadURL());
    });
    // await task.snapshotEvents.listen((event) async {
    //   double progress = 0.0;
    //
    //   progress =
    //       ((event.bytesTransferred.toDouble() / event.totalBytes.toDouble()) *
    //               100)
    //           .roundToDouble();
    //
    //   if (progress == 100) {
    //     finalImage = await event.ref.getDownloadURL();
    //     log('final url for  ${finalImage}');
    //     _uploadOfImage.add(finalImage);
    //   } else {
    //     finalImage = '';
    //   }
    //
    //   print(progress);
    // });

    return finalImage;
  }

  static Future<bool?> sendMessageForAlluser(
      {String? msg, Map<String, dynamic>? data}) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=${TextConst.serverKey}',
        },
        body: jsonEncode(
          <String, dynamic>{
            'to': '/topics/all',
            "priority": "high",
            'notification': <String, dynamic>{
              'body': msg ?? 'msg',
              'title': 'Inzoid',
              'bodyLocKey': 'true',
              "content_available": true,
            },
            'data': data!
          },
        ),
      );
      // log("RESPONSE CODE ${response.statusCode}");
      //
      // log("RESPONSE BODY ${response.body}");
      // return true}
    } catch (e) {
      print("error push notification");
      // return false;

    }
  }
}
