import 'package:get/get.dart';

class EditCategoryController extends GetxController {
  String? docId;
  String? categoryName;
  List? categoryImage = [];
  String? data;

  addCategoryData({
    String? docId,
    String? categoryName,
    List? categoryImage,
    String? data,
  }) {
    this.docId = docId;
    this.data = data;
    this.categoryName = categoryName;
    this.categoryImage = categoryImage;
  }
}
