import 'package:flutter/material.dart';

class CustomPrevMonthButton extends StatelessWidget {
  const CustomPrevMonthButton({required this.onPressed, super.key});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Icon(
        Icons.arrow_back_ios_new_sharp,
      ), //Icon
    ); //TextButton
  }
}
