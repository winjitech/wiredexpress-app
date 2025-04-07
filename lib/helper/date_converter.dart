import 'package:flutter/material.dart';
import 'package:wired_express/provider/localization_provider.dart';
import 'package:wired_express/provider/order_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/color_resources.dart';

class DateConverter {
  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm:ss').format(dateTime);
  }

  static String estimatedDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  static DateTime convertStringToDatetime(String dateTime) {
    return DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").parse(dateTime);
  }

  static DateTime isoStringToLocalDate(String dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS')
        .parse(dateTime, true)
        .toLocal();
  }

  static String isoStringToLocalTimeOnly(String dateTime) {
    return DateFormat('hh:mm aa').format(isoStringToLocalDate(dateTime));
  }

  static String isoStringToLocalAMPM(String dateTime) {
    return DateFormat('a').format(isoStringToLocalDate(dateTime));
  }

  static String isoStringToLocalDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy').format(isoStringToLocalDate(dateTime));
  }

  static String localDateToIsoString(DateTime dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(dateTime.toUtc());
  }

  static String convertTimeToTime(String time) {
    return DateFormat('hh:mm a').format(DateFormat('hh:mm:ss').parse(time));
  }

  static bool isAvailable(String start, String end, BuildContext? context) {
    DateTime _currentTime =
        Provider.of<SplashProvider>(context!, listen: false).currentTime;
    DateTime _start = DateFormat('hh:mm:ss').parse(start);
    DateTime _end = DateFormat('hh:mm:ss').parse(end);
    DateTime _startTime = DateTime(_currentTime.year, _currentTime.month,
        _currentTime.day, _start.hour, _start.minute, _start.second);
    DateTime _endTime = DateTime(_currentTime.year, _currentTime.month,
        _currentTime.day, _end.hour, _end.minute, _end.second);
    if (_endTime.isBefore(_startTime)) {
      _endTime = _endTime.add(Duration(days: 1));
    }
    return _currentTime.isAfter(_startTime) && _currentTime.isBefore(_endTime);
  }

  static String formatDateTime(BuildContext context, String dateTime) {
    Locale locale =
        Provider.of<LocalizationProvider>(context, listen: false).locale;
    String formattedDate = DateFormat('MM/dd/yyyy', locale.toString())
        .format(DateTime.parse(dateTime));

    String formattedTime = DateFormat('hh:mm a', locale.toString())
        .format(DateTime.parse(dateTime));

    return "$formattedDate - $formattedTime";
  }

  static Future<void> deliveryDateTime(
      BuildContext context, OrderProvider orderProvider) async {
    Locale locale =
        Provider.of<LocalizationProvider>(context, listen: false).locale;
    bool isDarkTheme =
        Provider.of<ThemeProvider>(context, listen: false).darkTheme;
    Color dialogBackgroundColor =
        ColorResources.getScaffoldBackgroundColor(context);
    Color primaryColor = ColorResources.getPrimaryColor(context);
    DateTime initialDate;
    TimeOfDay initialTime;
    if (orderProvider.selectedDeliveryDate != null) {
      initialDate = orderProvider.selectedDeliveryDate!;
      initialTime = TimeOfDay(
          hour: orderProvider.selectedDeliveryDate!.hour,
          minute: orderProvider.selectedDeliveryDate!.minute);
    } else {
      initialTime = TimeOfDay.now();
      initialDate = DateTime.now();
    }

    ThemeData themeData = isDarkTheme
        ? ThemeData.dark().copyWith(
            dialogBackgroundColor: dialogBackgroundColor,
            primaryColor: primaryColor,
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          )
        : ThemeData.light().copyWith(
            dialogBackgroundColor: dialogBackgroundColor,
            primaryColor: primaryColor,
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          );

    DateTime? pickedDate = await showDatePicker(
      locale: locale,
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(data: themeData, child: child!);
      },
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: initialTime,
        builder: (BuildContext context, Widget? child) {
          return Localizations.override(
            context: context,
            locale: locale,
            child: Theme(data: themeData, child: child!),
          );
        },
      );

      if (pickedTime != null) {
        final selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        orderProvider.setSelectDeliveryDate(selectedDateTime);
      }
    }
  }
}
