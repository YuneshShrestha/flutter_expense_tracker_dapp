part of 'dash_board_bloc.dart';

@immutable
sealed class DashBoardEvent {}

class DashBoardInitialFetch extends DashBoardEvent {}

class DashboardDepositEvent extends DashBoardEvent {
  final TransactionModel transactionModel;
  DashboardDepositEvent({required this.transactionModel});
}

class DashboardWithdrawEvent extends DashBoardEvent {
  final TransactionModel transactionModel;
  DashboardWithdrawEvent({required this.transactionModel});
}
