import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:velocity_x/velocity_x.dart';

class LongaTextFieldUnderline extends StatefulWidget {
  const LongaTextFieldUnderline({
    Key? key,
    this.hintText,
    this.label,
    this.labelRow,
    this.inputType,
    this.textInputAction,
    this.errorText,
    this.controller,
    this.inputFormatters,
    this.bankVerification = false,
    this.suffixIcon,
    this.showCursor = true,
    this.borderColor,
    this.fillColor,
    this.onTap,
    this.prefix,
    this.maxLength,
    this.onChanged,
    this.autoFocus,
    this.fontWeight,
    this.fontSize,
    this.isActivated,
    this.labelFontSize,
    this.enabled = true,
    this.validator,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.focusNode,
    this.onFocusChange,
    this.showLabel = true,
    this.obscureText = false,
    this.isDense = false,
    this.isCalendar,
    this.readOnly,
    this.disableSpace,
    this.errorColor,
    this.isDarkThemeOn = true,
    this.minLine,
    this.maxLine = 1,
    this.alignLabelWithHint = false,
    this.inputDecoration,
    this.textStyle,
    this.inputFormatter,
  }) : super(key: key);

  final String? label;
  final String? labelRow;
  final String? hintText;
  final TextInputType? inputType;
  final TextInputAction? textInputAction;
  final String? errorText;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final bool? bankVerification;
  final Widget? suffixIcon;
  final Widget? prefix;
  final bool? showCursor;
  final Color? borderColor;
  final Color? fillColor;
  final VoidCallback? onTap;
  final int? maxLength;
  final ValueChanged? onChanged;
  final bool? autoFocus;
  final FontWeight? fontWeight;
  final double? fontSize;
  final bool? isActivated;
  final double? labelFontSize;
  final bool? enabled;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
  final void Function(bool)? onFocusChange;
  final bool? showLabel;
  final bool? obscureText;
  final bool? isDense;
  final bool? isCalendar;
  final bool? readOnly;
  final bool? disableSpace;
  final Color? errorColor;
  final bool? isDarkThemeOn;
  final int? minLine;
  final int? maxLine;
  final bool alignLabelWithHint;
  final InputDecoration? inputDecoration;
  final TextStyle? textStyle;
  final TextInputFormatter? inputFormatter;

  @override
  State<LongaTextFieldUnderline> createState() =>
      _LongaTextFieldUnderlineState();
}

class _LongaTextFieldUnderlineState extends State<LongaTextFieldUnderline> {
  String? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.label != null
            ? Text(
                widget.label!,
                style: TextStyle(
                  color: LongaColor.black_four,
                  fontSize: widget.labelFontSize,
                  fontWeight: FontWeight.w700,
                ),
              ).py8()
            : Container(),
        Row(
          children: [
            widget.labelRow != null
                ? Text(
                  widget.labelRow!,
                  style: TextStyle(
                    color: LongaColor.black_two,
                    fontSize: widget.labelFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ).pOnly(top:16)
                    : Container(),
            Flexible(
              child: Focus(
                onFocusChange: widget.onFocusChange,
                child: TextFormField(
                  minLines: widget.minLine,
                  maxLines: widget.maxLine,
                  textAlignVertical: TextAlignVertical.center,
                  focusNode: widget.focusNode,
                  onTap: widget.onTap ??
                      () {
                        widget.isCalendar == true
                            ? _showCalender(context, widget.initialDate,
                                widget.firstDate, widget.lastDate)
                            : {};
                      },
                  inputFormatters: widget.inputFormatters ??
                      (widget.inputType == TextInputType.number
                          ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))]
                          : widget.disableSpace == true
                              ? [FilteringTextInputFormatter.deny(RegExp(r""))]
                              : null),
                  textCapitalization: TextCapitalization.sentences,
                  onFieldSubmitted: widget.onFieldSubmitted,
                  onEditingComplete: widget.onEditingComplete,
                  validator: widget.validator,
                  enabled: widget.enabled,
                  controller: widget.controller,
                  onChanged: widget.onChanged,
                  keyboardType: widget.inputType ?? TextInputType.text,
                  scrollPadding: const EdgeInsets.only(bottom: 40),
                  showCursor: widget.showCursor,
                  autofocus: widget.autoFocus ?? false,
                  maxLength: widget.maxLength,
                  textInputAction: widget.textInputAction,
                  style: widget.textStyle ??
                      TextStyle(
                        fontWeight: widget.fontWeight,
                        fontSize: widget.fontSize ?? 18,
                        color: widget.enabled == true
                            ? LongaColor.black_four
                            : widget.hintText != null
                                ? LongaColor.black_four
                                : LongaColor.pale_grey_three,
                      ),
                  obscureText: widget.obscureText ?? false,
                  obscuringCharacter: "*",
                  cursorColor: LongaColor.black_four,
                  readOnly: widget.readOnly ?? widget.isCalendar == true,
                  decoration: widget.inputDecoration ??
                      InputDecoration(
                        alignLabelWithHint: widget.alignLabelWithHint,
                        isDense: widget.isDense,
                        errorText: widget.errorText,
                        hintText: widget.showLabel == true ? null : widget.hintText,
                        suffixIcon: widget.suffixIcon == null
                            ? null
                            : UnconstrainedBox(child: widget.suffixIcon),
                        prefixIcon: widget.prefix,
                        // prefixIconConstraints:
                        //     const BoxConstraints(minWidth: 0, minHeight: 0),
                        counterText: '',
                        hintStyle: TextStyle(
                          color: LongaColor.black_four,
                          fontWeight: widget.fontWeight ?? FontWeight.w400,
                          fontSize: widget.fontSize,
                        ),
                        labelStyle: TextStyle(
                          color: LongaColor.black_four,
                          fontWeight: widget.fontWeight ?? FontWeight.w400,
                          fontSize: widget.fontSize,
                        ),
                        errorStyle: TextStyle(
                          color: widget.errorColor ?? LongaColor.reddish_pink,
                        ),
                        hintMaxLines: 2,
                        floatingLabelStyle: TextStyle(
                          color: LongaColor.black_four,
                        ),
                        labelText:
                            widget.showLabel == true ? widget.hintText : null,
                        border: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: LongaColor.tomato,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        fillColor: widget.fillColor ?? (Colors.transparent),
                        filled: true,
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: widget.borderColor ?? LongaColor.tomato,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: widget.borderColor ?? LongaColor.black_four,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: widget.borderColor ?? (LongaColor.black_four),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: widget.borderColor ?? LongaColor.black_four,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  _showCalender(BuildContext context, DateTime? initialDate,
      DateTime? firstDate, DateTime? lastDate) async {
    // DateTime? pickedDate = await showCalendar(
    //     context, widget.initialDate, widget.firstDate, widget.lastDate);
    // if (pickedDate != null) {
    //   setState(() {
    //     selectedDate = DateFormat(Format.calendarFormat).format(pickedDate);
    //     widget.controller?.text = selectedDate!;
    //   });
    // }
  }
}
