import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:routing_app/home_page/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widget/custom_button.dart';
import '../widget/custom_textfeild.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});



  @override
  State<SignUpPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<SignUpPage> {

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController confirmPass = TextEditingController();


  Future<void> createUserAndPassword() async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text.trim(),
          password: pass.text.trim()
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context)=>const MainPage())
      );
    }

    on FirebaseAuthException catch(e){
    showAdaptiveDialog(context: context,
    builder: (context){
    return AlertDialog.adaptive(
    icon: const Icon(Icons.warning),
    title: Text(e.message.toString()),
    actions: [
    TextButton(onPressed: (){
    Navigator.of(context).pop();
    }, child: const Text("ok"))
    ],
    );
    }
    );
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

            CustomTextField(text: 'Name',
              color: Colors.black,
              controller: name,
              isIcon: false,
            ),
            const SizedBox(height: 30,),


            CustomTextField(
              text: 'Email',
              color: Colors.black,
              controller: email,
              isIcon: false,
            ),
            const SizedBox(height: 30,),

            CustomTextField(text: 'Enter password',
              color: Colors.black,
              controller: pass,
              isIcon: true,
            ),
            const SizedBox(height: 30,),

            CustomTextField(
              text: 'Confirm password',
              color: Colors.black,
              controller: confirmPass,
              isIcon: true,
            ),

            const Spacer(flex: 2,),

            CustomButton(color: Colors.black87,
                label: 'Agree and Register',
                onPressed: (){

                  if(name.text!="" && email.text!="" &&
                  pass.text == confirmPass.text){
                    createUserAndPassword();
                  }

                  else if(pass.text != confirmPass.text){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("password does not match ")
                    )
                    );
                  }

                  else{
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("please enter the details ")
                    )
                    );
                  }

                },
                textColor: Colors.white),

            const Spacer(flex: 3,)
          ],
        ),
      ),
    );
  }
}
