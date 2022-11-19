// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_store/minor_screens/hot_deals.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  Timer? countDownTimer;
  int seconds = 3;
  List<int> discountList = [];
  int? maxDiscount;

  @override
  void initState() {
    startTimer();
    getDiscount();
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

  void getDiscount() {
    FirebaseFirestore.instance.collection('products').get().then(
      (QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          discountList.add(doc['discount']);
        }
      },
    ).whenComplete(
      () => setState(
        () {
          maxDiscount = discountList.reduce(max);
        },
      ),
    );
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
                  builder: (context) => HotDealsScreen(
                    fromOnBoarding: true,
                    maxDiscount: maxDiscount.toString(),
                  ),
                ),
                (Route route) => false,
              );
              // Navigator.of(context).pushAndRemoveUntil(
              //   MaterialPageRoute(
              //     builder: (context) => const ShoesGalleryScreen(
              //       fromOnboarding: true,
              //     ),
              //   ),
              //   (Route route) => false,
              // );
              // Navigator.of(context).pushAndRemoveUntil(
              //   MaterialPageRoute(
              //     builder: (context) => const SubCategProducts(
              //       subcategName: 't-shirt',
              //       maincategName: 'men',
              //       fromOnBoarding: true,
              //     ),
              //   ),
              //   (Route route) => false,
              // );
            },
            child: Image.asset(
              'images/onboard/sale.JPEG',
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
