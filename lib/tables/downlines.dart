import 'dart:convert';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ribo/constants/api.dart';
import 'package:ribo/constants/app.dart';
import 'package:ribo/services/http.service.dart';
import 'package:ribo/services/local_storage.dart';

class Downlines extends StatefulWidget {
  Downlines({Key? key}) : super(key: key);

  @override
  State<Downlines> createState() => _DownlinesState();
}

class _DownlinesState extends State<Downlines> {
  List? tableDatas;

  getData() async {
    String username = await LocalStorage().getString("username");
    final table =
        await HttpService.post(Api.downlinesDetails, {"username": username});
    tableDatas = jsonDecode(table.data);
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
                      "Downlines",
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
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 600,
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
                      label: Text('FULL NAME',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: mycolor)),
                    ),
                    DataColumn(
                      label: Text('EMAIL',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: mycolor)),
                    ),
                    DataColumn(
                      label: Text('PHONE',
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
                                    "${tableDatas![index]["lastName"]} ${tableDatas![index]["firstName"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                                DataCell(Text("${tableDatas![index]["email"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                                DataCell(Text("${tableDatas![index]["phone"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                              ]))
                      : []),
            )
          : Center(child: SpinKitDualRing(color: mycolor)),
    );
  }
}
