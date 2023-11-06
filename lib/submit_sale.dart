import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ribo/constants/api.dart';
import 'package:ribo/constants/app.dart';
import 'package:ribo/register.dart';
import 'package:ribo/services/http.service.dart';
import 'package:ribo/services/local_storage.dart';
import 'widgets/GradientButton/GradientButton.dart';
import 'package:dio/dio.dart' as dio;

class SubmitASale extends StatefulWidget {
  const SubmitASale({Key? key}) : super(key: key);

  @override
  State<SubmitASale> createState() => _SubmitASaleState();
}

class _SubmitASaleState extends State<SubmitASale> {
  ///Text Editing Controllers
  TextEditingController noPropertyController = TextEditingController(text: '');
  TextEditingController amountController = TextEditingController(text: '');
  TextEditingController actualPriceController = TextEditingController(text: '');
  List items = [
    {"Property Name": "Paucha Technology"}
  ];
  String val = "Paucha Technology";
  Map? res;
  String dte = "Choose date";

  PlatformFile? file;

  Future getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = result.files.single;
      setState(() {});
    } else {
      // User canceled the picker
    }
  }

  getAccountDetailsAndProperties() async {
    final response = await HttpService.get(Api.bankDetails);
    res = jsonDecode(response.data)[0];
    setState(() {});
    final resp = await HttpService.get(Api.viewProperties);
    items = jsonDecode(resp.data);
    setState(() {});
  }

  String? username;
  getusername() async {
    username = await LocalStorage().getString("username");
  }

  bool loading = false;
  aktivate() async {
    loading = true;
    setState(() {});
    print(username);
    final res = await HttpService.postWithFiles(Api.submitSale, {
      "username": username,
      "date": dte,
      "amt": amountController.text,
      "image": dio.MultipartFile.fromBytes(File(file!.path!).readAsBytesSync(),
          filename: file!.name),
      "name": val
    });
    final result = jsonDecode(res.data);
    if (result["Status"] == "succcess") {
      Get.defaultDialog(
        title: "${result["Report"]}",
        titleStyle: TextStyle(color: mycolor, fontWeight: FontWeight.bold),
        middleText: "Activation details sent successfully",
        middleTextStyle: TextStyle(
          color: mycolor,
        ),
      ).then((value) => print("done"));
    } else {
      Get.defaultDialog(
        title: "${result["Report"]}",
        titleStyle: TextStyle(color: mycolor, fontWeight: FontWeight.bold),
        middleText: "Activation details not sent",
        middleTextStyle: TextStyle(
          color: mycolor,
        ),
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
    getAccountDetailsAndProperties();
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
                      "Submit A Sale",
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
                  "Select Proof of Payment",
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
                  "Select Property",
                  style: TextStyle(
                      fontSize: 16,
                      color: mycolor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
                height: 50,
                width: 350,
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
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                      value: val,
                      underline: Container(),
                      style: TextStyle(color: Colors.black),
                      items: items
                          .map<DropdownMenuItem<String>>((value) =>
                              DropdownMenuItem(
                                  value: value["Property Name"],
                                  child: Text("${value["Property Name"]}")))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          val = value!;
                        });
                      }),
                )),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Text("Number Of Property Unit",
                    style: TextStyle(
                        fontSize: 16,
                        color: mycolor,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8),
            _input("Enter Number Of Property Unit", noPropertyController,
                type: TextInputType.number),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Text("Amount",
                    style: TextStyle(
                        fontSize: 16,
                        color: mycolor,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8),
            _input("Enter Amount", amountController,
                type: TextInputType.number),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Text("Actual Price",
                    style: TextStyle(
                        fontSize: 16,
                        color: mycolor,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8),
            _input("Enter Actual Purchase Price", actualPriceController,
                type: TextInputType.number),
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
                            aktivate();
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
            )
          ]),
        ),
      ),
    );
  }

  Widget _input(String hint, TextEditingController controller,
      {bool obscure = false,
      bool readOnly = false,
      TextInputType type = TextInputType.number}) {
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
          keyboardType: type,
          readOnly: readOnly,
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
