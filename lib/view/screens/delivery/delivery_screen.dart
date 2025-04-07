import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/model/response/cart_model.dart';
import 'package:wired_express/data/model/response/userinfo_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/place_order_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_main_appbar.dart';
import 'package:wired_express/view/base/custom_text_field.dart';
import 'package:wired_express/view/screens/cart/widget/status_cart_widget.dart';
import 'package:wired_express/view/screens/checkout/payment_screen.dart';
import 'package:wired_express/view/screens/drawer/drawer_screen.dart';

class DeliveryScreen extends StatefulWidget {
  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  ScrollController scrollController = ScrollController();

  FocusNode _emailFocus = FocusNode();
  FocusNode _nameFoucs = FocusNode();
  FocusNode _phoneFoucs = FocusNode();
  FocusNode _countryFoucs = FocusNode();
  FocusNode _streetFoucs = FocusNode();
  FocusNode _postCodeFoucs = FocusNode();

  TextEditingController? _emailController;
  TextEditingController? _nameController;
  TextEditingController? _phoneController;
  TextEditingController? _countryController;
  TextEditingController? _streetController;
  TextEditingController? _postController;
  GlobalKey<FormState>? _formKeyLogin;

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _countryController = TextEditingController();
    _streetController = TextEditingController();
    _postController = TextEditingController();

    if (Provider.of<ProfileProvider>(context, listen: false).userInfoModel !=
        null) {
      UserInfoModel _userInfoModel =
          Provider.of<ProfileProvider>(context, listen: false).userInfoModel!;
      _nameController!.text =
          '${_userInfoModel.fName}  ${_userInfoModel.lName}' ?? "";

      _phoneController!.text = _userInfoModel.phone ?? '';
      _emailController!.text = _userInfoModel.email ?? '';
    }
  }

  @override
  void dispose() {
    _emailController!.dispose();
    _nameController!.dispose();
    _phoneController!.dispose();
    _countryController!.dispose();
    _streetController!.dispose();
    _postController!.dispose();

    super.dispose();
  }

  final advancedDrawerController = AdvancedDrawerController();
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
          title: getTranslated('delivery', context),
        ),
        body: Consumer<ProfileProvider>(
          builder: (context, customAuthProvider, child) {
            return Form(
              key: _formKeyLogin,
              child: Scrollbar(
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
                          cart: true,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'contact',
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          hintText:
                              getTranslated('contact_person_name', context),
                          controller: _nameController,
                          focusNode: _nameFoucs,
                          nextFocus: _emailFocus,
                          inputType: TextInputType.text,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          hintText: getTranslated('email', context),
                          controller: _emailController,
                          focusNode: _emailFocus,
                          nextFocus: _phoneFoucs,
                          inputType: TextInputType.text,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          hintText: getTranslated('phone_number', context),
                          controller: _phoneController,
                          focusNode: _phoneFoucs,
                          inputType: TextInputType.phone,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            getTranslated('address', context),
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          hintText: getTranslated('your_country', context),
                          controller: _countryController,
                          focusNode: _countryFoucs,
                          nextFocus: _streetFoucs,
                          inputType: TextInputType.text,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          hintText: getTranslated('street_details', context),
                          controller: _streetController,
                          focusNode: _streetFoucs,
                          nextFocus: _postCodeFoucs,
                          inputType: TextInputType.text,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          hintText: getTranslated('post_code', context),
                          controller: _postController,
                          focusNode: _postCodeFoucs,
                          inputType: TextInputType.text,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        CustomButton(
                          text: getTranslated('next_step', context),
                          onTap: () {
                            final placeOrder = Provider.of<PlaceOrderProvider>(
                                context,
                                listen: false);
                            placeOrder.setEmail(_emailController!.text);
                            placeOrder.setName(_nameController!.text);
                            placeOrder.setPhone(_phoneController!.text);
                            placeOrder.setCountry(_countryController!.text);
                            placeOrder.setStreet(_streetController!.text);
                            placeOrder.setPostCode(_postController!.text);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        PaymentScreen()));
                          },
                        )
                      ],
                    ),
                  )),
                ),
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
