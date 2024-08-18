import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/constant/longa_constant.dart';
import 'package:longa_lotto/common/show_snackbar.dart';
import 'package:longa_lotto/common/widget/longa_scaffold.dart';
import 'package:longa_lotto/common/widget/longa_text_field.dart';
import 'package:longa_lotto/common/widget/rounded_container.dart';
import 'package:longa_lotto/common/widget/shake_animation.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/profile/bloc/profile_bloc.dart';
import 'package:longa_lotto/profile/bloc/profile_event.dart';
import 'package:longa_lotto/profile/bloc/profile_state.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:longa_lotto/utils/utils.dart';
import 'package:velocity_x/velocity_x.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController mobController         = TextEditingController();
  TextEditingController firstNameController   = TextEditingController();
  TextEditingController lastNameController    = TextEditingController();
  TextEditingController addressController     = TextEditingController();
  TextEditingController emailController       = TextEditingController();
  TextEditingController dobController         = TextEditingController();
  ShakeController mobShakeController          = ShakeController();
  ShakeController firstNameShakeController    = ShakeController();
  ShakeController lastNameShakeController     = ShakeController();
  ShakeController addressShakeController      = ShakeController();
  ShakeController emailShakeController        = ShakeController();
  ShakeController dobShakeController          = ShakeController();
  final _registrationForm = GlobalKey<FormState>();

  bool isUpdateButtonPressed  = false;
  bool obscurePass            = true;
  bool obscureConfPass        = true;
  var autoValidate            = AutovalidateMode.disabled;

  double mAnimatedButtonSize = 250.0;
  bool mButtonTextVisibility = true;
  ButtonShrinkStatus mButtonShrinkStatus = ButtonShrinkStatus.notStarted;
  bool isMailSelect = true;
  Gender? selectedGender = Gender.Male;

  @override
  void initState() {
    super.initState();
    if (UserInfo.firstName != "NA") {
      firstNameController.text = UserInfo.firstName;
    }
    if (UserInfo.lastName != "NA") {
      lastNameController.text = UserInfo.lastName;
    }
    if (UserInfo.emailId != "NA") {
      emailController.text = UserInfo.emailId;
    }
    if (UserInfo.address != "NA") {
      addressController.text = UserInfo.address;
    }
    if (UserInfo.gender != "NA") {
      var gender      = UserInfo.gender;
      selectedGender  = (gender == "M") ? Gender.Male : Gender.Female;
      isMailSelect    = (gender == "M");
    }
    if (UserInfo.dob != "NA") {
      print("================>${UserInfo.dob}");
      dobController.text = UserInfo.dob.split(" ")[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (mContext, state) {

      if( state is EditProfileSuccess) {
        setState(() {
          mAnimatedButtonSize   = 250.0;
          mButtonTextVisibility = true;
          mButtonShrinkStatus   = ButtonShrinkStatus.over;
        });
        if(state.response != null) {
          Navigator.pop(this.context);
          ShowToast.showToast(context,context.l10n.your_profile_has_been_update_successfully, type: ToastType.SUCCESS);
        }

      } else if (state is EditProfileError) {
        ShowToast.showToast(context, state.errorMessage.toString(), type: ToastType.ERROR);
        setState(() {
          mAnimatedButtonSize   = 250.0;
          mButtonTextVisibility = true;
          mButtonShrinkStatus   = ButtonShrinkStatus.over;
        });

      } else if (state is EditProfileLoading) {
        setState(() {
          mAnimatedButtonSize   = 50.0;
          mButtonTextVisibility = false;
        });
      }
    },
      child: SafeArea(
      child: LongaScaffold(
          showAppBar: true,
          appBarTitle: context.l10n.edit_profile.toUpperCase(),
          extendBodyBehindAppBar: true,
          body: RoundedContainer(
              child: Form(
                  key: _registrationForm,
                  autovalidateMode: autoValidate,
                  child: CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          children: [
                            const HeightBox(15),
                            _firstNameTextField(),
                            _lastNameTextField(),
                            //_mobTextField(),
                            _emailTextField(),
                            _genderRadioField(),
                            _dobField(),
                            _addressTextField(),
                            const HeightBox(30),
                            _updateProfileButton(),
                          ],
                        ).p20(),
                      ),
                    ],
                  )
              )
          )
      ),
    )
    );
  }

  _firstNameTextField() {
    return ShakeWidget(
      controller: firstNameShakeController,
      child: LongaTextField(
        borderColor: LongaColor.white,
        autoFocus: true,
        maxLength: 15,
        hintText: context.l10n.first_name,
        controller: firstNameController,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
        ],
        prefix: const Icon(
          Icons.person_outline,
          color: LongaColor.darkish_purple,
        ),
        validator: (value) {
          var firstName = firstNameController.text;
          if (firstName.isEmpty) {
            if (isUpdateButtonPressed) {
              firstNameShakeController.shake();
            }
            return context.l10n.please_enter_first_name;
          } else if (firstName.length < 2 ){
            if (isUpdateButtonPressed) {
              firstNameShakeController.shake();
            }
            return context.l10n.please_enter_at_least_2_character;
          } else {
            return null;
          }
        },
      ).pSymmetric(v: 8),
    );
  }

  _lastNameTextField() {
    return ShakeWidget(
      controller: lastNameShakeController,
      child: LongaTextField(
        borderColor: LongaColor.white,
        autoFocus: true,
        maxLength: 15,
        hintText: context.l10n.last_name,
        controller: lastNameController,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
        ],
        prefix: const Icon(
          Icons.person_outline,
          color: LongaColor.darkish_purple,
        ),
        validator: (value) {
          var lastName = lastNameController.text;
          if(lastName.isEmpty) {
            if (isUpdateButtonPressed) {
              lastNameShakeController.shake();
            }
            return context.l10n.please_enter_last_name;
          }else if (lastName.length < 2 ){
            if (isUpdateButtonPressed) {
              lastNameShakeController.shake();
            }
            return context.l10n.please_enter_at_least_2_character;
          }  else {
            return null;
          }
        },
      ).pSymmetric(v: 8),
    );
  }

  _emailTextField() {
    return ShakeWidget(
      controller: emailShakeController,
      child: LongaTextField(
        borderColor: LongaColor.white,
        autoFocus: true,
        maxLength: 50,
        hintText: "${context.l10n.email}*",
        controller: emailController,
        inputType: TextInputType.emailAddress,
        prefix: const Icon(
          Icons.email_outlined,
          color: LongaColor.darkish_purple,
        ),
        validator: (value) {
          var email = emailController.text;
          if(email.isEmpty) {
            if (isUpdateButtonPressed) {
              emailShakeController.shake();
            }
            return context.l10n.please_enter_email_address;
          } else if (!RegExp("^[a-zA-Z0-9.a-zA-Z0-9.!#\$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]{2}").hasMatch(email)){
            if (isUpdateButtonPressed) {
              emailShakeController.shake();
            }
            return context.l10n.email_address_is_invalid;
          } else {
            return null;
          }
        },
      ).pSymmetric(v: 8),
    );
  }

  _genderRadioField() {
    return Container(
      height: 60.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: LongaColor.warm_grey,
        border: Border.all(color: LongaColor.warm_grey_three),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: LongaColor.black,
        ),
        child: Row(
          children: [
            Text(
              context.l10n.gender_with_star,
              style: const TextStyle(
                color: LongaColor.warm_grey_three,
                fontWeight: FontWeight.w400,
                fontSize: 20.0,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio<Gender>(
                  activeColor: ((isMailSelect) ? LongaColor.darkish_purple_two : LongaColor.warm_grey_three),
                  value: Gender.Male,
                  groupValue: selectedGender,
                  onChanged: (Gender? value) {
                    setState((){
                      isMailSelect = true;
                      selectedGender = Gender.Male;
                    });

                  },
                ),
                Text(
                  context.l10n.male, //"Male",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: ((isMailSelect) ? LongaColor.darkish_purple_two : LongaColor.warm_grey_three),
                    fontSize: 15,
                    fontWeight: (isMailSelect) ? FontWeight.w600 : FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio<Gender>(
                  activeColor: ((!isMailSelect) ? LongaColor.darkish_purple_two : LongaColor.warm_grey_three),
                  value: Gender.Female,
                  groupValue: selectedGender,
                  onChanged: (Gender? value) {
                    setState((){
                      isMailSelect = false;
                      selectedGender = Gender.Female;
                    });
                  },
                ),
                Text(
                  context.l10n.female, //"Female",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: ((!isMailSelect) ? LongaColor.darkish_purple_two : LongaColor.warm_grey_three) ,
                    fontSize: 15,
                    fontWeight: (!isMailSelect) ? FontWeight.w600 : FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ],
            ),
          ],
        ).pSymmetric(v: 8, h: 12),
      ),
    ).pSymmetric(v: 8);
  }

  _dobField() {
    return ShakeWidget(
      controller: dobShakeController,
      child: LongaTextField(
        autoFocus: true,
        maxLength: 15,
        controller: dobController,
        hintText: context.l10n.date_of_birth_with_star,
        isCalendar: true,
        prefix: const Icon(
          Icons.calendar_month_outlined,
          color: LongaColor.darkish_purple,
        ),
        validator: (value) {
          var dob = dobController.text.trim();
          if(dob.isEmpty) {
            dobShakeController.shake();
            return context.l10n.please_enter_date_of_birth;
          } else {
            return null;
          }
        },
      ).pSymmetric(v: 8),
    );
  }

  _addressTextField() {
    return ShakeWidget(
      controller: addressShakeController,
      child: LongaTextField(
        borderColor: LongaColor.white,
        autoFocus: true,
        maxLength: 199,
        minLine: 4,
        maxLine: 4,
        hintText: context.l10n.address,
        controller: addressController,
        inputType: TextInputType.streetAddress,
        prefix: const Icon(
          Icons.location_on_outlined,
          color: LongaColor.darkish_purple,
        ),
        validator: (value) {
          var address = addressController.text;
          if(address.isEmpty) {
            if (isUpdateButtonPressed) {
              addressShakeController.shake();
            }
            return context.l10n.please_enter_address;
          } else if (address.length < 2) {
            return context.l10n.address_can_contain_2_to_196_characters;
          }else {
            return null;
          }
        },
        // isDarkThemeOn: isDarkThemeOn,
      ).pSymmetric(v: 8),
    );
  }

  _updateProfileButton() {
    return AbsorbPointer(
      absorbing: !mButtonTextVisibility,
      child: InkWell(
        onTap: () {
          _updateProfile();
        },
        child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [LongaColor.butter_scotch, LongaColor.orangey_red,
                ]),
                borderRadius: BorderRadius.circular(67)
            ),
            child: AnimatedContainer(
              width: mAnimatedButtonSize,
              height: 50,
              onEnd: () {
                setState(() {
                  if (mButtonShrinkStatus != ButtonShrinkStatus.over) {
                    mButtonShrinkStatus = ButtonShrinkStatus.started;

                  } else {
                    mButtonShrinkStatus = ButtonShrinkStatus.notStarted;
                  }
                });
              },
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 200),
              child: SizedBox(
                width: mAnimatedButtonSize,
                height: 50,
                child: mButtonShrinkStatus == ButtonShrinkStatus.started
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(color: LongaColor.white_two),
                      )
                    : Center(child:
                        Visibility(
                          visible: mButtonTextVisibility,
                          child: Text(context.l10n.update.toUpperCase(),
                          style: TextStyle(fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: LongaColor.white_two,
                          ),
                          ),
                        ))
              ),
            )
        ),
      ),
    );
  }

  String validateInput(TotalTextFields textField) {
    switch (textField) {
      case TotalTextFields.mobileNumber:
        print("mb");
        var mobText = mobController.text.trim();
        if (mobText.isEmpty) {
          return 'enterMobileNumber';
        } else if (mobText.length > 16) {
          return 'enterValidMobNumber';
        }
        print("mb1");

        break;
      case TotalTextFields.oldPassword:
        // TODO: Handle this case.
        break;
      case TotalTextFields.password:
        // TODO: Handle this case.
        break;
      case TotalTextFields.confirmPassword:
        // TODO: Handle this case.
        break;
      case TotalTextFields.otp:
        // TODO: Handle this case.
        break;
      case TotalTextFields.userName:
        // TODO: Handle this case.
        break;
    }
    return "";
  }

  void _updateProfile() {
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {
      isUpdateButtonPressed = true;
    });
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        isUpdateButtonPressed = false;
      });
    });
    if (_registrationForm.currentState!.validate()) {
      BlocProvider.of<ProfileBloc>(context).add(
          EditProfile(
            context       : context,
            firstName     : firstNameController.text,
            lastName      : lastNameController.text,
            emailId       : emailController.text,
            addressLine1  : addressController.text,
            gender        : isMailSelect ? "M" : "F",
            dob           : dobController.text
          )
      );
      setState(() {
        mButtonTextVisibility = false;
        mAnimatedButtonSize = 50.0;
      });
    } else {
      setState(() {
         autoValidate = AutovalidateMode.onUserInteraction;
      });
    }
  }
}
