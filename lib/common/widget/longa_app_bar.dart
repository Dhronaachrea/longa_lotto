import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:longa_lotto/ScanLogin/Scan_Login_screen.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/navigation/longa_screen.dart';
import 'package:longa_lotto/common/utils.dart';
import 'package:longa_lotto/common/widget/alert/alert_dialog.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/login/bloc/login_bloc.dart';
import 'package:longa_lotto/login/login_screen.dart';
import 'package:longa_lotto/utils/auth/auth_bloc.dart';
import 'package:longa_lotto/utils/shared_prefs.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:longa_lotto/utils/utils.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:velocity_x/velocity_x.dart';

import 'longa_button.dart';

class LongaAppBar extends StatefulWidget implements PreferredSizeWidget {
  const LongaAppBar({
    this.myKey,
    Key? key,
    this.title,
    this.showBalance,
    this.showBell,
    this.showDrawer,
    this.backgroundColor,
    this.showBottomAppBar = false,
    this.showLoginBtnOnAppBar = true,
    this.centeredTitle = false,
    this.bottomTapvalue,
    this.bottomTapLoginValue,
    this.onBackButton,
    this.isIgeGame = false,
    this.isDepositWebView = false,
  }) : super(key: key);

  final GlobalKey<ScaffoldState>? myKey;
  final String? title;
  final bool? bottomTapvalue;
  final bool? bottomTapLoginValue;
  final bool? showDrawer;
  final bool? showBalance;
  final bool? showBell;
  final Color? backgroundColor;
  final bool? showBottomAppBar;
  final bool? showLoginBtnOnAppBar;
  final bool? centeredTitle;
  final VoidCallback? onBackButton;
  final bool isIgeGame;
  final bool isDepositWebView;

  // final bool? signin;

  @override
  State<LongaAppBar> createState() => _LongaAppBarState();

  @override
  Size get preferredSize => showBottomAppBar == false
      ? const Size(double.infinity, kToolbarHeight + 10)
      : const Size(double.infinity, kToolbarHeight * 2);
}

class _LongaAppBarState extends State<LongaAppBar> {
  bool? isUserLoggedIn;
  late Map<String, dynamic> prefs;
  GlobalKey qrIconKey               = GlobalKey();
  GlobalKey withdrawInitiateIconKey = GlobalKey();
  late TutorialCoachMark tutorialCoachMark;

