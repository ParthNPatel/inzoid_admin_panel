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

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
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

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    try {
      brandTitle = TextEditingController(text: editBrandController.brandName);
    } catch (e) {
      brandTitle = TextEditingController();
    }
    super.initState();
  }

  String status = 'All';

  List statusList = [
    'All',
    'Active',
    'Inactive',
  ];

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
                                "FULL NAME",
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
                                "USER NAME",
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
                            width: 80.sp,
                            child: Center(
                              child: Text(
                                "EMAIL",
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
                              "STATUS",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            )),
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
                  users(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> users() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection('All_User_Details').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<DocumentSnapshot> brands = snapshot.data!.docs;
          print("length======>${brands.length}");
          if (searchText.isNotEmpty) {
            brands = brands.where((element) {
              return element
                  .get('user_name')
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
                      image: NetworkImage(brands[index]['profile_image']),
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
                      text: brands[index]['full_name'], fontSize: 15),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 50.sp,
                  child: CommonText.textBoldWight700(
                      text: brands[index]['user_name'], fontSize: 15),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 80.sp,
                  child: CommonText.textBoldWight700(
                      text: brands[index]['email'], fontSize: 15),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 50.sp,
                  child:
                      CommonText.textBoldWight700(text: "Active", fontSize: 15),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 50.sp,
                  child: CommonText.textBoldWight700(
                      text:
                          "${brands[index]['created_date'].toString().split(' ')[0]}",
                      fontSize: 15),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    Get.dialog(AlertDialog(
                      title: Text(
                          "Are you sure that you want to delete this user?"),
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
                                .collection('All_User_Details')
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
                    Get.dialog(AlertDialog(
                      title: Text(
                          "Are you sure that you want to block this user?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text('NO'),
                        ),
                        TextButton(
                          onPressed: () {
                            // FirebaseFirestore.instance
                            //     .collection('All_User_Details')
                            //     .doc(brands[index].id)
                            //     .delete();
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
                      Icons.lock_outline,
                      size: 20,
                      color: CommonColor.greyColor838589,
                    ),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
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
          InkWell(
            onTap: () async {
              DateTime? newData = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2019),
                lastDate: DateTime(2031),
              );

              if (newData != null) {
                setState(() {
                  startDate = newData;
                });
              }
            },
            child: Container(
              height: 14.sp,
              width: 40.sp,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(startDate == null
                        ? "dd/mm/yyyy"
                        : "${startDate!.day}/${startDate!.month}/${startDate!.year}"),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.calendar_today,
                      size: 15,
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 2.sp,
          ),
          InkWell(
            onTap: () async {
              DateTime? newData = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2019),
                lastDate: DateTime(2031),
              );

              if (newData != null) {
                setState(() {
                  endDate = newData;
                });
              }
            },
            child: Container(
              height: 14.sp,
              width: 40.sp,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(endDate == null
                        ? "dd/mm/yyyy"
                        : "${endDate!.day}/${endDate!.month}/${endDate!.year}"),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.calendar_today,
                      size: 15,
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 6.sp,
          ),
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
                hint: Text("Select"),
                disabledHint: Text("Select"),
                value: status,
                items: statusList.map((e) {
                  return DropdownMenuItem(
                    child: Text(e),
                    value: e,
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    status = value as String;
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
