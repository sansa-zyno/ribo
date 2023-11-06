import 'dart:convert';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ribo/constants/api.dart';
import 'package:ribo/constants/app.dart';
import 'package:ribo/services/http.service.dart';
import 'package:ribo/services/local_storage.dart';

class ViewProperties extends StatefulWidget {
  ViewProperties({Key? key}) : super(key: key);

  @override
  State<ViewProperties> createState() => _ViewPropertiesState();
}

class _ViewPropertiesState extends State<ViewProperties> {
  List? tableDatas;

  getData() async {
    String username = await LocalStorage().getString("username");
    final table =
        await HttpService.post(Api.viewProperties, {"username": username});
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
                      "View Properties",
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
                  minWidth: 900,
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
                      label: Text('NAME',
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
                      label: Text('DESCRIPTION',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: mycolor)),
                    ),
                    DataColumn(
                      label: Text('TYPE',
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
                                    "${tableDatas![index]["Property Name"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                                DataCell(Text(
                                    "\u20A6${tableDatas![index]["Property Amount"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                                DataCell(Text(
                                    "${tableDatas![index]["Property Description"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                                DataCell(Text(
                                    "${tableDatas![index]["Property Type"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                              ]))
                      : []),
            )
          : Center(child: SpinKitDualRing(color: Color(0xFF072A6C))),
    );
  }
}
