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
  }

  Web3Client? _web3Client;
  late ContractAbi _abiCode;
  late EthereumAddress _contractAddress;
  late DeployedContract _deployedContract;
  late ContractFunction _depositFunction;
  late ContractFunction _withdrawFunction;
  late ContractFunction _getBalanceFunction;
  late ContractFunction _getAllTransactionsFunction;

  FutureOr<void> dashboardInitialFetchEvent(event, emit) async {
    try {
      String rpcUrl = "http://192.168.1.88:7545";
      String socketUrl = "ws://192.168.1.88:7545";

      String privateKey =
          "0x6185933855f37994c0c926850a41b007961784ddf122ad1d42e1ec706e18d1d7";
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

      _deployedContract = DeployedContract(_abiCode, _contractAddress);

      _depositFunction = _deployedContract.function("deposit");
      _withdrawFunction = _deployedContract.function("withdraw");

      _getBalanceFunction = _deployedContract.function("getBalance");
      _getAllTransactionsFunction =
          _deployedContract.function("getAllTransactions");

      final data = await _web3Client!.call(
          contract: _deployedContract,
          function: _getAllTransactionsFunction,
          params: []);
      log(data.toString());
      // data.forEach((element) {
      //   log(element.toString());
      // });
    } catch (e) {
      log(e.toString());
      emit(DashboardErrorState(errorMessage: e.toString()));
    }
  }
}
