import 'package:wired_express/utill/color_resources.dart';
import 'package:flutter/material.dart';

class CustomCircularIndicator extends StatelessWidget {
  final Color? color;

  const CustomCircularIndicator({super.key, this.color});
  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
                color ?? ColorResources.getPrimaryColor(context))));
  }
}
