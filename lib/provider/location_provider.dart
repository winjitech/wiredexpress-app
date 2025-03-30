import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:wired_express/data/model/response/address_model.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/base/error_response.dart';
import 'package:wired_express/data/model/response/response_model.dart';
import 'package:wired_express/data/model/response/zone_model.dart';
import 'package:wired_express/data/repository/location_repo.dart';
import 'package:wired_express/helper/api_checker.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider with ChangeNotifier {
  final SharedPreferences? sharedPreferences;
  final LocationRepo? locationRepo;

  LocationProvider({@required this.sharedPreferences, this.locationRepo});

  Position _position = Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1,
      altitudeAccuracy: 0,
      headingAccuracy: 0);

  bool _loading = false;
  bool get loading => _loading;

  Position get position => _position;
  Placemark _address = Placemark();

  Placemark get address => _address;

  List<Marker> _markers = <Marker>[];
  List<Marker> get markers => _markers;

  LatLng? _initialPosition;
  LatLng? get initialPosition => _initialPosition;

  LatLng? _searchedPosition;
  LatLng? get searchedPosition => _searchedPosition;

  GoogleMapController? _mapController;
  GoogleMapController? get mapController => _mapController;

  double _deliveryFee = 0.0;
  double get deliveryFee => _deliveryFee;

  bool _outOfArea = false;
  bool get outOfArea => _outOfArea;

  String? _searchedText;
  String? get searchedText => _searchedText;

  void updateMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(40.37945080378499, -3.6686044671734765),
    zoom: 12,
  );
  CameraPosition get cameraPosition => _cameraPosition;

  void updateInitialPosition(LatLng position) {
    _initialPosition = position;
    print('position 2 ${_initialPosition}');
    _cameraPosition = CameraPosition(
      target: position,
      zoom: 12,
    );

    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: position, zoom: 12)));
    }
    notifyListeners();
  }

  void updateSearchedPosition(LatLng position) {
    _searchedPosition = position;

    // _cameraPosition = CameraPosition(
    //   target: position,
    //   zoom: 12,
    // );

    // if (_mapController != null) {
    //   _mapController!.animateCamera(CameraUpdate.newCameraPosition(
    //       CameraPosition(target: position, zoom: 12)));
    // }
    notifyListeners();
  }

  void saveSearchedPosition() {
    _initialPosition = _searchedPosition;

    _cameraPosition = CameraPosition(
      target: _initialPosition!,
      zoom: 12,
    );

    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: _initialPosition!, zoom: 12)));
    }
    _searchedText = '${_address.name}'
        ' ${_address.subAdministrativeArea}'
        ' ${_address.isoCountryCode}';

    notifyListeners();
  }

  // for get current location
  void getCurrentLocation(
      {GoogleMapController? mapController, bool fromSearch = false}) async {
    print('test 3');
    _loading = true;
    notifyListeners();
    try {
      Position newLocalData = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _position = newLocalData;
      _searchedPosition = LatLng(_position.latitude, _position.longitude);
      print('test 4 ${_searchedPosition!.latitude} ');
      if (mapController != null) {
        mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(newLocalData.latitude, newLocalData.longitude),
                zoom: 17)));
        _position = newLocalData;

        List<Placemark> placemarks = await placemarkFromCoordinates(
            newLocalData.latitude, newLocalData.longitude);
        _address = placemarks.first;
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
    _loading = false;
    notifyListeners();
  }

  /// update location
  void updateCurrentLocation(
      {GoogleMapController? mapController, LatLng? latLng}) async {
    _loading = true;
    notifyListeners();
    try {
      if (mapController != null) {
        mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: latLng!, zoom: 17)));

        Position newLocalData = Position(
            latitude: latLng.latitude,
            longitude: latLng.longitude,
            accuracy: 0.0,
            altitude: 0.0,
            speed: 0.0,
            heading: 0.0,
            speedAccuracy: 0.0,
            timestamp: DateTime.now(),
            altitudeAccuracy: 0,
            headingAccuracy: 0);

        List<Placemark> placemarks = await placemarkFromCoordinates(
            newLocalData.latitude, newLocalData.longitude);
        _address = placemarks.first;
        _searchedText = '${_address.name}'
            ' ${_address.subAdministrativeArea}'
            ' ${_address.isoCountryCode}';
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
    _loading = false;
    notifyListeners();
  }

  void updateLocation({LatLng? latLng}) async {
    _loading = true;
    notifyListeners();
    try {
      if (mapController != null) {
        _mapController!.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: latLng!, zoom: 12)));
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
    _loading = false;
    notifyListeners();
  }

  // update Position
  void updatePosition(CameraPosition position) async {
    _position = Position(
        latitude: position.target.latitude,
        longitude: position.target.longitude,
        timestamp: DateTime.now(),
        heading: 1,
        accuracy: 1,
        altitude: 1,
        speedAccuracy: 1,
        speed: 1,
        altitudeAccuracy: 0,
        headingAccuracy: 0);
  }

  // End Address Position
  void dragableAddress() async {
    try {
      _loading = true;
      notifyListeners();
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _position.latitude, _position.longitude);
      _address = placemarks.first;
      _loading = false;
      _searchedPosition = LatLng(_position.latitude, _position.longitude);
      notifyListeners();
    } catch (e) {
      _loading = false;
      notifyListeners();
    }
  }

  // delete usser address
  void deleteUserAddressByID(int id, int index, Function callback) async {
    ApiResponse apiResponse = await locationRepo!.removeAddressByID(id);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _addressList!.removeAt(index);
      callback(true, 'Deleted address successfully');
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors![0].message);
        errorMessage = errorResponse.errors![0].message!;
      }
      callback(false, errorMessage);
    }
    notifyListeners();
  }

  bool _isAvaibleLocation = false;

  bool get isAvaibleLocation => _isAvaibleLocation;

  // user address
  List<AddressModel>? _addressList;
  List<AddressModel>? get addressList => _addressList;
  ZonesModel? _zoneList;
  ZonesModel? get zoneList => _zoneList;

  Future<ResponseModel> initAddressList(BuildContext? context) async {
    ResponseModel? _responseModel;
    ApiResponse apiResponse = await locationRepo!.getAllAddress();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      print('test 1');
      _addressList = [];
      apiResponse.response!.data!.forEach(
          (address) => _addressList!.add(AddressModel.fromJson(address)));
      // print(" model address => ${_addressList![0].id}");
      _responseModel = ResponseModel(true, 'successful');
    } else {
      print('test 2');
      // ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
    return _responseModel!;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  String _addressStatusMessage = '';
  String get addressStatusMessage => _addressStatusMessage;

  updateAddressStatusMessae({String? message}) {
    _addressStatusMessage = message!;
  }

  updateErrorMessage({String? message}) {
    _errorMessage = message!;
  }

  Future<ResponseModel> addAddress(AddressModel addressModel) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = '';
    _addressStatusMessage = '';
    ApiResponse apiResponse = await locationRepo!.addAddress(addressModel);
    _isLoading = false;
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      if (_addressList == null) {
        _addressList = [];
      }
      _addressList!.add(addressModel);
      String message = map["message"];
      responseModel = ResponseModel(true, message);
      _addressStatusMessage = message;
    } else {
      String errorMessage = apiResponse.error.toString();
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors![0].message);
        errorMessage = errorResponse.errors![0].message!;
      }
      responseModel = ResponseModel(false, errorMessage);
      _errorMessage = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  // for address update screen
  Future<ResponseModel> updateAddress(BuildContext? context,
      {AddressModel? addressModel, int? addressId}) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = '';
    _addressStatusMessage = '';
    ApiResponse apiResponse =
        await locationRepo!.updateAddress(addressModel!, addressId!);
    _isLoading = false;
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      initAddressList(context);
      String message = map["message"];
      responseModel = ResponseModel(true, message);
      _addressStatusMessage = message;
    } else {
      String errorMessage = apiResponse.error.toString();
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors![0].message);
        errorMessage = errorResponse.errors![0].message!;
      }
      responseModel = ResponseModel(false, errorMessage);
      _errorMessage = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  // for save user address Section
  Future<void> saveUserAddress({Placemark? address}) async {
    String userAddress = jsonEncode(address);
    try {
      await sharedPreferences!
          .setString(AppConstants.USER_ADDRESS, userAddress);
    } catch (e) {
      throw e;
    }
  }

  String getUserAddress() {
    return sharedPreferences!.getString(AppConstants.USER_ADDRESS) ?? "";
  }

  // for Label Us
  List<String> _getAllAddressType = [];

  List<String> get getAllAddressType => _getAllAddressType;
  int _selectAddressIndex = 0;

  int get selectAddressIndex => _selectAddressIndex;

  updateAddressIndex(int index) {
    _selectAddressIndex = index;
    notifyListeners();
  }

  initializeAllAddressType({BuildContext? context}) {
    if (_getAllAddressType.length == 0) {
      _getAllAddressType = [];
      _getAllAddressType = locationRepo!.getAllAddressType(context: context);
    }
  }

  // Future<ResponseModel> getZone(
  //     BuildContext? context, String latitude, String longitude) async {
  //   ResponseModel? _responseModel;
  //   ApiResponse apiResponse = await locationRepo!.getZone(latitude, longitude);
  //   if (apiResponse.response != null &&
  //       apiResponse.response!.statusCode == 200) {
  //     print('zone 1');
  //     _zoneList = [];
  //     apiResponse.response!.data!
  //         .forEach((zone) => _zoneList!.add(ZonesModel.fromJson(zone)));
  //     // print(" id zoneList => ${_zoneList![0].id}");
  //     // print("zoneList => ${_zoneList!}");
  //
  //     _responseModel = ResponseModel(true, 'successful');
  //   } else {
  //     print('zone 2');
  //     ApiChecker.checkApi(context, apiResponse);
  //   }
  //   notifyListeners();
  //   return _responseModel!;
  // }

  bool? _zoneLoading = false;
  bool? get zoneLoading => _zoneLoading;
  // Future<void> getZone(
  //     BuildContext? context, String latitude, String longitude) async {
  //   _zoneLoading = true;
  //
  //   ApiResponse apiResponse = await locationRepo!.getZone(latitude, longitude);
  //   if (apiResponse.response != null &&
  //       apiResponse.response!.statusCode == 200) {
  //     _zoneLoading = false;
  //
  //     _zoneList = [];
  //     final responseData = apiResponse.response!.data;
  //     if (responseData is List) {
  //       responseData.forEach((zoneModel) {
  //         if (zoneModel is Map<String, dynamic>) {
  //           _zoneList!.add(ZonesModel.fromJson(zoneModel));
  //         }
  //       });
  //     }
  //     notifyListeners();
  //   } else {
  //     // ApiChecker.checkApi(context, apiResponse);
  //   }
  // }
  Future<ResponseModel> getZone(
      BuildContext? context, String latitude, String longitude) async {
    ResponseModel _responseModel;
    ApiResponse apiResponse = await locationRepo!.getZone(latitude, longitude);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _zoneList = ZonesModel.fromJson(apiResponse.response!.data);
      if (_zoneList != null) {
        _outOfArea = false;
        _deliveryFee =
            _zoneList!.deliveryFee != null ? _zoneList!.deliveryFee! : 0.0;
        if (_zoneList!.deliveryFee == null) {
          _outOfArea = true;
        }
      } else if (_zoneList == null) {
        _outOfArea = true;
        notifyListeners();
      } else {
        _outOfArea = true;
        notifyListeners();
      }
      _responseModel = ResponseModel(true, 'successful');
    } else {
      String _errorMessage;
      if (apiResponse.error is String) {
        _errorMessage = apiResponse.error.toString();
      } else {
        _errorMessage = apiResponse.error.errors[0].message;
      }
      print(_errorMessage);
      _responseModel = ResponseModel(false, _errorMessage);
      // ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
    return _responseModel;
  }
}
