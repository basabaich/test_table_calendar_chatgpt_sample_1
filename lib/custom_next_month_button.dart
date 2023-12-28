import 'package:flutter/material.dart';

class CustomNextMonthButton extends StatelessWidget {
  const CustomNextMonthButton({required this.onPressed, super.key});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Icon(
        Icons.arrow_forward_ios_sharp,
      ), //Icon
    ); //TextButton
  }
}
