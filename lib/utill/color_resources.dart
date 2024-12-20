import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/provider/theme_provider.dart';

class ColorResources {
  static Color getPrimaryColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme
        ? Color(0xFF009401)
        : Color(0xff04B200);
  }

  static Color getGreyColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme
        ? Color(0xFF6f7275)
        : Color(0xFFA0A4A8);
  }

  static Color getGrayColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme
        ? Color(0xFF919191)
        : Color(0xFF6E6E6E);
  }

  static Color? getSearchBg(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme
        ? Colors.grey[600]
        : Color(0xFFF4F7FC);
  }

  static Color getBackgroundColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme
        ? Color(0xFF343636)
        : Color(0xFFF4F7FC);
  }

  static Color getHintColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme
        ? Color(0xFF98a1ab)
        : Color(0xFF52575C);
  }

  static Color getGreyBunkerColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme
        ? Color(0xFFE4E8EC)
        : Color(0xFF25282B);
  }

  static Color getScaffoldBackgroundColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme
        ? Color(0xFF252525)
        : Colors.white;
  }

  static Color getTextColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme
        ? Colors.white
        : Colors.black;
  }

  static Color getCardColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context , listen: false).darkTheme
        ? Color(0xFF191919)
        : Colors.white;
  }


  static const Color COLOR_PRIMARY = Color(0xFF39aeb5);
  static const Color COLOR_PRIMARY_DARK = Color(0xFF288b91);
  static const Color COLOR_LIGHT_PRIMARY = Color(0xFFddf3f4);
  static const Color COLOR_GREY = Color(0xFFA0A4A8);
  static const Color COLOR_BLACK = Color(0xFF000000);
  static const Color COLOR_NERO = Color(0xFF1F1F1F);
  static const Color COLOR_WHITE = Color(0xFFFFFFFF);
  static const Color COLOR_HINT = Color(0xFF52575C);
  static const Color SEARCH_BG = Color(0xFFF4F7FC);
  static const Color COLOR_GRAY = Color(0xff6E6E6E);
  static const Color COLOR_OXFORD_BLUE = Color(0xff282F39);
  static const Color COLOR_GAINSBORO = Color(0xffE8E8E8);
  static const Color COLOR_NIGHER_RIDER = Color(0xff303030);
  static const Color BACKGROUND_COLOR = Color(0xfffffafb);
  static const Color COLOR_GREY_BUNKER = Color(0xff25282B);
  static const Color COLOR_GREY_CHATEAU = Color(0xffA0A4A8);
  static const Color BORDER_COLOR = Color(0xFFDCDCDC);
  static const Color DISABLE_COLOR = Color(0xFF979797);
  static const Color SCAFFOLD_COLOR = Color(0xFF252525);

  static const Map<int, Color> colorMap = {
    50: Color(0x10192D6B),
    100: Color(0x20192D6B),
    200: Color(0x30192D6B),
    300: Color(0x40192D6B),
    400: Color(0x50192D6B),
    500: Color(0x60192D6B),
    600: Color(0x70192D6B),
    700: Color(0x80192D6B),
    800: Color(0x90192D6B),
    900: Color(0xff192D6B),
  };
}
