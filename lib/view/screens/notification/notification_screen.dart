
import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wired_express/data/model/response/notification_model.dart';
import 'package:wired_express/helper/date_converter.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/notification_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/Images.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/screens/notification/notification_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/utill/color_resources.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 0), () async {
      await Provider.of<NotificationProvider>(context, listen: false)
          .initNotificationList(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
        key: _scaffoldKey,

        body: Column(
          children: [
            CustomAppBar(title: 'notifications', showBackButton: true),
            Expanded(
              child: Consumer<NotificationProvider>(
                builder: (context, notificationProvider, child) {
                  int notificationsLength =
                      notificationProvider.notificationList != null
                          ? notificationProvider.notificationList!.length
                          : 0;
                  // int notificationsTotalSize = notificationProvider.totalSize ?? 0;

                  var box = Hive.box('myBox');
                  // String notificationType = box.get('notification_type');

                  // var _todayRecords = notificationProvider.notificationsList!.where((notification) =>notification.createdAt == 1).length;

                  var _todayRecords = notificationProvider.notificationList!
                      .where((element) =>
                          DateConverter.isoStringToLocalDateOnly(context ,
                              element.createdAt!) ==
                          DateConverter.estimatedDate(context , DateTime.now()))
                      .toList();

                  var _yesterdayRecords = notificationProvider.notificationList!
                      .where((element) =>
                          DateConverter.isoStringToLocalDateOnly(context ,
                              element.createdAt!) ==
                          DateConverter.estimatedDate(context , 
                              DateTime.now().subtract(Duration(days: 1))))
                      .toList();

                  DateTime now = DateTime.now();
                  DateTime lastWeek = now.subtract(Duration(days: 7));

                  var _lastSevenDaysRecords = notificationProvider.notificationList!
                      .where((element) =>
                          DateTime.parse(element.createdAt!).isAfter(lastWeek) &&
                          DateConverter.isoStringToLocalDateOnly(context ,
                                  element.createdAt!) !=
                              DateConverter.estimatedDate(context , 
                                  DateTime.now().subtract(Duration(days: 1))))
                      .toList();

                  var _earlier = notificationProvider.notificationList!
                      .where((element) =>
                          DateTime.parse(element.createdAt!).isBefore(lastWeek))
                      .toList();

                  return Column(
                    children: [
                      Expanded(
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            physics: const BouncingScrollPhysics(),
                            //  padding: EdgeInsets.all(10.r),
                            child: Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: notificationProvider.loading!
                                    ? CustomCircularIndicator()
                                    : notificationProvider.notificationList!.length ==
                                            0
                                        ? Padding(
                                  padding: EdgeInsets.only(top: 100.h),
                                  child: Center(
                                    child: Text(
                                      getTranslated('no_notifications_yet', context),
                                      style: AppTextStyles.h5(context),
                                    ),
                                  ),
                                )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 10.h),

                                              _todayRecords.length > 0
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 25.w,
                                                          right: 25,
                                                          top: 15.h,
                                                          bottom: 8),
                                                      child:Text(
                                                        getTranslated('today', context),
                                                        style: AppTextStyles.h5(context).copyWith(
                                                          fontWeight: FontWeight.w500,
                                                          color: Provider.of<ThemeProvider>(context).darkTheme
                                                              ? Colors.white54
                                                              : Colors.black54,
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox(),

                                              _todayRecords.length > 0
                                                  ? Container(
                                                      color: ColorResources
                                                          .getScaffoldBackgroundColor(
                                                              context),
                                                      child: ListView.builder(
                                                        padding:  EdgeInsets.all(10.r),
                                                        itemCount:
                                                            _todayRecords.length,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemBuilder:
                                                            (context, index) {
                                                          NotificationModel
                                                              _notification =
                                                              _todayRecords[index];
                                                          String _date = DateConverter.isoStringToLocalDateOnly(context ,
                                                                      _notification
                                                                          .createdAt!) ==
                                                                  DateConverter.estimatedDate(context , 
                                                                      DateTime.now())
                                                              ? getTranslated('today', context)
                                                              : DateConverter.isoStringToLocalDateOnly(context ,
                                                                          _notification
                                                                              .createdAt!) ==
                                                                      DateConverter.estimatedDate(context , 
                                                                          DateTime.now().subtract(
                                                                              Duration(
                                                                                  days:
                                                                                      1)))
                                                                  ? getTranslated('yesterday', context)
                                                                  : DateConverter.isoStringToLocalDateOnly(context ,
                                                                      _notification.createdAt!);

                                                          return GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (BuildContext
                                                                              context) =>
                                                                          NotificationDetailsScreen(
                                                                              notification:
                                                                                  _notification)));
                                                            },
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .all(
                                                                              8.0),
                                                                      child: Stack(
                                                                        children: [
                                                                          ClipRRect(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(50.r),
                                                                              child: _notification.image !=
                                                                                      null
                                                                                  ? FadeInImage.assetNetwork(
                                                                                      placeholder: Images.filterIcon,
                                                                                      image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls?.notificationImageUrl}/${_notification.image!}',

                                                                                      // '${AppConstants.baseUrl}/public/storage/${_notification.image!}' ,
                                                                                      // .fileFolder}/${_notification.image!.uid}.${_notification.image!.fileExtension}',
                                                                                      height: 80.h,
                                                                                      width: 80.w,
                                                                                      fit: BoxFit.cover,
                                                                                    )
                                                                                  : Container(
                                                                                      height: 80.h,
                                                                                      width: 80.w,
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(50.r),
                                                                                        color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.white12 : Colors.black12,
                                                                                      ),
                                                                                      child: Icon(Icons.person, color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.white38 : Colors.black38))),
                                                                          Positioned(
                                                                              top: 50.h,
                                                                              right:
                                                                                  0,
                                                                              child: Container(
                                                                                  height: 25.h,
                                                                                  width: 25.w,
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(50.r),
                                                                                    color: ColorResources.getScaffoldBackgroundColor(context),
                                                                                  ),
                                                                                  child: Icon(Icons.notifications, color: ColorResources.getScaffoldBackgroundColor(context), size: 19.sp))),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        width: 10),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        SizedBox(
                                                                          width: 230,
                                                                          child: Text(
                                                                            '${_notification.title}',
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: AppTextStyles.h4(context, fontSize: 15.sp),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                5),
                                                                        SizedBox(
                                                                          width: 230,
                                                                          child: Text(
                                                                            '${_notification.description}',
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: AppTextStyles.h4(context, fontSize: 14.sp).copyWith(
                                                                              color: Provider.of<ThemeProvider>(context).darkTheme
                                                                                  ? Colors.white54
                                                                                  : Colors.black54,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                10),
                                                                        Text(
                                                                          '${_date}',
                                                                          style: AppTextStyles.h4(context, fontSize: 12.sp).copyWith(
                                                                            color: Provider.of<ThemeProvider>(context).darkTheme
                                                                                ? Colors.white54
                                                                                : Colors.black54,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    )
                                                  : SizedBox(),

                                              _yesterdayRecords.length > 0
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 25.w,
                                                          right: 25,
                                                          top: 15.h,
                                                          bottom: 8),
                                                      child: Text(
                                                        getTranslated('yesterday', context),
                                                        style: AppTextStyles.h5(context).copyWith(
                                                          fontWeight: FontWeight.w500,
                                                          color: Provider.of<ThemeProvider>(context).darkTheme
                                                              ? Colors.white54
                                                              : Colors.black54,
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox(),

                                              _yesterdayRecords.length > 0
                                                  ? Container(
                                                      color: ColorResources
                                                          .getScaffoldBackgroundColor(
                                                              context),
                                                      child: ListView.builder(
                                                        padding:  EdgeInsets.all(10.r),
                                                        itemCount:
                                                            _yesterdayRecords.length,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemBuilder:
                                                            (context, index) {
                                                          NotificationModel
                                                              _notification =
                                                              _yesterdayRecords[
                                                                  index];
                                                          String _date = DateConverter.isoStringToLocalDateOnly(context ,
                                                                      _notification
                                                                          .createdAt!) ==
                                                                  DateConverter.estimatedDate(context , 
                                                                      DateTime.now())
                                                              ? getTranslated('today', context)
                                                              : DateConverter.isoStringToLocalDateOnly(context ,
                                                                          _notification
                                                                              .createdAt!) ==
                                                                      DateConverter.estimatedDate(context , 
                                                                          DateTime.now().subtract(
                                                                              Duration(
                                                                                  days:
                                                                                      1)))
                                                                  ? getTranslated('yesterday', context)
                                                                  : DateConverter.isoStringToLocalDateOnly(context ,
                                                                      _notification.createdAt!);

                                                          return GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (BuildContext
                                                                              context) =>
                                                                          NotificationDetailsScreen(
                                                                              notification:
                                                                                  _notification)));
                                                            },
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .all(
                                                                              8.0),
                                                                      child: Stack(
                                                                        children: [
                                                                          ClipRRect(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(50.r),
                                                                              child: _notification.image !=
                                                                                      null
                                                                                  ? FadeInImage.assetNetwork(
                                                                                      placeholder: Images.filterIcon,
                                                                                      image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls?.notificationImageUrl}/${_notification.image!}',

                                                                                      // image: '${AppConstants.baseUrl}/public/storage/${_notification.image!}' ,
                                                                                      // .fileFolder}/${_notification.image!.uid}.${_notification.image!.fileExtension}',
                                                                                      height: 80.h,
                                                                                      width: 80.w,
                                                                                      fit: BoxFit.cover,
                                                                                    )
                                                                                  : Container(
                                                                                      height: 80.h,
                                                                                      width: 80.w,
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(50.r),
                                                                                        color: Colors.black12,
                                                                                      ),
                                                                                      child: Icon(Icons.person, color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.white38 : Colors.black38))),
                                                                          Positioned(
                                                                              top: 50.h,
                                                                              right:
                                                                                  0,
                                                                              child: Container(
                                                                                  height:
                                                                                      25,
                                                                                  width:
                                                                                      25,
                                                                                  decoration:
                                                                                      BoxDecoration(borderRadius: BorderRadius.circular(50.r), color: ColorResources.getScaffoldBackgroundColor(context)),
                                                                                  child: Icon(Icons.notifications, color: ColorResources.getScaffoldBackgroundColor(context), size: 19.sp))),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        width: 10),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        SizedBox(
                                                                          width: 230,
                                                                          child: Text(
                                                                            '${_notification.title}',
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: AppTextStyles.h4(context, fontSize: 15.sp),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                5),
                                                                        SizedBox(
                                                                          width: 230,
                                                                          child: Text(
                                                                            '${_notification.description}',
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: AppTextStyles.h6(context).copyWith(
                                                                              color: Provider.of<ThemeProvider>(context).darkTheme
                                                                                  ? Colors.white54
                                                                                  : Colors.black54,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                10),
                                                                        Text(
                                                                          '${_date}',
                                                                          style: AppTextStyles.h8(context).copyWith(
                                                                            fontWeight: FontWeight.w500,
                                                                            color: Provider.of<ThemeProvider>(context).darkTheme
                                                                                ? Colors.white54
                                                                                : Colors.black54,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    )
                                                  : SizedBox(),

                                              _lastSevenDaysRecords.length > 0
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 25.w,
                                                          right: 25,
                                                          top: 15.h,
                                                          bottom: 8),
                                                      child: Text(
                                                        getTranslated('last_week', context),
                                                        style: AppTextStyles.h4(context).copyWith(
                                                          color: Provider.of<ThemeProvider>(context).darkTheme
                                                              ? Colors.white54
                                                              : Colors.black54,
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox(),

                                              _lastSevenDaysRecords.length > 0
                                                  ? Container(
                                                      color: ColorResources
                                                          .getScaffoldBackgroundColor(
                                                              context),
                                                      child: ListView.builder(
                                                        //  padding: EdgeInsets.all(10.r),
                                                        itemCount:
                                                            _lastSevenDaysRecords
                                                                .length,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemBuilder:
                                                            (context, index) {
                                                          NotificationModel
                                                              _notification =
                                                              _lastSevenDaysRecords[
                                                                  index];
                                                          String _date = DateConverter.isoStringToLocalDateOnly(context ,
                                                                      _notification
                                                                          .createdAt!) ==
                                                                  DateConverter.estimatedDate(context , 
                                                                      DateTime.now())
                                                              ? getTranslated('today', context)
                                                              : DateConverter.isoStringToLocalDateOnly(context ,
                                                                          _notification
                                                                              .createdAt!) ==
                                                                      DateConverter.estimatedDate(context , 
                                                                          DateTime.now().subtract(
                                                                              Duration(
                                                                                  days:
                                                                                      1)))
                                                                  ? getTranslated('yesterday', context)
                                                                  : DateConverter.isoStringToLocalDateOnly(context ,
                                                                      _notification.createdAt!);

                                                          return GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (BuildContext
                                                                              context) =>
                                                                          NotificationDetailsScreen(
                                                                              notification:
                                                                                  _notification)));
                                                            },
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .all(
                                                                              8.0),
                                                                      child: Stack(
                                                                        children: [
                                                                          ClipRRect(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(
                                                                                      50.r),
                                                                              child: _notification.image !=
                                                                                      null
                                                                                  ? FadeInImage.assetNetwork(
                                                                                      placeholder: Images.filterIcon,
                                                                                      image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls?.notificationImageUrl}/${_notification.image!}',

                                                                                      // image: '${AppConstants.baseUrl}/public/storage/${_notification.image!}' ,
                                                                                      // .fileFolder}/${_notification.image!.uid}.${_notification.image!.fileExtension}',
                                                                                      height: 80.h,
                                                                                      width: 80.w,
                                                                                      fit: BoxFit.cover,
                                                                                    )
                                                                                  : Container(
                                                                                      height: 80.h,
                                                                                      width: 80.w,
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(50.r),
                                                                                        color: Colors.black12,
                                                                                      ),
                                                                                      child: Icon(Icons.person, color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.white38 : Colors.black38))),
                                                                          Positioned(
                                                                              top: 50.h,
                                                                              right:
                                                                                  0,
                                                                              child: Container(
                                                                                  height:
                                                                                      25,
                                                                                  width:
                                                                                      25,
                                                                                  decoration:
                                                                                      BoxDecoration(borderRadius: BorderRadius.circular(50.r), color: ColorResources.getScaffoldBackgroundColor(context)),
                                                                                  child: Icon(Icons.notifications, color: ColorResources.getScaffoldBackgroundColor(context), size: 19.sp))),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        width: 10),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        SizedBox(
                                                                          width: 230,
                                                                          child: Text(
                                                                            '${_notification.title}',
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: AppTextStyles.h4(context, fontSize: 15.sp),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                5),
                                                                        SizedBox(
                                                                          width: 230,
                                                                          child:Text(
                                                                            '${_notification.description}',
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: AppTextStyles.h6(context).copyWith(
                                                                              color: Provider.of<ThemeProvider>(context).darkTheme
                                                                                  ? Colors.white54
                                                                                  : Colors.black54,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                10),
                                                                        Text(
                                                                          '${_date}',
                                                                          style: AppTextStyles.h8(context).copyWith(
                                                                            fontWeight: FontWeight.w500,
                                                                            color: Provider.of<ThemeProvider>(context).darkTheme
                                                                                ? Colors.white54
                                                                                : Colors.black54,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    )
                                                  : SizedBox(),

                                              _earlier.length > 0
                                                  ? Padding(
                                                padding: EdgeInsets.only(
                                                    left: 25.w,
                                                    right: 25,
                                                    top: 15.h,
                                                    bottom: 8),
                                                child: Text(
                                                  getTranslated('earlier', context),
                                                  style: AppTextStyles.h4(context).copyWith(
                                                    color: Provider.of<ThemeProvider>(context).darkTheme
                                                        ? Colors.white54
                                                        : Colors.black54,
                                                  ),
                                                ),
                                              )
                                                  : SizedBox(),

                                              _earlier.length > 0
                                                  ? Container(
                                                color: ColorResources
                                                    .getScaffoldBackgroundColor(
                                                    context),
                                                child: ListView.builder(
                                                  //  padding: EdgeInsets.all(10.r),
                                                  itemCount: _earlier.length,
                                                  physics:
                                                  const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (context, index) {
                                                    NotificationModel
                                                    _notification =
                                                    _earlier[index];
                                                    String _date = DateConverter.isoStringToLocalDateOnly(context ,
                                                        _notification
                                                            .createdAt!) ==
                                                        DateConverter.estimatedDate(context , 
                                                            DateTime.now())
                                                        ? getTranslated('today', context)
                                                        : DateConverter.isoStringToLocalDateOnly(context ,
                                                        _notification
                                                            .createdAt!) ==
                                                        DateConverter.estimatedDate(context , 
                                                            DateTime.now().subtract(
                                                                Duration(
                                                                    days:
                                                                    1)))
                                                        ? getTranslated('yesterday', context)
                                                        : DateConverter.isoStringToLocalDateOnly(context ,
                                                        _notification.createdAt!);

                                                    return Padding(
                                                      padding: EdgeInsets.all(10.r),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(10.r),
                                                            color: ColorResources
                                                                .getScaffoldBackgroundColor(
                                                                context),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: ColorResources.getBoxShadow(context),

                                                                blurRadius: 5,
                                                                spreadRadius: 1,
                                                              )
                                                            ]),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (BuildContext
                                                                    context) =>
                                                                        NotificationDetailsScreen(
                                                                            notification:
                                                                            _notification)));
                                                          },
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                    child:
                                                                    Stack(
                                                                      children: [
                                                                        ClipRRect(
                                                                            borderRadius:
                                                                            BorderRadius.circular(50.r),
                                                                            child: _notification.image != null
                                                                                ? FadeInImage.assetNetwork(
                                                                              placeholder: Images.filterIcon,
                                                                              image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls?.notificationImageUrl}/${_notification.image!}',

                                                                              // image: '${AppConstants.baseUrl}/public/storage/${_notification.image!}' ,
                                                                              // .fileFolder}/${_notification.image!.uid}.${_notification.image!.fileExtension}',
                                                                              height: 80.h,
                                                                              width: 80.w,
                                                                              fit: BoxFit.cover,
                                                                            )
                                                                                : Container(
                                                                                height: 80.h,
                                                                                width: 80.w,
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(50.r),
                                                                                  color: Colors.black12,
                                                                                ),
                                                                                child: Icon(Icons.person, color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.white38 : Colors.black38))),
                                                                        Positioned(
                                                                            top:
                                                                            50,
                                                                            right:
                                                                            0,
                                                                            child: Container(
                                                                                height: 25.h,
                                                                                width: 25.w,
                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.r), color: ColorResources.getScaffoldBackgroundColor(context)),
                                                                                child: Icon(Icons.notifications, color: ColorResources.getScaffoldBackgroundColor(context), size: 19.sp))),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                      10),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                        230,
                                                                        child: Text(
                                                                          '${_notification.title}',
                                                                          maxLines: 1,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: AppTextStyles.h4(context, fontSize: 15.sp),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                          5),
                                                                      SizedBox(
                                                                        width: 230,
                                                                        child: Text(
                                                                          '${_notification.description}',
                                                                          maxLines: 1,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: AppTextStyles.h6(context).copyWith(
                                                                            color: Provider.of<ThemeProvider>(context).darkTheme
                                                                                ? Colors.white54
                                                                                : Colors.black54,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(height: 10),
                                                                      Text(
                                                                        '${_date}',
                                                                        style: AppTextStyles.h8(context).copyWith(
                                                                          fontWeight: FontWeight.w500,
                                                                          color: Provider.of<ThemeProvider>(context).darkTheme
                                                                              ? Colors.white54
                                                                              : Colors.black54,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              )
                                                  : SizedBox(),

                                              // notificationProvider.bottomLoading?
                                              // Column(
                                              //   children: [
                                              //     SizedBox(height: 10.h),
                                              //     CustomCircularIndicator(),
                                              //   ],
                                              // ) :
                                              // notificationsLength < notificationsTotalSize?
                                              // Center(child:
                                              // GestureDetector(
                                              //     onTap: () {
                                              //       // String offset = notificationProvider.offset ?? '';
                                              //       // int offsetInt = int.parse(offset) + 1;
                                              //       // print('$offset -- $offsetInt');
                                              //       // notificationProvider.showBottomLoader();
                                              //       // notificationProvider.getNotificationsList(context, offsetInt.toString());
                                              //     },
                                              //     child: Text('Load more...',style: TextStyle(color: ColorResources.getPrimaryColor(context),)))) : SizedBox(),
                                            ],
                                          ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                    ],
                  );
                },
              ),
            ),
          ],
        ));
  }
}
