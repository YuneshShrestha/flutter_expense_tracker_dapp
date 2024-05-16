part of 'dash_board_bloc.dart';

@immutable
sealed class DashBoardState {}

final class DashBoardInitial extends DashBoardState {}

class DashBoardLoadingState extends DashBoardState {}

class DashboardErrorState extends DashBoardState {
  final String errorMessage;
  DashboardErrorState({required this.errorMessage});
}

class DashboardSuccessState extends DashBoardState {
  final List<TransactionModel> transactions;
  final int balance;
  final String walletAddress;
  DashboardSuccessState({
    required this.transactions,
    required this.balance,
    required this.walletAddress,
  });
}

class DashboardDepositSuccessState extends DashBoardState {}
class DashboardWithdrawSuccessState extends DashBoardState {}