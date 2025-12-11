import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  static Function()? onNotificationTap;

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        print('Notification tapped - navigating to random meal');
        if (onNotificationTap != null) {
          onNotificationTap!();
        }
      },
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'daily_recipe_channel',
      'Daily Recipe Notifications',
      description: 'Get notified about the daily random recipe',
      importance: Importance.high,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    print('Notification service initialized');
  }

  Future<void> scheduleDailyRecipeNotification({int hour = 9, int minute = 0}) async {
    await _notifications.zonedSchedule(
      0,
      '🍽️ Recipe of the Day!',
      'Check out today\'s random meal recommendation',
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_recipe_channel',
          'Daily Recipe Notifications',
          channelDescription: 'Get notified about the daily random recipe',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    print('Daily notification scheduled for $hour:$minute');
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  Future<void> showTestNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'daily_recipe_channel',
      'Daily Recipe Notifications',
      channelDescription: 'Get notified about the daily random recipe',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await _notifications.show(
      999,
      'Recipe of the Day!',
      'Check out today\'s random meal recommendation',
      details,
    );

    print('Test notification sent');
  }

  Future<void> scheduleTestNotification({int seconds = 5}) async {
    await _notifications.zonedSchedule(
      888,
      'Check your daily meal!',
      'This notification was sent to you to remind you to check your daily meals!',
      tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_recipe_channel',
          'Daily Recipe Notifications',
          channelDescription: 'Get notified about the daily random recipe',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );

    print('Test notification scheduled for $seconds seconds from now');
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    print('All notifications cancelled');
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  Future<void> checkNotificationPermission() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
    _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    final bool? granted = await androidImplementation?.areNotificationsEnabled();
    print('Notifications enabled: $granted');

    if (granted == false) {
      print('Notifications are BLOCKED by the system!');
      await androidImplementation?.requestNotificationsPermission();
    }
  }
}