import 'package:ribo/constants/app.dart';
import 'package:ribo/login.dart';
import 'package:ribo/services/local_storage.dart';
import 'package:ribo/widgets/GradientButton/GradientButton.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class OnBoarding3 extends StatefulWidget {
  OnBoarding3({Key? key}) : super(key: key);

  @override
  State<OnBoarding3> createState() => _OnBoarding3State();
}

class _OnBoarding3State extends State<OnBoarding3> {
  onboardingShown() async {
    await LocalStorage().setBool("onboarded", true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    onboardingShown();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  'assets/ribo03.jpeg',
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: 70),
              /* Text(
                "OUR CORE VALUES",
                style: TextStyle(
                    color: mycolor,
                    fontSize: 22,
                    fontFamily: "poppins",
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              RichText(
                  text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: "poppins",
                      ),
                      children: [
                    TextSpan(text: "\u2013 Reliability\n\n"),
                    TextSpan(text: "\u2013 Efficiency\n\n"),
                    TextSpan(text: "\u2013 Affordability\n\n"),
                    TextSpan(text: "\u2013 Loyalty\n\n"),
                    TextSpan(text: "\u2013 Transparency\n\n"),
                    TextSpan(text: "\u2013 Yield")
                  ])),
              SizedBox(height: 100),*/
              Container(
                width: 250,
                height: 50,
                child: Hero(
                  tag: "Login",
                  child: GradientButton(
                    title: "Proceed",
                    clrs: [mycolor, mycolor],
                    onpressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeIn,
                            child: Login()),
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
