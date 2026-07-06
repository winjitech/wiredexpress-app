
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wired_express/data/model/response/notification_model.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/Images.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/utill/color_resources.dart';

class NotificationDetailsScreen extends StatefulWidget {
  final NotificationModel? notification;
  NotificationDetailsScreen({@required this.notification});

  @override
  State<NotificationDetailsScreen> createState() =>
      _NotificationDetailsScreenState();
}

class _NotificationDetailsScreenState extends State<NotificationDetailsScreen> {
  @override
  Widget build(BuildContext? context) {
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),

      body: Column(
        children: [
          CustomAppBar(title: 'notification_details', showBackButton: true),
          Consumer<CustomAuthProvider>(
            builder: (context, authProvider, child) => SafeArea(
              child: Scrollbar(
                child: SingleChildScrollView(
                  //padding: EdgeInsets.all(20.r),
                  physics: BouncingScrollPhysics(),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.notification!.image != null
                            ? Padding(
                                padding: EdgeInsets.all(10.r),
                                child: Row(children: [
                                  Expanded(
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10.r),
                                          child: FadeInImage.assetNetwork(
                                              placeholder:
                                                  Images.placeholder_rectangle,
                                              image:
                                                  '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.notificationImageUrl}/${widget.notification!.image!}',
                                              // image: '${AppConstants.baseUrl}/public/storage/${widget.notification!.image!}',  .fileFolder}/${widget.notification!.image!.uid}.${widget.notification!.image!.fileExtension}',
                                              height: 300,
                                              fit: BoxFit.cover,
                                              width: 300)))
                                ]),
                              )
                            : SizedBox(),
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.only(left: 24),
                          child: Text(
                            '${widget.notification!.title}',
                            style: AppTextStyles.h5(context).copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 7),
                        Padding(
                          padding: EdgeInsets.only(left: 24),
                          child: Text(
                            '${widget.notification!.description}',
                            style: AppTextStyles.h4(context, fontSize: 15.sp).copyWith(
                              color: Provider.of<ThemeProvider>(context).darkTheme
                                  ? Colors.white54
                                  : Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
