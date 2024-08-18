import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:longa_lotto/common/constant/api_constant.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/login/bloc/login_bloc.dart';
import 'package:longa_lotto/login/login_screen.dart';
import 'package:longa_lotto/profile/model/request/GetBalanceRequest.dart';
import 'package:longa_lotto/profile/model/request/SendVerificationEmailRequest.dart';
import 'package:longa_lotto/profile/profile_widget/profile_photo_options_bottom_sheet.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/constant/longa_constant.dart';
import 'package:longa_lotto/common/navigation/longa_screen.dart';
import 'package:longa_lotto/common/show_snackbar.dart';
import 'package:longa_lotto/common/widget/longa_scaffold.dart';
import 'package:longa_lotto/common/widget/rounded_container.dart';
import 'package:longa_lotto/common/widget/shake_animation.dart';
import 'package:longa_lotto/profile/bloc/profile_bloc.dart';
import 'package:longa_lotto/profile/bloc/profile_event.dart';
import 'package:longa_lotto/profile/bloc/profile_state.dart';
import 'package:longa_lotto/profile/widget/email_otp_dialog.dart';
import 'package:longa_lotto/profile/widget/scale_animation.dart';
import 'package:longa_lotto/sign_up/model/response/registration_response.dart';
import 'package:longa_lotto/utility/NetworkSingleton.dart';
import 'package:longa_lotto/utility/network_connection/network_bloc.dart';
import 'package:longa_lotto/utility/network_connection/network_state.dart';
import 'package:longa_lotto/utils/auth/auth_bloc.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:longa_lotto/utils/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

class MyProfileScreen extends StatefulWidget {
  final bool fromDashBoard;

