  import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
  class RoundedButton extends StatelessWidget {
   String? name;
   Function()? callBack;
   Color? color;
   RoundedButton({this.name, this.callBack, this.color});
  @override
  Widget build(BuildContext context) {
    return   Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: callBack,
          minWidth: 200.0,
          height: 42.0,
          child: Text(name!),
        ),

    ),
    );
  }
}