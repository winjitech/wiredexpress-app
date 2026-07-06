import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/location_provider.dart';
import 'package:wired_express/provider/order_provider.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/screens/address/address_screen.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/utill/color_resources.dart';

class AddressBottomSheet extends StatefulWidget {
  @override
  State<AddressBottomSheet> createState() => _AddressBottomSheetState();
}

class _AddressBottomSheetState extends State<AddressBottomSheet> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 0), () {
      CustomAuthProvider authProvider =
          Provider.of<CustomAuthProvider>(context, listen: false);

      int? id = authProvider.getUserAddressId();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocationProvider, CustomAuthProvider>(
      builder: (context, locationProvider, authProvider, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.r),
                topLeft: Radius.circular(20.r)),
            color: ColorResources.getScaffoldBackgroundColor(context),
          ),
          padding: EdgeInsets.all(35.r),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  getTranslated('select_delivery_location', context),
                  style: AppTextStyles.h2(context),
                ),
                SizedBox(height: 15.h),
                Consumer2<OrderProvider, LocationProvider>(
                  builder: (context, orderProvider, locationProvider, _) {
                    return locationProvider.addressList != null
                        ? locationProvider.addressList!.length > 0
                            ? Column(
                                children: [
                                  ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount:
                                        locationProvider.addressList!.length,
                                    itemBuilder: (context, index) {
                                      final addressModel =
                                          locationProvider.addressList![index];
                                      return Column(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                                color:
                                                    ColorResources
                                                        .getBackgroundColor(
                                                            context),
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                                border: addressModel.id ==
                                                        authProvider
                                                            .getUserAddressId()
                                                    ? Border.all(
                                                        color: ColorResources
                                                            .getPrimaryColor(
                                                                context),
                                                        width: 2)
                                                    : null),
                                            child: MaterialButton(
                                              minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              onPressed: () {
                                                authProvider.saveUserAddressId(
                                                    addressModel.id!);
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.all(0),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      getAddressIcon(
                                                          addressModel
                                                              .addressType),
                                                      color: addressModel.id ==
                                                              authProvider
                                                                  .getUserAddressId()
                                                          ? ColorResources
                                                              .getPrimaryColor(
                                                                  context)
                                                          : ColorResources
                                                              .getHintColor(
                                                                  context),
                                                      size: 30.sp,
                                                    ),
                                                    SizedBox(width: 5.w),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          addressModel
                                                              .addressType!,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              AppTextStyles.h7(
                                                                      context)
                                                                  .copyWith(
                                                            color: ColorResources
                                                                .getHintColor(
                                                                    context),
                                                          ),
                                                        ),
                                                        Text(
                                                          addressModel.address!,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              AppTextStyles.h7(
                                                                  context),
                                                        ),
                                                      ],
                                                    ),
                                                    const Spacer(),
                                                    addressModel.id ==
                                                            authProvider
                                                                .getUserAddressId()
                                                        ? Align(
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: Icon(
                                                              Icons
                                                                  .check_circle,
                                                              color: ColorResources
                                                                  .getPrimaryColor(
                                                                      context),
                                                            ),
                                                          )
                                                        : SizedBox(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 15.h),
                                        ],
                                      );
                                    },
                                  ),
                                  SizedBox(height: 20.h),
                                  if (authProvider.getUserAddressId() != 0)
                                    CustomButton(
                                      text: getTranslated('confirm', context),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  SizedBox(height: 15.h),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              AddressScreen(),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          getTranslated('add', context),
                                          style: AppTextStyles.h7(context)
                                              .copyWith(
                                            color: ColorResources
                                                .getGreyBunkerColor(context),
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        Icon(
                                          Icons.add,
                                          color:
                                              ColorResources.getGreyBunkerColor(
                                                  context),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(25.r),
                                      child: Text(
                                        getTranslated(
                                            'no_address_available', context),
                                        style:
                                            AppTextStyles.h6(context).copyWith(
                                          fontSize: 15.sp,
                                          color: ColorResources.getTextColor(
                                                  context)
                                              .withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15.h),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                AddressScreen(),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            getTranslated('add', context),
                                            style: AppTextStyles.h4(context)
                                                .copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: ColorResources
                                                  .getGreyBunkerColor(context),
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          Icon(
                                            Icons.add,
                                            color: ColorResources
                                                .getGreyBunkerColor(context),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                        : CustomCircularIndicator();
                  },
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData getAddressIcon(String? addressType) {
    switch (addressType) {
      case 'Home':
        return Icons.home_outlined;
      case 'Workplace':
        return Icons.work_outline;
      default:
        return Icons.list_alt_outlined;
    }
  }
}
