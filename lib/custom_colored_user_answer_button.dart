import 'package:flutter/material.dart';

class CustomColoredUserAnswerButton extends StatefulWidget {
  const CustomColoredUserAnswerButton({super.key});

  @override
  State<CustomColoredUserAnswerButton> createState() =>
      _CustomColoredUserAnswerButtonState();
}

class _CustomColoredUserAnswerButtonState
    extends State<CustomColoredUserAnswerButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      width: double.infinity, //width of 3rd Block
      height: 80.0,
      color: Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              // visualDensity:
              //     const VisualDensity(vertical: 1.0, horizontal: 1.0),
              // minimumSize: const Size(1, 1),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('R'),
          ), //ElevatedButton
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('G'),
          ), //ElevatedButton
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('B'),
          ), //ElevatedButton
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
              foregroundColor: Colors.black,
            ),
            child: const Text('Y'),
          ), //ElevatedButton
        ],
      ), //Row
    ); //Container;
  }
}
