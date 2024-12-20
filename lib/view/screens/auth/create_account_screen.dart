import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/view/screens/address/add_new_address_screen.dart';
import 'package:wired_express/view/screens/dashboard/dashboard_screen.dart';
import 'package:wired_express/view/screens/splash_screen.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/theme/dark_theme.dart';
import 'package:wired_express/theme/light_theme.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:wired_express/data/model/response/signup_model.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/wishlist_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/routes.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/base/custom_text_field.dart';
import 'package:wired_express/view/base/main_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:country_code_picker/country_code_picker.dart';

class CreateAccountScreen extends StatefulWidget {
  final String? email;
  CreateAccountScreen({@required this.email});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final FocusNode _firstNameFocus = FocusNode();

  final FocusNode _lastNameFocus = FocusNode();

  final FocusNode _numberFocus = FocusNode();

  final FocusNode _passwordFocus = FocusNode();

  final FocusNode _confirmPasswordFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _numberController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final TextEditingController _phoneTEC = TextEditingController();

  CountryCode? selectedCountryCode;

  String countryCode = "";

  String? accountPhoneNumber;

  int _currentValue = 25;

  countryCodeSelected(CountryCode countryCode) {
    selectedCountryCode = countryCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      appBar: ResponsiveHelper.isDesktop(context)
          ? PreferredSize(
              child: MainAppBar(), preferredSize: Size.fromHeight(80))
          : null,
      body: Consumer<CustomAuthProvider>(
        builder: (context, authProvider, child) => SafeArea(
          child: Scrollbar(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              physics: BouncingScrollPhysics(),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Text(
                        getTranslated('create_account', context),
                        style: TextStyle(
                            fontSize: 20,
                            color: ColorResources.getGreyBunkerColor(context)),
                      )),
                      SizedBox(height: 20),

                      // for first name section
                      Text(
                        getTranslated('first_name', context),
                        style: TextStyle(
                            color: ColorResources.getHintColor(context)),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      CustomTextField(
                        hintText: 'Name',
                        isShowBorder: true,
                        controller: _firstNameController,
                        focusNode: _firstNameFocus,
                        nextFocus: _lastNameFocus,
                        inputType: TextInputType.name,
                        capitalization: TextCapitalization.words,
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                      // for last name section
                      Text(
                        getTranslated('last_name', context),
                        style: TextStyle(
                            color: ColorResources.getHintColor(context)),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      CustomTextField(
                        hintText: 'Surname',
                        isShowBorder: true,
                        controller: _lastNameController,
                        focusNode: _lastNameFocus,
                        nextFocus: _numberFocus,
                        inputType: TextInputType.name,
                        capitalization: TextCapitalization.words,
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                      // for email section
                      /*  Text(
                        getTranslated('mobile_number', context),
                        style: Theme.of(context).textTheme.headline2!.copyWith(
                            color: ColorResources.getHintColor(context)),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                     CustomTextFormField(
                        prefixIcon: CountryCodePicker(
                          showCountryOnly: true,
                          initialSelection: "EG",
                          flagWidth: 16,
                          padding: EdgeInsets.all(0),
                          textStyle: TextStyle(color: Colors.black),
                          onChanged: countryCodeSelected,
                          onInit: countryCodeSelected,
                        ),
                        labelText: "",
                        hintText: getTranslated('enter_phone_number', context),
                        keyboardType: TextInputType.phone,
                        textEditingController: _phoneTEC,
                        validator: null,
                        fillColor: Colors.white,
                      ),

                     */

                      // for password section
                      Text(
                        getTranslated('password', context),
                        style: TextStyle(
                            color: ColorResources.getHintColor(context)),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      CustomTextField(
                        hintText: getTranslated('password_hint', context),
                        isShowBorder: true,
                        isPassword: true,
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        nextFocus: _confirmPasswordFocus,
                        isShowSuffixIcon: true,
                      ),
                      SizedBox(height: 22),

                      // for confirm password section
                      Text(
                        getTranslated('confirm_password', context),
                        style: TextStyle(
                            color: ColorResources.getHintColor(context)),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      CustomTextField(
                        hintText: getTranslated('password_hint', context),
                        isShowBorder: true,
                        isPassword: true,
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocus,
                        isShowSuffixIcon: true,
                        inputAction: TextInputAction.done,
                      ),

                      SizedBox(height: 22),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          authProvider.registrationErrorMessage!.length > 0
                              ? CircleAvatar(
                                  backgroundColor:
                                      ColorResources.getPrimaryColor(context),
                                  radius: 5)
                              : SizedBox.shrink(),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              authProvider.registrationErrorMessage ?? "",
                              style:TextStyle(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color:
                                        ColorResources.getPrimaryColor(context),
                                  ),
                            ),
                          )
                        ],
                      ),

                      // for signup button
                      SizedBox(height: 10),
                      !authProvider.isLoading!
                          ? CustomButton(
                              text: getTranslated('signup', context),
                              onTap: () {
                                String _firstName =
                                    _firstNameController.text.trim();
                                String _lastName =
                                    _lastNameController.text.trim();
                                /* String _number =
                                    "${selectedCountryCode.dialCode}${_phoneTEC.text.trim()}";*/
                                //_numberController.text.trim();

                                String _password =
                                    _passwordController.text.trim();
                                String _confirmPassword =
                                    _confirmPasswordController.text.trim();
                                RegExp passwordPattern = RegExp(
                                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$');
                                bool isPasswordValid =
                                    passwordPattern.hasMatch(_password);
                                if (_firstName.isEmpty) {
                                  showCustomSnackBar(
                                      getTranslated(
                                          'enter_first_name', context),
                                      context);
                                } else if (_lastName.isEmpty) {
                                  showCustomSnackBar(
                                      getTranslated('enter_last_name', context),
                                      context);
                                } /*else if (_number.isEmpty) {
                                  showCustomSnackBar(
                                      getTranslated(
                                          'enter_phone_number', context),
                                      context);
                                }*/
                                else if (!isPasswordValid) {
                                  showCustomSnackBar(
                                      getTranslated(
                                          'password_should_contain', context),
                                      context);
                                } else if (_password.isEmpty) {
                                  showCustomSnackBar(
                                      getTranslated('enter_password', context),
                                      context);
                                } else if (_password.length < 6) {
                                  showCustomSnackBar(
                                      getTranslated(
                                          'password_should_be', context),
                                      context);
                                } else if (_confirmPassword.isEmpty) {
                                  showCustomSnackBar(
                                      getTranslated(
                                          'enter_confirm_password', context),
                                      context);
                                } else if (_password != _confirmPassword) {
                                  showCustomSnackBar(
                                      getTranslated(
                                          'password_did_not_match', context),
                                      context);
                                } else {
                                  SignUpModel signUpModel = SignUpModel(
                                    fName: _firstName,
                                    lName: _lastName,
                                    email: widget.email,
                                    password: _password,
                                    // phone: _number,
                                  );
                                  authProvider
                                      .registration(signUpModel)
                                      .then((status) async {
                                    if (status.isSuccess) {
                                      DateTime _date = DateTime.now()
                                          .add(const Duration(days: 7));
                                      var box = Hive.box('myBox');
                                      box.put('rate_last_datetime', _date);
                                      await Provider.of<WishListProvider>(
                                              context,
                                              listen: false)
                                          .initWishListProductIds(context);
                                      await Provider.of<CartProvider>(context,
                                              listen: false)
                                          .initCartListProductIds(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  AddNewAddressScreen()));

                                      // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>
                                      //     DashboardScreen(pageIndex: 0)));

                                      // Navigator.pushNamedAndRemoveUntil(
                                      //     context,
                                      //     Routes.getMainRoute(),
                                      //     (route) => false);
                                    }
                                  });
                                }
                              },
                            )
                          : Center(
                              child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  ColorResources.getPrimaryColor(context)),
                            )),

                      // for already an account
                      SizedBox(height: 11),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, Routes.getLoginByEmailRoute());
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                getTranslated('already_have_account', context),
                                style: TextStyle(
                                        fontSize: Dimensions.FONT_SIZE_SMALL,
                                        color: ColorResources.getGreyColor(
                                            context)),
                              ),
                              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                              Text(
                                getTranslated('login', context),
                                style: TextStyle(
                                        fontSize: Dimensions.FONT_SIZE_SMALL,
                                        color:
                                            ColorResources.getGreyBunkerColor(
                                                context)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
