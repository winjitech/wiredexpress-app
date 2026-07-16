import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wired_express/data/model/response/address_model.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/location_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/base/custom_text_field.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wired_express/view/screens/address/select_location_screen.dart';
import 'package:wired_express/view/screens/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';

class AddNewAddressScreen extends StatefulWidget {
  final bool? isEnableUpdate;
  final bool? fromCheckout;
  final bool? fromSplash;
  final AddressModel? address;
  AddNewAddressScreen(
      {this.isEnableUpdate = false,
      this.address,
      this.fromCheckout = false,
      this.fromSplash = false});

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final TextEditingController _locationController = TextEditingController();

  final TextEditingController _contactPersonNameController =
      TextEditingController();

  final TextEditingController _contactPersonNumberController =
      TextEditingController();

  final FocusNode _addressNode = FocusNode();

  final FocusNode _nameNode = FocusNode();

  final FocusNode _numberNode = FocusNode();

  var _lightMapStyle;
  var _darkMapStyle;
  Future _loadMapStyles() async {
    _lightMapStyle =
        await rootBundle.loadString('assets/map/map_light_theme.json');
    _darkMapStyle =
        await rootBundle.loadString('assets/map/map_night_theme.json');
  }

  @override
  void initState() {
    super.initState();
    _loadMapStyles();
  }

  @override
  Widget build(BuildContext context) {
    GoogleMapController? _controller;

    Provider.of<LocationProvider>(context, listen: false)
        .initializeAllAddressType(context: context);
    Provider.of<LocationProvider>(context, listen: false)
        .updateAddressStatusMessae(message: '');
    Provider.of<LocationProvider>(context, listen: false)
        .updateErrorMessage(message: '');

    if (widget.isEnableUpdate! && widget.address != null) {
      Provider.of<LocationProvider>(context, listen: false).updatePosition(
          CameraPosition(
              target: LatLng(double.parse(widget.address!.latitude!),
                  double.parse(widget.address!.longitude!))));
      _locationController.text = '${widget.address!.address}';
      _contactPersonNameController.text =
          '${widget.address!.contactPersonName}';
      _contactPersonNumberController.text =
          '${widget.address!.contactPersonNumber}';
      if (widget.address!.addressType == 'Home') {
        Provider.of<LocationProvider>(context, listen: false)
            .updateAddressIndex(0);
      } else if (widget.address!.addressType == 'Workplace') {
        Provider.of<LocationProvider>(context, listen: false)
            .updateAddressIndex(1);
      } else {
        Provider.of<LocationProvider>(context, listen: false)
            .updateAddressIndex(2);
      }
    }

    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),

