
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:longa_lotto/common/constant/api_constant.dart';
import 'package:longa_lotto/common/constant/date_format.dart';
import 'package:longa_lotto/common/utils.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/profile/bloc/profile_event.dart';
import 'package:longa_lotto/profile/bloc/profile_state.dart';
import 'package:longa_lotto/profile/model/request/EditProfileRequest.dart';
import 'package:longa_lotto/profile/model/request/GetBalanceRequest.dart';
import 'package:longa_lotto/profile/model/response/EditProfileResponse.dart';
import 'package:longa_lotto/profile/model/request/UploadProfilePhotoRequest.dart';
import 'package:longa_lotto/profile/model/response/GetBalanceResponse.dart';
import 'package:longa_lotto/profile/model/response/SendVerificationEmailResponse.dart';
import 'package:longa_lotto/profile/model/response/UploadProfilePhotoResponse.dart';
import 'package:longa_lotto/profile/profile_logic_part/edit_profile_logic_part.dart';
import 'package:longa_lotto/profile/profile_logic_part/email_verify_logic_part.dart';
import 'package:longa_lotto/profile/profile_logic_part/upload_profile_photo_logic_part.dart';
import 'package:longa_lotto/sign_up/model/response/registration_response.dart';
import 'package:longa_lotto/utils/auth/auth_bloc.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:longa_lotto/utils/utils.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<EditProfile>(_onProfileEvent);
    on<UploadProfilePhoto>(_onUploadProfilePhotoEvent);
    on<SendVerificationEmailLink>(_onSendVerificationEmailLinkEvent);
    on<VerificationEmailOtp>(_onVerifyEmailOtpEvent);
    on<GetBalance>(_onGetBalanceEvent);
    on<VerifyImageUrl>(_verifyImageUrlEvent);
  }
}

_onProfileEvent(EditProfile event, Emitter<ProfileState> emit) async{
  emit(EditProfileLoading());

    BuildContext context  = event.context;
    String firstName      = event.firstName;
    String lastName       = event.lastName;
    String emailId        = event.emailId;
    String addressLine1   = event.addressLine1;
    String dob            = event.dob;
    String gender         = event.gender;
    print("==========>$dob");
    dob = formatDate(
              date: dob,
              inputFormat: Format.calendarFormat,
              outputFormat: Format.apiDateFormat3,
            );//1990-01-01
    var response = await EditProfileLogic.callEditProfileApi(context,
        EditProfileRequest(
          firstName         : firstName,
          lastName          : lastName,
          gender            : gender,
          dob               : dob,
          emailId           : emailId,
          addressLine1      : addressLine1,
          domainName        : AppConstants.domainName,
          merchantPlayerId  : UserInfo.userId
        ).toJson());

    try {
      response.when(idle: () {

      }, networkFault: (value) {
        emit(EditProfileError(errorMessage: context.l10n.not_internet_connection));

      }, responseSuccess: (value) {
        EditProfileResponse successResponse                 =   value as EditProfileResponse;
        var getSavedRegistrationData                        =   UserInfo.registrationData;
        Map<String, dynamic> jsonMap                        =   jsonDecode(getSavedRegistrationData);
        RegistrationResponse registrationResponse           =   RegistrationResponse.fromJson(jsonMap);

        registrationResponse.playerLoginInfo?.firstName     =   successResponse.data?.playerInfo?.firstName  ?? null;
        registrationResponse.playerLoginInfo?.lastName      =   successResponse.data?.playerInfo?.lastName   ?? null;
        registrationResponse.playerLoginInfo?.emailId       =   successResponse.data?.playerMaster?.emailId  ?? null;
        registrationResponse.playerLoginInfo?.addressLine1  =   successResponse.data?.playerInfo?.addressOne ?? null;
        registrationResponse.playerLoginInfo?.dob           =   successResponse.data?.playerInfo?.dateOfBirth?.replaceAll("-", "/") ?? null;
        registrationResponse.playerLoginInfo?.gender        =   successResponse.data?.playerInfo?.gender ?? null;
        registrationResponse.playerLoginInfo?.emailVerified =   successResponse.data?.playerVerificationStatus?.emailVerified ?? null;

        BlocProvider.of<AuthBloc>(context).add(
          UpdateUserInfo(registrationResponse: registrationResponse),
        );
        emit(EditProfileSuccess(response: successResponse));

      }, responseFailure: (value) {
        EditProfileResponse errorResponse = value as EditProfileResponse;
        print("bloc responseFailure: ${errorResponse.errorCode}, ${value.errorMessage}");
        emit(EditProfileError(errorMessage: fetchResponseCodeMsg(context, ApiFamily.RAM, errorResponse.errorCode)));
        //emit(EditProfileError(errorMessage: errorResponse.errorMessage ?? context.l10n.something_went_wrong_while_extracting_response));

      }, failure: (value) {
        print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
        if (value["occurredErrorDescriptionMsg"].toString().contains("SocketException")) {
          emit(EditProfileError(errorMessage: context.l10n.not_internet_connection));
        } else {
          emit(EditProfileError(errorMessage: value["occurredErrorDescriptionMsg"] ?? context.l10n.something_went_wrong));
        }
      });

    } catch(e) {
      print("error=========> $e");
      emit(EditProfileError(errorMessage: context.l10n.technical_issue_please_try_again));
    }

}

