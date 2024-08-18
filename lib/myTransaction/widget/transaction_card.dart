import 'package:flutter/material.dart';
import 'package:longa_lotto/common/constant/date_format.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/utils.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/myTransaction/model/response/transaction_response.dart';
import 'package:longa_lotto/utils/utils.dart';

import '../../utils/user_info.dart';

class TransactionCard extends StatelessWidget {
  final Size size;
  final TxnList txnDetails;

  const TransactionCard(this.size, {required this.txnDetails, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String txnDate = formatDate(
      date: txnDetails.transactionDate.toString(),
      inputFormat: Format.apiDateFormat2,
      outputFormat: Format.apiDateFormat_with_time,
    );
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                    child: Container(
                      width: 35,
                      height: 35,
                      child: Stack(
                        children: [
                          Image.asset("assets/icons/transaction_rectangle.png"),
                          Center(
                            child: Container(
                                width: 20,
                                height: 20,
                                child: Image.asset(
                                    "assets/icons/transaction_wallet.png")),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Text(
                          getWhichTrxType(context, txnDetails.txnType.toString()),
                          overflow: TextOverflow.visible,
                          maxLines: 3,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        child: Text(
                          txnDetails.particular.toString(),
                          style: const TextStyle(
                            color: LongaColor.black_four,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Roboto",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            context.l10n.txn_id,
                            style: const TextStyle(
                              color: LongaColor.black_four,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            txnDetails.transactionId.toString(),
                            style: const TextStyle(
                              color: LongaColor.black_four,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      Text(
                        txnDate,
                        style: const TextStyle(
                          color: LongaColor.black_four,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle: FontStyle.normal,
                          fontSize: 13.5,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        txnDetails.creditAmount != null
                            ? Text(
                                UserInfo.currencyDisplayCode +
                                    " " +
                    removeDecimalValueAndFormat("${double.parse(
                        txnDetails.creditAmount.toString())
                        .toStringAsFixed(2)
                        .replaceFirst(RegExp(r'\.?0*$'), '')}"),
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                              )
                            : Text(
                                UserInfo.currencyDisplayCode +
                                    " " +
                                  removeDecimalValueAndFormat("${double.parse(
                                      txnDetails.debitAmount.toString())
                                      .toStringAsFixed(2)
                                      .replaceFirst(RegExp(r'\.?0*$'), '')}"),
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                              ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: Text(
                            context.l10n.balance_amt,
                            style: const TextStyle(
                              color: LongaColor.black_four,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            UserInfo.currencyDisplayCode +
                                " " +
                                removeDecimalValueAndFormat("${double.parse(txnDetails.balance!.toString())
                                    .toStringAsFixed(2)
                                    .replaceFirst(RegExp(r'\.?0*$'), '')}"),
                            style: const TextStyle(
                              color: LongaColor.black_four,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 13.5,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
            //line below tab bar
          ),
          color: LongaColor.pale_grey_three,
        ),
      ),
    );
  }
}
