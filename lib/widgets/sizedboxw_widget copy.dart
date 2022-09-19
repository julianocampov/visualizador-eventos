import 'package:flutter/material.dart';

class SizedBoxWidget extends StatelessWidget {
  const SizedBoxWidget({super.key, required this.heightSized});
  final double heightSized;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heightSized,);
  }
}