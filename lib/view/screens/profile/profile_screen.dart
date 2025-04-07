// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:wired_express/provider/splash_provider.dart';
// import 'package:wired_express/provider/theme_provider.dart';
// import 'package:wired_express/theme/dark_theme.dart';
// import 'package:wired_express/theme/light_theme.dart';
// import 'package:provider/provider.dart';
// import 'package:wired_express/data/model/response/response_model.dart';
// import 'package:wired_express/data/model/response/userinfo_model.dart';
// import 'package:wired_express/localization/language_constrants.dart';
// import 'package:wired_express/provider/auth_provider.dart';
// import 'package:wired_express/provider/profile_provider.dart';
// import 'package:wired_express/utill/Images.dart';
// import 'package:wired_express/utill/color_resources.dart';
// import 'package:wired_express/utill/dimensions.dart';
// import 'package:wired_express/utill/styles.dart';
// import 'package:wired_express/view/base/custom_app_bar.dart';
// import 'package:wired_express/view/base/custom_button.dart';
// import 'package:wired_express/view/base/custom_snackbar.dart';
// import 'package:wired_express/view/base/custom_text_field.dart';
// import 'package:wired_express/view/base/not_logged_in_screen.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
//
// class ProfileScreen extends StatefulWidget {
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   FocusNode? _firstNameFocus;
//   FocusNode? _lastNameFocus;
//   FocusNode? _emailFocus;
//   FocusNode? _phoneNumberFocus;
//   FocusNode? _passwordFocus;
//   FocusNode? _confirmPasswordFocus;
//   TextEditingController? _firstNameController;
//   TextEditingController? _lastNameController;
//   TextEditingController? _emailController;
//   TextEditingController? _phoneNumberController;
//   TextEditingController? _passwordController;
//   TextEditingController? _confirmPasswordController;
//
//   File? file;
//   PickedFile? data;
//   final picker = ImagePicker();
//   final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
//       GlobalKey<ScaffoldMessengerState>();
//   bool? _isLoggedIn;
//
//   @override
//   void initState() {
//     super.initState();
//
//     Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
//     _isLoggedIn =
//         Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn();
//
//     _firstNameFocus = FocusNode();
//     _lastNameFocus = FocusNode();
//     _emailFocus = FocusNode();
//     _phoneNumberFocus = FocusNode();
//     _passwordFocus = FocusNode();
//     _confirmPasswordFocus = FocusNode();
//     _firstNameController = TextEditingController();
//     _lastNameController = TextEditingController();
//     _emailController = TextEditingController();
//     _phoneNumberController = TextEditingController();
//     _passwordController = TextEditingController();
//     _confirmPasswordController = TextEditingController();
//
//     if (Provider.of<ProfileProvider>(context, listen: false).userInfoModel !=
//         null) {
//       UserInfoModel _userInfoModel =
//           Provider.of<ProfileProvider>(context, listen: false).userInfoModel!;
//       _firstNameController!.text = _userInfoModel.fName ?? '';
//       _lastNameController!.text = _userInfoModel.lName ?? '';
//       _phoneNumberController!.text = _userInfoModel.phone ?? '';
//       _emailController!.text = _userInfoModel.email ?? '';
//     }
//   }
//
//   void _choose() async {
//     final pickedFile = await picker.getImage(
//         source: ImageSource.gallery,
//         imageQuality: 50,
//         maxHeight: 500,
//         maxWidth: 500);
//     setState(() {
//       if (pickedFile != null) {
//         file = File(pickedFile.path);
//         Provider.of<ProfileProvider>(context, listen: false)
//             .setProfileImage(file!);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
//     return Scaffold(
//       backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
//       key: _scaffoldKey,
//       appBar: CustomAppBar(title: getTranslated('my_profile', context)),
//       body: _isLoggedIn!
//           ? Consumer<ProfileProvider>(
//               builder: (context, profileProvider, child) {
//                 return profileProvider.userInfoModel != null
//                     ? Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 5.0),
//                         child: Column(
//                           children: [
//                             Expanded(
//                               child: Scrollbar(
//                                 child: SingleChildScrollView(
//                                   physics: BouncingScrollPhysics(),
//                                   padding: EdgeInsets.all(
//                                       Dimensions.PADDING_SIZE_SMALL),
//                                   child: Center(
//                                     child: SizedBox(
//                                     width: MediaQuery.of(context).size.width,
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           SizedBox(height: 30),
//                                           // for profile image
//                                           // Container(
//                                           //   margin: EdgeInsets.symmetric(
//                                           //       vertical: Dimensions
//                                           //           .PADDING_SIZE_LARGE),
//                                           //   alignment: Alignment.center,
//                                           //   decoration: BoxDecoration(
//                                           //     color: ColorResources.BORDER_COLOR,
//                                           //     border: Border.all(
//                                           //         color: ColorResources
//                                           //             .COLOR_GREY_CHATEAU,
//                                           //         width: 3),
//                                           //     shape: BoxShape.circle,
//                                           //   ),
//                                           //   child: GestureDetector(
//                                           //     onTap:
//                                           //         ResponsiveHelper.isMobilePhone()
//                                           //             ? _choose
//                                           //             : _pickImage,
//                                           //     child: Stack(
//                                           //       clipBehavior: Clip.none,
//                                           //       children: [
//                                           //         ClipRRect(
//                                           //           borderRadius:
//                                           //               BorderRadius.circular(50),
//                                           //           child: file != null
//                                           //               ? Image.file(file,
//                                           //                   width: 80,
//                                           //                   height: 80,
//                                           //                   fit: BoxFit.fill)
//                                           //               : data != null
//                                           //                   ? Image.network(
//                                           //                       data.path,
//                                           //                       width: 80,
//                                           //                       height: 80,
//                                           //                       fit: BoxFit.fill)
//                                           //                   : FadeInImage.assetNetwork(
//                                           //                       placeholder: Images
//                                           //                           .placeholder_user,
//                                           //                       width: 80,
//                                           //                       height: 80,
//                                           //                       fit: BoxFit.cover,
//                                           //                       image:
//                                           //                           '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/${profileProvider.userInfoModel.image}',
//                                           //                     ),
//                                           //         ),
//                                           //         Positioned(
//                                           //           bottom: 15,
//                                           //           right: -10,
//                                           //           child: GestureDetector(
//                                           //               onTap: _choose,
//                                           //               child: Container(
//                                           //                 alignment:
//                                           //                     Alignment.center,
//                                           //                 padding:
//                                           //                     EdgeInsets.all(2),
//                                           //                 decoration:
//                                           //                     BoxDecoration(
//                                           //                   shape:
//                                           //                       BoxShape.circle,
//                                           //                   color: ColorResources
//                                           //                       .BORDER_COLOR,
//                                           //                   border: Border.all(
//                                           //                       width: 2,
//                                           //                       color: ColorResources
//                                           //                           .COLOR_GREY_CHATEAU),
//                                           //                 ),
//                                           //                 child: Icon(Icons.edit,
//                                           //                     size: 13),
//                                           //               )),
//                                           //         ),
//                                           //       ],
//                                           //     ),
//                                           //   ),
//                                           // ),
//                                           // for name
//                                           // Center(
//                                           //     child: Text(
//                                           //   '${profileProvider.userInfoModel!.fName} ${profileProvider.userInfoModel!.lName}',
//                                           //   style: rubikMedium.copyWith(
//                                           //       fontSize: Dimensions
//                                           //           .FONT_SIZE_EXTRA_LARGE),
//                                           // )),
//                                           Center(
//                                             child: Container(
//                                               height: 120,
//                                               width: 120,
//                                               margin: EdgeInsets.symmetric(
//                                                   vertical: Dimensions
//                                                       .PADDING_SIZE_LARGE),
//                                               alignment: Alignment.center,
//                                               decoration: BoxDecoration(
//                                                 color: Colors.grey,
//                                                 border: Border.all(
//                                                     color: ColorResources
//                                                         .COLOR_GREY_CHATEAU,
//                                                     width: 3),
//                                                 shape: BoxShape.circle,
//                                               ),
//                                               child: GestureDetector(
//                                                 onTap: _choose,
//                                                 child: Stack(
//                                                   clipBehavior: Clip.none,
//                                                   children: [
//                                                     ClipRRect(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               50),
//                                                       child: file != null
//                                                           ? Image.file(file!,
//                                                               height: 120,
//                                                               width: 120,
//                                                               fit: BoxFit.fill)
//                                                           : data != null
//                                                               ? Image.network(
//                                                                   data!.path,
//                                                                   height: 120,
//                                                                   width: 120,
//                                                                   fit: BoxFit
//                                                                       .fill)
//                                                               : profileProvider
//                                                                           .userInfoModel!
//                                                                           .image !=
//                                                                       null
//                                                                   ? FadeInImage
//                                                                       .assetNetwork(
//                                                                       placeholder:
//                                                                           Images
//                                                                               .person,
//                                                                       image:
//                                                                           '${Provider.of<SplashProvider>(
//                                                                         context,
//                                                                       ).baseUrls!.customerImageUrl}/${profileProvider.userInfoModel!.image}',
//                                                                       height:
//                                                                           120,
//                                                                       width:
//                                                                           120,
//                                                                       fit: BoxFit
//                                                                           .cover,
//                                                                     )
//                                                                   : Container(
//                                                                       height:
//                                                                           120,
//                                                                       width:
//                                                                           120,
//                                                                       decoration: BoxDecoration(
//                                                                           color: Colors.grey[
//                                                                               200],
//                                                                           borderRadius:
//                                                                               BorderRadius.circular(80)),
//                                                                       child: profileProvider.userInfoModel!.image ==
//                                                                               null
//                                                                           ? Padding(
//                                                                               padding: const EdgeInsets.all(15.0),
//                                                                               child: Image.asset(
//                                                                                 Images.person,
//                                                                                 color: Colors.grey[300],
//                                                                               ),
//                                                                             )
//                                                                           : Image.network(
//                                                                               '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.customerImageUrl}/${profileProvider.userInfoModel!.image}'),
//                                                                     ),
//                                                     ),
//                                                     Positioned(
//                                                       bottom: 15,
//                                                       right: -10,
//                                                       child: GestureDetector(
//                                                           onTap: _choose,
//                                                           child: Container(
//                                                             alignment: Alignment
//                                                                 .center,
//                                                             padding:
//                                                                 EdgeInsets.all(
//                                                                     2),
//                                                             decoration:
//                                                                 BoxDecoration(
//                                                               shape: BoxShape
//                                                                   .circle,
//                                                               color: ColorResources
//                                                                   .BORDER_COLOR,
//                                                               border: Border.all(
//                                                                   width: 2,
//                                                                   color: ColorResources
//                                                                       .COLOR_GREY_CHATEAU),
//                                                             ),
//                                                             child: Icon(
//                                                                 Icons.edit,
//                                                                 size: 13),
//                                                           )),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//
//                                           SizedBox(height: 28),
//                                           // Text(
//                                           //   getTranslated('phone', context),
//                                           //   style: Theme.of(context)
//                                           //       .textTheme
//                                           //       .titleMedium!
//                                           //       .copyWith(
//                                           //           fontSize: 18,
//                                           //           color: ColorResources
//                                           //               .getHintColor(context)),
//                                           // ),
//                                           // SizedBox(
//                                           //     height:
//                                           //         Dimensions.PADDING_SIZE_SMALL),
//                                           // Container(
//                                           //   height: 45,
//                                           //   decoration: BoxDecoration(
//                                           //       color: Provider.of<ThemeProvider>(
//                                           //                   context,
//                                           //                   listen: false)
//                                           //               .darkTheme
//                                           //           ? Colors.black26
//                                           //           : Colors.grey[100],
//                                           //       borderRadius:
//                                           //           BorderRadius.circular(10),
//                                           //       border: Border.all(
//                                           //           color: ColorResources
//                                           //               .getTextColor(context),
//                                           //           width: 0.1)),
//                                           //   child: Align(
//                                           //     alignment: Alignment.centerLeft,
//                                           //     child: Padding(
//                                           //       padding:
//                                           //           const EdgeInsets.symmetric(
//                                           //               horizontal: 20),
//                                           //       child: Text(
//                                           //         Provider.of<ProfileProvider>(
//                                           //                 context,
//                                           //                 listen: false)
//                                           //             .userInfoModel!
//                                           //             .phone
//                                           //             .toString(),
//                                           //         style: TextStyle(
//                                           //             color: ColorResources
//                                           //                 .getHintColor(context)),
//                                           //       ),
//                                           //     ),
//                                           //   ),
//                                           // ),
//                                           // CustomTextField(
//                                           //   dontEdit: true,
//                                           //   hintText:
//                                           //       Provider.of<ProfileProvider>(
//                                           //                   context,
//                                           //                   listen: false)
//                                           //               .userInfoModel!
//                                           //               .phone ??
//                                           //           "00",
//                                           //        isShowBorder: false,
//                                           // ),
//                                           SizedBox(
//                                               height: Dimensions
//                                                   .PADDING_SIZE_LARGE),
//                                           // for first name section
//                                           Text(
//                                             getTranslated(
//                                                 'first_name', context),
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .titleMedium!
//                                                 .copyWith(
//                                                   fontWeight: FontWeight.w400,
//                                                 ),
//                                           ),
//                                           SizedBox(
//                                               height: Dimensions
//                                                   .PADDING_SIZE_SMALL),
//                                           CustomTextField(
//                                             hintText: '',
//                                             isShowBorder: false,
//                                             controller: _firstNameController,
//                                             focusNode: _firstNameFocus,
//                                             nextFocus: _lastNameFocus,
//                                             inputType: TextInputType.name,
//                                             capitalization:
//                                                 TextCapitalization.words,
//                                           ),
//                                           SizedBox(
//                                               height: Dimensions
//                                                   .PADDING_SIZE_LARGE),
//
//                                           // for last name section
//                                           Text(
//                                             getTranslated('last_name', context),
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .titleMedium!
//                                                 .copyWith(
//                                                   fontWeight: FontWeight.w400,
//                                                 ),
//                                           ),
//                                           SizedBox(
//                                               height: Dimensions
//                                                   .PADDING_SIZE_SMALL),
//                                           CustomTextField(
//                                             hintText: '',
//                                             isShowBorder: false,
//                                             controller: _lastNameController,
//                                             focusNode: _lastNameFocus,
//                                             nextFocus: _phoneNumberFocus,
//                                             inputType: TextInputType.name,
//                                             capitalization:
//                                                 TextCapitalization.words,
//                                           ),
//                                           SizedBox(
//                                               height: Dimensions
//                                                   .PADDING_SIZE_LARGE),
//
//                                           // for email section
//                                           Text(
//                                             getTranslated('email', context),
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .titleMedium!
//                                                 .copyWith(
//                                                   fontWeight: FontWeight.w400,
//                                                 ),
//                                           ),
//                                           SizedBox(
//                                               height: Dimensions
//                                                   .PADDING_SIZE_SMALL),
//                                           CustomTextField(
//                                             hintText: getTranslated(
//                                                 'demo_gmail', context),
//                                             isShowBorder: false,
//                                             controller: _emailController,
//                                             focusNode: _emailFocus,
//                                             nextFocus: _phoneNumberFocus,
//                                             inputType:
//                                                 TextInputType.emailAddress,
//                                           ),
//                                           SizedBox(
//                                               height: Dimensions
//                                                   .PADDING_SIZE_LARGE),
//
//                                           // for phone Number section
//                                           /*   Text(
//                                                getTranslated(
//                                                    'mobile_number', context),
//                                                style: Theme.of(context)
//                                                    .textTheme
//                                                    .titleMedium
//                                                    .copyWith(
//                                                        color: ColorResources
//                                                            .getHintColor(context)),
//                                              ),
//                                              SizedBox(
//                                                  height:
//                                                      Dimensions.PADDING_SIZE_SMALL),
//                                              CustomTextField(
//                                                hintText: getTranslated(
//                                                    'number_hint', context),
//                                                     isShowBorder: false,
//                                                controller: _phoneNumberController,
//                                                focusNode: _phoneNumberFocus,
//                                                nextFocus: _passwordFocus,
//                                                inputType: TextInputType.phone,
//                                              ),
//                                              SizedBox(
//                                                  height:
//                                                      Dimensions.PADDING_SIZE_LARGE),
//
//                                            */
//
//                                           SizedBox(
//                                               height: Dimensions
//                                                   .PADDING_SIZE_LARGE),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             !profileProvider.isLoading
//                                 ? Center(
//                                     child: Container(
//                                      width: MediaQuery.of(context).size.width,
//                                       padding: EdgeInsets.all(
//                                           Dimensions.PADDING_SIZE_SMALL),
//                                       child: CustomButton(
//                                         text: getTranslated(
//                                             'update_profile', context),
//                                         onTap: () async {
//                                           String _firstName =
//                                               _firstNameController!.text.trim();
//                                           String _lastName =
//                                               _lastNameController!.text.trim();
//                                           //  String _phoneNumber =
//                                           //  _phoneNumberController.text.trim();
//                                           String _password =
//                                               _passwordController!.text.trim();
//                                           String _confirmPassword =
//                                               _confirmPasswordController!.text
//                                                   .trim();
//                                           if (profileProvider
//                                                       .userInfoModel!.fName ==
//                                                   _firstName &&
//                                               profileProvider
//                                                       .userInfoModel!.lName ==
//                                                   _lastName &&
//                                               // profileProvider.userInfoModel.phone ==
//                                               //   _phoneNumber
//                                               // &&
//                                               profileProvider
//                                                       .userInfoModel!.email ==
//                                                   _emailController!.text &&
//                                               file == null &&
//                                               data == null &&
//                                               _password.isEmpty &&
//                                               _confirmPassword.isEmpty) {
//                                             showCustomSnackBar(
//                                                 getTranslated(
//                                                     'change_something_to_update',
//                                                     context),
//                                                 context);
//                                           } else if (_firstName.isEmpty) {
//                                             showCustomSnackBar(
//                                                 getTranslated(
//                                                     "password_empty", context),
//                                                 context);
//                                           } else if (_lastName.isEmpty) {
//                                             showCustomSnackBar(
//                                                 getTranslated(
//                                                     'enter_last_name', context),
//                                                 context);
//                                           } /*else if (_phoneNumber.isEmpty) {
//                                             showCustomSnackBar(
//                                                 getTranslated(
//                                                     'enter_phone_number',
//                                                     context),
//                                                 context);
//                                           }*/
//                                           else if ((_password.isNotEmpty &&
//                                                   _password.length < 6) ||
//                                               (_confirmPassword.isNotEmpty &&
//                                                   _confirmPassword.length <
//                                                       6)) {
//                                             showCustomSnackBar(
//                                                 getTranslated(
//                                                     'password_should_be',
//                                                     context),
//                                                 context);
//                                           } else if (_password !=
//                                               _confirmPassword) {
//                                             showCustomSnackBar(
//                                                 getTranslated(
//                                                     'password_did_not_match',
//                                                     context),
//                                                 context);
//                                           } else {
//                                             UserInfoModel updateUserInfoModel =
//                                                 UserInfoModel();
//
//                                             updateUserInfoModel.fName =
//                                                 _firstName ?? "";
//                                             updateUserInfoModel.lName =
//                                                 _lastName ?? "";
//                                             //  updateUserInfoModel.phone = _phoneNumber ?? '';
//                                             String _pass = _password ?? '';
//
//                                             ResponseModel _responseModel =
//                                                 await profileProvider
//                                                     .updateUserInfo(
//                                               updateUserInfoModel,
//                                               _pass,
//                                               Provider.of<CustomAuthProvider>(
//                                                       context,
//                                                       listen: false)
//                                                   .getUserToken()!,
//                                             );
//
//                                             if (_responseModel.isSuccess) {
//                                               profileProvider
//                                                   .getUserInfo(context);
//                                               showCustomSnackBar(
//                                                   getTranslated(
//                                                       'updated_successfully',
//                                                       context),
//                                                   context,
//                                                   isError: false);
//                                             } else {
//                                               showCustomSnackBar(
//                                                   _responseModel.message,
//                                                   context);
//                                             }
//                                             setState(() {});
//                                           }
//                                         },
//                                       ),
//                                     ),
//                                   )
//                                 : CustomCircularIndicator(color:ColorResources.getScaffoldColor(context)),
//                           ],
//                         ),
//                       )
//                     : CustomCircularIndicator(color:ColorResources.getScaffoldColor(context));
//               },
//             )
//           : NotLoggedInScreen(),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
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
    final pickedFile = await picker.getImage(
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
        print('Ninguna imagen seleccionada.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      key: _scaffoldKey,
      appBar: CustomAppBar(title: getTranslated('my_profile', context)),
      body: _isLoggedIn!
          ? Consumer<ProfileProvider>(
              builder: (context, profileProvider, child) {
                return profileProvider.userInfoModel != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Column(
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
                                        children: [
                                          SizedBox(height: 30),
                                          Container(
                                            height: 80,
                                            margin: EdgeInsets.symmetric(
                                                vertical: Dimensions
                                                    .PADDING_SIZE_LARGE),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: ColorResources.COLOR_WHITE,
                                              border: Border.all(
                                                  color: ColorResources
                                                      .COLOR_GREY_CHATEAU,
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
                                                        BorderRadius.circular(
                                                            50),
                                                    child: file != null
                                                        ? Image.file(file!,
                                                            width: 80,
                                                            height: 80,
                                                            fit: BoxFit.fill)
                                                        : data != null
                                                            ? Image.network(
                                                                data!.path,
                                                                width: 80,
                                                                height: 80,
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
                                                                    height: 80,
                                                                    width: 80,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )
                                                                : Container(
                                                                    height: 80,
                                                                    width: 80,
                                                                    child: Icon(
                                                                        Icons
                                                                            .person,
                                                                        size:
                                                                            30,
                                                                        color: Colors
                                                                            .black54)),
                                                  ),
                                                  Positioned(
                                                    bottom: 15,
                                                    right: -10,
                                                    child: GestureDetector(
                                                        onTap: _choose,
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          padding:
                                                              EdgeInsets.all(2),
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: ColorResources
                                                                .BORDER_COLOR,
                                                            border: Border.all(
                                                                width: 2,
                                                                color: ColorResources
                                                                    .COLOR_GREY_CHATEAU),
                                                          ),
                                                          child: Icon(
                                                              Icons.edit,
                                                              size: 13),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          SizedBox(height: 28),

                                          SizedBox(
                                              height: Dimensions
                                                  .PADDING_SIZE_LARGE),
                                          // for first name section
                                          Text(
                                            getTranslated(
                                                'first_name', context),
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
                                            hintText: '',
                                            isShowBorder: false,
                                            controller: _firstNameController,
                                            focusNode: _firstNameFocus,
                                            nextFocus: _lastNameFocus,
                                            inputType: TextInputType.name,
                                            capitalization:
                                                TextCapitalization.words,
                                          ),
                                          SizedBox(
                                              height: Dimensions
                                                  .PADDING_SIZE_LARGE),

                                          // for last name section
                                          Text(
                                            getTranslated('last_name', context),
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
                                            hintText: '',
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

                                          // for email section
                                          // Text(
                                          //   getTranslated('email', context),
                                          //   style: Theme.of(context)
                                          //       .textTheme
                                          //       .titleMedium!
                                          //       .copyWith(
                                          //         fontWeight: FontWeight.w400,
                                          //       ),
                                          // ),
                                          // SizedBox(
                                          //     height: Dimensions
                                          //         .PADDING_SIZE_SMALL),
                                          // CustomTextField(
                                          //   hintText: getTranslated(
                                          //       'demo_gmail', context),
                                          //   isShowBorder: false,
                                          //   controller: _emailController,
                                          //   focusNode: _emailFocus,
                                          //   nextFocus: _phoneNumberFocus,
                                          //   inputType:
                                          //       TextInputType.emailAddress,
                                          // ),
                                          SizedBox(
                                              height: Dimensions
                                                  .PADDING_SIZE_LARGE),

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
                                      padding: EdgeInsets.all(
                                          Dimensions.PADDING_SIZE_SMALL),
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
                                                  getTranslated('profile_updated', context), context,
                                                  isError: false);
                                              Navigator.pop(context);
                                            } else {
                                              showCustomSnackBar(
                                                  getTranslated('something_went_wrong', context),
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
