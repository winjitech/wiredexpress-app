// import 'package:flutter/material.dart';
// import 'package:wired_express/localization/language_constrants.dart';
// import 'package:wired_express/utill/dimensions.dart';
// import 'package:wired_express/utill/routes.dart';
// import 'package:wired_express/utill/styles.dart';
// import 'package:wired_express/view/base/custom_button.dart';
// import 'package:wired_express/view/screens/order/order_details_screen.dart';
//
// class CancelDialog extends StatelessWidget {
//   final int? orderID;
//   final bool? fromCheckout;
//   CancelDialog({@required this.orderID, @required this.fromCheckout});
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
//       child: Padding(
//         padding: EdgeInsets.all(20.r),
//         child: Column(mainAxisSize: MainAxisSize.min, children: [
//
//           Container(
//             height: 70, width: 70,
//             decoration: BoxDecoration(
//               color: ColorResources.getPrimaryColor(context),.withOpacity(0.2),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               Icons.check_circle,
//               color: ColorResources.getPrimaryColor(context), size: 50.sp,
//             ),
//           ),
//           SizedBox(height: 20.h),
//
//           fromCheckout! ? Text(
//             getTranslated('order_placed_successfully', context),
//             style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: ColorResources.getPrimaryColor(context),),
//           ) : SizedBox(),
//           SizedBox(height: fromCheckout! ? Dimensions.PADDING_SIZE_SMALL : 0),
//
//           Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//             Text('${getTranslated('order_id', context)}:', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
//             SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
//             Text(orderID.toString(), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
//           ]),
//          SizedBox(height: 30.h),
//
//           Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//             Icon(Icons.info, color: ColorResources.getPrimaryColor(context),),
//             Text(
//               getTranslated('payment_failed', context),
//               style: rubikMedium.copyWith(color: ColorResources.getPrimaryColor(context),),
//             ),
//           ]),
//           SizedBox(height: 10.h),
//
//           Text(
//             getTranslated('payment_process_is_interrupted', context),
//             style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
//             textAlign: TextAlign.center,
//           ),
//          SizedBox(height: 30.h),
//
//           Row(children: [
//             Expanded(child: SizedBox(
//               height: 50,
//               child: TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   // Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
//                 },
//                 style: TextButton.styleFrom(
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r), side: BorderSide(width: 2, color: ColorResources.getPrimaryColor(context),)),
//                 ),
//                 child: Text(getTranslated('maybe_later', context), style: rubikBold.copyWith(color: ColorResources.getPrimaryColor(context),)),
//               ),
//             )),
//             SizedBox(width: 10.w),
//             Expanded(child: CustomButton(text: getTranslated('order_details', context), onTap: () {
//               Navigator.pop(context);
//               Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> OrderDetailsScreen(orderId: orderID!, orderModel: null,)));
//
//               // Navigator.pushNamed(context, Routes.getOrderDetailsRoute(orderID!));
//             })),
//           ]),
//
//         ]),
//       ),
//     );
//   }
// }
