import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/constant/longa_constant.dart';
import 'package:longa_lotto/l10n/l10n.dart';

class ProfilePictureOptionsBottomSheet extends StatefulWidget {
  ProfilePictureOptionsBottomSheet({
    Key? key,
    required this.isValidImageUrl,
    required this.callback,
  }) : super(key: key);

  final void Function(ProfilePhotoSelectOptions) callback;
  bool isValidImageUrl;

  @override
  State<ProfilePictureOptionsBottomSheet> createState() => _ProfilePictureOptionsBottomSheetState();
}

class _ProfilePictureOptionsBottomSheetState extends State<ProfilePictureOptionsBottomSheet> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 24),
              child: Text(context.l10n.profile_photo, style: TextStyle(color: LongaColor.black, fontSize: 20, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold, letterSpacing: 1)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          onTap: () {
                            widget.callback(ProfilePhotoSelectOptions.camera);
                          },
                          child: Ink(
                            width: 60,
                            height:60,
                            decoration: BoxDecoration(
                              color: LongaColor.white,
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(50)),
                              border: new Border.all(
                                color: LongaColor.pale_lilac,
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SvgPicture.asset(
                                  'assets/icons/camera.svg',
                                  color: LongaColor.icon_green
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(context.l10n.camera, style: TextStyle(color: LongaColor.black, fontSize: 14)),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          onTap:() {
                            widget.callback(ProfilePhotoSelectOptions.gallery);
                          },
                          child: Ink(
                            width: 60,
                            height:60,
                            decoration: BoxDecoration(
                              color: LongaColor.white,
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(50)),
                              border: new Border.all(
                                color: LongaColor.pale_lilac,
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SvgPicture.asset(
                                  'assets/icons/gallery.svg',
                                  color: LongaColor.icon_green
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(context.l10n.gallery, style: TextStyle(color: LongaColor.black, fontSize: 14)),
                        )
                      ],
                    ),
                  ),
                  widget.isValidImageUrl ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          onTap:() {
                            widget.callback(ProfilePhotoSelectOptions.view);
                          },
                          child: Ink(
                            width: 60,
                            height:60,
                            decoration: BoxDecoration(
                              color: LongaColor.white,
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(50)),
                              border: new Border.all(
                                color: LongaColor.shamrock_green,
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SvgPicture.asset(
                                  'assets/icons/preview_image.svg',
                                  color: LongaColor.icon_green
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(context.l10n.view_profile_pic, style: TextStyle(color: LongaColor.black, fontSize: 14)),
                        )
                      ],
                    ),
                  ) : Container(),

                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

displayModalBottomSheet(context, ProfilePictureOptionsBottomSheet bottomSheet,
    {bool? enableDrag}) async {
  await showModalBottomSheet(
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(18),
      ),
    ),
    isScrollControlled: true,
    isDismissible: true,
    context: context,
    enableDrag: true,
    builder: (BuildContext context) {
      return bottomSheet;
    },
  ).then((value) => isVisible = true);
}

class BottomSheetTheme {
  static show({
    required BuildContext context,
    required ProfilePictureOptionsBottomSheet sheet,
    Color? backgroundColor,
    bool? enableDrag,
  }) {
    return showModalBottomSheet(
      backgroundColor: backgroundColor ?? Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(18),
        ),
      ),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: enableDrag ?? true,
      context: context,
      builder: (BuildContext context) {
        return sheet;
      },
    ).then((value) {
      isVisible = true;
    });
  }
}

bool isVisible = false;
