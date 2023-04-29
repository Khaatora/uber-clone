import 'package:flutter/material.dart';


class SecondaryElevatedButton extends StatelessWidget {
  const SecondaryElevatedButton({required this.onPressed, required this.text, this.prefixIcon = Icons.arrow_forward, this.style ,Key? key}) : super(key: key);
  final void Function() onPressed;
  final String text;
  final IconData prefixIcon;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: style,
        onPressed: onPressed,
        child: Row(
          children:  [
            Icon(prefixIcon),
            Expanded(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                )),
          ],
        ));
  }
}