      body: Column(
        children: [
          CustomAppBar(title:  widget.isEnableUpdate!
              ?'update_address':'add_new_address', showBackButton: true),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.r),
              child: Consumer<LocationProvider>(
                builder: (context, locationProvider, child) {
                  if (locationProvider.address != null ) {
                    _locationController.text =
                        '${locationProvider.address.name ?? ''}'
                        ', ${locationProvider.address.subAdministrativeArea ?? ''}'
                        ', ${locationProvider.address.isoCountryCode ?? ''}';
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.all(12.r),
                            child: Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  //   physics: BouncingScrollPhysics(),
                                  children: [
                                    Container(
                                      height: 150.h,
                                      width: MediaQuery.of(context).size.width,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15.r),
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            GoogleMap(
                                              mapType: MapType.normal,
                                              initialCameraPosition: CameraPosition(
                                                target: widget.isEnableUpdate!
                                                    ? LatLng(
                                                        double.parse(widget.address!
                                                                .latitude!) ??
                                                            0.0,
                                                        double.parse(widget.address!
                                                                .longitude!) ??
                                                            0.0)
                                                    : LatLng(
                                                        locationProvider
                                                                .position.latitude ??
                                                            0.0,
                                                        locationProvider
                                                                .position.longitude ??
                                                            0.0),
                                                zoom: 12,
                                              ),
                                              onTap: (latLng) {

                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              SelectLocationScreen()));
                                                  // Navigator.pushNamed(
                                                  //     context,
                                                  //     Routes
                                                  //         .getSelectLocationRoute());

                                              },
                                              zoomControlsEnabled: false,
                                              compassEnabled: false,
                                              indoorViewEnabled: true,
                                              mapToolbarEnabled: false,
                                              myLocationButtonEnabled: false,
                                              onCameraIdle: () {
                                                locationProvider.dragableAddress();
                                              },
                                              onCameraMove: ((_position) =>
                                                  locationProvider
                                                      .updatePosition(_position)),
                                              onMapCreated:
                                                  (GoogleMapController controller) {
                                                locationProvider
                                                    .updateMapController(controller);
                                                if (!widget.isEnableUpdate! &&
                                                    _controller != null) {
                                                  Provider.of<LocationProvider>(
                                                          context,
                                                          listen: false)
                                                      .getCurrentLocation(
                                                          mapController:
                                                              locationProvider
                                                                  .mapController);
                                                }
                                                // controller.setMapStyle(
                                                //     Provider.of<ThemeProvider>(
                                                //                 context,
                                                //                 listen: false)
                                                //             .darkTheme
                                                //         ? _darkMapStyle
                                                //         : _lightMapStyle);
                                              },
                                            ),
                                            locationProvider.loading
                                                ? CustomCircularIndicator()
                                                : SizedBox(),
                                            Container(
                                                width:
                                                    MediaQuery.of(context).size.width,
                                                alignment: Alignment.center,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                child: Image.asset(
                                                  Images.marker,
                                                  width: 25.w,
                                                  height: 35.h,
                                                )),
                                            Positioned(
                                              bottom: 10.h,
                                              right: 0,
                                              child: GestureDetector(
                                                onTap: () => locationProvider
                                                    .getCurrentLocation(
                                                        mapController:
                                                            locationProvider
                                                                .mapController),
                                                child: Container(

                                                  margin: EdgeInsets.only(
                                                      right: 15.w),
                                                  padding: EdgeInsets.all(5.r) ,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(5.r),
                                                    color: ColorResources
                                                        .getScaffoldBackgroundColor(
                                                            context),
                                                  ),
                                                  child: Icon(
                                                    Icons.my_location,
                                                    color: ColorResources
                                                        .getTextColor(
                                                            context),
                                                    size: 20.sp,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.h),
                                      child: Center(
                                        child: Text(
                                          getTranslated(
                                              'add_the_location_correctly', context),
                                          style: AppTextStyles.h8(context).copyWith(
                                            color: ColorResources.getGreyBunkerColor(
                                                context),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // for label us
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 24.h),
                                      child: Text(
                                        getTranslated('label_us', context),
                                        style: AppTextStyles.h8(context).copyWith(
                                          color: ColorResources.getGreyBunkerColor(
                                              context),
                                        ),
                                      ),
                                    ),

                                    Center(
                                      child: SizedBox(
                                        height: 50.h,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          // physics: BouncingScrollPhysics(),
                                          itemCount:
                                              locationProvider.getAllAddressType.length,
                                          itemBuilder: (context, index) =>
                                              GestureDetector(
                                            onTap: () => locationProvider
                                                .updateAddressIndex(index),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical:4.h,
                                                  horizontal:15.w),
                                              margin: EdgeInsets.only(right: 5.w),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10.r),
                                                  border: Border.all(
                                                      color: locationProvider
                                                                  .selectAddressIndex ==
                                                              index
                                                          ? ColorResources
                                                              .getScaffoldBackgroundColor(
                                                                  context)
                                                          : ColorResources
                                                              .BORDER_COLOR),
                                                  color: locationProvider
                                                              .selectAddressIndex ==
                                                          index
                                                      ? ColorResources
                                                          .getPrimaryColor(
                                                              context)
                                                      : ColorResources
                                                          .getScaffoldBackgroundColor(
                                                              context)),
                                              child: Center(
                                                child: Text(
                                                  locationProvider
                                                      .getAllAddressType[index],
                                                  style:
                                                      AppTextStyles.h7(context).copyWith(
                                                    color: locationProvider
                                                                .selectAddressIndex ==
                                                            index
                                                        ? Colors.white
                                                        : ColorResources.getTextColor(
                                                            context),
                                                        fontWeight: locationProvider
                                                            .selectAddressIndex ==
                                                            index
                                                            ? FontWeight.bold
                                                            : null
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15.h),
                                      child: Text(
                                        getTranslated('delivery_address', context),
                                        style: AppTextStyles.h4(context).copyWith(
                                          color: ColorResources.getGreyBunkerColor(
                                              context),
                                        ),
                                      ),
                                    ),

                                    Text(
                                      getTranslated('address_line_01', context),
                                      style: AppTextStyles.h7(context).copyWith(
                                        color: ColorResources.getHintColor(context),
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
                                    CustomTextField(fill: true,
                                      fillColor: ColorResources.getTextFieldFillColor(
                                          context),
                                      hintText:
                                          getTranslated('address_line_02', context),
                                      isShowBorder: false,
                                      inputType: TextInputType.streetAddress,
                                      inputAction: TextInputAction.next,
                                      focusNode: _addressNode,
                                      nextFocus: _nameNode,
                                      controller: _locationController,
                                    ),
                                    SizedBox(height: 20.h),

                                    // for Contact Person Name
                                    Text(
                                      getTranslated('contact_person_name', context),
                                      style: AppTextStyles.h7(context).copyWith(
                                        color: ColorResources.getHintColor(context),
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
                                    CustomTextField(fill: true,
                                      fillColor: ColorResources.getTextFieldFillColor(
                                          context),
                                      hintText: getTranslated(
                                          'enter_contact_person_name', context),
                                      isShowBorder: false,
                                      inputType: TextInputType.name,
                                      controller: _contactPersonNameController,
                                      focusNode: _nameNode,
                                      nextFocus: _numberNode,
                                      inputAction: TextInputAction.next,
                                      capitalization: TextCapitalization.words,
                                    ),
                                    SizedBox(height: 20.h),

                                    // for Contact Person Number
                                    Text(
                                      getTranslated('contact_person_number', context),
                                      style: AppTextStyles.h7(context).copyWith(
                                        color: ColorResources.getHintColor(context),
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
                                    CustomTextField(fill: true,
                                      fillColor: ColorResources.getTextFieldFillColor(
                                          context),
                                      hintText: getTranslated(
                                          'enter_contact_person_number', context),
                                      isShowBorder: false,
                                      inputType: TextInputType.phone,
                                      inputAction: TextInputAction.done,
                                      focusNode: _numberNode,
                                      controller: _contactPersonNumberController,
                                    ),
                                    SizedBox(height: 20.h),

                                    SizedBox(
                                      height: Dimensions.PADDING_SIZE_DEFAULT,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      locationProvider.addressStatusMessage != null
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                locationProvider.addressStatusMessage.length > 0
                                    ? CircleAvatar(
                                        backgroundColor: Colors.green, radius: 5)
                                    : SizedBox.shrink(),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    locationProvider.addressStatusMessage ?? "",
                                    style: AppTextStyles.h8(context).copyWith(
                                      color: Colors.green,
                                      height: 1,
                                    ),
                                  ),
                                )
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                locationProvider.errorMessage.length > 0
                                    ? CircleAvatar(
                                        backgroundColor:
                                            ColorResources.getPrimaryColor(context),
                                        radius: 5)
                                    : SizedBox.shrink(),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    locationProvider.errorMessage ?? "",
                                    style: AppTextStyles.h8(context).copyWith(
                                      color: Colors.green,
                                      height: 1,
                                    ),
                                  ),
                                )
                              ],
                            ),
                      SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                      Container(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width,
                        child: !locationProvider.isLoading
                            ? CustomButton(
                                text: widget.isEnableUpdate!
                                    ? getTranslated('update_address', context)
                                    : getTranslated('save_location', context),
                                onTap: locationProvider.loading
                                    ? null
                                    : () {
                                        FocusScope.of(context).unfocus();
                                        AddressModel addressModel = AddressModel(
                                          addressType: locationProvider
                                                  .getAllAddressType[
                                              locationProvider.selectAddressIndex],
                                          contactPersonName:
                                              _contactPersonNameController.text ?? '',
                                          contactPersonNumber:
                                              _contactPersonNumberController.text ??
                                                  '',
                                          address: _locationController.text ?? '',
                                          latitude: widget.isEnableUpdate!
                                              ? locationProvider.position.latitude
                                                      .toString() ??
                                                  widget.address!.latitude
                                              : locationProvider.position.latitude
                                                      .toString() ??
                                                  '',
                                          longitude: locationProvider
                                                  .position.longitude
                                                  .toString() ??
                                              '',
                                        );
                                        if (widget.isEnableUpdate!) {
                                          addressModel.id = widget.address!.id;
                                          addressModel.userId =
                                              widget.address!.userId;
                                          addressModel.method = 'put';
                                          locationProvider
                                              .updateAddress(context,
                                                  addressModel: addressModel,
                                                  addressId: addressModel.id)
                                              .then((value) {});
                                        } else {
                                          locationProvider
                                              .addAddress(addressModel)
                                              .then((value) {
                                            if (value.isSuccess) {
                                              if (widget.fromCheckout!) {
                                                Provider.of<LocationProvider>(context,
                                                        listen: false)
                                                    .initAddressList(context);

                                                FocusScope.of(context).unfocus();
                                              } else {
                                                widget.fromSplash == true
                                                    ? Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                DashboardScreen(
                                                                    pageIndex: 0)))
                                                    : Navigator.pop(context);

                                                showCustomSnackBar(
                                                    value.message, context,
                                                    isError: false);
                                              }
                                            } else {
                                              showCustomSnackBar(
                                                  value.message, context);
                                            }
                                          });
                                        }
                                      },
                              )
                            : CustomCircularIndicator(),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
