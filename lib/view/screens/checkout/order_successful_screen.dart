import 'package:flutter/material.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/place_order_provider.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/screens/dashboard/dashboard_screen.dart';
import 'package:wired_express/view/screens/track/order_tracking_screen.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/utill/color_resources.dart';

import 'package:wired_express/data/model/response/order_model.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/order_provider.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/routes.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/main_app_bar.dart';

class OrderSuccessfulScreen extends StatelessWidget {
  final String? orderID;
  final int? status;
  OrderSuccessfulScreen({@required this.orderID, @required this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
        appBar: ResponsiveHelper.isDesktop(context)
            ? PreferredSize(
                child: MainAppBar(), preferredSize: Size.fromHeight(80))
            : null,
        body: Consumer<OrderProvider>(builder: (context, order, child) {
          return order.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          ColorResources.getPrimaryColor(context))))
              : Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: ColorResources.getPrimaryColor(context)
                                  .withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              status == 0
                                  ? Icons.check_circle
                                  : status == 1
                                      ? Icons.sms_failed
                                      : Icons.cancel,
                              color: ColorResources.getPrimaryColor(context),
                              size: 80,
                            ),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                          Text(
                            getTranslated(
                                status == 0
                                    ? 'order_placed_successfully'
                                    : status == 1
                                        ? 'payment_failed'
                                        : 'payment_cancelled',
                                context),
                            style: rubikMedium.copyWith(
                                color: ColorResources.getTextColor(context),
                                fontSize: Dimensions.FONT_SIZE_LARGE),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${getTranslated('order_id', context)}:',
                                    style: rubikRegular.copyWith(
                                        color: ColorResources.getTextColor(
                                            context),
                                        fontSize: Dimensions.FONT_SIZE_SMALL)),
                                SizedBox(
                                    width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                Text(orderID!,
                                    style: rubikMedium.copyWith(
                                        color: ColorResources.getTextColor(
                                            context),
                                        fontSize: Dimensions.FONT_SIZE_SMALL)),
                              ]),
                          SizedBox(height: 30),
                          Padding(
                            padding:
                                EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                            child: CustomButton(
                                text: getTranslated(
                                    status == 0 ? 'track_order' : 'back_home',
                                    context),
                                onTap: () {
                                  if (status == 0) {
                                    Provider.of<OrderProvider>(context,
                                                    listen: false)
                                                .deliveryManModel ==
                                            null
                                        ? showCustomSnackBar(
                                            getTranslated(
                                                'cant_track', context),
                                            context)
                                        : order
                                            .trackOrder(
                                                orderID!,
                                                OrderModel(id: 0),
                                                context,
                                                true)
                                            .then((value) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        OrderTrackingScreen(
                                                          orderID: orderID,
                                                        )));
                                          });
                                  } else {
                                    Navigator.pop(context);
                                    // Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
                                  }
                                }),

                          ),

                    Padding(
                        padding:
                        EdgeInsets.only(right:Dimensions.PADDING_SIZE_LARGE ,
                        left : Dimensions.PADDING_SIZE_LARGE ,
                        top:0),
                        child:   CustomButton(

                              text: getTranslated('back_home', context),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            DashboardScreen(pageIndex: 0)));
                              },
                        backgroundColor: Colors.transparent,
                        borderColor: ColorResources.getPrimaryColor(context),
                        textColor: ColorResources.getPrimaryColor(context) ,))
                        ]),
                  ),
                );
        }));
  }
}
