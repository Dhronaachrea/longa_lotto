import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/bloc/date_bloc/date_selector_bloc.dart';
import 'package:longa_lotto/common/constant/api_constant.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/show_snackbar.dart';
import 'package:longa_lotto/common/widget/card_separator.dart';
import 'package:longa_lotto/common/widget/date_selector.dart';
import 'package:longa_lotto/common/widget/longa_scaffold.dart';
import 'package:longa_lotto/common/widget/rounded_container.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/myTransaction/bloc/transaction_bloc.dart';
import 'package:longa_lotto/myTransaction/bloc/transaction_event.dart';
import 'package:longa_lotto/myTransaction/bloc/transaction_state.dart';
import 'package:longa_lotto/myTransaction/model/response/transaction_response.dart';
import 'package:longa_lotto/myTransaction/widget/transaction_card.dart';
import 'package:longa_lotto/utility/NetworkSingleton.dart';
import 'package:longa_lotto/utility/network_connection/network_bloc.dart';
import 'package:longa_lotto/utility/network_connection/network_state.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

import '../common/constant/longa_constant.dart';
import '../utils/user_info.dart';
import '../utils/utils.dart';

class MyTransactionScreen extends StatefulWidget {
  final bool fromDashBoard;

  const MyTransactionScreen({Key? key, this.fromDashBoard = false})
      : super(key: key);

  @override
  State<MyTransactionScreen> createState() => _MyTransactionScreenState();
}

class _MyTransactionScreenState extends State<MyTransactionScreen> with SingleTickerProviderStateMixin {
  late Map<String, String> transactionTypeListTagMap;
  late var mFromDate;
  late var mToDate;

  var mOpeningBalance = "0";
  var mClosingBalance = "0";
  var mTxnTotalAmount = "0.0";

  List<TxnList>? transactionList = [];
  List<TxnList> transactionDummyList = [];
  var transactionScrollController = ScrollController();
  bool hasMoreTransactions = true;
  bool isLoadingForTransactions = true;
  bool isSelectableAllowed = false;
  bool isMoreTransactionsAvailable = false;
  bool afterNetGone = false;
  var offset = 0;
  late TabController _tabController;
  late int tabLength;
  late String selectedTab;

