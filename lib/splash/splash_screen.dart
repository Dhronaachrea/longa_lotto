import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/navigation/longa_screen.dart';
import 'package:longa_lotto/common/show_snackbar.dart';
import 'package:longa_lotto/common/widget/longa_scaffold.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/splash/bloc/splash_bloc.dart';
import 'package:longa_lotto/splash/bloc/splash_event.dart';
import 'package:longa_lotto/splash/bloc/splash_state.dart';
import 'package:longa_lotto/splash/widgets/version_alert.dart';
import 'package:longa_lotto/utility/NetworkSingleton.dart';
import 'package:longa_lotto/utility/network_connection/network_bloc.dart';
import 'package:longa_lotto/utility/network_connection/network_state.dart';
import 'package:longa_lotto/utils/shared_prefs.dart';
import 'package:longa_lotto/utils/utils.dart';
import 'package:velocity_x/velocity_x.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{
  int counter = 0;
  late final AnimationController  loadingController;
  late final Animation<Offset>    loadingAnimation;
  static const Channel = MethodChannel('com.example.longa_lotto/loader_inner_bg');
  bool afterNetGone = false;

  @override
  void initState() {
    _logPrefs();
    loadingController = AnimationController(duration: const Duration(seconds: 4), vsync: this);
    loadingAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: loadingController,
      curve: Curves.easeIn,
    ));
    loadingController.forward();
    NetworkSingleton().setNetworkListener(context);
    BlocProvider.of<SplashBloc>(context).add(VersionControlApi(context: context));
    super.initState();
  }
  
  @override
  void dispose() {
    loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return BlocListener<NetworkBloc, NetworkState>(
      listener: (context, state ) {
        if(state is NetWorkConnected) {
          setState(() {
            if (afterNetGone) {
              afterNetGone = false;
              ShowToast.showToast(context, context.l10n.internet_available, type: ToastType.SUCCESS);
              BlocProvider.of<SplashBloc>(context).add(VersionControlApi(context: context));
            }
          });
        } else if(state is NetWorkNotConnected) {
          setState(() {
            afterNetGone = true;
          });
        }
      },
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is VersionControlLoading) {

          } else if (state is VersionControlSuccess) {

            if (state.response?.appDetails?.isUpdateAvailable == true) {
              String message = "${state.response?.appDetails?.message ?? "Updated Version"} : ${state.response?.appDetails?.version}";
              if (state.response?.appDetails?.mandatory == true) {

                VersionAlert.show(
                  context: context,
                  type: VersionAlertType.mandatory,
                  message: message,
                  onUpdate: () async {
                    if (Platform.isAndroid) {
                      _downloadUpdatedAPK(state.response?.appDetails?.url ?? "");
                    } else {
                      // download for ios
                    }
                  },
                );
              } else {
                VersionAlert.show(
                  context: context,
                  type: VersionAlertType.optional,
                  message: message,
                  onUpdate: () {
                    if (Platform.isAndroid) {
                      _downloadUpdatedAPK(state.response?.appDetails?.url ?? "");
                    } else {
                      // download for ios
                    }
                  },
                  onCancel: () {
                    Navigator.pushReplacementNamed(
                      context,
                      LongaScreen.homeScreen,
                    );
                  },
                );
              }
            } else {
              Navigator.pushReplacementNamed(
                context,
                LongaScreen.homeScreen,
              );
            }

          } else if (state is VersionControlError) {
            ShowToast.showToast(context, state.errorMsg,type: ToastType.ERROR);
            Navigator.pushReplacementNamed(
              context,
              LongaScreen.homeScreen,
            );
          }
        },
        child: LongaScaffold(
          body: Stack(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/splash_new.webp"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: Image.asset(
                          "assets/images/logo.webp",
                        ),
                      ).pOnly(left: 20, right: 20),
                      Container(
                        width: 300,
                        height: 25,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.blueAccent, width: 2),
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          image: DecorationImage(
                              image: AssetImage('assets/images/loader_inner_bg.webp'),
                              fit: BoxFit.fill,
                              scale: 40
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 20.0,
                            ),
                          ],
                        ),
                        child: SlideTransition(
                          position: loadingAnimation,
                          child: Center(
                            child: Container(
                              width: 400,
                              height: 25,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(6)),
                                  boxShadow: [
                                        BoxShadow(
                                          blurRadius: 16.0,
                                        ),
                                      ],
                                  gradient: LinearGradient(
                                      transform: GradientRotation(-70),
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        LongaColor.dark_purple,
                                        LongaColor.navy_blue_mid,
                                      ],
                                      stops: [
                                        0.4,
                                        0.6
                                      ]
                                  )
                              ),
                            ),
                          ),
                        ),
                      ).pOnly(top: 50),
                      Text("Chargement...", textAlign: TextAlign.center ,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),)
                    ],
                  ).pOnly(top: MediaQuery.of(context).size.height * 0.38)
              ),
              /*Container(
                color: LongaColor.marigold,
                child: Image.asset(
                  "assets/images/splash_new.webp",
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Image.asset(
                            "assets/images/logo.webp",
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            Container(
                              width: 300,
                              height: 25,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(color: Colors.blueAccent, width: 2),
                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                image: DecorationImage(
                                    image: AssetImage('assets/images/loader_inner_bg.webp'),
                                    fit: BoxFit.fill,
                                    scale: 40
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 20.0,
                                  ),
                                ],
                              ),
                              child: SlideTransition(
                                position: loadingAnimation,
                                child: Center(
                                  child: Container(
                                    width: 400,
                                    height: 25,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(6)),
                                        *//*boxShadow: [
                                          BoxShadow(
                                            blurRadius: 16.0,
                                          ),
                                        ],*//*
                                        gradient: LinearGradient(
                                            transform: GradientRotation(-70),
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            colors: [
                                              LongaColor.dark_purple,
                                              LongaColor.navy_blue_mid,
                                            ],
                                            stops: [
                                              0.4,
                                              0.6
                                            ]
                                        )
                                    ),
                                  ),
                                ),
                              ),
                            ).pOnly(top: 50),
                            Text("Chargement...", textAlign: TextAlign.center ,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),)
                          ],
                        ),
                      ),
                    ),
                  ],
                ).pOnly(left: 20, right: 20),
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _downloadUpdatedAPK(String url) async{
    try {
      Map<String, String> arg = {
        "url"  : url,
      };

      final dynamic receivedResponse = await Channel.invokeMethod('_downloadUpdatedAPK', arg);
      print("receivedResponse --> $receivedResponse");
    } catch(e) {
      print("-------- $e");
    }
  }

  _logPrefs() async {
    final appPrefs = SharedPrefUtils.getAllAppPrefs();
    log("---------------APP_DATA---------------");
    prettyPrintJson(jsonEncode(appPrefs));

    final userPrefs = SharedPrefUtils.getAllUserPrefs();
    log("---------------USER_DATA---------------");
    prettyPrintJson(jsonEncode(userPrefs));
  }
}
