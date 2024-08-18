part of "ticket_widget.dart";
class TicketCard extends StatelessWidget {
  final int index;
  final List<TicketList> tickets;

  const TicketCard({Key? key, required this.index, required this.tickets})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String txnDate = formatDate(
      date: tickets[index].transactionDate.toString(),
      inputFormat: Format.apiDateFormat2,
      outputFormat: Format.apiDateFormat_with_time,
    );

    return SizedBox(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: (tickets[index].serviceCode?.toLowerCase().contains("dge") == true && tickets[index].gameId == "3")
                          ? Image.asset(
                      "assets/icons/my_tickets_game_image_1.png"
                  )
                          : Image.asset(
                      "assets/icons/my_tickets_game_image_${tickets[index].gameId}.png"
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tickets[index].gameName!,
                  style: TextStyle(
                    color: LongaColor.black_four,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Roboto",
                    fontStyle: FontStyle.normal,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.left,
                ),

                Text(
                  context.l10n.txn_id + tickets[index].refTxnNo.toString(),
                  style: const TextStyle(
                    color: LongaColor.black_four,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Roboto",
                    fontStyle: FontStyle.normal,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.left,
                ),

                Text(
                  txnDate,
                  style: const TextStyle(
                    color: LongaColor.black_four,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Roboto",
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.left,
                )
              ],
            ).pSymmetric(v: 16, h: 8),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  UserInfo.currencyDisplayCode +" "+
            removeDecimalValueAndFormat("${double.parse(tickets[index].amount!)
                .toStringAsFixed(2)
                .replaceFirst(RegExp(r'\.?0*$'), '')}")
                      ,
                  style: TextStyle(
                    color: LongaColor.black_four,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Roboto",
                    fontStyle: FontStyle.normal,
                    fontSize: 15.0,
                  ),
                  textAlign: TextAlign.center,
                ),

              ],
            ).pSymmetric(v: 16, h: 8),
          ),
        ],
      ).pSymmetric(h: 5),
    );
  }
}