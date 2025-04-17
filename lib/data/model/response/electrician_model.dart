import 'package:wired_express/data/model/response/area_model.dart';

class ElectricianModel {
  String? _name;
  String? _image;
  String? _phone;
  int? _areaId;
  String? _latitude;
  String? _longitude;
  String? _description;
  AreaModel? _area;

  ElectricianModel({
    String? name,
    String? image,
    String? phone,
    int? areaId,
    String? latitude,
    String? longitude,
    String? description,
    AreaModel? area,
  }) {
    this._name = name;
    this._image = image;
    this._phone = phone;
    this._areaId = areaId;
    this._latitude = latitude;
    this._longitude = longitude;
    this._description = description;
    this._area = area;
  }

  String? get name => _name;
  String? get image => _image;
  String? get phone => _phone;
  int? get areaId => _areaId;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get description => _description;
  AreaModel? get area => _area;

  ElectricianModel.fromJson(Map<String?, dynamic> json) {
    _name = json['name'];
    _image = json['image'];
    _phone = json['phone'];
    _areaId = json['area_id'];
    _latitude = json['latitude'].toString();
    _longitude = json['longitude'].toString();
    _description = json['description'];
    _area = json['area'] != null ? AreaModel.fromJson(json['area']) : null;
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['name'] = this._name;
    data['image'] = this._image;
    data['phone'] = this._phone;
    data['area_id'] = this._areaId;
    data['latitude'] = this._latitude;
    data['longitude'] = this._longitude;
    data['description'] = this._description;
    if (_area != null) {
      data['area'] = _area?.toJson();
    }
    return data;
  }
}
