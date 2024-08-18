import 'package:flutter/material.dart';

import '../common/constant/longa_color.dart';

class LoadingIndicator extends StatelessWidget {
  const
  LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      color: LongaColor.orangey_red,
    );
  }
}
