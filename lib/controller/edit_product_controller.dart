import 'package:get/get.dart';

class EditProductController extends GetxController {
  String? docId;
  String? productName;
  String? brand;
  String? price;
  String? oldPrice;
  String? description;
  List? listOfImage = [];
  String? category;
  String? subCategory;
  String? season;
  String? material;
  String? quantity;
  List? color;

  void addProductData(
      {String? productName,
      String? brand,
      String? price,
      String? oldPrice,
      String? description,
      List? listOfImage,
      String? category,
      String? subCategory,
      String? season,
      String? material,
      List? color,
      String? quantity,
      String? docId}) {
    this.productName = productName;
    this.brand = brand;
    this.price = price;
    this.oldPrice = oldPrice;
    this.description = description;
    this.listOfImage = listOfImage;
    this.category = category;
    this.subCategory = subCategory;
    this.season = season;
    this.material = material;
    this.color = color;
    this.quantity = quantity;
    this.docId = docId;
  }
}
