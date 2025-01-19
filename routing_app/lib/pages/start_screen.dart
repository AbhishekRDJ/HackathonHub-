import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:routing_app/pages/log_in_page.dart';
import 'package:routing_app/pages/sign_up_page.dart';
import 'package:routing_app/widget/custom_button.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _moveAnimation;
  late Animation<double> _buttonsFadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeIn)),
    );

    _moveAnimation = Tween<double>(begin: 0.0, end: -100.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 0.8, curve: Curves.easeInOut)),
    );

    _buttonsFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.8, 1.0, curve: Curves.easeIn)),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.translate(
                offset: Offset(0, _moveAnimation.value),
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SvgPicture.asset('assets/images/logo3.svg'),
                  ),
                ),
              ),
              const SizedBox(height: 50), // Space after the logo
              Opacity(
                opacity: _buttonsFadeAnimation.value,
                child: Column(
                  children: [
                    CustomButton(
                      color: Colors.white,
                      textColor: Colors.black,
                      label: "Sign Up",
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const SignUpPage()));
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomButton(
                      color: Colors.black,
                      textColor: Colors.white,
                      label: "Log In",
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const LogInPage()));
                      },
                    ),
                  ],
                ),
              ),

            ],
          );
        },
      ),
    );
  }
}