  @override
  void initState() {
    super.initState();
    transactionTypeListTagMap = {};
    tabLength = 8;
    _tabController = new TabController(vsync: this, length: tabLength);
    transactionScrollController.addListener(transactionPagination);
    transactionTypeListTagMap["ledger"]             = "ALL";
    transactionTypeListTagMap["wager"]              = "PLR_WAGER";
    transactionTypeListTagMap["deposit"]            = "PLR_DEPOSIT";
    transactionTypeListTagMap["withdrawal"]         = "PLR_WITHDRAWAL";
    transactionTypeListTagMap["winning"]            = "PLR_WINNING";
    transactionTypeListTagMap["bonus"]              = "PLR_BONUS_TRANSFER";
    transactionTypeListTagMap["wagerRefund"]        = "PLR_WAGER_REFUND";
    transactionTypeListTagMap["withdrawalCancel"]   = "PLR_DEPOSIT_AGAINST_CANCEL";
    mFromDate = context.read<DateSelectorBloc>().fromDate;
    mToDate   = context.read<DateSelectorBloc>().toDate;
    print("mFromDate -> $mFromDate");
    print("mToDate -> $mToDate");
    selectedTab = transactionTypeListTagMap["ledger"] ?? "NA";
    NetworkSingleton().setNetworkListener(context);
    BlocProvider.of<TransactionBloc>(context).add(GetTransaction(context: context, offset: 0, txnType: transactionTypeListTagMap["ledger"] ?? "NA", fromDate: mFromDate, toDate: mToDate));

  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    var body = BlocListener<NetworkBloc, NetworkState>(
      listener: (context, state) {
        if(state is NetWorkConnected) {
          setState(() {
            isSelectableAllowed = false;
            if (afterNetGone) {
              afterNetGone = false;
              ShowToast.showToast(context, context.l10n.internet_available, type: ToastType.SUCCESS);
              BlocProvider.of<TransactionBloc>(context).add(GetTransaction(context: context, offset: 0, txnType: selectedTab, fromDate: mFromDate, toDate: mToDate));
            }
          });
        } else if(state is NetWorkNotConnected) {
          setState(() {
            afterNetGone = true;
          });
        }
      },
      child: RoundedContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //tab bar container
            AbsorbPointer(
              absorbing: isSelectableAllowed,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: DefaultTabController(
                    length: tabLength,
                    initialIndex: 0,
                    child: TabBar(
                      controller: _tabController,
                      labelPadding: EdgeInsets.symmetric(horizontal: 25),
                      // Space between tabs
                      isScrollable: true,
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(
                            width: 5.0, color: LongaColor.darkish_purple),
                      ),
                      unselectedLabelColor: LongaColor.darkish_purple,
                      indicatorColor: LongaColor.darkish_purple,
                      tabs: [
                        Tab(
                          child: Text(
                            context.l10n.ledger,
                            style: TextStyle(
                                color: Color(
                                  0xff9e1f63,
                                ),
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                        Tab(
                          child: Text(
                            context.l10n.winning,
                            style: TextStyle(
                                color: Color(
                                  0xff9e1f63,
                                ),
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                        Tab(
                          child: Text(
                            context.l10n.bonus,
                            style: TextStyle(
                                color: Color(
                                  0xff9e1f63,
                                ),
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                        Tab(
                          child: Text(
                            context.l10n.wager,
                            style: TextStyle(
                                color: Color(
                                  0xff9e1f63,
                                ),
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                        Tab(
                          child: Text(
                            context.l10n.deposit,
                            style: TextStyle(
                                color: Color(
                                  0xff9e1f63,
                                ),
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                        Tab(
                          child: Text(
                            context.l10n.withdrawal,
                            style: TextStyle(
                                color: Color(
                                  0xff9e1f63,
                                ),
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                        Tab(
                          child: Text(
                            context.l10n.wagerRefund,
                            style: TextStyle(
                                color: Color(
                                  0xff9e1f63,
                                ),
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                        Tab(
                          child: Text(
                            context.l10n.withdrawalCancel,
                            style: TextStyle(
                                color: Color(
                                  0xff9e1f63,
                                ),
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                      ],
                      onTap: (int param) {
                        mTxnTotalAmount = "0.0";
                        switch (param) {
                          case 0:
                            {
                              resetTransactionRelatedValues();
                              setState(() {
                                selectedTab =
                                    transactionTypeListTagMap["ledger"] ?? "NA";
                              });
                              BlocProvider.of<TransactionBloc>(context).add(
                                  GetTransaction(
                                      context: context,
                                      offset: 0,
                                      txnType:
                                          transactionTypeListTagMap["ledger"] ??
                                              "NA",
                                      fromDate: mFromDate,
                                      toDate: mToDate));
                              break;
                            }
                          case 1:
                            {

                              resetTransactionRelatedValues();
                              setState(() {
                                selectedTab =
                                    transactionTypeListTagMap["winning"] ?? "NA";
                              });
                              BlocProvider.of<TransactionBloc>(context).add(
                                  GetTransaction(
                                      context: context,
                                      offset: 0,
                                      txnType:
                                      transactionTypeListTagMap["winning"] ??
                                          "NA",
                                      fromDate: mFromDate,
                                      toDate: mToDate));
                              break;
                            }
                          case 2:
                            {

                              resetTransactionRelatedValues();
                              setState(() {
                                selectedTab = transactionTypeListTagMap["bonus"] ?? "NA";
                              });
                              BlocProvider.of<TransactionBloc>(context).add(GetTransaction(context: context, offset: 0, txnType: transactionTypeListTagMap["bonus"] ?? "NA", fromDate: mFromDate, toDate: mToDate));
                              break;
                            }
                          case 3:
                            {
                              resetTransactionRelatedValues();
                            setState(() {
                              selectedTab =
                                  transactionTypeListTagMap["wager"] ?? "NA";
                            });
                            BlocProvider.of<TransactionBloc>(context).add(
                                GetTransaction(
                                    context: context,
                                    offset: 0,
                                    txnType:
                                    transactionTypeListTagMap["wager"] ??
                                        "NA",
                                    fromDate: mFromDate,
                                    toDate: mToDate));

                              break;
                            }
                          case 4:
                            {

                              resetTransactionRelatedValues();
                              setState(() {
                                selectedTab =
                                    transactionTypeListTagMap["deposit"] ?? "NA";
                              });
                              BlocProvider.of<TransactionBloc>(context).add(
                                  GetTransaction(
                                      context: context,
                                      offset: 0,
                                      txnType:
                                      transactionTypeListTagMap["deposit"] ??
                                          "NA",
                                      fromDate: mFromDate,
                                      toDate: mToDate));

                              break;
                            }
                          case 5: {

                            resetTransactionRelatedValues();
                            setState(() {
                              selectedTab =
                                  transactionTypeListTagMap["withdrawal"] ??
                                      "NA";
                            });
                            BlocProvider.of<TransactionBloc>(context).add(
                                GetTransaction(
                                    context: context,
                                    offset: 0,
                                    txnType: transactionTypeListTagMap[
                                    "withdrawal"] ??
                                        "NA",
                                    fromDate: mFromDate,
                                    toDate: mToDate));


                            break;
                          }
                          case 6: {

                            resetTransactionRelatedValues();
                            setState(() {
                              selectedTab = transactionTypeListTagMap["wagerRefund"] ?? "NA";
                            });
                            BlocProvider.of<TransactionBloc>(context).add(GetTransaction(context: context, offset: 0, txnType: transactionTypeListTagMap["wagerRefund"] ?? "NA", fromDate: mFromDate, toDate: mToDate));

                            break;
                          }
                          case 7: {


                            resetTransactionRelatedValues();
                            setState(() {
                              selectedTab = transactionTypeListTagMap["withdrawalCancel"] ?? "NA";
                            });
                            BlocProvider.of<TransactionBloc>(context).add(GetTransaction(context: context, offset: 0, txnType: transactionTypeListTagMap["withdrawalCancel"] ?? "NA", fromDate: mFromDate, toDate: mToDate));
                            break;
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            //line below tab bar
            Container(
              width: size.width,
              height: 1,
              color: LongaColor.black_four,
            ),
            //Date selector
            AbsorbPointer(
              absorbing: isSelectableAllowed,
              child: DateSelector(
                selectedDate: (fromDate, toDate) {
                  mFromDate = fromDate;
                  mToDate = toDate;
                  resetTransactionRelatedValues();
                  context.read<TransactionBloc>().add(GetTransaction(
                      context: context,
                      offset: 0,
                      txnType: selectedTab,
                      fromDate: mFromDate,
                      toDate: mToDate));
                },
              ),
            ),

            //Gradient balance container
            getWhichTrxType(context,selectedTab) == "ALL"
                ? Container(
                    height: 75,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LongaConstant.LongaGradientColor,
                      // LinearGradient(
                      //     colors: [
                      //       Colors.orange,
                      //       Colors.orange,
                      //       Colors.orange,
                      //       Colors.red
                      //       //add more colors for gradient
                      //     ],
                      //     begin: Alignment.topLeft, //begin of the gradient color
                      //     end: Alignment.bottomRight, //end of the gradient color
                      //     stops: [0, 0.2, 0.5, 0.8] //stops for individual color
                      //     //set the stops number equal to numbers of color
                      //     ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.opening_balance,
                                style: TextStyle(
                                    color: LongaColor.black_four, fontSize: 18),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  UserInfo.currencyDisplayCode +
                                      " " +
                                      removeDecimalValueAndFormat(mOpeningBalance),
                                  style: TextStyle(
                                      color: LongaColor.black_four,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                context.l10n.closing_balance,
                                style: TextStyle(
                                    color: LongaColor.black_four, fontSize: 18),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  UserInfo.currencyDisplayCode +
                                      " " +
                                      removeDecimalValueAndFormat(mClosingBalance),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: LongaColor.black_four,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ))
                : mTxnTotalAmount != "0.0"
                    ? Container(
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 10),
                        child: Text(
                          context.l10n.total_amount_msg(getWhichTrxType(context,selectedTab))
                              + "\n${UserInfo.currencyDisplayCode} " +
                              removeDecimalValueAndFormat(mTxnTotalAmount),
                          style: const TextStyle(
                            color: LongaColor.black_four,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Container(),

            //List view
            Expanded(
              child: BlocListener<TransactionBloc, TransactionState>(
                  listener: (context, state) {
                    print("state============> $state  <=============");
                    if (state is TransactionSuccess) {
                      print("============> success  <=============");
                      transactionList = [];
                      List<TxnList> dgeTransactionTempList = [];
                      transactionList =
                          state.response?.txnList?.isNotEmpty == true
                              ? state.response?.txnList
                              : [];
                      dgeTransactionTempList = transactionList ?? [];
                      log("dgeTransactionTempList length -> ${dgeTransactionTempList.length}");
                      setState(() {
                        isLoadingForTransactions = false;
                        isSelectableAllowed = false;
                      });
                      transactionDummyList.addAll(dgeTransactionTempList);
                      hasMoreTransactions = transactionList?.isEmpty == true ? false : true;

                      if (mOpeningBalance == "0") {
                        mOpeningBalance =
                            transactionList![0].openingBalance.toString();
                      }
                      if (mClosingBalance == "0") {
                        mClosingBalance = transactionList![0].balance.toString();
                      }

                      if (state.response!.txnList!
                          .isNotEmpty && state.response!.txnTotalAmount != null) {
                        mTxnTotalAmount =
                            state.response?.txnTotalAmount?.toString() ?? "0.0";

                      }
                      if (dgeTransactionTempList.isNotEmpty) {
                        log("-"*100);

                        if (dgeTransactionTempList.length < 20) {
                          setState(() {
                            isMoreTransactionsAvailable = false;
                          });
                        } else {
                          setState(() {
                            isMoreTransactionsAvailable = true;
                          });
                        }
                      } else {
                        setState(() {
                          isMoreTransactionsAvailable = false;
                        });
                      }
                      log("isMoreTransactionsAvailable on success: $isMoreTransactionsAvailable");

                    }
                    else if(state is TransactionLoading) {
                      setState(() {
                        isSelectableAllowed = true;
                      });

                    }
                    else if (state is TransactionError) {
                      setState(() {
                        isLoadingForTransactions = false;
                        isSelectableAllowed = false;
                      });
                      ShowToast.showToast(context, state.errorMessage);
                      /*if (state.errorMessage == AppConstants.sessionExpiryCode) {
                            showSnackMsg(context, state.errorMsg ?? "", Colors.red,
                                isDarkThemeOn: isDarkThemeOn);
                          } else {
                            *//*Alert.show(
                              title: context.l10n.myTransactionError,
                              subtitle: state.errorMsg ?? "Ticket Error",
                              buttonText: context.l10n.ok.toUpperCase(),
                              context: context,
                              isDarkThemeOn: isDarkThemeOn,
                            );*//*
                          }*/
                    }
                    log("isMoreTransactionsAvailable: $isMoreTransactionsAvailable");
                  },
                  child: transactionDummyList.isNotEmpty
                      ? SingleChildScrollView(
                    controller: transactionScrollController,
                    child: Column(
                      children: [
                        ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: transactionDummyList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return TransactionCard(size, txnDetails: transactionDummyList[index]);
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              CardSeparator(),
                        ),
                        isMoreTransactionsAvailable
                            ? CircularProgressIndicator(color: LongaColor.marigold).p(8)
                            : Container()
                      ],
                    ),
                  )
                      : isLoadingForTransactions
                      ? Center(child: CircularProgressIndicator(color: LongaColor.marigold))
                      : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: context.screenHeight / 4,
                          child: Lottie.asset('assets/lottie/no_data.json'),
                        ),
                        Text(
                            "${context.l10n.noTransactionAvailableMsg} \n ${context.l10n.pleaseCheckForAnotherDates}",
                            style: const TextStyle(color: LongaColor.tangerine, fontSize: 16,), textAlign: TextAlign.center),
                      ],
                    ),
                  )
              ),
            ),
          ],
        ),
      ),
    );

    return widget.fromDashBoard
        ? body
        : LongaScaffold(
      showAppBar: true,
      appBarTitle: context.l10n.myTransactions.toUpperCase(),
      extendBodyBehindAppBar: true,
      body: body,
    );
  }

  void transactionPagination() {
    if (transactionScrollController.position.pixels == transactionScrollController.position.maxScrollExtent) {
      print("at last");
      if (hasMoreTransactions) {
        setState(() {
          offset += int.parse(AppConstants.transactionLimit) + 1;
        });

        context.read<TransactionBloc>().add(GetTransaction(context: context, offset: offset, txnType: selectedTab, fromDate: mFromDate, toDate: mToDate));
      }
    }
  }

  void resetTransactionRelatedValues() {
    setState(() {
      transactionDummyList        = [];
      offset                      = 0;
      isLoadingForTransactions    = true;
      isMoreTransactionsAvailable = false;
    });
  }
}
