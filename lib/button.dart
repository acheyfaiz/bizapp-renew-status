import 'package:flutter/material.dart';

class BizappButton extends StatelessWidget {
  final String title;
  final GestureTapCallback tapCallback;
  final Color color;
  const BizappButton({super.key, required this.color, required this.title, required this.tapCallback});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10)
      ),
      child: IconButton(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          onPressed: tapCallback,
          icon: Text(title)
      ),
    );
  }
}

class BizappText extends StatelessWidget {
  final String text;
  const BizappText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold
    ));
  }
}


