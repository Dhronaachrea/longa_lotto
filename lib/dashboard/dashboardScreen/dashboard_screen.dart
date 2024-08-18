import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/bloc/date_bloc/date_selector_bloc.dart';
import 'package:longa_lotto/common/constant/api_constant.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/widget/drawer/drawer.dart';
import 'package:longa_lotto/common/widget/gradient_line.dart';
import 'package:longa_lotto/common/widget/longa_scaffold.dart';
import 'package:longa_lotto/dashboard/dashboardScreen/bloc/dashboard_bloc.dart';
import 'package:longa_lotto/dashboard/dashboardScreen/bloc/dashboard_event.dart';
import 'package:longa_lotto/dashboard/dashboardScreen/bloc/dashboard_state.dart';
import 'package:longa_lotto/dashboard/dashboardScreen/model/request/check_bonus_status_player_request.dart';
import 'package:longa_lotto/home/bloc/dge/dge_game_bloc.dart';
import 'package:longa_lotto/home/bloc/ige/ige_game_bloc.dart';
import 'package:longa_lotto/inbox/bloc/inbox_bloc.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/myTransaction/bloc/transaction_bloc.dart';
import 'package:longa_lotto/myTransaction/my_transaction_screen.dart';
import 'package:longa_lotto/profile/bloc/profile_bloc.dart';
import 'package:longa_lotto/profile/my_profile_screen.dart';
import 'package:longa_lotto/sign_up/bloc/sign_up_bloc.dart';
import 'package:longa_lotto/sign_up/bloc/sign_up_event.dart';
import 'package:longa_lotto/ticket/bloc/ticket_bloc.dart';
import 'package:longa_lotto/ticket/ticket_screen.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:longa_lotto/utils/utils.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../common/widget/bottom_navigation_bar.dart';
import '../../home/home_screen.dart';

class DashBoardScreen extends StatefulWidget {
  final bool? isFirstTimeLogin;
  const DashBoardScreen({Key? key, this.isFirstTimeLogin = false}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  var currentIndex = 0;

  @override
  void initState() {
    String deepLinkData = UserInfo.getDeeplinkData;
    print("home deep link data ===================>$deepLinkData");
    if (deepLinkData.isNotEmpty) {
      Map<String, dynamic> proceedData = jsonDecode(deepLinkData);
      BlocProvider.of<SignUpBloc>(context).add(
          RegistrationUsingScan(
              context: context,
              username: "${proceedData["t"]}",
              currencyCode: "CDF",
              countryCode: "CD"
          )
      );
      UserInfo.setDeepLinkData("");
    }
    if (UserInfo.isLoggedIn()) {
      if (widget.isFirstTimeLogin == true) {
        BlocProvider.of<DashBoardBloc>(context).add(
          CheckBonusStatusEvent(context: context, request:
              CheckBonusStatusPlayerRequest(
                  aliasName     : AppConstants.domainName,
                  playerToken   : UserInfo.userToken,
                  playerId      : int.parse(UserInfo.userId)
              )
          )
        );
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashBoardBloc, DashBoardState>(
      listener: (context, state) {

        if (state is CheckBonusStatusError) {
          print("Bonus-------------------->error");

        } else if ( state is CheckBonusStatusSuccess){
          print("Bonus-------------------->Success");
          var bonusDatas = state.response?.data;
          double totalBonus = 0;
          bonusDatas?.forEach((bonusData) {
            totalBonus += bonusData.bonusAmt ?? 0;
          });

          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext ctx) {
              return  WillPopScope(
                onWillPop: () async{
                  return false;
                },
                child: Dialog(
                  insetPadding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _gradientLine(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                              height: 90,
                              width: 90,
                              child: Image(
                                image: AssetImage("assets/images/party_popper.png"),
                                fit: BoxFit.cover,
                              )
                          ),
                          const HeightBox(20),

                          Text(
                              context.l10n.congratulations,
                              style: TextStyle(
                                  color: LongaColor.marigold,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                              )
                          ),
                          const HeightBox(10),
                          Text(
                            context.l10n.your_registration_is_complete,
                            style: TextStyle(
                              color: LongaColor.warm_grey_seven,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "${context.l10n.enjoy_with_a_welcome_bonus_of} ${UserInfo.currencyDisplayCode} ${removeDecimalValueAndFormat("${totalBonus}")}",
                            style: TextStyle(
                              color: LongaColor.black,
                              fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.center,
                          ),

                          Stack(
                            alignment: Alignment.center,
                            children: [
                              const SizedBox(
                                  width: 180,
                                  height: 100,
                                  child: Image(
                                    image: AssetImage("assets/images/bonus_sprinkal_bg.png"),
                                  )
                              ),
                              Text(
                                  "${UserInfo.currencyDisplayCode} $totalBonus",
                                  style: TextStyle(
                                      color: LongaColor.marigold,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                            ],
                          ),

                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: LongaColor.marigold,
                                  borderRadius: BorderRadius.circular(22)
                              ),
                              child: Text(
                                context.l10n.continues,
                                style: TextStyle(
                                    color: LongaColor.white,
                                    fontSize: 20,
                                    fontWeight:
                                    FontWeight.bold
                                ),
                              ).pOnly(left: 20, right: 20, top: 10, bottom: 10),
                            ),
                          )
                        ],
                      ).pSymmetric(v: 30, h: 30),
                    ],
                  ),
                ),
              );
            },
          );
        }

      },
      child: SafeArea(
        // child: Scaffold(
        child: LongaScaffold(
          showAppBar: true,
          extendBodyBehindAppBar: true,
          drawer: LongaDrawer(),
          bottomNavigationBar: LongaBottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (int index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
          body: selectedPage(currentIndex),
        ),
      ),
    );
  }

  selectedPage(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => DgeGameBloc()),
            BlocProvider(create: (_) => IgeGameBloc()),
            BlocProvider(create: (_) => InboxBloc()),
          ],
          child:const HomeScreen(),
        );

      case 1:
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => DateSelectorBloc()),
            BlocProvider(create: (_) => TransactionBloc()),
          ],
          child: const MyTransactionScreen(
            fromDashBoard: true,
          ),
        );
      case 2:
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => DateSelectorBloc()),
            BlocProvider(create: (_) => TicketBloc()),
          ],
          child: const TicketScreen(
            fromDashBoard: true,
          ),
        );
      case 3:
        {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => DateSelectorBloc()),
              BlocProvider(create: (_) => ProfileBloc()),
            ],
            child: const MyProfileScreen(
              fromDashBoard: true,
            )
          );

        }
    }
  }

  static _gradientLine() {
    return const GradientLine(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    );
  }
}
