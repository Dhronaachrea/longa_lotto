import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/bloc/logout_bloc/logout_bloc.dart';
import 'package:longa_lotto/common/bloc/logout_bloc/logout_event.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/navigation/longa_screen.dart';
import 'package:longa_lotto/common/widget/alert/alert_type.dart';
import 'package:longa_lotto/common/widget/alert/state_alert_dialog.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:velocity_x/velocity_x.dart';

class ChangePasswordLogout extends StatefulWidget {
  const ChangePasswordLogout({Key? key}) : super(key: key);

  @override
  State<ChangePasswordLogout> createState() => _ChangePasswordLogoutState();
}


class _ChangePasswordLogoutState extends State<ChangePasswordLogout> {

  bool logOutButtonClicked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: 50,
      decoration: BoxDecoration(
        color: LongaColor.darkish_purple_two,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(LongaScreen.changePasswordScreen);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.vpn_key_outlined,
                        color: Colors.white,
                      ).px8(),
                      FittedBox(
                        child: Text(
                          context.l10n.changePassword,
                          maxLines: 2,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(
            color: Colors.white,
            width: 1,
          ),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    StateAlert.show(
                      type: AlertType.confirmation,
                      title: context.l10n.logout.toUpperCase(),
                      subtitle: context.l10n.logout_confirmation,
                      buttonText: context.l10n.ok.toUpperCase(),
                      context: context,
                      isCloseButton: true,
                      isDarkThemeOn: false,
                      buttonClick: _onConfirmLogout,
                    );
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.logout,
                          color: Colors.white,
                        ).px4(),
                        Text(
                          context.l10n.logout,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _onConfirmLogout(BuildContext mCtx) {
    if(logOutButtonClicked) return;
      logOutButtonClicked = true;
    BlocProvider.of<LogoutBloc>(context).add(LogoutApiEvent(context: context));
  }
}
