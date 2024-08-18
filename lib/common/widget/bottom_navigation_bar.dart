import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/constant/longa_constant.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/login/bloc/login_bloc.dart';
import 'package:longa_lotto/login/login_screen.dart';
import 'package:longa_lotto/utils/user_info.dart';

class LongaBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int index) onTap;

  const LongaBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var verticalBorder = Container(
      color: LongaColor.warm_grey_three,
      width: 1,
    );
    var textStyle = TextStyle(
      color: LongaColor.black_four,
      fontSize: 12,
    );
    return Container(
      color: LongaColor.pale_grey_three,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: LongaColor.white,
        ),
        height: LongaConstant.bottomNavigationHeight,
        child: BottomAppBar(
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      onTap(0);
                    },
                    child: Column(
                      children: <Widget>[
                        SvgPicture.asset(
                          currentIndex == 0
                              ? "assets/icons/bottombar/home_colored.svg"
                              : "assets/icons/bottombar/home.svg",
                          width: LongaConstant.bottomNavigationIconSize,
                          height: LongaConstant.bottomNavigationIconSize,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              context.l10n.home,
                              textAlign: TextAlign.center,
                              style: setTextStyle(currentIndex == 0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                verticalBorder,
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      if (UserInfo.isLoggedIn()) {
                        onTap(1);
                      } else {
                        onTap(0);
                        showDialog(
                          context: context,
                          builder: (context) => BlocProvider<LoginBloc>(
                            create: (context) => LoginBloc(),
                            child: const LoginScreen(),
                          ),
                        );
                      }
                    },
                    child: Column(
                      children: <Widget>[
                        SvgPicture.asset(
                          currentIndex == 1
                              ? "assets/icons/bottombar/icon_open_transfer_colored.svg"
                              : "assets/icons/bottombar/icon_open_transfer.svg",
                          width: LongaConstant.bottomNavigationIconSize,
                          height: LongaConstant.bottomNavigationIconSize,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Expanded(
                          child: Text(
                            context.l10n.my_translation_nav,
                            textAlign: TextAlign.center,
                            style: setTextStyle(currentIndex == 1),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                verticalBorder,
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      if (UserInfo.isLoggedIn()) {
                        onTap(2);
                      } else {
                        onTap(0);
                        showDialog(
                          context: context,
                          builder: (context) => BlocProvider<LoginBloc>(
                            create: (context) => LoginBloc(),
                            child: const LoginScreen(),
                          ),
                        );
                      }
                    },
                    child: Column(
                      children: <Widget>[
                        SvgPicture.asset(
                          currentIndex == 2
                              ? "assets/icons/bottombar/subtraction_8_colored.svg"
                              : "assets/icons/bottombar/subtraction_8.svg",
                          width: LongaConstant.bottomNavigationIconSize,
                          height: LongaConstant.bottomNavigationIconSize,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Expanded(
                          child: Text(
                            context.l10n.my_ticket_nav,
                            textAlign: TextAlign.center,
                            style: setTextStyle(currentIndex == 2),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                verticalBorder,
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      if (UserInfo.isLoggedIn()) {
                        onTap(3);
                      } else {
                        onTap(0);
                        showDialog(
                          context: context,
                          builder: (context) => BlocProvider<LoginBloc>(
                            create: (context) => LoginBloc(),
                            child: const LoginScreen(),
                          ),
                        );
                      }
                    },
                    child: Column(
                      children: <Widget>[
                        SvgPicture.asset(
                          currentIndex == 3
                              ? "assets/icons/bottombar/account_colored.svg"
                              : "assets/icons/bottombar/icon_feather_user.svg",
                          width: LongaConstant.bottomNavigationIconSize,
                          height: LongaConstant.bottomNavigationIconSize,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Expanded(
                          child: Text(
                            context.l10n.my_account_nav,
                            textAlign: TextAlign.center,
                            style: setTextStyle(currentIndex == 3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  setTextStyle(bool isSelected){
    return TextStyle(
      color: isSelected ? LongaColor.black : LongaColor.warm_grey_three,
      fontSize: 12,
      fontWeight: FontWeight.w600
    );
  }
}
