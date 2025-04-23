import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/model/response/order_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/order_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:widget_to_marker/widget_to_marker.dart';
import 'package:flutter/services.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/screens/track/direction_repository.dart';

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

class OrderTrackingScreenState extends State<OrderTrackingScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = HashSet<Marker>();
  late BitmapDescriptor deliveryIcon;
  int _currentCoordinateIndex = 0;
  Timer? _moveMarkerTimer;
  bool _isLoading = true;
  List<LatLng> _coordinatesList = [];
  late LatLng dropOff;
  var _lightStyle;
  var _nightStyle;
  String? _estimatedDistance;
  String? _estimatedDuration;

  @override
  void initState() {
    super.initState();
    _loadMapStyles();

    dropOff = LatLng(double.parse(widget.track!.deliveryAddress!.latitude!),
        double.parse(widget.track!.deliveryAddress!.longitude!));
    print("dropOff == $dropOff");
    Timer(const Duration(seconds: 0), () async => _loadData());
  }

  @override
  void dispose() {
    _moveMarkerTimer?.cancel();
    super.dispose();
  }

  Future _loadMapStyles() async {
    _lightStyle =
        await rootBundle.loadString('assets/map/map_light_theme.json');
    _nightStyle =
        await rootBundle.loadString('assets/map/map_night_theme.json');
  }

  void _loadData() async {
    print("=====================================");

    final response = await Provider.of<OrderProvider>(context, listen: false)
        .getLastDeliveryCoordinates(context, widget.orderID!);

    if (response.isSuccess) {
      final coordinates = Provider.of<OrderProvider>(context, listen: false)
              .lastDeliveryCoordinates
              ?.coordinates ??
          [];

      _coordinatesList = coordinates
          .map((coord) => LatLng(coord['latitude']!, coord['longitude']!))
          .toList();

      print("_coordinatesList == ${_coordinatesList.first}");
      if (_coordinatesList.isNotEmpty) {
        _initializeMarker(_coordinatesList.first);
        await _getDistanceAndDuration(_coordinatesList.first, dropOff);

        _startMovingMarker();
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _getDistanceAndDuration(
      LatLng origin, LatLng destination) async {
    final directions = await DirectionsRepository().getDirections(
      origin: origin,
      destination: destination,
    );

    setState(() {
      _estimatedDistance = directions.totalDistance;
      _estimatedDuration = directions.totalDuration;

      print('Distance: $_estimatedDistance');
      print('Duration: $_estimatedDuration');
    });
  }

  Future<void> _initializeMarker(LatLng position) async {
    final dropOffLocationIcon = await Image(
      image: const AssetImage(Images.delivery_boy_marker),
      height: 80,
      width: 80,
    ).toBitmapDescriptor(
        logicalSize: const Size(350, 300), imageSize: const Size(500, 200));
    _markers.clear();
    _markers.add(Marker(
        markerId: const MarkerId('delivery_man'),
        position: position,
        icon: dropOffLocationIcon));
    setState(() {});
  }

  Future<void> _startMovingMarker() async {
    final dropOffLocationIcon = await Image(
      image: const AssetImage(Images.delivery_boy_marker),
      height: 80,
      width: 80,
    ).toBitmapDescriptor(
        logicalSize: const Size(350, 300), imageSize: const Size(500, 200));

    _moveMarkerTimer =
        Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (_currentCoordinateIndex >= _coordinatesList.length - 1) {
        timer.cancel();
        _startFetchingNewCoordinates();
        return;
      }

      _currentCoordinateIndex++;
      final nextPosition = _coordinatesList[_currentCoordinateIndex];

      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('delivery_man'),
          position: nextPosition,
          icon: dropOffLocationIcon,
        ),
      );

      _mapController?.animateCamera(
        CameraUpdate.newLatLng(nextPosition),
      );

      await _getDistanceAndDuration(nextPosition, dropOff);

      setState(() {});
    });
  }

  void _startFetchingNewCoordinates() {
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      final response = await Provider.of<OrderProvider>(context, listen: false)
          .getLastDeliveryCoordinates(context, widget.orderID!);

      if (response.isSuccess) {
        final coordinates = Provider.of<OrderProvider>(context, listen: false)
                .lastDeliveryCoordinates
                ?.coordinates ??
            [];

        if (coordinates.isNotEmpty) {
          _coordinatesList = coordinates
              .map((coord) => LatLng(coord['latitude']!, coord['longitude']!))
              .toList();

          _currentCoordinateIndex = 0;

          _initializeMarker(_coordinatesList.first);
          _startMovingMarker();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: getTranslated('track_order', context)),
        body: Column(
          children: [
            Expanded(
              child: _isLoading
                  ? const CustomCircularIndicator()
                  : Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: _coordinatesList.isNotEmpty
                                ? _coordinatesList.first
                                : const LatLng(0, 0),
                            zoom: 10,
                          ),
                          markers: _markers,
                          onMapCreated: (GoogleMapController controller) {
                            _mapController = controller;
                            controller.setMapStyle(Provider.of<ThemeProvider>(
                                        context,
                                        listen: false)
                                    .darkTheme
                                ? _nightStyle
                                : _lightStyle);
                          },
                        ),
                        if (_estimatedDistance != null &&
                            _estimatedDuration != null)
                          Positioned(
                            top: 20,
                            left: 20,
                            right: 20,
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: ColorResources.getCardColor(context)
                                      .withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${getTranslated('estimated_distance', context)} :  $_estimatedDistance',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color:
                                            ColorResources.getTextColor(context)
                                                .withOpacity(0.9)),
                                  ),
                                  Text(
                                    '${getTranslated('estimated_duration', context)} : $_estimatedDuration',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color:
                                            ColorResources.getTextColor(context)
                                                .withOpacity(0.9)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
            )
          ],
        ));
  }
}
