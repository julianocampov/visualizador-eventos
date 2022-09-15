import 'package:flutter/material.dart';

import '../widgets/otp_widget.dart';

class OTPPage extends StatelessWidget {
  const OTPPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: OTPWidget(),
    );
  }
}