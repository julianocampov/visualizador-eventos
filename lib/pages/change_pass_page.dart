import 'package:flutter/material.dart';

import '../widgets/change_pass_widget.dart';
import 'configuration_page.dart';

class ChangePassPage extends StatelessWidget {
  const ChangePassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromRGBO(255, 192, 0, 10),
          ),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute<void>(
              builder: (BuildContext context){
                return const ConfigurationPage();
                },
              ),  (Route<dynamic> route) => false,
            );
          },
        ),

        backgroundColor: Colors.white,
        elevation: 0,
        //shadowColor: const Color.fromRGBO(255, 192, 0, 10),
      ),

      body: ChangePassWidget(),
    );
  }
}