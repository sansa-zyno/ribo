import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ribo/constants/api.dart';
import 'package:ribo/constants/app.dart';
import 'package:ribo/forgot_password.dart';
import 'package:ribo/home.dart';
import 'package:ribo/register.dart';
import 'package:ribo/services/http.service.dart';
import 'package:ribo/services/local_storage.dart';
import 'widgets/GradientButton/GradientButton.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ///Text Editing Controllers
  TextEditingController userNameController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 25, right: 25),
        child: ListView(children: [
          SizedBox(
            height: 25,
          ),
          Image.asset(
            'assets/ribo-nobg.png',
            fit: BoxFit.contain,
            height: 200,
            width: 200,
          ),
          SizedBox(
            height: 25,
          ),
          Column(
            children: [
              RichText(
                  text: TextSpan(
                      style: TextStyle(
                        color: mycolor,
                        fontSize: 16,
                      ),
                      children: [
                    TextSpan(text: "Dont have an account yet ? "),
                    TextSpan(
                        text: "Sign up here",
                        style: TextStyle(
                            color: mycolor, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (ctx) => Register()),
                                (route) => false);
                          })
                  ])),
            ],
          ),
          SizedBox(height: 50),
          Center(
            child: Text(
              "Sign In",
              style: TextStyle(
                  fontSize: 28, color: mycolor, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Text("Username",
                  style: TextStyle(
                      fontSize: 16,
                      color: mycolor,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 8),
          _input("Enter Username", userNameController),
          SizedBox(height: 25),
          Row(
            children: [
              Text("Enter Password",
                  style: TextStyle(
                      fontSize: 16,
                      color: mycolor,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 8),
          _input("Enter Password", passwordController, obscure: true),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                          child: ForgotPassword()),
                    );
                  },
                  child: Text(
                    "Forgot Password ?",
                    style:
                        TextStyle(color: mycolor, fontWeight: FontWeight.bold),
                  )),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          loading
              ? Center(child: CircularProgressIndicator())
              : Container(
                  width: 250,
                  height: 50,
                  child: Hero(
                    tag: "Login",
                    child: GradientButton(
                      title: "Submit",
                      clrs: [mycolor, mycolor],
                      onpressed: () {
                        signin();
                      },
                    ),
                  ),
                ),
          SizedBox(
            height: 25,
          )
        ]),
      ),
    );
  }

  signin() async {
    loading = true;
    setState(() {});
    try {
      final apiResult = await HttpService.post(
        Api.login,
        {
          "username": userNameController.text,
          "password": passwordController.text,
        },
      );
      print(apiResult.data);
      //Map<String, String> result = apiResult.data as Map<String, String>;
      final result = jsonDecode(apiResult.data);
      print(result);
      if (result["Status"] == "succcess") {
        LocalStorage().setString("username", userNameController.text);
        Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 200),
                curve: Curves.easeIn,
                child: Home(
                  username: userNameController.text,
                )),
            (route) => false);
      } else {
        Get.defaultDialog(
          title: "${result["Report"]}",
          titleStyle: TextStyle(color: mycolor, fontWeight: FontWeight.bold),
          middleText: "Please check your sign in credentials",
          middleTextStyle: TextStyle(color: mycolor),
        ).then((value) => print("done"));
      }
    } catch (e) {
      Get.defaultDialog(
        title: "Error",
        titleStyle: TextStyle(color: mycolor, fontWeight: FontWeight.bold),
        middleText: "Please check your internet connection and try again",
        middleTextStyle: TextStyle(color: mycolor),
      ).then((value) => print("done"));
    }
    loading = false;
    setState(() {});
  }

  Widget _input(String hint, TextEditingController controller,
      {bool obscure = false}) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          border: Border.all(color: mycolor),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(2, 2))
          ]),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 15, 0),
        child: TextFormField(
          cursorColor: mycolor,
          obscureText: obscure,
          controller: controller,
          validator: (value) {
            if (value!.isEmpty) {
              return "This field must not be empty.";
            }
            return null;
          },
          decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontStyle: FontStyle.italic),
              //labelText: label,
              hintText: hint,
              focusColor: Colors.grey,

              //fillColor: Colors.white,

              fillColor: Colors.white),
          //keyboardType: TextInputType.emailAddress,
          style: TextStyle(
            fontFamily: "Poppins",
          ),
        ),
      ),
    );
  }
}
