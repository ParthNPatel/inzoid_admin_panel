import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:inzoid_admin_panel/controller/edit_brand_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import '../components/category_shimmer.dart';
import '../components/common_widget.dart';
import '../constant/color_const.dart';
import '../constant/text_styel.dart';
import '../controller/edit_category_controller.dart';
import '../controller/handle_screen_controller.dart';
import 'categories_screen.dart';

class BrandsScreen extends StatefulWidget {
  const BrandsScreen({Key? key}) : super(key: key);

  @override
  State<BrandsScreen> createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen> {
  String searchText = '';

  TextEditingController searchController = TextEditingController();

  EditBrandController editBrandController = Get.find();

  HandleScreenController handleScreenController = Get.find();

  double progress = 0.0;

  List<Uint8List> _listOfImage = [];
  List<Uint8List> _brandIcon = [];

  bool isLoading = true;

  TextEditingController? brandTitle;

  HandleScreenController controller = Get.find();

  List<String> statusList1 = ['Active', 'Inactive'];
  int selected = 0;

  String dropDownValue = 'All';

  List items = ['All', 'Active', 'Inactive'];

  @override
  void initState() {
    try {
      brandTitle = TextEditingController(text: editBrandController.brandName);
    } catch (e) {
      brandTitle = TextEditingController();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          searchBar(context),
          SizedBox(
            height: 10.sp,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 20.sp,
                    decoration: BoxDecoration(
                      color: blueColor,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 100,
                            child: Center(
                                child: Text(
                              "Brand Image",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 150,
                            child: Center(
                                child: Text(
                              "Brand Icon",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 150,
                            child: Center(
                                child: Text(
                              "Brand Name",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  brands(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> brands() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Admin')
          .doc('brands')
          .collection('brand_list')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<DocumentSnapshot> brands = snapshot.data!.docs;
          print("length======>${brands.length}");
          if (searchText.isNotEmpty) {
            brands = brands.where((element) {
              return element
                  .get('brand_name')
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase());
            }).toList();
          }
          return ListView.builder(
            //reverse: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            itemCount: brands.length,
            shrinkWrap: true,
            itemBuilder: (context, index) => Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 100,
                  width: 100,
                  margin: EdgeInsets.only(right: 20, bottom: 20),
                  decoration: BoxDecoration(
                    color: CommonColor.greyColorF2F2F2,
                    image: DecorationImage(
                      image: NetworkImage(brands[index]['brand_image'][0]),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 50,
                  width: 150,
                  margin: EdgeInsets.only(right: 20, bottom: 20),
                  decoration: BoxDecoration(
                    color: CommonColor.greyColorF2F2F2,
                    image: DecorationImage(
                      image: NetworkImage(brands[index]['brand_icon'][0]),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 50.sp,
                  child: CommonText.textBoldWight700(
                      text: brands[index]['brand_name'], fontSize: 15),
                ),
                SizedBox(
                  width: 10,
                ),
                GetBuilder<HandleScreenController>(
                  builder: (controller) => InkWell(
                    onTap: () {
                      //controller.changeTapped3(true);
                      editBrandController.addBrandData(
                        docId: brands[index].id,
                        brandName: brands[index]['brand_name'],
                        brandImage: brands[index]['brand_image'],
                        brandIcon: brands[index]['brand_icon'],
                      );
                      Get.dialog(
                        StatefulBuilder(
                          builder: (context, setState) => Dialog(
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: 13.sp, right: 13.sp),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonWidget.commonSizedBox(height: 20),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Center(
                                        child: CommonText.textBoldWight700(
                                            text: 'Edit Brand', fontSize: 8.sp),
                                      ),
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        icon: Icon(Icons.close),
                                      ),
                                    ],
                                  ),
                                  CommonWidget.commonSizedBox(height: 20),
                                  CommonText.textBoldWight500(
                                      text: 'Edit Brand Image', fontSize: 7.sp),
                                  CommonWidget.commonSizedBox(height: 10),
                                  GetBuilder<EditCategoryController>(
                                    builder: (controller) => InkWell(
                                      onTap: () async {
                                        FilePickerResult? selectedImages =
                                            await FilePicker.platform.pickFiles(
                                          type: FileType.custom,
                                          allowedExtensions: [
                                            'jpg',
                                            'png',
                                            'webp',
                                            'jpeg'
                                          ],
                                        );

                                        if (selectedImages != null) {
                                          selectedImages.files
                                              .forEach((element) {
                                            editBrandController.brandImage![0] =
                                                element.bytes;
                                          });

                                          //Uint8List? file = selectedImages!.files.first.bytes;

                                          print(
                                              'selectedImages  image of  ${selectedImages}');
                                          //print("Image List Length:${_listOfImage.length}");
                                          setState(() {});
                                        }
                                      },
                                      child: Container(
                                        height: 100,
                                        width: 200,
                                        child: editBrandController
                                                    .brandImage!.length !=
                                                0
                                            ? editBrandController.brandImage![0]
                                                        .runtimeType ==
                                                    Uint8List
                                                ? Image.memory(
                                                    editBrandController
                                                            .brandImage![0]
                                                        as Uint8List,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.network(
                                                    '${editBrandController.brandImage![0].toString()}',
                                                    fit: BoxFit.cover)
                                            : Icon(Icons.add),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                  CommonWidget.commonSizedBox(height: 20),
                                  CommonText.textBoldWight500(
                                      text: 'Edit Brand Icon', fontSize: 7.sp),
                                  CommonWidget.commonSizedBox(height: 10),
                                  GetBuilder<EditCategoryController>(
                                    builder: (controller) => InkWell(
                                      onTap: () async {
                                        FilePickerResult? selectedImages =
                                            await FilePicker.platform.pickFiles(
                                          type: FileType.custom,
                                          allowedExtensions: [
                                            'jpg',
                                            'png',
                                            'webp',
                                            'jpeg'
                                          ],
                                        );

                                        if (selectedImages != null) {
                                          selectedImages.files
                                              .forEach((element) {
                                            editBrandController.brandIcon![0] =
                                                element.bytes;
                                          });

                                          //Uint8List? file = selectedImages!.files.first.bytes;

                                          print(
                                              'selectedImages  image of  ${selectedImages}');
                                          //print("Image List Length:${_listOfImage.length}");
                                          setState(() {});
                                        }
                                      },
                                      child: Container(
                                        height: 100,
                                        width: 200,
                                        child: editBrandController
                                                    .brandIcon!.length !=
                                                0
                                            ? editBrandController.brandIcon![0]
                                                        .runtimeType ==
                                                    Uint8List
                                                ? Image.memory(
                                                    editBrandController
                                                            .brandIcon![0]
                                                        as Uint8List,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.network(
                                                    '${editBrandController.brandIcon![0].toString()}',
                                                    fit: BoxFit.cover)
                                            : Icon(Icons.add),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                  CommonWidget.commonSizedBox(height: 35),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CommonText.textBoldWight500(
                                          text: 'Brand Name', fontSize: 7.sp),
                                      CommonWidget.commonSizedBox(height: 10),
                                      SizedBox(
                                        width: 30.w,
                                        child: CommonWidget.textFormField(
                                            controller: brandTitle!),
                                      ),
                                    ],
                                  ),
                                  CommonWidget.commonSizedBox(height: 50),
                                  SizedBox(
                                    width: 50.sp,
                                    child: isLoading
                                        ? MaterialButton(
                                            onPressed: () async {
                                              if (brandTitle!.text.isNotEmpty) {
                                                isLoading = false;
                                                setState(() {});

                                                // var getAllURL = await uploadFiles(
                                                //     editCategoryController.categoryImage!);
                                                // print('url of image $getAllURL');

                                                List uploadImage = [];
                                                List uploadImage1 = [];
                                                List existImage = [];
                                                List existIcon = [];

                                                try {
                                                  editBrandController
                                                      .brandImage!
                                                      .forEach((element) {
                                                    if (element.runtimeType ==
                                                        Uint8List) {
                                                      uploadImage.add(element);
                                                    } else {
                                                      existImage.add(element);
                                                    }
                                                  });
                                                } catch (e) {}

                                                try {
                                                  editBrandController.brandIcon!
                                                      .forEach((element) {
                                                    if (element.runtimeType ==
                                                        Uint8List) {
                                                      uploadImage1.add(element);
                                                    } else {
                                                      existIcon.add(element);
                                                    }
                                                  });
                                                } catch (e) {}
                                                print(
                                                    'image length for up  ${uploadImage.length}  ${existImage.length}');
                                                if (uploadImage.length != 0) {
                                                  var getAllURL =
                                                      await uploadFiles(
                                                          uploadImage);
                                                  getAllURL.forEach((element) {
                                                    existImage.add(element);
                                                  });
                                                  print(
                                                      'url of image ${existImage}');
                                                }
                                                if (uploadImage1.length != 0) {
                                                  var getAllURL1 =
                                                      await uploadFiles(
                                                          uploadImage);
                                                  getAllURL1.forEach((element) {
                                                    existIcon.add(element);
                                                  });
                                                  print(
                                                      'url of image ${existImage}');
                                                }

                                                await FirebaseFirestore.instance
                                                    .collection('Admin')
                                                    .doc('brands')
                                                    .collection('brand_list')
                                                    .doc(editBrandController
                                                        .docId)
                                                    .update({
                                                  'brand_name':
                                                      brandTitle!.text,
                                                  'brand_image': existImage,
                                                  'brand_icon': existIcon,
                                                });

                                                _listOfImage.clear();

                                                isLoading = true;
                                                setState(() {});

                                                //Get.back();
                                                //Navigator.pop(context);
                                                controller.changeTapped3(false);
                                                Get.back();
                                                CommonWidget.getSnackBar(
                                                    color: themColors309D9D,
                                                    duration: 2,
                                                    title: 'Successful!',
                                                    message:
                                                        'Your Brand Edited Successfully');
                                              } else {
                                                isLoading = false;
                                                CommonWidget.getSnackBar(
                                                    duration: 2,
                                                    title: 'Required',
                                                    message:
                                                        'Please Enter All Valid Details');
                                              }
                                            },
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            color: themColors309D9D,
                                            height: 20.sp,
                                            child: Padding(
                                              padding: const EdgeInsets.all(2),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CommonText.textBoldWight500(
                                                        text: "Update",
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
                          ),
                        ),
                      );
                      //Get.to(() => EditCategoryScreen());
                    },
                    child: Container(
                      height: 10.sp,
                      width: 10.sp,
                      decoration: BoxDecoration(
                        border: Border.all(color: themColors309D9D, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 20,
                        color: CommonColor.greyColor838589,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    Get.dialog(AlertDialog(
                      title: Text(
                          "Are you sure that you want to delete this brand?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text('NO'),
                        ),
                        TextButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('Admin')
                                .doc('brands')
                                .collection('brand_list')
                                .doc(brands[index].id)
                                .delete();
                            Get.back();
                          },
                          child: Text('YES'),
                        ),
                      ],
                    ));
                  },
                  child: Container(
                    height: 10.sp,
                    width: 10.sp,
                    decoration: BoxDecoration(
                      border: Border.all(color: themColors309D9D, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(
                      Icons.delete,
                      size: 20,
                      color: CommonColor.greyColor838589,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    Get.dialog(
                      StatefulBuilder(
                        builder: (context, setState) => Dialog(
                          child: Padding(
                            padding: EdgeInsets.only(left: 13.sp, right: 13.sp),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonWidget.commonSizedBox(height: 20),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Center(
                                      child: CommonText.textBoldWight700(
                                          text: 'Add Brand', fontSize: 8.sp),
                                    ),
                                    SizedBox(
                                      width: 20.w,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      icon: Icon(Icons.close),
                                    ),
                                  ],
                                ),
                                CommonWidget.commonSizedBox(height: 20),
                                CommonText.textBoldWight500(
                                    text: 'Upload Brand Image', fontSize: 7.sp),
                                CommonWidget.commonSizedBox(height: 10),
                                InkWell(
                                  onTap: () async {
                                    FilePickerResult? selectedImages =
                                        await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: [
                                        'jpg',
                                        'png',
                                        'webp',
                                        'jpeg'
                                      ],
                                    );

                                    if (selectedImages != null) {
                                      selectedImages.files.forEach((element) {
                                        _listOfImage.add(element.bytes!);
                                      });
                                      //Uint8List? file = selectedImages!.files.first.bytes;

                                      print(
                                          'selectedImages  image of  ${selectedImages}');
                                      //print("Image List Length:${_listOfImage.length}");
                                      setState(() {});
                                    }
                                  },
                                  child: Container(
                                    height: 100,
                                    width: 200,
                                    child: _listOfImage.length != 0
                                        ? Image.memory(
                                            _listOfImage[0],
                                            fit: BoxFit.cover,
                                          )
                                        : Icon(Icons.add),
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black)),
                                  ),
                                ),
                                CommonWidget.commonSizedBox(height: 20),
                                CommonText.textBoldWight500(
                                    text: 'Upload Brand Icon', fontSize: 7.sp),
                                CommonWidget.commonSizedBox(height: 10),
                                InkWell(
                                  onTap: () async {
                                    FilePickerResult? selectedImages =
                                        await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: [
                                        'jpg',
                                        'png',
                                        'webp',
                                        'jpeg'
                                      ],
                                    );

                                    if (selectedImages != null) {
                                      selectedImages.files.forEach((element) {
                                        _brandIcon.add(element.bytes!);
                                      });
                                      //Uint8List? file = selectedImages!.files.first.bytes;

                                      print(
                                          'selectedImages  image of  ${selectedImages}');
                                      //print("Image List Length:${_listOfImage.length}");
                                      setState(() {});
                                    }
                                  },
                                  child: Container(
                                    height: 100,
                                    width: 200,
                                    child: _brandIcon.length != 0
                                        ? Image.memory(
                                            _brandIcon[0],
                                            fit: BoxFit.cover,
                                          )
                                        : Icon(Icons.add),
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black)),
                                  ),
                                ),
                                CommonWidget.commonSizedBox(height: 35),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonText.textBoldWight500(
                                        text: 'Brand Name', fontSize: 7.sp),
                                    CommonWidget.commonSizedBox(height: 10),
                                    CommonWidget.textFormField(
                                        controller: brandTitle!),
                                  ],
                                ),
                                CommonWidget.commonSizedBox(height: 50),
                                SizedBox(
                                  width: 50.sp,
                                  child: isLoading
                                      ? MaterialButton(
                                          onPressed: () async {
                                            if (_listOfImage.length != 0 &&
                                                brandTitle!.text.isNotEmpty) {
                                              isLoading = false;
                                              setState(() {});

                                              var getAllURL = await uploadFiles(
                                                  _listOfImage);
                                              var getAllURLForIcon =
                                                  await uploadFiles(_brandIcon);

                                              print(
                                                  'url of image $getAllURL====$getAllURLForIcon}');

                                              await FirebaseFirestore.instance
                                                  .collection('Admin')
                                                  .doc('brands')
                                                  .collection('brand_list')
                                                  .add({
                                                'brand_name': brandTitle!.text,
                                                'brand_image': getAllURL,
                                                'brand_icon': getAllURLForIcon,
                                              });

                                              brandTitle!.clear();
                                              _listOfImage.clear();
                                              _brandIcon.clear();

                                              isLoading = true;
                                              setState(() {});

                                              //Get.back();
                                              //Navigator.pop(context);
                                              controller.changeTapped2(false);
                                              Get.back();

                                              CommonWidget.getSnackBar(
                                                  color: themColors309D9D,
                                                  duration: 2,
                                                  title: 'Successful!',
                                                  message:
                                                      'Your Brand Added Successfully');
                                            } else {
                                              CommonWidget.getSnackBar(
                                                  duration: 2,
                                                  title: 'Required',
                                                  message:
                                                      'Please Enter All Valid Details');
                                            }
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          color: themColors309D9D,
                                          height: 20.sp,
                                          child: Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CommonText.textBoldWight500(
                                                      text: "Add Brand",
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
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 10.sp,
                    width: 10.sp,
                    decoration: BoxDecoration(
                      border: Border.all(color: themColors309D9D, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 20,
                      color: CommonColor.greyColor838589,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                AnimatedToggle(
                  values: statusList1,
                  buttonColor: CommonColor.themColor309D9D,
                  backgroundColor: CommonColor.greyColorD9D9D9,
                  textColor: const Color(0xFFFFFFFF),
                  onToggleCallback: (value) {
                    setState(() {
                      selected = value;
                    });
                  },
                )
              ],
            ),
          );
        } else {
          return CategoryShimmer();
        }
      },
    );
  }

  Container searchBar(BuildContext context) {
    return Container(
      height: 20.sp,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child: Row(
        children: [
          SizedBox(
            width: 6.sp,
          ),
          SizedBox(
            height: 20.sp,
            width: 200.sp,
            child: Center(
              child: TextFormField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                cursorHeight: 8.sp,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          Spacer(),
          Container(
            height: 14.sp,
            width: 40.sp,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey),
            ),
            child: Center(
              child: DropdownButton(
                underline: SizedBox(),
                hint: Text("All"),
                disabledHint: Text("All"),
                value: dropDownValue,
                items: items.map((e) {
                  return DropdownMenuItem<String>(
                    child: Text(e),
                    value: e,
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    dropDownValue = value!;
                  });
                },
              ),
            ),
          ),
          SizedBox(
            width: 6.sp,
          ),
        ],
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
