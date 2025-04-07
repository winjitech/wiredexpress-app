// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:lacrostini_app/data/model/response/userinfo_model.dart';
// import 'package:lacrostini_app/helper/responsive_helper.dart';
// import 'package:lacrostini_app/localization/language_constrants.dart';
// import 'package:lacrostini_app/provider/auth_provider.dart';
// import 'package:lacrostini_app/provider/profile_provider.dart';
// import 'package:lacrostini_app/provider/wishlist_provider.dart';
// import 'package:lacrostini_app/utill/color_resources.dart';
// import 'package:lacrostini_app/utill/routes.dart';
// import 'package:lacrostini_app/view/base/custom_app_bar.dart';
// import 'package:lacrostini_app/view/base/custom_button.dart';
// import 'package:lacrostini_app/view/base/custom_snackbar.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:provider/provider.dart';
//
//
// class VerificationPhoneScreen extends StatelessWidget {
//   BuildContext? contextBuilder;
//   final String emailAddress = "";
//   final bool fromSignUp = false;
//
//   String loginErrorMessage = "";
//   final String? phoneString;
//   final String? phonePrefixString;
//   String? firebaseToken;
//   String? firebaseVerificationId;
//   String? smsCode;
//   VerificationPhoneScreen(param,
//       {@required this.phoneString,
//       @required this.phonePrefixString,
//       @required this.firebaseVerificationId});
//   bool isLoading = false;
//
//   setIsLoading(bool loading) {
//     isLoading = loading;
//   }
//
// //verify the provided code with the firebase server
//   void onSmsCodeChanged(String smsCode) async {
//     this.smsCode = smsCode;
//   }
//   void verifyFirebaseOTP() async {
//
//     if (smsCode!.length != 6) {
//       return;
//     }
//     setIsLoading(true);
//     // setBusyForObject(firebaseVerificationId, true);
//
//     // Sign the user in (or link) with the credential
//     try {
//       // Create a PhoneAuthCredential with the code
//       PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
//         verificationId: firebaseVerificationId,
//         smsCode: smsCode,
//       );
//
//       UserCredential userCredential =
//           await FirebaseAuth.instance.signInWithCredential(
//         phoneAuthCredential,
//       );
//       //
//       firebaseToken = await userCredential.user.getIdToken();
//       print('firebaseToken --- ${firebaseToken}');
//       AuthProvider authProvider =
//           Provider.of<AuthProvider>(contextBuilder, listen: false);
//       authProvider.loginByPhone(firebaseToken).then((status) async {
//         if (status.isSuccess) {
//           await Provider.of<WishListProvider>(contextBuilder, listen: false)
//               .initWishList(contextBuilder);
//           await Provider.of<ProfileProvider>(contextBuilder, listen: false).getUserInfo(contextBuilder);
//           if (Provider.of<ProfileProvider>(contextBuilder, listen: false).userInfoModel !=
//               null) {
//             DateTime _date = DateTime.now().add(const Duration(days: 7));
//             var box = Hive.box('myBox');
//             box.put('rate_last_datetime', _date);
//             UserInfoModel _userInfoModel =
//                 Provider.of<ProfileProvider>(contextBuilder, listen: false).userInfoModel;
//             if(_userInfoModel.fName.isEmpty){
//               Navigator.of(contextBuilder).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
//                   UserNameScreen()), (Route<dynamic> route) => false);
//             }else {
//
//               Navigator.pushNamedAndRemoveUntil(
//                   contextBuilder, Routes.getMainRoute(), (route) => false);
//             }
//           }
//         } else {
//          // showCustomSnackBar(status.message, contextBuilder);
//           Navigator.pushNamedAndRemoveUntil(
//               contextBuilder, Routes.getSignUpRoute(), (route) => false);
//         }
//         setIsLoading(false);
//       });
//     } catch (error) {
//       print('error---- ');
//       Navigator.pushNamedAndRemoveUntil(
//           contextBuilder, Routes.getSignUpRoute(), (route) => false);
//       //viewContext.showToast(msg: "$error", bgColor: Colors.red);
//       showCustomSnackBar("$error", contextBuilder);
//       setIsLoading(false);
//     }
//     //
//     // setBusyForObject(firebaseVerificationId, false);
//   }
//
//   processFirebaseForgotPassword(String phoneNumber) async {
//     setIsLoading(true);
//     //firebase authentication
//     await FirebaseAuth.instance.verifyPhoneNumber(
//       phoneNumber: phoneNumber,
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         //
//         UserCredential userCredential =
//             await FirebaseAuth.instance.signInWithCredential(
//           credential,
//         );
//
//         //fetch user id token
//         firebaseToken = await userCredential.user.getIdToken();
//         firebaseVerificationId = credential.verificationId;
//
//         setIsLoading(false);
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         if (e.code == 'invalid-phone-number') {
//           loginErrorMessage = "Invalid Phone Number";
//         } else {
//           loginErrorMessage = e.message;
//         }
//         // setBusy(false);
//         setIsLoading(false);
//       },
//       codeSent: (String verificationId, int resendToken) {
//         firebaseVerificationId = verificationId;
//         //Navigator.pushNamed(context, Routes.getVerificationPhoneScreen(_phoneTEC.text, selectedCountryCode.dialCode));
//         print("codeSent: (String verificationId, int resendToken) " +
//             verificationId);
//         setIsLoading(false);
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         setIsLoading(false);
//         print("codeSent: (String verificationId, int resendToken) " +
//             verificationId);
//         //Navigator.pushNamed(context, Routes.getVerificationPhoneScreen(_phoneTEC.text, selectedCountryCode.dialCode));
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     this.contextBuilder = context;
//     print("phonePrefixString " +
//         phonePrefixString +
//         " phoneString " +
//         phoneString);
//     return Scaffold(
//       appBar: CustomAppBar(
//           title:
//               "Verify Phone"), //CustomAppBar(title: getTranslated('verify_email', context)),
//       body: SafeArea(
//         child: Scrollbar(
//           child: SingleChildScrollView(
//             physics: BouncingScrollPhysics(),
//             child: Center(
//               child: SizedBox(
//                 width: ResponsiveHelper.isWeb() ? 600 : 1170,
//                 child: Consumer<AuthProvider>(
//                   builder: (context, authProvider, child) => Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       /*
//                       SizedBox(height: 55),
//                       Image.asset(
//                         Images.email_with_background,
//                         width: 142,
//                         height: 142,
//                       ),
//                       SizedBox(height: 40),
//                       */
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 50),
//                         child: Center(
//                             child: Text(
//                           '${getTranslated('please_enter_6_digit_code', context)}\n $phoneString',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               color: ColorResources.getHintColor(context)),
//                         )),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 5, vertical: 35),
//                         child: PinCodeTextField(
//                           length: 6,
//                           appContext: context,
//                           obscureText: false,
//                           keyboardType: TextInputType.number,
//                           animationType: AnimationType.fade,
//                           pinTheme: PinTheme(
//                             shape: PinCodeFieldShape.box,
//                             fieldHeight: 63,
//                             fieldWidth: ResponsiveHelper.isWeb()
//                                 ? 50
//                                 : MediaQuery.of(context).size.width.toInt() /
//                                         6 -
//                                     10,
//                             borderWidth: 1,
//                             borderRadius: BorderRadius.circular(10),
//                             selectedColor: ColorResources.colorMap[200],
//                             selectedFillColor: Colors.white,
//                             inactiveFillColor:
//                                 ColorResources.getSearchBg(context),
//                             inactiveColor: ColorResources.colorMap[200],
//                             activeColor: ColorResources.colorMap[400],
//                             activeFillColor:
//                                 ColorResources.getSearchBg(context),
//                           ),
//                           animationDuration: Duration(milliseconds: 300),
//                           backgroundColor: Colors.transparent,
//                           enableActiveFill: true,
//                           onChanged: onSmsCodeChanged,
//                           beforeTextPaste: (text) {
//                             return true;
//                           },
//                         ),
//                       ),
//                       // for login button
//                       SizedBox(height: 10),
//                       isLoading
//                           ? CustomCircularIndicator()
//                           : Padding(
//                            padding: const EdgeInsets.all(15.0),
//                            child: CustomButton(
//                               text: getTranslated('login', context),
//                               onTap: () async {
//                                 verifyFirebaseOTP();
//                               },
//                             ),
//                           ),
//                       // for create an account
//                       SizedBox(height: 10),
//                     ],
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
