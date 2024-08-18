part of 'home_widget.dart';
class HomeSliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  Function(bool) mCallBack;
  HomeSliverAppBar({required this.expandedHeight, required this.mCallBack});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    var size = MediaQuery.of(context).size;
    if (shrinkOffset.toInt() >= 169 && shrinkOffset.toInt() <= 184) {
      mCallBack(true);
    }
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                "assets/images/bg_banner.webp",
              ),
            ),
          ),
        ),
        Center(
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Image.asset(
              "assets/images/group_2827.webp",
              width: isMobileDevice() ? 260 : 360,
              height: isMobileDevice() ? 260 : 360,
            ).pOnly(left: MediaQuery.of(context).size.width * 0.1, top: 20),
          ),
        ),
        // Image.network(
        //   "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
        //   fit: BoxFit.cover,
        // ),
        // Center(
        //   child: Opacity(
        //     opacity: shrinkOffset / expandedHeight,
        //     child: Text(
        //       "MySliverAppBar",
        //       style: TextStyle(
        //         color: Colors.white,
        //         fontWeight: FontWeight.w700,
        //         fontSize: 23,
        //       ),
        //     ),
        //   ),
        // ),
        // Positioned(
        //   top: expandedHeight / 2 - shrinkOffset,
        //   left: MediaQuery.of(context).size.width / 4,
        //   child: Opacity(
        //     opacity: (1 - shrinkOffset / expandedHeight),
        //     child: Card(
        //       elevation: 10,
        //       child: SizedBox(
        //         height: expandedHeight,
        //         width: MediaQuery.of(context).size.width / 2,
        //         child: FlutterLogo(),
        //       ),
        //     ),
        //   ),
        // ),
        Positioned(
          bottom: -10,
          left: 0,
          right: 0,
          child: Container(
            height: 30,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: LongaColor.pale_grey_three,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(40),
              ),
              border: Border.all(
                color: LongaColor.pale_grey_three,
                width: 0,
              ),
                image: DecorationImage(
                    image: AssetImage(
                      'assets/images/bg_strip.jpg',
                    ),
                    fit: BoxFit.fitWidth
                ),
                boxShadow: const [
                  BoxShadow(
                    color: LongaColor.black_10,
                    offset: Offset(10, -5),
                    blurRadius: 5,
                    spreadRadius: 0,
                  )
                ]
            ),
          ),
        ),
        Positioned(
          top: expandedHeight / 2 - shrinkOffset -20,
          left: 20,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Container(
              width: 60,
              height: expandedHeight,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/yellow_ball.webp"),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: expandedHeight / 2 - shrinkOffset -20,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Container(
              alignment: Alignment.center,
              width: size.width,
              height: expandedHeight,
              child: Center(
                child: Image.asset(
                  "assets/images/beta_o_longa.webp",
                  width: size.width / 2,
                ),
              ),
            ),
          ),
        ),
        // Align(
        //   alignment: Alignment.topCenter,
        //   child: SizedBox(
        //     height: 80,
        //     child: Padding(
        //       padding: const EdgeInsets.only(left: 20),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           InkWell(
        //             onTap: () {
        //               Scaffold.of(context).openDrawer();
        //             },
        //             child: SvgPicture.asset("assets/icons/drawer.svg",
        //               width: 30,
        //               height: 30,
        //               fit: BoxFit.contain,
        //               color: Colors.white,
        //             ),
        //           ),
        //           SecondaryButton(
        //             onPressed: () {
        //               // _signInUpdateAnalytics();
        //               // Navigator.pushNamed(context, LOGIN_SCREEN);
        //             },
        //             text: 'Login / Sign Up',
        //             isFilled: true,
        //             fillColor: Colors.transparent,
        //             borderColor: LongaColor.white_two,
        //           )
        //         ],
        //       ),
        //     ),
        //   ),
        // )
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight + 40;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}