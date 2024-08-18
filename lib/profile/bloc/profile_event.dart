import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:longa_lotto/profile/model/request/GetBalanceRequest.dart';
import 'package:longa_lotto/profile/model/request/SendVerificationEmailRequest.dart';
import 'package:longa_lotto/profile/model/request/VerifyEmailWithOtpRequest.dart';

abstract class ProfileEvent {}

class EditProfile extends ProfileEvent {
  String firstName;
  String lastName;
  String emailId;
  String addressLine1;
  String dob;
  String gender;
  BuildContext context;

  EditProfile({required this.context, required this.firstName, required this.lastName,
    required this.emailId, required this.addressLine1, required this.dob, required this.gender});
}

class UploadProfilePhoto extends ProfileEvent {
  XFile mXFileDetails;
  BuildContext context;

  UploadProfilePhoto({required this.context, required this.mXFileDetails});
}

class SendVerificationEmailLink extends ProfileEvent {
  SendVerificationEmailRequest request;
  bool? isResendOtp;
  BuildContext context;

  SendVerificationEmailLink({required this.context, required this.request, this.isResendOtp});
}

class VerificationEmailOtp extends ProfileEvent {
  VerifyEmailWithOtpRequest request;
  BuildContext context;

  VerificationEmailOtp({required this.context, required this.request});
}

class GetBalance extends ProfileEvent {
  GetBalanceRequest request;
  BuildContext context;

  GetBalance({required this.context, required this.request});
}

class VerifyImageUrl extends ProfileEvent {
  BuildContext context;
  String imageUrl;

  VerifyImageUrl({required this.context, required this.imageUrl});
}
