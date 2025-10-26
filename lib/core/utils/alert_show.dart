import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertShow {

  static alertShowSnackBar(BuildContext context, String message, Color snackColor){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: snackColor,
      ),
    );
  }

}