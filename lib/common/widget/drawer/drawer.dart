import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/bloc/logout_bloc/logout_bloc.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/utils.dart';
import 'package:longa_lotto/common/widget/gradient_line.dart';
import 'package:longa_lotto/main.dart';
import 'package:longa_lotto/utils/auth/auth_bloc.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:velocity_x/velocity_x.dart';
import 'drawer_widgets/change_password_logout.dart';
import 'drawer_widgets/header.dart';
import 'drawer_widgets/more_links.dart';
import 'drawer_widgets/my_accounts.dart';
import 'drawer_widgets/quick_links.dart';
import 'drawer_widgets/version/longa_version.dart';
import 'drawer_widgets/version/longa_version_cubit.dart';

class LongaDrawer extends StatefulWidget {
  const LongaDrawer({Key? key}) : super(key: key);

  @override
  State<LongaDrawer> createState() => _LongaDrawerState();
}

class _LongaDrawerState extends State<LongaDrawer> {
  final double flagSize = 35;
  int selectedFlag = 0;
  bool howToPlayTapped = false;

  @override
  Widget build(BuildContext context) {
    String selectedLang = LongaLottoApp.of(context).locale.languageCode;
    return BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return SafeArea(
            bottom: false,
            left: false,
            right: false,
            child: Drawer(
              width: context.screenWidth * 0.8,
              child: Container(
                color: LongaColor.white_five,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      height: isMobileDevice() ? 40 : 50,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              LongaLottoApp.of(context).setLocale(
                                const Locale('en', 'UK'),
                              );
                            },
                            child: Text(
                              "EN",
                              style: selectedLang == 'en'
                                  ? Theme.of(context).textTheme.headline3?.copyWith(
                                      fontSize: isMobileDevice() ? 18 : 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600
                                    )
                                  : Theme.of(context).textTheme.headline4?.copyWith(
                                      fontSize: isMobileDevice() ? 16 : 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                            ),
                          ),
                          const VerticalDivider(width: 6, thickness: 1.5,color: LongaColor.black,).pOnly(left: 3, right: 3, top: 5, bottom: 5),
                          InkWell(
                            onTap: () {
                              LongaLottoApp.of(context).setLocale(
                                const Locale('fr', 'FR'),
                              );
                            },
                            child: Text(
                              "FR",
                              style: selectedLang != 'en'
                                  ? Theme.of(context).textTheme.headline3?.copyWith(
                                      fontSize: isMobileDevice() ? 18 : 20,
                                      color: LongaColor.black,
                                      fontWeight: FontWeight.w600
                                    )
                                  : Theme.of(context).textTheme.headline4?.copyWith(
                                      fontSize: isMobileDevice() ? 16 : 18,
                                      fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ).pSymmetric(h: 20),
                    ),
                    const Header(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HeightBox(10),
                            MyAccount(),
                            HeightBox(20),
                            QuickLinks(),
                            HeightBox(20),
                            MoreLinks(),
                            HeightBox(20),
                            UserInfo.isLoggedIn()
                                ? BlocProvider<LogoutBloc>(
                              create:  (BuildContext context) => LogoutBloc(),
                              child: const ChangePasswordLogout(),
                            )
                                : Container(),
                            HeightBox(20),
                            GradientLine(),
                          ],
                        ),
                      ),
                    ),
                    BlocProvider<LongaVersionCubit>(
                      create: (BuildContext context) => LongaVersionCubit(),
                      child: const LongaVersion(),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}
