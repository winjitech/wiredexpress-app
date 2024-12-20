// import 'package:country_code_picker/country_code_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:lacrostini_app/view/screens/address/add_new_address_screen.dart';
// import 'package:lacrostini_app/view/screens/auth/verify_phone_code_screen.dart';
// import 'package:lacrostini_app/helper/responsive_helper.dart';
// import 'package:lacrostini_app/localization/language_constrants.dart';
// import 'package:lacrostini_app/provider/auth_provider.dart';
// import 'package:lacrostini_app/provider/splash_provider.dart';
// import 'package:lacrostini_app/utill/color_resources.dart';
// import 'package:lacrostini_app/utill/dimensions.dart';
// import 'package:lacrostini_app/utill/images.dart';
// import 'package:lacrostini_app/view/base/custom_button.dart';
// import 'package:lacrostini_app/view/base/custom_snackbar.dart';
// import 'package:lacrostini_app/view/base/custom_text_field.dart';
// import 'package:lacrostini_app/view/base/main_app_bar.dart';
// import 'package:provider/provider.dart';
//
// class SignUpWithPhoneScreen extends StatefulWidget {
//   final String? phoneNumber;
//
//   const SignUpWithPhoneScreen({super.key, required this.phoneNumber});
//
//   @override
//   _SignUpWithPhoneScreenState createState() => _SignUpWithPhoneScreenState();
// }
//
// class _SignUpWithPhoneScreenState extends State<SignUpWithPhoneScreen> {
//   String countryCode = "";
//   FocusNode _phoneNumberFocus = FocusNode();
//   TextEditingController? _phoneController;
//   FocusNode _fNameFocus = FocusNode();
//   TextEditingController? _fNameController;
//   FocusNode _lNameFocus = FocusNode();
//   TextEditingController? _lNameController;
//   GlobalKey<FormState>? _formKeyLogin;
//
//   @override
//   void initState() {
//     super.initState();
//     _formKeyLogin = GlobalKey<FormState>();
//     _phoneController = TextEditingController();
//     _fNameController = TextEditingController();
//     _lNameController = TextEditingController();
//   }
//
//   @override
//   void dispose() {
//     _phoneController!.dispose();
//     _fNameController!.dispose();
//     _lNameController!.dispose();
//
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<CustomAuthProvider>(context);
//
//     return Scaffold(
//       appBar: ResponsiveHelper.isDesktop(context)
//           ? PreferredSize(
//               child: MainAppBar(), preferredSize: Size.fromHeight(80))
//           : null,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Scrollbar(
//             child: SizedBox(
//                width: MediaQuery.of(context).size.width,
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Consumer<CustomAuthProvider>(
//                   builder: (context, authProvider, child) => Form(
//                     key: _formKeyLogin,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Center(
//                           child: Padding(
//                             padding: const EdgeInsets.all(15.0),
//                             child: ResponsiveHelper.isWeb()
//                                 ? Consumer<SplashProvider>(
//                                     builder: (context, splash, child) =>
//                                         FadeInImage.assetNetwork(
//                                       placeholder: Images.placeholder_rectangle,
//                                       image: splash.baseUrls != null
//                                           ? '${splash.baseUrls!.storeImageUrl}/${splash.configModel!.storeLogo}'
//                                           : '',
//                                       height:
//                                           MediaQuery.of(context).size.height /
//                                               4.5,
//                                     ),
//                                   )
//                                 : Image.asset(
//                                     Images.welcome_logo,
//                                     height: MediaQuery.of(context).size.height /
//                                         4.5,
//                                     fit: BoxFit.scaleDown,
//                                   ),
//                           ),
//                         ),
//                         Center(
//                             child: Text(
//                           getTranslated('signup', context),
//                           style: Theme.of(context)
//                               .textTheme
//                               .headline3!
//                               .copyWith(
//                                   fontSize: 24,
//                                   color: ColorResources.getGreyBunkerColor(
//                                       context)),
//                         )),
//                         SizedBox(height: 35),
//                         // Text(
//                         //   getTranslated('phone', context),
//                         //   style: Theme.of(context)
//                         //       .textTheme
//                         //       .headline2!
//                         //       .copyWith(
//                         //           color: ColorResources.getHintColor(context)),
//                         // ),
//                         // SizedBox(height: 10),
//                         // Container(
//                         //   decoration: BoxDecoration(
//                         //       borderRadius: BorderRadius.circular(10),
//                         //       border: Border.all(
//                         //           color: Colors.black54, width: 0.1)),
//                         //   child: Row(
//                         //     children: [
//                         //       CountryCodePicker(
//                         //         searchDecoration: InputDecoration(
//                         //           contentPadding:
//                         //               EdgeInsets.symmetric(vertical: 10),
//                         //           hintText: 'write country',
//                         //           border: OutlineInputBorder(
//                         //             borderRadius: BorderRadius.circular(15),
//                         //           ),
//                         //           enabledBorder: OutlineInputBorder(
//                         //             borderRadius: BorderRadius.circular(15),
//                         //           ),
//                         //         ),
//                         //         onChanged: (val) =>
//                         //             countryCode = val.toString(),
//                         //         onInit: (val) => countryCode = val.toString(),
//                         //         initialSelection: countryCode,
//                         //         textStyle: TextStyle(
//                         //           color: Theme.of(context).hintColor,
//                         //         ),
//                         //         flagDecoration: BoxDecoration(
//                         //           borderRadius: BorderRadius.circular(5),
//                         //         ),
//                         //       ),
//                         //       SizedBox(width: 10),
//                         //       Expanded(
//                         //         child: CustomTextField(
//                         //           hintText: getTranslated(
//                         //               'enter_phone_number', context),
//                         //           isShowBorder: false,
//                         //           isCountryPicker: true,
//                         //           focusNode: _phoneNumberFocus,
//                         //           controller: _phoneController,
//                         //           inputType: TextInputType.phone,
//                         //           nextFocus: _fNameFocus,
//                         //         ),
//                         //       ),
//                         //     ],
//                         //   ),
//                         // ),
//                         // SizedBox(height: 20),
//                         Text(
//                           getTranslated('first_name', context),
//                           style: Theme.of(context)
//                               .textTheme
//                               .headline2!
//                               .copyWith(
//                                   color: ColorResources.getHintColor(context)),
//                         ),
//                         SizedBox(height: 10),
//                         CustomTextField(
//                           hintText: getTranslated('first_name', context),
//                           isShowBorder: true,
//                           focusNode: _fNameFocus,
//                           nextFocus: _lNameFocus,
//                           controller: _fNameController,
//                           inputType: TextInputType.name,
//                         ),
//                         SizedBox(height: 20),
//                         Text(
//                           getTranslated('last_name', context),
//                           style: Theme.of(context)
//                               .textTheme
//                               .headline2!
//                               .copyWith(
//                                   color: ColorResources.getHintColor(context)),
//                         ),
//                         SizedBox(height: 10),
//                         CustomTextField(
//                           hintText: getTranslated('last_name', context),
//                           isShowBorder: true,
//                           focusNode: _lNameFocus,
//                           //     nextFocus: _lNameFocus,
//                           controller: _lNameController,
//                           inputType: TextInputType.name,
//                         ),
//                         SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
//                         authProvider.isLoading == true
//                             ? Center(
//                                 child: CircularProgressIndicator(
//                                 valueColor: new AlwaysStoppedAnimation<Color>(
//                                     Theme.of(context).primaryColor),
//                               ))
//                             : _lNameController!.text.isEmpty ||
//                                     _fNameController!.text.isEmpty
//                                 ? CustomButton(
//                                     text: getTranslated('next', context),
//                                     backgroundColor: Colors.black12,
//                                   )
//                                 : CustomButton(
//                                     text: getTranslated('next', context),
//                                     onTap: () async {
//                                       authProvider.signByPhone(
//                                           _fNameController!.text,
//                                           _lNameController!.text,
//                                           widget.phoneNumber!);
//                                       //     .then((value) {
//                                       //   Navigator.push(
//                                       //       context,
//                                       //       MaterialPageRoute(
//                                       //           builder: (BuildContext? context) =>
//                                       //               AddNewAddressScreen()));
//                                       // });
//                                     },
//                                   )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
