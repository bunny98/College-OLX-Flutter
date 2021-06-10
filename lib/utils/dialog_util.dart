import 'package:flutter/material.dart';

class DialogUtil {
  static Future<bool> showTwoOptionDialog(
      {BuildContext context,
      String op1 = "No",
      String op2 = "Yes",
      String title = "Alert",
      String content}) async {
    bool retVal = false;
    // set up the buttons
    Widget op1Button = TextButton(
      child: Text(op1),
      onPressed: () {
        retVal = false;
        Navigator.of(context).pop();
      },
    );
    Widget op2Button = TextButton(
      child: Text(op2),
      onPressed: () {
        retVal = true;
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        op1Button,
        op2Button,
      ],
    );

    // show the dialog
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    return retVal;
  }
}
