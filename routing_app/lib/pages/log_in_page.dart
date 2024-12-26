import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:routing_app/widget/custom_button.dart';
import 'package:routing_app/widget/custom_textfeild.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
         onPressed: (){
           Navigator.of(context).pop();
         } ,
            icon : const Icon(Icons.arrow_back_ios)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(

          children: [
            const Text("Welcome Back! Glade \nto see you, Again!",
            maxLines: 2,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 34,
              color: Colors.white
            ),
            ).animate() // uses `Animate.defaultDuration`
                .slideX(duration: const Duration(milliseconds: 650)).
                tint(color: Colors.black,
                delay: const Duration(microseconds: 200)
            ),

            const Spacer(),

            const CustomTextField(text: 'Enter your email',
                color: Colors.black,
              isIcon: false,
                ),
            const SizedBox(height: 30,),

            const CustomTextField(
                text: 'Enter you password',
                color: Colors.black,
                icon: Icons.remove_red_eye,
              isIcon: true,
            ),

            const Spacer(flex: 2,),

            CustomButton(color: Colors.black87,
                label: 'Log In',
                onPressed: (){},
                textColor: Colors.white),


            const Spacer(flex: 3,),

            RichText(text: const TextSpan(
                text: "Don't have an account ? ",
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: 'Register Now',
                style: TextStyle(color: Colors.blue)
              )
            ]),
            ),

            const Spacer(flex: 2,)
          ],
        ),
      ),
    );
  }
}
