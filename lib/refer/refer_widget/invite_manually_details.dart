part of 'refer_widget.dart';

class InviteManuallyDetails extends StatelessWidget {
  final ShakeController nameShakeController;
  final ShakeController emailShakeController;
  final TextEditingController nameController;
  final TextEditingController emailController;

  const InviteManuallyDetails({
    Key? key,
    required this.nameShakeController,
    required this.emailShakeController,
    required this.nameController,
    required this.emailController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        border: Border.all(color: LongaColor.pale_grey_three, width: 2),
        color: LongaColor.white,
      ),
      child: Column(
        children: [
          const HeightBox(10),
          ShakeWidget(
            controller: nameShakeController,
            child: LongaTextField(
              maxLength: 30,
              controller: nameController,
              prefix: const Icon(
                Icons.person,
                color: LongaColor.black_four,
              ),
              hintText: context.l10n.nameOfFriend,
            ).px16(),
          ),
          const HeightBox(20),
          ShakeWidget(
            controller: emailShakeController,
            child: LongaTextField(
              maxLength: 30,
              controller: emailController,
              prefix: const Icon(
                Icons.email_outlined,
                color: LongaColor.black_four,
              ),
              hintText: context.l10n.emailOfFriend,
            ).px16(),
          ),
          const HeightBox(10),
        ],
      ),
    ).px16();
  }
}
