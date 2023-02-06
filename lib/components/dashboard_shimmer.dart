import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import '../constant/color_const.dart';
import '../responsive/responsive.dart';

class ProductShimmer extends StatelessWidget {
  const ProductShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: ListView.builder(
        padding: EdgeInsets.only(left: 25, top: 25),
        physics: NeverScrollableScrollPhysics(),
        itemCount: 10,
        shrinkWrap: true,
        itemBuilder: (context, index) => Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  margin: EdgeInsets.only(top: 7, bottom: 7, right: 20),
                  decoration: BoxDecoration(
                    color: CommonColor.greyColorF2F2F2,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 50.sp,
                  child: Container(
                    height: 10,
                    width: 15.sp,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                SizedBox(
                  width: 50.sp,
                  child: Container(
                    height: 10,
                    width: 15.sp,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 50.sp,
                  child: Container(
                    height: 10,
                    width: 15.sp,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  child: Container(
                    height: 10,
                    width: 15.sp,
                    color: Colors.grey,
                  ),
                  width: 50.sp,
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 50.sp,
                  child: Container(
                    height: 10,
                    width: 15.sp,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                // SizedBox(
                //   width: 50.sp,
                //   child:
                //       CommonText.textBoldWight700(text: subCategory, fontSize: 15),
                // ),
                // SizedBox(
                //   width: 10,
                // ),
                SizedBox(
                  width: 30.sp,
                  child: Container(
                    height: 10,
                    width: 15.sp,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                // SizedBox(
                //   width: 50.sp,
                //   child: CommonText.textBoldWight700(text: season, fontSize: 15),
                // ),
                // SizedBox(
                //   width: 10,
                // ),
                SizedBox(
                  width: 50.sp,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 10,
                        width: 10.sp,
                        color: Colors.grey,
                      ),
                      Icon(
                        Icons.star,
                        size: 15,
                        color: CommonColor.yellowColor,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 10.sp,
                  width: 10.sp,
                  decoration: BoxDecoration(
                      border: Border.all(color: themColors309D9D, width: 1),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 10.sp,
                  width: 10.sp,
                  decoration: BoxDecoration(
                      border: Border.all(color: themColors309D9D, width: 1),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 10.sp,
                  width: 10.sp,
                  decoration: BoxDecoration(
                      border: Border.all(color: themColors309D9D, width: 1),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey),
                ),
              ],
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
          ],
        ),
      ),
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey,
      direction: ShimmerDirection.ltr,
    );
  }
}
