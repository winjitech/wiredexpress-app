import 'package:flutter/material.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/location_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/timer_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_text_field.dart';
import 'package:wired_express/view/base/main_app_bar.dart';
import 'package:wired_express/view/screens/address/add_new_address_screen.dart';
import 'package:wired_express/view/screens/dashboard/dashboard_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/theme/dark_theme.dart';
import 'package:wired_express/theme/light_theme.dart';
import 'package:provider/provider.dart';

class VerifyPhoneCodeScreen extends StatefulWidget {
  final String phone;

  VerifyPhoneCodeScreen({Key? key, required this.phone}) : super(key: key);
  @override
  _VerifyPhoneCodeScreenState createState() => _VerifyPhoneCodeScreenState();
}

class _VerifyPhoneCodeScreenState extends State<VerifyPhoneCodeScreen> {
  GlobalKey<FormState>? _formKeyLogin;
  final TextEditingController _smsCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    ;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final location = Provider.of<LocationProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      appBar: ResponsiveHelper.isDesktop(context)
          ? PreferredSize(
              child: MainAppBar(), preferredSize: Size.fromHeight(80))
          : null,
      body: SafeArea(
        child: Column(
          children: [
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius:
                            BorderRadius.circular(50)),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: ColorResources.getScaffoldColor(context),
                            size: 19,
                          ),
                        )),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Scrollbar(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Consumer2<CustomAuthProvider, TimerProvider>(
                        builder: (context, authProvider, timerProvider, child) =>
                            Form(
                          key: _formKeyLogin,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [


                              Center(
                                child: Image.asset(
                                  Images.logo_2,
                                  height: 150,

                                ),
                              ),
                              Center(
                                  child: Text(
                                getTranslated('verify_phone_num', context),
                                style: TextStyle(
                                        fontSize: 24,
                                        color: ColorResources.getTextColor(context)),
                              )),
                              SizedBox(height: 15),
                              Text(
                                '${getTranslated('please_enter_6_digit_code', context)} ${widget.phone}',
                                textAlign: TextAlign.start,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 18,
                                        color: ColorResources.getHintColor(context)),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 35),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getTranslated('enter_the_code', context),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              fontSize: 16,
                                              color: ColorResources.getTextColor(
                                                  context)),
                                    ),
                                    SizedBox(height: 15),
                                    PinCodeTextField(
                                      controller: _smsCodeController,
                                      length: 6,
                                      appContext: context,
                                      obscureText: false,
                                      keyboardType: TextInputType.number,
                                      textStyle: TextStyle(
                                          color: ColorResources.getScaffoldColor(context)),
                                      animationType: AnimationType.fade,
                                      pinTheme: PinTheme(
                                        shape: PinCodeFieldShape.box,
                                        fieldHeight: 63,
                                        fieldWidth: MediaQuery.of(context)
                                                    .size
                                                    .width
                                                    .toInt() /
                                                6 -
                                            (10 + 5),
                                        borderWidth: 1,
                                        borderRadius: BorderRadius.circular(10),
                                        selectedColor:
                                            ColorResources.getGreyColor(context),
                                        selectedFillColor:
                                            ColorResources.getScaffoldBackgroundColor(
                                                context),
                                        inactiveFillColor:
                                            ColorResources.getSearchBg(context),
                                        inactiveColor:
                                            ColorResources.getGreyColor(context),
                                        activeColor:
                                            ColorResources.getGreyColor(context),
                                        activeFillColor:
                                            ColorResources.getSearchBg(context),
                                      ),
                                      animationDuration: Duration(milliseconds: 300),
                                      backgroundColor: Colors.transparent,
                                      enableActiveFill: true,
                                      beforeTextPaste: (text) {
                                        return true;
                                      },
                                      onChanged: (String value) {},
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        timerProvider.countDown > 0
                                            ? Text(
                                                "${getTranslated('resend_code_in', context)} ${timerProvider.countDown} seconds",
                                                style: TextStyle(
                                                    color:
                                                        ColorResources.getTextColor(
                                                            context)),
                                              )
                                            : TextButton(
                                                onPressed: () async {
                                                  timerProvider.resetTimer();
                                                  print(widget.phone);
                                                  await authProvider
                                                      .verifyPhoneNumber(
                                                          context, widget.phone);
                                                },
                                                child: Text(
                                                  getTranslated(
                                                      'resend_code', context),
                                                  style: TextStyle(
                                                      color: ColorResources
                                                          .getScaffoldColor(context)),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // for login button
                              authProvider.isLoading == true
                                  ? CustomCircularIndicator()
                                  : _smsCodeController.text.isEmpty
                                      ? CustomButton(
                                          text: getTranslated('login', context),
                                          onTap: () async {},
                                          backgroundColor: Colors.black12,
                                        )
                                      : CustomButton(
                                          text: getTranslated('login', context),
                                          onTap: () async {
                                            // print(widget.phone);
                                            FocusScope.of(context).unfocus();

                                            await authProvider
                                                .signInWithVerificationID(
                                                    context,
                                                    authProvider.verificationId!,
                                                    _smsCodeController.text);
                                            authProvider.deleteVerificationId;
                                            print(
                                                'authProvider.verificationId =>>> ${authProvider.verificationId}');
                                          },
                                        ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