_onUploadProfilePhotoEvent(UploadProfilePhoto event, Emitter<ProfileState> emit) async{
  emit(EditProfileLoading());

    BuildContext context  = event.context;
    XFile mXFileDetails   = event.mXFileDetails;

    var response = await UploadProfilePhotoLogic.callUploadProfilePhotoApi(context,
        UploadProfilePhotoRequest(
          playerId          : UserInfo.userId,
          playerToken       : UserInfo.userToken,
          domainName        : AppConstants.domainName,
          isDefaultAvatar   : "N",
          file              : await MultipartFile.fromFile(mXFileDetails.path, filename: mXFileDetails.name),
        ).toJson());

    try {
      response.when(idle: () {

      }, networkFault: (value) {
        emit(UploadProfilePhotoError(errorMessage: value["occurredErrorDescriptionMsg"]));

      }, responseSuccess: (value) {
        UploadProfilePhotoResponse successResponse            =   value as UploadProfilePhotoResponse;
        var getSavedRegistrationData                          =   UserInfo.registrationData;
        Map<String, dynamic> jsonMap                          =   jsonDecode(getSavedRegistrationData);
        RegistrationResponse registrationResponse             =   RegistrationResponse.fromJson(jsonMap);

        if (successResponse.avatarPath != null) {
          registrationResponse.playerLoginInfo?.avatarPath    =   successResponse.avatarPath?.split(UserInfo.registrationResponse?.playerLoginInfo?.commonContentPath ?? "")[1];
        }

        BlocProvider.of<AuthBloc>(context).add(
          UpdateUserInfo(registrationResponse: registrationResponse),
        );
        emit(UploadProfilePhotoSuccess(response: successResponse));

      }, responseFailure: (value) {
        UploadProfilePhotoResponse errorResponse = value as UploadProfilePhotoResponse;
        print("bloc responseFailure: ${errorResponse.errorCode}, ${value.respMsg}");
        emit(UploadProfilePhotoError(errorMessage: fetchResponseCodeMsg(context, ApiFamily.WEAVER, errorResponse.errorCode)));
        //emit(UploadProfilePhotoError(errorMessage: errorResponse.respMsg ?? context.l10n.something_went_wrong_while_extracting_response));

      }, failure: (value) {
        print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
        if (value["occurredErrorDescriptionMsg"].toString().contains("SocketException")) {
          emit(UploadProfilePhotoError(errorMessage: context.l10n.not_internet_connection,));
        } else {
          emit(UploadProfilePhotoError(errorMessage: value["occurredErrorDescriptionMsg"] ?? context.l10n.something_went_wrong));
        }
      });

    } catch(e) {
      print("error=========> $e");
      emit(UploadProfilePhotoError(errorMessage: "${context.l10n.technical_issue_please_try_again} $e"));
    }

}

_onSendVerificationEmailLinkEvent(SendVerificationEmailLink event, Emitter<ProfileState> emit) async{
    BuildContext context  = event.context;
    bool isResendOtp      = event.isResendOtp ?? false;

    var response = await EmailVerifyLogic.callSendVerificationEmailApi(context, event.request.toJson());

    try {
      response.when(idle: () {

      }, networkFault: (value) {
        emit(SendVerificationEmailError(errorMessage: value["occurredErrorDescriptionMsg"]));

      }, responseSuccess: (value) {
        SendVerificationEmailResponse successResponse  =   value as SendVerificationEmailResponse;
        successResponse.errorMessage = fetchResponseCodeMsg(context, ApiFamily.RAM, successResponse.errorCode);
        emit(SendVerificationEmailSuccess(response: successResponse, isResendOtp: isResendOtp));

      }, responseFailure: (value) {
        SendVerificationEmailResponse errorResponse = value as SendVerificationEmailResponse;
        print("bloc responseFailure: ${errorResponse.errorCode}, ${value.errorMessage}");
        emit(SendVerificationEmailError(errorMessage: fetchResponseCodeMsg(context, ApiFamily.RAM, errorResponse.errorCode)));
        //emit(SendVerificationEmailError(errorMessage: errorResponse.errorMessage ?? context.l10n.something_went_wrong_while_extracting_response));

      }, failure: (value) {
        print("bloc failure: ${value  }");
        if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
          emit(SendVerificationEmailError(errorMessage: context.l10n.not_internet_connection,));
        } else {
          emit(SendVerificationEmailError(errorMessage: value["occurredErrorDescriptionMsg"] ?? context.l10n.something_went_wrong));
        }
      });

    } catch(e) {
      print("error=========> $e");
      emit(SendVerificationEmailError(errorMessage: "${context.l10n.technical_issue_please_try_again} $e"));
    }

}

