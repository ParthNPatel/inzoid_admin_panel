import 'package:flutter/material.dart';
import '../constant/color_const.dart';

class FavouriteButton extends StatefulWidget {
  const FavouriteButton({Key? key}) : super(key: key);

  @override
  State<FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton> {
  bool _isFavourite = false;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 15,
      backgroundColor: Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            _isFavourite = !_isFavourite;
          });
        },
        child: _isFavourite == true
            ? Icon(
                Icons.favorite,
                size: 20,
                color: CommonColor.red,
              )
            : Icon(
                Icons.favorite_border,
                size: 20,
                color: CommonColor.greyColor838589,
              ),
      ),
    );
  }
}
