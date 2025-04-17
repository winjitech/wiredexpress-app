import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/screens/auth/login_screen.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_text_field.dart';
import 'package:wired_express/view/base/main_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/view/screens/dashboard/dashboard_screen.dart';

class LoginWithPhoneScreen extends StatefulWidget {
  @override
  _LoginWithPhoneScreenState createState() => _LoginWithPhoneScreenState();
}

class _LoginWithPhoneScreenState extends State<LoginWithPhoneScreen> {
  FocusNode _phoneNumberFocus = FocusNode();
  String countryCode = "Pr";
  TextEditingController? _phoneController;
  GlobalKey<FormState>? _formKeyLogin;

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<CustomAuthProvider>(context);

    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      appBar: ResponsiveHelper.isDesktop(context)
          ? PreferredSize(
              child: MainAppBar(), preferredSize: Size.fromHeight(80))
          : null,
      body: Column(
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
                        borderRadius: BorderRadius.circular(50)),
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
                    padding: const EdgeInsets.all(20),
                    child: Consumer<CustomAuthProvider>(
                      builder: (context, authProvider, child) => Form(
                        key: _formKeyLogin,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [


                            Center(
                              child: Image.asset(
                                Images.logo_2,
                                height: 150,

                              ),
                            ),
                            Center(
                                child: Text(
                              getTranslated('login', context),
                              style:TextStyle(
                                  fontSize: 24,
                                  color: ColorResources.getTextColor(context)),
                            )),
                            SizedBox(height: 35),
                            Text(
                              getTranslated('phone', context),
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  fontSize: 16,
                                  color: ColorResources.getTextColor(context)),
                            ),
                            SizedBox(height: 10),
                            Container(
                              // decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(10),
                              //     border: Border.all(
                              //         color: ColorResources.getTextColor(context),
                              //         width: 0.1)),
                              child: Row(
                                children: [
                                  CountryCodePicker(
                                    backgroundColor: Provider.of<ThemeProvider>(
                                                context,
                                                listen: false)
                                            .darkTheme
                                        ? Colors.black26
                                        : Colors.grey[100],
                                    barrierColor: Provider.of<ThemeProvider>(context,
                                                listen: false)
                                            .darkTheme
                                        ? Colors.black26
                                        : Colors.grey[100],
                                    dialogBackgroundColor:
                                        ColorResources.getScaffoldBackgroundColor(
                                            context),
                                    dialogSize: Size(350, 500),
                                    dialogTextStyle: TextStyle(
                                      color: ColorResources.getTextColor(context),
                                    ),
                                    searchStyle: TextStyle(
                                      color: ColorResources.getTextColor(context),
                                    ),
                                    searchDecoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      prefixIcon: Icon(Icons.search,
                                          color:
                                              ColorResources.getHintColor(context)),
                                      hintText: 'write country',
                                      hintStyle: TextStyle(
                                          color:
                                              ColorResources.getHintColor(context)),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                ColorResources.getTextColor(context)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                ColorResources.getTextColor(context)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                ColorResources.getTextColor(context)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    closeIcon: Icon(
                                      Icons.close,
                                      color: ColorResources.getTextColor(context),
                                    ),
                                    onChanged: (val) => countryCode = val.toString(),
                                    onInit: (val) => countryCode = val.toString(),
                                    initialSelection: countryCode,
                                    textStyle: TextStyle(
                                      color: ColorResources.getTextColor(context),
                                    ),
                                    flagDecoration: BoxDecoration(
                                      color: Provider.of<ThemeProvider>(context,
                                                  listen: false)
                                              .darkTheme
                                          ? Colors.black26
                                          : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  Expanded(
                                    child: CustomTextField(
                                      hintText: getTranslated(
                                          'enter_phone_number', context),
                                      isShowBorder: false,
                                      isCountryPicker: true,
                                      focusNode: _phoneNumberFocus,
                                      controller: _phoneController,
                                      inputType: TextInputType.phone,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                            authProvider.isLoading == true
                                ? CustomCircularIndicator()
                                :  CustomButton(
                              text: getTranslated('next', context),
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                // 10 m3da4 .........11 3da ..... 15 m3da4
                                String phone = countryCode + _phoneController!.text;
                                await authProvider
                                    .verifyPhoneNumber(context, phone);
                                    // .then((value) => phone.length <= 10
                                    //     ? _phoneController!.text.isEmpty
                                    //         ? showCustomSnackBar(
                                    //             getTranslated(
                                    //                 'enter_phone_number', context),
                                    //             context)
                                    //         : showCustomSnackBar(
                                    //             getTranslated(
                                    //                 'phone_num_too_short', context),
                                    //             context)
                                    //     : phone.length > 15
                                    //         ? showCustomSnackBar(
                                    //             getTranslated(
                                    //                 'phone_num_too_long', context),
                                    //             context)
                                    //         : Navigator.push(
                                    //             context,
                                    //             MaterialPageRoute(
                                    //                 builder: (BuildContext context) =>
                                    //                     VerifyPhoneCodeScreen(
                                    //                         phone: phone))));
                              },
                            ),
                            SizedBox(height: 15),
                            Center(
                              child: GestureDetector(
                                onTap: () async {
                                  final pref =
                                  await SharedPreferences.getInstance();
                                  await pref.clear();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              DashboardScreen(pageIndex: 0)));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    getTranslated('login_as_guest', context),
                                    style: TextStyle(
                                        color:
                                        ColorResources.getTextColor(context)
                                            .withOpacity(0.6),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15  , decoration: TextDecoration.underline),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 15),
                            Row(
                              children: [
                                Expanded(
                                    child: Divider(
                                  thickness: 1,
                                )),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(getTranslated('or', context)),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                    child: Divider(
                                  thickness: 1,
                                )),
                              ],
                            ),
                            SizedBox(height: 5),
                            TextButton(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              LoginScreen()));
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      getTranslated('login_by_email', context),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500, fontSize: 16),
                                    ),
                                  ],
                                )),
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
    );
  }
}
