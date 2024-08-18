import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/responseCodeMapping/response_code_en.dart';
import 'package:longa_lotto/common/responseCodeMapping/response_code_fr.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/main.dart';

enum TotalTextFields{mobileNumber, password, confirmPassword, oldPassword, otp, userName, amount, accountNo}

enum Gender { Male, Female}

enum ApiFamily {
    CASHIER,
    WEAVER,
    RAM,
    BONUS,
    DGE,
    IGE
}

encryptMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

prettyPrintJson(String input) {
  StringBuffer sb = StringBuffer();
  const JsonDecoder decoder = JsonDecoder();
  const JsonEncoder encoder = JsonEncoder.withIndent('  ');
  final dynamic object = decoder.convert(input);
  final String prettyString = encoder.convert(object);
  prettyString.split('\n').forEach((String element) => sb.writeln(element));
  log(sb.toString());
}

getWhichTrxType(BuildContext context, String type) {
  if (type.toLowerCase() == "PLR_WAGER".toLowerCase()) {
    return  context.l10n.wager ;
  } else if (type.toLowerCase() == "PLR_DEPOSIT".toLowerCase()) {
    return context.l10n.deposit;
  } else if (type.toLowerCase() == "PLR_WITHDRAWAL".toLowerCase()) {
    return context.l10n.withdrawal;
  } else if (type.toLowerCase() == "PLR_WINNING".toLowerCase()) {
    return context.l10n.winning;
  } else if (type.toLowerCase() == "PLR_BONUS_TRANSFER".toLowerCase()) {
    return context.l10n.bonus;
  } else if (type.toLowerCase() == "PLR_WAGER_REFUND".toLowerCase()) {
    return context.l10n.wagerRefund;
  } else if (type.toLowerCase() == "PLR_DEPOSIT_AGAINST_CANCEL".toLowerCase()) {
    return context.l10n.withdrawalCancel;
  } else if (type.toLowerCase() == "WITHDRAWAL_CHARGE_REFUND".toLowerCase()) {
    return context.l10n.withdrawal_charge_refund;
  }
  else {
    return type;
  }
}

Future<DateTime?> showCalendar(BuildContext context, DateTime? initialDate,
    DateTime? firstDate, DateTime? lastDate) async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDatePickerMode: DatePickerMode.day,
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    initialDate: initialDate ?? DateTime(1990),
    firstDate: firstDate ?? DateTime(1900),
    lastDate:
    lastDate ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: LongaColor.darkish_purple_two,
            onPrimary: LongaColor.white,
            onSurface: LongaColor.black,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: LongaColor.darkish_purple_two, // button text color
            ),
          ),
        ),
        child: child!,
      );
    },
  ).then((pickedDate) {
    if (pickedDate == null) {
      return null;
    }
    return pickedDate;
  });
  return pickedDate;
}

String currencyFormatting(double amount) {
    final formatter = NumberFormat("#,###.##", "en_fr");
    return formatter.format(amount).replaceAll(","," ");
}

String removeDecimalValueAndFormat(String amount) {
  //double.parse(amount.toString()).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')
  // return currencyFormatting(double.parse(amount.toString().contains(".") ? amount.toString().split('.')[0].toString() : amount));
  return currencyFormatting(double.parse(amount));
}

Future<bool> isInternetConnect() async{
  return await InternetConnectionChecker().hasConnection;
}

hideKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

String fetchResponseCodeMsg(BuildContext context, ApiFamily apiFamily, int? errorCode) {
  print("fetchResponseCodeMsg call ---> $errorCode ===> ${ResponseCodeMappingInEnglish.responseCodeMsg["${apiFamily.name}_$errorCode"] ?? context.l10n.something_went_wrong}");
  return (LongaLottoApp.of(context).getLocale().toString().split("_")[0].toLowerCase() == "en")
    ?
      // english
      ResponseCodeMappingInEnglish.responseCodeMsg["${apiFamily.name}_$errorCode"] ?? context.l10n.something_went_wrong
    :
      //french
      ResponseCodeMappingInFrench.responseCodeMsg["${apiFamily.name}_$errorCode"] ?? context.l10n.something_went_wrong ;

}