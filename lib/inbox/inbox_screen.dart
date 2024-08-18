
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:longa_lotto/common/constant/date_format.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/constant/longa_constant.dart';
import 'package:longa_lotto/common/show_snackbar.dart';
import 'package:longa_lotto/common/utils.dart';
import 'package:longa_lotto/common/widget/longa_scaffold.dart';
import 'package:longa_lotto/common/widget/rounded_container.dart';
import 'package:longa_lotto/inbox/model/response/inbox_response.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/utility/NetworkSingleton.dart';
import 'package:longa_lotto/utility/network_connection/network_bloc.dart';
import 'package:longa_lotto/utility/network_connection/network_state.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

import '../common/widget/alert/alert_dialog.dart';
import 'bloc/inbox_bloc.dart';
import 'inbox_widget/inbox_widget.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({Key? key}) : super(key: key);

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  List<PlrInboxList> inboxList = [];
  List<PlrInboxList> inboxDummyList = [];
  List<PlrInboxList> inboxMainList = [];

  var inboxScrollController = ScrollController();
  bool hasMoreInbox = true;
  bool isLoadingForInbox = true;
  bool isMoreInboxAvailable = false;
  bool hasMoreMsg = true;
  var offset = 0;
  bool isBackPressedAllowed = true;
  bool isMoreInboxDataAvailable = false;
  bool isSearchItem = false;
  late String query;
  bool afterNetGone = false;
  final ExpansionTileController expandedController = ExpansionTileController();

  @override
  void initState() {
    context.read<InboxBloc>().add(GetInbox(offset: offset, context: context));
    NetworkSingleton().setNetworkListener(context);
    inboxScrollController.addListener(
      inboxPagination,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<NetworkBloc, NetworkState>(
      listener: (context, state) {
        if(state is NetWorkConnected) {
          setState(() {
            if (afterNetGone) {
              afterNetGone = false;
              ShowToast.showToast(context, context.l10n.internet_available, type: ToastType.SUCCESS);
              context.read<InboxBloc>().add(GetInbox(offset: offset, context: context));
            }
          });
        } else if(state is NetWorkNotConnected) {
          setState(() {
            afterNetGone = true;
          });
        }
      },
      child: LongaScaffold(
          extendBodyBehindAppBar: true,
          showAppBar: true,
          appBarTitle: context.l10n.inbox.toString().toUpperCase(),
          body: RoundedContainer(
            child: BlocListener<InboxBloc, InboxState>(
                listener: (context, state) {
                  if (state is InboxDeleteLoaded) {
                    ShowToast.showToast(context, context.l10n.deletedSuccessfully,
                        type: ToastType.SUCCESS);
                  }
                  if (state is InboxError) {
                    Alert.show(
                      isDarkThemeOn: false,
                      buttonClick: () {
                        setState(() {
                          isLoadingForInbox = false;
                        });
                      },
                      title: context.l10n.inbox,
                      subtitle: state.errorMsg ?? "Inbox Error",
                      buttonText: context.l10n.ok.toUpperCase(),
                      context: context,
                    );
                    // }
                  }
                  if (state is InboxLoading) {
                    setState(() {
                      isLoadingForInbox = true;
                    });
                  } else if (state is InboxSearchLoaded) {
                    inboxDummyList = [];
                    setState(() {
                      if (state.inboxResponseList!.isNotEmpty) {
                        isSearchItem = true;
                        inboxDummyList.addAll(state.inboxResponseList!);
                      } else {
                        isSearchItem = false;
                        if (query.isEmpty) {
                          inboxDummyList.addAll(inboxMainList);
                        } else {
                          inboxDummyList.clear();
                        }
                      }
                    });
                    if (isSearchItem) {
                      setState(() {
                        isMoreInboxDataAvailable = false;
                      });
                    } else {
                      setState(() {
                        isMoreInboxDataAvailable = true;
                      });
                    }
                  } else if (state is InboxLoaded) {
                    setState(() {
                      state.inboxResponseList!.length;
                    });
                    List<PlrInboxList> inboxTempList = [];

                    setState(() {
                      isLoadingForInbox = false;
                    });
                    inboxList = state.inboxResponseList ?? [];
                    inboxTempList = inboxList;
                    inboxDummyList.addAll(inboxTempList);
                    inboxMainList = inboxDummyList;
                    hasMoreInbox = inboxList.isEmpty ? false : true;
                    setState(() {
                      isLoadingForInbox = false;
                    });

                    if (inboxTempList.isNotEmpty) {
                      if (inboxTempList.length < 20) {
                        setState(() {
                          isMoreInboxDataAvailable = false;
                        });
                      } else {
                        setState(() {
                          isMoreInboxDataAvailable = true;
                        });
                      }
                    } else {
                      setState(() {
                        isMoreInboxDataAvailable = false;
                      });
                    }
                  }
                },
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    inboxDummyList.isNotEmpty
                        ? SingleChildScrollView(
                            controller: inboxScrollController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimationLimiter(
                                  child: ListView.separated(
                                    padding: EdgeInsets.only(top: 10),
                                    shrinkWrap: true,
                                    itemCount: inboxDummyList.length,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return AnimationConfiguration.staggeredList(
                                        position: index,
                                        duration:
                                            const Duration(milliseconds: 400),
                                        child: SlideAnimation(
                                          verticalOffset: 100,
                                          child: FadeInAnimation(
                                              child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(width: 1, color: LongaColor.warm_grey.withOpacity(0.7))
                                              ),
                                              child: Dismissible(
                                                key: Key("${inboxDummyList[index]}"),
                                                direction: DismissDirection.endToStart,
                                                background: Container(
                                                  color: LongaColor.tomato,
                                                  padding: EdgeInsets.only(right: 20.0),
                                                  alignment: AlignmentDirectional.centerEnd,
                                                  child: Icon(Icons.delete_forever, color: Colors.white,),
                                                ),
                                                confirmDismiss: (DismissDirectiondirection) async {
                                                  // var confirmDismiss =
                                                  //     await _confirmDismiss(isDarkThemeOn);
                                                  var confirmDismiss =
                                                  await ConfirmationSheet.show(
                                                      inboxList:
                                                      inboxDummyList[index],
                                                      context: context,
                                                      onConfirm: () {
                                                        context
                                                            .read<InboxBloc>()
                                                            .add(InboxActivity(
                                                            context: context,
                                                            activity:
                                                            "DELETE",
                                                            inboxId:
                                                            inboxDummyList[
                                                            index]
                                                                .inboxId
                                                                .toString()));

                                                        inboxList.clear();
                                                        inboxDummyList.clear();
                                                        inboxMainList.clear();

                                                        Navigator.of(context)
                                                            .pop(true);
                                                      },
                                                      onCancel: () {
                                                        Navigator.of(context)
                                                            .pop(false);
                                                      });
                                                  return confirmDismiss;
                                                },
                                                /*onDismissed: (DismissDirection direction){
                                                  context
                                                      .read<
                                                      InboxBloc>()
                                                      .add(
                                                    InboxActivity(
                                                        context:
                                                        context,
                                                        activity:
                                                        "DELETE",
                                                        inboxId: inboxDummyList[
                                                        index]
                                                            .inboxId
                                                            .toString()),
                                                  );
                                                },*/
                                                child: ExpansionTile(
                                                      title:Text(
                                                        inboxDummyList[index]
                                                            .subject ??
                                                            "",
                                                        //"WINNING HIGH",
                                                        style: TextStyle(
                                                            color: inboxDummyList[index]!.status!.toLowerCase().contains("unread") ? LongaColor.black : LongaColor.black_four ,
                                                            fontWeight: inboxDummyList[index]!.status!.toLowerCase().contains("unread") ? FontWeight.w700 : FontWeight.w300,
                                                            fontFamily: "Roboto",
                                                            fontStyle:
                                                            FontStyle.normal,
                                                            fontSize: 16.0),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                      subtitle: Text(
                                                        inboxDummyList[index]
                                                            .mailSentDate ??
                                                            "",
                                                        //"WINNING HIGH",
                                                        style: TextStyle(
                                                            color: inboxDummyList[index]!.status!.toLowerCase().contains("unread") ? LongaColor.black : LongaColor.black_four ,
                                                            fontWeight: inboxDummyList[index]!.status!.toLowerCase().contains("unread") ? FontWeight.w700 : FontWeight.w500,
                                                            fontFamily: "Roboto",
                                                            fontStyle:
                                                            FontStyle.normal,
                                                            fontSize: 13.0),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                      onExpansionChanged: (bool isExpanded) {
                                                        if (isExpanded && inboxDummyList[index].status != "READ") {
                                                          setState(() {
                                                            inboxDummyList[index].status = "READ";
                                                            context.read<InboxBloc>().add(
                                                              InboxActivityMarkRead(
                                                                  context: context,
                                                                  activity: "READ",
                                                                  inboxId: inboxDummyList[index].inboxId.toString()
                                                              ),
                                                            );
                                                          });
                                                        }
                                                        print("is expanded  =================> $isExpanded");
                                                      },
                                                      children: [
                                                          Text(
                                                            inboxDummyList[index]
                                                                .contentId ??
                                                                "",
                                                            style: TextStyle(
                                                                color: LongaColor.black_four,
                                                                fontWeight: inboxDummyList[index]!.status!.toLowerCase().contains("unread") ? FontWeight.w500 : FontWeight.w400,
                                                                fontFamily: "Roboto",
                                                                fontStyle: FontStyle.normal,
                                                                fontSize: 16.0),
                                                          ).p(10)
                                                        ]
                                                    ).pOnly(left: 10, right: 10),
                                              )
                                              ).pOnly(left: 20, right: 20)
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            HeightBox(10),
                                  ),
                                ).pOnly(bottom: 60),
                                isMoreInboxDataAvailable
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 80),
                                        child: SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: Lottie.asset(
                                                'assets/lottie/gradient_loading.json')))
                                    : Container(),
                              ],
                            ),
                          )
                        : isLoadingForInbox
                            ? SizedBox(
                                width: 60,
                                height: 60,
                                child: Lottie.asset(
                                    'assets/lottie/gradient_loading.json'))
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: context.screenHeight / 4,
                                    child: Lottie.asset(
                                        'assets/lottie/no_data.json'),
                                  ),
                                  Text(
                                      context.l10n.no_search_found_please_try_with_another_inputs,
                                      style: TextStyle(
                                        color: LongaColor.darkish_purple,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center),
                                ],
                              ).pOnly(bottom: 120),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        height: 60.0,
                        color: LongaColor.white,
                        child: CupertinoSearchTextField(
                          itemSize: 30,
                          onChanged: (String input) {
                            query = input.trim();
                            context.read<InboxBloc>().add(
                                  InboxSearch(
                                      context: context,
                                      query: query,
                                      inboxList: inboxDummyList),
                                );
                          },
                        ).pSymmetric(h: 15, v: 10),
                      ),
                    )
                  ],
                )),
          )),
    );
  }

  String _dateTimeDiff(String mailSentDate) {
    var now = DateTime.now();

    DateFormat inputFormat = DateFormat('dd/MM/yyyy hh:mm:ss');
    DateTime input = inputFormat.parse(mailSentDate);

    var difference = now.difference(input);

    var days = difference.inDays;
    var hours = difference.inHours;
    var minutes = difference.inMinutes;
    var seconds = difference.inSeconds;
    if (days > 1) {
      if (days > 7) {
        String date = formatDate(
          date: mailSentDate,
          inputFormat: Format.apiDateFormat,
          outputFormat: Format.inboxFormat,
        );
        return date;
      }
      return "$days days ago";
    } else if (days == 1) {
      return context.l10n.yesterday;
    } else if (hours > 0) {
      return "$hours hours ago";
    } else if (minutes > 0) {
      return "$minutes minutes ago";
    } else {
      return "$seconds seconds ago";
    }
  }


  void inboxPagination() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    if (inboxScrollController.position.pixels ==
        inboxScrollController.position.maxScrollExtent) {
      if (hasMoreInbox) {
        setState(() {
          offset += int.parse(LongaConstant.inboxLimit);
        });
        context
            .read<InboxBloc>()
            .add(GetInbox(offset: offset, context: context));
      } else {
        setState(() {
          isMoreInboxDataAvailable = false;
        });
      }
    }
  }
}
