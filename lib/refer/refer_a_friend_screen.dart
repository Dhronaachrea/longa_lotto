import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/navigation/longa_screen.dart';
import 'package:longa_lotto/common/show_snackbar.dart';
import 'package:longa_lotto/common/utils.dart';
import 'package:longa_lotto/common/widget/alert/alert_dialog.dart';
import 'package:longa_lotto/common/widget/alert/alert_type.dart';
import 'package:longa_lotto/common/widget/longa_button.dart';
import 'package:longa_lotto/common/widget/longa_scaffold.dart';
import 'package:longa_lotto/common/widget/rounded_container.dart';
import 'package:longa_lotto/common/widget/shake_animation.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/refer/bloc/refer_bloc.dart';
import 'package:longa_lotto/refer/refer_widget/refer_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

import 'common/refer_bottom_button.dart';
import 'model/friend_contact_model.dart';

class ReferAFriend extends StatefulWidget {
  const ReferAFriend({Key? key}) : super(key: key);

  @override
  State<ReferAFriend> createState() => _ReferAFriendState();
}

class _ReferAFriendState extends State<ReferAFriend> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final ShakeController nameShakeController = ShakeController();
  final ShakeController emailShakeController = ShakeController();
  List<FriendContactModel?> friendContactList = [];
  List<FriendContactModel?> friendContactList1 = [];
  bool isInviting = false;

  @override
  void dispose() {
    nameShakeController.dispose();
    emailShakeController.dispose();
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LongaScaffold(
      appBarTitle: context.l10n.referAFriend.toUpperCase(),
      showAppBar: true,
      extendBodyBehindAppBar: true,
      body: AbsorbPointer(
        absorbing: isInviting,
        child: Stack(
          children:[
              RoundedContainer(
                child: Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: SingleChildScrollView(
                    child: BlocListener<ReferBloc, ReferState>(
                        listener: (_, state) {
                          if (state is Invited) {
                            var response = state.response;
                            setState(() {
                              isInviting = false;
                              friendContactList.clear();
                              nameController.clear();
                              emailController.clear();
                            });
                            Alert.show(
                              type: AlertType.success,
                              context: context,
                              title: context.l10n.success,
                              subtitle: context.l10n.thanks_for_the_references_an_invitation_email,
                              buttonText: context.l10n.ok.toUpperCase(),
                              isDarkThemeOn: false,
                              buttonClick: () {
                                print("-------------------> track_status_screen");
                                Navigator.of(context).pop();
                              },
                            );
                          }
                          else if (state is InvitationError) {
                            var errorMsg = state.errorMsg;
                            setState(() {
                              isInviting = false;
                            });
                            Alert.show(
                              type: AlertType.error,
                              context: context,
                              title: context.l10n.error,
                              subtitle: errorMsg,
                              buttonText: context.l10n.ok.toUpperCase(),
                              isDarkThemeOn: false,
                              buttonClick: () {
                                print("-----------------error--> track_status_screen");

                              },
                            );
                          } else if(state is Inviting) {
                            print("-------------------------------------------------------------------------------------->>");
                            setState(() {
                              isInviting = true;
                            });
                          }
                        },
                        child: Column(
                          children: [
                            const HeightBox(20),
                            InformationText(),
                            const HeightBox(30),
                            ReferralCode(),
                            const HeightBox(20),
                            ReferralLink(),
                            const HeightBox(20),
                            OrWidget(),
                            const HeightBox(20),
                            ChooseHowToInvite(),
                            const HeightBox(20),
                            SharingOption(),
                            const HeightBox(20),
                            OrWidget(),
                            const HeightBox(20),
                            InviteManually(),
                            const HeightBox(20),
                            friendContactList.isEmpty
                                ? const SizedBox()
                                : ContactList(
                              friendContactList: friendContactList,
                              onRemove: (contactDetails) {
                                setState(() {
                                  friendContactList.remove(contactDetails);
                                });
                              },
                            ),
                            InviteManuallyDetails(
                              nameShakeController: nameShakeController,
                              emailShakeController: emailShakeController,
                              nameController: nameController,
                              emailController: emailController,
                            ),
                            const HeightBox(20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SecondaryButton(
                                  borderRadius: 80,
                                  borderColor: LongaColor.darkish_purple,
                                  textColor: LongaColor.darkish_purple,
                                  width: context.screenWidth * 0.4,
                                  text: context.l10n.addMore,
                                  onPressed: () {
                                    var emailId = emailController.text;
                                    var name = nameController.text;
                                    log("email ID: $emailId");
                                    log("name : $name");
                                    if (!verifyEmail(emailId)) {
                                      ShowToast.showToast(context, context.l10n.validEmailText,
                                          type: ToastType.ERROR);
                                      log(context.l10n.validEmailText);
                                      emailShakeController.shake();
                                    } else if (name.isEmpty) {
                                      ShowToast.showToast(context, context.l10n.validNameText,
                                          type: ToastType.ERROR);
                                      log(context.l10n.validNameText);
                                      nameShakeController.shake();
                                    } else {
                                      nameController.clear();
                                      emailController.clear();
                                      setState(() {
                                        friendContactList
                                            .add(FriendContactModel(name, emailId));
                                      });
                                    }
                                  },
                                ),
                                PrimaryButton(
                                    textColor: LongaColor.white,
                                    borderRadius: 80,
                                    width: context.screenWidth * 0.4,
                                    fillDisableColor: LongaColor.orangey_red_two,
                                    text: context.l10n.inviteNow,

                                    onPressed: () {
                                      if (!isInviting) {
                                        /*setState(() {
                                          isInviting = true;
                                        });*/
                                        var emailId = emailController.text;
                                        var name = nameController.text;
                                        log("email ID: $emailId");
                                        log("name : $name");
                                        if (friendContactList.isEmpty && !verifyEmail(emailId)) {
                                          print("11111111111111");
                                          ShowToast.showToast(context, context.l10n.validEmailText,
                                              type: ToastType.ERROR);
                                          emailShakeController.shake();
                                        } else if (friendContactList.isEmpty && name.isEmpty) {
                                          ShowToast.showToast(context, context.l10n.validNameText,
                                              type: ToastType.ERROR);
                                          nameShakeController.shake();
                                        } else {
                                          if(verifyEmail(emailId) && name.isNotEmpty){
                                            friendContactList1.add(FriendContactModel(name, emailId));
                                            BlocProvider.of<ReferBloc>(context).add(InviteNow(context: context,
                                                contactDetails: friendContactList1));
                                          }
                                          else
                                          {
                                            BlocProvider.of<ReferBloc>(context).add(InviteNow(context: context,
                                                contactDetails: friendContactList));
                                          }
                                        }
                                      }

                                    }
                                ),
                              ],
                            ),
                            const HeightBox(20),
                            ReferInformationText(),
                            const HeightBox(20),
                            ReferBottomButton(
                              title: context.l10n.trackStatus.toUpperCase(),
                              onTap: () {
                                Navigator.pushNamed(context, LongaScreen.trackStatusScreen);
                              },
                            ),
                          ],
                        )
                    ),
                  ),
                ),
              ),
            Visibility(
              visible: isInviting,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: LongaColor.black.withOpacity(0.7),
                child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                        width: 70,
                        height: 70,
                        child: Lottie.asset('assets/lottie/gradient_loading.json'))),
              ),
            )
          ]
        ),
      ),
    );
  }
}
