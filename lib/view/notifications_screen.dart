import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:inzoid_admin_panel/components/common_widget.dart';
import 'package:inzoid_admin_panel/controller/edit_brand_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import '../components/category_shimmer.dart';
import '../constant/color_const.dart';
import '../constant/text_const.dart';
import '../constant/text_styel.dart';
import '../controller/handle_screen_controller.dart';
import 'package:http/http.dart' as http;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String searchText = '';

  TextEditingController searchController = TextEditingController();

  TextEditingController messageController = TextEditingController();

  EditBrandController editBrandController = Get.find();

  HandleScreenController handleScreenController = Get.find();

  double progress = 0.0;

  List<Uint8List> _listOfImage = [];
  List<Uint8List> _brandIcon = [];

  bool isLoading = true;

  TextEditingController? brandTitle;

  HandleScreenController controller = Get.find();

  bool isSelected = false;

  bool allSelected = false;

  Map select = {};

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
    'New User',
  ];
  List sendNotificationList = [];
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            //mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 200.sp,
                child: Column(
                  children: [
                    TextFormField(
                      controller: messageController,
                      maxLines: 5,
                      decoration: InputDecoration(
                          hintStyle: TextStyle(
                              fontFamily: TextConst.fontFamily,
                              fontWeight: FontWeight.w500,
                              color: CommonColor.hinTextColor),
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: themColors309D9D),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "Write your message here.."),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MaterialButton(
                            onPressed: () async {
                              messageController.clear();
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            color: themColors309D9D,
                            height: 17.sp,
                            minWidth: 120,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: CommonText.textBoldWight500(
                                  text: "Cancel",
                                  color: Colors.white,
                                  fontSize: 7.sp),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () async {
                              if (messageController.text.isNotEmpty) {
                                if (allSelected) {
                                  print('alllalalallaal');
                                  var fetchCollection = FirebaseFirestore
                                      .instance
                                      .collection('All_User_Details');
                                  var getData = await fetchCollection.get();
                                  getData.docs.forEach((element) {
                                    print(
                                        'elelelelel  ${element['fcm_token']}  ${element.id}');
                                    if (sendNotificationList
                                        .contains(element['fcm_token'])) {
                                      print('npnpnpnpnp');
                                    } else {
                                      print('yesss');

                                      FirebaseFirestore.instance
                                          .collection('All_User_Details')
                                          .doc('${element.id}')
                                          .collection('Notification')
                                          .add({
                                        'msg': messageController.text,
                                      });

                                      sendMessageForPersonalUser(
                                          msg: messageController.text,
                                          receiverFcmToken:
                                              element['fcm_token']);
                                    }
                                  });
                                } else {
                                  var fetchCollection = FirebaseFirestore
                                      .instance
                                      .collection('All_User_Details');
                                  var getData = await fetchCollection.get();
                                  getData.docs.forEach((element) {
                                    print(
                                        'elelelelel  ${element['fcm_token']}  ${element.id}');
                                    if (sendNotificationList
                                        .contains(element['fcm_token'])) {
                                      print('yesss');

                                      FirebaseFirestore.instance
                                          .collection('All_User_Details')
                                          .doc('${element.id}')
                                          .collection('Notification')
                                          .add({
                                        'msg': messageController.text,
                                      });

                                      sendMessageForPersonalUser(
                                          msg: messageController.text,
                                          receiverFcmToken:
                                              element['fcm_token']);
                                    }
                                  });
                                }

                                CommonWidget.getSnackBar(
                                    title: "Sent!",
                                    message:
                                        'Notification has been sent to the selected users');

                                messageController.clear();
                                isSelected = false;
                                allSelected = false;
                                select = {};
                                sendNotificationList = [];
                                setState(
                                  () {},
                                );
                              } else {
                                CommonWidget.getSnackBar(
                                    color: Colors.red,
                                    colorText: Colors.white,
                                    title: "Required!",
                                    message: 'Please write message for users');
                              }
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            color: themColors309D9D,
                            height: 17.sp,
                            minWidth: 120,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CommonText.textBoldWight500(
                                      text: "Send",
                                      color: Colors.white,
                                      fontSize: 7.sp)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 30.sp,
                width: MediaQuery.of(context).size.width,
                //decoration: BoxDecoration(color: Colors.grey.shade200),
                child: Column(
                  children: [
                    SizedBox(
                      height: 3.sp,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 6.sp,
                        ),
                        InkWell(
                          onTap: () async {},
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
                                  // Checkbox(
                                  //   value: isSelected,
                                  //   activeColor: CommonColor.themColor309D9D,
                                  //   onChanged: (value) {
                                  //     setState(() {
                                  //       isSelected = value!;
                                  //     });
                                  //   },
                                  // ),
                                  Checkbox(
                                    value: allSelected,
                                    activeColor: CommonColor.themColor309D9D,
                                    onChanged: (value) {
                                      setState(() {
                                        allSelected = value!;

                                        select = {};
                                        sendNotificationList = [];
                                      });
                                    },
                                  ),
                                  Text("Select All"),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 6.sp,
                        ),
                        Container(
                          height: 15.sp,
                          width: 250.sp,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(5),
                          ),
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
                          width: 7.sp,
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
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    header(),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('All_User_Details')
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          List<DocumentSnapshot> brands = snapshot.data!.docs;
                          print("length======>${brands.length}");
                          int userIndex = 0;

                          if (searchText.isNotEmpty) {
                            brands = brands.where((element) {
                              return element
                                  .get('user_name')
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchText.toLowerCase());
                            }).toList();
                          }

                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  //height: 150.sp,
                                  child: ListView.builder(
                                    //reverse: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 25),
                                    itemCount: brands.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      // print('DOC ID ${brands[index].id}');
                                      userIndex = index;
                                      return Row(
                                        children: [
                                          SizedBox(
                                            width: 30.sp,
                                            child: Checkbox(
                                              value: (allSelected &&
                                                      select.containsKey(
                                                              '$index') ==
                                                          false)
                                                  ? allSelected
                                                  : select.containsKey('$index')
                                                      ? select['$index'] == true
                                                          ? true
                                                          : false
                                                      : false,
                                              activeColor:
                                                  CommonColor.themColor309D9D,
                                              onChanged: (value) {
                                                setState(() {
                                                  isSelected = value!;

                                                  if (select
                                                      .containsKey('$index')) {
                                                    select.remove("$index");
                                                  } else {
                                                    if (allSelected) {
                                                      select.addAll(
                                                          {"$index": false});
                                                    } else {
                                                      select.addAll(
                                                          {"$index": true});
                                                    }
                                                  }
                                                  try {
                                                    if (sendNotificationList
                                                        .contains(brands[index]
                                                            ['fcm_token'])) {
                                                      sendNotificationList
                                                          .remove(brands[index]
                                                              ['fcm_token']);
                                                    } else {
                                                      sendNotificationList.add(
                                                          brands[index]
                                                              ['fcm_token']);
                                                    }
                                                    print(
                                                        'sendNotificationList  ${sendNotificationList}');
                                                  } catch (e) {}
                                                });
                                                print("Select Map$select");
                                                print(
                                                    "Select Map index${select.containsKey('$index') ? select[index] == true ? true : false : false}");
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            height: 60,
                                            width: 80,
                                            margin: EdgeInsets.only(
                                                right: 20, bottom: 20),
                                            decoration: BoxDecoration(
                                              color:
                                                  CommonColor.greyColorF2F2F2,
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    brands[index]
                                                        ['profile_image']),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                              width: 50.sp,
                                              child: Center(
                                                child:
                                                    CommonText.textBoldWight700(
                                                        text: brands[index]
                                                            ['user_name'],
                                                        fontSize: 15),
                                              )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            width: 80.sp,
                                            child: CommonText.textBoldWight700(
                                                text: brands[index]['email'],
                                                fontSize: 15),
                                          ),
                                          // SizedBox(
                                          //   width: 10,
                                          // ),
                                          SizedBox(
                                            width: 50.sp,
                                            child: Center(
                                              child:
                                                  CommonText.textBoldWight700(
                                                      text: "Active",
                                                      fontSize: 15),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 10.sp,
                                ),
                              ],
                            ),
                          );
                        } else {
                          return CategoryShimmer();
                        }
                      },
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 20),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       MaterialButton(
              //         onPressed: () async {
              //           messageController.clear();
              //         },
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(5),
              //         ),
              //         color: themColors309D9D,
              //         height: 20.sp,
              //         minWidth: 140,
              //         child: Padding(
              //           padding: const EdgeInsets.symmetric(vertical: 2),
              //           child: CommonText.textBoldWight500(
              //               text: "Cancel",
              //               color: Colors.white,
              //               fontSize: 7.sp),
              //         ),
              //       ),
              //       MaterialButton(
              //         onPressed: () async {
              //           Get.back();
              //
              //           // // FirebaseFirestore.instance
              //           // //     .collection('All_User_Details')
              //           // //     .doc('${brands[index].id}')
              //           // //     .collection('Notification')
              //           // //     .add({
              //           // //   'msg': messageController.text,
              //           // // });
              //           // // sendMessageForPersonalUser(
              //           // //     msg: messageController.text,
              //           // //     receiverFcmToken: brands[index]['fcm_token']);
              //           //
              //           // if (messageController.text.isNotEmpty) {
              //           //   Get.dialog(
              //           //     StatefulBuilder(
              //           //       builder: (context, setState) => Dialog(
              //           //         child: SizedBox(
              //           //           width: 300.sp,
              //           //           child: Column(
              //           //             mainAxisSize: MainAxisSize.min,
              //           //             children: [
              //           //               Container(
              //           //                 height: 40.sp,
              //           //                 width: MediaQuery.of(context)
              //           //                     .size
              //           //                     .width,
              //           //                 //decoration: BoxDecoration(color: Colors.grey.shade200),
              //           //                 child: Column(
              //           //                   children: [
              //           //                     SizedBox(
              //           //                       height: 3.sp,
              //           //                     ),
              //           //                     Row(
              //           //                       children: [
              //           //                         SizedBox(
              //           //                           width: 6.sp,
              //           //                         ),
              //           //                         InkWell(
              //           //                           onTap: () async {},
              //           //                           child: Container(
              //           //                             height: 14.sp,
              //           //                             width: 40.sp,
              //           //                             decoration:
              //           //                                 BoxDecoration(
              //           //                               color: Colors.white,
              //           //                               borderRadius:
              //           //                                   BorderRadius
              //           //                                       .circular(5),
              //           //                               border: Border.all(
              //           //                                   color:
              //           //                                       Colors.grey),
              //           //                             ),
              //           //                             child: Center(
              //           //                               child: Row(
              //           //                                 mainAxisAlignment:
              //           //                                     MainAxisAlignment
              //           //                                         .center,
              //           //                                 children: [
              //           //                                   // Checkbox(
              //           //                                   //   value: isSelected,
              //           //                                   //   activeColor: CommonColor.themColor309D9D,
              //           //                                   //   onChanged: (value) {
              //           //                                   //     setState(() {
              //           //                                   //       isSelected = value!;
              //           //                                   //     });
              //           //                                   //   },
              //           //                                   // ),
              //           //                                   Checkbox(
              //           //                                     value:
              //           //                                         allSelected,
              //           //                                     activeColor:
              //           //                                         CommonColor
              //           //                                             .themColor309D9D,
              //           //                                     onChanged:
              //           //                                         (value) {
              //           //                                       setState(() {
              //           //                                         allSelected =
              //           //                                             value!;
              //           //
              //           //                                         select = {};
              //           //                                         sendNotificationList =
              //           //                                             [];
              //           //                                       });
              //           //                                     },
              //           //                                   ),
              //           //                                   Text(
              //           //                                       "Select All"),
              //           //                                   SizedBox(
              //           //                                     width: 5,
              //           //                                   ),
              //           //                                 ],
              //           //                               ),
              //           //                             ),
              //           //                           ),
              //           //                         ),
              //           //                         SizedBox(
              //           //                           width: 6.sp,
              //           //                         ),
              //           //                         Container(
              //           //                           height: 15.sp,
              //           //                           width: 150.sp,
              //           //                           decoration: BoxDecoration(
              //           //                             color: Colors
              //           //                                 .grey.shade300,
              //           //                             borderRadius:
              //           //                                 BorderRadius
              //           //                                     .circular(5),
              //           //                           ),
              //           //                           child: Center(
              //           //                             child: TextFormField(
              //           //                               controller:
              //           //                                   searchController,
              //           //                               onChanged: (value) {
              //           //                                 setState(() {
              //           //                                   searchText =
              //           //                                       value;
              //           //                                 });
              //           //                               },
              //           //                               cursorHeight: 8.sp,
              //           //                               decoration:
              //           //                                   InputDecoration(
              //           //                                 border: InputBorder
              //           //                                     .none,
              //           //                                 hintText: "Search",
              //           //                                 prefixIcon: Icon(
              //           //                                     Icons.search),
              //           //                               ),
              //           //                             ),
              //           //                           ),
              //           //                         ),
              //           //                         Spacer(),
              //           //                         Container(
              //           //                           height: 14.sp,
              //           //                           width: 40.sp,
              //           //                           decoration: BoxDecoration(
              //           //                             color: Colors.white,
              //           //                             borderRadius:
              //           //                                 BorderRadius
              //           //                                     .circular(5),
              //           //                             border: Border.all(
              //           //                                 color: Colors.grey),
              //           //                           ),
              //           //                           child: Center(
              //           //                             child: DropdownButton(
              //           //                               underline: SizedBox(),
              //           //                               hint: Text("Select"),
              //           //                               disabledHint:
              //           //                                   Text("Select"),
              //           //                               value: status,
              //           //                               items: statusList
              //           //                                   .map((e) {
              //           //                                 return DropdownMenuItem(
              //           //                                   child: Text(e),
              //           //                                   value: e,
              //           //                                 );
              //           //                               }).toList(),
              //           //                               onChanged: (value) {
              //           //                                 setState(() {
              //           //                                   status = value
              //           //                                       as String;
              //           //                                 });
              //           //                               },
              //           //                             ),
              //           //                           ),
              //           //                         ),
              //           //                         SizedBox(
              //           //                           width: 6.sp,
              //           //                         ),
              //           //                       ],
              //           //                     ),
              //           //                     SizedBox(
              //           //                       height: 3.sp,
              //           //                     ),
              //           //                     Row(
              //           //                       mainAxisAlignment:
              //           //                           MainAxisAlignment.center,
              //           //                       children: [
              //           //                         InkWell(
              //           //                           onTap: () async {
              //           //                             DateTime? newData =
              //           //                                 await showDatePicker(
              //           //                               context: context,
              //           //                               initialDate:
              //           //                                   DateTime.now(),
              //           //                               firstDate:
              //           //                                   DateTime(2019),
              //           //                               lastDate:
              //           //                                   DateTime(2031),
              //           //                             );
              //           //
              //           //                             if (newData != null) {
              //           //                               setState(() {
              //           //                                 startDate = newData;
              //           //                               });
              //           //                             }
              //           //                           },
              //           //                           child: Container(
              //           //                             height: 14.sp,
              //           //                             width: 40.sp,
              //           //                             decoration:
              //           //                                 BoxDecoration(
              //           //                               color: Colors.white,
              //           //                               borderRadius:
              //           //                                   BorderRadius
              //           //                                       .circular(5),
              //           //                               border: Border.all(
              //           //                                   color:
              //           //                                       Colors.grey),
              //           //                             ),
              //           //                             child: Center(
              //           //                               child: Row(
              //           //                                 mainAxisAlignment:
              //           //                                     MainAxisAlignment
              //           //                                         .center,
              //           //                                 children: [
              //           //                                   Text(startDate ==
              //           //                                           null
              //           //                                       ? "dd/mm/yyyy"
              //           //                                       : "${startDate!.day}/${startDate!.month}/${startDate!.year}"),
              //           //                                   SizedBox(
              //           //                                     width: 5,
              //           //                                   ),
              //           //                                   Icon(
              //           //                                     Icons
              //           //                                         .calendar_today,
              //           //                                     size: 15,
              //           //                                   )
              //           //                                 ],
              //           //                               ),
              //           //                             ),
              //           //                           ),
              //           //                         ),
              //           //                         SizedBox(
              //           //                           width: 7.sp,
              //           //                         ),
              //           //                         InkWell(
              //           //                           onTap: () async {
              //           //                             DateTime? newData =
              //           //                                 await showDatePicker(
              //           //                               context: context,
              //           //                               initialDate:
              //           //                                   DateTime.now(),
              //           //                               firstDate:
              //           //                                   DateTime(2019),
              //           //                               lastDate:
              //           //                                   DateTime(2031),
              //           //                             );
              //           //
              //           //                             if (newData != null) {
              //           //                               setState(() {
              //           //                                 endDate = newData;
              //           //                               });
              //           //                             }
              //           //                           },
              //           //                           child: Container(
              //           //                             height: 14.sp,
              //           //                             width: 40.sp,
              //           //                             decoration:
              //           //                                 BoxDecoration(
              //           //                               color: Colors.white,
              //           //                               borderRadius:
              //           //                                   BorderRadius
              //           //                                       .circular(5),
              //           //                               border: Border.all(
              //           //                                   color:
              //           //                                       Colors.grey),
              //           //                             ),
              //           //                             child: Center(
              //           //                               child: Row(
              //           //                                 mainAxisAlignment:
              //           //                                     MainAxisAlignment
              //           //                                         .center,
              //           //                                 children: [
              //           //                                   Text(endDate ==
              //           //                                           null
              //           //                                       ? "dd/mm/yyyy"
              //           //                                       : "${endDate!.day}/${endDate!.month}/${endDate!.year}"),
              //           //                                   SizedBox(
              //           //                                     width: 5,
              //           //                                   ),
              //           //                                   Icon(
              //           //                                     Icons
              //           //                                         .calendar_today,
              //           //                                     size: 15,
              //           //                                   )
              //           //                                 ],
              //           //                               ),
              //           //                             ),
              //           //                           ),
              //           //                         ),
              //           //                         SizedBox(
              //           //                           width: 6.sp,
              //           //                         ),
              //           //                       ],
              //           //                     ),
              //           //                   ],
              //           //                 ),
              //           //               ),
              //           //               header(),
              //           //               StreamBuilder<QuerySnapshot>(
              //           //                 stream: FirebaseFirestore.instance
              //           //                     .collection('All_User_Details')
              //           //                     .snapshots(),
              //           //                 builder: (context,
              //           //                     AsyncSnapshot<QuerySnapshot>
              //           //                         snapshot) {
              //           //                   if (snapshot.hasData) {
              //           //                     List<DocumentSnapshot> brands =
              //           //                         snapshot.data!.docs;
              //           //                     print(
              //           //                         "length======>${brands.length}");
              //           //                     int userIndex = 0;
              //           //
              //           //                     if (searchText.isNotEmpty) {
              //           //                       brands =
              //           //                           brands.where((element) {
              //           //                         return element
              //           //                             .get('user_name')
              //           //                             .toString()
              //           //                             .toLowerCase()
              //           //                             .contains(searchText
              //           //                                 .toLowerCase());
              //           //                       }).toList();
              //           //                     }
              //           //
              //           //                     return SingleChildScrollView(
              //           //                       child: Column(
              //           //                         crossAxisAlignment:
              //           //                             CrossAxisAlignment
              //           //                                 .center,
              //           //                         children: [
              //           //                           SizedBox(
              //           //                             height: 150.sp,
              //           //                             child: ListView.builder(
              //           //                               //reverse: true,
              //           //                               physics:
              //           //                                   NeverScrollableScrollPhysics(),
              //           //                               padding: EdgeInsets
              //           //                                   .symmetric(
              //           //                                       horizontal:
              //           //                                           25,
              //           //                                       vertical: 25),
              //           //                               itemCount:
              //           //                                   brands.length,
              //           //                               shrinkWrap: true,
              //           //                               itemBuilder:
              //           //                                   (context, index) {
              //           //                                 // print('DOC ID ${brands[index].id}');
              //           //                                 userIndex = index;
              //           //                                 return Row(
              //           //                                   children: [
              //           //                                     SizedBox(
              //           //                                       width: 10,
              //           //                                     ),
              //           //                                     Container(
              //           //                                       height: 60,
              //           //                                       width: 80,
              //           //                                       margin: EdgeInsets
              //           //                                           .only(
              //           //                                               right:
              //           //                                                   20,
              //           //                                               bottom:
              //           //                                                   20),
              //           //                                       decoration:
              //           //                                           BoxDecoration(
              //           //                                         color: CommonColor
              //           //                                             .greyColorF2F2F2,
              //           //                                         image:
              //           //                                             DecorationImage(
              //           //                                           image: NetworkImage(
              //           //                                               brands[index]
              //           //                                                   [
              //           //                                                   'profile_image']),
              //           //                                           fit: BoxFit
              //           //                                               .cover,
              //           //                                         ),
              //           //                                         borderRadius:
              //           //                                             BorderRadius
              //           //                                                 .circular(7),
              //           //                                       ),
              //           //                                     ),
              //           //                                     SizedBox(
              //           //                                       width: 10,
              //           //                                     ),
              //           //                                     SizedBox(
              //           //                                       width: 50.sp,
              //           //                                       child: CommonText.textBoldWight700(
              //           //                                           text: brands[
              //           //                                                   index]
              //           //                                               [
              //           //                                               'user_name'],
              //           //                                           fontSize:
              //           //                                               15),
              //           //                                     ),
              //           //                                     SizedBox(
              //           //                                       width: 10,
              //           //                                     ),
              //           //                                     SizedBox(
              //           //                                       width: 80.sp,
              //           //                                       child: CommonText.textBoldWight700(
              //           //                                           text: brands[
              //           //                                                   index]
              //           //                                               [
              //           //                                               'email'],
              //           //                                           fontSize:
              //           //                                               15),
              //           //                                     ),
              //           //                                     SizedBox(
              //           //                                       width: 10,
              //           //                                     ),
              //           //                                     SizedBox(
              //           //                                       width: 50.sp,
              //           //                                       child: Center(
              //           //                                         child: CommonText.textBoldWight700(
              //           //                                             text:
              //           //                                                 "Active",
              //           //                                             fontSize:
              //           //                                                 15),
              //           //                                       ),
              //           //                                     ),
              //           //                                     SizedBox(
              //           //                                       width: 10,
              //           //                                     ),
              //           //                                     Checkbox(
              //           //                                       value: (allSelected &&
              //           //                                               select.containsKey('$index') ==
              //           //                                                   false)
              //           //                                           ? allSelected
              //           //                                           : select.containsKey(
              //           //                                                   '$index')
              //           //                                               ? select['$index'] == true
              //           //                                                   ? true
              //           //                                                   : false
              //           //                                               : false,
              //           //                                       activeColor:
              //           //                                           CommonColor
              //           //                                               .themColor309D9D,
              //           //                                       onChanged:
              //           //                                           (value) {
              //           //                                         setState(
              //           //                                             () {
              //           //                                           isSelected =
              //           //                                               value!;
              //           //
              //           //                                           if (select
              //           //                                               .containsKey(
              //           //                                                   '$index')) {
              //           //                                             select.remove(
              //           //                                                 "$index");
              //           //                                           } else {
              //           //                                             if (allSelected) {
              //           //                                               select
              //           //                                                   .addAll({
              //           //                                                 "$index":
              //           //                                                     false
              //           //                                               });
              //           //                                             } else {
              //           //                                               select
              //           //                                                   .addAll({
              //           //                                                 "$index":
              //           //                                                     true
              //           //                                               });
              //           //                                             }
              //           //                                           }
              //           //                                           try {
              //           //                                             if (sendNotificationList.contains(brands[index]
              //           //                                                 [
              //           //                                                 'fcm_token'])) {
              //           //                                               sendNotificationList.remove(brands[index]
              //           //                                                   [
              //           //                                                   'fcm_token']);
              //           //                                             } else {
              //           //                                               sendNotificationList.add(brands[index]
              //           //                                                   [
              //           //                                                   'fcm_token']);
              //           //                                             }
              //           //                                             print(
              //           //                                                 'sendNotificationList  ${sendNotificationList}');
              //           //                                           } catch (e) {}
              //           //                                         });
              //           //                                         print(
              //           //                                             "Select Map$select");
              //           //                                         print(
              //           //                                             "Select Map index${select.containsKey('$index') ? select[index] == true ? true : false : false}");
              //           //                                       },
              //           //                                     ),
              //           //                                     SizedBox(
              //           //                                       width: 10,
              //           //                                     ),
              //           //                                   ],
              //           //                                 );
              //           //                               },
              //           //                             ),
              //           //                           ),
              //           //                           Padding(
              //           //                             padding: EdgeInsets
              //           //                                 .symmetric(
              //           //                                     horizontal: 40),
              //           //                             child: Row(
              //           //                               mainAxisAlignment:
              //           //                                   MainAxisAlignment
              //           //                                       .spaceBetween,
              //           //                               children: [
              //           //                                 MaterialButton(
              //           //                                   onPressed:
              //           //                                       () async {
              //           //                                     Get.back();
              //           //                                   },
              //           //                                   shape:
              //           //                                       RoundedRectangleBorder(
              //           //                                     borderRadius:
              //           //                                         BorderRadius
              //           //                                             .circular(
              //           //                                                 5),
              //           //                                   ),
              //           //                                   color:
              //           //                                       themColors309D9D,
              //           //                                   height: 20.sp,
              //           //                                   minWidth: 130,
              //           //                                   child: Padding(
              //           //                                     padding: const EdgeInsets
              //           //                                             .symmetric(
              //           //                                         vertical:
              //           //                                             2),
              //           //                                     child: CommonText.textBoldWight500(
              //           //                                         text:
              //           //                                             "Cancel",
              //           //                                         color: Colors
              //           //                                             .white,
              //           //                                         fontSize:
              //           //                                             7.sp),
              //           //                                   ),
              //           //                                 ),
              //           //                                 MaterialButton(
              //           //                                   onPressed:
              //           //                                       () async {
              //           //                                     Get.back();
              //           //                                     if (allSelected) {
              //           //                                       print(
              //           //                                           'alllalalallaal');
              //           //                                       var fetchCollection = FirebaseFirestore
              //           //                                           .instance
              //           //                                           .collection(
              //           //                                               'All_User_Details');
              //           //                                       var getData =
              //           //                                           await fetchCollection
              //           //                                               .get();
              //           //                                       getData.docs
              //           //                                           .forEach(
              //           //                                               (element) {
              //           //                                         print(
              //           //                                             'elelelelel  ${element['fcm_token']}  ${element.id}');
              //           //                                         if (sendNotificationList
              //           //                                             .contains(
              //           //                                                 element['fcm_token'])) {
              //           //                                           print(
              //           //                                               'npnpnpnpnp');
              //           //                                         } else {
              //           //                                           print(
              //           //                                               'yesss');
              //           //
              //           //                                           FirebaseFirestore
              //           //                                               .instance
              //           //                                               .collection(
              //           //                                                   'All_User_Details')
              //           //                                               .doc(
              //           //                                                   '${element.id}')
              //           //                                               .collection(
              //           //                                                   'Notification')
              //           //                                               .add({
              //           //                                             'msg': messageController
              //           //                                                 .text,
              //           //                                           });
              //           //
              //           //                                           sendMessageForPersonalUser(
              //           //                                               msg: messageController
              //           //                                                   .text,
              //           //                                               receiverFcmToken:
              //           //                                                   element['fcm_token']);
              //           //                                         }
              //           //                                       });
              //           //                                     } else {
              //           //                                       var fetchCollection = FirebaseFirestore
              //           //                                           .instance
              //           //                                           .collection(
              //           //                                               'All_User_Details');
              //           //                                       var getData =
              //           //                                           await fetchCollection
              //           //                                               .get();
              //           //                                       getData.docs
              //           //                                           .forEach(
              //           //                                               (element) {
              //           //                                         print(
              //           //                                             'elelelelel  ${element['fcm_token']}  ${element.id}');
              //           //                                         if (sendNotificationList
              //           //                                             .contains(
              //           //                                                 element['fcm_token'])) {
              //           //                                           print(
              //           //                                               'yesss');
              //           //
              //           //                                           FirebaseFirestore
              //           //                                               .instance
              //           //                                               .collection(
              //           //                                                   'All_User_Details')
              //           //                                               .doc(
              //           //                                                   '${element.id}')
              //           //                                               .collection(
              //           //                                                   'Notification')
              //           //                                               .add({
              //           //                                             'msg': messageController
              //           //                                                 .text,
              //           //                                           });
              //           //
              //           //                                           sendMessageForPersonalUser(
              //           //                                               msg: messageController
              //           //                                                   .text,
              //           //                                               receiverFcmToken:
              //           //                                                   element['fcm_token']);
              //           //                                         }
              //           //                                       });
              //           //                                     }
              //           //
              //           //                                     messageController
              //           //                                         .clear();
              //           //                                     isSelected =
              //           //                                         false;
              //           //                                     allSelected =
              //           //                                         false;
              //           //                                     select = {};
              //           //                                     sendNotificationList =
              //           //                                         [];
              //           //                                     setState(
              //           //                                       () {},
              //           //                                     );
              //           //                                   },
              //           //                                   shape:
              //           //                                       RoundedRectangleBorder(
              //           //                                     borderRadius:
              //           //                                         BorderRadius
              //           //                                             .circular(
              //           //                                                 5),
              //           //                                   ),
              //           //                                   color:
              //           //                                       themColors309D9D,
              //           //                                   height: 20.sp,
              //           //                                   minWidth: 140,
              //           //                                   child: Padding(
              //           //                                     padding:
              //           //                                         const EdgeInsets
              //           //                                             .symmetric(
              //           //                                       vertical: 2,
              //           //                                     ),
              //           //                                     child: Row(
              //           //                                       mainAxisAlignment:
              //           //                                           MainAxisAlignment
              //           //                                               .center,
              //           //                                       children: [
              //           //                                         CommonText.textBoldWight500(
              //           //                                             text:
              //           //                                                 "Send",
              //           //                                             color: Colors
              //           //                                                 .white,
              //           //                                             fontSize:
              //           //                                                 7.sp)
              //           //                                       ],
              //           //                                     ),
              //           //                                   ),
              //           //                                 ),
              //           //                               ],
              //           //                             ),
              //           //                           ),
              //           //                           SizedBox(
              //           //                             height: 10.sp,
              //           //                           ),
              //           //                         ],
              //           //                       ),
              //           //                     );
              //           //                   } else {
              //           //                     return CategoryShimmer();
              //           //                   }
              //           //                 },
              //           //               ),
              //           //             ],
              //           //           ),
              //           //         ),
              //           //       ),
              //           //     ),
              //           //   ).then((value) {
              //           //     setState(() {});
              //           //   });
              //           // } else {
              //           //   CommonWidget.getSnackBar(
              //           //       color: CommonColor.red,
              //           //       colorText: Colors.white,
              //           //       title: "Required",
              //           //       message: "Please enter message for users");
              //           // }
              //         },
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(5),
              //         ),
              //         color: themColors309D9D,
              //         height: 20.sp,
              //         minWidth: 140,
              //         child: Padding(
              //           padding: const EdgeInsets.symmetric(
              //             vertical: 2,
              //           ),
              //           child: Row(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 CommonText.textBoldWight500(
              //                     text: "Send",
              //                     color: Colors.white,
              //                     fontSize: 7.sp)
              //               ]),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ],
      ),
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
              width: 30.sp,
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
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
            SizedBox(
              width: 10,
            ),
            Container(
              width: 50.sp,
              child: Center(
                child: Text(
                  "USER NAME",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500),
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
                      color: Colors.black, fontWeight: FontWeight.w500),
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
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              )),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }

  // StreamBuilder<QuerySnapshot<Object?>> users() {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream:
  //         FirebaseFirestore.instance.collection('All_User_Details').snapshots(),
  //     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //       if (snapshot.hasData) {
  //         List<DocumentSnapshot> brands = snapshot.data!.docs;
  //         print("length======>${brands.length}");
  //         int userIndex = 0;
  //
  //         if (searchText.isNotEmpty) {
  //           brands = brands.where((element) {
  //             return element
  //                 .get('user_name')
  //                 .toString()
  //                 .toLowerCase()
  //                 .contains(searchText.toLowerCase());
  //           }).toList();
  //         }
  //
  //         return SingleChildScrollView(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               SizedBox(
  //                 height: 150.sp,
  //                 child: ListView.builder(
  //                   //reverse: true,
  //                   physics: NeverScrollableScrollPhysics(),
  //                   padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
  //                   itemCount: brands.length,
  //                   shrinkWrap: true,
  //                   itemBuilder: (context, index) {
  //                     // print('DOC ID ${brands[index].id}');
  //                     userIndex = index;
  //                     return Row(
  //                       children: [
  //                         SizedBox(
  //                           width: 10,
  //                         ),
  //                         Container(
  //                           height: 60,
  //                           width: 80,
  //                           margin: EdgeInsets.only(right: 20, bottom: 20),
  //                           decoration: BoxDecoration(
  //                             color: CommonColor.greyColorF2F2F2,
  //                             image: DecorationImage(
  //                               image: NetworkImage(
  //                                   brands[index]['profile_image']),
  //                               fit: BoxFit.cover,
  //                             ),
  //                             borderRadius: BorderRadius.circular(7),
  //                           ),
  //                         ),
  //                         SizedBox(
  //                           width: 10,
  //                         ),
  //                         SizedBox(
  //                           width: 50.sp,
  //                           child: CommonText.textBoldWight700(
  //                               text: brands[index]['user_name'], fontSize: 15),
  //                         ),
  //                         SizedBox(
  //                           width: 10,
  //                         ),
  //                         SizedBox(
  //                           width: 80.sp,
  //                           child: CommonText.textBoldWight700(
  //                               text: brands[index]['email'], fontSize: 15),
  //                         ),
  //                         SizedBox(
  //                           width: 10,
  //                         ),
  //                         SizedBox(
  //                           width: 50.sp,
  //                           child: Center(
  //                             child: CommonText.textBoldWight700(
  //                                 text: "Active", fontSize: 15),
  //                           ),
  //                         ),
  //                         SizedBox(
  //                           width: 10,
  //                         ),
  //                         Checkbox(
  //                           value: allSelected ? allSelected : isSelected,
  //                           activeColor: CommonColor.themColor309D9D,
  //                           onChanged: (value) {
  //                             setState(() {
  //                               isSelected = value!;
  //                             });
  //                           },
  //                         ),
  //                         SizedBox(
  //                           width: 10,
  //                         ),
  //                       ],
  //                     );
  //                   },
  //                 ),
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.symmetric(horizontal: 40),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     MaterialButton(
  //                       onPressed: () async {
  //                         Get.back();
  //                       },
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(5),
  //                       ),
  //                       color: themColors309D9D,
  //                       height: 20.sp,
  //                       minWidth: 130,
  //                       child: Padding(
  //                         padding: const EdgeInsets.symmetric(vertical: 2),
  //                         child: CommonText.textBoldWight500(
  //                             text: "Cancel",
  //                             color: Colors.white,
  //                             fontSize: 7.sp),
  //                       ),
  //                     ),
  //                     MaterialButton(
  //                       onPressed: () async {
  //                         Get.back();
  //                         FirebaseFirestore.instance
  //                             .collection('All_User_Details')
  //                             .doc('${brands[userIndex].id}')
  //                             .collection('Notification')
  //                             .add({
  //                           'msg': messageController.text,
  //                         });
  //
  //                         sendMessageForPersonalUser(
  //                             msg: messageController.text,
  //                             receiverFcmToken: brands[userIndex]['fcm_token']);
  //                       },
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(5),
  //                       ),
  //                       color: themColors309D9D,
  //                       height: 20.sp,
  //                       minWidth: 140,
  //                       child: Padding(
  //                         padding: const EdgeInsets.symmetric(
  //                           vertical: 2,
  //                         ),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             CommonText.textBoldWight500(
  //                                 text: "Send",
  //                                 color: Colors.white,
  //                                 fontSize: 7.sp)
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 10.sp,
  //               ),
  //             ],
  //           ),
  //         );
  //       } else {
  //         return CategoryShimmer();
  //       }
  //     },
  //   );
  // }

  Future<dynamic> sendNotificationDialog(
      List<DocumentSnapshot<Object?>> brands, int index) {
    return Get.dialog(
      StatefulBuilder(
        builder: (context, setState) => Dialog(
          child: SizedBox(
            width: 120.sp,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonText.textBoldWight500(
                          text:
                              'Send Notification to ${brands[index]['user_name']}',
                          fontSize: 8.sp),
                      InkResponse(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(Icons.close),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: messageController,
                    maxLines: 5,
                    decoration: InputDecoration(
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
                        hintText: "Write your message here.."),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  MaterialButton(
                    onPressed: () async {
                      Get.back();
                      FirebaseFirestore.instance
                          .collection('All_User_Details')
                          .doc('${brands[index].id}')
                          .collection('Notification')
                          .add({
                        'msg': messageController.text,
                      });
                      sendMessageForPersonalUser(
                          msg: messageController.text,
                          receiverFcmToken: brands[index]['fcm_token']);
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
                                text: "Send",
                                color: Colors.white,
                                fontSize: 5.sp)
                          ]),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Future<bool?> sendMessageForPersonalUser({
    String? receiverFcmToken,
    String? msg,
  }) async {
    try {
      // for (String token in receiverFcmToken) {
      // log("RESPONSE TOKEN  $receiverFcmToken");

      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=${TextConst.serverKey}',
        },
        body: jsonEncode(
          <String, dynamic>{
            "priority": "high",
            'notification': <String, dynamic>{
              'body': msg,
              'title': 'Inzoid Admin',
              'bodyLocKey': 'true',
              "content_available": true,
              // "sound": "iphone1.mp3"
            },
            'data': <String, dynamic>{
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "body": 'Notification_screen',
              // 'click_action': 'notification_screen',
              'id': '1',
              'status': 'done'
            },
            'android': {
              'notification': {
                'channel_id': 'high_importance_channel',
              },
            },
            'apns': {
              'headers': {
                // "apns-push-type":
                //     "background", // This line prevents background notification
                "apns-priority": "10",
              },
            },
            "webpush": {
              "headers": {"Urgency": "high"}
            },
            'to': receiverFcmToken,
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

  // Container searchBar(BuildContext context) {
  //   return Container(
  //     height: 40.sp,
  //     width: MediaQuery.of(context).size.width,
  //     //decoration: BoxDecoration(color: Colors.grey.shade200),
  //     child: Column(
  //       children: [
  //         SizedBox(
  //           height: 3.sp,
  //         ),
  //         Row(
  //           children: [
  //             SizedBox(
  //               width: 6.sp,
  //             ),
  //             InkWell(
  //               onTap: () async {},
  //               child: Container(
  //                 height: 14.sp,
  //                 width: 40.sp,
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(5),
  //                   border: Border.all(color: Colors.grey),
  //                 ),
  //                 child: Center(
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       // Checkbox(
  //                       //   value: isSelected,
  //                       //   activeColor: CommonColor.themColor309D9D,
  //                       //   onChanged: (value) {
  //                       //     setState(() {
  //                       //       isSelected = value!;
  //                       //     });
  //                       //   },
  //                       // ),
  //                       Checkbox(
  //                         value: allSelected,
  //                         activeColor: CommonColor.themColor309D9D,
  //                         onChanged: (value) {
  //                           setState(() {
  //                             allSelected = value!;
  //                           });
  //                         },
  //                       ),
  //                       Text("Select All"),
  //                       SizedBox(
  //                         width: 5,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               width: 6.sp,
  //             ),
  //             Container(
  //               height: 15.sp,
  //               width: 150.sp,
  //               decoration: BoxDecoration(
  //                 color: Colors.grey.shade300,
  //                 borderRadius: BorderRadius.circular(5),
  //               ),
  //               child: Center(
  //                 child: TextFormField(
  //                   controller: searchController,
  //                   onChanged: (value) {
  //                     setState(() {
  //                       searchText = value;
  //                     });
  //                   },
  //                   cursorHeight: 8.sp,
  //                   decoration: InputDecoration(
  //                     border: InputBorder.none,
  //                     hintText: "Search",
  //                     prefixIcon: Icon(Icons.search),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Spacer(),
  //             Container(
  //               height: 14.sp,
  //               width: 40.sp,
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(5),
  //                 border: Border.all(color: Colors.grey),
  //               ),
  //               child: Center(
  //                 child: DropdownButton(
  //                   underline: SizedBox(),
  //                   hint: Text("Select"),
  //                   disabledHint: Text("Select"),
  //                   value: status,
  //                   items: statusList.map((e) {
  //                     return DropdownMenuItem(
  //                       child: Text(e),
  //                       value: e,
  //                     );
  //                   }).toList(),
  //                   onChanged: (value) {
  //                     setState(() {
  //                       status = value as String;
  //                     });
  //                   },
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               width: 6.sp,
  //             ),
  //           ],
  //         ),
  //         SizedBox(
  //           height: 3.sp,
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             InkWell(
  //               onTap: () async {
  //                 DateTime? newData = await showDatePicker(
  //                   context: context,
  //                   initialDate: DateTime.now(),
  //                   firstDate: DateTime(2019),
  //                   lastDate: DateTime(2031),
  //                 );
  //
  //                 if (newData != null) {
  //                   setState(() {
  //                     startDate = newData;
  //                   });
  //                 }
  //               },
  //               child: Container(
  //                 height: 14.sp,
  //                 width: 40.sp,
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(5),
  //                   border: Border.all(color: Colors.grey),
  //                 ),
  //                 child: Center(
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Text(startDate == null
  //                           ? "dd/mm/yyyy"
  //                           : "${startDate!.day}/${startDate!.month}/${startDate!.year}"),
  //                       SizedBox(
  //                         width: 5,
  //                       ),
  //                       Icon(
  //                         Icons.calendar_today,
  //                         size: 15,
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               width: 7.sp,
  //             ),
  //             InkWell(
  //               onTap: () async {
  //                 DateTime? newData = await showDatePicker(
  //                   context: context,
  //                   initialDate: DateTime.now(),
  //                   firstDate: DateTime(2019),
  //                   lastDate: DateTime(2031),
  //                 );
  //
  //                 if (newData != null) {
  //                   setState(() {
  //                     endDate = newData;
  //                   });
  //                 }
  //               },
  //               child: Container(
  //                 height: 14.sp,
  //                 width: 40.sp,
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(5),
  //                   border: Border.all(color: Colors.grey),
  //                 ),
  //                 child: Center(
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Text(endDate == null
  //                           ? "dd/mm/yyyy"
  //                           : "${endDate!.day}/${endDate!.month}/${endDate!.year}"),
  //                       SizedBox(
  //                         width: 5,
  //                       ),
  //                       Icon(
  //                         Icons.calendar_today,
  //                         size: 15,
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               width: 6.sp,
  //             ),
  //           ],
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

// class SelectWidget extends StatefulWidget {
//   final bool allSelected;
//
//   const SelectWidget({
//     super.key,
//     this.allSelected = false,
//   });
//
//   @override
//   State<SelectWidget> createState() => _SelectWidgetState();
// }
//
// class _SelectWidgetState extends State<SelectWidget> {
//   bool isSelected = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Checkbox(
//       value: widget.allSelected ? widget.allSelected : isSelected,
//       activeColor: CommonColor.themColor309D9D,
//       onChanged: (value) {
//         setState(() {
//           isSelected = value!;
//         });
//       },
//     );
//   }
// }
