class InstallmentCalculationResultModel {
  final double amount;
  final double downPayment;
  final double financedAmount;
  final double interestRate;
  final int months;
  final double totalAmount;
  final double monthlyPayment;

  InstallmentCalculationResultModel({
    required this.amount,
    required this.downPayment,
    required this.financedAmount,
    required this.interestRate,
    required this.months,
    required this.totalAmount,
    required this.monthlyPayment,
  });
}