import 'package:first_dapp/features/dashboard/bloc/dash_board_bloc.dart';
import 'package:first_dapp/features/deposit/deposit.dart';
import 'package:first_dapp/features/withdraw/withdraw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  final DashBoardBloc _dashBoardBloc= DashBoardBloc();
  @override
  void initState() {
    
    super.initState();
    _dashBoardBloc.add(DashBoardInitialFetch());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web3 Wallet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const UserInfo(),
            const SizedBox(height: 16),
            const Text('Send or receive Ethereum',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const DepositScreen()));
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const WithdrawScreen()));
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
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: SvgPicture.asset('assets/eth-logo.svg',
                        width: 32, height: 32),
                    title: const Text('0x1234567890abcdef'),
                    subtitle: Text('0.00 ETH'),
                    trailing: Text('12:00 PM'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.grey[200],
        child: Row(
          children: [
            SvgPicture.asset('assets/eth-logo.svg', width: 48, height: 48),
            const SizedBox(width: 20),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wallet Address',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('0x1234567890abcdef'),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Balance',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('0.00 ETH'),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
