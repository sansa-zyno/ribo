import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  final String? hint;
  String? label;
  Color? focusedColor;
  Color? disabledColor;
  Color? enabledColor;
  Color? iconColor;
  TextEditingController? controller;
  TextInputType? type;
  bool? obsecureText;
  Icon? icon;
  Function? onEditingComplete;
  Function(String)? onChange;
  int? maxLines;

  RoundedTextField(
      {this.controller,
      this.disabledColor,
      this.enabledColor,
      this.focusedColor,
      this.hint,
      this.icon,
      this.iconColor,
      this.label,
      this.obsecureText,
      this.onChange,
      this.onEditingComplete,
      this.type,
      this.maxLines});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (text) {
        onChange!(text);
      },
      controller: controller,
      keyboardType: type ?? TextInputType.text,
      obscureText: obsecureText ?? false,
      decoration: new InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          alignLabelWithHint: false,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: focusedColor ?? Color(0xff00AEFF), width: 2.0),
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff00AEFF), width: 1.0),
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          hintText: hint ?? 'Your Value',
          labelText: label ?? null,
          labelStyle: TextStyle(
            fontFamily: "Nunito",
          ),
          hintStyle: TextStyle(fontFamily: "Nunito")),
    );
  }
}
