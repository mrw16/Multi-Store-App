// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:multi_store/minor_screens/subcateg_products.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  Timer? countDownTimer;
  int seconds = 3;

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void startTimer() {
    countDownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          seconds--;
        });
        if (seconds < 0) {
          stopTimer();
          Navigator.pushReplacementNamed(context, '/customer_home');
        }
        print(timer.tick);
        print(seconds);
      },
    );
  }

  void stopTimer() {
    countDownTimer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              stopTimer();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const SubCategProducts(
                    subcategName: 't-shirt',
                    maincategName: 'men',
                    fromOnBoarding: true,
                  ),
                ),
                (Route route) => false,
              );
            },
            child: Image.asset(
              'images/onboard/watches.JPEG',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 60,
            right: 30,
            child: Container(
              height: 35,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade600.withOpacity(0.5),
                borderRadius: BorderRadius.circular(25),
              ),
              child: MaterialButton(
                onPressed: () {
                  stopTimer();
                  Navigator.pushReplacementNamed(context, '/customer_home');
                },
                child: seconds < 1
                    ? const Text(
                        'Skip',
                      )
                    : Text(
                        'Skip | $seconds',
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
