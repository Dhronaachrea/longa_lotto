import 'package:flutter/material.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:velocity_x/velocity_x.dart';

import 'gradient_line.dart';

class LongoLottoBottomSheet extends StatefulWidget {
  final String? title;
  final List<Widget>? description;
  final Widget? bottomWidget;

  const LongoLottoBottomSheet({
    this.title,
    this.description,
    this.bottomWidget,
    Key? key,
  }) : super(key: key);

  @override
  State<LongoLottoBottomSheet> createState() => _LongoLottoBottomSheetState();
}

class _LongoLottoBottomSheetState extends State<LongoLottoBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: LongaColor.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const GradientLine(),
          widget.title != null ? const HeightBox(30) : const SizedBox(),
          HeaderText(
            title: widget.title ?? '',
          ),
          widget.title != null ? const HeightBox(20) : const SizedBox(),
          SingleChildScrollView(
            child: _buildBody(),
          ),
          _buildBottom()
        ],
      ),
    );
  }

  _buildBody() {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.description != null
            ? widget.description!
            : [const SizedBox()],
      ).px24(),
    );
  }

  _buildBottom() {
    return widget.bottomWidget ?? const SizedBox();
  }
}

class HeaderText extends StatelessWidget {
  final String title;

  const HeaderText({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 26,
          color: LongaColor.butter_scotch,
          fontWeight: FontWeight.w700,
        ),
      ).px20(),
    );
  }
}

class BottomSheetTheme {
  static show({
    required BuildContext context,
    required LongoLottoBottomSheet sheet,
    Color? backgroundColor,
    bool? enableDrag,
    bool? isDarkThemeOn,
  }) {
    return showModalBottomSheet(
      backgroundColor: LongaColor.white,
      isScrollControlled: false,
      isDismissible: false,
      enableDrag: enableDrag ?? true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return sheet;
        });
      },
    );
  }
}
