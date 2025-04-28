import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/helper/date_converter.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/coupon_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/base/main_app_bar.dart';
import 'package:wired_express/view/base/no_data_screen.dart';
import 'package:wired_express/view/base/not_logged_in_screen.dart';
import 'package:provider/provider.dart';

class CouponScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn =
        Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn()!;
    if (_isLoggedIn) {
      Provider.of<CouponProvider>(context, listen: false)
          .getCouponList(context);
    }

    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      appBar: CustomAppBar(title: getTranslated('coupon', context)),
      body: _isLoggedIn
          ? Consumer<CouponProvider>(
              builder: (context, coupon, child) {
                return coupon.couponListLoading != true
                    ? coupon.couponList != null
                        ? coupon.couponList!.length > 0
                            ? RefreshIndicator(
                                onRefresh: () async {
                                  await Provider.of<CouponProvider>(context,
                                          listen: false)
                                      .getCouponList(context);
                                },
                                backgroundColor:
                                    ColorResources.getScaffoldColor(context),
                                child: Scrollbar(
                                  child: SingleChildScrollView(
                                    child: Center(
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ListView.builder(
                                          itemCount: coupon.couponList!.length,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: const EdgeInsets.all(
                                              Dimensions.PADDING_SIZE_LARGE),
                                          itemBuilder: (context, index) {
                                            print(
                                                'visibility ----- ${coupon.couponList![index].visibility}');
                                            int _visibleCount = 0;
                                            if (coupon.couponList![index]
                                                    .visibility ==
                                                0) {
                                              _visibleCount++;
                                            }
                                            print(
                                                'count ----- ${_visibleCount}');
                                            return coupon.couponList![index]
                                                        .visibility ==
                                                    1
                                                ? Padding(
                                                    padding: const EdgeInsets
                                                        .only(
                                                        bottom: Dimensions
                                                            .PADDING_SIZE_LARGE),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Clipboard.setData(
                                                            ClipboardData(
                                                                text: coupon
                                                                    .couponList![
                                                                        index]
                                                                    .code!));
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(SnackBar(
                                                                content: Text(
                                                                    getTranslated(
                                                                        'coupon_code_copied',
                                                                        context)),
                                                                backgroundColor:
                                                                    Colors
                                                                        .green));
                                                      },
                                                      child: Stack(children: [
                                                        Image.asset(
                                                            Images.coupon_bg,
                                                            height: 100,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            fit: BoxFit.cover,
                                                            color: ColorResources
                                                                .getCardColor(
                                                                    context)),
                                                        Container(
                                                          height: 100,
                                                          alignment:
                                                              Alignment.center,
                                                          child: Row(children: [
                                                            const SizedBox(
                                                                width: 50),
                                                            Image.asset(
                                                                Images
                                                                    .percentage,
                                                                height: 50,
                                                                color: ColorResources
                                                                    .getTextColor(
                                                                        context),
                                                                width: 50),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      Dimensions
                                                                          .PADDING_SIZE_LARGE,
                                                                  vertical:
                                                                      Dimensions
                                                                          .PADDING_SIZE_SMALL),
                                                              child: Image.asset(
                                                                  Images.line,
                                                                  color: ColorResources
                                                                      .getTextColor(
                                                                          context),
                                                                  height: 100,
                                                                  width: 5),
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    SelectableText(
                                                                      coupon
                                                                          .couponList![
                                                                              index]
                                                                          .code!,
                                                                      style: rubikRegular.copyWith(
                                                                          color:
                                                                              ColorResources.getTextColor(context)),
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                                    Text(
                                                                      '${Helpers.formatTextWithNum(coupon.couponList![index].discount.toString())}${coupon.couponList![index].discountType == 'percent' ? '%' : getTranslated('description', context) == "Description" ? 'LE' : 'ج.م'} off',
                                                                      style: rubikMedium.copyWith(
                                                                          color: ColorResources.getTextColor(
                                                                              context),
                                                                          fontSize:
                                                                              Dimensions.FONT_SIZE_EXTRA_LARGE),
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                                    Text(
                                                                      '${getTranslated('valid_until', context)} ${DateConverter.isoStringToLocalDateOnly(coupon.couponList![index].expireDate!)}',
                                                                      style: rubikRegular.copyWith(
                                                                          color: ColorResources.getTextColor(
                                                                              context),
                                                                          fontSize:
                                                                              Dimensions.FONT_SIZE_SMALL),
                                                                    ),
                                                                  ]),
                                                            ),
                                                          ]),
                                                        ),
                                                      ]),
                                                    ),
                                                  )
                                                : const SizedBox();
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : NoDataScreen()
                        : CustomCircularIndicator()
                    : CustomCircularIndicator();
              },
            )
          : NotLoggedInScreen(),
    );
  }
}
