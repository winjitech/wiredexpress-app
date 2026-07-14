import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wired_express/data/model/body/place_order_body.dart';
import 'package:wired_express/data/model/response/config_model.dart';
import 'package:wired_express/data/model/response/opening_hours_model.dart';
import 'package:wired_express/data/model/response/working_hours_model.dart';
import 'package:wired_express/helper/date_converter.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/order_provider.dart';
import 'package:wired_express/provider/payment_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/base/custom_text_field.dart';
import 'package:wired_express/view/base/not_logged_in_screen.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/view/screens/dashboard/dashboard_screen.dart';
import 'package:wired_express/view/screens/payment/update_card_screen.dart';
import 'package:wired_express/view/screens/payment/widget/remove_card_bottom_sheet.dart';

class CheckoutScreen extends StatefulWidget {
  final PlaceOrderBody? orderBody;

  const CheckoutScreen({super.key, this.orderBody});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _noteController = TextEditingController();
  DateTime _weekStart = DateTime.now();


  bool? _isLoggedIn;


  @override
  void initState() {
    super.initState();
    _isLoggedIn =
        Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn();
    final orderProv = Provider.of<OrderProvider>(context, listen: false);
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    _weekStart = DateTime.now();

    Timer(Duration(seconds: 0), () async {
      orderProv.setScheduledOrder(false);
      orderProv.clearSelectDeliveryDate();
      orderProv.clearSelectedTime();
      if (_isLoggedIn!) {
        if (profile.userInfoModel == null) {
          profile.getUserInfo(context);
        }
        Provider.of<PaymentProvider>(context, listen: false).getPaymentCardList(context, profile.userInfoModel!.id!);
        orderProv.clearPrevData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
      key: _scaffoldKey,
      body: Column(
        children: [
          CustomAppBar(title: 'checkout', showBackButton: true),
          Expanded(
            child: _isLoggedIn!
                ? Consumer5<OrderProvider, CartProvider, ProfileProvider,
                    PaymentProvider, SplashProvider>(
                    builder: (context, orderProv, cartProvider, profileProvider,
                        paymentProvider,splash , child) {
                      ConfigModel config = splash.configModel!;
                      final bool hasServiceOnCart = cartProvider.cartList.any(
                            (cart) => cart.product?.isService == 1,
                      );


                      final bool isScheduled =
                          hasServiceOnCart || (orderProv.isScheduledOrder ?? false);

                      final bool canChooseDeliveryType =
                          !hasServiceOnCart &&
                              (profileProvider.userInfoModel?.scheduledDelivery == 1);

                      final bool showScheduleSection =
                          hasServiceOnCart ||
                              (profileProvider.userInfoModel?.scheduledDelivery == 1);
                      if (hasServiceOnCart &&
                          orderProv.isScheduledOrder != true) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          orderProv.setScheduledOrder(true);
                        });
                      }
                      Map<String, WorkingHoursModel> workingHours = config.workingHours ?? {};
                      return Column(
                            children: [
                              Expanded(
                                child: Scrollbar(
                                  child: SingleChildScrollView(
                                    padding: EdgeInsets.all(25.r),
                                    physics: BouncingScrollPhysics(),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                getTranslated(
                                                    'additional_note', context),
                                                style: AppTextStyles.h4(
                                                  context,
                                                ),
                                              ),
                                              Text(
                                                ' (${getTranslated('optional', context).toLowerCase()})',
                                                style: AppTextStyles.h4(context)
                                                    .copyWith(
                                                  color:
                                                      ColorResources.getHintColor(
                                                              context)
                                                          .withOpacity(0.6),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10.h),
                                          CustomTextField(fill: true,
                                              fillColor: ColorResources
                                                  .getTextFieldFillColor(context),
                                              controller: _noteController,
                                              hintText: getTranslated(
                                                  'additional_note', context),
                                              maxLines: 5,
                                              inputType: TextInputType.multiline,
                                              inputAction:
                                                  TextInputAction.newline,
                                              capitalization:
                                                  TextCapitalization.sentences),
                                          SizedBox(height: 20.h),
                                          if (showScheduleSection)
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [

                                                if (canChooseDeliveryType) ...[
                                                  Text(
                                                    getTranslated('delivery_type', context),
                                                    style: AppTextStyles.h4(context),
                                                  ),

                                                  SizedBox(height:15.h),

                                                  Row(
                                                    children:[
                                                      Expanded(
                                                        child:_buildSchedulingOption(
                                                          context:context,
                                                          orderProv:orderProv,
                                                          value:0,
                                                          textKey:'same_day',
                                                        ),
                                                      ),

                                                      SizedBox(width:15.w),

                                                      Expanded(
                                                        child:_buildSchedulingOption(
                                                          context:context,
                                                          orderProv:orderProv,
                                                          value:1,
                                                          textKey:'schedule',
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  SizedBox(height:20.h),
                                                ],

                                                if (isScheduled)
                                                  _buildScheduleWidget(
                                                    context,
                                                    orderProv,
                                                    workingHours,
                                                  ),
                                              ],
                                            ),
                                          paymentProvider.loading! ||
                                                  paymentProvider
                                                          .paymentCardList ==
                                                      null
                                              ? const Center(
                                                  child: SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child:
                                                          CustomCircularIndicator()),
                                                )
                                              : Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 15.h,
                                                          left: 16.w,
                                                          right: 16.w),
                                                      child: Text(
                                                        getTranslated(
                                                            'payment_info',
                                                            context),
                                                        style: AppTextStyles.h4(
                                                          context,
                                                        ),
                                                      ),
                                                    ),
                                                    paymentProvider
                                                            .paymentCardList!
                                                            .isEmpty
                                                        ? Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 16.w,
                                                                    right: 16.w,
                                                                    top: 10.h),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                paymentProvider
                                                                    .cardUpdateLink(
                                                                        context)
                                                                    .then(
                                                                        (value) {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder:
                                                                              (_) =>
                                                                                  UpdateCardScreen()));
                                                                });
                                                              },
                                                              child: Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.35,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(15.r),
                                                                  border:
                                                                      Border.all(
                                                                    color: ColorResources
                                                                            .getTextColor(
                                                                                context)
                                                                        .withOpacity(
                                                                            0.5),
                                                                  ),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10.0),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        getTranslated(
                                                                            'add_card_info',
                                                                            context),
                                                                        style: AppTextStyles.h7(
                                                                            context),
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              5),
                                                                      Icon(
                                                                          Icons
                                                                              .add,
                                                                          color: ColorResources.getTextColor(context)
                                                                              .withOpacity(0.5)),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : SizedBox(),
                                                    paymentProvider
                                                            .paymentCardList!
                                                            .isEmpty
                                                        ? SizedBox()
                                                        : Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left: 16.w,
                                                                        right: 16.w,
                                                                        top: 16,
                                                                        bottom:
                                                                            8),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10.r),
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                ColorResources.getTextColor(context).withOpacity(0.5),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              EdgeInsets.all(14),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Icon(Icons.credit_card,
                                                                                  color: ColorResources.getTextColor(context)),
                                                                              SizedBox(width: 30.w),
                                                                              Text(
                                                                                '**** **** **** ${paymentProvider.paymentCardList![0].last4}',
                                                                                style: AppTextStyles.h7(context),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 15,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap: () =>
                                                                              showModalBottomSheet(
                                                                            context:
                                                                                context,
                                                                            builder: (BuildContext context) =>
                                                                                RemoveCardBottomSheet(cardId: paymentProvider.paymentCardList![0].id!),
                                                                            backgroundColor:
                                                                                Colors.transparent,
                                                                            isScrollControlled:
                                                                                true,
                                                                            barrierColor:
                                                                                Colors.black54,
                                                                            isDismissible:
                                                                                true,
                                                                            useSafeArea:
                                                                                true,
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.all(5.r),
                                                                            child: Icon(
                                                                                Icons.delete,
                                                                                color: Colors.red),
                                                                          ),
                                                                        ),
                                                                        paymentProvider
                                                                                .loading!
                                                                            ? SizedBox(
                                                                                height: 20,
                                                                                width: 20,
                                                                                child: CustomCircularIndicator(color: Colors.white),
                                                                              )
                                                                            : GestureDetector(
                                                                                onTap: () => paymentProvider.cardUpdateLink(context).then((value) {
                                                                                  Navigator.push(context, MaterialPageRoute(builder: (_) => UpdateCardScreen()));
                                                                                }),
                                                                                child: Padding(
                                                                                  padding: EdgeInsets.all(5.r),
                                                                                  child: Icon(Icons.edit, color: ColorResources.getTextColor(context).withOpacity(0.5)),
                                                                                ),
                                                                              ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                  ],
                                                )
                                        ]),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(10.r),
                                child: !orderProv.isLoading
                                    ? Builder(
                                        builder: (context) => CustomButton(
                                            text: getTranslated(
                                                'confirm_order', context),
                                          onTap: () {
                                            if (isScheduled) {
                                              if (orderProv.selectedDeliveryDate == null) {
                                                showCustomSnackBar(getTranslated('select_delivery_date_required', context), context);
                                                return;
                                              }

                                              if (orderProv.selectedOpeningHour == null) {
                                                showCustomSnackBar(getTranslated('select_delivery_time_required', context), context);
                                                return;
                                              }
                                            }

                                            if ((paymentProvider.paymentCardList == null || paymentProvider.paymentCardList!.isEmpty) && !orderProv.useInstallment) {
                                              showCustomSnackBar(getTranslated('please_add_your_card_details', context), context);
                                              return;
                                            }

                                            PlaceOrderBody placeOrder = PlaceOrderBody(
                                              cart: widget.orderBody!.cart!,
                                              couponDiscountAmount: widget.orderBody!.couponDiscountAmount!,
                                              usePointsDiscountAmount: widget.orderBody!.usePointsDiscountAmount!,
                                              couponDiscountTitle: '',
                                              couponCode: widget.orderBody!.couponCode!,
                                              totalTaxAmount: widget.orderBody!.totalTaxAmount!,
                                              orderAmount: widget.orderBody!.orderAmount!,
                                              deliveryAddressId: widget.orderBody!.deliveryAddressId!,
                                              orderType: widget.orderBody!.orderType!,
                                              paymentMethod: 'credit_card',
                                              orderNote: _noteController.text,
                                              deliveryDate: isScheduled ? DateConverter.formatDate(context, orderProv.selectedDeliveryDate!,) : "",
                                              deliveryTime: isScheduled ? "${orderProv.selectedOpeningHour!.start}-${orderProv.selectedOpeningHour!.end}" : "",
                                              usePoints: widget.orderBody!.usePoints!,
                                              remainingUserPoints: widget.orderBody!.remainingUserPoints!,
                                              deliveryCharge: widget.orderBody!.deliveryCharge!,
                                              priorityDelivery: profileProvider.userInfoModel!.priorityBulkOrderFulfillment ?? 0,
                                              cardId: (paymentProvider.paymentCardList?.isNotEmpty ?? false)
                                                  ? paymentProvider.paymentCardList!.first.id!
                                                  : "",
                                              useInstallment: orderProv.useInstallment,
                                              months: orderProv.selectedInstallmentPlan?.months,
                                              downPayment: orderProv.useInstallment ? orderProv.downPayment : null,
                                              monthlyPayment: orderProv.useInstallment ? orderProv.monthlyPayment : null,
                                            );
                                            log("placeOrder == ${placeOrder.toJson()}");
                                            orderProv.placeOrder(placeOrder, _callback);
                                          },),
                                      )
                                    : CustomCircularIndicator(),
                              ),
                              SizedBox(height: 20.h)
                            ],
                          );
                    },
                  )
                : NotLoggedInScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildSchedulingOption(
      {required BuildContext context,
      required OrderProvider orderProv,
      required int value,
      required String textKey}) {
    bool selected = (orderProv.isScheduledOrder ?? false) == (value == 1);
    return GestureDetector(
      onTap: () {
        if (value == 1) {
          orderProv.setScheduledOrder(true);
        } else {
          orderProv.setScheduledOrder(false);

          orderProv.clearSelectDeliveryDate();
          orderProv.clearSelectedTime();
        }
      },
      child: Row(
        children: [
          Icon(
              selected
                  ? Icons.check_circle_sharp
                  : Icons.circle_outlined,
              color: selected
                  ? ColorResources.getSecondaryColor(context)
                  : ColorResources.getBorderColor(context)),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              getTranslated(textKey, context),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.h6(
                context,
                fontSize: 15.sp,
              ).copyWith(
                color: selected
                    ? ColorResources.getSecondaryColor(context)
                    : ColorResources.getTextColor(context).withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildScheduleWidget(
      BuildContext context,
      OrderProvider orderProv,
      Map<String, WorkingHoursModel> workingHours,
      ){
    List<WorkingHourRangeModel> selectedDayHours = [];

    if (orderProv.selectedDeliveryDate != null) {

      final selectedDay = DateConverter.dateToWeekDay(
        context,
        orderProv.selectedDeliveryDate!,
      );

      selectedDayHours =
          workingHours[selectedDay]?.hours ?? [];
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// Pick Date
        Row(
          children: [
            Icon(
              Icons.calendar_month,
              color: Colors.green,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              getTranslated('pick_a_date', context),
              style: AppTextStyles.h4(context),
            ),
          ],
        ),

        SizedBox(height: 15.h),
        Row(
          children: [

            IconButton(
              onPressed: () {
                DateTime previous =
                _weekStart.subtract(const Duration(days: 14));

                if (!previous.isBefore(
                    DateTime.now().subtract(const Duration(days: 1)))) {
                  setState(() {
                    _weekStart = previous;
                  });
                }
              },
              icon:  Icon(Icons.chevron_left , color: ColorResources.getTextColor(context).withOpacity(0.6),),
            ),

            Expanded(
              child: Center(
                child: Text(
                  "${DateConverter.dateToMonth(context, _weekStart)} ${_weekStart.year}",
                  style: AppTextStyles.h5(context),
                ),
              ),
            ),

            IconButton(
              onPressed: () {
                setState(() {
                  _weekStart =
                      _weekStart.add(const Duration(days: 14));
                });
              },
              icon:  Icon(Icons.chevron_right , color: ColorResources.getTextColor(context).withOpacity(0.6),),
            ),
          ],
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 14,
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.35,
          ),
          itemBuilder: (context, index) {
            DateTime date = _weekStart.add(Duration(days: index));
            String dayName = DateConverter.dateToWeekDay(context, date);

            final dayConfig = workingHours[dayName];

            bool enabled = dayConfig?.enabled == true;
            final DateTime today = DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            );

            bool isPastOrToday =
                date.isBefore(today) || DateUtils.isSameDay(date, today);

            enabled = enabled && !isPastOrToday;
            bool selected =
                orderProv.selectedDeliveryDate != null &&
                    DateUtils.isSameDay(
                      orderProv.selectedDeliveryDate!,
                      date,
                    );

            return GestureDetector(
              onTap: enabled
                  ? () {
                orderProv.setSelectDeliveryDate(date);
              }
                  : null,
              child: Opacity(
                opacity: enabled ? 1 : .35,
                child: Container(
                  decoration: BoxDecoration(
                    color: selected
                        ? ColorResources.getPrimaryColor(context)
                        :ColorResources.getCardColor(context),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text(
                        DateConverter.dateToShortWeekDay(context ,date),
                        style: AppTextStyles.h7(context),
                      ),

                      SizedBox(height: 3.h),

                      Text(
                        "${date.day}",
                        style: AppTextStyles.h3(context).copyWith(
                          color: selected
                              ? Colors.white
                              : ColorResources.getTextColor(context),
                        ),
                      ),

                      SizedBox(height: 3.h),

                      Text(
                        DateConverter.dateToMonth(context ,date),
                        style: AppTextStyles.h7(context).copyWith(
                          color: selected
                              ? Colors.white
                              : ColorResources.getHintColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        SizedBox(height: 25.h),

        /// Choose Time
        Row(
          children: [
            Icon(
              Icons.access_time,
              color: Colors.green,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              getTranslated('choose_a_time', context),
              style: AppTextStyles.h4(context),
            ),
          ],
        ),

        SizedBox(height: 15.h),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: selectedDayHours.length,
          itemBuilder: (context, index) {

            final slot = selectedDayHours[index];
            bool selected =
                orderProv.selectedOpeningHour == slot;

            return GestureDetector(
              onTap: () {
                orderProv.setSelectedTime(slot);
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 18.h,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? ColorResources.getPrimaryColor(context)
                      : ColorResources.getCardColor(context),
                  borderRadius: BorderRadius.circular(12.r),

                ),
                child: Text(
                  "${DateConverter.convertTimeToTime(slot.start!)} - ${DateConverter.convertTimeToTime(slot.end!)}",
                  style: AppTextStyles.h6(context).copyWith(
                    color: selected
                        ? Colors.white
                        : ColorResources.getTextColor(context),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
  void _callback(
      bool isSuccess, String message, String orderID, int addressID) async {
    if (isSuccess) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  DashboardScreen(pageIndex: 2)));
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (BuildContext context) => PaymentWebView(
      //               url: '${AppConstants.baseUrl}/paypal/create/${orderID}',
      //               fromCheckoutScreen: true,
      //             )));
    } else {
      showCustomSnackBar(
          getTranslated('something_went_wrong', context), context);
    }
  }
}
