import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ribo/add_fund.dart';
import 'package:ribo/constants/app.dart';
import 'package:ribo/dashboard.dart';
import 'package:ribo/payment/withdraw_funds.dart';
import 'package:boxicons/boxicons.dart';
import 'package:ribo/widgets/menu.dart';
import 'package:upgrader/upgrader.dart';
import 'package:double_back_to_close/double_back_to_close.dart';

class Home extends StatefulWidget {
  String username;
  Home({required this.username, Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late int pageIndex;
  late dynamic _showPage;
  late DashBoard _dashboard;
  late AddFund _addFund;
  late WithdrawFund _withdrawFund;

  //navbar
  _pageChooser(int page) {
    switch (page) {
      case 0:
        return _dashboard;

      case 1:
        return _addFund;

      case 2:
        return _withdrawFund;
      case 3:
        {
          _scaffoldKey.currentState!.openDrawer();
          return _dashboard;
        }
      default:
        return new Container(
            child: new Center(
          child: new Text(
            'No Page found by page thrower',
            style: new TextStyle(fontSize: 30),
          ),
        ));
    }
  }

  /* bg() async {
    await Future.delayed(Duration(seconds: 30), () async {
      await AppbackgroundService().startBg();
    });
  }*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dashboard = DashBoard(
      username: widget.username,
    );
    _addFund = AddFund();
    _withdrawFund = WithdrawFund();
    pageIndex = 0;
    _showPage = _pageChooser(pageIndex);
    //bg();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DoubleBack(
        message: "Press back again to close",
        child: Scaffold(
          key: _scaffoldKey,
          drawer: Menu(),
          body: UpgradeAlert(
              upgrader: Upgrader(
                dialogStyle: Platform.isIOS
                    ? UpgradeDialogStyle.cupertino
                    : UpgradeDialogStyle.material,
              ),
              child: _showPage),
          bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    size: 25,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.bar_chart,
                    size: 25,
                  ),
                  label: 'Fund Account',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Boxicons.bx_credit_card,
                    size: 25,
                  ),
                  label: 'Withdraw',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                    size: 25,
                  ),
                  label: 'Menu',
                ),
              ],
              showSelectedLabels: true,
              showUnselectedLabels: true,
              currentIndex: pageIndex,
              selectedItemColor: mycolor,
              unselectedItemColor: Colors.black,
              onTap: (int tappedIndex) {
                setState(() {
                  pageIndex = tappedIndex;
                  _showPage = _pageChooser(pageIndex);
                });
              }),
        ),
      ),
    );
  }
}
