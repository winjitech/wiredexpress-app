class InstallmentPlanModel {
  int? _months;
  List<InterestRateModel>? _interestRates;

  InstallmentPlanModel({
    int? months,
    List<InterestRateModel>? interestRates,
  }) {
    _months = months;
    _interestRates = interestRates;
  }

  int? get months => _months;

  List<InterestRateModel>? get interestRates => _interestRates;

  InstallmentPlanModel.fromJson(Map<String, dynamic> json) {
    _months = int.tryParse(json['months'].toString());

    if (json['interest_rates'] != null) {
      _interestRates = [];
      json['interest_rates'].forEach((v) {
        _interestRates!.add(InterestRateModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'months': _months,
      'interest_rates':
      _interestRates?.map((e) => e.toJson()).toList(),
    };
  }
}

class InterestRateModel {
  double? _rate;

  InterestRateModel({
    double? rate,
  }) {
    _rate = rate;
  }

  double? get rate => _rate;

  InterestRateModel.fromJson(Map<String, dynamic> json) {
    _rate = double.tryParse(json['rate'].toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'rate': _rate,
    };
  }
}