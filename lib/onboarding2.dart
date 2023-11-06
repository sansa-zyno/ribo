import 'package:ribo/constants/app.dart';
import 'package:ribo/onboarding3.dart';
import 'package:ribo/widgets/GradientButton/GradientButton.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:page_transition/page_transition.dart';

class OnBoarding2 extends StatefulWidget {
  OnBoarding2({
    Key? key,
  }) : super(key: key);

  @override
  State<OnBoarding2> createState() => _OnBoarding2State();
}

class _OnBoarding2State extends State<OnBoarding2> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  'assets/ribo02.jpeg',
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: 70),
              /*Text(
                "OUR MISSION",
                style: TextStyle(
                    fontSize: 22,
                    color: mycolor,
                    fontWeight: FontWeight.bold,
                    fontFamily: "poppins"),
              ),
              SizedBox(height: 15),
              Text(
                "To create platforms that are transparent enough to make individuals and organizations see from onset that their investments are REAL, PROFITABLE, and SECURED.",
                style: TextStyle(fontSize: 14, fontFamily: "poppins"),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 100),*/
              Container(
                width: 250,
                height: 50,
                child: Hero(
                  tag: "Login",
                  child: GradientButton(
                    title: "Next",
                    clrs: [mycolor, mycolor],
                    onpressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeIn,
                            child: OnBoarding3()),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
