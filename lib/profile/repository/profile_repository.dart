import 'package:flutter/cupertino.dart';
import 'package:longa_lotto/common/constant/api_urls_constant.dart';
import 'package:longa_lotto/network/api_call.dart';

class ProfileRepository {

  static dynamic callEditProfileApi(BuildContext context, Map<String, dynamic> request, Map<String, dynamic> header) async =>
      await CallApi.callApi(BaseUrlEnum.ramBaseUrl, MethodType.post, ApiUrlsConstant.overallUpdatePlayerProfile, requestBody: request, headers: header, contentType: contentTypeMap[ContentTypeLabel.multipart] ?? "NA");


  static dynamic callUploadProfilePhotoApi(BuildContext context, Map<String, dynamic> request) async =>
      await CallApi.callApi(BaseUrlEnum.weaverBaseUrl, MethodType.post, ApiUrlsConstant.uploadAvatar, requestBody: request, contentType: contentTypeMap[ContentTypeLabel.multipart] ?? "NA");

  static dynamic callSendVerificationEmailApi(BuildContext context, Map<String, dynamic> request, Map<String, dynamic> header) async =>
      await CallApi.callApi(BaseUrlEnum.ramBaseUrl, MethodType.post, ApiUrlsConstant.sendVerificationEmailLinkUrl, requestBody: request, headers: header);


  static dynamic callVerifyEmailOtpApi(BuildContext context, Map<String, dynamic> request, Map<String, dynamic> header) async =>
      await CallApi.callApi(BaseUrlEnum.ramBaseUrl, MethodType.post, ApiUrlsConstant.verifyEmailWithOtpUrl, requestBody: request, headers: header);

  static dynamic checkValidImageOnUrl(BuildContext context, String relativePath) async =>
      await CallApi.callApi(BaseUrlEnum.profileImageBaseUrl, MethodType.get, relativePath);

  static dynamic callGetBalanceApi(BuildContext context,  Map<String, dynamic> request) async =>
      await CallApi.callApi(BaseUrlEnum.weaverBaseUrl, MethodType.post, ApiUrlsConstant.getBalanceUrl, requestBody: request);

}