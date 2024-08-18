import 'package:flutter/cupertino.dart';
import 'package:longa_lotto/common/constant/api_urls_constant.dart';
import 'package:longa_lotto/network/api_call.dart';

class TransactionRepository {

  static dynamic callTransactionDetailApi(BuildContext context, Map<String, dynamic> request) async =>
      await CallApi.callApi(BaseUrlEnum.weaverBaseUrl, MethodType.post, ApiUrlsConstant.transactionDetailsUrl, requestBody: request, contentType: contentTypeMap[ContentTypeLabel.json] ?? "NA");
}