
import 'package:flutter/cupertino.dart';
import 'package:longa_lotto/profile/model/response/UploadProfilePhotoResponse.dart';
import 'package:longa_lotto/profile/repository/profile_repository.dart';
import 'package:longa_lotto/utility/result.dart';

class UploadProfilePhotoLogic {
    static Future<Result<dynamic>> callUploadProfilePhotoApi(BuildContext context, Map<String, dynamic> request) async {
    dynamic jsonMap = await ProfileRepository.callUploadProfilePhotoApi(context, request);
    print("---> $jsonMap");
    try {
      var respObj = UploadProfilePhotoResponse.fromJson(jsonMap);
      if (respObj.errorCode == 0) {
        if (await isValidImageInUrl(context, "${respObj.avatarPath}" ?? "")) {
          return Result.responseSuccess(data: respObj);
        } else {
          return Result.failure(data: jsonMap);
        }

      } else {
        return jsonMap["occurredErrorDescriptionMsg"] != null ? jsonMap["occurredErrorDescriptionMsg"] == "No connection" ? Result.networkFault(data: jsonMap) : Result.failure(data: jsonMap) : Result.responseFailure(data: respObj);
      }

    } catch(e) {
      if(jsonMap["occurredErrorDescriptionMsg"] == "No connection") {
        return Result.networkFault(data: jsonMap);

      } else {
        return Result.failure(data: jsonMap["occurredErrorDescriptionMsg"] != null ? jsonMap : {"occurredErrorDescriptionMsg": e});
      }
    }
  }

  static Future<bool> isValidImageInUrl(BuildContext context,  String relativePath) async {
    dynamic jsonMap = await ProfileRepository.checkValidImageOnUrl(context, relativePath);
    return jsonMap["occurredErrorDescriptionMsg"] == "Valid Image Url Response data";
  }
}