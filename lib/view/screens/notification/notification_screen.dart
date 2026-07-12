import 'package:wired_express/data/model/response/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/helper/date_converter.dart';
import 'package:wired_express/provider/notification_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/base/no_data_found_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wired_express/view/screens/notification/widget/notification_details_dialog.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchNotifications(resetOffset: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  void _fetchNotifications({bool resetOffset = false}) {
    final prov = Provider.of<NotificationProvider>(context, listen: false);
    if (resetOffset) {
      prov.clearNotificationsOffset();
    }
    prov.getNotifications(context, "1");
  }

  void _onScroll() {
    final prov = Provider.of<NotificationProvider>(context, listen: false);
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !prov.bottomNotificationsLoading &&
        (prov.notificationsList?.length ?? 0) <
            (prov.totalNotificationsSize ?? 0)) {
      int nextOffset = (int.tryParse(prov.notificationsOffset ?? "1") ?? 1) + 1;
      prov.showBottomNotificationsLoader();
      prov.getNotifications(context, nextOffset.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, prov, child) {
        List<NotificationModel> notifications = prov.notificationsList ?? [];
        bool isLoading = prov.notificationsIsLoading;
        int totalSize = prov.totalNotificationsSize ?? 0;

        return Scaffold(
          backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
          body: Column(
            children: [
              CustomAppBar(title: 'notifications', showBackButton: true),
              Expanded(
                child: isLoading
                    ? Center(child: CustomCircularIndicator())
                    : notifications.isEmpty
                        ? const Center(
                            child: NoDataFoundView(
                              text: 'no_any_notification_yet',
                              showIcon: false,
                            ),
                          )
                        : _buildDeliveryList(notifications, prov, totalSize),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDeliveryList(
    List<NotificationModel> notifications,
    NotificationProvider prov,
    int totalSize,
  ) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification.metrics.pixels ==
                scrollNotification.metrics.maxScrollExtent &&
            (notifications.length < totalSize)) {
          _onScroll();
        }
        return false;
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          children: [
            ListView.builder(
              padding: EdgeInsets.all(0.r),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                NotificationModel notification = notifications[index];

                return Column(
                  children: [
                    Opacity(
                      opacity: notification.read! ? 0.5 : 1.0,
                      child: GestureDetector(
                        onTap: () async {
                          if (!(notification.read ?? false)) {
                            await prov.markAsRead(context, notification.id!);
                          }
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => NotificationDetailsDialog(
                              notification: notification,
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorResources.getCardColor(context),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12.w),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        '${notification.title ?? '-'} ',
                                        style: AppTextStyles.h6(context),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        '${notification.description ?? '-'} ',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            AppTextStyles.h8(context).copyWith(
                                          color: ColorResources.getTextColor(
                                            context,
                                          ).withOpacity(0.9),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        DateConverter.formatDateTime(
                                          context,
                                          notification.createdAt!,
                                        ),
                                        style:
                                            AppTextStyles.h9(context).copyWith(
                                          color: ColorResources.getTextColor(
                                            context,
                                          ).withOpacity(0.6),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                  ],
                );
              },
            ),
            if (prov.bottomNotificationsLoading)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                child: CustomCircularIndicator(),
              ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
