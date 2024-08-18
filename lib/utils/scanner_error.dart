import 'package:flutter/material.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class ScannerError extends StatefulWidget {
  BuildContext context;
  MobileScannerException error;

  ScannerError({Key? key, required this.context, required this.error})
      : super(key: key);

  @override
  State<ScannerError> createState() => _ScannerErrorState();
}

class _ScannerErrorState extends State<ScannerError> {
  static const Permission cameraPermission = Permission.camera;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: LongaColor.butterscotch,
      child: widget.error.errorCode.name == "genericError" ||
          widget.error.errorCode.name == "permissionDenied"
          ? Center(
        child: InkWell(
            onTap: () async {
              showCustomDialog(context);
            },
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.crisis_alert, size: 30,),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Reload",
                    style: TextStyle(
                        color: LongaColor.black, fontSize: 24),
                  ),
                ],
              ),
            )),
      )
          : Text(widget.error.errorCode.name.toString()),
    );
  }

  Future<void> _requestPermission(context) async {
    var status = await cameraPermission.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            "Need Camera Permission",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                  context.l10n.ok,
                  style: TextStyle(
                    fontSize: 18,
                    color: LongaColor.black,
                    fontWeight: FontWeight.w500,
                  )),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                _requestPermission(context);
              },
            )
          ],
        );
      },
    );
  }
}
