import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/place_order_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/Images.dart';
import 'package:wired_express/utill/color_resources.dart';

import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/order_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/routes.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_main_appbar.dart';
import 'package:wired_express/view/base/custom_text_field.dart';
import 'package:wired_express/view/screens/cart/widget/status_cart_widget.dart';
import 'package:wired_express/view/screens/checkout/submit_order_screen.dart';
import 'package:wired_express/view/screens/checkout/widget/cancel_dialog.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wired_express/view/screens/checkout/widget/payment_methods_widget.dart';
import 'package:wired_express/view/screens/drawer/drawer_screen.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final advancedDrawerController = AdvancedDrawerController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  ScrollController scrollController = ScrollController();

  FocusNode _oneFocus = FocusNode();
  FocusNode _twoFoucs = FocusNode();
  FocusNode _threeFoucs = FocusNode();
  FocusNode _fourFoucs = FocusNode();

  TextEditingController? _oneController;
  TextEditingController? _twoController;
  TextEditingController? _threeController;
  TextEditingController? _fourController;

  GlobalKey<FormState>? _formKeyLogin;

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _oneController = TextEditingController();
    _twoController = TextEditingController();
    _threeController = TextEditingController();
    _fourController = TextEditingController();
  }

  @override
  void dispose() {
    _oneController!.dispose();
    _twoController!.dispose();
    _threeController!.dispose();
    _fourController!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      rtlOpening: false,
      openRatio: 0.55,
      openScale: 0.80,
      backdrop: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15),
        child: IconButton(
            onPressed: () {
              closeDrawer();
            },
            icon: Icon(
              Icons.close,
              color: Colors.white,
              size: 36,
            )),
      )),
      childDecoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
      controller: advancedDrawerController,
      animationCurve: Curves.easeInOutExpo,
      animationDuration: Duration(milliseconds: 400),
      backdropColor: ColorResources.getScaffoldColor(context),
      drawer: DrawerScreen(),
      child: Scaffold(
        backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
        key: _scaffoldKey,
        appBar: CustomMainAppBar(
          onMenuPressed: () => showDrawer(),
          title: getTranslated('PAYMENT', context),
        ),
        body: Consumer<CustomAuthProvider>(
          builder: (context, customAuthProvider, child) {
            return Scrollbar(
              child: SingleChildScrollView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                //  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      StatusCartWidget(
                        delivery: true,
                        payment: true,
                        cart: true,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      PaymentMethodsWiget(),
                      SizedBox(
                        height: 40,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          getTranslated('credit_Details', context),
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 18),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                        hintText: getTranslated('name', context),
                        controller: _oneController,
                        focusNode: _oneFocus,
                        nextFocus: _twoFoucs,
                        inputType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                        hintText: '0000-0000-0000-0000',
                        controller: _twoController,
                        focusNode: _twoFoucs,
                        nextFocus: _threeFoucs,
                        inputType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              hintText: '09/2021',
                              controller: _threeController,
                              focusNode: _threeFoucs,
                              nextFocus: _fourFoucs,
                              inputType: TextInputType.text,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: CustomTextField(
                              hintText: '0000',
                              controller: _fourController,
                              focusNode: _fourFoucs,
                              inputType: TextInputType.text,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      // SwitchListTile(
                      //     value: true,
                      //     onChanged: (bool isActive) {},
                      //     title: Text('Save credit cart information',
                      //         style: rubikMedium.copyWith(
                      //             color: ColorResources.getTextColor(context),
                      //             fontSize: Dimensions.FONT_SIZE_LARGE)),
                      //     activeColor: ColorResources.getScaffoldColor(context)),
                      SizedBox(
                        height: 40,
                      ),
                      CustomButton(
                        text: getTranslated('next_step', context),
                        onTap: () {
                          Provider.of<PlaceOrderProvider>(context,
                                  listen: false)
                              .creditCardDetails(
                            paymentName: _oneController!.text.trim(),
                            paymentNumber: _twoController!.text.trim(),
                            paymentDate: _threeController!.text.trim(),
                            paymentCode: _fourController!.text.trim(),
                          );
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      SubmitOrderScreen()));
                        },
                      )
                    ],
                  ),
                )),
              ),
            );
          },
        ),
      ),
    );
  }

  void showDrawer() {
    if (mounted) {
      advancedDrawerController.showDrawer();
    }
  }

  void closeDrawer() {
    if (mounted) {
      advancedDrawerController.hideDrawer();
    }
  }
}
