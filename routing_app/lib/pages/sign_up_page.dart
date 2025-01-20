import 'package:cloud_firestore/cloud_firestore.dart';
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
  TextEditingController phone = TextEditingController();
  TextEditingController about = TextEditingController();

  Future<void> createUserAndPassword() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text.trim(), password: pass.text.trim());

      await FirebaseFirestore.instance.collection('userInfo').add({
        'name': name.text.trim(),
        'phone': phone.text.trim(),
        'email': email.text.trim(),
        'pass': pass.text.trim(),
        'about': about.text.trim(),
        'userid': FirebaseAuth.instance.currentUser!.uid,
      });

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainPage()));
    } on FirebaseAuthException catch (e) {
      showAdaptiveDialog(
          context: context,
          builder: (context) {
            return AlertDialog.adaptive(
              icon: const Icon(Icons.warning),
              title: Text(e.message.toString()),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("ok"))
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Embark on Smarter Journeys with NeoRoute",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white),
            )
                .animate() // uses `Animate.defaultDuration`
                .slideX(duration: const Duration(milliseconds: 650))
                .tint(
                    color: Colors.black,
                    delay: const Duration(microseconds: 100)),
            const SizedBox(
              height: 30,
            ),
            CustomTextField(
              text: 'Enter name',
              color: Colors.black,
              controller: name,
              isPreIcon: false,
              isIcon: false,
            ),
            const SizedBox(
              height: 25,
            ),
            CustomTextField(
              text: 'Enter phone no',
              color: Colors.black,
              controller: phone,
              isIcon: false,
              isPreIcon: false,
            ),
            const SizedBox(
              height: 25,
            ),
            CustomTextField(
              text: 'Enter email',
              color: Colors.black,
              controller: email,
              isIcon: false,
              isPreIcon: false,
            ),
            const SizedBox(
              height: 25,
            ),
            CustomTextField(
              text: 'Enter password',
              color: Colors.black,
              controller: pass,
              isIcon: true,
              isPreIcon: false,
            ),
            const SizedBox(
              height: 25,
            ),
            CustomTextField(
              text: 'Confirm password',
              color: Colors.black,
              controller: confirmPass,
              isIcon: true,
              isPreIcon: false,
            ),
            const SizedBox(
              height: 25,
            ),
            CustomTextField(
              text: 'About',
              color: Colors.black,
              controller: about,
              isPreIcon: false,
              isIcon: false,
            ),
            const Spacer(
              flex: 2,
            ),
            CustomButton(
                color: Colors.black87,
                label: 'Sign Up',
                onPressed: () {
                  if (name.text != "" &&
                      email.text != "" &&
                      pass.text == confirmPass.text) {
                    createUserAndPassword();
                  } else if (pass.text != confirmPass.text) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("password does not match ")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("please enter the details ")));
                  }
                },
                textColor: Colors.white),
            const Spacer(
              flex: 3,
            )
          ],
        ),
      ),
    );
  }
}
