import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ribo/constants/app.dart';
import 'package:ribo/home.dart';
import 'package:ribo/login.dart';
import 'package:ribo/onboarding1.dart';
import 'package:ribo/services/http.service.dart';
import 'package:ribo/services/notification.service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'services/local_storage.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterStatusbarcolor.setStatusBarColor(mycolor);
  //await NotificationService.initializeAwesomeNotification();
  //await NotificationService.listenToActions();
  /*Workmanager().initialize(

      // The top level function, aka callbackDispatcher
      callbackDispatcher,

      // If enabled it will post a notification whenever
      // the task is running. Handy for debugging tasks
      isInDebugMode: false);*/
  // Periodic task registration
  /*Workmanager().registerPeriodicTask(
      "3",

      //This is the value that will be
      // returned in the callbackDispatcher
      "ribo",

      // When no frequency is provided
      // the default 15 minutes is set.
      // Minimum frequency is 15 min.
      // Android will automatically change
      // your frequency to 15 min
      // if you have configured a lower frequency.
      initialDelay: Duration(seconds: 5),
      frequency: Duration(minutes: 15),
      constraints: Constraints(
          networkType: NetworkType.connected,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresDeviceIdle: false,
          requiresStorageNotLow: false));*/
  runApp(const MyApp());
}

/*Future<String> api() async {
  final response = await HttpService.get("");
  //Response response = await Dio().get("http://lionstakers.com/api/test.php");

  //List list = response.data;
  List list = jsonDecode(response.data);
  dev.log("no errors from api");
  String lastItem = jsonEncode(list.last);
  return lastItem;
}*/

/*void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      SharedPreferences? prefs;

      setString(key, data) async {
        prefs = await SharedPreferences.getInstance();
        prefs!.setString(key, data);
      }

      getString(key) async {
        prefs = await SharedPreferences.getInstance();
        return prefs!.getString(key);
      }

      String localTimeZone =
          await AwesomeNotifications().getLocalTimeZoneIdentifier();
      String lastItem = await api();
      dev.log("before first time calling shared prefs");
      Map llastItem = jsonDecode(lastItem);
      String savedLastItem = await getString("lastItem") ?? "{\"id\":0}";
      Map ssaveLastItem = jsonDecode(savedLastItem);
      if (llastItem["id"] != ssaveLastItem["id"]) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: Random().nextInt(20),
                channelKey:
                    NotificationService.appNotificationChannel().channelKey!,
                title: "${llastItem["nhead"]}",
                body: "",
                icon: "resource://drawable/launcher_icon",
                // notificationLayout: NotificationLayout.BigPicture,
                //bigPicture: "resource://drawable/launcher_icon",
                payload: {"ndet": "${llastItem["ndet"]}"}),
            schedule: NotificationInterval(
                interval: 900, timeZone: localTimeZone, repeats: true));
      }
      setString("lastItem", lastItem);
    } catch (e) {
      // Logger flutter package, prints error on the debug console
      dev.log(e.toString());
      throw Exception(e);
    }
    return Future.value(true);
  });
}*/

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  String? username;
  bool? onboaded;
  bool loading = false;

  getUserData() async {
    loading = true;
    setState(() {});
    username = await LocalStorage().getString("username");
    try {
      onboaded = await LocalStorage().getBool("onboarded");
    } catch (e) {
      onboaded = false;
    }
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ribo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: loading
          ? Scaffold(
              body: Center(
                  child: SpinKitFadingCircle(
              color: Color(0xFF072A6C),
            )))
          : username != null && username != ""
              ? Home(username: username!)
              : onboaded == true
                  ? Login()
                  : OnBoarding1(),
    );
  }
}