  @override
  void initState() { // for now its always work for only withdrawal initiated.
    createTutorial();
    super.initState();
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   var currentPage = ModalRoute.of(context)?.settings.name;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if(SharedPrefUtils.getAppFirstTimeLaunch() && UserInfo.isLoggedIn()) {
        Future.delayed(Duration.zero, showTutorial);
        SharedPrefUtils.setAppFirstTimeLaunch();
      }
      /*String? cashBalance =
          (context.watch<AuthBloc>().cashBalance ?? UserInfo.cashBalance)
              .toString();*/
      return AppBar(
        centerTitle:  widget.title == null ? true : false,
        backgroundColor: widget.backgroundColor ?? Colors.transparent,
        elevation: 0,
        titleSpacing: 1,
        leadingWidth: 40,
        title: Container(
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width * 0.45,
          height: 50,
          child: Text(
            widget.title != null ? widget.title! : '',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: LongaColor.grape_purple,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                fontSize: 16.0),
          ),

        ),
        leading: widget.title == null
            ? MaterialButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                padding: isMobileDevice() ? EdgeInsets.all(8) : EdgeInsets.only(left: 8),
                child: SvgPicture.asset("assets/icons/drawer.svg",
                    color: LongaColor.white),
              )
            : new MaterialButton(
                onPressed: () {
                  if (widget.isIgeGame == true  || widget.isDepositWebView == true) {
                    Alert.show(
                      isDarkThemeOn: false,
                      buttonClick: () {
                        fetchHeaderInfo(navigatorKey.currentContext ?? context);
                        Navigator.pop(context);
                      },
                      title: context.l10n.exit,
                      isCloseButton: true,
                      subtitle: context.l10n.are_you_sure_you_want_to_exit,
                      buttonText: context.l10n.ok.toUpperCase(),
                      context: context,
                    );
                  } else {
                    Navigator.of(context).pop();
                  }
                },
          padding: EdgeInsets.all(8),
                child: SvgPicture.asset("assets/icons/back_icon.svg",
                    color: LongaColor.black),
              ),
        actions: [
          UserInfo.isLoggedIn() == false
              ? widget.showLoginBtnOnAppBar == true
                  ? Row(
                    children: [
                      InkWell(

                          onTap: () {

                            print("click on scaner login");
                            showGeneralDialog(
                                context: context,
                                pageBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation) {
                                  return Container();
                                },
                                transitionBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation,
                                    child) {
                                  var curve = Curves.easeInOut.transform(animation.value);
                                  return Transform.scale(
                                    scale: curve,
                                    child:ScanLoginScreen(onTap: () {

                                    },),
                                  );
                                },
                                transitionDuration: const Duration(milliseconds: 400)
                            );

                            /*Navigator.push( context,
                                MaterialPageRoute(
                                builder: (_) => MultiBlocProvider(
                              providers: [
                                BlocProvider<SignUpBloc>(
                                  create: (BuildContext context) => SignUpBloc(),
                                )
                              ],
                              child: ScanLoginScreen(onTap: () {

                              },),
                            ))
                            );*/

                          },
                          child: Row(
                            key: qrIconKey,
                            children: [
                              Icon(Icons.qr_code_scanner_outlined, size: 30,),
                              /*Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(context.l10n.scan, style: TextStyle(color: LongaColor.black,fontSize: 9),),
                                  Text(context.l10n.qr, style: TextStyle(color: LongaColor.black,fontSize: 13),),
                                ],
                              ).pOnly(left: 10)*/
                            ],
                          )

                        //const Icon(Icons.document_scanner_outlined, color: SabanzuriColors.yellow_orange, size: 30)
                      ),
                      Material(
                          borderRadius: BorderRadius.circular(30),
                          clipBehavior: Clip.hardEdge,
                          color: Colors.transparent,
                          child: SecondaryButton(
                            onPressed: () {
                              _loginOrSignUp();
                            },
                            text: context.l10n.login_or_signup_cap,
                            isFilled: true,
                            fontSize: 11.5,
                            fillColor: LongaColor.black_four.withOpacity(0.26),
                            borderColor: LongaColor.white,
                          ),
                        ),
                    ],
                  )
                  : Container()
              : Row(
                children: [
                  widget.title == null
                  ? UserInfo.getAliasNameScan.contains("scan")
                      ? InkWell(
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
                    child: Image.asset(
                        "assets/icons/icon-withdraw-scan.png",
                        key: withdrawInitiateIconKey,
                        width: 34,
                      height: 36,
                    ),
                  )
                      : Container()
                  : Container(),
                  FittedBox(
                    child: Container(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
                      decoration: BoxDecoration(
                          color: LongaColor.tangerine,
                          border: Border.all(color: LongaColor.white),
                          borderRadius: const BorderRadius.all(Radius.circular(30))
                      ),
                      child: Center(
                        child: RichText(
                          textAlign: TextAlign.right,
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                  text: '${context.l10n.hi}, ${UserInfo.userName}\n',
                                  style: TextStyle(
                                      color: LongaColor.black_four,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Roboto",
                                      fontSize: 13),
                              ),
                              TextSpan(
                                  text: '${UserInfo.currencyDisplayCode} ${removeDecimalValueAndFormat(UserInfo.totalBalance.toString())}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: LongaColor.black,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ).p(10),
                ],
              ),
        ],
      );
    });
  }

  Future _loginOrSignUp() {
    return showDialog(
        context: context,
        builder: (context) => BlocProvider<LoginBloc>(
              create: (context) => LoginBloc(),
              child: const LoginScreen(),
            )
        // builder: (context) => const SignUp(),
        // builder: (context) => const OtpScreen(),
        );
  }


  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets:   _createTargets(withdrawInitiateIconKey, "Withdraw Initiating", "Click on this icon if you want to withdraw amount."),
                  // : _createTargets(qrIconKey, "Qr Code Scanner", "Click on this icon to scan QR-code and login your user and enjoy the game"),
      colorShadow: LongaColor.tangerine,
      textSkip: "SKIP",
      textStyleSkip: TextStyle(
        color: LongaColor.white,
        fontWeight: FontWeight.w500,
        fontSize: 20
      ),
      // paddingFocus: 10,
      opacityShadow: 0.8,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print("clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        print("skip");
        return true;
      },
    );
  }

  List<TargetFocus> _createTargets(GlobalKey key, String title, String msgInfo) {
    List<TargetFocus> targets = [];

    targets.add(
      TargetFocus(
        identify: "iconKey",
        keyTarget: key,
        alignSkip: Alignment.bottomRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight:FontWeight.w500
                      ),
                    )
                  ),
                  Text(
                      msgInfo,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: LongaColor.black,
                        fontSize: 20
                      ),
                  ).pOnly(top: 10)
                ],
              );
            },
          )
        ]
      )
    );

    return targets;
  }

}
