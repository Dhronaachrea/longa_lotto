import 'package:flutter/material.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';

class WalletTabBar extends StatefulWidget {
  final List<Tab> tabBarTitles;
  final List<Widget> tabBarViews;

  const WalletTabBar({
    Key? key,
    required this.tabBarTitles,
    required this.tabBarViews,
  }) : super(key: key);

  @override
  State<WalletTabBar> createState() => _WalletTabBarState();
}

class _WalletTabBarState extends State<WalletTabBar>
    with TickerProviderStateMixin {
  late TabController tabController;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );

    tabController.addListener(
          () {
        if (tabController.indexIsChanging ||
            tabController.index != tabController.previousIndex) {
          FocusScope.of(context).unfocus();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          // height: 50,
          color: LongaColor.pale_grey_three,
          child: TabBar(
            controller: tabController,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 6,
                color: LongaColor.darkish_purple,
              ),
            ),
            unselectedLabelColor: LongaColor.black,
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: "Roboto",
              fontStyle: FontStyle.normal,
              fontSize: 20,
            ),
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: "Roboto",
              fontStyle: FontStyle.normal,
              fontSize: 20.0,
            ),
            labelColor: LongaColor.darkish_purple,
            tabs: widget.tabBarTitles,
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: tabController,
            children: widget.tabBarViews,
          ),
        ),
      ],
    );
  }
}
