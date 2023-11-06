import 'dart:convert';
import "dart:developer" as dev;
import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ribo/constants/api.dart';
import 'package:ribo/constants/app.dart';
import 'package:ribo/profile/edit_profile_setup.dart';
import 'package:ribo/services/http.service.dart';
import 'package:ribo/services/local_storage.dart';
import 'package:ribo/services/notification.service.dart';
import 'package:ribo/widgets/GradientButton/GradientButton.dart';

class AddFundOnline extends StatefulWidget {
  const AddFundOnline({Key? key}) : super(key: key);

  @override
  State<AddFundOnline> createState() => _AddFundOnlineState();
}

class _AddFundOnlineState extends State<AddFundOnline> {
  final plugin = PaystackPlugin();
  Map<String, dynamic> headers = {
    "Authorization": "Bearer $secretKey",
    "Content-Type": "application/json"
  };
  TextEditingController amtController = TextEditingController(text: '');
  List? tableDatas;
  Map? totalBalance;
  String? username;

  Future getUsername() async {
    username = await LocalStorage().getString("username");
  }

  Map? loadedData;
  getUserData() async {
    final res = await HttpService.post(Api.loadData, {"username": username});
    loadedData = jsonDecode(res.data)[0];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsername().then((value) => getUserData());
    plugin.initialize(publicKey: pubKey);
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
                      "Add Fund Online",
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
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            /*Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: mycolor,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    padding: EdgeInsets.all(15),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Account Balance",
                            style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      totalBalance != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "NGN ${totalBalance != null ? totalBalance!["money"].replaceAllMapped(reg, mathFunc) : ""}",
                                  style: TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            )
                          : SpinKitFadingCircle(
                              color: Colors.white,
                            ),
                      SizedBox(
                        height: 30,
                      ),
                    ]),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                          //color: Colors.orange,

                          ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        child: Image.asset(
                          "assets/7.jpeg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),*/
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Text("Amount",
                      style: TextStyle(
                          fontSize: 16,
                          color: mycolor,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: _input("Enter Amount", amtController),
            ),
            SizedBox(
              height: 100,
            ),
            Container(
              width: 250,
              height: 50,
              child: Hero(
                tag: "fund",
                child: GradientButton(
                  title: "Proceed",
                  clrs: [mycolor, mycolor],
                  onpressed: () async {
                    if (loadedData != null) {
                      if (amtController.text != "") {
                        try {
                          int amount = int.parse(amtController.text);
                          if (loadedData!["email"] != null &&
                              loadedData!["email"] != "") {
                            await HttpService.dio
                                .post("https://api.paystack.co/customer",
                                    data: {
                                      "email": "${loadedData!["email"]}",
                                      "first_name":
                                          "${loadedData!["firstname"] ?? ""}",
                                      "last_name":
                                          "${loadedData!["lastname"] ?? ""}",
                                      "phone": "${loadedData!["phone"] ?? ""}"
                                    },
                                    options: Options(headers: headers));

                            final res = await HttpService.dio.post(
                                "https://api.paystack.co/transaction/initialize",
                                data: {
                                  "email": "${loadedData!["email"]}",
                                  "amount": "${amount * 100}",
                                },
                                options: Options(headers: headers));
                            final result = res.data;
                            print(result["data"]["reference"]);
                            Charge charge = Charge()
                              ..amount = amount * 100
                              //..reference = username
                              ..accessCode = result["data"]["access_code"]
                              ..email = "${loadedData!["email"]}";

                            CheckoutResponse response = await plugin.checkout(
                                context,
                                charge: charge,
                                fullscreen: true);

                            print(response);

                            final resp =
                                await HttpService.post(Api.fundOnline, {
                              "username": username,
                              "tid": response.reference,
                              "status":
                                  response.status ? "success" : "declined",
                              "amount": amount,
                              "date":
                                  "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
                              "email": "${loadedData!["email"]}"
                            });

                            print(resp);
                            amtController.text = "";
                          } else {
                            Get.defaultDialog(
                                title: "Missing Email Address",
                                titleStyle: TextStyle(
                                    color: mycolor,
                                    fontWeight: FontWeight.bold),
                                middleText:
                                    "We need your email address to be able to register you as our customer on Paystack",
                                middleTextStyle: TextStyle(color: mycolor),
                                textConfirm: "Proceed",
                                confirmTextColor: Colors.white,
                                onConfirm: () {
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (ctx) => EditProfile()))
                                      .then((value) => getUserData());
                                },
                                textCancel: "Cancel",
                                onCancel: () {
                                  Navigator.of(context).pop();
                                });
                          }
                        } catch (e) {
                          Get.defaultDialog(
                            title: "Error",
                            titleStyle: TextStyle(
                                color: mycolor, fontWeight: FontWeight.bold),
                            middleText:
                                "Please remove any sign from the amount and try again",
                            middleTextStyle: TextStyle(color: mycolor),
                          );
                        }
                      } else {
                        Get.defaultDialog(
                          title: "Amount cannot be empty",
                          titleStyle: TextStyle(
                              color: mycolor, fontWeight: FontWeight.bold),
                          middleText: "Please enter an amount to fund",
                          middleTextStyle: TextStyle(color: mycolor),
                        );
                      }
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
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
          keyboardType: TextInputType.number,
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
