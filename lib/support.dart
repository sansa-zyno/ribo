import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ribo/Widgets/GradientButton/GradientButton.dart';
import 'package:ribo/constants/api.dart';
import 'package:ribo/constants/app.dart';
import 'package:ribo/services/http.service.dart';
import 'package:ribo/services/local_storage.dart';

class Support extends StatefulWidget {
  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  TextEditingController subjectController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  String? username;

  getUserName() async {
    username = await LocalStorage().getString("username");
  }

  bool loading = false;
  contact() async {
    loading = true;
    setState(() {});
    print(username);
    final res = await HttpService.post(Api.contactSupport, {
      "username": username,
      "subject": subjectController.text,
      "comment": commentController.text
    });
    final result = jsonDecode(res.data);
    if (result["Status"] == "succcess") {
      Get.defaultDialog(
        title: "${result["Report"]}",
        titleStyle: TextStyle(color: mycolor, fontWeight: FontWeight.bold),
        middleText: "Message sent successfully",
        middleTextStyle: TextStyle(color: mycolor),
      ).then((value) => print("done"));
    } else {
      Get.defaultDialog(
        title: "${result["Report"]}",
        titleStyle: TextStyle(color: mycolor, fontWeight: FontWeight.bold),
        middleText: "Message not sent",
        middleTextStyle: TextStyle(color: mycolor),
      ).then((value) => print("done"));
    }
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width / 100;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        flexibleSpace: SafeArea(
          child: Container(
            height: 90,
            width: double.infinity,
            decoration: BoxDecoration(
              color: mycolor,
              border: Border.all(
                color: mycolor,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Contact Support",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: w * 6.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          children: [
            SizedBox(height: 15),
            Row(
              children: [
                Text(
                  "Subject",
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
            _input("", subjectController),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Text(
                  "Enter Your Message",
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
            Container(
              height: 350,
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                color: Colors.white30,
                border: Border.all(color: mycolor),
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                        hintText: "Leave a comment here"),
                    controller: commentController,
                    maxLines: 15,
                    maxLength: 450,
                  ))
                ],
              ),
            ),
            SizedBox(height: 50),
            loading
                ? Center(child: CircularProgressIndicator())
                : Container(
                    width: 220,
                    height: 50,
                    child: GradientButton(
                      title: "Submit",
                      clrs: [mycolor, mycolor],
                      onpressed: () async {
                        contact();
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
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
