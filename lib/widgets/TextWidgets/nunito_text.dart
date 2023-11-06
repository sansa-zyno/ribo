import 'package:flutter/material.dart';

class NunitoText extends StatelessWidget {
  String? text;
  TextAlign? align;
  Color? clr;
  double? fontSize;
  FontWeight? fontWeight;
  double? letterSpacing;

  NunitoText(
      {this.text,
      this.align,
      this.clr,
      this.fontSize,
      this.fontWeight,
      this.letterSpacing});

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      textScaleFactor: 1,
      textAlign: align ?? TextAlign.start,
      style: TextStyle(
          color: clr ?? Colors.black,
          fontFamily: "Nunito",
          fontSize: fontSize ?? 16,
          fontWeight: fontWeight ?? FontWeight.w400,
          letterSpacing: letterSpacing ?? 1),
    );
  }
}
