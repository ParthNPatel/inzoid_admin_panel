import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inzoid_admin_panel/constant/color_const.dart';
import 'package:inzoid_admin_panel/controller/edit_product_controller.dart';
import 'package:inzoid_admin_panel/controller/handle_screen_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import '../components/common_widget.dart';
import '../components/dashboard_shimmer.dart';
import '../components/product_tile.dart';
import '../constant/image_const.dart';
import '../constant/text_styel.dart';

class ProductsScreen extends StatefulWidget {
  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  EditProductController editProductController = Get.find();

  List<Map<String, dynamic>> data = [
    {
      'image': ImageConst.women3,
      'title': 'CLAUDETTE CORSET',
      'subtitle': 'TMP Company',
      'price': '₹999,00',
      'oldPrice': '₹1299,00',
      'rating': '(200 Ratings)'
    },
    {
      'image': ImageConst.women4,
      'title': ' Tailored FULL Skirta',
      'subtitle': 'TMP Company',
      'price': '₹999,00',
      'oldPrice': '₹1299,00',
      'rating': '(200 Ratings)'
    },
    {
      'image': ImageConst.women5,
      'title': 'CLAUDETTE CORSET',
      'subtitle': 'TMP Company',
      'price': '₹999,00',
      'oldPrice': '₹1299,00',
      'rating': '(200 Ratings)'
    },
    {
      'image': ImageConst.women6,
      'title': ' Tailored FULL Skirta',
      'subtitle': 'TMP Company',
      'price': '₹999,00',
      'oldPrice': '₹1299,00',
      'rating': '(200 Ratings)'
    },
  ];

  String searchText = '';

  TextEditingController searchController = TextEditingController();

  HandleScreenController handleScreenController = Get.find();

  String category = 'All';

  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 9,
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
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
                          color: blueColor,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 25,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 100,
                                width: 100,
                                margin: EdgeInsets.only(bottom: 7, right: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 50.sp,
                                child: CommonText.textBoldWight700(
                                    text: "Product Name", fontSize: 15),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                width: 50.sp,
                                child: CommonText.textBoldWight700(
                                    text: "Brand", fontSize: 15),
                              ),
                              SizedBox(
                                width: 1.w,
                              ),
                              SizedBox(
                                width: 50.sp,
                                child: CommonText.textBoldWight700(
                                    text: "Price", fontSize: 15),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                child: CommonText.textBoldWight700(
                                    text: "Old Price", fontSize: 15),
                                width: 50.sp,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 50.sp,
                                child: CommonText.textBoldWight700(
                                    text: "Category", fontSize: 15),
                              ),
                              // SizedBox(
                              //   width: 10,
                              // ),
                              // SizedBox(
                              //   width: 50.sp,
                              //   child: CommonText.textBoldWight700(
                              //       text: "Sub Category", fontSize: 15),
                              // ),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 30.sp,
                                child: CommonText.textBoldWight700(
                                    text: "Material", fontSize: 15),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              // SizedBox(
                              //   width: 50.sp,
                              //   child: CommonText.textBoldWight700(
                              //       text: 'Season', fontSize: 15),
                              // ),
                              SizedBox(
                                width: 50.sp,
                                child: CommonText.textBoldWight700(
                                    text: "Quantity", fontSize: 15),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection('Admin')
                                    .doc('categories')
                                    .collection('categories_list')
                                    .get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<
                                            QuerySnapshot<Map<String, dynamic>>>
                                        snapshot) {
                                  if (snapshot.hasData) {
                                    return Container(
                                      height: 14.sp,
                                      width: 45.sp,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          border:
                                              Border.all(color: Colors.grey)),
                                      child: Center(
                                        child: DropdownButton(
                                          underline: SizedBox(),
                                          hint: Text("All"),
                                          disabledHint: Text("All"),
                                          value: category,
                                          items: snapshot.data!.docs.map((e) {
                                            return DropdownMenuItem(
                                              child: Text(e['category_name']),
                                              value: e['category_name'],
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              category = value as String;
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      products(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> products() {
    return StreamBuilder<QuerySnapshot>(
      stream: category == 'All'
          ? FirebaseFirestore.instance
              .collection('Admin')
              .doc('all_product')
              .collection('product_data')
              .orderBy('create_time', descending: true)
              .snapshots()
          : FirebaseFirestore.instance
              .collection('Admin')
              .doc('all_product')
              .collection('product_data')
              .orderBy('create_time', descending: true)
              .where('category', isEqualTo: category)
              .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<DocumentSnapshot> products = snapshot.data!.docs;
          print("length======>${products.length}");
          if (searchText.isNotEmpty) {
            products = products.where((element) {
              return element
                  .get('productName')
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase());
            }).toList();
          }
          return GetBuilder<HandleScreenController>(
            builder: (controller) => ListView.builder(
              //reverse: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: products.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 25, top: 25),
              itemBuilder: (context, index) =>
                  products[index].get("productName") == "All"
                      ? SizedBox()
                      : ProductTile(
                          onEdit: () {
                            editProductController.listOfImage!.clear();
                            editProductController.addProductData(
                              docId: products[index].id,
                              listOfImage: products[index].get("listOfImage"),
                              productName: products[index].get("productName"),
                              brand: products[index].get("brand"),
                              price: products[index].get("price"),
                              oldPrice: products[index].get("oldPrice"),
                              color: products[index].get("color"),
                              category: products[index].get("category"),
                              description: products[index].get("description"),
                              material: products[index].get("material"),
                              season: products[index].get("season"),
                              subCategory: products[index].get("subCategory"),
                              quantity:
                                  products[index].get("quantity").toString(),
                            );
                            controller.changeTapped1(true);
                            // Get.to(() => EditProductScreen());
                            //Navigator.pushNamed(context, '/EditProduct');
                          },
                          image: products[index].get("listOfImage")[0],
                          title: products[index].get("productName"),
                          subtitle: products[index].get("brand"),
                          price: products[index].get("price"),
                          oldPrice: products[index].get("oldPrice"),
                          category: products[index].get("category"),
                          material: products[index].get("material"),
                          quantity: products[index].get("quantity"),
                          onAdd: () {
                            controller.changeTapped(true);
                          },
                          onDelete: () {
                            Get.dialog(AlertDialog(
                              title: Text(
                                  "Are you sure that you want to delete this product?"),
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
                                        .doc('all_product')
                                        .collection('product_data')
                                        .doc(products[index].id)
                                        .delete();
                                    Get.back();
                                  },
                                  child: Text('YES'),
                                ),
                              ],
                            ));
                          },
                          season: products[index].get("season"),
                          subCategory: products[index].get("subCategory"),
                          rating: '(200 Ratings)',
                        ),
            ),
          );
        } else {
          return ProductShimmer();
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
            width: 80.sp,
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
          GetBuilder<HandleScreenController>(
            builder: (controller) => CommonWidget.commonButton(
                onTap: () {
                  controller.changeTapped(true);
                },
                text: "Add New Product",
                radius: 40),
          ),
          SizedBox(
            width: 6.sp,
          ),
        ],
      ),
    );
  }
}
