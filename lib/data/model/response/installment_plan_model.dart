class InstallmentPlanModel {
  int? _months;
  double? _interestRate;

  InstallmentPlanModel({
    int? months,
    double? interestRate,
  }) {
    _months = months;
    _interestRate = interestRate;
  }

  int? get months => _months;
  double? get interestRate => _interestRate;

  InstallmentPlanModel.fromJson(Map<String, dynamic> json) {
    _months = int.parse(json['months'].toString());

    if (json['interest_rate'] != null) {
      _interestRate =double.parse(json['interest_rate']?.toString()??"0");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'months': _months,
      'interest_rate': _interestRate,
    };
  }
}
