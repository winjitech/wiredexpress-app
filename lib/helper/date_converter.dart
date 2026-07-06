import 'package:flutter/material.dart';
import 'package:wired_express/provider/localization_provider.dart';
import 'package:wired_express/provider/order_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class DateConverter {
  static Locale locale(BuildContext context) {
    return Provider.of<LocalizationProvider>(
      context,
      listen: false,
    ).locale;
  }

  static String timezone(BuildContext context) {
    return "Europe/Madrid";
  }

  static DateTime toUserTime(
    BuildContext context,
    String isoString,
  ) {
    final location = tz.getLocation(timezone(context));

    final utc = DateTime.parse(isoString).toUtc();

    return tz.TZDateTime.from(utc, location);
  }

  static String formatDate(
    BuildContext context,
    DateTime dateTime,
  ) {
    return DateFormat(
      'yyyy-MM-dd HH:mm:ss',
      locale(context).toString(),
    ).format(dateTime);
  }

  static String estimatedDate(
    BuildContext context,
    DateTime dateTime,
  ) {
    return DateFormat(
      'dd MMM yyyy',
      locale(context).toString(),
    ).format(dateTime);
  }

  static DateTime convertStringToDatetime(String dateTime) {
    return DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").parse(dateTime);
  }

  static DateTime isoStringToLocalDate(String dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS')
        .parse(dateTime, true)
        .toLocal();
  }

  static String convertIsoStringToDayMonthFormat(
    BuildContext context,
    String isoDateString,
  ) {
    final date = toUserTime(context, isoDateString);
    final l = locale(context);

    return '${DateFormat('dd MMM', l.toString()).format(date)} , '
        '${DateFormat('h:mm a', l.toString()).format(date)}';
  }

  static String isoStringToLocalTimeOnly(
    BuildContext context,
    String dateTime,
  ) {
    final l = locale(context);

    return DateFormat(
      'hh:mm a',
      l.toString(),
    ).format(toUserTime(context, dateTime));
  }

  static String isoStringToLocalAMPM(
    BuildContext context,
    String dateTime,
  ) {
    return DateFormat(
      'a',
      locale(context).toString(),
    ).format(toUserTime(context, dateTime));
  }

  static String isoStringToLocalDateOnly(
    BuildContext context,
    String dateTime,
  ) {
    return DateFormat(
      'dd MMM yyyy',
      locale(context).toString(),
    ).format(toUserTime(context, dateTime));
  }

  static String localDateToIsoString(DateTime dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(dateTime.toUtc());
  }

  static String convertTimeToTime(String time) {
    DateTime parsedTime;

    try {
      if (time.split(':').length == 2) {
        // Example: 13:39
        parsedTime = DateFormat('HH:mm').parse(time);
      } else {
        // Example: 13:39:00
        parsedTime = DateFormat('HH:mm:ss').parse(time);
      }
    } catch (_) {
      return time;
    }

    return DateFormat('hh:mm a').format(parsedTime);
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

  static String formatDateTime(
    BuildContext context,
    String dateTime,
  ) {
    final l = locale(context);
    final date = toUserTime(context, dateTime);

    return "${DateFormat('MM/dd/yyyy', l.toString()).format(date)} - "
        "${DateFormat('hh:mm a', l.toString()).format(date)}";
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

  static String convertToDesiredFormat(
      BuildContext context,
      String dateString,
      ) {
    return DateFormat(
      'dd MMM yyyy',
      locale(context).toString(),
    ).format(DateTime.parse(dateString));
  }

  static String localizeWeekDay(
    BuildContext context,
    String day,
  ) {
    final l = locale(context);


    final Map<String, int> weekDays = {
      'Monday': DateTime.monday,
      'Tuesday': DateTime.tuesday,
      'Wednesday': DateTime.wednesday,
      'Thursday': DateTime.thursday,
      'Friday': DateTime.friday,
      'Saturday': DateTime.saturday,
      'Sunday': DateTime.sunday,
    };

    if (!weekDays.containsKey(day)) {
      return day;
    }

    // Monday of any week
    final baseDate = DateTime(2024, 1, 1);

    final date = baseDate.add(
      Duration(days: weekDays[day]! - DateTime.monday),
    );  return DateFormat(
      'EEEE',
      l.toString(),
    ).format(date);

  }static String dateToWeekDay(
      BuildContext context,
      DateTime date,
      ) {
    return DateFormat(
      'EEEE',
      locale(context).toString(),
    ).format(date);
  }
  static String formatScheduledDate(
      BuildContext context,
      String date,
      ) {
    return DateFormat(
      'dd MMM yyyy',
      locale(context).toString(),
    ).format(DateTime.parse(date));
  }static String formatScheduledTime(String timeRange) {
    if (timeRange.isEmpty) return '';

    final times = timeRange.split('-');

    if (times.length != 2) return timeRange;

    return '${convertTimeToTime(times[0])} - ${convertTimeToTime(times[1])}';
  }
  static String dateToShortWeekDay(
      BuildContext context,
      DateTime date,
      ) {
    return DateFormat(
      'EEE',
      locale(context).toString(),
    ).format(date);
  }

  static String dateToMonth(
      BuildContext context,
      DateTime date,
      ) {
    return DateFormat(
      'MMM',
      locale(context).toString(),
    ).format(date);
  }
}
