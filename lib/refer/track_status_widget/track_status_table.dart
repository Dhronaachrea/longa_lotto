part of 'track_status_widget.dart';

class TrackStatusTable extends StatelessWidget {
  final List<PlrTrackBonusList> plrTrackBonusList;
  final List<bool> selectedList;
  final Function(bool, int) onSelectChange;

  const TrackStatusTable({
    Key? key,
    required this.plrTrackBonusList,
    required this.selectedList,
    required this.onSelectChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<DataColumn> columns;
    List<DataRow> rows;
    var columnsTextStyle = const TextStyle(
      color: LongaColor.brownish_grey_six,
      fontWeight: FontWeight.w400,
      fontFamily: "SegoeUI",
      fontStyle: FontStyle.normal,
      fontSize: 18.0,
    );
    var rowTextStyle = TextStyle(
      color: LongaColor.brownish_grey_six,
      fontWeight: FontWeight.w400,
      fontFamily: "SegoeUI",
      fontStyle: FontStyle.normal,
      fontSize: 18.0,
    );
    columns = [
      DataColumn(
        label: Align(
          alignment: Alignment.center,
          child: Text(context.l10n.referDetails,
              style: columnsTextStyle, textAlign: TextAlign.left),
        ),
      ),
      DataColumn(
        label: Align(
          alignment: Alignment.center,
          child: Text(context.l10n.register,
              style: columnsTextStyle, textAlign: TextAlign.left),
        ),
      ),
      DataColumn(
        label: Align(
          alignment: Alignment.center,
          child: Text(context.l10n.addCash,
              style: columnsTextStyle, textAlign: TextAlign.left),
        ),
      ),
    ];
    rows = plrTrackBonusList
        .asMap()
        .map(
          (index, element) => MapEntry(
              element,
              DataRow(
                selected: selectedList[index],
                onSelectChanged: (value) {
                  log("value: $value");
                  onSelectChange(value ?? !selectedList[index], index);
                },
                cells: [
                  DataCell(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          element.emailId ?? context.l10n.email,
                          style: rowTextStyle,
                        ),
                        const HeightBox(5),
                        Opacity(
                          opacity: 0.6,
                          child: Text(
                            formatDate(
                                  date: element.referralDate!,
                                  inputFormat: Format.apiDateFormat,
                                  outputFormat: Format.trackStatusDateFormat,
                                ) ??
                                DateTime.now().toIso8601String(),
                            style: rowTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        element.register!
                            ? "assets/icons/icon_success.png"
                            : "assets/icons/icon_error.png",
                        width: 24,
                        height: 24,
                      ).p(20),
                    ),
                  ),
                  DataCell(
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        element.depositor!
                            ? "assets/icons/icon_success.png"
                            : "assets/icons/icon_error.png",
                        width: 20,
                        height: 20,
                      ).p(20),
                    ),
                  ),
                ],
              )),
        )
        .values
        .toList();

    return FittedBox(
      child: DataTable(
        dataRowHeight: 80,
        headingRowColor: MaterialStateColor.resolveWith(
          (states) => LongaColor.pale_grey_three,
        ),
        border: TableBorder.all(color: LongaColor.pale_grey_three, width: 2),
        columns: columns,
        rows: rows,
      ).px16(),
    );
  }
}
