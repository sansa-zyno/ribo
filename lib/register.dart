import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ribo/constants/api.dart';
import 'package:ribo/constants/app.dart';
import 'package:ribo/home.dart';
import 'package:ribo/login.dart';
import 'package:ribo/services/http.service.dart';
import 'package:ribo/services/local_storage.dart';
import 'widgets/GradientButton/GradientButton.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  ///Text Editing Controllers
  TextEditingController userNameController = TextEditingController(text: '');
  TextEditingController refererUsernameController =
      TextEditingController(text: '');
  TextEditingController firstNameController = TextEditingController(text: '');
  TextEditingController lastNameController = TextEditingController(text: '');
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController phoneController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  TextEditingController confirmPasswordController =
      TextEditingController(text: '');
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.only(left: 25, right: 25),
      child: ListView(
        children: [
          SizedBox(
            height: 25,
          ),
          Image.asset(
            'assets/ribo-nobg.png',
            fit: BoxFit.contain,
            height: 200,
            width: 200,
          ),
          SizedBox(height: 25),
          Column(
            children: [
              RichText(
                  text: TextSpan(
                      style: TextStyle(
                        color: mycolor,
                        fontSize: 16,
                      ),
                      children: [
                    TextSpan(text: "Already have an account ? "),
                    TextSpan(
                        text: "Sign in here",
                        style: TextStyle(
                            color: mycolor, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (ctx) => Login()),
                                (route) => false);
                          })
                  ])),
            ],
          ),
          SizedBox(height: 30),
          Center(
            child: Text(
              "Sign Up",
              style: TextStyle(
                  fontSize: 28, color: mycolor, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Text(
                "Username",
                style: TextStyle(
                    fontSize: 16, color: mycolor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 8),
          _input("Enter Username", userNameController),
          SizedBox(height: 25),
          Row(
            children: [
              Text(
                "Referer Username",
                style: TextStyle(
                    fontSize: 16, color: mycolor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 8),
          _input("Enter Referer Id ", refererUsernameController),
          SizedBox(height: 25),
          Row(
            children: [
              Text(
                "First Name",
                style: TextStyle(
                    fontSize: 16, color: mycolor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 8),
          _input("Enter First Name", firstNameController),
          SizedBox(height: 25),
          Row(
            children: [
              Text(
                "Last Name",
                style: TextStyle(
                    fontSize: 16, color: mycolor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 8),
          _input("Enter Last Name", lastNameController),
          SizedBox(height: 25),
          Row(
            children: [
              Text(
                "Email Address",
                style: TextStyle(
                    fontSize: 16, color: mycolor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 8),
          _input("Enter Email Address", emailController),
          SizedBox(height: 25),
          Row(
            children: [
              Text(
                "Phone Number",
                style: TextStyle(
                    fontSize: 16, color: mycolor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 8),
          _input("Enter Phone No", phoneController),
          SizedBox(height: 25),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Password",
                          style: TextStyle(
                              fontSize: 16,
                              color: mycolor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    _input("", passwordController, obscure: true)
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Confirm Password",
                          style: TextStyle(
                              fontSize: 16,
                              color: mycolor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    _input("", confirmPasswordController, obscure: true)
                  ],
                ),
              )
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
                        signup();
                      },
                    ),
                  ),
                ),
          SizedBox(
            height: 25,
          )
        ],
      ),
    ));
  }

  signup() async {
    loading = true;
    setState(() {});
    try {
      final apiResult = await HttpService.post(
        Api.register,
        {
          "username": userNameController.text,
          "referer": refererUsernameController.text,
          "firstName": firstNameController.text,
          "lastName": lastNameController.text,
          "email": emailController.text,
          "phone": phoneController.text,
          "password": passwordController.text,
          "cpassword": confirmPasswordController.text
        },
      );
      print(apiResult);
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
                child: Home(username: userNameController.text)),
            (route) => false);
      } else {
        Get.defaultDialog(
          title: "${result["Report"]}",
          titleStyle: TextStyle(color: mycolor, fontWeight: FontWeight.bold),
          middleText: "Please check your sign up credentials",
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
      height: 60,
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

              fillColor: Color.fromARGB(255, 136, 0, 0)),
          //keyboardType: TextInputType.emailAddress,
          style: TextStyle(
            fontFamily: "Poppins",
          ),
        ),
      ),
    );
  }
}
