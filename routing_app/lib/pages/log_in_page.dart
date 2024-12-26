import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routing_app/widget/custom_button.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SvgPicture.asset('assets/images/logo3.svg'),
          ),

          SizedBox(
            child: Column(
              children: [
                CustomButton(color: Colors.white,
                    textColor: Colors.black,
                    label: "SignUp",
                    onPressed: (){}),
                const SizedBox(height: 15,),

                CustomButton(color: Colors.black,
                    textColor: Colors.white,
                    label: "LogIn",
                    onPressed: (){}),
              ],
            ),
          ),

          const Text("Continue as guest",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),)
        ],
      ),
    );
  }
}
