import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CountShimmer extends StatelessWidget {
  const CountShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: Container(
        height: 15,
        width: 30,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey,
      direction: ShimmerDirection.ltr,
    );
  }
}
