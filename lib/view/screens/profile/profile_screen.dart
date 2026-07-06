import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:wired_express/data/model/response/signup_model.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/model/response/userinfo_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/utill/Images.dart';
import 'package:wired_express/utill/app_constants.dart';
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

import 'package:wired_express/data/model/response/response_model.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FocusNode? _firstNameFocus;
  FocusNode? _lastNameFocus;
  // FocusNode? _emailFocus;
  FocusNode? _phoneNumberFocus;
  FocusNode? _passwordFocus;
  FocusNode? _confirmPasswordFocus;
  TextEditingController? _firstNameController;
  TextEditingController? _lastNameController;
  // TextEditingController? _emailController;
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

    _firstNameFocus = FocusNode();
    _lastNameFocus = FocusNode();
    // _emailFocus = FocusNode();
    _phoneNumberFocus = FocusNode();
    _passwordFocus = FocusNode();
    _confirmPasswordFocus = FocusNode();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    // _emailController = TextEditingController();
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
      // _emailController!.text = _userInfoModel.email ?? '';
    }
  }

  void _choose() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
        Provider.of<ProfileProvider>(context, listen: false)
            .setProfileImage(file!);
      } else {
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      key: _scaffoldKey,
      body: Column(
        children: [
          CustomAppBar(title: 'my_profile', showBackButton: true),
          Expanded(
            child: _isLoggedIn!
                ? Consumer<ProfileProvider>(
                    builder: (context, profileProvider, child) {
                      return profileProvider.userInfoModel != null
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Scrollbar(
                                      child: SingleChildScrollView(
                                        physics: BouncingScrollPhysics(),
                                        padding: EdgeInsets.all(10.r),
                                        child: Center(
                                          child: SizedBox(
                                            width: MediaQuery.of(context).size.width,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 30.h),
                                                Container(
                                                  height: 80.h,
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: Dimensions
                                                          .PADDING_SIZE_LARGE),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: ColorResources
                                                        .getTextFieldFillColor(
                                                            context),
                                                    border: Border.all(
                                                        color: ColorResources
                                                                .getTextColor(context)
                                                            .withOpacity(0.2),
                                                        width: 3),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: _choose,
                                                    child: Stack(
                                                      clipBehavior: Clip.none,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(50.r),
                                                          child: file != null
                                                              ? Image.file(file!,
                                                                  width: 80.w,
                                                                  height: 80.h,
                                                                  fit: BoxFit.fill)
                                                              : data != null
                                                                  ? Image.network(
                                                                      data!.path,
                                                                      width: 80.w,
                                                                      height: 80.h,
                                                                      fit:
                                                                          BoxFit.fill)
                                                                  : profileProvider
                                                                              .userInfoModel!
                                                                              .image !=
                                                                          null
                                                                      ? FadeInImage
                                                                          .assetNetwork(
                                                                          placeholder:
                                                                              Images
                                                                                  .person,
                                                                          image:
                                                                              '${Provider.of<SplashProvider>(
                                                                            context,
                                                                          ).baseUrls!.customerImageUrl}/${profileProvider.userInfoModel!.image}',
                                                                          height: 80.h,
                                                                          width: 80.w,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        )
                                                                      : Container(
                                                                          height: 80.h,
                                                                          width: 80.w,
                                                                          child: Icon(
                                                                              Icons
                                                                                  .person,
                                                                              size:
                                                                                  30,
                                                                              color: ColorResources.getTextColor(context)
                                                                                  .withOpacity(0.4))),
                                                        ),
                                                        Positioned(
                                                          bottom: 15.h,
                                                          right: -10,
                                                          child: GestureDetector(
                                                              onTap: _choose,
                                                              child: Container(
                                                                alignment:
                                                                    Alignment.center,
                                                                padding:
                                                                    EdgeInsets.all(
                                                                        2.r),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape:
                                                                      BoxShape.circle,
                                                                  color: ColorResources
                                                                      .getTextFieldFillColor(
                                                                          context),
                                                                  border: Border.all(
                                                                    width: 2,
                                                                    color: ColorResources
                                                                            .getTextColor(
                                                                                context)
                                                                        .withOpacity(
                                                                            0.4),
                                                                  ),
                                                                ),
                                                                child: Icon(
                                                                    color: ColorResources
                                                                            .getTextColor(
                                                                                context)
                                                                        .withOpacity(
                                                                            0.7),
                                                                    Icons.edit,
                                                                    size: 13.sp),
                                                              )),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                                SizedBox(height: 35.h),

                                                Text(
                                                  getTranslated(
                                                      'first_name', context),
                                                  style: AppTextStyles.h4(context),
                                                ),
                                                SizedBox(
                                                    height: Dimensions
                                                        .PADDING_SIZE_SMALL),
                                                CustomTextField(
                                                  hintText: '',
                                                  isShowBorder: false,
                                                  controller: _firstNameController,
                                                  focusNode: _firstNameFocus,
                                                  nextFocus: _lastNameFocus,
                                                  inputType: TextInputType.name,fill: true,
                                                  fillColor: ColorResources
                                                      .getTextFieldFillColor(context),
                                                  capitalization:
                                                      TextCapitalization.words,
                                                ),
                                                SizedBox(
                                                    height: Dimensions
                                                        .PADDING_SIZE_LARGE),

                                                // for last name section
                                                Text(
                                                  getTranslated('last_name', context),
                                                  style: AppTextStyles.h4(context),
                                                ),
                                                SizedBox(
                                                    height: Dimensions
                                                        .PADDING_SIZE_SMALL),
                                                CustomTextField(fill: true,
                                                  hintText: '',
                                                  fillColor: ColorResources
                                                      .getTextFieldFillColor(context),
                                                  isShowBorder: false,
                                                  controller: _lastNameController,
                                                  focusNode: _lastNameFocus,
                                                  nextFocus: _phoneNumberFocus,
                                                  inputType: TextInputType.name,
                                                  capitalization:
                                                      TextCapitalization.words,
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
                                  profileProvider.isLoading == false
                                      ? Center(
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            padding: EdgeInsets.all(10.r),
                                            child: CustomButton(
                                              text: getTranslated(
                                                  'update_profile', context),
                                              onTap: () async {
                                                FocusScope.of(context).unfocus();
                                                String _lastName =
                                                    _lastNameController!.text.trim();
                                                String _firstName =
                                                    _firstNameController!.text.trim();
                                                String _phone =
                                                    '${_phoneNumberController!.text.trim()}';
                                                String _password =
                                                    _passwordController!.text.trim();
                                                String _confirmPassword =
                                                    _confirmPasswordController!.text
                                                        .trim();

                                                SignUpModel signUpModel = SignUpModel(
                                                  fName: _firstName,
                                                  lName: _lastName,

                                                  // email: _email,
                                                  password: _password,
                                                  phone: _phone,
                                                );

                                                profileProvider
                                                    .updatePersonalInfo(
                                                        Provider.of<CustomAuthProvider>(
                                                                context,
                                                                listen: false)
                                                            .getUserToken()!,
                                                        signUpModel)
                                                    .then((value) {
                                                  if (value.statusCode == 200) {
                                                    profileProvider
                                                        .getUserInfo(context);
                                                    showCustomSnackBar(
                                                        getTranslated(
                                                            'profile_updated',
                                                            context),
                                                        context,
                                                        isError: false);
                                                    Navigator.pop(context);
                                                  } else {
                                                    showCustomSnackBar(
                                                        getTranslated(
                                                            'something_went_wrong',
                                                            context),
                                                        context,
                                                        isError: true);
                                                  }
                                                });
                                              },
                                              // onTap: () async {
                                              //   String _firstName =
                                              //       _firstNameController!.text.trim();
                                              //   String _lastName =
                                              //       _lastNameController!.text.trim();
                                              //   //  String _phoneNumber =
                                              //   //  _phoneNumberController.text.trim();
                                              //   String _password =
                                              //       _passwordController!.text.trim();
                                              //   String _confirmPassword =
                                              //       _confirmPasswordController!.text
                                              //           .trim();
                                              //   if (profileProvider
                                              //               .userInfoModel!.fName ==
                                              //           _firstName &&
                                              //       profileProvider
                                              //               .userInfoModel!.lName ==
                                              //           _lastName &&
                                              //       // profileProvider.userInfoModel.phone ==
                                              //       //   _phoneNumber
                                              //       // &&
                                              //       profileProvider
                                              //               .userInfoModel!.email ==
                                              //           _emailController!.text &&
                                              //       file == null &&
                                              //       data == null &&
                                              //       _password.isEmpty &&
                                              //       _confirmPassword.isEmpty) {
                                              //     showCustomSnackBar(
                                              //         getTranslated(
                                              //             'change_something_to_update',
                                              //             context),
                                              //         context);
                                              //   } else if (_firstName.isEmpty) {
                                              //     showCustomSnackBar(
                                              //         getTranslated(
                                              //             "password_empty", context),
                                              //         context);
                                              //   } else if (_lastName.isEmpty) {
                                              //     showCustomSnackBar(
                                              //         getTranslated(
                                              //             'enter_last_name', context),
                                              //         context);
                                              //   } /*else if (_phoneNumber.isEmpty) {
                                              //     showCustomSnackBar(
                                              //         getTranslated(
                                              //             'enter_phone_number',
                                              //             context),
                                              //         context);
                                              //   }*/
                                              //   else if ((_password.isNotEmpty &&
                                              //           _password.length < 6) ||
                                              //       (_confirmPassword.isNotEmpty &&
                                              //           _confirmPassword.length <
                                              //               6)) {
                                              //     showCustomSnackBar(
                                              //         getTranslated(
                                              //             'password_should_be',
                                              //             context),
                                              //         context);
                                              //   } else if (_password !=
                                              //       _confirmPassword) {
                                              //     showCustomSnackBar(
                                              //         getTranslated(
                                              //             'password_did_not_match',
                                              //             context),
                                              //         context);
                                              //   } else {
                                              //     UserInfoModel updateUserInfoModel =
                                              //         UserInfoModel();
                                              //
                                              //     updateUserInfoModel.fName =
                                              //         _firstName ?? "";
                                              //     updateUserInfoModel.lName =
                                              //         _lastName ?? "";
                                              //     //  updateUserInfoModel.phone = _phoneNumber ?? '';
                                              //     String _pass = _password ?? '';
                                              //
                                              //     ResponseModel _responseModel =
                                              //         await profileProvider
                                              //             .updateUserInfo(
                                              //       updateUserInfoModel,
                                              //       _pass,
                                              //       Provider.of<CustomAuthProvider>(
                                              //               context,
                                              //               listen: false)
                                              //           .getUserToken()!,
                                              //     );
                                              //
                                              //     if (_responseModel.isSuccess) {
                                              //       profileProvider
                                              //           .getUserInfo(context);
                                              //       showCustomSnackBar(
                                              //           getTranslated(
                                              //               'updated_successfully',
                                              //               context),
                                              //           context,
                                              //           isError: false);
                                              //     } else {
                                              //       showCustomSnackBar(
                                              //           _responseModel.message,
                                              //           context);
                                              //     }
                                              //     setState(() {});
                                              //   }
                                              // },
                                            ),
                                          ),
                                        )
                                      : CustomCircularIndicator(),
                                ],
                              ),
                            )
                          : CustomCircularIndicator();
                    },
                  )
                : NotLoggedInScreen(),
          ),
        ],
      ),
    );
  }
}
