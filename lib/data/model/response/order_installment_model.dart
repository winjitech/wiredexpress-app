class OrderInstallmentModel {
  int? _id;
  int? _orderId;
  int? _userId;
  int? _installmentPlanId;
  int? _months;
  double? _orderAmount;
  double? _downPayment;
  double? _financedAmount;
  double? _monthlyPayment;
  double? _interestRate;
  double? _totalPayable;
  String? _firstInstallmentDate;
  String? _status;
  String? _adminNote;
  String? _createdAt;
  String? _updatedAt;

  OrderInstallmentModel({
    int? id,
    int? orderId,
    int? userId,
    int? installmentPlanId,
    int? months,
    double? orderAmount,
    double? downPayment,
    double? financedAmount,
    double? monthlyPayment,
    double? interestRate,
    double? totalPayable,
    String? firstInstallmentDate,
    String? status,
    String? adminNote,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _orderId = orderId;
    _userId = userId;
    _installmentPlanId = installmentPlanId;
    _months = months;
    _orderAmount = orderAmount;
    _downPayment = downPayment;
    _financedAmount = financedAmount;
    _monthlyPayment = monthlyPayment;
    _interestRate = interestRate;
    _totalPayable = totalPayable;
    _firstInstallmentDate = firstInstallmentDate;
    _status = status;
    _adminNote = adminNote;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  int? get id => _id;
  int? get orderId => _orderId;
  int? get userId => _userId;
  int? get installmentPlanId => _installmentPlanId;
  int? get months => _months;
  double? get orderAmount => _orderAmount;
  double? get downPayment => _downPayment;
  double? get financedAmount => _financedAmount;
  double? get monthlyPayment => _monthlyPayment;
  double? get interestRate => _interestRate;
  double? get totalPayable => _totalPayable;
  String? get firstInstallmentDate => _firstInstallmentDate;
  String? get status => _status;
  String? get adminNote => _adminNote;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  OrderInstallmentModel.fromJson(Map<String?, dynamic> json) {
    _id = json['id'];
    _orderId = json['order_id'];
    _userId = json['user_id'];
    _installmentPlanId = json['installment_plan_id'];
    _months = json['months'];
    _orderAmount = json['order_amount'] != null
        ? (json['order_amount'] as num).toDouble()
        : null;
    _downPayment = json['down_payment'] != null
        ? (json['down_payment'] as num).toDouble()
        : null;
    _financedAmount = json['financed_amount'] != null
        ? (json['financed_amount'] as num).toDouble()
        : null;
    _monthlyPayment = json['monthly_payment'] != null
        ? (json['monthly_payment'] as num).toDouble()
        : null;
    _interestRate = json['interest_rate'] != null
        ? (json['interest_rate'] as num).toDouble()
        : null;
    _totalPayable = json['total_payable'] != null
        ? (json['total_payable'] as num).toDouble()
        : null;
    _firstInstallmentDate = json['first_installment_date'];
    _status = json['status'];
    _adminNote = json['admin_note'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = {};

    data['id'] = _id;
    data['order_id'] = _orderId;
    data['user_id'] = _userId;
    data['installment_plan_id'] = _installmentPlanId;
    data['months'] = _months;
    data['order_amount'] = _orderAmount;
    data['down_payment'] = _downPayment;
    data['financed_amount'] = _financedAmount;
    data['monthly_payment'] = _monthlyPayment;
    data['interest_rate'] = _interestRate;
    data['total_payable'] = _totalPayable;
    data['first_installment_date'] = _firstInstallmentDate;
    data['status'] = _status;
    data['admin_note'] = _adminNote;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;

    return data;
  }
}