import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/navigation/longa_screen.dart';
import 'package:longa_lotto/common/utils.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/login/bloc/login_bloc.dart';
import 'package:longa_lotto/login/login_screen.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'drawer_grid_tile.dart';
import 'drawer_title.dart';

class MyAccount extends StatelessWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DrawerTitle(title: context.l10n.myAccount.toUpperCase()),
        GridView(
          padding: const EdgeInsets.only(bottom: 0),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: isMobileDevice() ? 0.95 : 0.99,
            crossAxisCount: 3,
          ),
          children: [
            //leftChild
            DrawerGridTile(
              icon: const AssetImage('assets/icons/account/user.png'),
              title: context.l10n.myProfile,
              onTap: () {

                UserInfo.isLoggedIn()
                    ? Navigator.pushNamed(context, LongaScreen.myProfileScreen)
                    : showDialog(
                          context: context,
                          builder: (context) => BlocProvider<LoginBloc>(
                            create: (context) => LoginBloc(),
                            child: const LoginScreen(),
                          )
                      );
              },
              leftChild: true,
            ),
            DrawerGridTile(
              icon: const AssetImage('assets/icons/account/tickets.png'),
              title: context.l10n.myTickets,
              onTap: () {
                UserInfo.isLoggedIn()
                    ? Navigator.pushNamed(context, LongaScreen.ticketScreen)
                    : showDialog(
                    context: context,
                    builder: (context) => BlocProvider<LoginBloc>(
                      create: (context) => LoginBloc(),
                      child: const LoginScreen(),
                    )
                );
              },
            ),
            //right child
            DrawerGridTile(
              icon: const AssetImage('assets/icons/account/wallet.png'),
              title: context.l10n.myWallet,
              onTap: () {
                UserInfo.isLoggedIn()
                    ? Navigator.pushNamed(context, LongaScreen.myWalletScreen)
                    : showDialog(
                    context: context,
                    builder: (context) => BlocProvider<LoginBloc>(
                      create: (context) => LoginBloc(),
                      child: const LoginScreen(),
                    )
                );
              },
              rightChild: true,
            ),
            //left child
            DrawerGridTile(
              icon: const AssetImage('assets/icons/account/transactions.png'),
              title: context.l10n.myTransactions,
              onTap: () {
                UserInfo.isLoggedIn()
                    ? Navigator.pushNamed(context, LongaScreen.transactionScreen)
                    : showDialog(
                  context: context,
                  builder: (context) => BlocProvider<LoginBloc>(
                    create: (context) => LoginBloc(),
                    child: const LoginScreen(),
                  ),
                );
              },
              leftChild: true,
            ),
            DrawerGridTile(
              icon: const AssetImage('assets/icons/account/inbox.png'),
              title: context.l10n.inbox,
              showCounter: true,
              onTap: () {
                UserInfo.isLoggedIn()
                    ? Navigator.pushNamed(context, LongaScreen.inbox_screen)
                    : showDialog(
                        context: context,
                        builder: (context) => BlocProvider<LoginBloc>(
                          create: (context) => LoginBloc(),
                          child: const LoginScreen(),
                        ),
                      );
              },
            ),
            //right child
            DrawerGridTile(
              icon: const AssetImage('assets/icons/account/high_five.png'),
              title: context.l10n.referAFriend,
              onTap: () {
                UserInfo.isLoggedIn()
                    ? Navigator.pushNamed(context, LongaScreen.referAFriend)
                    : showDialog(
                        context: context,
                        builder: (context) => BlocProvider<LoginBloc>(
                          create: (context) => LoginBloc(),
                          child: const LoginScreen(),
                        ),
                      );
              },
              rightChild: true,
            ),
          ],
        ),
      ],
    );
  }
}
