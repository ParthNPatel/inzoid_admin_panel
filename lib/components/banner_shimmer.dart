import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import '../constant/color_const.dart';
import '../responsive/responsive.dart';

class BannerShimmer extends StatelessWidget {
  const BannerShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: ListView.builder(
        //reverse: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        itemCount: 3,
        shrinkWrap: true,
        itemBuilder: (context, index) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Stack(
              children: [
                Container(
                  height: 250,
                  width: 450,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Positioned(
                  top: 4.sp,
                  right: 4.sp,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    child: InkWell(
                      onTap: () {},
                      child: Icon(Icons.delete, size: 20, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
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
