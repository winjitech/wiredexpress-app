import 'package:flutter/material.dart';
import 'package:wired_express/utill/color_resources.dart';

class CustomButton extends StatefulWidget {
  final double? width, height, radius, textSize;
  final Color? backgroundColor, textColor , borderColor;
  final String? text;
  final VoidCallback? onTap;

  const CustomButton(
      {super.key,
        this.width,
        this.height,
        this.backgroundColor,
        this.textColor,
        required  this.text,
        this.radius,
        this.onTap, this.textSize, this.borderColor});
  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(elevation: 0,
      onPressed: widget.onTap,
      child: Text(
        widget.text!,
        style: TextStyle(
            color: widget.textColor ??
                ColorResources.getScaffoldBackgroundColor(context),
            fontWeight: FontWeight.w600,
            fontSize: widget.textSize??18),
      ),
      color: widget.backgroundColor ?? ColorResources.getPrimaryColor(context),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.radius ?? 40) , side: BorderSide(color: widget.borderColor??Colors.transparent)),
      minWidth: widget.width ?? MediaQuery.of(context).size.width,
      height: widget.height ?? 50,
    );
  }
}
