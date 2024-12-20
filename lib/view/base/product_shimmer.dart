import 'package:flutter/material.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/view/base/rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ProductShimmer extends StatelessWidget {
  final bool? isEnabled;
  ProductShimmer({@required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      enabled: true,
      child: Container(
        height: 85,
        padding: EdgeInsets.symmetric(
            vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
            horizontal: Dimensions.PADDING_SIZE_SMALL),
        margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT),
        decoration: BoxDecoration(
            color: ColorResources.getScaffoldBackgroundColor(context),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Provider.of<ThemeProvider>(context).darkTheme
                    ? Colors.black.withOpacity(0.4)
                    : Colors.grey[300]!,
                blurRadius: 5,
                spreadRadius: 1,
              )
            ]),
        child: Row(children: [
          Container(
            height: 85,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[
                  Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300]!,
            ),
          ),
          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 15,
                    width: 200,
                    color: Colors.grey[
                        Provider.of<ThemeProvider>(context).darkTheme
                            ? 900
                            : 300]!,
                  ),
                  SizedBox(height: 5),
                  RatingBar(rating: 0.0, size: 17),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Container(
                        height: 10,
                        width: 70,
                        color: Colors.grey[
                            Provider.of<ThemeProvider>(context).darkTheme
                                ? 900
                                : 300]!,
                      ),
                      SizedBox(width: 5),
                      Container(
                        height: 10,
                        width: 50,
                        color: Colors.grey[
                            Provider.of<ThemeProvider>(context).darkTheme
                                ? 900
                                : 300]!,
                      ),
                    ],
                  ),
                ]),
          )),
          SizedBox(width: 10),
          Column(children: [
            Icon(Icons.favorite_border, color: ColorResources.COLOR_GREY),
            Expanded(child: SizedBox()),
            Icon(Icons.add, color: ColorResources.COLOR_GREY),
          ]),
        ]),
      ),
    );
  }
}
