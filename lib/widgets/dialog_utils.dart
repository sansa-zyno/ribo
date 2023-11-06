
import 'package:flutter/material.dart';

class DialogUtils {
  static DialogUtils _instance = new DialogUtils.internal();

  DialogUtils.internal();

  factory DialogUtils() => _instance;

  static void showCustomDialog(BuildContext context,
      {required String title,
      required String middleText,
        String okBtnText = "Yes",
        String cancelBtnText = "No",
        required Function okBtnFunction,
        required Function cancelBtnFunction,
      }) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(title),
            content: Text(middleText),
            actions: <Widget>[
              FlatButton(
                child: Text(okBtnText),
                onPressed:() => okBtnFunction,
              ),
              FlatButton(
                  child: Text(cancelBtnText),
                  onPressed: () => cancelBtnFunction)
            ],
          );
        });
  }
}