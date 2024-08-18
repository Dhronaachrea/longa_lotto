import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/widget/gradient_line.dart';
import 'package:longa_lotto/l10n/l10n.dart';

import 'longa_version_cubit.dart';

class LongaVersion extends StatefulWidget {
  const LongaVersion({Key? key}) : super(key: key);

  @override
  State<LongaVersion> createState() => _LongaVersionState();
}

class _LongaVersionState extends State<LongaVersion> {
  @override
  void initState() {
    BlocProvider.of<LongaVersionCubit>(context).getVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const GradientLine(),
        BlocBuilder<LongaVersionCubit, LongaVersionState>(
          builder: (context, state) {
            if (state is LongaVersionLoaded) {
              return SizedBox(
                height: 40,
                child: Center(
                  child: Text(
                    context.l10n.version + ": ${state.appVersion}",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              );
            } else {
              return SizedBox();
            }
          },
        ),
      ],
    );
  }
}
