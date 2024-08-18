part of "refer_widget.dart";

class ReferralLink extends StatefulWidget {
  const ReferralLink({Key? key}) : super(key: key);

  @override
  State<ReferralLink> createState() => _ReferralLinkState();
}

class _ReferralLinkState extends State<ReferralLink> with TickerProviderStateMixin {

  late final AnimationController _referCodeTextAnimatedController;
  late final Animation<double> animationReferCodeText;
  bool isShareLinkClick = false;

  String url = '${baseUrlMap[BaseUrlEnum.webViewBaseUrl]}/refer-friend?data=${UserInfo.getReferCode}';

  @override
  void initState() {
    _referCodeTextAnimatedController  = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    animationReferCodeText            = Tween<double>(begin: 1.2, end: 1.5).animate(CurvedAnimation(
      parent: _referCodeTextAnimatedController,
      curve: Curves.easeInOut,
    ))
                                        ..addStatusListener((status) {
                                          if (status == AnimationStatus.completed) {
                                            _referCodeTextAnimatedController.reverse();
                                          }
                                        })
                                        ..addStatusListener((state) => print('$state'));
    _referCodeTextAnimatedController.reset();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      dashPattern: const [6, 7],
      color: LongaColor.warm_grey_three,
      child: InkWell(
        onTap: () async {
          // _launchUrl();
          if (!isShareLinkClick) {
            setState(() {
              _referCodeTextAnimatedController.forward();
              Share.share("$url/?data=${UserInfo.getReferCode}", subject: "Invite Link");
              //await Clipboard.setData(ClipboardData(text: url));
              print('referCodeCopy $url');
              isShareLinkClick = true;
            });
          }

          Future.delayed(const Duration(milliseconds: 3000), () {
            setState(() {
              isShareLinkClick = false;
            });

          });


        },
        child: Container(
          color: LongaColor.white,
          child: ScaleTransition(
            scale: animationReferCodeText,
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/feather_link.png',
                  color: LongaColor.navy_blue,
                  width: 24,
                  height: 16,
                ).p(8).pOnly(left: isMobileDevice() ? 0 : 10),
                const WidthBox(10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    url,
                    style: TextStyle(
                      color: LongaColor.navy_blue,
                      fontWeight: FontWeight.w400,
                      fontFamily: "SegoeUI",
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ).pOnly(right: 8),
                )
              ],
            ).pOnly(left: 32),
          ),
        ),
      ),
    ).px16();
  }
}
