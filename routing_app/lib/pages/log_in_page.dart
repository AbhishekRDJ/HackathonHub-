import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:routing_app/home_page/main_page.dart';
import 'package:routing_app/pages/sign_up_page.dart';
import 'package:routing_app/widget/custom_button.dart';
import 'package:routing_app/widget/custom_textfeild.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {

  bool isObsute = true;
  TextEditingController username = TextEditingController();
  TextEditingController pass = TextEditingController();

  Future<void> getUserLogIn() async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: username.text.trim(),
          password: pass.text.trim());

      if(context.mounted){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const MainPage()));
      }
    }
    on FirebaseAuthException catch(e){

      if(context.mounted){
        showAdaptiveDialog(context: context,
            builder: (context){
              return AlertDialog.adaptive(
                icon: const Icon(Icons.warning),
                title: Text(e.message.toString(),
                style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,fontFamily: "lato"),),
                actions: [
                  TextButton(onPressed: (){
                    Navigator.of(context).pop();
                  }, child: const Text("ok",
                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,fontFamily: "lato"),))
                ],
              );
            }
        );
      }
    }
  }

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
            const Text("Welcome Back, Let’s Navigate New Paths",

            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
              color: Colors.white
            ),
            ).animate() // uses `Animate.defaultDuration`
                .slideX(duration: const Duration(milliseconds: 650)).
                tint(color: Colors.black,
                delay: const Duration(microseconds: 100)
            ),

            const Spacer(),

            CustomTextField(text: 'Enter your email',
                color: Colors.black,
              controller: username,
              isIcon: false,
              isPreIcon: false,
                ),
            const SizedBox(height: 30,),

            CustomTextField(
                text: 'Enter your password',
                color: Colors.black,
              isPreIcon: false,
                controller: pass,
                icon: Icons.remove_red_eye,
              isIcon: true,
            ),

            const Spacer(flex: 2,),

            CustomButton(color: Colors.black87,
                label: 'Log In',
                onPressed: (){
                  if(username.text!="" && pass.text!=""){
                    getUserLogIn();
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("username or password field is empty")));
                  }
                },
                textColor: Colors.white),


            const Spacer(flex: 3,),

            Center(
              child: GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=> const SignUpPage())
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
