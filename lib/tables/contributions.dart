import 'dart:convert';
import 'package:achievement_view/achievement_view.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ribo/constants/api.dart';
import 'package:ribo/constants/app.dart';
import 'package:ribo/services/http.service.dart';
import 'package:ribo/services/local_storage.dart';

class Contribution extends StatefulWidget {
  Contribution({Key? key}) : super(key: key);

  @override
  State<Contribution> createState() => _ContributionState();
}

class _ContributionState extends State<Contribution> {
  List? tableDatas;
  String? username;

  getData() async {
    username = await LocalStorage().getString("username");
    final table =
        await HttpService.post(Api.contributions, {"username": username});
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
                      "Contributions",
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
                  minWidth: 1050,
                  columns: [
                    DataColumn2(
                      label: Text('NO',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: mycolor)),
                      size: ColumnSize.S,
                    ),
                    DataColumn2(
                      label: Text('CONTRIBUTION NAME',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: mycolor)),
                      size: ColumnSize.L,
                    ),
                    DataColumn(
                      label: Text('DAILY',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: mycolor)),
                    ),
                    DataColumn(
                      label: Text('WEEKLY',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: mycolor)),
                    ),
                    DataColumn(
                      label: Text('MONTHLY',
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
                                DataCell(Text("${tableDatas![index]["cname"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                                DataCell(Text("${tableDatas![index]["daily"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                                DataCell(Text("${tableDatas![index]["weekly"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                                DataCell(Text(
                                    "${tableDatas![index]["monthly"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                                DataCell(Text(
                                    "${tableDatas![index]["duration"]}",
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
                                    child: Text("Contribute",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16)),
                                  ),
                                  onTap: () {
                                    contibute(tableDatas![index]["id"]);
                                  },
                                )),
                              ]))
                      : []),
            )
          : Center(child: SpinKitDualRing(color: mycolor)),
    );
  }

  contibute(id) async {
    try {
      final res = await HttpService.post(
          Api.newContributions, {"username": username, "id": id});
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
          subTitle: "New contribution created successfully",
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
