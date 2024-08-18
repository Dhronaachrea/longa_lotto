part of "refer_widget.dart";

class SharingWidget extends StatelessWidget {
  final String path;
  final String title;
  final VoidCallback onShare;

  const SharingWidget({
    Key? key,
    required this.path,
    required this.title,
    required this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onShare();
      },
      child: Column(
        children: [
          SvgPicture.asset(
            path,
            width: 50,
            height: 40,
          ),
          const HeightBox(15),
          Text(title.toUpperCase(),
              style: TextStyle(
                  color: LongaColor.warm_grey_six,
                  fontWeight: FontWeight.w300,
                  fontFamily: "SegoeUI",
                  fontStyle: FontStyle.normal,
                  fontSize: 18),
              textAlign: TextAlign.center)
        ],
      ),
    );
  }
}
