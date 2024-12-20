import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:wired_express/utill/app_constants.dart';
import 'package:wired_express/view/screens/track/directions.dart';

class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json';

  Future<Directions> getDirections({
    @required LatLng? origin,
    @required LatLng? destination,
  }) async {
    String originInfo = '${origin!.latitude},${origin.longitude}';
    String destinationInfo =
        '${destination!.latitude},${destination.longitude}';
    String key = AppConstants.API_KEY;

    var url = Uri.parse(
        '$_baseUrl?origin=$originInfo&destination=$destinationInfo&key=$key');
    var response = await http.get(url);

    // Check if response is successful
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      print('test 1 ${response.body}');
      return Directions.fromMap(body);
    } else {
      print('test 2 ${response.body}');
    }
    return null!;
  }
}
