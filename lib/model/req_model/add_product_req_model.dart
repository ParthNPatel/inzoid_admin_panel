String category = "Deal";
String subCategory = "Shirts";
String season = "Summer";
String material = "Cotton";

class AddProductReqModel {
  String? productName;
  String? brand;
  String? price;
  String? oldPrice;
  String? description;
  List? listOfImage;
  String? category;
  String? subCategory;
  String? season;
  String? material;
  List? color;
  String? productId;
  List? sizes;
  int? quantity;

  AddProductReqModel(
      {this.productName,
      this.brand,
      this.price,
      this.oldPrice,
      this.description,
      this.listOfImage,
      this.category,
      this.subCategory,
      this.season,
      this.material,
      this.productId,
      this.color,
      this.sizes,
      this.quantity});
  Map<String, dynamic> toJson() {
    return {
      "productName": productName,
      "brand": brand,
      "price": price,
      "oldPrice": oldPrice,
      "description": description,
      "listOfImage": listOfImage,
      "category": category,
      "subCategory": subCategory,
      "season": season,
      "material": material,
      "color": color,
      'sizes': sizes,
      'quantity': quantity,
      "create_time": DateTime.now().toString(),
      "productId": productId
    };
  }
}
