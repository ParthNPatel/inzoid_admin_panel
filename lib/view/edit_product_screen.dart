import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inzoid_admin_panel/components/common_widget.dart';
import 'package:inzoid_admin_panel/constant/text_styel.dart';
import 'package:inzoid_admin_panel/controller/edit_product_controller.dart';
import 'package:sizer/sizer.dart';
import '../constant/color_const.dart';
import '../constant/text_const.dart';
import '../controller/handle_screen_controller.dart';
import '../model/req_model/add_product_req_model.dart';
import 'package:get/get.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  double progress = 0.0;

  String category = "Deal";
  String subCategory = "Shirts";

  String season = "Summer";
  String material = "Cotton";

  List color = [];

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
    'Linen'
  ];

  List<String> colorList = [
    'Grey',
    'Black',
    'White',
    'Red',
    'Yellow',
    'Blue',
    'Pink',
    'Purple',
    'Brown',
    'Orange',
  ];

  List<String> colorListData = [
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

  EditProductController editProductController = Get.find();

  TextEditingController? productName;
  TextEditingController? brand;
  TextEditingController? price;
  TextEditingController? oldPrice;
  TextEditingController? description;
  TextEditingController? quantity;

  AddProductReqModel _addProductReqModel = AddProductReqModel();
  bool isLoading = true;

  HandleScreenController handleScreenController = Get.find();

  @override
  void initState() {
    productName =
        TextEditingController(text: editProductController.productName);
    brand = TextEditingController(text: editProductController.brand);
    price = TextEditingController(text: editProductController.price);
    oldPrice = TextEditingController(text: editProductController.oldPrice);
    description =
        TextEditingController(text: editProductController.description);
    quantity = TextEditingController(text: editProductController.quantity);

    category = editProductController.category!;
    subCategory = editProductController.subCategory!;

    season = editProductController.season!;
    material = editProductController.material!;

    color = editProductController.color!;

    print('----COLOR-----${color}');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 6,
      child: Padding(
        padding: EdgeInsets.all(6.sp),
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
                        controller.changeTapped1(false);
                      },
                      icon: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  Spacer(),
                  Center(
                    child: CommonText.textBoldWight700(
                        text: 'Edit Product', fontSize: 10.sp),
                  ),
                  Spacer(),
                ],
              ),
              CommonWidget.commonSizedBox(height: 20),
              GetBuilder<EditProductController>(
                builder: (controller) => Row(
                  children: [
                    editProductController.listOfImage!.length != 0
                        ? Row(
                            children: List.generate(
                              editProductController.listOfImage!.length,
                              (index) => Container(
                                height: 200,
                                width: 200,
                                child: editProductController
                                            .listOfImage![index].runtimeType ==
                                        Uint8List
                                    ? Image.memory(
                                        editProductController
                                            .listOfImage![index] as Uint8List,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        '${editProductController.listOfImage![index].toString()}',
                                        fit: BoxFit.cover),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
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
                            editProductController.listOfImage!
                                .add(element.bytes!);
                          });

                          print(
                              'selectedImages  image of  ${selectedImages.files.first.bytes.runtimeType}');
                        }
                        print(
                            "Image List Length:${editProductController.listOfImage!.length}");
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
                      CommonWidget.textFormField(controller: productName!),
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
                      CommonWidget.textFormField(controller: brand!),
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
                        controller: price!,
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
                        controller: oldPrice!,
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                            contentPadding:
                                EdgeInsets.only(top: 7.sp, left: 6.sp),
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
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     //CommonWidget.commonSizedBox(height: 18),
                  //     CommonText.textBoldWight500(
                  //         text: 'Select Color', fontSize: 7.sp),
                  //     CommonWidget.commonSizedBox(height: 10),
                  //     Container(
                  //       height: 14.sp,
                  //       width: 50.sp,
                  //       decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           borderRadius: BorderRadius.circular(3),
                  //           border: Border.all(color: Colors.grey)),
                  //       child: Center(
                  //         child: DropdownButton(
                  //           underline: SizedBox(),
                  //           value: color,
                  //           items: colorList.map((e) {
                  //             return DropdownMenuItem(
                  //               child: Text(e),
                  //               value: e,
                  //             );
                  //           }).toList(),
                  //           onChanged: (value) {
                  //             setState(() {
                  //               color = value!;
                  //             });
                  //           },
                  //         ),
                  //       ),
                  //     ),
                  //     CommonWidget.commonSizedBox(height: 30),
                  //   ],
                  // )
                ],
              ),
              CommonWidget.commonSizedBox(height: 20),
              CommonText.textBoldWight500(text: 'Colors', fontSize: 7.sp),
              CommonWidget.commonSizedBox(height: 10),
              Row(
                children: List.generate(
                  color.length,
                  (index) => Container(
                    padding: EdgeInsets.all(4),
                    margin: EdgeInsets.only(right: 10),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Color(
                        int.parse(
                          color[index],
                        ),
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ),
              CommonWidget.commonSizedBox(height: 20),
              CommonText.textBoldWight500(text: 'Quantity', fontSize: 7.sp),
              CommonWidget.commonSizedBox(height: 10),
              SizedBox(
                width: 60.sp,
                child: CommonWidget.textFormField(
                  inpuFormator: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  controller: quantity!,
                ),
              ),
              CommonWidget.commonSizedBox(height: 50),
              SizedBox(
                width: 50.sp,
                child: isLoading
                    ? MaterialButton(
                        onPressed: () async {
                          if (editProductController.listOfImage!.length != 0 &&
                              price!.text.isNotEmpty &&
                              brand!.text.isNotEmpty &&
                              oldPrice!.text.isNotEmpty &&
                              description!.text.isNotEmpty &&
                              productName!.text.isNotEmpty) {
                            isLoading = false;
                            setState(() {});
                            List uploadImage = [];
                            List existImage = [];
                            try {
                              editProductController.listOfImage!
                                  .forEach((element) {
                                if (element.runtimeType == Uint8List) {
                                  uploadImage.add(element);
                                } else {
                                  existImage.add(element);
                                }
                              });
                            } catch (e) {}
                            print(
                                'image length for up  ${uploadImage.length}  ${existImage.length}');
                            if (uploadImage.length != 0) {
                              var getAllURL = await uploadFiles(uploadImage);
                              getAllURL.forEach((element) {
                                existImage.add(element);
                              });
                              print('url of image ${existImage}');
                            }

                            _addProductReqModel.listOfImage = existImage;
                            _addProductReqModel.price = int.parse(price!.text);
                            _addProductReqModel.brand = brand!.text;
                            _addProductReqModel.oldPrice = oldPrice!.text;
                            _addProductReqModel.description = description!.text;
                            _addProductReqModel.category = category;
                            _addProductReqModel.subCategory = subCategory;
                            _addProductReqModel.season = season;
                            _addProductReqModel.material = material;
                            _addProductReqModel.color = colorList;
                            _addProductReqModel.productName = productName!.text;
                            _addProductReqModel.productName = quantity!.text;

                            await FirebaseFirestore.instance
                                .collection('Admin')
                                .doc('all_product')
                                .collection('product_data')
                                .doc(editProductController.docId)
                                .update(_addProductReqModel.toJson());
                            price!.clear();
                            brand!.clear();
                            oldPrice!.clear();
                            description!.clear();
                            productName!.clear();
                            category = "Deal";
                            subCategory = "Shirts";

                            season = "Summer";
                            material = "Cotton";

                            color = [];
                            editProductController.listOfImage!.clear();
                            isLoading = true;
                            setState(() {});
                            handleScreenController.changeTapped1(false);
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
                                    text: "Edit",
                                    color: Colors.white,
                                    fontSize: 5.sp)
                              ]),
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(
                        color: themColors309D9D,
                      )),
              )
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
    });
    return finalImage;
  }
}
