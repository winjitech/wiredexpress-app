import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wired_express/provider/order_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class OrderShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      padding: EdgeInsets.all(15),
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
          children: [
            Shimmer(
              duration: const Duration(seconds: 2),
              enabled: true,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                decoration: BoxDecoration(
                  color: ColorResources.getScaffoldBackgroundColor(context),
                  boxShadow: [
                    BoxShadow(
                      color: Provider.of<ThemeProvider>(context).darkTheme
                          ? Colors.black.withOpacity(0.4)
                          : Colors.grey[300]!,
                      blurRadius: 5,
                      spreadRadius: 1,
                    )
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(children: [
                  Container(
                    height: 180,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.grey[
                            Provider.of<ThemeProvider>(context).darkTheme
                                ? 900
                                : 300]!,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 15,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.grey[
                                Provider.of<ThemeProvider>(context).darkTheme
                                    ? 900
                                    : 300]!,
                            borderRadius: BorderRadius.circular(40)),
                      ),
                      Container(
                        height: 15,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.grey[
                                Provider.of<ThemeProvider>(context).darkTheme
                                    ? 900
                                    : 300]!,
                            borderRadius: BorderRadius.circular(40)),
                      ),
                      Container(
                        height: 15,
                        width: 60,
                        decoration: BoxDecoration(
                            color: Colors.grey[
                                Provider.of<ThemeProvider>(context).darkTheme
                                    ? 900
                                    : 300]!,
                            borderRadius: BorderRadius.circular(40)),
                      ),
                      Container(
                        height: 15,
                        width: 120,
                        decoration: BoxDecoration(
                            color: Colors.grey[
                                Provider.of<ThemeProvider>(context).darkTheme
                                    ? 900
                                    : 300]!,
                            borderRadius: BorderRadius.circular(40)),
                      ),
                      Container(
                        height: 30,
                        width: 190,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey[
                                    Provider.of<ThemeProvider>(context)
                                            .darkTheme
                                        ? 900
                                        : 300]!,
                                width: 1.6),
                            borderRadius: BorderRadius.circular(40)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          child: Container(
                            height: 20,
                            width: 60,
                            decoration: BoxDecoration(
                                color: Colors.grey[
                                    Provider.of<ThemeProvider>(context)
                                            .darkTheme
                                        ? 900
                                        : 300]!,
                                borderRadius: BorderRadius.circular(40)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        );
      },
    );
  }
}
