import 'dart:convert';
import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ribo/constants/api.dart';
import 'package:ribo/services/http.service.dart';
import 'package:ribo/services/local_storage.dart';
import 'package:ribo/services/notification.service.dart';
import 'package:ribo/widgets/GradientButton/GradientButton.dart';
import 'package:ribo/constants/app.dart';

class WithdrawFund extends StatefulWidget {
  const WithdrawFund({Key? key}) : super(key: key);

  @override
  State<WithdrawFund> createState() => _WithdrawFundState();
}

class _WithdrawFundState extends State<WithdrawFund> {
  TextEditingController amtController = TextEditingController(text: '');
  bool refresh = false;
  bool hideBalance = false;
  String? walletBalance;
  String? username;

  getData() async {
    username = await LocalStorage().getString("username");
    final balance =
        await HttpService.post(Api.walletBalance, {"username": username});
    walletBalance = balance.data;
    setState(() {});
  }

  refreshBalance(String username) async {
    refresh = true;
    setState(() {});
    final balance =
        await HttpService.post(Api.walletBalance, {"username": username});
    walletBalance = balance.data;
    refresh = false;
    setState(() {});
  }

  bool loading = false;
  withdrawFund() async {
    loading = true;
    setState(() {});
    final res = await HttpService.post(Api.withdrawFunds,
        {"username": username, "amount": amtController.text});
    final result = jsonDecode(res.data);
    print(result);
    if (result["Status"] == "succcess") {
      Get.defaultDialog(
        title: "${result["Report"]}",
        titleStyle: TextStyle(color: mycolor, fontWeight: FontWeight.bold),
        middleText: "Transaction successful",
        middleTextStyle: TextStyle(color: mycolor),
      ).then((value) => print("done"));
      amtController.text = "";
    } else {
      Get.defaultDialog(
        title: "${result["Report"]}",
        titleStyle: TextStyle(color: mycolor, fontWeight: FontWeight.bold),
        middleText: "Transaction failed",
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
    getData();
  }

  @override
  Widget build(BuildContext context) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String Function(Match) mathFunc = (Match match) => '${match[1]},';
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
                      "Withdraw Fund",
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
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                decoration: BoxDecoration(color: mycolor, boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 3,
                      offset: Offset(3, 10))
                ]),
                padding: EdgeInsets.all(15),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Balance",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          InkWell(
                            onTap: () {
                              refreshBalance(username!);
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.blue[300],
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                children: [
                                  refresh
                                      ? SpinKitFadingCircle(
                                          size: 25,
                                          color: Colors.white,
                                        )
                                      : Icon(
                                          Icons.sync,
                                          color: Colors.white,
                                        ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "Refresh balance",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          hideBalance
                              ? Text("")
                              : Text(
                                  "NGN ${walletBalance == null ? "" : walletBalance!.replaceAllMapped(reg, mathFunc)}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                          IconButton(
                              onPressed: () {
                                hideBalance = !hideBalance;
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.remove_red_eye_sharp,
                                color: Colors.white,
                              ))
                        ],
                      )
                    ]),
              ),
            ),
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
              child: _input("Enter Amount", amtController,
                  type: TextInputType.number),
            ),
            SizedBox(
              height: 100,
            ),
            loading
                ? Center(
                    child: SpinKitFadingCircle(
                    color: mycolor,
                  ))
                : Container(
                    width: 250,
                    height: 50,
                    child: Hero(
                      tag: "Login",
                      child: GradientButton(
                        title: "Withdraw",
                        clrs: [mycolor, mycolor],
                        onpressed: () {
                          withdrawFund();
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
      {bool obscure = false, TextInputType type = TextInputType.text}) {
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
