import 'package:flutter/material.dart';
import 'package:ribo/widgets/custom_webview.page.dart';
import 'package:ribo/services/local_storage.dart';

class DirectGenealogy extends StatefulWidget {
  const DirectGenealogy({Key? key}) : super(key: key);

  @override
  State<DirectGenealogy> createState() => _DirectGenealogyState();
}

class _DirectGenealogyState extends State<DirectGenealogy> {
  Future getusername() async {
    String username = await LocalStorage().getString("username");
    return username;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 90,
            flexibleSpace: SafeArea(
              child: Container(
                height: 90,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  border: Border.all(
                    color: Colors.blue,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
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
                          "Direct Referal Genealogy",
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
          body: FutureBuilder(
              future: getusername(),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? CustomWebviewPage(
                        selectedUrl:
                            "https://empowermentfoodnetwork.com/office/viewtr.php?username=${snapshot.data}")
                    : Container();
              })),
    );
  }
}
