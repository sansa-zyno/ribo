import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:get/get.dart';
import 'package:ribo/add_fund_online.dart';
import 'package:ribo/constants/api.dart';
import 'package:ribo/constants/app.dart';
import 'package:ribo/services/http.service.dart';
import 'package:ribo/services/local_storage.dart';
import 'widgets/GradientButton/GradientButton.dart';

class AddFund extends StatefulWidget {
  const AddFund({Key? key}) : super(key: key);

  @override
  State<AddFund> createState() => _AddFundState();
}

class _AddFundState extends State<AddFund> {
  ///Text Editing Controllers
  TextEditingController amountController = TextEditingController(text: '');
  PlatformFile? file;
  Map? res;
  String dte = "Choose date";

  Future getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = result.files.single;
      setState(() {});
    } else {
      // User canceled the picker
    }
  }

  bool loading = false;

  getAccountDetails() async {
    final response = await HttpService.get(Api.bankDetails);
    res = jsonDecode(response.data)[0];
    setState(() {});
  }

  String? username;
  getusername() async {
    username = await LocalStorage().getString("username");
  }

  addFund() async {
    loading = true;
    setState(() {});
    print(username);
    final res = await HttpService.postWithFiles(Api.addFund, {
      "username": username,
      "date": dte,
      "amt": amountController.text,
      "image": dio.MultipartFile.fromBytes(File(file!.path!).readAsBytesSync(),
          filename: file!.name)
    });
    final result = jsonDecode(res.data);
    if (result["Status"] == "succcess") {
      Get.defaultDialog(
        title: "${result["Report"]}",
        titleStyle: TextStyle(color: mycolor, fontWeight: FontWeight.bold),
        middleText: "Fund details sent successfully",
        middleTextStyle: TextStyle(
          color: mycolor,
        ),
      ).then((value) => print("done"));
      amountController.text = "";
    } else {
      Get.defaultDialog(
        title: "${result["Report"]}",
        titleStyle: TextStyle(color: mycolor, fontWeight: FontWeight.bold),
        middleText: "Fund details not sent",
        middleTextStyle: TextStyle(color: mycolor, fontWeight: FontWeight.bold),
      ).then((value) => print("done"));
    }
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getusername();
    getAccountDetails();
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
                      "Add Fund",
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
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 25, right: 25),
          child: Column(children: [
            SizedBox(
              height: 15,
            ),
            Column(
              children: [
                Text(
                  "Pay To: ",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 150,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 3,
                                offset: Offset(3, 10))
                          ]),
                      child: Text("Bank:",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange)),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 3,
                                offset: Offset(3, 10))
                          ]),
                      child: Text(
                        "${res != null ? res!["bname"] : ""}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 150,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 3,
                                offset: Offset(3, 10))
                          ]),
                      child: Text("Account Name:",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange)),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 3,
                                offset: Offset(3, 10))
                          ]),
                      child: Text(
                        " ${res != null ? res!["aname"] : ""}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 150,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 3,
                                offset: Offset(3, 10))
                          ]),
                      child: Text("Account Number:",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange)),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 3,
                                offset: Offset(3, 10))
                          ]),
                      child: Text(
                        " ${res != null ? res!["anum"] : ""}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Text(
                  "Proof of Payment",
                  style: TextStyle(
                      fontSize: 16,
                      color: mycolor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              InkWell(
                onTap: () {
                  getFile();
                },
                child: Container(
                  height: 50,
                  width: 150,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: mycolor),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(2, 2))
                    ],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      bottomLeft: Radius.circular(5.0),
                    ),
                  ),
                  child: Text(
                    "Choose File",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: mycolor),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(2, 2))
                    ],
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5.0),
                      bottomRight: Radius.circular(5.0),
                    ),
                  ),
                  child: Text(
                    "${file != null ? file!.name.split("/").last : "No file chosen"}",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ),
            ]),
            SizedBox(height: 25),
            Row(
              children: [
                Text(
                  "Date of Payment",
                  style: TextStyle(
                      fontSize: 16,
                      color: mycolor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            InkWell(
                onTap: () async {
                  DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now());
                  if (date != null) {
                    dte = "${date.year}-${date.month}-${date.day}";
                    setState(() {});
                  }
                },
                child: Container(
                  height: 50,
                  width: 450,
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
                      padding: const EdgeInsets.all(15),
                      child: Text("$dte", style: TextStyle(fontSize: 16))),
                )),
            SizedBox(height: 25),
            Row(
              children: [
                Text(
                  "Amount To Fund",
                  style: TextStyle(
                      fontSize: 16,
                      color: mycolor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            _input("", amountController),
            SizedBox(
              height: 25,
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
                          if (file != null) {
                            addFund();
                          } else {
                            Get.defaultDialog(
                              title: "No proof of payment",
                              titleStyle: TextStyle(
                                  color: mycolor, fontWeight: FontWeight.bold),
                              middleText: "Please include proof of payment",
                              middleTextStyle: TextStyle(color: mycolor),
                            );
                          }
                        },
                      ),
                    ),
                  ),
            SizedBox(
              height: 25,
            ),
            Container(
              width: 250,
              height: 50,
              child: Hero(
                tag: "nav",
                child: GradientButton(
                  title: "Pay Online",
                  clrs: [mycolor, mycolor],
                  onpressed: () async {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => AddFundOnline()));
                  },
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
          ]),
        ),
      ),
    );
  }

  Widget _input(String hint, TextEditingController controller,
      {bool obscure = false, bool readOnly = false}) {
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
          readOnly: readOnly,
          keyboardType: TextInputType.number,
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
              hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
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
