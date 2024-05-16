part of 'dash_board_bloc.dart';

@immutable
sealed class DashBoardEvent {}

class DashBoardInitialFetch extends DashBoardEvent {}

class DashBoardSuccessState extends DashBoardEvent {
  final List<TransactionModel> transactionModel;
  final int balance;
  final String walletAddress;
  DashBoardSuccessState({required this.transactionModel, required this.balance, required this.walletAddress});
  
}

class DashboardDepositEvent extends DashBoardEvent {
  final TransactionModel transactionModel;
  DashboardDepositEvent({required this.transactionModel});
}

class DashboardWithdrawEvent extends DashBoardEvent {
  final TransactionModel transactionModel;
  DashboardWithdrawEvent({required this.transactionModel});
}
