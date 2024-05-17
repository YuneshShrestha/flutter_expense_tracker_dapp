import 'package:first_dapp/features/dashboard/bloc/dash_board_bloc.dart';
import 'package:first_dapp/models/transaction_model.dart';
import 'package:flutter/material.dart';

class WithdrawScreen extends StatelessWidget {
  const WithdrawScreen({super.key, required this.dashBoardBloc});
  final DashBoardBloc dashBoardBloc;

  @override
  Widget build(BuildContext context) {
    TextEditingController amountController = TextEditingController();
    TextEditingController reasonController = TextEditingController();
    TextEditingController recipientController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdraw Ethereum'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Withdraw Ethereum',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            // const TextField(
            //   controller: recipientController,
            //   decoration: InputDecoration(
            //       labelText: 'Recipient Address', border: OutlineInputBorder()),
            // ),
            // const SizedBox(height: 16),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    dashBoardBloc.add(
                      DashboardWithdrawEvent(
                        transactionModel: TransactionModel(
                          amount: int.parse(amountController.text),
                          reason: reasonController.text,
                          timestamp: DateTime.now(),
                          user: recipientController.text,
                        ),
                      ),
                    );

                    Navigator.of(context).pop();
                  
                  },
                  child: const Text('Withdraw'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
