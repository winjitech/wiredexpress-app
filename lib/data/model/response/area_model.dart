class AreaModel {
  String? _name;
  String? _description;

  AreaModel({String? name, String? description}) {
    this._name = name;
    this._description = description;
  }

  String? get name => _name;
  String? get description => _description;

  AreaModel.fromJson(Map<String?, dynamic> json) {
    _name = json['name'];
    _description = json['description'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['name'] = this._name;
    data['description'] = this._description;
    return data;
  }
}
