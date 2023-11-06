import 'dart:convert';
import 'package:achievement_view/achievement_view.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ribo/constants/api.dart';
import 'package:ribo/constants/app.dart';
import 'package:ribo/services/http.service.dart';
import 'package:ribo/services/local_storage.dart';

class ActiveContribution extends StatefulWidget {
  ActiveContribution({Key? key}) : super(key: key);

  @override
  State<ActiveContribution> createState() => _ActiveContributionState();
}

class _ActiveContributionState extends State<ActiveContribution> {
  List? tableDatas;
  String? username;

  getData() async {
    username = await LocalStorage().getString("username");
    final table =
        await HttpService.post(Api.activeContributions, {"username": username});
    tableDatas = jsonDecode(table.data);
    print(tableDatas.toString());
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
                      "Active Contributions",
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
      body: tableDatas != null
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: DataTable2(
                  columnSpacing: 15,
                  horizontalMargin: 12,
                  minWidth: 1900,
                  columns: [
                    DataColumn2(
                      label: Text('NO',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: mycolor)),
                      size: ColumnSize.S,
                    ),
                    DataColumn(
                      label: Text('CONTRIBUTION NAME',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: mycolor)),
                    ),
                    DataColumn(
                      label: Text('PAYMENT TYPE',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: mycolor)),
                    ),
                    DataColumn(
                      label: Text('AMOUNT',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: mycolor)),
                    ),
                    DataColumn(
                      label: Text('TOTAL AMOUNT PAID',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: mycolor)),
                    ),
                    DataColumn(
                      label: Text('TOTAL MONTHLY AMOUNT',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: mycolor)),
                    ),
                    DataColumn(
                      label: Text('DURATION',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: mycolor)),
                    ),
                    DataColumn(
                      label: Text('TOTAL MONTH PAID',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: mycolor)),
                    ),
                    DataColumn(
                      label: Text('ACTION',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: mycolor)),
                    ),
                  ],
                  rows: tableDatas!.isNotEmpty
                      ? List<DataRow>.generate(
                          tableDatas!.length,
                          (index) => DataRow(cells: [
                                DataCell(Text("${index + 1}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                                DataCell(Text(
                                    "${tableDatas![index]["Contribution Name"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                                DataCell(Text(
                                    "${tableDatas![index]["Payment Type"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                                DataCell(Text(
                                    "\u20A6${tableDatas![index]["Amount"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                                DataCell(Text(
                                    "\u20A6${tableDatas![index]["Total Amount Paid"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                                DataCell(Text(
                                    "\u20A6${tableDatas![index]["Total Monthly Amout"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                                DataCell(Text(
                                    "${tableDatas![index]["Duration"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                                DataCell(Text(
                                    "${tableDatas![index]["Total Month Paid"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                                DataCell(InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: mycolor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    padding: EdgeInsets.all(8),
                                    child: Text("Proceed",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16)),
                                  ),
                                  onTap: () {
                                    contribute(
                                        tableDatas![index]["Contribution ID"],
                                        tableDatas![index]["Payment Type"]);
                                  },
                                )),
                              ]))
                      : []),
            )
          : Center(child: SpinKitDualRing(color: mycolor)),
    );
  }

  contribute(id, paymentType) async {
    try {
      final res = await HttpService.post(Api.contribute,
          {"username": username, "id": id, "ptype": paymentType});
      //final result = jsonDecode(res.data);
      if (res.statusCode == 200) {
        AchievementView(
          context,
          color: mycolor,
          icon: Icon(
            Icons.check,
            color: Colors.white,
          ),
          title: "Success!",
          elevation: 20,
          subTitle: "Contribution successful",
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
          subTitle: "Request failed",
          isCircle: true,
        ).show();
      }
    } catch (e) {
      AchievementView(
        context,
        color: Colors.red,
        icon: Icon(
          Icons.bug_report,
          color: Colors.white,
        ),
        title: "Error!",
        elevation: 20,
        subTitle: "Something went wrong",
        isCircle: true,
      ).show();
    }
  }
}
