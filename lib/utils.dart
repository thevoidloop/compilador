import 'package:flutter/material.dart';

class Enmarcar extends StatelessWidget {
  final Widget child;

  const Enmarcar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.lightBlueAccent, width: 2)),
      child: child,
    );
  }
}
