import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/order_provider.dart';
import 'package:wired_express/provider/place_order_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';

class OrderCancelDialog extends StatelessWidget {
  final String? orderID;
  final Function? callback;
  OrderCancelDialog({@required this.orderID, @required this.callback});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: Container(
        decoration: BoxDecoration(
            color: ColorResources.getScaffoldBackgroundColor(context),
            borderRadius: BorderRadius.circular(15.r)),
        width: 300,
        child: Consumer2<OrderProvider, PlaceOrderProvider>(
          builder: (context, order, placeOrderProvider, child) {
            return Column(mainAxisSize: MainAxisSize.min, children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: 50),
                child:Text(
                  getTranslated('are_you_sure_to_cancel', context),
                  style: AppTextStyles.h2(context),
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(height: 0, color: ColorResources.getHintColor(context)),
              !order.isLoading
                  ? Row(children: [
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          // Provider.of<OrderProvider>(context, listen: false)
                          //     .cancelOrder(orderID!, () {Navigator.of(context);});
                          // Navigator.of(context);
                          order.cancelOrder(orderID!,
                              (String message, bool isSuccess, String orderID) {
                            placeOrderProvider.getRunningOrderList(context);
                            showCustomSnackBar(
                                getTranslated('order_cancelled', context),
                                context,
                                isError: false);

                            Navigator.pop(context);
                            callback!(message, isSuccess, orderID);
                          });
                          // placeOrderProvider.getRunningOrderList(context);
                          // showCustomSnackBar('canceled success', context,
                          //     isError: false);
                          // placeOrderProvider.getRunningOrderList(context);
                          // Navigator.pop(context);
                        },
                        child: Container(
                          padding:
                              EdgeInsets.all(10.r),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10))),
                          child: Text(
                            getTranslated('yes', context),
                            style: AppTextStyles.h2(context),
                          ),
                        ),
                      )),
                      Expanded(
                          child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding:
                              EdgeInsets.all(10.r),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: ColorResources.getTextColor(
                                  context),
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10))),
                          child: Text(
                            getTranslated('no', context),
                            style: AppTextStyles.h2(context).copyWith(
                              color: ColorResources.getScaffoldBackgroundColor(context),
                            ),
                          ),
                        ),
                      )),
                    ])
                  :  Padding(
                padding: EdgeInsets.all(15.r),
                child: CustomCircularIndicator(),
              ),
            ]);
          },
        ),
      ),
    );
  }
}
