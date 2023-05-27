import 'package:flutter/material.dart';

extension UnFocusKeyboardFromScope on BuildContext {
  void unFocusKeyboardFromScope() {
    FocusScope.of(this).unfocus();
  }
}

extension ShowSnackBar on BuildContext {
  void showCustomSnackBar(String text, Duration? duration, [Color? color]) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      backgroundColor: color,
      duration: duration ?? const Duration(seconds: 4),
      content: Center(
        child: Text(text),
      ),
    ));
  }
}
