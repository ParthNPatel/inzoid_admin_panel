import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../components/common_widget.dart';
import '../components/count_shimmer.dart';
import '../constant/text_styel.dart';
import '../responsive/responsive.dart';
import 'package:http/http.dart' as http;

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  static Future<bool?> sendMessageForPersonalUser({
    String? receiverFcmToken,
    String? msg,
    bool isRing = false,
  }) async {
    var serverKey =
        'AAAABvV7pVk:APA91bHr9KJl9LPJUpd41xZ_1x50wRo1RMp1zzyNy_-y3wi45gPC_AyBLmqNymdbewTPbQD1vk7cJfKgQ_n2PMaygygeCv37tq_XYXdTvTPY168105zmeF5UXFljL3gzpl4_gMemYyM-';
    try {
      // for (String token in receiverFcmToken) {
      // log("RESPONSE TOKEN  $receiverFcmToken");

      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode(
          <String, dynamic>{
            "priority": "high",
            'notification': <String, dynamic>{
              'body': msg ?? 'msg',
              'title': 'plusApp',
              'bodyLocKey': 'true',
              "content_available": true,
              // "sound": "iphone1.mp3"
            },
            'data': <String, dynamic>{
              'click_action': isRing,
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

  static Future<bool?> sendMessageForAlluser({
    dynamic msg,
    bool isRing = false,
  }) async {
    var serverKey =
        'AAAABvV7pVk:APA91bHr9KJl9LPJUpd41xZ_1x50wRo1RMp1zzyNy_-y3wi45gPC_AyBLmqNymdbewTPbQD1vk7cJfKgQ_n2PMaygygeCv37tq_XYXdTvTPY168105zmeF5UXFljL3gzpl4_gMemYyM-';
    try {
      // for (String token in receiverFcmToken) {
      // log("RESPONSE TOKEN  $receiverFcmToken");

      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode(
          <String, dynamic>{
            'to': '/topics/all',

            // 'topic': "all",
            "priority": "high",
            'notification': <String, dynamic>{
              'body': msg ?? 'msg',
              'title': 'plusApp',
              'bodyLocKey': 'true',
              "content_available": true,
              // "sound": "iphone1.mp3"
            },
            'data': <String, dynamic>{
              'click_action': isRing,
              'id': '1',
              'status': 'done'
            },
            // 'android': {
            //   'notification': {
            //     'channel_id': 'high_importance_channel',
            //   },
            // },
            // 'apns': {
            //   'headers': {
            //     // "apns-push-type":
            //     //     "background", // This line prevents background notification
            //     "apns-priority": "10",
            //   },
            // },
            // "webpush": {
            //   "headers": {"Urgency": "high"}
            // },
            // 'to': receiverFcmToken,
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

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 8,
      child: Padding(
        padding: EdgeInsets.only(left: 20, top: 20),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: Column(
              children: [
                GridView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: Responsive.isDesktop(context) ? 4 : 2,
                    mainAxisExtent: 350,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  children: [
                    Container(
                      height: 350,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xffdee0ef),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CommonWidget.commonSvgPitcher(
                              image: 'assets/images/add_product.svg',
                              height: 70,
                              width: 70,
                              color: Colors.black),
                          SizedBox(
                            height: 15,
                          ),
                          CommonText.textBoldWight500(
                              text: 'Total Products', fontSize: 7.sp),
                          SizedBox(
                            height: 10,
                          ),
                          FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('Admin')
                                .doc('all_product')
                                .collection('product_data')
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var total;
                                try {
                                  total = snapshot.data!.docs.length;
                                } catch (e) {
                                  total = 0;
                                }
                                return CommonText.textBoldWight500(
                                  text: '${total}',
                                  fontSize: 7.sp,
                                  fontWeight: FontWeight.bold,
                                );
                              } else {
                                return CountShimmer();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 350,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xffeedad9),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CommonWidget.commonSvgPitcher(
                              image: 'assets/images/inbox.svg',
                              height: 70,
                              width: 70,
                              color: Colors.black),
                          SizedBox(
                            height: 15,
                          ),
                          CommonText.textBoldWight500(
                              text: 'Total Categories', fontSize: 7.sp),
                          SizedBox(
                            height: 10,
                          ),
                          FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('Admin')
                                .doc('categories')
                                .collection('categories_list')
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var total;
                                try {
                                  total = snapshot.data!.docs.length;
                                } catch (e) {
                                  total = 0;
                                }
                                return CommonText.textBoldWight500(
                                  text: '${total}',
                                  fontSize: 7.sp,
                                  fontWeight: FontWeight.bold,
                                );
                              } else {
                                return CountShimmer();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 350,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xffddefe1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CommonWidget.commonSvgPitcher(
                              image: 'assets/images/banner.svg',
                              height: 70,
                              width: 70,
                              color: Colors.black),
                          SizedBox(
                            height: 15,
                          ),
                          CommonText.textBoldWight500(
                              text: 'Total banners', fontSize: 7.sp),
                          SizedBox(
                            height: 10,
                          ),
                          FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('Admin')
                                .doc('banners')
                                .collection('banner_list')
                                .get(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                var total;

                                try {
                                  // log("===>>>${snapshot.data.docs[0]['is_check']}");
                                  print("===>>>${snapshot.data}");
                                  total = snapshot.data!.docs.length;
                                } catch (e) {
                                  total = 0;
                                }
                                return CommonText.textBoldWight500(
                                  text: '${total}',
                                  fontSize: 7.sp,
                                  fontWeight: FontWeight.bold,
                                );
                              } else {
                                return CountShimmer();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    // Container(
                    //   height: 250,
                    //   width: 250,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(5),
                    //     color: Color(0xff93dee4),
                    //   ),
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       CommonWidget.commonSvgPitcher(
                    //         image: 'assets/images/valuation.svg',
                    //         height: 70,
                    //         width: 70,
                    //         color: themColors309D9D,
                    //       ),
                    //       SizedBox(
                    //         height: 15,
                    //       ),
                    //       CommonText.textBoldWight500(
                    //           text: 'Property Enquiries', fontSize: 7.sp),
                    //       SizedBox(
                    //         height: 10,
                    //       ),
                    //       FutureBuilder(
                    //         future: FirebaseFirestore.instance
                    //             .collection('Admin')
                    //             .doc('inquires_list')
                    //             .collection('get_a_free_valuation')
                    //             .get(),
                    //         builder: (context, AsyncSnapshot snapshot) {
                    //           if (snapshot.hasData) {
                    //             var total;
                    //             log("11===>>>${snapshot.data.docs.length}");
                    //             try {
                    //               return FutureBuilder(
                    //                 future: FirebaseFirestore.instance
                    //                     .collection('Admin')
                    //                     .doc('inquires_list')
                    //                     .collection('free_martgage_check')
                    //                     .get(),
                    //                 builder: (context, AsyncSnapshot inq) {
                    //                   if (inq.hasData) {
                    //                     print("22===>>>}");
                    //
                    //                     total = snapshot.data.docs.length +
                    //                         inq.data.docs.length;
                    //                     return CommonText.textBoldWight500(
                    //                       text: '${total}',
                    //                       fontSize: 7.sp,
                    //                       fontWeight: FontWeight.bold,
                    //                     );
                    //                   } else {
                    //                     return CountShimmer();
                    //                   }
                    //                 },
                    //               );
                    //               //log("===>>>${snapshot.data.docs[0]['is_check']}");
                    //
                    //             } catch (e) {
                    //               total = 0;
                    //             }
                    //             // return CommonText.textBoldWight500(
                    //             //   text: '${total}',
                    //             //   fontSize: 7.sp,
                    //             //   fontWeight: FontWeight.bold,
                    //             // );
                    //             return SizedBox();
                    //           } else {
                    //             return CountShimmer();
                    //           }
                    //         },
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
