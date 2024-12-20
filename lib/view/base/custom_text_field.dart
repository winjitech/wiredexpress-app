import 'package:flutter/material.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/language_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
  final Function(String)? onChanged;
  final VoidCallback? onSuffixTap;
  final String? suffixIconUrl;
  final String? prefixIconUrl;
  final bool? isSearch;
  final Function? onSubmit;
  final bool? isEnabled;
  final TextCapitalization? capitalization;
  final bool? dontEdit;
  final String? labelText;

  CustomTextField({
    this.hintText ,
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
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: this.widget.dontEdit!,
      maxLines: widget.maxLines,
      controller: widget.controller,
      focusNode: widget.focusNode,
      style: TextStyle(
          color: Provider.of<ThemeProvider>(context, listen: false).darkTheme
              ? Colors.white
              : Colors.black,
          fontSize: 12),
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
              FilteringTextInputFormatter.allow(RegExp('[0-9+]'))
            ]
          : null,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 22),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40.0),
          borderSide: BorderSide(
              width: widget.isShowBorder == false ? 0 : 0.2,
              color: widget.isShowBorder == false
                  ? Colors.transparent
                  : Provider.of<ThemeProvider>(context, listen: false).darkTheme
                      ? Colors.white54
                      : Colors.black54),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40.0),
          borderSide: BorderSide(
              width: widget.isShowBorder == false ? 0 : 0.2,
              color: widget.isShowBorder == false
                  ? Colors.transparent
                  : Provider.of<ThemeProvider>(context, listen: false).darkTheme
                      ? Colors.white54
                      : Colors.black54),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40.0),
          borderSide: BorderSide(
              width: widget.isShowBorder == false ? 0 : 0.2,
              color: widget.isShowBorder == false
                  ? Colors.transparent
                  : Provider.of<ThemeProvider>(context, listen: false).darkTheme
                      ? Colors.white54
                      : Colors.black54),
        ),
        isDense: true, labelText: widget.labelText,

        labelStyle: TextStyle(fontSize: 13, color: ColorResources.COLOR_GREY_CHATEAU),
        hintText: widget.hintText??getTranslated('write_something', context),
        fillColor: Colors.grey[150],
        // fillColor: Provider.of<ThemeProvider>(context, listen: false).darkTheme
        //     ? Colors.black
        //     : Colors.white,
        hintStyle: TextStyle(
            fontSize: 14, color: Colors.grey[500], fontWeight: FontWeight.w400),
        filled: true,
        prefixIcon: widget.isShowPrefixIcon!
            ? Padding(
                padding: const EdgeInsets.only(left: 12, right: 5),
                child: Image.asset(widget.prefixIconUrl!),
              )
            : SizedBox.shrink(),
        prefixIconConstraints: BoxConstraints(minWidth: 23, maxHeight: 20),
        suffixIcon: widget.isShowSuffixIcon!
            ? widget.isPassword!
                ? IconButton(
                    icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color:
                            Provider.of<ThemeProvider>(context, listen: false)
                                    .darkTheme
                                ? Colors.white54
                                : Colors.black54),
                    onPressed: _toggle)
                : widget.isIcon!
                    ? IconButton(
                        onPressed: widget.onSuffixTap!,
                        icon: Image.asset(
                          widget.suffixIconUrl!,
                          width: 15,
                          height: 15,
                          color:
                              Provider.of<ThemeProvider>(context, listen: false)
                                      .darkTheme
                                  ? Colors.white54
                                  : Colors.black54,
                        ),
                      )
                    : null
            : null,
      ),
      onTap: widget.onTap,
      onSubmitted: (text) => widget.nextFocus != null
          ? FocusScope.of(context).requestFocus(widget.nextFocus)
          : widget.onSubmit != null
              ? widget.onSubmit!(text)
              : null,
      onChanged: widget.onChanged,
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
