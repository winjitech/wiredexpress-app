import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wired_express/data/model/response/address_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui';

import 'package:provider/provider.dart';

class MapWidget extends StatefulWidget {
  final AddressModel? address;
  MapWidget({@required this.address});

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  LatLng? _latLng;
  Set<Marker> _markers = Set.of([]);
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
    _latLng = LatLng(double.parse(widget.address!.latitude!),
        double.parse(widget.address!.longitude!));
    _setMarker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      body: Column(
        children: [
          CustomAppBar(title: 'delivery_address', showBackButton: true),
          Expanded(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Stack(children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(target: _latLng!, zoom: 8),
                    zoomGesturesEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    indoorViewEnabled: true,
                    markers: _markers,
                    onMapCreated: (GoogleMapController controller) {
                      controller.setMapStyle(
                          Provider.of<ThemeProvider>(context, listen: false).darkTheme
                              ? _darkMapStyle
                              : _lightMapStyle);
                    },
                  ),
                  Positioned(
                    left: Dimensions.PADDING_SIZE_LARGE,
                    right: Dimensions.PADDING_SIZE_LARGE,
                    bottom: Dimensions.PADDING_SIZE_LARGE,
                    child: Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          color: ColorResources.getScaffoldBackgroundColor(context),
                          boxShadow: [
                            BoxShadow(
                              color: ColorResources.getBoxShadow(context),

                              blurRadius: 5,
                              spreadRadius: 1,
                            )
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Icon(
                              widget.address!.addressType == 'Home'
                                  ? Icons.home_outlined
                                  : widget.address!.addressType == 'Workplace'
                                      ? Icons.work_outline
                                      : Icons.list_alt_outlined,
                              size: 30.sp,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.address!.addressType!,
                                      style: AppTextStyles.h7(context).copyWith(
                                        color: Colors.grey,
                                      ),
                                    ),

                                    Text(
                                      widget.address!.address!,
                                      style: AppTextStyles.h6(context),
                                    ),
                                  ]),
                            ),
                          ]),
                          Text(
                            '- ${widget.address!.contactPersonName}',
                            style: AppTextStyles.h4(context).copyWith(
                              color: ColorResources.getScaffoldBackgroundColor(context),
                            ),
                          ),

                          Text(
                            '- ${widget.address!.contactPersonNumber}',
                            style: AppTextStyles.h5(context).copyWith(
                              color: ColorResources.getScaffoldBackgroundColor(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _setMarker() async {
    Uint8List destinationImageData =
        await convertAssetToUnit8List(Images.destination_marker, width: 70);

    _markers = Set.of([]);
    _markers.add(Marker(
      markerId: MarkerId('marker'),
      position: _latLng!,
      icon: BitmapDescriptor.fromBytes(destinationImageData),
    ));

    setState(() {});
  }

  Future<Uint8List> convertAssetToUnit8List(String imagePath,
      {int width = 50}) async {
    ByteData data = await rootBundle.load(imagePath);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
