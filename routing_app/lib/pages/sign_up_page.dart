import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../widget/custom_button.dart';
import '../widget/custom_textfeild.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<SignUpPage> {
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Welcome Back! Glade \nto see you, Again!",

              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  color: Colors.white
              ),
            ).animate() // uses `Animate.defaultDuration`
                .slideX(duration: const Duration(milliseconds: 650)).
            tint(color: Colors.black,
                delay: const Duration(microseconds: 100)
            ),

            const Spacer(),

            const CustomTextField(text: 'Username',
              color: Colors.black,
              isIcon: false,
            ),
            const SizedBox(height: 30,),

            const CustomTextField(
              text: 'Email',
              color: Colors.black,
              icon: Icons.remove_red_eye,
              isIcon: false,
            ),
            const SizedBox(height: 30,),

            const CustomTextField(text: 'Enter password',
              color: Colors.black,
              isIcon: true,
            ),
            const SizedBox(height: 30,),

            const CustomTextField(
              text: 'Confirm password',
              color: Colors.black,
              isIcon: true,
            ),

            const Spacer(flex: 2,),

            CustomButton(color: Colors.black87,
                label: 'Agree and Register',
                onPressed: (){},
                textColor: Colors.white),

            const Spacer(flex: 3,)
          ],
        ),
      ),
    );
  }
}
