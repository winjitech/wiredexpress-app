import 'package:wired_express/data/model/response/financing_step_model.dart';

class FinancingProviderModel {
  int? _id;
  String? _name;
  String? _logoPath;
  String? _badge;
  String? _shortDescription;
  String? _detailedDescription;
  String? _websiteUrl;
  List<String>? _benefits;
  List<FinancingStepModel>? _steps;
  bool? _isActive;
  String? _createdAt;
  String? _updatedAt;

  FinancingProviderModel({
    int? id,
    String? name,
    String? logoPath,
    String? badge,
    String? shortDescription,
    String? detailedDescription,
    String? websiteUrl,
    List<String>? benefits,
    List<FinancingStepModel>? steps,
    bool? isActive,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _name = name;
    _logoPath = logoPath;
    _badge = badge;
    _shortDescription = shortDescription;
    _detailedDescription = detailedDescription;
    _websiteUrl = websiteUrl;
    _benefits = benefits;
    _steps = steps;
    _isActive = isActive;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  int? get id => _id;
  String? get name => _name;
  String? get logoPath => _logoPath;
  String? get badge => _badge;
  String? get shortDescription => _shortDescription;
  String? get detailedDescription => _detailedDescription;
  String? get websiteUrl => _websiteUrl;
  List<String>? get benefits => _benefits;
  List<FinancingStepModel>? get steps => _steps;
  bool? get isActive => _isActive;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  FinancingProviderModel.fromJson(Map<String?, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _logoPath = json['logo_path'];
    _badge = json['badge'];
    _shortDescription = json['short_description'];
    _detailedDescription = json['detailed_description'];
    _websiteUrl = json['website_url'];

    if (json['benefits'] != null) {
      _benefits = List<String>.from(json['benefits']);
    }

    if (json['steps'] != null) {
      _steps = [];
      json['steps'].forEach((v) {
        _steps!.add(FinancingStepModel.fromJson(v));
      });
    }

    _isActive = json['is_active'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = Map<String?, dynamic>();

    data['id'] = _id;
    data['name'] = _name;
    data['logo_path'] = _logoPath;
    data['badge'] = _badge;
    data['short_description'] = _shortDescription;
    data['detailed_description'] = _detailedDescription;
    data['website_url'] = _websiteUrl;
    data['benefits'] = _benefits;

    if (_steps != null) {
      data['steps'] = _steps!.map((v) => v.toJson()).toList();
    }

    data['is_active'] = _isActive;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;

    return data;
  }
}