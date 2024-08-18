import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'longa_version_state.dart';

class LongaVersionCubit extends Cubit<LongaVersionState> {
  String appVersion = "0.0.0";
  LongaVersionCubit() : super(LongaVersionInitial(appVersion: "0.0.0"));

  getVersion() async {
    emit(LongaVersionLoading(appVersion: appVersion));
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    appVersion = '$version+$buildNumber';
    emit(LongaVersionLoaded(appVersion: appVersion));
  }
}
