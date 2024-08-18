import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/constant/longa_constant.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/utils/auth/auth_bloc.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:longa_lotto/utils/utils.dart';
import 'package:velocity_x/velocity_x.dart';

class Header extends StatefulWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  double innerRadius = 35;
  double innerRadiusPadding = 2;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
       return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  gradient: LongaConstant.LongaGradientColor,
                ),
                child: Row(
                  children: [
                    CachedNetworkImage(
                      imageUrl: UserInfo.getProfilePhotoUrl,
                      placeholder: (context, url) => CircleAvatar(
                        radius: innerRadius + innerRadiusPadding,
                        backgroundColor: LongaColor.darkish_purple_two,
                        child: CircleAvatar(
                          backgroundColor: LongaColor.butter_scotch,
                          backgroundImage:
                          AssetImage("assets/icons/person.webp"),
                          radius: innerRadius,
                        ),
                      ),
                      errorWidget: (context, url, error) => CircleAvatar(
                        radius: innerRadius + innerRadiusPadding,
                        backgroundColor: LongaColor.darkish_purple_two,
                        child: CircleAvatar(
                          backgroundColor: LongaColor.butter_scotch,
                          backgroundImage:
                          AssetImage("assets/icons/person.webp"),
                          radius: innerRadius,
                        ),
                      ),
                      imageBuilder: (context, image) => CircleAvatar(
                        radius: innerRadius + innerRadiusPadding,
                        backgroundColor: LongaColor.darkish_purple_two,
                        child: CircleAvatar(
                          backgroundColor: LongaColor.butter_scotch,
                          backgroundImage: image,
                          radius: innerRadius,
                        ),
                      ),
                    ),
                    const WidthBox(20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            width: 150,
                            child: Text(
                              UserInfo.isLoggedIn() ? "${context.l10n.hi}, ${UserInfo.userName}" : context.l10n.hi_guest,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          const HeightBox(4),
                          UserInfo.isLoggedIn()
                          ? RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  style: const TextStyle(
                                    color: LongaColor.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                  text: UserInfo.isLoggedIn() ? "${UserInfo.currencyDisplayCode} " :"\$",
                                ),
                                TextSpan(
                                  style: const TextStyle(
                                    color: LongaColor.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0,
                                  ),
                                  text: UserInfo.isLoggedIn() ? "${removeDecimalValueAndFormat(UserInfo.totalBalance.toString())}" :"0",
                                )
                              ],
                            ),
                          )
                          : Container()
                        ],
                      ),
                    ),
                  ],
                ).px8(),
              ),
              const HeightBox(10),
            ],
          ),
        );
      },
    );
  }
}
