import 'package:flutter/material.dart';

class Slidingdots extends StatelessWidget {
  bool isActive;
  Slidingdots(this.isActive);
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: isActive ? 12 : 8,
      width: isActive ? 12 : 8,
      decoration: BoxDecoration(
          color: isActive ? Colors.amberAccent : Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(15))),
    );
  }
}
