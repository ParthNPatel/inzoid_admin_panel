import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import '../components/category_shimmer.dart';
import '../components/common_widget.dart';
import '../constant/color_const.dart';
import '../constant/text_styel.dart';
import '../controller/edit_category_controller.dart';
import '../controller/handle_screen_controller.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String searchText = '';

  TextEditingController searchController = TextEditingController();

  EditCategoryController editCategoryController = Get.find();

  HandleScreenController handleScreenController = Get.find();

  double progress = 0.0;

  int selected = 0;

  List<Uint8List> _listOfImage = [];
  bool isLoading = true;

  TextEditingController? categoryTitle;

  HandleScreenController controller = Get.find();

  bool isActive = false;

  List<String> statusList1 = ['Active', 'Inactive'];

  List items = ['All', 'Active', 'Inactive'];

  String dropDownValue = "All";

  @override
  void initState() {
    categoryTitle =
        TextEditingController(text: editCategoryController.categoryName);
    try {} catch (e) {
      categoryTitle = TextEditingController();
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
                          Container(
                            width: 90,
                            child: Center(
                                child: Text(
                              "USER IMAGE",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                          ),
                          // SizedBox(
                          //   width: 10,
                          // ),
                          Container(
                            width: 50.sp,
                            child: Center(
                              child: Text(
                                "CATEGORY",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 50.sp,
                            child: Center(
                                child: Text(
                              "CREATED DATE",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            )),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  categories(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> categories() {
    return StreamBuilder<QuerySnapshot>(
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
          return ListView.builder(
            //reverse: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            itemCount: categories.length,
            shrinkWrap: true,
            itemBuilder: (context, index) => categories[index]
                        ['category_name'] ==
                    'All'
                ? SizedBox()
                : Row(
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
                            image: NetworkImage(
                                categories[index]['category_image'][0]),
                            fit: BoxFit.cover,
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
                            text: categories[index]['category_name'],
                            fontSize: 15),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 50.sp,
                        child: CommonText.textBoldWight700(
                            text: '09/11/22', fontSize: 15),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GetBuilder<HandleScreenController>(
                        builder: (controller) => InkWell(
                          onTap: () {
                            //controller.changeTapped3(true);
                            editCategoryController.addCategoryData(
                              docId: categories[index].id,
                              categoryName: categories[index]['category_name'],
                              categoryImage: categories[index]
                                  ['category_image'],
                            );
                            Get.dialog(
                              StatefulBuilder(
                                builder: (context, setState) => Dialog(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 13.sp, right: 13.sp),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CommonWidget.commonSizedBox(height: 20),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Center(
                                              child:
                                                  CommonText.textBoldWight700(
                                                      text: 'Edit Category',
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
                                            text: 'Edit Category Icon',
                                            fontSize: 7.sp),
                                        CommonWidget.commonSizedBox(height: 10),
                                        GetBuilder<EditCategoryController>(
                                          builder: (controller) => InkWell(
                                            onTap: () async {
                                              FilePickerResult? selectedImages =
                                                  await FilePicker.platform
                                                      .pickFiles(
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
                                                          .categoryImage!
                                                          .length !=
                                                      0
                                                  ? editCategoryController
                                                              .categoryImage![0]
                                                              .runtimeType ==
                                                          Uint8List
                                                      ? Image.memory(
                                                          editCategoryController
                                                                  .categoryImage![
                                                              0] as Uint8List,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.network(
                                                          '${editCategoryController.categoryImage![0].toString()}',
                                                          fit: BoxFit.cover)
                                                  : Icon(Icons.add),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
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
                                                text: 'Category Name',
                                                fontSize: 7.sp),
                                            CommonWidget.commonSizedBox(
                                                height: 10),
                                            SizedBox(
                                              width: 30.w,
                                              child: CommonWidget.textFormField(
                                                  controller: categoryTitle!),
                                            ),
                                          ],
                                        ),
                                        CommonWidget.commonSizedBox(height: 50),
                                        SizedBox(
                                          width: 50.sp,
                                          child: isLoading
                                              ? MaterialButton(
                                                  onPressed: () async {
                                                    if (categoryTitle!
                                                        .text.isNotEmpty) {
                                                      isLoading = false;
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
                                                          if (element
                                                                  .runtimeType ==
                                                              Uint8List) {
                                                            uploadImage
                                                                .add(element);
                                                          } else {
                                                            existImage
                                                                .add(element);
                                                          }
                                                        });
                                                      } catch (e) {}
                                                      print(
                                                          'image length for up  ${uploadImage.length}  ${existImage.length}');
                                                      if (uploadImage.length !=
                                                          0) {
                                                        var getAllURL =
                                                            await uploadFiles(
                                                                uploadImage);
                                                        getAllURL
                                                            .forEach((element) {
                                                          existImage
                                                              .add(element);
                                                        });
                                                        print(
                                                            'url of image ${existImage}');
                                                      }

                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('Admin')
                                                          .doc('categories')
                                                          .collection(
                                                              'categories_list')
                                                          .doc(
                                                              editCategoryController
                                                                  .docId)
                                                          .update({
                                                        'category_name':
                                                            categoryTitle!.text,
                                                        'category_image':
                                                            existImage,
                                                      });

                                                      _listOfImage.clear();

                                                      isLoading = true;
                                                      setState(() {});

                                                      //Get.back();
                                                      //Navigator.pop(context);
                                                      controller
                                                          .changeTapped3(false);
                                                      Get.back();
                                                      CommonWidget.getSnackBar(
                                                          color:
                                                              themColors309D9D,
                                                          duration: 2,
                                                          title: 'Successful!',
                                                          message:
                                                              'Your Category Edited Successfully');
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
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  color: themColors309D9D,
                                                  height: 20.sp,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(2),
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          CommonText
                                                              .textBoldWight500(
                                                                  text:
                                                                      "Update Category",
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      5.sp)
                                                        ]),
                                                  ),
                                                )
                                              : Center(
                                                  child:
                                                      CircularProgressIndicator(
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
                              border:
                                  Border.all(color: themColors309D9D, width: 1),
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
                                "Are you sure that you want to delete this category?"),
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
                                      .doc('categories')
                                      .collection('categories_list')
                                      .doc(categories[index].id)
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
                            border:
                                Border.all(color: themColors309D9D, width: 1),
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
                        onTap: () async {
                          Get.dialog(
                            await addCategory(),
                          );
                        },
                        child: Container(
                          height: 10.sp,
                          width: 10.sp,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: themColors309D9D, width: 1),
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

  Future<StatefulBuilder> addCategory() async {
    return StatefulBuilder(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: CommonText.textBoldWight700(
                        text: 'Add Category', fontSize: 8.sp),
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
                  CommonWidget.textFormField(controller: categoryTitle!),
                ],
              ),
              CommonWidget.commonSizedBox(height: 50),
              SizedBox(
                width: 50.sp,
                child: isLoading
                    ? MaterialButton(
                        onPressed: () async {
                          if (_listOfImage.length != 0 &&
                              categoryTitle!.text.isNotEmpty) {
                            isLoading = false;
                            setState(() {});

                            var getAllURL = await uploadFiles(_listOfImage);
                            print('url of image $getAllURL');

                            await FirebaseFirestore.instance
                                .collection('Admin')
                                .doc('categories')
                                .collection('categories_list')
                                .add({
                              'category_name': categoryTitle!.text,
                              'category_image': getAllURL,
                            });

                            categoryTitle!.clear();
                            _listOfImage.clear();

                            _listOfImage.clear();
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
      ),
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
          GetBuilder<HandleScreenController>(
            builder: (controller) => CommonWidget.commonButton(
                onTap: () async {
                  //controller.changeTapped2(true);
                  //Navigator.pushNamed(context, '/AddProperty');
                  Get.dialog(
                    await addCategory(),
                  );
                },
                text: "Add New Category",
                radius: 40),
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

class AnimatedToggle extends StatefulWidget {
  final List<String> values;
  final ValueChanged onToggleCallback;
  final Color backgroundColor;
  final Color buttonColor;
  final Color textColor;

  AnimatedToggle({
    required this.values,
    required this.onToggleCallback,
    this.backgroundColor = const Color(0xFFe7e7e8),
    this.buttonColor = const Color(0xFFFFFFFF),
    this.textColor = const Color(0xFF000000),
  });
  @override
  _AnimatedToggleState createState() => _AnimatedToggleState();
}

class _AnimatedToggleState extends State<AnimatedToggle> {
  bool initialPosition = true;
  var index = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 148,
      height: 38,
      margin: EdgeInsets.all(20),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              initialPosition = !initialPosition;
              index = 0;
              if (!initialPosition) {
                index = 1;
              }
              widget.onToggleCallback(index);
              setState(() {});
            },
            child: Container(
              width: 148,
              height: 38,
              decoration: ShapeDecoration(
                color: widget.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  widget.values.length,
                  (index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      widget.values[index],
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xAA000000),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeIn,
            alignment:
                initialPosition ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: 70,
              height: 40,
              decoration: ShapeDecoration(
                color: widget.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(index == 0 ? 40 : 0),
                    right: Radius.circular(index == 1 ? 40 : 0),
                  ),
                ),
              ),
              child: Text(
                initialPosition ? widget.values[0] : widget.values[1],
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 12,
                  color: widget.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }
}
