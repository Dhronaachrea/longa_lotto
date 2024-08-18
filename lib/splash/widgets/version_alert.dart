import 'package:flutter/material.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/splash/widgets/primary.dart';
import 'package:longa_lotto/splash/widgets/tertiary.dart';
import 'package:velocity_x/velocity_x.dart';

enum VersionAlertType {
  mandatory,
  optional,
}

class VersionAlert {
  static show({
    required BuildContext context,
    required VersionAlertType type,
    required String message,
    String? description,
    VoidCallback? onUpdate,
    VoidCallback? onCancel,
  }) {
    bool isLoading = false;
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return Center(
              child: Material(
                color: Colors.transparent,
                child: Wrap(
                  children: [
                    Stack(
                        children:[
                          Container(
                            margin: const EdgeInsets.all(18),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Colors.transparent,
                                      Colors.transparent,
                                    ]),

                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                      color: LongaColor.orangey_red,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [

                                        const HeightBox(15),
                                        const HeightBox(10),
                                        const Text(
                                          "Longa Lotto",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const HeightBox(20),
                                        Text(
                                          message,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        description != null
                                            ? Text(
                                          description,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ).py8()
                                            : Container(),
                                        const HeightBox(20),
                                        type == VersionAlertType.optional
                                            ? isLoading
                                                ? SizedBox(height: 20,).pOnly(left: 30,right: 30)
                                                : Row(children: [
                                                Expanded(
                                                  child: TertiaryButton(
                                                    textColor: Colors.white,
                                                    type: ButtonType.line_art,
                                                    onPressed: onCancel != null
                                                        ? () {
                                                      Navigator.of(ctx).pop();
                                                      onCancel();
                                                    }
                                                        : () {
                                                      Navigator.of(ctx).pop();
                                                    },
                                                    text: (context.l10n.later).toString(),
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                const WidthBox(10),
                                                Expanded(
                                                  child: TertiaryButton(
                                                    color: LongaColor.butter_scotch,
                                                    onPressed: onUpdate != null
                                                        ? () {
                                                      // Navigator.of(ctx).pop();
                                                      setState((){
                                                        isLoading = true;
                                                      });
                                                      onUpdate();
                                                    }
                                                        : () {
                                                      Navigator.of(ctx).pop();
                                                    },
                                                    text: (context.l10n.update_now).toString(),
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],).pOnly(left: 30,right: 30)
                                            : isLoading
                                                ? SizedBox(height: 20,).pOnly(left: 30,right: 30)
                                                : TertiaryButton(
                                              color: LongaColor.marigold,
                                              width: context.screenWidth,
                                              onPressed: onUpdate != null
                                                  ? () {
                                                // Navigator.of(ctx).pop();
                                                setState((){
                                                  isLoading = true;
                                                });
                                                onUpdate();
                                              }
                                                  : () {
                                                Navigator.of(ctx).pop();
                                              },
                                              text: (context.l10n.update_now).toString(),
                                            ).pOnly(left: 30,right: 30),

                                        isLoading
                                            ? LinearProgressIndicator(
                                                color: LongaColor.navy_blue_light,
                                              )
                                            : Container()
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                              top: -30,
                              left: 110,
                              child: Image.asset('assets/images/logo.webp',width: 150, height: 130,
                              )
                          ),
                        ]
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
