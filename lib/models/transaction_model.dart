class TransactionModel {
  String user;
  int amount;
  String reason;
  DateTime timestamp;
  TransactionModel(
      {required this.user,
      required this.amount,
      required this.reason,
      required this.timestamp});
}
