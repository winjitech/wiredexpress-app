class FinancingStepModel {
  int? _stepNumber;
  String? _title;
  String? _description;

  FinancingStepModel({
    int? stepNumber,
    String? title,
    String? description,
  }) {
    _stepNumber = stepNumber;
    _title = title;
    _description = description;
  }

  int? get stepNumber => _stepNumber;
  String? get title => _title;
  String? get description => _description;

  FinancingStepModel.fromJson(Map<String?, dynamic> json) {
    _stepNumber = json['step_number'];
    _title = json['title'];
    _description = json['description'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = Map<String?, dynamic>();
    data['step_number'] = _stepNumber;
    data['title'] = _title;
    data['description'] = _description;
    return data;
  }
}