  const MyProfileScreen({Key? key, this.fromDashBoard = false})
      : super(key: key);

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> with TickerProviderStateMixin {

  TextEditingController otpController = TextEditingController();
  ShakeController otpShakeController  = ShakeController();
  bool isOtpLoading = false;
  final ScaleController _balanceController = ScaleController();
  late final AnimationController _refreshBtnAnimationController;
  late final Animation<double> refreshBtnAnimation;

  var imageUrls = [
    'assets/images/deposit.svg',
    'assets/images/transaction.svg',
    'assets/images/msg.svg',
    'assets/images/refer_a_frnd.svg'
  ];

  var mProfilePhotoSelectionSource;
  XFile? mXFileDetails;
  late String mProfilePhotoUrl;
  bool isProfilePhotoUploadLoading          = false;
  bool isProfileManuallyUploading           = false;
  bool isProfileImageUrlFurnished           = false;
  bool isProfileImageUrlValid               = false;
  bool profilePicBottomSheetOpenRestricted  = false;
  bool afterNetGone                         = false;
  final List<String> imageExtensionList     = ["jpg", "png", "gif"];

  @override
  void initState() {
    super.initState();
    print("-> ${UserInfo.emailVerified}");
    _refreshBtnAnimationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    refreshBtnAnimation =
        Tween<double>(begin: 2, end: 1).animate(_refreshBtnAnimationController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              log("completed");
              _refreshBtnAnimationController.reset();
            } else if (status == AnimationStatus.dismissed) {
              log("dismissed");
              _refreshBtnAnimationController.forward();
            }
          });
    mProfilePhotoUrl = UserInfo.getProfilePhotoUrl;
    NetworkSingleton().setNetworkListener(context);
    BlocProvider.of<ProfileBloc>(context).add(VerifyImageUrl(context: context, imageUrl: mProfilePhotoUrl));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final List imageName = [context.l10n.deposit, context.l10n.myTransactions, context.l10n.inbox, context.l10n.referAFriend];
    var body = BlocListener<NetworkBloc, NetworkState>(
      listener: (context, state) {
        if(state is NetWorkConnected) {
          setState(() {
            if (afterNetGone) {
              afterNetGone = false;
              ShowToast.showToast(context, context.l10n.internet_available, type: ToastType.SUCCESS);
              BlocProvider.of<ProfileBloc>(context).add(VerifyImageUrl(context: context, imageUrl: mProfilePhotoUrl));
            }
          });
        } else if(state is NetWorkNotConnected) {
          setState(() {
            afterNetGone = true;
          });
        }
      },
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          setState(() {
            if (state is UploadProfilePhotoLoading) {
              isProfilePhotoUploadLoading = true;
            } else if (state is UploadProfilePhotoSuccess) {
              isProfilePhotoUploadLoading = false;
              isProfileManuallyUploading = false;
              isProfileImageUrlValid = true;
              mProfilePhotoUrl = UserInfo.getProfilePhotoUrl;
              PaintingBinding.instance.imageCache.clear();
              CachedNetworkImage.evictFromCache(UserInfo.getProfilePhotoUrl);
            } else if (state is UploadProfilePhotoError) {
              isProfilePhotoUploadLoading = false;
              ShowToast.showToast(context, state.errorMessage,
                  type: ToastType.ERROR);
            } else if (state is SendVerificationEmailSuccess) {
              isOtpLoading = false;
              if (!state.isResendOtp) {
                showGeneralDialog(
                    context: context,
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return Container();
                    },
                    transitionBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                        child) {
                      var curve = Curves.easeInOut.transform(animation.value);
                      return Transform.scale(
                        scale: curve,
                        child: EmailOtpDialog(),
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 400));
              }
              ShowToast.showToast(context, state.response.errorMessage.toString(),
                  type: ToastType.SUCCESS);
            } else if (state is SendVerificationEmailError) {
              isOtpLoading = false;
              ShowToast.showToast(context, state.errorMessage, type: ToastType.ERROR);
            } else if (state is GetBalanceSuccess) {
              _balanceController.scale(from: 0.3);
              _refreshBtnAnimationController.stop();
              var getBalanceResponse = state.response;
              var getSavedRegistrationData = UserInfo.registrationData;
              Map<String, dynamic> jsonMap = jsonDecode(getSavedRegistrationData);
              RegistrationResponse registrationResponse =
                  RegistrationResponse.fromJson(jsonMap);
              registrationResponse.playerLoginInfo?.walletBean?.cashBalance =
                  getBalanceResponse.wallet?.cashBalance;
              registrationResponse.playerLoginInfo?.walletBean?.totalBalance =
                  getBalanceResponse.wallet?.totalBalance;
              BlocProvider.of<AuthBloc>(context).add(
                  UpdateUserInfo(registrationResponse: registrationResponse));
            } else if (state is GetBalanceError) {
              _refreshBtnAnimationController.stop();
              ShowToast.showToast(context, state.errorMessage.toString(),
                  type: ToastType.ERROR);
            } else if (state is VerifyImageUrlLoading) {
              profilePicBottomSheetOpenRestricted = true;
            } else if (state is VerifyImageUrlSuccess) {
              profilePicBottomSheetOpenRestricted = false;
              isProfileImageUrlFurnished          = true;
              isProfileImageUrlValid              = true;
            } else if (state is VerifyImageUrlError) {
              profilePicBottomSheetOpenRestricted = false;
              isProfileImageUrlFurnished          = true;
              isProfileImageUrlValid              = false;

            }
          });
        },
        child: AbsorbPointer(
            absorbing: isOtpLoading,
            child: RoundedContainer(
                child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        children: [
                          AbsorbPointer(
                            absorbing: profilePicBottomSheetOpenRestricted,
                            child: InkWell(
                              onTap: () {
                                BottomSheetTheme.show(
                                    context: context,
                                    enableDrag: false,
                                    sheet: ProfilePictureOptionsBottomSheet(
                                        isValidImageUrl: isProfileImageUrlValid,
                                        callback: (profilePhotoSelectOptions) {
                                      Navigator.of(context).pop();

                                      if (profilePhotoSelectOptions == ProfilePhotoSelectOptions.camera) {
                                        mProfilePhotoSelectionSource = ImageSource.camera;
                                        _pickProfileImageFromSource(mProfilePhotoSelectionSource);
                                        log("mProfilePhotoSelectionSource camera: $mProfilePhotoSelectionSource");

                                      } else if (profilePhotoSelectOptions == ProfilePhotoSelectOptions.gallery) {
                                        log("mProfilePhotoSelectionSource gallery: $mProfilePhotoSelectionSource");
                                        mProfilePhotoSelectionSource = ImageSource.gallery;
                                        _pickProfileImageFromSource(mProfilePhotoSelectionSource);

                                      } else if (profilePhotoSelectOptions == ProfilePhotoSelectOptions.view) {
                                        _previewImage(mProfilePhotoUrl);
                                      }
                                    }));
                              },
                              child: Hero(
                                tag: "profileImage",
                                child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: LongaColor.white,
                                      borderRadius: new BorderRadius.all(
                                          new Radius.circular(50)),
                                      border: new Border.all(
                                        color: LongaColor.pale_lilac,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: ClipOval(
                                        child: isProfilePhotoUploadLoading
                                            ? CircularProgressIndicator(
                                                color: LongaColor.app_blue)
                                            : isProfileImageUrlFurnished
                                              ? Image.network(
                                                  mProfilePhotoUrl,
                                                  fit: BoxFit.fill,
                                                  errorBuilder: (BuildContext context,
                                                      Object obj,
                                                      StackTrace? stackTrace) {
                                                    if (UserInfo
                                                        .getProfilePhotoUrl.isEmpty) {
                                                      return Image.asset('assets/icons/person.webp');
                                                    } else {
                                                      return Image.network(
                                                          UserInfo.getProfilePhotoUrl,
                                                          errorBuilder: (BuildContext
                                                                  context,
                                                              Object obj,
                                                              StackTrace? stackTrace) {
                                                        print(
                                                            "--------------Image.network----------------");
                                                        return Image.asset(
                                                            'assets/icons/person.webp');
                                                      });
                                                    }
                                                  },
                                                  loadingBuilder: (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                    if (loadingProgress == null)
                                                      return child;
                                                    return Stack(
                                                        alignment: Alignment.center,
                                                        children: [
                                                          CircularProgressIndicator(
                                                              value: loadingProgress
                                                                          .expectedTotalBytes !=
                                                                      null
                                                                  ? loadingProgress
                                                                          .cumulativeBytesLoaded /
                                                                      loadingProgress
                                                                          .expectedTotalBytes!
                                                                  : null,
                                                              color: Colors.green),
                                                          //Text( loadingProgress.expectedTotalBytes != null ? "${(double.parse((loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!).toStringAsFixed(2)) * 100).toInt()} %" : "", textAlign: TextAlign.center)
                                                        ]);
                                                  },
                                                )
                                              : SizedBox(width: 50, height: 50, child: Lottie.asset('assets/lottie/loading_image.json')).py(16)
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                      context, LongaScreen.editProfileScreen)
                                  .then((value) => setState(() {}));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(23.5)),
                                  border: Border.all(
                                      color: LongaColor.darkish_purple_two,
                                      width: 1)),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/icons/icon_feather_edit_3.png",
                                    width: 20,
                                    height: 10,
                                  ),
                                  Text(context.l10n.edit_profile,
                                      style: const TextStyle(
                                          color: LongaColor.darkish_purple_two,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Roboto",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 8.0),
                                      textAlign: TextAlign.center)
                                ],
                              ),
                            ),
                          )
                        ],
                      ).pOnly(left: 20, top: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: UserInfo.firstName != "NA",
                              child: Text(
                                UserInfo.firstName != "NA"
                                    ? "${UserInfo.firstName} ${UserInfo.lastName}"
                                    : UserInfo.userName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: LongaColor.black_four,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            HeightBox(2),
                            Row(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  size: 20,
                                  color: LongaColor.black_four,
                                ).pOnly(right: 4),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.47,
                                  child: Text(
                                    '${UserInfo.userName}',
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: LongaColor.black_four,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            HeightBox(4),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: [
                                Icon(
                                  Icons.phone_outlined,
                                  size: 20,
                                  color: LongaColor.black_four,
                                ).pOnly(right: 4),
                                Text(
                                  UserInfo.mobNumber,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: LongaColor.black_four,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                            HeightBox(2),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  size: 20,
                                  color: LongaColor.black_four,
                                ).pOnly(right: 4),
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          style: TextStyle(
                                            color: LongaColor.black_four,
                                            fontSize: 14.0,
                                          ),
                                          text: UserInfo.emailId != "NA" ? UserInfo.emailId : "--",
                                        ),
                                        WidgetSpan(
                                          child:
                                          UserInfo.emailId != "NA" &&
                                              isOtpLoading
                                              ? SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: Lottie.asset(
                                                'assets/lottie/resend_loader.json'),
                                          ).pOnly(left: 3, right: 3)
                                              : (UserInfo.emailVerified ==
                                              "N")
                                              ? InkWell(
                                            onTap: () {
                                              setState(() {
                                                isOtpLoading = true;
                                                BlocProvider.of<ProfileBloc>(context).add(SendVerificationEmailLink(
                                                    context:
                                                    context,
                                                    request: SendVerificationEmailRequest(
                                                        domainName:
                                                        AppConstants
                                                            .domainName,
                                                        emailId:
                                                        UserInfo
                                                            .emailId,
                                                        isOtpVerification:
                                                        "YES",
                                                        playerId:
                                                        UserInfo
                                                            .userId)));
                                              });
                                            },
                                            child: UserInfo.emailId != "NA"
                                                ? Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      20),
                                                  color: LongaColor
                                                      .grape_purple_two),
                                              child: Text(
                                                context.l10n.verify,
                                                style: TextStyle(
                                                    color:
                                                    LongaColor
                                                        .white,
                                                    fontSize: 13),
                                              ).pOnly(
                                                  left: 10,
                                                  right: 10,
                                                  top: 2,
                                                  bottom: 2),
                                            ).pOnly(left: 8)
                                                : Container(),
                                          )
                                              : Container(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            HeightBox(2),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 20,
                                  color: LongaColor.black_four,
                                ).pOnly(right: 4),
                                Expanded(
                                  child: Text(
                                    UserInfo.address != "NA" ? UserInfo.address : "--",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: LongaColor.black_four,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ).p20(),
                      ),
                    ],
                  ).pOnly(top: 8, bottom: 8),
                  Container(
                    height: size.height * 0.2,
                    width: size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(1, 0),
                        end: Alignment(0, 1),
                        colors: [
                          LongaColor.marigold,
                          LongaColor.tangerine,
                        ],
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset("assets/icons/wallet.svg",
                            width: 30, height: 30, color: LongaColor.black_four),
                        Text(
                          context.l10n.wallet_balance,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: LongaColor.black_four,
                            fontSize: 18.0,
                          ),
                        ).p8(),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ScaleAnimate(
                              controller: _balanceController,
                              child: Text(
                                "${UserInfo.currencyDisplayCode} ${removeDecimalValueAndFormat(UserInfo.totalBalance.toString()) }",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: LongaColor.black_four,
                                    fontSize: 28.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            IconButton(
                              onPressed: () {
                                _refreshBtnAnimationController.forward();
                                BlocProvider.of<ProfileBloc>(context).add(
                                    GetBalance(
                                        context: context,
                                        request: GetBalanceRequest(
                                            domainName: AppConstants.domainName,
                                            playerId: UserInfo.userId,
                                            playerToken: UserInfo.userToken)))
                                ;
                              },
                              icon: RotationTransition(
                                turns: refreshBtnAnimation,
                                child: CircleAvatar(
                                  radius: 16,
                                  child: SvgPicture.asset(
                                      "assets/icons/referesh.svg",
                                      width: 20,
                                      height: 20,
                                      color: LongaColor.darkish_purple_two),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    width: size.width,
                    // color: Colors.green,
                    child: GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          // crossAxisCount: 2,
                          // childAspectRatio: 1,
                          childAspectRatio: 1.2,
                          // mainAxisSpacing: 2.0,
                          // crossAxisSpacing: 2.0,
                          crossAxisCount: 2),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            onAccountOptionClick(index);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: LongaColor.grid_line_color, width: 1)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(imageUrls[index],
                                    width: 30,
                                    height: 30,
                                    color: LongaColor.black_four),
                                const HeightBox(10),
                                Text(
                                  imageName[index],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: LongaColor.black_four,
                                    fontSize: 16.0,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ))),
      ),
    );

    return widget.fromDashBoard
        ? body
        : SafeArea(
            child: LongaScaffold(
              showAppBar: true,
              appBarTitle: context.l10n.profile.toUpperCase(),
              extendBodyBehindAppBar: true,
              body: body,
            ),
          );
  }

  _previewImage(imageUrl) {
    Navigator.of(context).push(
      PageRouteBuilder(
        fullscreenDialog: true,
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return Hero(
              tag: "profileImage",
              child: Container(
                child: Center(
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.all(20),
                      color: Colors.white,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        loadingBuilder: (BuildContext context,
                            Widget child,
                            ImageChunkEvent?
                            loadingProgress) {
                          if (loadingProgress == null)
                            return child;
                          return Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                    value: loadingProgress
                                        .expectedTotalBytes !=
                                        null
                                        ? loadingProgress
                                        .cumulativeBytesLoaded /
                                        loadingProgress
                                            .expectedTotalBytes!
                                        : null,
                                    color: LongaColor.app_blue),
                                //Text( loadingProgress.expectedTotalBytes != null ? "${(double.parse((loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!).toStringAsFixed(2)) * 100).toInt()} %" : "", textAlign: TextAlign.center)
                              ]);
                        },
                      )
                  ),
                ),
              )
          );
        },
        transitionsBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child) {
          return FadeTransition(
            opacity:
            animation, // CurvedAnimation(parent: animation, curve: Curves.elasticInOut),
            child: child,
          );
        },
      ),
    );
  }

  _pickProfileImageFromSource(source) async {
    try {
      mXFileDetails = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      if (mXFileDetails != null) {
        String fileExtension = mXFileDetails?.name.split(".")[1] ?? "";
        print("file extension -------> $fileExtension");
        if ( imageExtensionList.contains(fileExtension.toLowerCase())) {
          int imgSize = await _getImageSize();

          if( imgSize <= 2 && imgSize > 0) {
            setState(() {
              isProfilePhotoUploadLoading = true;
              isProfileManuallyUploading = true;
            });
            ShowToast.showToast(
                context, context.l10n.please_wait_profile_photo_is_updating,
                type: ToastType.INFO);
            BlocProvider.of<ProfileBloc>(context).add(UploadProfilePhoto(
                context: context, mXFileDetails: mXFileDetails!));
          } else {
            ShowToast.showToast(
                context, context.l10n.image_size_should_less_then_2mb,
                type: ToastType.ERROR);
          }
        }
        else {
          ShowToast.showToast(
              context, context.l10n.image_should_be_jpg_png,
              type: ToastType.ERROR);
        }

      }
    } catch (e) {
      log("[PROFILE IMAGE] $e");
    }
  }

  Future<int> _getImageSize() async {
    int sizeInBytes = await mXFileDetails!.length();
    int imgSize = (sizeInBytes / 4096 / 100).ceil();
    print("image size in mb ---> $imgSize");
    return imgSize;
  }

  onAccountOptionClick(int index) {
    switch (index) {
      case 0:
        UserInfo.isLoggedIn()
            ? Navigator.pushNamed(context, LongaScreen.myWalletScreen)
            : showDialog(
          context: context,
          builder: (context) => BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(),
            child: const LoginScreen(),
          ),
        );
        break;
      case 1:
        Navigator.pushNamed(context, LongaScreen.transactionScreen);
        break;
      case 2:
        Navigator.pushNamed(context, LongaScreen.inbox_screen);
        break;
      case 3:
        UserInfo.isLoggedIn()
            ? Navigator.pushNamed(context, LongaScreen.referAFriend)
            : showDialog(
                context: context,
                builder: (context) => BlocProvider<LoginBloc>(
                  create: (context) => LoginBloc(),
                  child: const LoginScreen(),
                ),
              );
        break;
      default:
        log("default screen");
    }
  }
}


class MySecondPage extends StatefulWidget {
  String itemUrl;

  MySecondPage({Key? key, required this.itemUrl}) : super(key: key);

  @override
  State<MySecondPage> createState() => _MySecondPageState();
}

class _MySecondPageState extends State<MySecondPage> {

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "profileImage",
      child: Material(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Second Page"),
          ),
          body: Image.network(
            widget.itemUrl,
            fit: BoxFit.contain,
            loadingBuilder: (BuildContext context,
                Widget child,
                ImageChunkEvent?
                loadingProgress) {
              if (loadingProgress == null)
                return child;
              return Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                        value: loadingProgress
                            .expectedTotalBytes !=
                            null
                            ? loadingProgress
                            .cumulativeBytesLoaded /
                            loadingProgress
                                .expectedTotalBytes!
                            : null,
                        color: LongaColor.app_blue),
                    ]
              );
            },
          )
          // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ),
    );
  }
}