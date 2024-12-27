import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:routing_app/pages/home_page.dart';
import 'package:routing_app/pages/sign_up_page.dart';
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

            const CustomTextField(text: 'Enter your email',
                color: Colors.black,
              isIcon: false,
                ),
            const SizedBox(height: 30,),

            const CustomTextField(
                text: 'Enter your password',
                color: Colors.black,
                icon: Icons.remove_red_eye,
              isIcon: true,
            ),

            const Spacer(flex: 2,),

            CustomButton(color: Colors.black87,
                label: 'Log In',
                onPressed: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=> const HomePage())
                  );
                },
                textColor: Colors.white),


            const Spacer(flex: 3,),

            Center(
              child: GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>const SignUpPage())
                  );
                },
                child: RichText(text: const TextSpan(
                    text: "Don't have an account ? ",
                style: TextStyle(color: Colors.black,fontSize: 18),
                children: [
                  TextSpan(
                    text: 'Register Now',
                    style: TextStyle(color: Colors.blue,fontSize: 18)
                  )
                ]),
                ),
              ),
            ),

            const Spacer(flex: 2,)
          ],
        ),
      ),
    );
  }
}
