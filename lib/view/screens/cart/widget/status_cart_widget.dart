import 'package:flutter/material.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/utill/Images.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/view/screens/checkout/payment_screen.dart';
import 'package:wired_express/view/screens/checkout/submit_order_screen.dart';
import 'package:wired_express/view/screens/dashboard/dashboard_screen.dart';

class StatusCartWidget extends StatelessWidget {
  final bool? cart, delivery, payment, order;
  const StatusCartWidget(
      {super.key, this.cart, this.delivery, this.payment, this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            DashboardScreen(pageIndex: 0)));
              },
              child: Column(
                children: [
                  Text(
                    getTranslated('my_cart', context),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    // height: 80,
                    // width: 80,
                    decoration: BoxDecoration(
                        color: cart == true
                            ? ColorResources.getScaffoldColor(context)
                            : Colors.grey[400],
                        borderRadius: BorderRadius.circular(50)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Image.asset(
                        Images.cartIcon,
                        color: cart == true ? Colors.white : Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ),
            // Column(
            //   children: [
            //     Text(
            //       getTranslated('delivery', context),
            //       style: TextStyle(fontWeight: FontWeight.bold),
            //     ),
            //     SizedBox(
            //       height: 10,
            //     ),
            //     Container(
            //       // height: 80,
            //       // width: 80,
            //       decoration: BoxDecoration(
            //           color: delivery == true
            //               ? ColorResources.getScaffoldColor(context)
            //               : Colors.grey[400],
            //           borderRadius: BorderRadius.circular(50)),
            //       child: Padding(
            //           padding: const EdgeInsets.all(20),
            //           child: Icon(
            //             Icons.location_on_outlined,
            //             color: delivery == true ? Colors.white : Colors.black,
            //           )),
            //     )
            //   ],
            // ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => PaymentScreen()));
              },
              child: Column(
                children: [
                  Text(
                    getTranslated('PAYMENT', context),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    // height: 80,
                    // width: 80,
                    decoration: BoxDecoration(
                        color: payment == true
                            ? ColorResources.getScaffoldColor(context)
                            : Colors.grey[400],
                        borderRadius: BorderRadius.circular(50)),
                    child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Icon(
                          Icons.attach_money,
                          color: payment == true ? Colors.white : Colors.black,
                        )),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            SubmitOrderScreen()));
              },
              child: Column(
                children: [
                  Text(
                    getTranslated('order', context),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    // height: 80,
                    // width: 80,
                    decoration: BoxDecoration(
                        color: order == true
                            ? ColorResources.getScaffoldColor(context)
                            : Colors.grey[400],
                        borderRadius: BorderRadius.circular(50)),
                    child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Image.asset(
                          Images.orderIcon,
                          color: order == true ? Colors.white : Colors.black,
                        )),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
