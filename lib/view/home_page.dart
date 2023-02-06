import 'package:flutter/material.dart';
import 'package:inzoid_admin_panel/components/common_widget.dart';
import 'package:inzoid_admin_panel/constant/color_const.dart';
import 'package:inzoid_admin_panel/constant/text_styel.dart';
import 'package:inzoid_admin_panel/controller/handle_screen_controller.dart';
import 'package:inzoid_admin_panel/responsive/responsive.dart';
import 'package:inzoid_admin_panel/view/add_product_screen.dart';
import 'package:inzoid_admin_panel/view/edit_product_screen.dart';
import 'package:inzoid_admin_panel/view/sub_category_screen.dart';
import 'package:inzoid_admin_panel/view/users_screen.dart';
import 'package:sizer/sizer.dart';
import 'brands_screen.dart';
import 'add_category_screen.dart';
import 'banner_screen.dart';
import 'categories_screen.dart';
import 'dashboard_screen.dart';
import 'edit_category_screen.dart';
import 'notifications_screen.dart';
import 'products_screen.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();

  List<Map<String, dynamic>> items = [
    {'name': "Dashboard", 'image': 'assets/images/dashboard.svg'},
    {'name': "Users", 'image': 'assets/images/dashboard.svg'},
    {'name': "Category", 'image': 'assets/images/inbox.svg'},
    {'name': "Sub Category", 'image': 'assets/images/inbox.svg'},
    {'name': "Products", 'image': 'assets/images/add_product.svg'},
    {'name': "Banner", 'image': 'assets/images/banner.svg'},
    {'name': "Brands", 'image': 'assets/images/banner.svg'},
    {'name': "Notification", 'image': 'assets/images/notification.svg'},
    {'name': "Support", 'image': 'assets/images/support.svg'},
  ];

  int selected = 0;

  HandleScreenController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:
          Responsive.isDesktop(context) ? SizedBox() : drawerWidget(context),
      body: GetBuilder<HandleScreenController>(
        builder: (controller) => Row(
          children: [
            Flexible(
              flex: 2,
              child: Container(
                width: 40.w,
                decoration: BoxDecoration(color: Color(0xffecf4f4), boxShadow: [
                  BoxShadow(
                      color: CommonColor.greyColorD9D9D9,
                      blurRadius: 2,
                      spreadRadius: 2,
                      offset: Offset(0, 1))
                ]),
                child: Column(
                  children: [
                    SizedBox(
                      height: 2.h,
                    ),
                    CircleAvatar(
                      radius: 15.sp,
                      backgroundImage: AssetImage('assets/images/user.png'),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Column(
                      children: [
                        CommonText.textBoldWight500(
                            text: "Naman Sharma", fontSize: 8.sp),
                        SizedBox(
                          height: 3.sp,
                        ),
                        CommonText.textBoldWight500(
                            textDecoration: TextDecoration.underline,
                            text: "View Profile",
                            fontSize: 5.sp,
                            color: themColors309D9D),
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Column(
                      children: List.generate(
                        items.length,
                        (index) => InkWell(
                          onTap: () {
                            setState(() {
                              selected = index;
                            });
                          },
                          child: Container(
                            height: 20.sp,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: selected == index
                                    ? Colors.grey.withOpacity(0.2)
                                    : blueColor),
                            child: Padding(
                              padding: EdgeInsets.only(left: 4.w),
                              child: Row(
                                children: [
                                  CommonWidget.commonSvgPitcher(
                                      image: items[index]['image'],
                                      height: 10.sp,
                                      width: 10.sp,
                                      color: selected == index
                                          ? themColors309D9D
                                          : Colors.grey.shade400),
                                  SizedBox(
                                    width: 3.w,
                                  ),
                                  CommonText.textBoldWight500(
                                      text: items[index]['name'],
                                      fontSize: 5.sp,
                                      fontWeight: selected == index
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      color: selected == index
                                          ? Colors.black
                                          : Colors.grey),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            selected == 0
                ? DashBoardScreen()
                : selected == 1
                    ? UsersScreen()
                    : selected == 3
                        ? SubCategoriesScreen()
                        : selected == 2
                            ? controller.isTapped2 == true
                                ? AddCategoryScreen()
                                : controller.isTapped3 == true
                                    ? EditCategoryScreen()
                                    : CategoriesScreen()
                            : selected == 4
                                ? controller.isTapped == true
                                    ? AddProductScreen()
                                    : controller.isTapped1 == true
                                        ? EditProductScreen()
                                        : ProductsScreen()
                                : selected == 5
                                    ? BannerScreen()
                                    : selected == 6
                                        ? BrandsScreen()
                                        : selected == 7
                                            ? NotificationScreen()
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: Responsive.isDesktop(
                                                            context)
                                                        ? 200.sp
                                                        : 70.sp,
                                                  ),
                                                  Text(
                                                    "Coming Soon...",
                                                    textScaleFactor: 2,
                                                  ),
                                                ],
                                              )
          ],
        ),
      ),
    );
  }

  Drawer drawerWidget(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 2.h,
          ),
          CircleAvatar(
            radius: 15.sp,
            backgroundImage: AssetImage('assets/images/user.png'),
          ),
          SizedBox(
            height: 1.h,
          ),
          Column(
            children: [
              CommonText.textBoldWight500(text: "Naman Sharma", fontSize: 8.sp),
              SizedBox(
                height: 3.sp,
              ),
              CommonText.textBoldWight500(
                  textDecoration: TextDecoration.underline,
                  text: "View Profile",
                  fontSize: 5.sp,
                  color: themColors309D9D),
            ],
          ),
          SizedBox(
            height: 2.h,
          ),
          Column(
            children: List.generate(
              4,
              (index) => InkWell(
                onTap: () {
                  setState(() {
                    selected = index;
                  });
                },
                child: Container(
                  height: 25.sp,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: selected == index
                          ? Colors.grey.withOpacity(0.2)
                          : Colors.white),
                  child: Padding(
                    padding: EdgeInsets.only(left: 2.w),
                    child: Row(
                      children: [
                        CommonWidget.commonSvgPitcher(
                            image: items[index]['image'],
                            height: 10.sp,
                            width: 10.sp,
                            color: selected == index
                                ? themColors309D9D
                                : Colors.grey.shade400),
                        SizedBox(
                          width: 3.w,
                        ),
                        CommonText.textBoldWight500(
                            text: items[index]['name'],
                            fontSize: 5.sp,
                            color:
                                selected == index ? Colors.black : Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
