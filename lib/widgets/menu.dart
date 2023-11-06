import 'dart:convert';
import 'dart:io';
import 'package:achievement_view/achievement_view.dart';
import 'package:boxicons/boxicons.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ribo/activate.dart';
import 'package:ribo/add_fund.dart';
import 'package:ribo/constants/api.dart';
import 'package:ribo/home.dart';
import 'package:ribo/login.dart';
import 'package:ribo/payment/withdraw_funds.dart';
import 'package:ribo/profile/change_password.dart';
import 'package:ribo/profile/edit_profile_setup.dart';
import 'package:ribo/services/http.service.dart';
import 'package:ribo/services/local_storage.dart';
import 'package:ribo/submit_sale.dart';
import 'package:ribo/support.dart';
import 'package:ribo/tables/downlines.dart';
import 'package:ribo/upgrade.dart';
import 'package:ribo/view_messages.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:ribo/tables/active_contributions.dart';
import 'package:ribo/tables/approved_earning_history.dart';
import 'package:ribo/tables/approved_withdrawal_history.dart';
import 'package:ribo/tables/completed_contributions.dart';
import 'package:ribo/tables/contributions.dart';
import 'package:ribo/tables/funding_history.dart';
import 'package:ribo/tables/pending_earning_history.dart';
import 'package:ribo/tables/pending_withdrawal_history.dart';
import 'package:ribo/tables/properties_history.dart';
import 'package:ribo/tables/rejected_sales_history.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool profile = false;
  bool withdrawal = false;
  bool fund = false;
  bool contribution = false;
  bool properties = false;
  bool extra = false;

  XFile? image;
  String imageUrl = "";
  String? username;
  String? useremail;

  getUserData() async {
    username = await LocalStorage().getString("username");
    final response =
        await HttpService.post(Api.getEmail, {"username": username});
    useremail = jsonDecode(response.data)[0]["email"];
    setState(() {});
    getImage();
  }

  getImage() async {
    try {
      Response res = await HttpService.postWithFiles(
          Api.getProfilePics, {"username": username});
      print(res.data);
      imageUrl = jsonDecode(res.data)[0]["avatar"];
    } catch (e) {
      imageUrl = "";
    }
    setState(() {});
  }

  uploadImage() async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      Response res = await HttpService.postWithFiles(Api.changeProfilePics, {
        "username": username,
        "image": MultipartFile.fromBytes(File(image!.path).readAsBytesSync(),
            filename: image!.name)
      });
      final result = jsonDecode(res.data);
      if (result["Status"] == "succcess") {
        getImage();
        AchievementView(
          context,
          color: Color(0xFF072A6C),
          icon: Icon(
            Icons.check,
            color: Colors.white,
          ),
          title: "Success!",
          elevation: 20,
          subTitle: "Profile picture uploaded successfully",
          isCircle: true,
        ).show();
      } else {
        AchievementView(
          context,
          color: Colors.red,
          icon: Icon(
            Icons.bug_report,
            color: Colors.white,
          ),
          title: "Failed!",
          elevation: 20,
          subTitle: "Profile picture upload failed",
          isCircle: true,
        ).show();
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 7, 51, 133),
              ),
              currentAccountPicture: CircularProfileAvatar(
                "",
                backgroundColor: Color(0xffDCf0EF),
                initialsText: Text(
                  "+",
                  textScaleFactor: 1,
                  style: TextStyle(
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w900,
                      fontSize: 21,
                      color: Colors.white),
                ),
                //cacheImage: true,
                borderWidth: 2,
                elevation: 10,
                radius: 50,
                onTap: () {
                  uploadImage();
                },
                child: imageUrl != ""
                    ? Image.network(
                        "https://realtyinvestnetwork.com/office/uploads//images//${imageUrl.substring(15, (imageUrl.length))}",
                        fit: BoxFit.cover,
                      )
                    : Image.asset("assets/user.png"),
              ),
              accountName: Text("${username != null ? username : ""}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white)),
              accountEmail: Text("${useremail != null ? useremail : ""}",
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white))),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(15),
              children: [
                ListTile(
                  leading: Icon(
                    Boxicons.bxs_home_circle,
                    color: Color.fromARGB(255, 16, 73, 179),
                  ),
                  title: Text("Dashboard",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                          child: Home(
                            username: username!,
                          )),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Boxicons.bx_group,
                    color: Color.fromARGB(255, 16, 73, 179),
                  ),
                  title: Text("Downlines",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                          child: Downlines()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Boxicons.bx_aperture,
                    color: Color.fromARGB(255, 16, 73, 179),
                  ),
                  title: Text("Activate Account",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                          child: Activate()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Boxicons.bx_sun,
                    color: Color.fromARGB(255, 16, 73, 179),
                  ),
                  title: Text("Upgrade Account",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                          child: Upgrade()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Boxicons.bx_user,
                    color: Color.fromARGB(255, 16, 73, 179),
                  ),
                  title: Text("Profile",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded),
                    onPressed: () {
                      profile = !profile;
                      setState(() {});
                    },
                  ),
                ),
                Visibility(
                    visible: profile,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                              color: Color.fromARGB(255, 16, 73, 179),
                            ),
                            title: Text("Edit Profile",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                    child: EditProfile()),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                              color: Color.fromARGB(255, 16, 73, 179),
                            ),
                            title: Text("Change Password",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                    child: ChangePassword()),
                              );
                            },
                          ),
                        ],
                      ),
                    )),
                ListTile(
                  leading: Icon(
                    Boxicons.bx_credit_card,
                    color: Color.fromARGB(255, 16, 73, 179),
                  ),
                  title: Text("Withdrawal",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded),
                    onPressed: () {
                      withdrawal = !withdrawal;
                      setState(() {});
                    },
                  ),
                ),
                Visibility(
                    visible: withdrawal,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                              color: Color.fromARGB(255, 16, 73, 179),
                            ),
                            title: Text("Withdraw",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                    child: WithdrawFund()),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                              color: Color.fromARGB(255, 16, 73, 179),
                            ),
                            title: Text("Pending",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                    child: PendingHistory()),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                              color: Color.fromARGB(255, 16, 73, 179),
                            ),
                            title: Text("Approved",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                    child: ApprovedHistory()),
                              );
                            },
                          ),
                        ],
                      ),
                    )),
                ListTile(
                  leading: Icon(
                    Icons.bar_chart,
                    color: Color.fromARGB(255, 16, 73, 179),
                  ),
                  title: Text("Fund Account",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded),
                    onPressed: () {
                      fund = !fund;
                      setState(() {});
                    },
                  ),
                ),
                Visibility(
                    visible: fund,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                              color: Color.fromARGB(255, 16, 73, 179),
                            ),
                            title: Text("Fund Now",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                    child: AddFund()),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                              color: Color.fromARGB(255, 16, 73, 179),
                            ),
                            title: Text("Funding History",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                    child: FundingHistory()),
                              );
                            },
                          ),
                        ],
                      ),
                    )),
                ListTile(
                  leading: Icon(
                    Boxicons.bx_award,
                    color: Color.fromARGB(255, 16, 73, 179),
                  ),
                  title: Text("Home Contributions",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded),
                    onPressed: () {
                      contribution = !contribution;
                      setState(() {});
                    },
                  ),
                ),
                Visibility(
                    visible: contribution,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                              color: Color.fromARGB(255, 16, 73, 179),
                            ),
                            title: Text("Contributions",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                    child: Contribution()),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                              color: Color.fromARGB(255, 16, 73, 179),
                            ),
                            title: Text("Active Contributions",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                    child: ActiveContribution()),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                              color: Color.fromARGB(255, 16, 73, 179),
                            ),
                            title: Text("Completed Contributions",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                    child: CompletedContribution()),
                              );
                            },
                          ),
                        ],
                      ),
                    )),
                ListTile(
                  leading: Icon(
                    Boxicons.bx_lock,
                    color: Color.fromARGB(255, 16, 73, 179),
                  ),
                  title: Text("Properties",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded),
                    onPressed: () {
                      properties = !properties;
                      setState(() {});
                    },
                  ),
                ),
                Visibility(
                    visible: properties,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                              color: Color.fromARGB(255, 16, 73, 179),
                            ),
                            title: Text("View Properties",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                    child: ViewProperties()),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                              color: Color.fromARGB(255, 16, 73, 179),
                            ),
                            title: Text("Submit A Sale",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                    child: SubmitASale()),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                              color: Color.fromARGB(255, 16, 73, 179),
                            ),
                            title: Text("Approved Earnings",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                    child: ApprovedEarning()),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                              color: Color.fromARGB(255, 16, 73, 179),
                            ),
                            title: Text("Pending Earnings",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                    child: PendingEarning()),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                              color: Color.fromARGB(255, 16, 73, 179),
                            ),
                            title: Text("Rejected Sales",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                    child: RejectedSales()),
                              );
                            },
                          ),
                        ],
                      ),
                    )),
                ListTile(
                  leading: Icon(
                    Boxicons.bx_lock,
                    color: Color.fromARGB(255, 16, 73, 179),
                  ),
                  title: Text("Extras",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded),
                    onPressed: () {
                      extra = !extra;
                      setState(() {});
                    },
                  ),
                ),
                Visibility(
                    visible: extra,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                            ),
                            title: Text("Contact Support",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                    child: Support()),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                            ),
                            title: Text("View Messages",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                    child: ViewMessages()),
                              );
                            },
                          ),
                        ],
                      ),
                    )),
                ListTile(
                  leading: Icon(
                    Boxicons.bx_log_out_circle,
                    color: Color.fromARGB(255, 16, 73, 179),
                  ),
                  title: Text("Logout",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  onTap: () async {
                    LocalStorage().setString("username", "");
                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                          child: Login()),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
