import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inzoid_admin_panel/controller/edit_brand_controller.dart';
import 'package:inzoid_admin_panel/controller/edit_category_controller.dart';
import 'package:inzoid_admin_panel/controller/handle_screen_controller.dart';
import 'package:inzoid_admin_panel/view/add_product_screen.dart';
import 'package:inzoid_admin_panel/view/edit_product_screen.dart';
import 'package:inzoid_admin_panel/view/home_page.dart';
import 'package:sizer/sizer.dart';
import 'constant/color_const.dart';
import 'controller/edit_product_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyB4SSDorKo9AoNlCnMbCnsTUC0_GhOplLA",
        authDomain: "inzoid-7e1fd.firebaseapp.com",
        projectId: "inzoid-7e1fd",
        storageBucket: "inzoid-7e1fd.appspot.com",
        messagingSenderId: "29888324953",
        appId: "1:29888324953:web:6e4ca7f9d169e3b886d848",
        measurementId: "G-ZC2GP12ZLN"),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => GetMaterialApp(
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSwatch().copyWith(primary: themColors309D9D),
        ),
        // home: HomePage(),
        debugShowCheckedModeBanner: false, initialBinding: BaseBindings(),
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(),
          '/AddProduct': (context) => AddProductScreen(),
          '/EditProduct': (context) => EditProductScreen(),
        },
        title: 'Inzoid Admin Panel',
      ),
    );
  }
}

class BaseBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditProductController(), fenix: true);
    Get.lazyPut(() => HandleScreenController(), fenix: true);
    Get.lazyPut(() => EditCategoryController(), fenix: true);
    Get.lazyPut(() => EditBrandController(), fenix: true);
  }
}
