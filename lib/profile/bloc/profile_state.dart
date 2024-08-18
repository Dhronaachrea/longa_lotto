import 'package:longa_lotto/profile/model/response/EditProfileResponse.dart';
import 'package:longa_lotto/profile/model/response/GetBalanceResponse.dart';
import 'package:longa_lotto/profile/model/response/SendVerificationEmailResponse.dart';
import 'package:longa_lotto/profile/model/response/UploadProfilePhotoResponse.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class EditProfileLoading extends ProfileState{}

class EditProfileSuccess extends ProfileState{
  EditProfileResponse? response;

  EditProfileSuccess({required this.response});

}
class EditProfileError extends ProfileState{
  String errorMessage;

  EditProfileError({required this.errorMessage});
}

class UploadProfilePhotoLoading extends ProfileState{}

class UploadProfilePhotoSuccess extends ProfileState{
  UploadProfilePhotoResponse? response;

  UploadProfilePhotoSuccess({required this.response});

}
class UploadProfilePhotoError extends ProfileState{
  String errorMessage;

  UploadProfilePhotoError({required this.errorMessage});
}

//////////////////// Email Verifying ////////////////////////////
class SendVerificationEmailSuccess extends ProfileState{
  SendVerificationEmailResponse response;
  bool isResendOtp;
  SendVerificationEmailSuccess({required this.response, required this.isResendOtp});

}
class SendVerificationEmailError extends ProfileState{
  String errorMessage;
  SendVerificationEmailError({required this.errorMessage});
}

class VerifyEmailWithOtpSuccess extends ProfileState{
  SendVerificationEmailResponse response;
  VerifyEmailWithOtpSuccess({required this.response});

}
class VerifyEmailWithOtpError extends ProfileState{
  String errorMessage;
  VerifyEmailWithOtpError({required this.errorMessage});
}

///////////////////////////// Get Balance ///////////////////////////

class GetBalanceSuccess extends ProfileState{
  GetBalanceResponse response;
  GetBalanceSuccess({required this.response});

}
class GetBalanceError extends ProfileState{
  String errorMessage;
  GetBalanceError({required this.errorMessage});
}

class VerifyImageUrlLoading extends ProfileState {}

class VerifyImageUrlSuccess extends ProfileState {
  bool isImageUrlValid;

  VerifyImageUrlSuccess({required this.isImageUrlValid});
}

class VerifyImageUrlError extends ProfileState {
  bool isImageUrlValid;

  VerifyImageUrlError({required this.isImageUrlValid});
}