_onVerifyEmailOtpEvent(VerificationEmailOtp event, Emitter<ProfileState> emit) async{
  BuildContext context  = event.context;

  var response = await EmailVerifyLogic.callVerifyEmailWithOtpApi(context, event.request.toJson());

  try {
    response.when(idle: () {

    }, networkFault: (value) {
      emit(VerifyEmailWithOtpError(errorMessage: value["occurredErrorDescriptionMsg"]));

    }, responseSuccess: (value) {
      SendVerificationEmailResponse successResponse  =   value as SendVerificationEmailResponse;
      successResponse.errorMessage = fetchResponseCodeMsg(context, ApiFamily.RAM, successResponse.errorCode);
      emit(VerifyEmailWithOtpSuccess(response: successResponse));

    }, responseFailure: (value) {
      SendVerificationEmailResponse errorResponse = value as SendVerificationEmailResponse;
      print("bloc responseFailure: ${errorResponse.errorCode}, ${value.errorMessage}");
      emit(VerifyEmailWithOtpError(errorMessage: fetchResponseCodeMsg(context, ApiFamily.RAM, errorResponse.errorCode)));
      //emit(VerifyEmailWithOtpError(errorMessage: errorResponse.errorMessage ?? context.l10n.something_went_wrong_while_extracting_response));

    }, failure: (value) {
      print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
      if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
        emit(VerifyEmailWithOtpError(errorMessage: context.l10n.not_internet_connection,));
      } else {
        emit(VerifyEmailWithOtpError(errorMessage: value["occurredErrorDescriptionMsg"] ?? context.l10n.something_went_wrong));
      }
    });

  } catch(e) {
    print("error=========> $e");
    emit(VerifyEmailWithOtpError(errorMessage: "${context.l10n.technical_issue_please_try_again} $e"));
  }

}

_onGetBalanceEvent(GetBalance event, Emitter<ProfileState> emit) async{
  BuildContext context  = event.context;
  GetBalanceRequest request = event.request;

  var response = await EmailVerifyLogic.callGetBalanceApi(context, request.toJson());

  try {
    response.when(idle: () {

    }, networkFault: (value) {
      emit(GetBalanceError(errorMessage: value["occurredErrorDescriptionMsg"]));

    }, responseSuccess: (value) {
      GetBalanceResponse successResponse  =   value as GetBalanceResponse;
      emit(GetBalanceSuccess(response: successResponse));

    }, responseFailure: (value) {
      GetBalanceResponse errorResponse = value as GetBalanceResponse;
      print("bloc responseFailure: ${errorResponse.errorCode}, ${value.respMsg}");
      emit(GetBalanceError(errorMessage: fetchResponseCodeMsg(context, ApiFamily.WEAVER, errorResponse.errorCode)));
      //emit(GetBalanceError(errorMessage: errorResponse.respMsg ?? context.l10n.something_went_wrong_while_extracting_response));

    }, failure: (value) {
      print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
      if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
        emit(GetBalanceError(errorMessage: context.l10n.not_internet_connection,));
      } else {
        emit(GetBalanceError(errorMessage: value["occurredErrorDescriptionMsg"] ?? context.l10n.something_went_wrong));
      }
    });

  } catch(e) {
    print("error=========> $e");
    emit(GetBalanceError(errorMessage: "${context.l10n.technical_issue_please_try_again} $e"));
  }

}

_verifyImageUrlEvent(VerifyImageUrl event, Emitter<ProfileState> emit) async{
  emit(VerifyImageUrlLoading());
  BuildContext context = event.context;
  String imageUrl = event.imageUrl;
  print("-"*10);
  var isImageUrlValid = await UploadProfilePhotoLogic.isValidImageInUrl(context, imageUrl);
  log("isImageUrlValid bloc ------------->>------- $isImageUrlValid");
  if  (isImageUrlValid) {
    emit(VerifyImageUrlSuccess(isImageUrlValid: isImageUrlValid));

  } else {
    emit(VerifyImageUrlError(isImageUrlValid: isImageUrlValid));

  }


}


