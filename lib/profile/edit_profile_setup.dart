import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ribo/constants/api.dart';
import 'package:ribo/constants/app.dart';
import 'package:ribo/services/http.service.dart';
import 'package:ribo/services/local_storage.dart';
import 'package:ribo/widgets/GradientButton/GradientButton.dart';
import 'package:achievement_view/achievement_view.dart';

class EditProfile extends StatefulWidget {
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  ///Text Editing Controllers
  TextEditingController firstNameController = TextEditingController(text: '');
  TextEditingController lastNameController = TextEditingController(text: '');
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController phoneController = TextEditingController(text: '');
  TextEditingController accountNameController = TextEditingController(text: '');
  TextEditingController accountNoController = TextEditingController(text: '');
  TextEditingController bankController = TextEditingController(text: '');
  bool loading = false;
  bool onPageLoad = false;
  String? username;

  OnPageLoad() async {
    onPageLoad = true;
    setState(() {});
    username = await LocalStorage().getString("username");
    final res = await HttpService.post(Api.loadData, {"username": username});
    Map result = jsonDecode(res.data)[0];
    firstNameController.text = result["fisrtname"] ?? "";
    lastNameController.text = result["lastname"] ?? "";
    emailController.text = result["email"] ?? "";
    phoneController.text = result["phone"] ?? "";
    accountNameController.text = result["accountname"] ?? "";
    accountNoController.text = result["accountnumber"] ?? "";
    bankController.text = result["bankname"] ?? "";
    onPageLoad = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    OnPageLoad();
  }

  @override
  Widget build(BuildContext context) {
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
                        "Edit Profile",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
        ),
        body: onPageLoad
            ? Center(child: SpinKitDualRing(color: mycolor))
            : Container(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: ListView(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      children: [
                        Text(
                          "First Name",
                          style: TextStyle(
                              fontSize: 16,
                              color: mycolor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    _input("", firstNameController),
                    SizedBox(height: 25),
                    Row(
                      children: [
                        Text(
                          "Last Name",
                          style: TextStyle(
                              fontSize: 16,
                              color: mycolor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    _input("", lastNameController),
                    SizedBox(height: 25),
                    Row(
                      children: [
                        Text(
                          "Phone Number",
                          style: TextStyle(
                              fontSize: 16,
                              color: mycolor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    _input("", phoneController, type: TextInputType.phone),
                    SizedBox(height: 25),
                    Row(
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(
                              fontSize: 16,
                              color: mycolor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    _input("", emailController,
                        readOnly: emailController.text == "" ? false : true),
                    SizedBox(height: 25),
                    Row(
                      children: [
                        Text(
                          "Account Name",
                          style: TextStyle(
                              fontSize: 16,
                              color: mycolor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    _input("", accountNameController),
                    SizedBox(height: 25),
                    Row(
                      children: [
                        Text(
                          "Account Number",
                          style: TextStyle(
                              fontSize: 16,
                              color: mycolor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    _input("", accountNoController, type: TextInputType.number),
                    SizedBox(height: 25),
                    Row(
                      children: [
                        Text(
                          "Bank Name",
                          style: TextStyle(
                              fontSize: 16,
                              color: mycolor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    _input("", bankController),
                    SizedBox(height: 25),
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
                                  update();
                                },
                              ),
                            ),
                          ),
                    SizedBox(height: 25),
                  ],
                ),
              ));
  }

  update() async {
    loading = true;
    setState(() {});
    final apiResponse = await HttpService.post(Api.editProfile, {
      "username": username,
      "firstname": firstNameController.text,
      "lastname": lastNameController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      "accountname": accountNameController.text,
      "accountno": accountNoController.text,
      "bank": bankController.text
    });
    final result = jsonDecode(apiResponse.data);
    print(result);
    if (result["Status"] == "succcess") {
      AchievementView(
        context,
        alignment: Alignment.topRight,
        color: mycolor,
        icon: Icon(
          Icons.check,
          color: Colors.white,
        ),
        title: "Success!",
        elevation: 20,
        subTitle: "Profile updated successfully",
        isCircle: true,
      ).show();
      Navigator.pop(context);
    } else {
      Get.defaultDialog(
        title: "${result["Report"]}",
        titleStyle: TextStyle(color: mycolor, fontWeight: FontWeight.bold),
        middleText: "Your input fields could not be updated",
        middleTextStyle: TextStyle(color: mycolor),
      ).then((value) => print("done"));
    }
    loading = false;
    setState(() {});
  }

  Widget _input(String hint, TextEditingController controller,
      {bool obscure = false,
      bool readOnly = false,
      TextInputType type = TextInputType.text}) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: mycolor),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(2, 2))
          ]),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 15, 0),
        child: TextFormField(
          keyboardType: type,
          cursorColor: mycolor,
          obscureText: obscure,
          readOnly: readOnly,
          controller: controller,
          validator: (value) {
            if (value!.isEmpty) {
              return "This field must not be empty.";
            }
            return null;
          },
          decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
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
