import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/constant/date_format.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/navigation/longa_screen.dart';
import 'package:longa_lotto/common/show_snackbar.dart';
import 'package:longa_lotto/common/utils.dart';
import 'package:longa_lotto/common/widget/card_separator.dart';
import 'package:longa_lotto/common/widget/date_selector.dart';
import 'package:longa_lotto/common/widget/longa_scaffold.dart';
import 'package:longa_lotto/common/widget/rounded_container.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/ticket/ticket_widget/ticket_widget.dart';
import 'package:longa_lotto/utility/NetworkSingleton.dart';
import 'package:longa_lotto/utility/network_connection/network_bloc.dart';
import 'package:longa_lotto/utility/network_connection/network_state.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

import '../utils/loading_indicator.dart';
import 'bloc/ticket_bloc.dart';
import 'model/response/tIcket_response.dart';

class TicketScreen extends StatefulWidget {
  final bool fromDashBoard;

  const TicketScreen({Key? key, this.fromDashBoard = false}) : super(key: key);

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  List<TicketList>? ticketList = [];
  final ScrollController _scrollController = ScrollController();
  bool afterNetGone = false;
  var offset = 0;
  var limit = 10;
  bool hasMoreData = true;
  bool isLoading = false;
  String fromDate = formatDate(
    date: DateTime.now().subtract(const Duration(days: 30)).toString(),
    inputFormat: Format.apiDateFormat2,
    outputFormat: Format.rangeDateFormat,
    notTranslate: true
  );

  String toDate = formatDate(
    date: DateTime.now().toString(),
    inputFormat: Format.apiDateFormat2,
    outputFormat: Format.rangeDateFormat,
    notTranslate: true
  );

  @override
  void initState() {
    initTicket();
    NetworkSingleton().setNetworkListener(context);

    _scrollController.addListener(() {
// nextPageTrigger will have a value equivalent to 80% of the list size.
      var nextPageTrigger = 0.8 * _scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current postion of the user on the screen has surpassed
      if (_scrollController.position.pixels > nextPageTrigger) {
        if (ticketList!.length >= offset + limit) {
          offset = offset + limit;

          context.read<TicketBloc>().add(GetTicket(
            context: context,
            offset: offset,
            limit: limit,
            fromDate: fromDate,
            toDate: toDate,
            isPagination: true
          ));
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    var body = RoundedContainer(
      child: Column(
        children: [
          DateSelector(
            selectedDate: (fromDate, toDate) {
              log("ticket from date : $fromDate");
              log("ticket to date : $toDate");
              this.fromDate = formatDate(
                date: fromDate,
                inputFormat: Format.calendarFormat,
                outputFormat: Format.rangeDateFormat,
                notTranslate: true
              );
              this.toDate = formatDate(
                date: toDate,
                inputFormat: Format.calendarFormat,
                outputFormat: Format.rangeDateFormat,
                notTranslate: true
              );
              ticketList?.clear();
              offset = 0;
              initTicket();
            },
          ).pSymmetric(h: 20),
          Container(
            width: size.width,
            height: 1,
            color: LongaColor.black_four,
          ),
          BlocListener<TicketBloc, TicketState>(
              listener: (context, state) {
                  if (state is TicketLoaded) {
                    setState(() {
                      if (state.ticketList!.length < limit) {
                        hasMoreData = false;
                      } else {
                        hasMoreData = true;
                      }

                      print(" list length  ==========. ${ticketList?.length}");
                      if (ticketList!.isEmpty) {
                        ticketList = state.ticketList;
                      } else {
                        print("before add ------> ${ticketList?.length}");
                        ticketList!.addAll(state.ticketList!);
                        print("after add ------> ${ticketList?.length}");
                      }
                      isLoading = false;
                    });
                  }
                  else if (state is TicketLoadingError) {
                    setState(() {
                      ticketList?.clear();
                      isLoading = false;
                      ShowToast.showToast(context, state.errorMessage, type: ToastType.ERROR);
                    });
                  }
                  else if (state is TicketLoading) {
                    setState(() {
                      isLoading = true;
                    });
                  }

                },
            child: isLoading
                ? Expanded(
                    child: Center(
                      child: LoadingIndicator(),
                    ),
                  )
                : ticketList!.length > 0
                    ? Expanded(
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: EdgeInsets.all(0),
                    itemCount: ticketList!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          InkWell(
                              onTap: () {
                                if (ticketList![index]
                                    .serviceCode
                                    .toString()
                                    .toLowerCase() !=
                                    "ige") {
                                  Navigator.pushNamed(context,
                                      LongaScreen.ticketWebViewScreen,
                                      arguments: {
                                        "transactionId": ticketList![index]
                                            .transactionId
                                            .toString(),
                                        "gameType": ticketList![index]
                                            .serviceCode
                                            .toString()
                                            .toLowerCase(),
                                        "gameName":
                                        ticketList![index].gameName,
                                        "refTxnNo":
                                        ticketList![index].refTxnNo
                                      });
                                }
                              },
                              child: TicketCard(
                                  index: index, tickets: ticketList!)),
                          index == ticketList!.length - 1 && hasMoreData
                              ? LoadingIndicator()
                              : SizedBox(
                            height: 10,
                          )
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        CardSeparator(),
                  ),
                )
                    : SizedBox(
                  height: context.screenHeight / 3,
                  child: Lottie.asset('assets/lottie/no_data.json',
                      repeat: false),
                ),

          ),
        ],
      ),
    );

    return BlocListener<NetworkBloc, NetworkState>(
      listener: (context, state) {
        if(state is NetWorkConnected) {
          setState(() {
            if (afterNetGone) {
              afterNetGone = false;
              ShowToast.showToast(context, context.l10n.internet_available, type: ToastType.SUCCESS);
              initTicket();
            }
          });
        } else if(state is NetWorkNotConnected) {
          setState(() {
            afterNetGone = true;
          });
        }
      },
      child: widget.fromDashBoard
          ? body
          : LongaScaffold(
              showAppBar: true,
              appBarTitle: context.l10n.myTickets.toUpperCase(),
              extendBodyBehindAppBar: true,
              body: body,
            ),
    );
  }

  void initTicket() {
    context.read<TicketBloc>().add(GetTicket(
          context: context,
          offset: offset,
          limit: limit,
          fromDate: fromDate,
          toDate: toDate,
        ));
  }
}
