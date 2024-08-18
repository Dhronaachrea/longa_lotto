import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/constant/api_urls_constant.dart';
import 'package:longa_lotto/common/navigation/longa_screen.dart';
import 'package:longa_lotto/common/utils.dart';
import 'package:longa_lotto/login/bloc/login_bloc.dart';
import 'package:longa_lotto/login/login_screen.dart';
import 'package:longa_lotto/utility/network_utils.dart';
import 'package:longa_lotto/utils/user_info.dart';

enum MethodType{get, post, put, patch, delete}

enum ContentTypeLabel{json, multipart}
Map<ContentTypeLabel, String> contentTypeMap = {
  ContentTypeLabel.json      : "application/json",
  ContentTypeLabel.multipart : "multipart/form-data"
};

class CallApi {
  static Future<dynamic> callApi(BaseUrlEnum baseUrl, MethodType methodType, String relativeUrl, {String contentType = "application/json", Map<String, dynamic>? requestBody, Map<String, dynamic>?  params, Map<String, dynamic>? headers, int? pathId}) async {
    var dioObj = Dio();
    if (!await dioObj.isNetworkConnected()) {
      return {"occurredErrorDescriptionMsg": "No connection"};
    }

    dioObj.options.baseUrl = baseUrlMap[baseUrl] ?? "NA";
    dioObj.options.connectTimeout = 30000;
    dioObj.options.receiveTimeout = 30000;

    dioObj.interceptors.add(
        LogInterceptor(
            requestBody: true,
            requestHeader: true,
            responseBody: true,
            responseHeader: true,
            logPrint: (object) {
              log(object.toString());
            },
        )
    );
    Response response;
    try {
      switch(methodType) {
        case MethodType.get : {
          params != null
              ? response = await dioObj.get(relativeUrl, queryParameters: params,
              options: Options(
              headers: headers,
              contentType: contentType
              )
          )
              : pathId != null
              ? response = await dioObj.get("$relativeUrl/$pathId")
              : response = await dioObj.get(relativeUrl);

          break;
        }

        case MethodType.post:
          if (contentType == contentTypeMap[ContentTypeLabel.multipart]) {
            final formData = FormData.fromMap(requestBody ?? {});
            response = await dioObj.post(relativeUrl,
              options: Options(
                  headers: headers,
                  contentType: contentType
              ),
              data: formData,
            );

          } else {
            response = await dioObj.post(relativeUrl,
              options: Options(
                  headers: headers,
                  contentType: contentType
              ),
              data: jsonEncode(requestBody),
            );
          }

          break;

        case MethodType.put:
          pathId != null
              ?
          response = await dioObj.put("$relativeUrl/$pathId",
            options: Options(
                headers: headers,
                contentType: contentType
            ),
            data: jsonEncode(requestBody),
          )
              :
          response = await dioObj.put(relativeUrl,
              options: Options(
                  headers: headers,
                  contentType: contentType
              ),
              data: jsonEncode(requestBody),
              queryParameters: params,
          );
          break;

        case MethodType.patch:
          pathId != null
              ?
          response = await dioObj.patch("$relativeUrl/$pathId",
            options: Options(
                headers: headers,
                contentType: contentType
            ),
            data: jsonEncode(requestBody),
          )
              :
          response = await dioObj.patch(relativeUrl,
              options: Options(
                  headers: headers,
                  contentType: contentType
              ),
              data: jsonEncode(requestBody),
              queryParameters: params
          );
          break;

        case MethodType.delete:
          pathId != null
              ?
          response = await dioObj.delete("$relativeUrl/$pathId",
              options: Options(
                  headers: headers,
                  contentType: contentType
              )
          )
              :
          response = await dioObj.delete(relativeUrl,
              options: Options(
                  headers: headers,
                  contentType: contentType
              ),
              data: jsonEncode(requestBody),
              queryParameters: params
          );
          break;
      }
      log("response.baseUrl: ${response.requestOptions.baseUrl}");
      if (response.statusCode == 200 && response.data != null) {
        try {
          if ( response.requestOptions.baseUrl.contains("cashier")) {
            if (response.data["errorCode"] == 1109) { // session expire for cashier
              BuildContext? context = navigatorKey.currentContext;
              UserInfo.logout();
              if (context != null) {
                Navigator.of(context).popUntil((route) => false);
                Navigator.of(context).pushNamed(LongaScreen.homeScreen);
                showDialog(
                    context: context,
                    builder: (context) => BlocProvider<LoginBloc>(
                      create: (context) => LoginBloc(),
                      child: const LoginScreen(),
                    )
                );
              }
            }
          } else {
            if (response.data["errorCode"] == 203) { // session expire
              BuildContext? context = navigatorKey.currentContext;
              UserInfo.logout();
              if (context != null) {
                Navigator.of(context).popUntil((route) => false);
                Navigator.of(context).pushNamed(LongaScreen.homeScreen);
                showDialog(
                    context: context,
                    builder: (context) => BlocProvider<LoginBloc>(
                      create: (context) => LoginBloc(),
                      child: const LoginScreen(),
                    )
                );
              }
            }
          }
          return response.data;

        } catch (e) {
          if (baseUrl == BaseUrlEnum.profileImageBaseUrl && response.data is String) {
            return {"occurredErrorDescriptionMsg": "Valid Image Url Response data"};
          }
          return {"occurredErrorDescriptionMsg": "Might be response data is invalid"};

        }
      } else {
        return {"occurredErrorDescriptionMsg": "Might be status code is not success or response data is null"};
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        log("------------ DioError Exception e: connectTimeout: ${e.error} --------------");
      }
      if (e.type == DioErrorType.receiveTimeout) {
        log("------------ DioError Exception e: receiveTimeout: ${e.error} --------------");
      }
      log("------------ DioError Exception e: ${e.error} --------------");

      return {"occurredErrorDescriptionMsg": e.error};
    }
  }
}
