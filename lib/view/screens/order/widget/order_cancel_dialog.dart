import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/order_provider.dart';
import 'package:wired_express/provider/place_order_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';

class OrderCancelDialog extends StatelessWidget {
  final String? orderID;
  final Function? callback;
  OrderCancelDialog({@required this.orderID, @required this.callback});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorResources.SCAFFOLD_COLOR,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 300,
        child: Consumer2<OrderProvider, PlaceOrderProvider>(
          builder: (context, order, placeOrderProvider, child) {
            return Column(mainAxisSize: MainAxisSize.min, children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: 50),
                child: Text(getTranslated('are_you_sure_to_cancel', context),
                    style: rubikBold.copyWith(
                        color:
                            ColorResources.getScaffoldBackgroundColor(context)),
                    textAlign: TextAlign.center),
              ),
              Divider(height: 0, color: ColorResources.getHintColor(context)),
              !order.isLoading
                  ? Row(children: [
                      Expanded(
                          child: InkWell(
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
                              EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10))),
                          child: Text(getTranslated('yes', context),
                              style: rubikBold.copyWith(
                                  color:
                                      ColorResources.getScaffoldBackgroundColor(
                                          context))),
                        ),
                      )),
                      Expanded(
                          child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding:
                              EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: ColorResources.getScaffoldBackgroundColor(
                                  context),
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10))),
                          child: Text(getTranslated('no', context),
                              style: rubikBold.copyWith(
                                  color: ColorResources.SCAFFOLD_COLOR)),
                        ),
                      )),
                    ])
                  : Center(
                      child: Padding(
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              ColorResources.COLOR_WHITE)),
                    )),
            ]);
          },
        ),
      ),
    );
  }
}
