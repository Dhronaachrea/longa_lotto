import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/show_snackbar.dart';
import 'package:longa_lotto/common/widget/alert/alert_dialog.dart';
import 'package:longa_lotto/common/widget/alert/alert_type.dart';
import 'package:longa_lotto/common/widget/longa_scaffold.dart';
import 'package:longa_lotto/common/widget/rounded_container.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/model/response/track_status_response.dart';
import 'package:longa_lotto/refer/bloc/refer_bloc.dart';
import 'package:longa_lotto/refer/track_status_widget/track_status_widget.dart';
import 'package:longa_lotto/utility/NetworkSingleton.dart';
import 'package:longa_lotto/utility/network_connection/network_bloc.dart';
import 'package:longa_lotto/utility/network_connection/network_state.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

import 'common/refer_bottom_button.dart';
import 'model/friend_contact_model.dart';

class TrackStatusScreen extends StatefulWidget {
  const TrackStatusScreen({Key? key}) : super(key: key);

  @override
  State<TrackStatusScreen> createState() => _TrackStatusScreenState();
}

class _TrackStatusScreenState extends State<TrackStatusScreen> {
  List<PlrTrackBonusList> plrTrackBonusList = [
    PlrTrackBonusList(register: false, depositor: true),
    PlrTrackBonusList(register: true, depositor: false)
  ];
  List<FriendContactModel?> friendContactList = [];
  List<bool> selectedList = [];
  bool afterNetGone = false;

  @override
  void initState() {
    NetworkSingleton().setNetworkListener(context);
    BlocProvider.of<ReferBloc>(context).add(TrackStatus(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NetworkBloc, NetworkState>(
      listener: (context, state) {
        if(state is NetWorkConnected) {
          setState(() {
            if (afterNetGone) {
              afterNetGone = false;
              ShowToast.showToast(context, context.l10n.internet_available, type: ToastType.SUCCESS);
              BlocProvider.of<ReferBloc>(context).add(TrackStatus(context: context));
            }
          });
        } else if(state is NetWorkNotConnected) {
          setState(() {
            afterNetGone = true;
          });
        }
      },
      child: LongaScaffold(
        appBarTitle: context.l10n.referAFriend.toUpperCase(),
        showAppBar: true,
        extendBodyBehindAppBar: true,
        body: RoundedContainer(
          child: BlocConsumer<ReferBloc, ReferState>(
            listener: (context, state) {
              if (state is Invited) {
                var response = state.response;
                Alert.show(
                  type: AlertType.success,
                  context: context,
                  title: context.l10n.success,
                  subtitle: context.l10n.an_invitation_email_will_be_sent_to_your_reference,
                  buttonText: context.l10n.ok.toUpperCase(),
                  isDarkThemeOn: false,
                  buttonClick: () {
                    Navigator.pop(context);
                  },
                );
              }
            },
            builder: (context, state) {
              if (state is TrackedStatus || state is SelectStatusState) {
                if (state is TrackedStatus) {
                  plrTrackBonusList = state.response.plrTrackBonusList!;
                  log("tracked status");
                  selectedList = plrTrackBonusList
                      .asMap()
                      .map((key, value) => MapEntry(
                            key,
                            false,
                          ))
                      .values
                      .toList();
                }
                return Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: plrTrackBonusList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: context.screenHeight / 3,
                                child: Lottie.asset(
                                  'assets/lottie/no_data.json',
                                ),
                              ),
                              Text(
                                context.l10n.noOrderToTrack,
                                style: const TextStyle(
                                  color: LongaColor.butterscotch,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              const HeightBox(20),
                              TrackStatusInformation(),
                              const HeightBox(20),
                              TrackStatusTable(
                                plrTrackBonusList: plrTrackBonusList,
                                selectedList: selectedList,
                                onSelectChange: (value, index) {
                                  selectedList[index] = value;
                                  context
                                      .read<ReferBloc>()
                                      .add(SelectStatus(context: context));
                                },
                              ),
                              const HeightBox(20),
                              ReferBottomButton(
                                title: context.l10n.send_reminder.toUpperCase(),
                                onTap: () {

                                  for (int i = 0; i < selectedList.length; i++) {
                                    if (selectedList[i]) {
                                      friendContactList.add(
                                        FriendContactModel(
                                          plrTrackBonusList[i].userName ?? "NA",
                                          plrTrackBonusList[i].emailId ?? "NA",
                                        ),
                                      );
                                    }
                                  }
                                  if (friendContactList.isEmpty) {
                                    ShowToast.showToast(context,
                                        context.l10n.please_select_some_user_to_invite,
                                        type: ToastType.ERROR);
                                  } else {
                                    context.read<ReferBloc>().add(InviteNow(
                                        context: context,
                                        contactDetails: friendContactList));
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                );
              } else if (state is TrackStatusError) {
                // var response = state.response;
                return Container();
              } else {
                return Center(
                  child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Lottie.asset('assets/lottie/gradient_loading.json')),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
