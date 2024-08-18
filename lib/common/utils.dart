import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/logic/utils_logic.dart';
import 'package:longa_lotto/sign_up/model/response/registration_response.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:velocity_x/velocity_x.dart';
import '../login/bloc/login_bloc.dart';
import '../login/login_screen.dart';
import '../utils/auth/auth_bloc.dart';
import 'constant/api_constant.dart';
import 'model/response/get_balance_response.dart';

final navigatorKey = GlobalKey<NavigatorState>();

const Duration buttonClickThreshold = Duration(seconds: 2);

Future<DateTimeRange?> showCalendar(
    BuildContext context, DateTime? firstDate, DateTime? lastDate) async {
  DateTimeRange? pickedDate = await showDateRangePicker(
    context: context,
    //initialDatePickerMode: DatePickerMode.day,
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    firstDate: DateTime(1900),
    initialDateRange: DateTimeRange(
      start: firstDate ??
          DateTime.now().subtract(
            Duration(days: 30),
          ),
      end: lastDate ?? DateTime.now(),
    ),
    lastDate: DateTime.now(),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: LongaColor.navy_blue_light,
            onPrimary: LongaColor.white,
            onSurface: LongaColor.tomato,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor:
                  LongaColor.navy_blue_light, // button text color
            ),
          ),
        ),
        child: Dialog(
                  child: Container(
                    height: 500,
                    child: child!
                  ),
              ).pSymmetric(h: isMobileDevice() ? 0 : 40)
      );
    },
  );
  if (pickedDate == null) {
    return null;
  }
  return pickedDate;
}

formatDate({
  required String date,
  required String inputFormat,
  required String outputFormat,
  bool notTranslate = false
}) {
  DateFormat inputDateFormat = DateFormat(inputFormat);
  DateTime input = inputDateFormat.parse(date);
  DateFormat outputDateFormat;
  if(!notTranslate) {
    outputDateFormat = DateFormat(outputFormat,Localizations.localeOf(navigatorKey.currentContext!).toString());
  } else{
    outputDateFormat = DateFormat(outputFormat);
  }
  return outputDateFormat.format(input);
}

bool verifyEmail(String emailId) {
  return emailId.isValidEmail();
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

void fetchHeaderInfo(BuildContext context) async {
  Map<String, dynamic> request = {
    "domainName": AppConstants.domainName,
    "playerId": UserInfo.userId,
    "playerToken": UserInfo.userToken,
  };
  var response = await UtilsLogic.getBalanceApi(context, request);
  try {
    response.when(
        responseSuccess: (value) {
          GetBalanceResponse getBalanceResponse = value as GetBalanceResponse;
          var getSavedRegistrationData = UserInfo.registrationData;
          Map<String, dynamic> jsonMap = jsonDecode(getSavedRegistrationData);
          RegistrationResponse registrationResponse =
              RegistrationResponse.fromJson(jsonMap);
          registrationResponse.playerLoginInfo?.walletBean?.cashBalance =
              getBalanceResponse.wallet?.cashBalance;
          registrationResponse.playerLoginInfo?.walletBean?.totalBalance =
              getBalanceResponse.wallet?.totalBalance;
          registrationResponse.playerLoginInfo?.walletBean?.withdrawableBal = getBalanceResponse.wallet?.withdrawableBal;
          BlocProvider.of<AuthBloc>(context).add(UpdateUserInfo(registrationResponse: registrationResponse));
          /*BlocProvider.of<AuthBloc>(context).add(
            UpdateUserInfo(
              user: User(
                cashBalance:
                    getBalanceResponse.wallet?.cashBalance?.toStringAsFixed(2),
                totalBalance:
                    getBalanceResponse.wallet?.totalBalance?.toStringAsFixed(2),
              ),
            ),
          );*/
        },
        idle: () {},
        networkFault: (value) {
          // log("network error");
          // emit(FetchDgeGameError(
          //     errorMessage: value["occurredErrorDescriptionMsg"]));
        },
        responseFailure: (value) {
          // print(
          //     "bloc responseFailure: ${value?.errorCode}, ${value?.respMsg}");
          // emit(FetchDgeGameError(
          //     errorMessage: value?.respMsg ??
          //         "Something went wrong while extracting response"));
        },
        failure: (value) {
          // print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
          // emit(FetchDgeGameError(
          //     errorMessage: value["occurredErrorDescriptionMsg"] ??
          //         "Something went wrong"));
        });
  } catch (e) {
    // emit(FetchDgeGameError(
    //     errorMessage: "Technical issue, Please try again. $e"));
  }
}

loginForSessionExpired(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(),
      child: const LoginScreen(),
    ),
  );
}


bool isMobileDevice () {
  final data = MediaQueryData.fromView(WidgetsBinding.instance.window);
  return data.size.shortestSide < 600; // true => phone, false => tablet
}