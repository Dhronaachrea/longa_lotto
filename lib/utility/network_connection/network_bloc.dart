import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:longa_lotto/common/show_snackbar.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/utility/network_connection/network_event.dart';
import 'package:longa_lotto/utility/network_connection/network_state.dart';


class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  NetworkBloc() : super(NetworkInitial()) {
    on<IsNetworkConnected>(_isNetworkConnected);
  }

  FutureOr<void> _isNetworkConnected(IsNetworkConnected event, Emitter<NetworkState> emit) {
    final BuildContext context = event.context;
    if (event.isConnected) {
      emit(NetWorkConnected(s: ""));
    } else {
      ShowToast.showToast(context, context.l10n.not_internet_connection, type: ToastType.ERROR);
      emit(NetWorkNotConnected(s: ""));
    }
  }

}


