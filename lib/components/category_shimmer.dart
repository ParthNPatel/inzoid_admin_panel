import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import '../responsive/responsive.dart';

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: 10,
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        shrinkWrap: true,
        itemBuilder: (context, index) => Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Container(
              height: 100,
              width: 100,
              margin: EdgeInsets.only(right: 20, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              height: 10,
              width: 20.sp,
              margin: EdgeInsets.only(right: 20, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              height: 10.sp,
              width: 10.sp,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
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
                  border: Border.all(color: Colors.grey, width: 1),
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
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey),
            ),
            SizedBox(
              width: 12,
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
