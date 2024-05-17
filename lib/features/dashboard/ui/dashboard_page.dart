import 'dart:developer';

import 'package:first_dapp/features/dashboard/bloc/dash_board_bloc.dart';
import 'package:first_dapp/features/deposit/deposit.dart';
import 'package:first_dapp/features/withdraw/withdraw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  final DashBoardBloc _dashBoardBloc = DashBoardBloc();
  @override
  void initState() {
    _dashBoardBloc.add(DashBoardInitialFetch());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web3 Wallet'),
      ),
      body: BlocConsumer<DashBoardBloc, DashBoardState>(
        bloc: _dashBoardBloc,
        listener: (context, state) {},
        builder: (context, state) {
          log('State: $state');
          if (state is DashBoardInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is DashboardErrorState) {
            return Center(
              child: Text(state.errorMessage),
            );
          } else if (state is DashboardSuccessState) {
            final transactions = state.transactions;
            final balance = state.balance;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserInfo(
                    walletAddress: state.walletAddress,
                    balance: state.balance,
                  ),
                  const SizedBox(height: 16),
                  const Text('Send or receive Ethereum',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DepositScreen(
                                    dashBoardBloc: _dashBoardBloc,
                                  )));
                        },
                        icon: Column(
                          children: [
                            SvgPicture.asset('assets/deposit.svg',
                                width: 48, height: 48),
                            const Text('Deposit'),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => WithdrawScreen(
                                dashBoardBloc: _dashBoardBloc,
                              ),
                            ),
                          );
                        },
                        icon: Column(
                          children: [
                            SvgPicture.asset('assets/withdraw.svg',
                                width: 48, height: 48),
                            const Text('Withdraw'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Text('Recent Transactions',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: SvgPicture.asset('assets/eth-logo.svg',
                              width: 32, height: 32),
                          title: Text(transactions[index].reason),
                          subtitle:
                              FittedBox(child: Text(transactions[index].user)),
                          trailing: Text("${transactions[index].amount} ETH"),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox(
            child: Center(child: Text('Loading...')),
          );
        },
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({
    super.key,
    required this.walletAddress,
    required this.balance,
  });
  final String walletAddress;
  final int balance;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.grey[200],
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: SvgPicture.asset('assets/eth-logo.svg',
                  width: 48, height: 48),
            ),
            const SizedBox(width: 20),
            Flexible(
              flex: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Wallet Address',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    walletAddress,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    'Balance',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('$balance ETH'),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
