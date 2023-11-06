/*import 'dart:convert';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ribo/constants/api.dart';
import 'package:ribo/constants/app.dart';
import 'package:ribo/services/http.service.dart';
import 'package:ribo/services/local_storage.dart';

class tableDatas extends StatefulWidget {
  tableDatas({Key? key}) : super(key: key);

  @override
  State<tableDatas> createState() => _tableDatasState();
}

class _tableDatasState extends State<tableDatas> {
  List? tableDatas;

  getData() async {
    String username = await LocalStorage().getString("username");
    final table =
        await HttpService.post(Api.earningHistory, {"username": username});
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
                      "Earning History",
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
                    DataColumn(
                        label: Text('NO',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                    DataColumn(
                        label: Text("CONSULTANT USERNAME",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                    DataColumn(
                        label: Text("CONSULTANT PHONE NUMBER",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                    DataColumn(
                        label: Text("PROPERTY",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                    DataColumn(
                        label: Text("PROPERTY TYPE",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                    DataColumn(
                        label: Text("UNIT",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                    DataColumn(
                        label: Text("AMOUNT",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                    DataColumn(
                        label: Text("ACTUAL PURCHASE PRICE",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                    DataColumn(
                        label: Text("COMMISSION",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                    DataColumn(
                        label: Text("COMMISSION TYPE",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                    DataColumn(
                        label: Text("DATE",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                    DataColumn(
                        label: Text("STATUS",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
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
                                DataCell(Text("${tableDatas![index]["cname"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                                DataCell(Text(
                                    "${tableDatas![index]["property"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                                DataCell(Text("${tableDatas![index]["ptype"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                                DataCell(Text("${tableDatas![index]["cname"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                                DataCell(Text("${tableDatas![index]["amount"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                                DataCell(Text(
                                    "${tableDatas![index]["actamount"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                                DataCell(Text("${tableDatas![index]["comm"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                                DataCell(Text("${tableDatas![index]["ctype"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                                DataCell(Text("${tableDatas![index]["date"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                                DataCell(Text("${tableDatas![index]["status"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                              ]))
                      : []),
            )
          : Center(child: SpinKitDualRing(color: Color(0xFF072A6C))),
    );
  }
}*/
