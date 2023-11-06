import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';

class NotificationService {
  //
  //static const platform = MethodChannel('notifications.test');
  //
  static initializeAwesomeNotification() async {
    await AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      'resource://drawable/launcher_icon',
      [
        appNotificationChannel(),
      ],
    );
    //requet notifcation permission if not allowed
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // Insert here your friendly dialog box before call the request method
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  static NotificationChannel appNotificationChannel() {
    //firebase fall back channel key
    //fcm_fallback_notification_channel
    return NotificationChannel(
      channelKey: 'efn',
      channelName: 'Basic notifications',
      channelDescription: 'Notification channel for efn app',
      importance: NotificationImportance.High,
      //soundSource: "resource://raw/alert",
      playSound: true,
    );
  }

  static listenToActions() {
    AwesomeNotifications().actionStream.listen((receivedNotification) async {
      //if notification is from order
      if (receivedNotification.payload != null) {
        //Get.to(LatestNews());
      }
    });
  }
}
