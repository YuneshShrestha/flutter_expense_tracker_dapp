import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:first_dapp/models/transaction_model.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

part 'dash_board_event.dart';
part 'dash_board_state.dart';

class DashBoardBloc extends Bloc<DashBoardEvent, DashBoardState> {
  DashBoardBloc() : super(DashBoardInitial()) {
    on<DashBoardInitialFetch>(dashboardInitialFetchEvent);
    on<DashboardDepositEvent>(dashboardDepositEvent);
    on<DashboardWithdrawEvent>(dashboardWithdrawEvent);
  }

  Web3Client? _web3Client;
  late ContractAbi _abiCode;
  late EthereumAddress _contractAddress;
  late EthPrivateKey _creds;
  int balance = 0;

  // Functions
  late DeployedContract _deployedContract;
  late ContractFunction _depositFunction;
  late ContractFunction _withdrawFunction;
  late ContractFunction _getBalanceFunction;
  late ContractFunction _getAllTransactionsFunction;

  FutureOr<void> dashboardInitialFetchEvent(
      DashBoardInitialFetch event, Emitter<DashBoardState> emit) async {
    try {
      String rpcUrl = "http://192.168.1.88:7545";
      String socketUrl = "ws://192.168.1.88:7545";

      String privateKey =
          "0x19d998b17a8eea588fa1ab3ecbdaba584636e8eeea16fb0ead5e7ac80788e082";

      _creds = EthPrivateKey.fromHex(privateKey);
      _web3Client = Web3Client(
        rpcUrl,
        http.Client(),
        socketConnector: () {
          return IOWebSocketChannel.connect(socketUrl).cast<String>();
        },
      );

      // getABI
      String abiFile =
          await rootBundle.loadString("build/contracts/ExpenseManager.json");

      var jsonDecoded = jsonDecode(abiFile);
      _abiCode = ContractAbi.fromJson(
          jsonEncode(jsonDecoded["abi"]), "ExpenseManager");

      _contractAddress =
          EthereumAddress.fromHex(jsonDecoded["networks"]["5777"]["address"]);
      log("Contract Address: $_contractAddress");
      _deployedContract = DeployedContract(_abiCode, _contractAddress);

      _depositFunction = _deployedContract.function("deposit");
      _withdrawFunction = _deployedContract.function("withdraw");

      _getBalanceFunction = _deployedContract.function("getBalance");
      _getAllTransactionsFunction =
          _deployedContract.function("getAllTransactions");

      final transactionData = await _web3Client!.call(
          contract: _deployedContract,
          function: _getAllTransactionsFunction,
          params: []);
      final balanceData = await _web3Client!.call(
          contract: _deployedContract,
          function: _getBalanceFunction,
          params: [
            EthereumAddress.fromHex(
                '0x1499F9645Ae571F9A75BE877d4F4489C7A374BAa')
          ]);

      List<TransactionModel> transactions = [];
      for (int i = 0; i < transactionData[0].length; i++) {
        transactions.add(TransactionModel(
          user: transactionData[0][i].toString(),
          amount: transactionData[1][i].toInt(),
          reason: transactionData[2][i].toString(),
          timestamp: DateTime.fromMillisecondsSinceEpoch(
              transactionData[3][i].toInt()),
        ));
      }

      balance = balanceData[0].toInt();
      log(balance.toString());
      log(transactions.toString());
      emit(DashboardSuccessState(
        transactions: transactions,
        balance: balance,
        walletAddress: _creds.address.hex,
      ));
      log("Success");
    } catch (e) {
      log(e.toString());
      emit(DashboardErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> dashboardDepositEvent(
      DashboardDepositEvent event, Emitter<DashBoardState> emit) async {
    try {
      final transaction = event;
      log(_creds.address.hex);
      final transactionData = await _web3Client!.sendTransaction(
        _creds,
        Transaction.callContract(
          from: EthereumAddress.fromHex(
              '0x1499F9645Ae571F9A75BE877d4F4489C7A374BAa'),
          contract: _deployedContract,
          function: _depositFunction,
          parameters: [
            BigInt.from(transaction.transactionModel.amount),
            transaction.transactionModel.reason,
          ],
          value: EtherAmount.inWei(
            BigInt.from(transaction.transactionModel.amount),
          ),
        ),
        fetchChainIdFromNetworkId: false,
        chainId: 1337,
      );
      log(transactionData);
      add(DashBoardInitialFetch());
      emit(DashboardDepositSuccessState());
    } catch (e) {
      log(e.toString());
      emit(DashboardErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> dashboardWithdrawEvent(
      DashboardWithdrawEvent event, Emitter<DashBoardState> emit) async {
    try {
      final transaction = event;
      final transactionData = await _web3Client!.sendTransaction(
        _creds,
        Transaction.callContract(
          from: EthereumAddress.fromHex(
              '0x1499F9645Ae571F9A75BE877d4F4489C7A374BAa'),
          contract: _deployedContract,
          function: _withdrawFunction,
          parameters: [
            BigInt.from(transaction.transactionModel.amount),
            transaction.transactionModel.reason,
          ],
        ),
        fetchChainIdFromNetworkId: false,
        chainId: 1337,
      );
      log(transactionData);
      add(DashBoardInitialFetch());
      emit(DashboardWithdrawSuccessState());
    } catch (e) {
      log(e.toString());
      emit(DashboardErrorState(errorMessage: e.toString()));
    }
  }
}
