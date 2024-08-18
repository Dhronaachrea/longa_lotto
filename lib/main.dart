import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:longa_lotto/common/theme/app_theme.dart';
import 'package:longa_lotto/common/utils.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/utility/network_connection/network_bloc.dart';
import 'package:longa_lotto/utils/DeepLinkHandler.dart';
import 'package:longa_lotto/utils/auth/auth_bloc.dart';
import 'package:longa_lotto/utils/shared_prefs.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'common/navigation/longa_route.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await SharedPrefUtils.init();
  DeepLinkHandler.initPlatformState();
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => NetworkBloc(),
        ),
      ],
      child: LongaLottoApp(),
    ),
  );
}

class LongaLottoApp extends StatefulWidget {
  LongaLottoApp({Key? key}) : super(key: key);

  static _LongaLottoAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_LongaLottoAppState>()!;

  @override
  State<LongaLottoApp> createState() => _LongaLottoAppState();
}

class _LongaLottoAppState extends State<LongaLottoApp> {
  final LongaRoute longaRoute = LongaRoute();
  // Locale _locale = const Locale('en', 'UK');
  Locale _locale = const Locale('fr', 'FR'); // Default Lang

  Locale get locale => _locale;

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  Locale getLocale() {
    return _locale;
  }

  @override
  void initState() {
    if (UserInfo.isLoggedIn()) {
      UserInfo.setRegistrationResponse();
    }

    BlocProvider.of<AuthBloc>(context).add(AppStarted());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: appThemeData[AppTheme.LightAppTheme],
        locale: _locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (setting) => longaRoute.router(setting),
        navigatorKey: navigatorKey);
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}


