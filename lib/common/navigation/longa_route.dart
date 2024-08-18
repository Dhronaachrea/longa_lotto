import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/changePassword/bloc/current_password_bloc.dart';
import 'package:longa_lotto/changePassword/change_password_screen.dart';
import 'package:longa_lotto/common/bloc/date_bloc/date_selector_bloc.dart';
import 'package:longa_lotto/common/widget/web_view/drawer_more_links_web_view.dart';
import 'package:longa_lotto/dashboard/dashboardScreen/bloc/dashboard_bloc.dart';
import 'package:longa_lotto/dashboard/dashboardScreen/dashboard_screen.dart';
import 'package:longa_lotto/forgotPassword/bloc/forgot_password_bloc.dart';
import 'package:longa_lotto/forgotPassword/forgot_password_screen.dart';
import 'package:longa_lotto/myTransaction/bloc/transaction_bloc.dart';
import 'package:longa_lotto/inbox/bloc/inbox_bloc.dart';
import 'package:longa_lotto/inbox/inbox_screen.dart';
import 'package:longa_lotto/lobby/ige_lobby_screen.dart';
import 'package:longa_lotto/myTransaction/my_transaction_screen.dart';
import 'package:longa_lotto/profile/bloc/profile_bloc.dart';
import 'package:longa_lotto/profile/edit_profile_screen.dart';
import 'package:longa_lotto/profile/my_profile_screen.dart';
import 'package:longa_lotto/refer/bloc/refer_bloc.dart';
import 'package:longa_lotto/refer/refer_a_friend_screen.dart';
import 'package:longa_lotto/refer/track_status_screen.dart';
import 'package:longa_lotto/sign_up/bloc/sign_up_bloc.dart';
import 'package:longa_lotto/sign_up/sign_up.dart';
import 'package:longa_lotto/splash/bloc/splash_bloc.dart';
import 'package:longa_lotto/splash/model/response/ige_game_response.dart';
import 'package:longa_lotto/splash/splash_screen.dart';
import 'package:longa_lotto/ticket/ticket_screen.dart';
import 'package:longa_lotto/ticket/ticket_webview_screen.dart';
import 'package:longa_lotto/utility/network_connection/network_bloc.dart';
import 'package:longa_lotto/wallet/deposit/bloc/deposit_bloc.dart';
import 'package:longa_lotto/wallet/my_wallet_screen.dart';
import 'package:longa_lotto/wallet/withdrawal/bloc/Withdrawal_bloc.dart';

import '../../ticket/bloc/ticket_bloc.dart';
import 'longa_screen.dart';

class LongaRoute {
  router(RouteSettings setting) {
    switch (setting.name) {
      case LongaScreen.splashScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<SplashBloc>(
                create: (BuildContext context) => SplashBloc(),
              ),
              BlocProvider(
                create: (context) => NetworkBloc(),
              ),
            ],
            child: SplashScreen(),
          )
        );
      case LongaScreen.homeScreen:
        var isFirstTimeLogin = setting.arguments as bool?;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<DashBoardBloc>(
                create: (BuildContext context) => DashBoardBloc(),
              ),
              BlocProvider<NetworkBloc>(
                create: (BuildContext context) => NetworkBloc(),
              ),
              BlocProvider<SignUpBloc>(
                create: (BuildContext context) => SignUpBloc(),
              ),
            ],
            child: DashBoardScreen(isFirstTimeLogin: isFirstTimeLogin),
          )
        );
      case LongaScreen.forgotPasswordScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<ForgotPasswordBloc>(
                create: (BuildContext context) => ForgotPasswordBloc(),
              ),
            ],
            child: const ForgotPasswordScreen(),
          ),
        );
      case LongaScreen.signUpScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<SignUpBloc>(
                create: (BuildContext context) => SignUpBloc(),
              ),
            ],
            child: const SignUp(),
          ),
        );
      /*case LongaScreen.otpScreen:
        return MaterialPageRoute(
          builder: (context) => const OtpScreen(),
        );*/
      case LongaScreen.myProfileScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<ProfileBloc>(
                create: (BuildContext context) => ProfileBloc(),
              ),
              BlocProvider(
                create: (context) => NetworkBloc(),
              ),
            ],
            child: const MyProfileScreen(),
          ),
        );
      case LongaScreen.editProfileScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<ProfileBloc>(
                create: (BuildContext context) => ProfileBloc(),
              ),
            ],
            child: const EditProfileScreen(),
          ),
        );
      case LongaScreen.ticketScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => DateSelectorBloc()),
              BlocProvider(create: (_) => TicketBloc()),
              BlocProvider(
                create: (context) => NetworkBloc(),
              ),
            ],
            child: const TicketScreen(),
          ),
        );
      case LongaScreen.transactionScreen:
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => DateSelectorBloc()),
                BlocProvider(create: (_) => TransactionBloc()),
                BlocProvider(
                  create: (context) => NetworkBloc(),
                ),
              ],
              child: const MyTransactionScreen(),
            ),
        );
      case LongaScreen.referAFriend:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<ReferBloc>(
                create: (BuildContext context) => ReferBloc(),
              ),
            ],
            child: const ReferAFriend(),
          ),
        );
      case LongaScreen.changePasswordScreen:
        return MaterialPageRoute(
          builder: (context) =>
              BlocProvider<ChangePasswordBloc>(
                create: (_) => ChangePasswordBloc(),
                child: const ChangePassword(),
          ),
        );
      /*case LongaScreen.trackStatusScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<ReferBloc>(
                create: (BuildContext context) => ReferBloc(),
              ),
            ],
            child: const TrackStatusScreen(),
          ),
        );*/
      case LongaScreen.myWalletScreen:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider<DepositBloc>(
                    create: (BuildContext context) => DepositBloc(),
                  ),
                  BlocProvider<WithdrawalBloc>(
                    create: (BuildContext context) => WithdrawalBloc(),
                  ),
                  BlocProvider(
                    create: (context) => NetworkBloc(),
                  ),
                ],
                child: MyWalletScreen()
            )
        );
      case LongaScreen.forgotPasswordScreen:
        return MaterialPageRoute(
          builder: (context) => const ForgotPasswordScreen(),
        );
      /*case LongaScreen.IgeLobbyScreen:
        IgeGameResponse igeGameResponse = setting.arguments as IgeGameResponse;
        return MaterialPageRoute(
          builder: (context) =>
              IgeLobbyScreen(igeGameResponse: igeGameResponse),
        );*/
      case LongaScreen.moreLinksWebViewScreen:
        List<String?> screenDetail = setting.arguments as List<String?>;
        return MaterialPageRoute(
          builder: (context) => DrawerMoreLinksWebView(screenDetail: screenDetail,),
        );
      case LongaScreen.inbox_screen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => InboxBloc(),
              ),
              BlocProvider(
                create: (context) => NetworkBloc(),
              ),
            ],
            child: const InboxScreen(),
          ),
        );

      case LongaScreen.ticketWebViewScreen:
        Map<String, dynamic> ticketDetail =
        setting.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => TicketWebViewScreen(ticketDetail: ticketDetail),
        );

      case LongaScreen.trackStatusScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider<ReferBloc>(
                create: (context) => ReferBloc(),
              ),
              BlocProvider(
                create: (context) => NetworkBloc(),
              ),
            ],
            child: const TrackStatusScreen(),
          ),
        );


      default:
        return MaterialPageRoute(builder: (context) => const DashBoardScreen());
    }
  }
}
