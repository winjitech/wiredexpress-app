
import 'package:wired_express/data/model/response/order_model.dart';

class InstallmentPaymentModel {
  int? _id;
  int? _orderInstallmentId;
  int? _orderId;
  int? _userId;
  int? _installmentNumber;
  double? _amount;
  double? _remainingBalance;
  String? _dueDate;
  String? _requestedAt;
  String? _paidAt;
  String? _status;
  String? _paymentMethod;
  String? _transactionReference;
  String? _adminNote;
  String? _customerNote;

  OrderModel? _order;

  InstallmentPaymentModel({
    int? id,
    int? orderInstallmentId,
    int? orderId,
    int? userId,
    int? installmentNumber,
    double? amount,
    double? remainingBalance,
    String? dueDate,
    String? requestedAt,
    String? paidAt,
    String? status,
    String? paymentMethod,
    String? transactionReference,
    String? adminNote,
    String? customerNote,
    OrderModel? order, 
  }) {
    _id = id;
    _orderInstallmentId = orderInstallmentId;
    _orderId = orderId;
    _userId = userId;
    _installmentNumber = installmentNumber;
    _amount = amount;
    _remainingBalance = remainingBalance;
    _dueDate = dueDate;
    _requestedAt = requestedAt;
    _paidAt = paidAt;
    _status = status;
    _paymentMethod = paymentMethod;
    _transactionReference = transactionReference;
    _adminNote = adminNote;
    _customerNote = customerNote;
    _order = order; 
  }

  int? get id => _id;
  int? get orderInstallmentId => _orderInstallmentId;
  int? get orderId => _orderId;
  int? get userId => _userId;
  int? get installmentNumber => _installmentNumber;
  double? get amount => _amount;
  double? get remainingBalance => _remainingBalance;
  String? get dueDate => _dueDate;
  String? get requestedAt => _requestedAt;
  String? get paidAt => _paidAt;
  String? get status => _status;
  String? get paymentMethod => _paymentMethod;
  String? get transactionReference => _transactionReference;
  String? get adminNote => _adminNote;
  String? get customerNote => _customerNote;

  OrderModel? get order => _order; 

  InstallmentPaymentModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'] != null ? int.parse(json['id'].toString()) : null;
    _orderInstallmentId = json['order_installment_id'] != null
        ? int.parse(json['order_installment_id'].toString())
        : null;
    _orderId =
    json['order_id'] != null ? int.parse(json['order_id'].toString()) : null;
    _userId =
    json['user_id'] != null ? int.parse(json['user_id'].toString()) : null;
    _installmentNumber = json['installment_number'] != null
        ? int.parse(json['installment_number'].toString())
        : null;

    _amount = double.parse(json['amount']?.toString() ?? "0");
    _remainingBalance =
        double.parse(json['remaining_balance']?.toString() ?? "0");

    _dueDate = json['due_date'];
    _requestedAt = json['requested_at'];
    _paidAt = json['paid_at'];
    _status = json['status'];
    _paymentMethod = json['payment_method'];
    _transactionReference = json['transaction_reference'];
    _adminNote = json['admin_note'];
    _customerNote = json['customer_note'];

    _order = json['order'] != null
        ? OrderModel.fromJson(json['order'])
        : null; 
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'order_installment_id': _orderInstallmentId,
      'order_id': _orderId,
      'user_id': _userId,
      'installment_number': _installmentNumber,
      'amount': _amount,
      'remaining_balance': _remainingBalance,
      'due_date': _dueDate,
      'requested_at': _requestedAt,
      'paid_at': _paidAt,
      'status': _status,
      'payment_method': _paymentMethod,
      'transaction_reference': _transactionReference,
      'admin_note': _adminNote,
      'customer_note': _customerNote,
      'order': _order?.toJson(), 
    };
  }
}