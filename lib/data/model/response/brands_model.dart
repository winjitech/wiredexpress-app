class Brand {
  int? _id;
  String? _name;
  String? _image;
  int? _featured;

  Brand(
      {int? id,
        String? name,
        String? image,
        int? featured,
      }) {
    this._id = id;
    this._name = name;
    this._image = image;
    this._featured = featured;
  }

  int? get id => _id;
  String? get name => _name;
  String? get image => _image;
  int? get featured => _featured;



  Brand.fromJson(Map<String?, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _image = json['image'];
    _featured = json['featured'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['name_ar'] = this._name;
    data['image'] = this._image;
    data['featured'] = this._featured;
    return data;
  }
}
