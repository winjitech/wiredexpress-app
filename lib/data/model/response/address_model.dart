// class AddressModel {
//   int? id;
//   String? addressType;
//   String? contactPersonNumber;
//   String? address;
//   String? latitude;
//   String? longitude;
//   String? createdAt;
//   String? updatedAt;
//   int? userId;
//   String? method;
//   String? contactPersonName;
//
//   AddressModel(
//       {this.id,
//       this.addressType,
//       this.contactPersonNumber,
//       this.address,
//       this.latitude,
//       this.longitude,
//       this.createdAt,
//       this.updatedAt,
//       this.userId,
//       this.method,
//       this.contactPersonName});
//
//   AddressModel.fromJson(Map<String?, dynamic> json) {
//     id = json['id'];
//     addressType = json['address_type'];
//     contactPersonNumber = json['contact_person_number'];
//     address = json['address'];
//     latitude = json['latitude'];
//     longitude = json['longitude'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     userId = json['user_id'];
//     method = json['_method'];
//     contactPersonName = json['contact_person_name'];
//   }
//
//   Map<String?, dynamic> toJson() {
//     final Map<String?, dynamic> data = new Map<String?, dynamic>();
//     data['id'] = this.id;
//     data['address_type'] = this.addressType;
//     data['contact_person_number'] = this.contactPersonNumber;
//     data['address'] = this.address;
//     data['latitude'] = this.latitude;
//     data['longitude'] = this.longitude;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['user_id'] = this.userId;
//     data['_method'] = this.method;
//     data['contact_person_name'] = this.contactPersonName;
//     return data;
//   }
// }
class AddressModel {
  int? _id;
  String? _addressType;
  String? _contactPersonNumber;
  String? _address;
  String? _latitude;
  String? _longitude;
  String? _createdAt;
  String? _updatedAt;
  int? _userId;
  String? _method;
  String? _contactPersonName;

  AddressModel({
    int? id,
    String? addressType,
    String? contactPersonNumber,
    String? address,
    String? latitude,
    String? longitude,
    String? createdAt,
    String? updatedAt,
    int? userId,
    String? method,
    String? contactPersonName,
  }) {
    this._id = id;
    this._addressType = addressType;
    this._contactPersonNumber = contactPersonNumber;
    this._address = address;
    this._latitude = latitude;
    this._longitude = longitude;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._userId = userId;
    this._method = method;
    this._contactPersonName = contactPersonName;
  }

  int? get id => _id;
  String? get addressType => _addressType;
  String? get contactPersonNumber => _contactPersonNumber;
  String? get address => _address;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get userId => _userId;
  String? get method => _method;
  String? get contactPersonName => _contactPersonName;

  set id(int? id) {
    this._id = id;
  }
  set userId(int? userId) {
    this._userId = userId;
  }
  set method(String? method) {
    this._method = method;
  }

  AddressModel.fromJson(Map<String?, dynamic> json) {
    _id = json['id'];
    _addressType = json['address_type'];
    _contactPersonNumber = json['contact_person_number'];
    _address = json['address'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _userId = json['user_id'];
    _method = json['_method'];
    _contactPersonName = json['contact_person_name'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['id'] = this._id;
    data['address_type'] = this._addressType;
    data['contact_person_number'] = this._contactPersonNumber;
    data['address'] = this._address;
    data['latitude'] = this._latitude;
    data['longitude'] = this._longitude;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['user_id'] = this._userId;
    data['_method'] = this._method;
    data['contact_person_name'] = this._contactPersonName;
    return data;
  }
}
