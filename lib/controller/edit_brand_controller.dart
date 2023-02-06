import 'package:get/get.dart';

class EditBrandController extends GetxController {
  String? docId;
  String? brandName;
  List? brandImage = [];
  List? brandIcon = [];

  void addBrandData({
    String? docId,
    String? brandName,
    List? brandIcon,
    List? brandImage,
  }) {
    this.docId = docId;
    this.brandName = brandName;
    this.brandImage = brandImage;
    this.brandIcon = brandIcon;
  }
}
