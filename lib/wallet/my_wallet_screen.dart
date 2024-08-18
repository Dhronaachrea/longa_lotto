import 'package:flutter/material.dart';
import 'package:longa_lotto/common/widget/longa_scaffold.dart';
import 'package:longa_lotto/common/widget/rounded_container.dart';

import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:longa_lotto/wallet/deposit/deposit_screen.dart';
import 'package:longa_lotto/wallet/wallet_widget.dart';
import 'package:longa_lotto/wallet/withdrawal/withdrawal_screen.dart';

class MyWalletScreen extends StatefulWidget {
  const MyWalletScreen({Key? key}) : super(key: key);

  @override
  _MyWalletScreenState createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen> with TickerProviderStateMixin {
  bool absorber = false;
  ScrollController mainScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: LongaScaffold(
          showAppBar: true,
          appBarTitle: context.l10n.myWallet.toUpperCase(),
          extendBodyBehindAppBar: true,
          body: AbsorbPointer(
            absorbing: absorber,
            child: Stack(
              children: [
                Container(
                  height: size.height * 0.3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        "assets/images/app_bg.webp",
                      ),
                    ),
                  ),
                ),
                RoundedContainer(
                    child: SingleChildScrollView(
                      controller: mainScrollController,
                          child: WalletTabBar(
                            tabBarTitles: [
                              if(!UserInfo.getAliasNameScan.contains("scan")) Tab(text: context.l10n.deposit),
                              Tab(text: context.l10n.withdrawal),
                            ],
                            tabBarViews:  [
                              if(!UserInfo.getAliasNameScan.contains("scan"))
                                DepositScreen(
                                  mCallback: (isDisable) {
                                    setState(() {
                                      absorber = isDisable;
                                    });
                                  },
                                  scrollInitCallBack: () {
                                    setState(() {
                                      print("scroll call back");
                                      mainScrollController.animateTo(
                                        0.0,
                                        duration: Duration(milliseconds: 500),  // Duration of the animation
                                        curve: Curves.easeInOut,  // Animation curve
                                      );
                                    });
                                  }
                                ),
                              WithdrawalScreen(
                                mCallback: (isDisable) {
                                setState(() {
                                  absorber = isDisable;
                                });
                              },
                                scrollInitCallBack: () {
                                  setState(() {
                                    print("scroll call back");
                                    mainScrollController.animateTo(
                                      0.0,
                                      duration: Duration(milliseconds: 500),  // Duration of the animation
                                      curve: Curves.easeInOut,  // Animation curve
                                    );
                                  });
                                }
                              ),
                            ],

                      ),
                    )
                )
              ],
            ),
          )),
    );
  }
}
