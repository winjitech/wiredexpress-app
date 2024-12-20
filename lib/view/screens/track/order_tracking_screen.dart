import 'dart:async';
import 'dart:collection';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wired_express/data/model/response/order_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/order_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/Images.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/screens/dashboard/dashboard_screen.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String? orderID;
  final OrderModel? track;

  OrderTrackingScreen({
    @required this.orderID,
    @required this.track,
  });

  @override
  OrderTrackingScreenState createState() => OrderTrackingScreenState();
}

class OrderTrackingScreenState extends State<OrderTrackingScreen>
    with WidgetsBindingObserver {
  GoogleMapController? _controller;
  bool _isLoading = true;
  Set<Marker> _markers = HashSet<Marker>();
  List<LatLng> _polylinePoints = [];
  var _lightStyle;
  var _nightStyle;

  late GoogleMapController _mapController;
  late BitmapDescriptor deliveryIcon;
  void _loadData() async {
    Provider.of<OrderProvider>(context, listen: false)
        .trackOrder(widget.orderID!, widget.track!, context, true)
        .then((value) {
      Provider.of<OrderProvider>(context, listen: false).addDirections(
          LatLng(double.parse(widget.track!.deliveryMan!.latitude!),
              double.parse(widget.track!.deliveryMan!.longitude!)),
          LatLng(double.parse(widget.track!.deliveryAddress!.latitude!),
              double.parse(widget.track!.deliveryAddress!.longitude!)));
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMapStyles();
    Timer(Duration(seconds: 1), () async {
      _loadData();
      _loadMapStyles();      WidgetsBinding.instance.addObserver(this);

      BitmapDescriptor.fromAssetImage(
              ImageConfiguration(size: Size(4, 5)), Images.delivery_boy_marker)
          .then((icon) {
        deliveryIcon = icon;
      });
    });
  }

  Future _loadMapStyles() async {
    _lightStyle =
        await rootBundle.loadString('assets/map/map_light_theme.json');
    _nightStyle =
        await rootBundle.loadString('assets/map/map_night_theme.json');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
    Provider.of<OrderProvider>(context, listen: false).cancelTimer();
    WidgetsBinding.instance.removeObserver(this);
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

  void setMarker(
    DeliveryAddress? deliveryAddress,
    DeliveryMan? deliveryMan,
  ) async {
    try {
      _polylinePoints.add(LatLng(double.parse(deliveryAddress!.latitude!),
          double.parse(deliveryAddress.longitude!)));
      _polylinePoints.add(LatLng(double.parse(deliveryMan!.latitude!),
          double.parse(deliveryMan.longitude!)));

      Uint8List deliveryBoyImageData =
          await convertAssetToUnit8List(Images.delivery_boy_marker, width: 100);

      // Marker
      _markers = HashSet<Marker>();

      deliveryAddress != null
          ? _markers.add(Marker(
              markerId: const MarkerId('restaurant'),
              position: LatLng(double.parse(deliveryAddress.latitude!),
                  double.parse(deliveryAddress.longitude!)),
              infoWindow: InfoWindow(
                snippet: deliveryAddress.address,
              ),
              icon: BitmapDescriptor.defaultMarker))
          : const SizedBox();

      deliveryMan != null
          ? _markers.add(Marker(
              markerId: const MarkerId('delivery_boy'),
              position: LatLng(double.parse(deliveryMan.latitude ?? '0'),
                  double.parse(deliveryMan.longitude ?? '0')),
              infoWindow: InfoWindow(
                snippet: deliveryMan.fName,
              ),
              rotation: 0,
              icon: BitmapDescriptor.fromBytes(deliveryBoyImageData),
            ))
          : const SizedBox();
      setState(() {});
    } catch (_) {}
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),

        body: Consumer<OrderProvider>(builder: (context, order, child) {
      return Stack(children: [
        GoogleMap(
            initialCameraPosition: CameraPosition(
                target: LatLng(
                    double.parse(widget.track!.deliveryAddress!.latitude!),
                    double.parse(widget.track!.deliveryAddress!.longitude!)),
                zoom: 5),
            // markers: _createMarkers(),
            markers: _markers,
            minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
            zoomControlsEnabled: true,
            polylines: {
              Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: ColorResources.SCAFFOLD_COLOR,
                  width: 3,
                  points: order.info!.polylinePoints!
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList())
            },
            onMapCreated: (controller) {
              _isLoading = false;

              setMarker(
                widget.track!.deliveryAddress,
                widget.track!.deliveryMan,
              );
              _mapController = controller;
              controller.setMapStyle(
                  Provider.of<ThemeProvider>(context, listen: false).darkTheme
                      ? _nightStyle
                      : _lightStyle);
            }),
        if (_isLoading)
          Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      ColorResources.SCAFFOLD_COLOR)))
        else
          SizedBox.shrink(),
        Positioned(
            top: 5,
            left: 5,
            right: 5,
            child: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                        child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50)),
                                child: Icon(Icons.arrow_back_ios_new_rounded,
                                    color: Colors.black, size: 15))),
                        alignment: Alignment.topLeft)))),
        Positioned(
            top: 10,
            left: MediaQuery.of(context).size.width / 2 - 50,
            child: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                        child: Text(getTranslated('track_order', context),
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 18)),
                        alignment: Alignment.topCenter)))),
        Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25))),
                child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Text('${getTranslated('order_id', context)}: ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)),
                              Text(widget.orderID.toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600))
                            ]),
                            Text("20 MIN",
                                style: TextStyle(
                                    color: Colors.black26, fontSize: 17))
                          ]),
                      SizedBox(height: 15),
                      Row(children: [
                        Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.deliveryManImageUrl}/${widget.track!.deliveryMan!.image}'),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(50))),
                        SizedBox(width: 10),
                        Expanded(
                            child: Text(
                                ' ${widget.track!.deliveryMan!.fName} ${widget.track!.deliveryMan!.lName}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600))),
                        SizedBox(width: 10),
                        Text(widget.track!.deliveryMan!.phone.toString(),
                            style:
                                TextStyle(color: Colors.black26, fontSize: 17)),
                        SizedBox(width: 10),
                        InkWell(
                            onTap: () async {
                              if (await canLaunchUrlString(
                                  'tel:${widget.track!.deliveryMan!.phone}')) {
                                launchUrlString(
                                    'tel:${widget.track!.deliveryMan!.phone}',
                                    mode: LaunchMode.externalApplication);
                              } else {
                                showCustomSnackBar(
                                    '${getTranslated('can_not_launch', context)} ${widget.track!.deliveryMan!.phone}',
                                    context);
                              }
                            },
                            child:
                                Icon(Icons.call, color: Colors.black, size: 30))
                      ]),
                      SizedBox(height: 15),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on_outlined, size: 30),
                            SizedBox(width: 15),
                            Text(widget.track!.deliveryAddress!.address
                                .toString())
                          ]),
                      SizedBox(height: 25),
                      CustomButton(
                          text: getTranslated('back_home', context),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DashboardScreen(pageIndex: 0)));
                          })
                    ]))))
      ]);
    }));
  }
}
