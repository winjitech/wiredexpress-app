import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/provider/theme_provider.dart';

class ColorResources {
  static bool isDark(BuildContext context) =>
      Provider.of<ThemeProvider>(context, listen: false).darkTheme;

  // Primary Color
  static Color getPrimaryColor(BuildContext context) {
    return isDark(context) ? const Color(0xFF009401) : const Color(0xff04B200);
  }

  static Color getSecondaryColor(BuildContext context) {
    return isDark(context) ? const Color(0xFFA6D94E) : const Color(0xFF5E8F16);
  }

  // Grey Colors
  static Color getGreyColor(BuildContext context) {
    return isDark(context) ? const Color(0xFF6F7275) : const Color(0xFFA0A4A8);
  }

  static Color getGrayColor(BuildContext context) {
    return isDark(context) ? const Color(0xFF919191) : const Color(0xFF6E6E6E);
  }
  static Color getGreyBunkerColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false).darkTheme
        ? Color(0xFFE4E8EC)
        : Color(0xFF25282B);
  }
  // Search Background
  static Color getSearchBg(BuildContext context) {
    return isDark(context) ? Colors.grey[600]! : const Color(0xFFF4F7FC);
  }

  // Background
  static Color getBackgroundColor(BuildContext context) {
    return isDark(context) ? const Color(0xFF343636) : const Color(0xFFF4F7FC);
  }

  static Color getSe(BuildContext context) {
    return isDark(context) ? const Color(0xFF3C3C3C) : const Color(0xFFFAFAFA);
  }

  static Color getScaffoldBackgroundColor(BuildContext context) {
    return isDark(context) ? const Color(0xFF3C3C3C) : const Color(0xFFF9FAFB);
  }

  // Text Colors
  static Color getTextColor(BuildContext context) {
    return isDark(context) ? Colors.white : const Color(0xFF333333);
  }

  static Color getChatTextColor(BuildContext context) {
    return isDark(context) ? Colors.white : Colors.black87;
  }

  static Color getHintColor(BuildContext context) {
    return isDark(context) ? const Color(0xFF98A1AB) : const Color(0xFF52575C);
  }

  // Cards, Borders, Shadows
  static Color getCardColor(BuildContext context) {
    return isDark(context) ? const Color(0xFF222222) : const Color(0xFFFFFFFF);
  }

  static Color getBoxShadow(BuildContext context) {
    return isDark(context) ? Colors.black.withOpacity(0.4) : Colors.grey[300]!;
  }

  static Color getTextFieldFillColor(BuildContext context) {
    return isDark(context) ? const Color(0xFF222222) : const Color(0xFFFFFFFF);
  }


  static Color getBorderColor(BuildContext context) {
    return isDark(context)
        ? getTextColor(context).withOpacity(0.8)
        : const Color(0xFFE8ECF4);
  }

  // Ratings
  static Color getRatingColor(BuildContext context) {
    return isDark(context) ? const Color(0xFFFFC721) : const Color(0xFFFFC107);
  }

// Shimmer Base Color
  static Color getShimmerColor(BuildContext context) {
    return isDark(context)
        ? const Color(0xFF2E2E2E)
        : const Color(0xFFE9EDF3);
  }

// Shimmer Highlight
  static Color getShimmerHighlightColor(BuildContext context) {
    return isDark(context)
        ? const Color(0xFF454545)
        : const Color(0xFFF8FAFC);
  }
  static const Color COLOR_PRIMARY = Color(0xFF535AA9);
  static const Color COLOR_PRIMARY_DARK = Color(0xFF276573);
  static const Color COLOR_LIGHT_PRIMARY = Color(0xFF4397AF);
  static const Color COLOR_GREY = Color(0xFFA0A4A8);
  static const Color COLOR_BLACK = Color(0xFF000000);
  static const Color COLOR_NERO = Color(0xFF1F1F1F);
  static const Color COLOR_WHITE = Color(0xFFFFFFFF);
  static const Color COLOR_HINT = Color(0xFF52575C);
  static const Color SEARCH_BG = Color(0xFFF4F7FC);
  static const Color COLOR_GRAY = Color(0xFF6E6E6E);
  static const Color COLOR_OXFORD_BLUE = Color(0xFF282F39);
  static const Color COLOR_GAINSBORO = Color(0xFFE8E8E8);
  static const Color COLOR_NIGHER_RIDER = Color(0xFF303030);
  static const Color BACKGROUND_COLOR = Color(0xFFFFFAFB);
  static const Color COLOR_GREY_BUNKER = Color(0xFF25282B);
  static const Color COLOR_GREY_CHATEAU = Color(0xFFA0A4A8);
  static const Color BORDER_COLOR = Color(0xFFDCDCDC);
  static const Color DISABLE_COLOR = Color(0xFF979797);
}
