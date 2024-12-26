import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routing_app/pages/log_in_page.dart';
import 'package:routing_app/widget/custom_button.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _LogInPageState();
}

class _LogInPageState extends State<StartScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Animate(
            effects: const [
              FadeEffect(duration: Duration(milliseconds: 1500),)
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SvgPicture.asset('assets/images/logo3.svg'),
            ),
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
                    onPressed: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>const LogInPage())
                  );
                    }),
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