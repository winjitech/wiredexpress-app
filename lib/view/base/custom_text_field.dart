import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/language_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/utill/styles.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final Color? fillColor;
  final int? maxLines;
  final bool? isPassword;
  final bool? isCountryPicker;
  final bool? isShowBorder;
  final bool? isIcon;
  final bool? isShowSuffixIcon;
  final bool? isShowPrefixIcon;
  final VoidCallback? onTap;
  final Function(String)? onChanged, onSubmit;
  final VoidCallback? onSuffixTap;
  final String? suffixIconUrl;
  final String? prefixIconUrl;
  final bool? isSearch;
  final bool? isEnabled, fill;
  final TextCapitalization? capitalization;
  final bool? dontEdit, putDefaultCountryCode;
  final String? labelText;
  final double? radius;

  CustomTextField({
    this.hintText = 'Write something...',
    this.labelText,
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.isEnabled = true,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.maxLines = 1,
    this.onSuffixTap,
    this.fillColor,
    this.onSubmit,
    this.onChanged,
    this.capitalization = TextCapitalization.none,
    this.isCountryPicker = false,
    this.isShowBorder = false,
    this.isShowSuffixIcon = false,
    this.isShowPrefixIcon = false,
    this.onTap,
    this.isIcon = false,
    this.isPassword = false,
    this.suffixIconUrl,
    this.prefixIconUrl,
    this.isSearch = false,
    this.dontEdit = false,
    this.radius,
    this.fill = false,
    this.putDefaultCountryCode = true,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context, listen: false).darkTheme;

    return TextField(
      readOnly: this.widget.dontEdit!,
      maxLines: widget.maxLines,
      controller: widget.controller,
      focusNode: widget.focusNode,
      style: AppTextStyles.h8(
        context,
      ).copyWith(color: isDark ? Colors.white : Colors.black),
      textInputAction: widget.inputAction,
      keyboardType: widget.inputType,
      cursorColor: ColorResources.getPrimaryColor(context),
      textCapitalization: widget.capitalization!,
      enabled: widget.isEnabled,
      autofocus: false,
      //onChanged: widget.isSearch ? widget.languageProvider.searchLanguage : null,
      obscureText: widget.isPassword! ? _obscureText : false,
      inputFormatters: widget.inputType == TextInputType.phone
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp('[0-9+]')),
            ]
          : null,
      decoration: InputDecoration(
        prefixText: widget.controller != null && widget.controller!.text.isEmpty
            ? null
            : widget.inputType != TextInputType.phone
                ? ''
                : widget.inputType == TextInputType.phone &&
                        widget.putDefaultCountryCode!
                    // ? '+251 '
        ?''
                    : '',
        contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 22.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular((widget.radius ?? 8).r),
          borderSide: BorderSide(
            width: widget.isShowBorder == false ? 0 : 0.2,
            color: widget.isShowBorder == false
                ? Colors.transparent
                : ColorResources.getBorderColor(context),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular((widget.radius ?? 8).r),
          borderSide: BorderSide(
            width: widget.isShowBorder == false ? 0 : 0.2,
            color: widget.isShowBorder == false
                ? Colors.transparent
                : ColorResources.getBorderColor(context),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular((widget.radius ?? 8).r),
          borderSide: BorderSide(
            width: widget.isShowBorder == false ? 0 : 0.2,
            color: widget.isShowBorder == false
                ? Colors.transparent
                : ColorResources.getBorderColor(context),
          ),
        ),
        isDense: true,
        labelText: widget.labelText,
        labelStyle: AppTextStyles.h9(context, fontSize: 13.sp)
            .copyWith(color: ColorResources.COLOR_GREY_CHATEAU),
        hintText: widget.hintText,
        fillColor: widget.fillColor ?? Colors.grey[150],
        hintStyle: GoogleFonts.rubik(
          color: Color(isDark ? 0xBFFFFFFF : 0xFF8391A1),
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
        filled: widget.fill == true ? true : false,
        prefixIcon: widget.isShowPrefixIcon!
            ? Padding(
                padding: EdgeInsets.only(left: 12.w, right: 15.w),
                child: Image.asset(
                  widget.prefixIconUrl!,
                  color: Colors.grey[500],
                ),
              )
            : SizedBox.shrink(),
        prefixIconConstraints: BoxConstraints(minWidth: 23.w, maxHeight: 20.h),
        suffixIcon: widget.isShowSuffixIcon!
            ? widget.isPassword!
                ? IconButton(
                    icon: Image.asset(
                      _obscureText
                          ? Images.visibilityOffIcon
                          : Images.visibilityIcon,
                      color: isDark ? Colors.white54 : Colors.black54,
                      width: 20.w,
                      height: 20.h,
                    ),
                    // icon: Icon(
                    //   _obscureText ? Icons.visibility_off : Icons.visibility,
                    //   color: isDark ? Colors.white54 : Colors.black54,
                    // ),
                    onPressed: _toggle,
                  )
                : widget.isIcon!
                    ? IconButton(
                        onPressed: widget.onSuffixTap!,
                        icon: Image.asset(
                          widget.suffixIconUrl!,
                          width: 15.w,
                          height: 15.h,
                          color: ColorResources.getTextColor(
                            context,
                          ).withOpacity(0.5),
                        ),
                      )
                    : null
            : null,
      ),
      onTap: widget.onTap,
      onSubmitted: widget.onSubmit,
      onChanged: widget.onChanged,
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
