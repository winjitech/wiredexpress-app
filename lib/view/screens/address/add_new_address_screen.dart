import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wired_express/data/model/response/address_model.dart';
import 'package:wired_express/data/model/response/config_model.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/location_provider.dart';
import 'package:wired_express/provider/order_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/routes.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_text_field.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wired_express/view/screens/address/select_location_screen.dart';
import 'package:wired_express/view/screens/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/theme/dark_theme.dart';
import 'package:wired_express/theme/light_theme.dart';
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
      appBar: CustomAppBar(
          title: widget.isEnableUpdate!
              ? getTranslated('update_address', context)
              : getTranslated('add_new_address', context)),
      body: Padding(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: Consumer<LocationProvider>(
          builder: (context, locationProvider, child) {
            if (locationProvider.address != null &&
                ResponsiveHelper.isMobilePhone()) {
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
                      padding: EdgeInsets.all(12.0),
                      child: Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            //   physics: BouncingScrollPhysics(),
                            children: [
                              Container(
                                height: 126,
                                width: MediaQuery.of(context).size.width,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.PADDING_SIZE_SMALL),
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
                                          if (ResponsiveHelper
                                              .isMobilePhone()) {
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
                                          }
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
                                          locationProvider.updateMapController(controller);
                                          if (!widget.isEnableUpdate! &&
                                              _controller != null) {
                                            Provider.of<LocationProvider>(
                                                    context,
                                                    listen: false)
                                                .getCurrentLocation(
                                                    mapController: locationProvider.mapController);
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
                                          ? Center(
                                              child: CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          ColorResources
                                                              .SCAFFOLD_COLOR)))
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
                                            width: 25,
                                            height: 35,
                                          )),
                                      Positioned(
                                        bottom: 10,
                                        right: 0,
                                        child: InkWell(
                                          onTap: () {
                                            locationProvider.getCurrentLocation(
                                                mapController: locationProvider.mapController);
                                          },
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            margin: EdgeInsets.only(
                                                right: Dimensions
                                                    .PADDING_SIZE_LARGE),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions
                                                          .PADDING_SIZE_SMALL),
                                              color: ColorResources
                                                  .getScaffoldBackgroundColor(
                                                      context),
                                            ),
                                            child: Icon(
                                              Icons.my_location,
                                              color:
                                                  ColorResources.SCAFFOLD_COLOR,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Center(
                                    child: Text(
                                  getTranslated(
                                      'add_the_location_correctly', context),
                                  style:TextStyle(
                                          color:
                                              ColorResources.getGreyBunkerColor(
                                                  context),
                                          fontSize: Dimensions.FONT_SIZE_SMALL),
                                )),
                              ),

                              // for label us
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 24.0),
                                child: Text(
                                  getTranslated('label_us', context),
                                  style: TextStyle(
                                          color:
                                              ColorResources.getGreyBunkerColor(
                                                  context),
                                          fontSize: Dimensions.FONT_SIZE_LARGE),
                                ),
                              ),

                              Container(
                                height: 50,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  // physics: BouncingScrollPhysics(),
                                  itemCount:
                                      locationProvider.getAllAddressType.length,
                                  itemBuilder: (context, index) => InkWell(
                                    onTap: () {
                                      locationProvider
                                          .updateAddressIndex(index);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              Dimensions.PADDING_SIZE_DEFAULT,
                                          horizontal:
                                              Dimensions.PADDING_SIZE_LARGE),
                                      margin: EdgeInsets.only(right: 17),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            Dimensions.PADDING_SIZE_SMALL,
                                          ),
                                          border: Border.all(
                                              color: locationProvider
                                                          .selectAddressIndex ==
                                                      index
                                                  ? ColorResources
                                                      .SCAFFOLD_COLOR
                                                  : ColorResources
                                                      .BORDER_COLOR),
                                          color: locationProvider
                                                      .selectAddressIndex ==
                                                  index
                                              ? ColorResources.SCAFFOLD_COLOR
                                              : ColorResources
                                                  .getScaffoldBackgroundColor(
                                                      context)),
                                      child: Text(
                                        locationProvider
                                            .getAllAddressType[index],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: locationProvider
                                                            .selectAddressIndex ==
                                                        index
                                                    ? ColorResources
                                                        .getScaffoldBackgroundColor(
                                                            context)
                                                    : ColorResources
                                                        .getTextColor(context)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 24.0),
                                child: Text(
                                  getTranslated('delivery_address', context),
                                  style: TextStyle(
                                          color:
                                              ColorResources.getGreyBunkerColor(
                                                  context),
                                          fontSize: Dimensions.FONT_SIZE_LARGE),
                                ),
                              ),

                              // for Address Field
                              Text(
                                getTranslated('address_line_01', context),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: ColorResources.getHintColor(
                                            context)),
                              ),
                              SizedBox(height: 8),
                              CustomTextField(
                                hintText:
                                    getTranslated('address_line_02', context),
                                isShowBorder: false,
                                inputType: TextInputType.streetAddress,
                                inputAction: TextInputAction.next,
                                focusNode: _addressNode,
                                nextFocus: _nameNode,
                                controller: _locationController,
                              ),
                              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                              // for Contact Person Name
                              Text(
                                getTranslated('contact_person_name', context),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: ColorResources.getHintColor(
                                            context)),
                              ),
                              SizedBox(height: 8),
                              CustomTextField(
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
                              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                              // for Contact Person Number
                              Text(
                                getTranslated('contact_person_number', context),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: ColorResources.getHintColor(
                                            context)),
                              ),
                              SizedBox(height: 8),
                              CustomTextField(
                                hintText: getTranslated(
                                    'enter_contact_person_number', context),
                                isShowBorder: false,
                                inputType: TextInputType.phone,
                                inputAction: TextInputAction.done,
                                focusNode: _numberNode,
                                controller: _contactPersonNumberController,
                              ),
                              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

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
                              style: TextStyle(
                                      fontSize: Dimensions.FONT_SIZE_SMALL,
                                      color: Colors.green,
                                      height: 1),
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
                              style: TextStyle(
                                      fontSize: Dimensions.FONT_SIZE_SMALL,
                                      color: ColorResources.getPrimaryColor(
                                          context),
                                      height: 1),
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
                                          Provider.of<OrderProvider>(context,
                                                  listen: false)
                                              .setAddressIndex(-1);
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
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(value.message),
                                                  backgroundColor:
                                                      Colors.green));
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(value.message),
                                                backgroundColor: Colors.red));
                                      }
                                    });
                                  }
                                },
                        )
                      : Center(
                          child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              ColorResources.SCAFFOLD_COLOR),
                        )),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
