import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/theme/dark_theme.dart';
import 'package:wired_express/theme/light_theme.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/model/response/response_model.dart';
import 'package:wired_express/data/model/response/userinfo_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/base/custom_text_field.dart';
import 'package:wired_express/view/base/not_logged_in_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  FocusNode? _passwordFocus;
  FocusNode? _confirmPasswordFocus;
  TextEditingController? _firstNameController;
  TextEditingController? _lastNameController;
  TextEditingController? _emailController;
  TextEditingController? _phoneNumberController;
  TextEditingController? _passwordController;
  TextEditingController? _confirmPasswordController;

  File? file;
  PickedFile? data;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool? _isLoggedIn;

  @override
  void initState() {
    super.initState();

    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    _isLoggedIn =
        Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn();

    _passwordFocus = FocusNode();
    _confirmPasswordFocus = FocusNode();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    if (Provider.of<ProfileProvider>(context, listen: false).userInfoModel !=
        null) {
      UserInfoModel _userInfoModel =
          Provider.of<ProfileProvider>(context, listen: false).userInfoModel!;
      _firstNameController!.text = _userInfoModel.fName ?? '';
      _lastNameController!.text = _userInfoModel.lName ?? '';
      _phoneNumberController!.text = _userInfoModel.phone ?? '';
      _emailController!.text = _userInfoModel.email ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      key: _scaffoldKey,
      appBar: CustomAppBar(title: getTranslated('change_pass', context)),
      body: _isLoggedIn!
          ? Consumer<ProfileProvider>(
              builder: (context, profileProvider, child) {
                return profileProvider.userInfoModel != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Scrollbar(
                                child: SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                                  padding: EdgeInsets.all(
                                      Dimensions.PADDING_SIZE_SMALL),
                                  child: Center(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            getTranslated('password', context),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                ),
                                          ),
                                          SizedBox(
                                              height: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                          CustomTextField(
                                            hintText: getTranslated(
                                                'password_hint', context),
                                            isShowBorder: false,
                                            controller: _passwordController,
                                            focusNode: _passwordFocus,
                                            nextFocus: _confirmPasswordFocus,
                                            isPassword: true,
                                            isShowSuffixIcon: true,
                                          ),
                                          SizedBox(
                                              height: Dimensions
                                                  .PADDING_SIZE_LARGE),
                                          Text(
                                            getTranslated(
                                                'confirm_password', context),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                ),
                                          ),
                                          SizedBox(
                                              height: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                          CustomTextField(
                                            hintText: getTranslated(
                                                'password_hint', context),
                                            isShowBorder: false,
                                            controller:
                                                _confirmPasswordController,
                                            focusNode: _confirmPasswordFocus,
                                            isPassword: true,
                                            isShowSuffixIcon: true,
                                            inputAction: TextInputAction.done,
                                          ),
                                          SizedBox(
                                              height: Dimensions
                                                  .PADDING_SIZE_LARGE),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            !profileProvider.isLoading
                                ? Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.all(
                                          Dimensions.PADDING_SIZE_SMALL),
                                      child: CustomButton(
                                        text: getTranslated(
                                            'change_pass', context),
                                        onTap: () async {
                                          String _firstName =
                                              _firstNameController!.text.trim();
                                          String _lastName =
                                              _lastNameController!.text.trim();
                                          //  String _phoneNumber =
                                          //  _phoneNumberController.text.trim();
                                          String _password =
                                              _passwordController!.text.trim();
                                          String _confirmPassword =
                                              _confirmPasswordController!.text
                                                  .trim();
                                          if (profileProvider
                                                      .userInfoModel!.fName ==
                                                  _firstName &&
                                              profileProvider
                                                      .userInfoModel!.lName ==
                                                  _lastName &&
                                              // profileProvider.userInfoModel.phone ==
                                              //   _phoneNumber
                                              // &&
                                              profileProvider
                                                      .userInfoModel!.email ==
                                                  _emailController!.text &&
                                              file == null &&
                                              data == null &&
                                              _password.isEmpty &&
                                              _confirmPassword.isEmpty) {
                                            showCustomSnackBar(
                                                getTranslated(
                                                    'change_something_to_update',
                                                    context),
                                                context);
                                          } else if (_firstName.isEmpty) {
                                            showCustomSnackBar(
                                                getTranslated(
                                                    "password_empty", context),
                                                context);
                                          } else if (_lastName.isEmpty) {
                                            showCustomSnackBar(
                                                getTranslated(
                                                    'enter_last_name', context),
                                                context);
                                          } /*else if (_phoneNumber.isEmpty) {
                                            showCustomSnackBar(
                                                getTranslated(
                                                    'enter_phone_number',
                                                    context),
                                                context);
                                          }*/
                                          else if ((_password.isNotEmpty &&
                                                  _password.length < 6) ||
                                              (_confirmPassword.isNotEmpty &&
                                                  _confirmPassword.length <
                                                      6)) {
                                            showCustomSnackBar(
                                                getTranslated(
                                                    'password_should_be',
                                                    context),
                                                context);
                                          } else if (_password !=
                                              _confirmPassword) {
                                            showCustomSnackBar(
                                                getTranslated(
                                                    'password_did_not_match',
                                                    context),
                                                context);
                                          } else {
                                            UserInfoModel updateUserInfoModel =
                                                UserInfoModel();
                                            updateUserInfoModel.fName =
                                                _firstName ?? "";
                                            updateUserInfoModel.lName =
                                                _lastName ?? "";
                                            //  updateUserInfoModel.phone = _phoneNumber ?? '';
                                            String _pass = _password ?? '';

                                            ResponseModel _responseModel =
                                                await profileProvider
                                                    .updateUserInfo(
                                              updateUserInfoModel,
                                              _pass,
                                              Provider.of<CustomAuthProvider>(
                                                      context,
                                                      listen: false)
                                                  .getUserToken()!,
                                            );

                                            if (_responseModel.isSuccess) {
                                              profileProvider
                                                  .getUserInfo(context);
                                              showCustomSnackBar(
                                                  getTranslated(
                                                      'updated_successfully',
                                                      context),
                                                  context,
                                                  isError: false);
                                              Navigator.pop(context);
                                            } else {
                                              showCustomSnackBar(
                                                  _responseModel.message,
                                                  context);
                                            }
                                            setState(() {});
                                          }
                                        },
                                      ),
                                    ),
                                  )
                                : CustomCircularIndicator(color:ColorResources.getScaffoldColor(context)),
                          ],
                        ),
                      )
                    : CustomCircularIndicator(color:ColorResources.getScaffoldColor(context));
              },
            )
          : NotLoggedInScreen(),
    );
  }
}
