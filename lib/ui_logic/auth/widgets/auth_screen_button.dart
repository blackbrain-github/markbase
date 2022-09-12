// Packages
import 'package:Markbase/ui_logic/common/widgets/custom_animated_widget.dart';
import 'package:flutter/material.dart';

class AuthScreenButton extends StatefulWidget {
  final String title;
  final Function onPressed;
  final bool disabled;
  AuthScreenButton(this.title, this.onPressed, {this.disabled = false});

  @override
  _AuthScreenButtonState createState() => _AuthScreenButtonState();
}

class _AuthScreenButtonState extends State<AuthScreenButton> {
  // ---------------------------- BUILD ------------------------------ //

  @override
  Widget build(BuildContext context) {
    return CustomAnimatedWidget(
      onPressed: widget.onPressed,
      isAsync: true,
      animate: !widget.disabled,
      loadingWidget: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(14, 10, 14, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Stack(
          children: [
            Text(
              "",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.transparent,
              ),
            ),
            SizedBox(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(color: Colors.black),
            ),
          ],
        ),
      ),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(14, 10, 14, 10),
        decoration: BoxDecoration(
          color: !widget.disabled ? Color(0xFF202020) : Color(0xFF202020).withOpacity(0.2),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          widget.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
