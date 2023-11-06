import 'package:ribo/constants/app.dart';
import 'package:ribo/onboarding2.dart';
import 'package:ribo/widgets/GradientButton/GradientButton.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class OnBoarding1 extends StatefulWidget {
  OnBoarding1({Key? key}) : super(key: key);

  @override
  State<OnBoarding1> createState() => _OnBoarding1State();
}

class _OnBoarding1State extends State<OnBoarding1> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    //border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10.0,
                          offset: Offset(2, 2),
                          color: Colors.grey.withOpacity(0.3))
                    ]),
                child: Image.asset(
                  'assets/ribo01.jpeg',
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: 70),
              /* Text(
                "OUR VISION",
                style: TextStyle(
                    color: mycolor,
                    fontSize: 22,
                    fontFamily: "poppins",
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Text(
                "To be the investor’s preferred destination as we offer real, profitable and secured investment portfolios.",
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
                            child: OnBoarding2()),
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
