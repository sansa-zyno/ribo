import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ribo/constants/api.dart';
import 'package:ribo/constants/app.dart';
import 'package:ribo/services/http.service.dart';
import 'dart:developer';

class DashBoard extends StatefulWidget {
  String username;
  DashBoard({required this.username, Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  bool refresh = false;
  bool hideBalance = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController? scrollController = ScrollController();
  List imgList = [
    //"assets/ribo1.jpeg",
    //"assets/ribo2.jpeg",
    //"assets/ribo3.jpeg",
  ];
  String? refLink;

  String? walletBalance;
  String? salesBonus;
  String? indirectBonus;
  String? memberType;
  String? downlines;
  List? earningHistory;

  Future getDasboardData(username) async {
    final ref = await HttpService.post(Api.refLink, {"username": username});
    refLink = ref.data;
    setState(() {});

    final member = await HttpService.post(Api.mtype, {"username": username});
    memberType = member.data;
    setState(() {});

    final balance =
        await HttpService.post(Api.walletBalance, {"username": username});
    walletBalance = balance.data;

    setState(() {});
    final sales =
        await HttpService.post(Api.salesBonus, {"username": username});
    salesBonus = sales.data;
    setState(() {});
    final indirect =
        await HttpService.post(Api.indirectSales, {"username": username});
    indirectBonus = indirect.data;
    setState(() {});
    final downline =
        await HttpService.post(Api.downlines, {"username": username});
    downlines = downline.data;
    setState(() {});
    final earning =
        await HttpService.post(Api.earningHistory, {"username": username});
    earningHistory = jsonDecode(earning.data);
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDasboardData(widget.username);
  }

  @override
  Widget build(BuildContext context) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String Function(Match) mathFunc = (Match match) => '${match[1]},';
    return Scaffold(
      key: _scaffoldKey,
      /*appBar: AppBar(
        leading: Container(),
        toolbarHeight: 120,
        flexibleSpace: Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      height: 300,
                    ),
                    items: imgList
                        .map(
                          (item) => Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    opacity: 10.0,
                                    image: AssetImage(item),
                                    fit: BoxFit.cover)),
                          ),
                        )
                        .toList(),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(30),
                      ),
                      //color: mycolor,
                    ),
                    padding: EdgeInsets.all(15),
                    child: Column(children: [
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: () {
                                _scaffoldKey.currentState!.openDrawer();
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50 / 2),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.menu,
                                    color: mycolor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      /*Text(
                        "Welcome ${widget.username}",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: mycolor),
                      ),*/
                      /*SizedBox(
                        height: 5,
                      ),*/
                      /*Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: mycolor),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        padding: EdgeInsets.all(8),
                        width: 250,
                        child: Text("User ID: EFN1"),
                      ),*/
                    ]),
                  ),
                ],
              ),
            )
          ],
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
      ),*/
      body: ListView(
          controller: scrollController,
          physics: ClampingScrollPhysics(),
          children: [
            SizedBox(
              height: 15,
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
                              refreshBalance(widget.username);
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
              height: 15,
            ),
            Center(
              child: Text(
                "Referral Link :",
                style: TextStyle(
                  color: mycolor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                padding: EdgeInsets.all(15),
                child: refLink != null
                    ? Text(
                        refLink!,
                        style: TextStyle(color: mycolor, fontSize: 16),
                      )
                    : LinearProgressIndicator(
                        color: Colors.blue,
                      ),
              ),
            ),
            SizedBox(height: 15),
            Center(
              child: InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: refLink)).then((_) =>
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Link copied to clipboard",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.blue[400],
                      )));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: mycolor,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "Copy Referral Link",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          //border: Border.all(color: mycolor),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 10,
                                offset: Offset(2, 2))
                          ]),
                      padding: EdgeInsets.all(15),
                      child: Column(children: [
                        Text(
                          "Sales Bonus",
                          style: TextStyle(
                              color: mycolor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        salesBonus != null
                            ? Text("\u20A6 $salesBonus",
                                style: TextStyle(
                                    color: Colors.cyan,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16))
                            : SpinKitFadingCircle(
                                color: Colors.blue,
                              ),
                      ]),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          // border: Border.all(color: mycolor),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 10,
                                offset: Offset(2, 2))
                          ]),
                      padding: EdgeInsets.all(15),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Indirect Bonus",
                                style: TextStyle(
                                    color: mycolor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                            Icon(Icons.file_present, color: Colors.deepOrange),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        indirectBonus != null
                            ? Text("\u20A6 $indirectBonus",
                                style: TextStyle(
                                    color: Colors.cyan,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold))
                            : SpinKitFadingCircle(
                                color: Colors.blue,
                              )
                      ]),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          //border: Border.all(color: mycolor),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 10,
                                offset: Offset(2, 2))
                          ]),
                      padding: EdgeInsets.all(15),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "RIBO Member Type",
                                style: TextStyle(
                                    color: mycolor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                            Icon(Icons.event, color: Colors.deepOrange),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        memberType != null
                            ? Text("$memberType",
                                style: TextStyle(
                                    color: Colors.cyan,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold))
                            : SpinKitFadingCircle(
                                color: Colors.blue,
                              )
                      ]),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          // border: Border.all(color: mycolor),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 10,
                                offset: Offset(2, 2))
                          ]),
                      padding: EdgeInsets.all(15),
                      child: Column(children: [
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Downlines",
                              style: TextStyle(
                                  color: mycolor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            Icon(Icons.bar_chart, color: Colors.deepOrange),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        downlines != null
                            ? Text("$downlines",
                                style: TextStyle(
                                    color: Colors.cyan,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold))
                            : SpinKitFadingCircle(
                                color: Colors.blue,
                              )
                      ]),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Earnings History",
                            style: TextStyle(
                                fontSize: 16,
                                color: mycolor,
                                fontWeight: FontWeight.bold)),
                        Text("...",
                            style: TextStyle(fontSize: 16, color: mycolor))
                      ],
                    ),
                    SizedBox(height: 20),
                    Divider(),
                    SizedBox(height: 15),
                    earningHistory != null
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                                headingRowColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered))
                                    return Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.08);
                                  return mycolor; // Use the default value.
                                }),
                                columns: [
                                  DataColumn(
                                      label: Text('NO',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))),
                                  DataColumn(
                                      label: Text("CONSULTANT USERNAME",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))),
                                  /*DataColumn(
                                      label: Text("CONSULTANT PHONE NUMBER",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))),*/
                                  DataColumn(
                                      label: Text("PROPERTY",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))),
                                  DataColumn(
                                      label: Text("PROPERTY TYPE",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))),
                                  DataColumn(
                                      label: Text("UNIT",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))),
                                  DataColumn(
                                      label: Text("AMOUNT",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))),
                                  DataColumn(
                                      label: Text("ACTUAL PURCHASE PRICE",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))),
                                  DataColumn(
                                      label: Text("COMMISSION",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))),
                                  DataColumn(
                                      label: Text("COMMISSION TYPE",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))),
                                  DataColumn(
                                      label: Text("DATE",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))),
                                  DataColumn(
                                      label: Text("STATUS",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))),
                                ],
                                rows: List<DataRow>.generate(
                                    earningHistory!.length,
                                    (index) => DataRow(cells: [
                                          DataCell(Text("${index + 1}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                          DataCell(Text(
                                              "${earningHistory![index]["cname"]}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                          /* DataCell(Text(
                                              "${earningHistory![index]["cname"]}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.bold))),*/
                                          DataCell(Text(
                                              "${earningHistory![index]["property"]}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                          DataCell(Text(
                                              "${earningHistory![index]["ptype"]}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                          DataCell(Text(
                                              "${earningHistory![index]["nop"]}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                          DataCell(Text(
                                              "${earningHistory![index]["amount"].replaceAllMapped(reg, mathFunc)}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                          DataCell(Text(
                                              "${earningHistory![index]["actamount"].replaceAllMapped(reg, mathFunc)}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                          DataCell(Text(
                                              "${earningHistory![index]["comm"]}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                          DataCell(Text(
                                              "${earningHistory![index]["ctype"]}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                          DataCell(Text(
                                              "${earningHistory![index]["date"]}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                          DataCell(Text(
                                              "${earningHistory![index]["status"]}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                        ]))),
                          )
                        : LinearProgressIndicator(
                            color: Colors.blue,
                          )
                  ],
                ),
              ),
            ),
            //SizedBox(height: 90),
          ]),
    );
  }
}
