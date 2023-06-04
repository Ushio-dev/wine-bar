import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class ProgressDialog {
  static show(BuildContext context) {
    showCupertinoModalPopup(
      context: context, 
      builder: (_) {
        return Container(
          width: 50,
          height: 50,
          color: Colors.black,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    );
  }

  static dismiss(BuildContext context) {
    Navigator.pop(context);
  }
}