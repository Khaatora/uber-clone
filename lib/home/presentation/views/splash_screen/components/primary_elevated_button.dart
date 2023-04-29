import 'package:flutter/material.dart';


class PrimaryElevatedButton extends StatelessWidget {
  const PrimaryElevatedButton({required this.onPressed, required this.text, this.suffixIcon = Icons.arrow_forward, this.style ,Key? key}) : super(key: key);
  final void Function() onPressed;
  final String text;
  final IconData suffixIcon;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: style,
        onPressed: onPressed,
        child: Row(
          children:  [
            Expanded(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                )),
            Icon(suffixIcon),
          ],
        ));
  }
}
