part of "inbox_widget.dart";

class ConfirmationSheet {
  static show({
    required PlrInboxList inboxList,
    required BuildContext context,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
  }) {
    return BottomSheetTheme.show(
      sheet: LongoLottoBottomSheet(
        title: inboxList.subject,
        description: [
          Text(
            inboxList.contentId ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: LongaColor.black_four),
          ),
        ],
        bottomWidget: Row(
          children: [
            Expanded(
              child: PrimaryButton(
                text: context.l10n.delete.toUpperCase(),
               // type: ButtonType.line_art,
                borderColor: LongaColor.butter_scotch,
                textColor:LongaColor.white,
                borderRadius: 10.0,
                onPressed: onConfirm,
              ),
            ),
            const WidthBox(10.0),
            Expanded(
              child: PrimaryButton(
                text: context.l10n.close.toUpperCase(),
                fillEnableColor:
                LongaColor.butter_scotch,
                fillDisableColor: LongaColor.butter_scotch,
                textColor: LongaColor.white,
                borderRadius: 10.0,
                onPressed: onCancel,
              ),
            ),
          ],
        ).px24().pOnly(top: 20, bottom: 20),
      ),
      context: context,
    );
  }
}
