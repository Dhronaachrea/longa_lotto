part of 'longa_version_cubit.dart';

abstract class LongaVersionState {
  String appVersion = "0.0.0";
  LongaVersionState({required this.appVersion});
}

class LongaVersionInitial extends LongaVersionState {
  LongaVersionInitial({required String appVersion})
      : super(appVersion: appVersion);
}

class LongaVersionLoading extends LongaVersionState {
  LongaVersionLoading({required String appVersion})
      : super(appVersion: appVersion);
}

class LongaVersionLoaded extends LongaVersionState {
  @override
  final String appVersion;

  LongaVersionLoaded({required this.appVersion})
      : super(appVersion: appVersion);
}
