// import 'package:flutter/material.dart';
// import 'package:lacrostini_app/data/model/response/response_model.dart';
// import 'package:lacrostini_app/localization/language_constrants.dart';
// import 'package:lacrostini_app/provider/auth_provider.dart';
// import 'package:lacrostini_app/provider/profile_provider.dart';
// import 'package:lacrostini_app/utill/color_resources.dart';
// import 'package:lacrostini_app/utill/dimensions.dart';
// import 'package:lacrostini_app/utill/routes.dart';
// import 'package:lacrostini_app/view/base/custom_app_bar.dart';
// import 'package:lacrostini_app/view/base/custom_button.dart';
// import 'package:lacrostini_app/view/base/custom_snackbar.dart';
// import 'package:lacrostini_app/view/base/custom_text_field.dart';
// import 'package:lacrostini_app/view/base/not_logged_in_screen.dart';
// import 'package:numberpicker/numberpicker.dart';
// import 'package:provider/provider.dart';
//
// class UserNameScreen extends StatefulWidget {
//   @override
//   _UserNameScreenState createState() => _UserNameScreenState();
// }
//
// class _UserNameScreenState extends State<UserNameScreen> {
//   FocusNode _firstNameFocus;
//   FocusNode _lastNameFocus;
//   FocusNode _ageFocus;
//   int _currentValue = 20;
//
//   TextEditingController _firstNameController;
//   TextEditingController _lastNameController;
//   TextEditingController _ageController;
//
//   final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
//   GlobalKey<ScaffoldMessengerState>();
//   bool _isLoggedIn;
//
//
//   @override
//   void initState() {
//     super.initState();
//
//     Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
//     _isLoggedIn =
//         Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
//
//     _firstNameFocus = FocusNode();
//     _lastNameFocus = FocusNode();
//     _ageFocus = FocusNode();
//
//     _firstNameController = TextEditingController();
//     _lastNameController = TextEditingController();
//     _ageController = TextEditingController();
//
//
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: CustomAppBar(title: getTranslated('my_profile', context)),
//       body: _isLoggedIn
//           ? Consumer<ProfileProvider>(
//         builder: (context, profileProvider, child) {
//           return profileProvider.userInfoModel != null
//               ? Column(
//             children: [
//               Expanded(
//                 child: Scrollbar(
//                   child: SingleChildScrollView(
//                     physics: BouncingScrollPhysics(),
//                     padding: EdgeInsets.all(
//                         Dimensions.PADDING_SIZE_SMALL),
//                     child: Center(
//                       child: SizedBox(
//                       width: MediaQuery.of(context).size.width,
//                         child: Column(
//                           crossAxisAlignment:
//                           CrossAxisAlignment.start,
//                           children: [
//
//                             SizedBox(height: 28),
//                             // for first name section
//                             Text(
//                               getTranslated('first_name', context),
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .headline2
//                                   .copyWith(
//                                   color: ColorResources
//                                       .getHintColor(context)),
//                             ),
//                             SizedBox(
//                                 height:
//                                 Dimensions.PADDING_SIZE_SMALL),
//                             CustomTextField(
//                               hintText: '',
//                               isShowBorder: true,
//                               controller: _firstNameController,
//                               focusNode: _firstNameFocus,
//                               nextFocus: _lastNameFocus,
//                               inputType: TextInputType.name,
//                               capitalization:
//                               TextCapitalization.words,
//                             ),
//                             SizedBox(
//                                 height:
//                                 Dimensions.PADDING_SIZE_LARGE),
//
//                             // for last name section
//                             Text(
//                               getTranslated('last_name', context),
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .headline2
//                                   .copyWith(
//                                   color: ColorResources
//                                       .getHintColor(context)),
//                             ),
//                             SizedBox(
//                                 height:
//                                 Dimensions.PADDING_SIZE_SMALL),
//                             CustomTextField(
//                               //dontEdit: true,
//                               hintText: '',
//                               isShowBorder: true,
//                               controller: _lastNameController,
//                               focusNode: _lastNameFocus,
//                               nextFocus: _ageFocus,
//                               inputType: TextInputType.name,
//                               capitalization:
//                               TextCapitalization.words,
//                             ),
//                             SizedBox(
//                                 height:
//                                 Dimensions.PADDING_SIZE_LARGE),
//
//                             // for email section
//                             Text(
//                               '${getTranslated('age', context)}: $_currentValue',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .headline2
//                                   .copyWith(
//                                   color: ColorResources
//                                       .getHintColor(context)),
//                             ),
//                             SizedBox(
//                                 height:
//                                 Dimensions.PADDING_SIZE_SMALL),
//
//                             NumberPicker(
//                               value: _currentValue,
//                               minValue: 0,
//                               maxValue: 100,
//                               selectedTextStyle: TextStyle(color: Colors.teal, fontSize: 19,),
//                               onChanged: (value) => setState(() => _currentValue = value),
//                             ),
//                             SizedBox(
//                                 height:
//                                 Dimensions.PADDING_SIZE_LARGE),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               !profileProvider.isLoading
//                   ? Center(
//                 child: Container(
//                   width: MediaQuery.of(context).size.width,
//                   padding: EdgeInsets.all(
//                       Dimensions.PADDING_SIZE_SMALL),
//                   child: CustomButton(
//                     text: getTranslated(
//                         'update_profile', context),
//                     onTap: () async {
//                       String _firstName =
//                       _firstNameController.text.trim();
//                       String _lastName =
//                       _lastNameController.text.trim();
//
//                        if (_firstName.isEmpty) {
//                          showCustomSnackBar(
//                              getTranslated(
//                                  'enter_first_name', context),
//                              context);
//                       } else if (_lastName.isEmpty) {
//                         showCustomSnackBar(
//                             getTranslated(
//                                 'enter_last_name', context),
//                             context);
//                       }
//                       else {
//                         ResponseModel _responseModel =
//                         await profileProvider
//                             .updateNameAge(
//                           _firstName,
//                           _lastName,
//                           _currentValue.toString(),
//                           Provider.of<AuthProvider>(context,
//                               listen: false)
//                               .getUserToken(),
//                         );
//
//                         if (_responseModel.isSuccess) {
//                           profileProvider
//                               .getUserInfo(context);
//                           showCustomSnackBar(
//                               getTranslated(
//                                   'updated_successfully',
//                                   context),
//                               context,
//                               isError: false);
//                           Navigator.pushNamedAndRemoveUntil(
//                               context, Routes.getMainRoute(), (route) => false);
//                         } else {
//                           showCustomSnackBar(
//                               _responseModel.message,
//                               context);
//                         }
//                         setState(() {});
//                       }
//                     },
//                   ),
//                 ),
//               )
//                   : CustomCircularIndicator(),
//             ],
//           )
//               : CustomCircularIndicator();
//         },
//       )
//           : NotLoggedInScreen(),
//     );
//   }
// }
