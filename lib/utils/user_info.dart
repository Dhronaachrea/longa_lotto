import 'dart:convert';

import 'package:longa_lotto/sign_up/model/response/registration_response.dart';
import 'package:longa_lotto/utils/shared_prefs.dart';

class UserInfo {
  static final UserInfo _instance = UserInfo._ctor();
  static RegistrationResponse? registrationResponse;

  factory UserInfo() {
    return _instance;
  }

  UserInfo._ctor();

  static bool isLoggedIn() {
    return SharedPrefUtils.playerToken != '';
  }

  static logout() async {
    SharedPrefUtils.removeValue(PrefType.USER_PREF.value);
    setRegistrationResponse();
  }

  static setPlayerToken(String token) {
    SharedPrefUtils.playerToken = token;
  }

  static setPlayerId(String playerId) {
    SharedPrefUtils.playerId = playerId;
  }

  static setRegistrationData(String data) {
    SharedPrefUtils.registrationResponse = data;
  }

  static setCashBalance(String cashBalance) {
    SharedPrefUtils.cashBalance = cashBalance;
  }

  static setTotalBalance(String totalBalance) {
    SharedPrefUtils.totalBalance = totalBalance;
  }

  static setUnReadMsgCount(String unReadMsgCount) {
    SharedPrefUtils.unreadMsgCount = unReadMsgCount;
  }

  static setRegistrationResponse() {
    var getRegistrationFromSharedPref   = SharedPrefUtils.registrationResponse;
    Map<String, dynamic> jsonMap        = getRegistrationFromSharedPref.isNotEmpty ? jsonDecode(getRegistrationFromSharedPref) : {};
    registrationResponse                = RegistrationResponse.fromJson(jsonMap);
  }

  static setDeepLinkData(String data) {
    SharedPrefUtils.deeplinkResponse = data;
  }

  static setWithdrawalBalance(double data) {
    registrationResponse?.playerLoginInfo?.walletBean?.withdrawableBal = data;
  }


  static String get userToken                 => SharedPrefUtils.playerToken;

  static String get userId                    => SharedPrefUtils.playerId;

  static String get userName                  => registrationResponse?.playerLoginInfo?.userName ?? "NA";

  static String get firstName                 => registrationResponse?.playerLoginInfo?.firstName ?? "NA";

  static String get lastName                  => registrationResponse?.playerLoginInfo?.lastName ?? "NA";

  static String get gender                    => registrationResponse?.playerLoginInfo?.gender ?? "NA";

  static String get dob                       => registrationResponse?.playerLoginInfo?.dob ?? "NA";

  static String get emailId                   => registrationResponse?.playerLoginInfo?.emailId ?? "NA";

  static String get emailVerified             => registrationResponse?.playerLoginInfo?.emailVerified ?? "N";

  static String get address                   => registrationResponse?.playerLoginInfo?.addressLine1 ?? "NA";

  static String get registrationData          => SharedPrefUtils.registrationResponse;

  static String get currencyDisplayCode       => registrationResponse?.playerLoginInfo?.walletBean?.currencyDisplayCode ?? "CDF";

  static double get totalBalance              => registrationResponse?.playerLoginInfo?.walletBean?.totalBalance ?? 0.0;

  static double get totalWithdrawalBalance    => registrationResponse?.playerLoginInfo?.walletBean?.totalWithdrawableBalance ?? 0.0;

  static String get unRaedMsgCount            => SharedPrefUtils.unreadMsgCount;

  static double get cashBalance               => registrationResponse?.playerLoginInfo?.walletBean?.cashBalance ?? 0.0;

  static double get withdrawalBalance         => registrationResponse?.playerLoginInfo?.walletBean?.withdrawableBal ?? 0.0;

  static String get mobNumber                 => registrationResponse?.playerLoginInfo?.mobileNo.toString() ?? "NA";

  static String get profileImage              => (registrationResponse?.playerLoginInfo?.commonContentPath ?? "") +  (registrationResponse?.playerLoginInfo?.avatarPath ?? "");

  static String get getReferCode              => registrationResponse?.playerLoginInfo?.referFriendCode ?? "NA";

  static String get getProfilePhotoUrl        => "${registrationResponse?.playerLoginInfo?.commonContentPath ?? ""}${registrationResponse?.playerLoginInfo?.avatarPath ?? ""}";

  static String get getAliasNameScan          => registrationResponse?.ramPlayerInfo?.aliasName ?? "";

  static String get getDeeplinkData           => SharedPrefUtils.deeplinkResponse;

}
