import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:longa_lotto/sign_up/model/response/registration_response.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<UserLogin>(_onLoginEvent);
    on<UserLogout>(_onLogoutEvent);
    on<UpdateUserInfo>(_onUpdateUserEvent);
  }
  String? currencyCode;
  String? referCode;
  String? countryName;
  String? cashBalance;
  String? userName;
  String? totalBalance;
  double? totalWithdrawalBalance;
  String? mobNumber;
  String? email;
  String? dob;
  String? gender;
  String? address;
  String? profileImage;
  String? firstName;
  String? lastName;

  FutureOr<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) {
    if (UserInfo.isLoggedIn()) {

      userName      = UserInfo.userName;
      referCode     = UserInfo.getReferCode;
      totalBalance  = UserInfo.totalBalance.toString();
      mobNumber     = UserInfo.mobNumber;
      profileImage  = UserInfo.profileImage;
      cashBalance   = UserInfo.cashBalance.toString();
      totalWithdrawalBalance= UserInfo.withdrawalBalance;
      emit(AuthLoggedIn());
    } else {
      emit(AuthLoggedOut());
    }
  }

  FutureOr<void> _onLoginEvent(UserLogin event, Emitter<AuthState> emit) {
    RegistrationResponse response   = event.registrationResponse;
    PlayerLoginInfo playerInfo      = response.playerLoginInfo!;
    WalletBean? walletBean          = playerInfo.walletBean;

    currencyCode  = walletBean?.currency ?? "";
    referCode     = response.playerLoginInfo?.referFriendCode ?? "";
    cashBalance   = walletBean?.cashBalance?.toStringAsFixed(2);
    totalBalance  = walletBean?.totalBalance?.toStringAsFixed(2);
    /*var name      = "${firstName ?? ""} ${lastName ?? ""}";
    userName      = name.trim() == '' ? UserInfo.userName : name;*/
    userName      = playerInfo.userName;
    mobNumber     = playerInfo.mobileNo;
    profileImage  = (playerInfo.commonContentPath ?? "") + (playerInfo.avatarPath ?? "");
    totalWithdrawalBalance = response.playerLoginInfo?.walletBean?.withdrawableBal ?? 0.0;
    print("before total withdrawal balance ===============>${response.playerLoginInfo?.walletBean?.withdrawableBal}");

    UserInfo.setRegistrationData(jsonEncode(response));
    UserInfo.setRegistrationResponse();
    UserInfo.setPlayerToken(response.playerToken ?? "");
    UserInfo.setPlayerId(playerInfo.playerId.toString());
    UserInfo.setCashBalance(cashBalance ?? "0");
    UserInfo.setTotalBalance(totalBalance ?? "0");
    UserInfo.setWithdrawalBalance(response.playerLoginInfo?.walletBean?.withdrawableBal ?? 0.0);

    print("login withdrawal balance ===============>${UserInfo.withdrawalBalance}");
    emit(AuthLoggedIn());
  }

  FutureOr<void> _onLogoutEvent(UserLogout event, Emitter<AuthState> emit) {
    UserInfo.logout();
    emit(AuthLoggedOut());
  }

  FutureOr<void> _onUpdateUserEvent(UpdateUserInfo event, Emitter<AuthState> emit) {
    RegistrationResponse response   = event.registrationResponse;

    UserInfo.setRegistrationData(jsonEncode(response));
    UserInfo.setRegistrationResponse();
    emit(UserInfoUpdated());
  }
}
