part of 'refer_widget.dart';

class ContactList extends StatelessWidget {
  final List<FriendContactModel?> friendContactList;
  final Function(FriendContactModel friendContactDetail) onRemove;

  const ContactList({
    Key? key,
    required this.friendContactList,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: DataTable(
        showBottomBorder: true,
        border: TableBorder.all(color: LongaColor.warm_grey_three, width: 1),
        columns: [
          DataColumn(
            label: Align(
              alignment: Alignment.center,
              child: Text(
                context.l10n.name,
                style: TextStyle(
                  color: LongaColor.brownish_grey_six,
                  fontWeight: FontWeight.w400,
                  fontFamily: "SegoeUI",
                  fontStyle: FontStyle.normal,
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          DataColumn(
            label: Align(
              alignment: Alignment.center,
              child: Text(
                context.l10n.email,
                style: TextStyle(
                  color: LongaColor.brownish_grey_six,
                  fontWeight: FontWeight.w400,
                  fontFamily: "SegoeUI",
                  fontStyle: FontStyle.normal,
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          DataColumn(
            label: Align(
              alignment: Alignment.center,
              child: Text(
                context.l10n.remove,
                style: TextStyle(
                  color: LongaColor.brownish_grey_six,
                  fontWeight: FontWeight.w400,
                  fontFamily: "SegoeUI",
                  fontStyle: FontStyle.normal,
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
        rows: friendContactList
            .map(
              (contactDetails) => DataRow(cells: [
                DataCell(
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      contactDetails!.name,
                      style: TextStyle(
                        color: LongaColor.brownish_grey_six,
                        fontWeight: FontWeight.w400,
                        fontFamily: "SegoeUI",
                        fontStyle: FontStyle.normal,
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                DataCell(
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      contactDetails.emailId,
                      style: TextStyle(
                        color: LongaColor.brownish_grey_six,
                        fontWeight: FontWeight.w400,
                        fontFamily: "SegoeUI",
                        fontStyle: FontStyle.normal,
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                DataCell(
                  InkWell(
                    onTap: () {
                      onRemove(contactDetails);
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/icons/icon_error.png",
                      ).p(8),
                    ),
                  ),
                ),
              ]),
            )
            .toList(),
      ).p(16),
    );
  }
}
