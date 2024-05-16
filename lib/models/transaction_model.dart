class TransactionModel {
  String user;
  int amount;
  String reason;
  int timestamp;
  TransactionModel(
      {required this.user,
      required this.amount,
      required this.reason,
      required this.timestamp});
}
