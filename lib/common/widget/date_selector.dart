import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:longa_lotto/common/bloc/date_bloc/date_selector_bloc.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:velocity_x/velocity_x.dart';

class DateSelector extends StatefulWidget {
  final Function(String, String) selectedDate;
  const DateSelector({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<DateSelectorBloc, DateSelectorState>(
        listener: (context, state) {
          if (state is SelectedDate) {
            widget.selectedDate(context.read<DateSelectorBloc>().fromDate,context.read<DateSelectorBloc>().toDate);
          }
        },
        child : InkWell(
          onTap: () {
            context.read<DateSelectorBloc>().add(
              SelectDate(context: context),
            );
          },
          child: Row(
            children: [
              SvgPicture.asset(
                "assets/icons/calendar.svg",
                width: 22,
                height: 22,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                context.l10n.select_date_range,
                style: const TextStyle(
                    color: LongaColor.darkish_purple_two,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Roboto",
                    fontStyle: FontStyle.normal,
                    fontSize: 12),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(child: Container()),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                          "${context.l10n.from.capitalized} :",
                          style: const TextStyle(
                              color: LongaColor.black_four,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 12),
                          textAlign: TextAlign.left),
                      Text(
                          "${context.watch<DateSelectorBloc>().fromDate}",
                          style: const TextStyle(
                              color: LongaColor.black_four,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 12),
                          textAlign: TextAlign.left),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                          "${context.l10n.to.capitalized} :",
                          style: const TextStyle(
                              color: LongaColor.black_four,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 12),
                          textAlign: TextAlign.left),
                      Text(
                          "${context.watch<DateSelectorBloc>().toDate}",
                          style: const TextStyle(
                              color: LongaColor.black_four,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 12),
                          textAlign: TextAlign.left),
                    ],
                  )
                ],
              )
            ],
          ).p(10),
        ));
  }
}
