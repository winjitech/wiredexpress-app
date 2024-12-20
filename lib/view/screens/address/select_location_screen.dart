import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:flutter/src/services/asset_bundle.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/location_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/Images.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/main_app_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class SelectLocationScreen extends StatefulWidget {
  @override
  _SelectLocationScreenState createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  GoogleMapController? _controller;
  TextEditingController _locationController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();
  TextEditingController _addressController = TextEditingController();
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
  //  _loadMapStyles();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
    _addressController.dispose();
    _searchFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<LocationProvider>(context).address != null) {
      _locationController.text =
          '${Provider.of<LocationProvider>(context).address.name ?? ''}, '
          '${Provider.of<LocationProvider>(context).address.subAdministrativeArea ?? ''}, '
          '${Provider.of<LocationProvider>(context).address.isoCountryCode ?? ''}';
    }

    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      appBar: ResponsiveHelper.isDesktop(context)
          ? PreferredSize(
              child: MainAppBar(), preferredSize: Size.fromHeight(80))
          : AppBar(
              backgroundColor: ColorResources.SCAFFOLD_COLOR,
              elevation: 0,
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: Colors.white,
                  )),
              centerTitle: true,
              title: Text(
                getTranslated('select_delivery_address', context),
                style: TextStyle(
                    color: ColorResources.getScaffoldBackgroundColor(context)),
              ),
            ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Consumer<LocationProvider>(
            builder: (context, locationProvider, child) => Stack(
              clipBehavior: Clip.none,
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(locationProvider.position.latitude,
                        locationProvider.position.longitude),
                    zoom: 8,
                  ),
                  zoomControlsEnabled: false,
                  compassEnabled: false,
                  indoorViewEnabled: true,
                  mapToolbarEnabled: true,
                  myLocationButtonEnabled: false,
                  onCameraIdle: () {
                    locationProvider.dragableAddress();
                  },
                  onCameraMove: ((_position) =>
                      locationProvider.updatePosition(_position)),
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                    if (_controller != null) {
                      // locationProvider.getCurrentLocation(
                      //     mapController: _controller);
                    }
                    // controller.setMapStyle(
                    //     Provider.of<ThemeProvider>(context, listen: false)
                    //             .darkTheme
                    //         ? _darkMapStyle
                    //         : _lightMapStyle);
                  },
                ),
                placesAutoCompleteTextField(),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          // locationProvider.getCurrentLocation(
                          //     mapController: _controller);

                          locationProvider.getCurrentLocation(
                              mapController: _controller);
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.only(
                              right: Dimensions.PADDING_SIZE_LARGE),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                Dimensions.PADDING_SIZE_SMALL),
                            color: ColorResources.getScaffoldBackgroundColor(
                                context),
                          ),
                          child: Icon(
                            Icons.my_location,
                            color: ColorResources.SCAFFOLD_COLOR,
                            size: 35,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                        child: CustomButton(
                          text: getTranslated('select_location', context),
                          onTap: locationProvider.loading
                              ? null
                              : () {
                                  Navigator.pop(context);
                                  locationProvider.saveSearchedPosition();
                                  // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> AddNewAddressScreen()));
                                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=> AddNewAddressScreen()));
                                },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height,
                    child: Image.asset(
                      Images.marker,
                      width: 25,
                      height: 35,
                    )),
                locationProvider.loading
                    ? Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              ColorResources.SCAFFOLD_COLOR,)))
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void searchPlaces(String query) async {
    try {
      List<Location> locations =
          await GeocodingPlatform.instance!.locationFromAddress("$query, pr");
      if (locations.isNotEmpty) {
        _controller?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(locations[0].latitude, locations[0].longitude),
              zoom: 14.0,
            ),
          ),
        );
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Location not found ,try again or use your current location ",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              actions: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          color: ColorResources.SCAFFOLD_COLOR,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Provider.of<LocationProvider>(context, listen: false)
                              .getCurrentLocation(mapController: _controller);
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.my_location,
                          color:ColorResources.SCAFFOLD_COLOR,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
    }
  }

  placesAutoCompleteTextField() {
    return Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
      return Container(
        height: 80,
        padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
        child: GooglePlaceAutoCompleteTextField(
          textStyle: TextStyle(color: ColorResources.SCAFFOLD_COLOR),
          boxDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorResources.getScaffoldBackgroundColor(context),
            border: Border.all(
                width: 1,
                color:ColorResources.SCAFFOLD_COLOR,),
          ),
          textEditingController: _addressController,
          googleAPIKey: AppConstants.API_KEY,
          inputDecoration: InputDecoration(
              hintText: 'Search your location',
              hintStyle:
                  TextStyle(color: ColorResources.SCAFFOLD_COLOR,),
              border: InputBorder.none,
              enabledBorder: InputBorder.none),
          debounceTime: 400,
          countries: ["PR"],
          isLatLngRequired: true,
          getPlaceDetailWithLatLng: (Prediction prediction) {
            searchPlaces(_addressController.text);
            print('prediction=> ${prediction.description}');
            print('prediction=> ${prediction.lat}');
            print('prediction=> ${prediction.lng}');
            locationProvider.updateSearchedPosition(LatLng(
                double.parse(prediction.lat!), double.parse(prediction.lng!)));

            // locationProvider.updateInitialPosition(LatLng(double.parse(prediction.lat!),
            //     double.parse(prediction.lng!)));
            // Navigator.of(context).pop();
          },
          itemClick: (Prediction prediction) async {
            _addressController.text = prediction.description ?? "";
            _addressController.selection = TextSelection.fromPosition(
                TextPosition(offset: prediction.description?.length ?? 0));
          },
          seperatedBuilder: Divider(),
          itemBuilder: (context, index, Prediction prediction) {
            return Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(Icons.location_on),
                  SizedBox(
                    width: 7,
                  ),
                  Expanded(child: Text("${prediction.description ?? ""}"))
                ],
              ),
            );
          },
          isCrossBtnShown: true,
        ),
      );
    });
  }
}
