import 'package:flutter/material.dart';

class ShadowCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final bool? disableRipple;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool? disableShadow;
  final Color? shadowColor;
  final double? width;
  final AssetImage? backgroundImage;

  const ShadowCard({
    Key? key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.disableRipple = false,
    this.margin,
    this.backgroundColor,
    this.disableShadow = false,
    this.borderColor,
    this.width,
    this.backgroundImage,
    this.shadowColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        border: Border.all(
          color: borderColor ?? Colors.blueGrey,
          width: 1,
        ),
        image: backgroundImage != null
            ? DecorationImage(
                image: backgroundImage!,
                fit: BoxFit.cover,
              )
            : null,
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        boxShadow: disableShadow == false
            ? [
                BoxShadow(
                  color: backgroundColor?.withOpacity(0.0001) ??
                      shadowColor ??
                      Colors.blue.withOpacity(0.1),
                  offset: const Offset(0, 5),
                  blurRadius: 10,
                  spreadRadius: -5,
                ),
                BoxShadow(
                  color: backgroundColor != null
                      ? Colors.transparent
                      : Colors.white,
                  offset: Offset.zero,
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      clipBehavior: Clip.hardEdge,
      child: disableRipple == true
          ? Container(
              width: width,
              padding: padding,
              margin: margin,
              child: child,
            )
          : Material(
              color: backgroundColor ?? Colors.transparent,
              borderRadius: borderRadius ?? BorderRadius.circular(20),
              clipBehavior: Clip.hardEdge,
              child: Container(
                width: width,
                padding: padding,
                margin: margin,
                child: child,
              ),
            ),
    );
  }
}
