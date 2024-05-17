import 'package:first_dapp/features/dashboard/bloc/dash_board_bloc.dart';
import 'package:first_dapp/models/transaction_model.dart';
import 'package:flutter/material.dart';

class DepositScreen extends StatelessWidget {
  const DepositScreen({super.key, required this.dashBoardBloc});
  final DashBoardBloc dashBoardBloc;


  @override
  Widget build(BuildContext context) {
    TextEditingController amountController = TextEditingController();
    TextEditingController reasonController = TextEditingController();
    TextEditingController recipientController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deposit Ethereum'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Deposit Ethereum',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            //  TextField(
            //   controller: recipientController,
            //   decoration: const InputDecoration(
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
                    dashBoardBloc.add(DashboardDepositEvent(
                      transactionModel: TransactionModel(
                        user: '0x1499F9645Ae571F9A75BE877d4F4489C7A374BAa',
                        amount: int.parse(amountController.text),
                        reason: reasonController.text,
                      
                        
                        timestamp: DateTime.now(),
                      ),
                    ));
                    Navigator.of(context).pop();
                  },
                  child: const Text('Deposit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
