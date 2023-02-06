import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inzoid_admin_panel/components/banner_shimmer.dart';
import 'package:sizer/sizer.dart';
import '../components/common_widget.dart';
import '../constant/color_const.dart';
import '../constant/text_const.dart';
import '../constant/text_styel.dart';
import '../controller/edit_category_controller.dart';
import '../controller/handle_screen_controller.dart';
import 'categories_screen.dart';

class BannerScreen extends StatefulWidget {
  const BannerScreen({Key? key}) : super(key: key);

  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  String searchText = '';

  TextEditingController searchController = TextEditingController();

  TextEditingController bannerLinkController = TextEditingController();

  EditCategoryController editCategoryController = Get.find();

  HandleScreenController handleScreenController = Get.find();

  double progress = 0.0;

  List<Uint8List> _listOfImage = [];

  bool isLoading = false;

  bool isActive = false;

  List<String> statusList1 = ['Active', 'Inactive'];

  int selected = 0;

  String category = 'All';

  String category1 = 'Deal';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 20.sp,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.grey.shade200),
            child: Row(
              children: [
                SizedBox(
                  width: 6.sp,
                ),
                // SizedBox(
                //   height: 20.sp,
                //   width: 200.sp,
                //   child: Center(
                //     child: TextFormField(
                //       controller: searchController,
                //       onChanged: (value) {
                //         setState(() {
                //           searchText = value;
                //         });
                //       },
                //       cursorHeight: 8.sp,
                //       decoration: InputDecoration(
                //         border: InputBorder.none,
                //         hintText: "Search",
                //         prefixIcon: Icon(Icons.search),
                //       ),
                //     ),
                //   ),
                // ),

                Text(
                  "Banners",
                  style: TextStyle(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w600,
                      color: CommonColor.themColor309D9D),
                ),
                Spacer(),

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Admin')
                      .doc('categories')
                      .collection('categories_list')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      List<DocumentSnapshot> categories = snapshot.data!.docs;
                      print("length======>${categories.length}");
                      if (searchText.isNotEmpty) {
                        categories = categories.where((element) {
                          return element
                              .get('category_name')
                              .toString()
                              .toLowerCase()
                              .contains(searchText.toLowerCase());
                        }).toList();
                      }
                      return Container(
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
                            value: category,
                            items: snapshot.data!.docs.map((e) {
                              return DropdownMenuItem<String>(
                                child: Text(e['category_name']),
                                value: e['category_name'],
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                category = value!;
                              });
                            },
                          ),
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
                SizedBox(
                  width: 6.sp,
                ),
                GetBuilder<HandleScreenController>(
                  builder: (controller) => CommonWidget.commonButton(
                      onTap: () {
                        Get.dialog(
                          StatefulBuilder(
                            builder: (context, setState) => AlertDialog(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Choose Category"),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('Admin')
                                        .doc('categories')
                                        .collection('categories_list')
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasData) {
                                        List<DocumentSnapshot> categories =
                                            snapshot.data!.docs;
                                        print(
                                            "length======>${categories.length}");
                                        if (searchText.isNotEmpty) {
                                          categories =
                                              categories.where((element) {
                                            return element
                                                .get('category_name')
                                                .toString()
                                                .toLowerCase()
                                                .contains(
                                                    searchText.toLowerCase());
                                          }).toList();
                                        }
                                        return Container(
                                          height: 15.sp,
                                          width: 43.sp,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border:
                                                Border.all(color: Colors.grey),
                                          ),
                                          child: Center(
                                            child: DropdownButton(
                                              underline: SizedBox(),
                                              hint: Text("All"),
                                              disabledHint: Text("All"),
                                              value: category,
                                              items:
                                                  snapshot.data!.docs.map((e) {
                                                return DropdownMenuItem<String>(
                                                  child:
                                                      Text(e['category_name']),
                                                  value: e['category_name'],
                                                );
                                              }).toList(),
                                              onChanged: (String? value) {
                                                setState(() {
                                                  category = value!;
                                                });
                                              },
                                            ),
                                          ),
                                        );
                                      } else {
                                        return SizedBox();
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text("Choose Banner Photo"),
                                  SizedBox(
                                    height: 15,
                                  ),
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
                                      height: 200,
                                      width: 400,
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
                                  SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                    width: 400,
                                    child: TextFormField(
                                      controller: bannerLinkController,
                                      maxLines: 5,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: TextConst.fontFamily,
                                      ),
                                      cursorColor: Colors.black,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                          top: 12.sp,
                                          left: 6.sp,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: "Paste banner link here",
                                        hintStyle: TextStyle(
                                            fontFamily: TextConst.fontFamily,
                                            fontWeight: FontWeight.w500,
                                            color: CommonColor.hinTextColor),
                                        border: InputBorder.none,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: themColors309D9D),
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                isLoading == true
                                    ? CircularProgressIndicator()
                                    : MaterialButton(
                                        onPressed: () async {
                                          if (_listOfImage.length != 0) {
                                            setState(() {
                                              isLoading == true;
                                            });

                                            var getAllURL =
                                                await uploadFiles(_listOfImage);
                                            print('url of image $getAllURL');

                                            await FirebaseFirestore.instance
                                                .collection('Admin')
                                                .doc('banners')
                                                .collection('banner_list')
                                                .add({
                                              'banner_image': getAllURL,
                                              'category': category,
                                              "link": bannerLinkController.text
                                                  .trim(),
                                            });

                                            CommonWidget.getSnackBar(
                                                title: "Added!",
                                                message:
                                                    "Your Banner is added Successfully");

                                            Get.back();
                                            _listOfImage.clear();
                                            bannerLinkController.clear();
                                          } else {
                                            CommonWidget.getSnackBar(
                                                color: CommonColor.red,
                                                colorText: Colors.white,
                                                title: "Failed!",
                                                message:
                                                    "Please select banner photo");
                                          }
                                        },
                                        child: Text(
                                          'Add',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        color: themColors309D9D,
                                      )
                              ],
                            ),
                          ),
                        );
                      },
                      text: "Add New Banner",
                      radius: 40),
                ),
                SizedBox(
                  width: 6.sp,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  header(),
                  banners(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> banners() {
    return StreamBuilder<QuerySnapshot>(
      stream: category == "All"
          ? FirebaseFirestore.instance
              .collection('Admin')
              .doc('banners')
              .collection('banner_list')
              .snapshots()
          : FirebaseFirestore.instance
              .collection('Admin')
              .doc('banners')
              .collection('banner_list')
              .where('category', isEqualTo: category)
              .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<DocumentSnapshot> banners = snapshot.data!.docs;
          print("length======>${banners.length}");
          return ListView.builder(
            //reverse: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            itemCount: banners.length,
            shrinkWrap: true,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                children: [
                  Container(
                    height: 100,
                    width: 200,
                    decoration: BoxDecoration(
                      color: CommonColor.greyColorF2F2F2,
                      image: DecorationImage(
                        image: NetworkImage(banners[index]['banner_image'][0]),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Container(
                    width: 50.sp,
                    child: Center(
                      child: Text(
                        "${banners[index]['category']}",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 5.sp),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 100.sp,
                    child: CommonText.textBoldWight500(
                        text: "${banners[index]['link']}", fontSize: 13),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  InkWell(
                    onTap: () async {
                      await editCategoryController.addCategoryData(
                          docId: banners[index].id,
                          categoryName: banners[index]['link'],
                          categoryImage: banners[index]['banner_image'],
                          data: banners[index]['category']);

                      category1 = editCategoryController.data!;
                      bannerLinkController = TextEditingController(
                          text: editCategoryController.categoryName);

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
                                            text: 'Edit Banner',
                                            fontSize: 8.sp),
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
                                      text: 'Banner Image', fontSize: 6.sp),
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
                                            editCategoryController
                                                    .categoryImage![0] =
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
                                        height: 200,
                                        width: 200,
                                        child: editCategoryController
                                                    .categoryImage!.length !=
                                                0
                                            ? editCategoryController
                                                        .categoryImage![0]
                                                        .runtimeType ==
                                                    Uint8List
                                                ? Image.memory(
                                                    editCategoryController
                                                            .categoryImage![0]
                                                        as Uint8List,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.network(
                                                    '${editCategoryController.categoryImage![0].toString()}',
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
                                          text: 'Choose Category',
                                          fontSize: 6.sp),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('Admin')
                                            .doc('categories')
                                            .collection('categories_list')
                                            .snapshots(),
                                        builder: (context,
                                            AsyncSnapshot<QuerySnapshot>
                                                snapshot) {
                                          if (snapshot.hasData) {
                                            List<DocumentSnapshot> categories =
                                                snapshot.data!.docs;
                                            print(
                                                "length======>${categories.length}");
                                            if (searchText.isNotEmpty) {
                                              categories =
                                                  categories.where((element) {
                                                return element
                                                    .get('category_name')
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains(searchText
                                                        .toLowerCase());
                                              }).toList();
                                            }
                                            return Container(
                                              height: 14.sp,
                                              width: 40.sp,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                    color: Colors.grey),
                                              ),
                                              child: Center(
                                                child: DropdownButton(
                                                  underline: SizedBox(),
                                                  hint: Text("All"),
                                                  disabledHint: Text("All"),
                                                  value: category1,
                                                  items: snapshot.data!.docs
                                                      .map((e) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      child: Text(
                                                          e['category_name']),
                                                      value: e['category_name'],
                                                    );
                                                  }).toList(),
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      category1 = value!;
                                                    });
                                                  },
                                                ),
                                              ),
                                            );
                                          } else {
                                            return SizedBox();
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      CommonText.textBoldWight500(
                                          text: 'Banner Link', fontSize: 6.sp),
                                      CommonWidget.commonSizedBox(height: 10),
                                      SizedBox(
                                        width: 400,
                                        child: TextFormField(
                                          controller: bannerLinkController,
                                          maxLines: 5,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontFamily: TextConst.fontFamily,
                                          ),
                                          cursorColor: Colors.black,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                              top: 12.sp,
                                              left: 6.sp,
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: "Paste banner link here",
                                            hintStyle: TextStyle(
                                                fontFamily:
                                                    TextConst.fontFamily,
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    CommonColor.hinTextColor),
                                            border: InputBorder.none,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: themColors309D9D),
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  CommonWidget.commonSizedBox(height: 50),
                                  SizedBox(
                                    width: 50.sp,
                                    child: isLoading == false
                                        ? MaterialButton(
                                            onPressed: () async {
                                              if (bannerLinkController
                                                  .text.isNotEmpty) {
                                                isLoading = true;
                                                setState(() {});

                                                // var getAllURL = await uploadFiles(
                                                //     editCategoryController.categoryImage!);
                                                // print('url of image $getAllURL');

                                                List uploadImage = [];
                                                List existImage = [];

                                                try {
                                                  editCategoryController
                                                      .categoryImage!
                                                      .forEach((element) {
                                                    if (element.runtimeType ==
                                                        Uint8List) {
                                                      uploadImage.add(element);
                                                    } else {
                                                      existImage.add(element);
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

                                                await FirebaseFirestore.instance
                                                    .collection('Admin')
                                                    .doc('banners')
                                                    .collection('banner_list')
                                                    .doc(editCategoryController
                                                        .docId)
                                                    .update({
                                                  'link': bannerLinkController
                                                      .text
                                                      .trim(),
                                                  'category': category1,
                                                  'banner_image': existImage,
                                                });

                                                _listOfImage.clear();

                                                isLoading = false;
                                                setState(() {});

                                                //Get.back();
                                                //Navigator.pop(context);

                                                Get.back();
                                                CommonWidget.getSnackBar(
                                                    color: themColors309D9D,
                                                    duration: 2,
                                                    title: 'Successful!',
                                                    message:
                                                        'Your Banner Edited Successfully');
                                              } else {
                                                isLoading = false;
                                                CommonWidget.getSnackBar(
                                                    duration: 2,
                                                    title: 'Required',
                                                    message:
                                                        'Please Enter All Valid Details');
                                              }

                                              _listOfImage.clear();
                                              bannerLinkController.clear();
                                            },
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            color: themColors309D9D,
                                            height: 17.sp,
                                            child: CommonText.textBoldWight500(
                                                text: "Update",
                                                color: Colors.white,
                                                fontSize: 5.sp),
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
                        Icons.edit,
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
                      Get.dialog(AlertDialog(
                        title: Text(
                            "Are you sure that you want to delete this banner?"),
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
                                  .doc('banners')
                                  .collection('banner_list')
                                  .doc(banners[index].id)
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
                  ),
                  SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          );
        } else {
          return BannerShimmer();
        }
      },
    );
  }

  Container header() {
    return Container(
      height: 20.sp,
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.grey.shade200),
        ),
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
            SizedBox(
              height: 100,
              width: 200,
              child: Center(
                  child: Text(
                "BANNER IMAGE",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              )),
            ),
            // SizedBox(
            //   width: 10,
            // ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: 50.sp,
              child: Center(
                child: Text(
                  "CATEGORY",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: 100.sp,
              child: Center(
                child: Text(
                  "BANNER LINK",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }

  // Container searchBar(BuildContext context) {
  //   return Container(
  //     height: 20.sp,
  //     width: MediaQuery.of(context).size.width,
  //     decoration: BoxDecoration(color: Colors.grey.shade200),
  //     child: Row(
  //       children: [
  //         SizedBox(
  //           width: 6.sp,
  //         ),
  //         // SizedBox(
  //         //   height: 20.sp,
  //         //   width: 200.sp,
  //         //   child: Center(
  //         //     child: TextFormField(
  //         //       controller: searchController,
  //         //       onChanged: (value) {
  //         //         setState(() {
  //         //           searchText = value;
  //         //         });
  //         //       },
  //         //       cursorHeight: 8.sp,
  //         //       decoration: InputDecoration(
  //         //         border: InputBorder.none,
  //         //         hintText: "Search",
  //         //         prefixIcon: Icon(Icons.search),
  //         //       ),
  //         //     ),
  //         //   ),
  //         // ),
  //
  //         Text(
  //           "Banners",
  //           style: TextStyle(
  //               fontSize: 8.sp,
  //               fontWeight: FontWeight.w600,
  //               color: CommonColor.themColor309D9D),
  //         ),
  //         Spacer(),
  //
  //         StreamBuilder<QuerySnapshot>(
  //           stream: FirebaseFirestore.instance
  //               .collection('Admin')
  //               .doc('categories')
  //               .collection('categories_list')
  //               .snapshots(),
  //           builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //             if (snapshot.hasData) {
  //               List<DocumentSnapshot> categories = snapshot.data!.docs;
  //               print("length======>${categories.length}");
  //               if (searchText.isNotEmpty) {
  //                 categories = categories.where((element) {
  //                   return element
  //                       .get('category_name')
  //                       .toString()
  //                       .toLowerCase()
  //                       .contains(searchText.toLowerCase());
  //                 }).toList();
  //               }
  //               return Container(
  //                 height: 14.sp,
  //                 width: 40.sp,
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(5),
  //                   border: Border.all(color: Colors.grey),
  //                 ),
  //                 child: Center(
  //                   child: DropdownButton(
  //                     underline: SizedBox(),
  //                     hint: Text("All"),
  //                     disabledHint: Text("All"),
  //                     value: category,
  //                     items: snapshot.data!.docs.map((e) {
  //                       return DropdownMenuItem<String>(
  //                         child: Text(e['category_name']),
  //                         value: e['category_name'],
  //                       );
  //                     }).toList(),
  //                     onChanged: (String? value) {
  //                       setState(() {
  //                         category = value!;
  //                       });
  //                     },
  //                   ),
  //                 ),
  //               );
  //             } else {
  //               return SizedBox();
  //             }
  //           },
  //         ),
  //         SizedBox(
  //           width: 6.sp,
  //         ),
  //         GetBuilder<HandleScreenController>(
  //           builder: (controller) => CommonWidget.commonButton(
  //               onTap: () {
  //                 Get.dialog(
  //                   StatefulBuilder(
  //                     builder: (context, setState) => AlertDialog(
  //                       title: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text("Choose Category"),
  //                           SizedBox(
  //                             height: 15,
  //                           ),
  //                           StreamBuilder<QuerySnapshot>(
  //                             stream: FirebaseFirestore.instance
  //                                 .collection('Admin')
  //                                 .doc('categories')
  //                                 .collection('categories_list')
  //                                 .snapshots(),
  //                             builder: (context,
  //                                 AsyncSnapshot<QuerySnapshot> snapshot) {
  //                               if (snapshot.hasData) {
  //                                 List<DocumentSnapshot> categories =
  //                                     snapshot.data!.docs;
  //                                 print("length======>${categories.length}");
  //                                 if (searchText.isNotEmpty) {
  //                                   categories = categories.where((element) {
  //                                     return element
  //                                         .get('category_name')
  //                                         .toString()
  //                                         .toLowerCase()
  //                                         .contains(searchText.toLowerCase());
  //                                   }).toList();
  //                                 }
  //                                 return Container(
  //                                   height: 15.sp,
  //                                   width: 43.sp,
  //                                   decoration: BoxDecoration(
  //                                     color: Colors.white,
  //                                     borderRadius: BorderRadius.circular(5),
  //                                     border: Border.all(color: Colors.grey),
  //                                   ),
  //                                   child: Center(
  //                                     child: DropdownButton(
  //                                       underline: SizedBox(),
  //                                       hint: Text("All"),
  //                                       disabledHint: Text("All"),
  //                                       value: category,
  //                                       items: snapshot.data!.docs.map((e) {
  //                                         return DropdownMenuItem<String>(
  //                                           child: Text(e['category_name']),
  //                                           value: e['category_name'],
  //                                         );
  //                                       }).toList(),
  //                                       onChanged: (String? value) {
  //                                         setState(() {
  //                                           category = value!;
  //                                         });
  //                                       },
  //                                     ),
  //                                   ),
  //                                 );
  //                               } else {
  //                                 return SizedBox();
  //                               }
  //                             },
  //                           ),
  //                           SizedBox(
  //                             height: 20,
  //                           ),
  //                           Text("Choose Banner Photo"),
  //                           SizedBox(
  //                             height: 15,
  //                           ),
  //                           InkWell(
  //                             onTap: () async {
  //                               FilePickerResult? selectedImages =
  //                                   await FilePicker.platform.pickFiles(
  //                                 type: FileType.custom,
  //                                 allowedExtensions: [
  //                                   'jpg',
  //                                   'png',
  //                                   'webp',
  //                                   'jpeg'
  //                                 ],
  //                               );
  //
  //                               if (selectedImages != null) {
  //                                 selectedImages.files.forEach((element) {
  //                                   _listOfImage.add(element.bytes!);
  //                                 });
  //                                 //Uint8List? file = selectedImages!.files.first.bytes;
  //
  //                                 print(
  //                                     'selectedImages  image of  ${selectedImages}');
  //                                 //print("Image List Length:${_listOfImage.length}");
  //                                 setState(() {});
  //                               }
  //                             },
  //                             child: Container(
  //                               height: 200,
  //                               width: 400,
  //                               child: _listOfImage.length != 0
  //                                   ? Image.memory(
  //                                       _listOfImage[0],
  //                                       fit: BoxFit.cover,
  //                                     )
  //                                   : Icon(Icons.add),
  //                               decoration: BoxDecoration(
  //                                   border: Border.all(color: Colors.black)),
  //                             ),
  //                           ),
  //                           SizedBox(
  //                             height: 20,
  //                           ),
  //                           SizedBox(
  //                             width: 400,
  //                             child: TextFormField(
  //                               controller: bannerLinkController,
  //                               maxLines: 5,
  //                               style: TextStyle(
  //                                 fontWeight: FontWeight.w500,
  //                                 fontFamily: TextConst.fontFamily,
  //                               ),
  //                               cursorColor: Colors.black,
  //                               decoration: InputDecoration(
  //                                 contentPadding: EdgeInsets.only(
  //                                   top: 12.sp,
  //                                   left: 6.sp,
  //                                 ),
  //                                 filled: true,
  //                                 fillColor: Colors.white,
  //                                 hintText: "Paste banner link here",
  //                                 hintStyle: TextStyle(
  //                                     fontFamily: TextConst.fontFamily,
  //                                     fontWeight: FontWeight.w500,
  //                                     color: CommonColor.hinTextColor),
  //                                 border: InputBorder.none,
  //                                 enabledBorder: OutlineInputBorder(
  //                                   borderSide: BorderSide(color: Colors.grey),
  //                                   borderRadius: BorderRadius.circular(3),
  //                                 ),
  //                                 focusedBorder: OutlineInputBorder(
  //                                   borderSide:
  //                                       BorderSide(color: themColors309D9D),
  //                                   borderRadius: BorderRadius.circular(3),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           SizedBox(
  //                             height: 25,
  //                           ),
  //                         ],
  //                       ),
  //                       actions: [
  //                         TextButton(
  //                           onPressed: () {
  //                             Get.back();
  //                           },
  //                           child: Text(
  //                             "Cancel",
  //                             style: TextStyle(color: Colors.white),
  //                           ),
  //                         ),
  //                         isLoading == true
  //                             ? CircularProgressIndicator()
  //                             : MaterialButton(
  //                                 onPressed: () async {
  //                                   if (_listOfImage.length != 0) {
  //                                     setState(() {
  //                                       isLoading == true;
  //                                     });
  //
  //                                     var getAllURL =
  //                                         await uploadFiles(_listOfImage);
  //                                     print('url of image $getAllURL');
  //
  //                                     await FirebaseFirestore.instance
  //                                         .collection('Admin')
  //                                         .doc('banners')
  //                                         .collection('banner_list')
  //                                         .add({
  //                                       'banner_image': getAllURL,
  //                                       'category': category,
  //                                       "link":
  //                                           bannerLinkController.text.trim(),
  //                                     });
  //
  //                                     CommonWidget.getSnackBar(
  //                                         title: "Added!",
  //                                         message:
  //                                             "Your Banner is added Successfully");
  //
  //                                     Get.back();
  //                                     _listOfImage.clear();
  //                                     bannerLinkController.clear();
  //                                   } else {
  //                                     CommonWidget.getSnackBar(
  //                                         color: CommonColor.red,
  //                                         colorText: Colors.white,
  //                                         title: "Failed!",
  //                                         message:
  //                                             "Please select banner photo");
  //                                   }
  //                                 },
  //                                 child: Text('Add'),
  //                                 color: themColors309D9D,
  //                               )
  //                       ],
  //                     ),
  //                   ),
  //                 );
  //               },
  //               text: "Add New Banner",
  //               radius: 40),
  //         ),
  //         SizedBox(
  //           width: 6.sp,
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
