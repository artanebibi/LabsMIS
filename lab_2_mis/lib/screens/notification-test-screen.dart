import 'package:flutter/material.dart';
import '../service/notification-service.dart';

class NotificationTestScreen extends StatelessWidget {
  final NotificationService _notificationService = NotificationService();

  NotificationTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Notifications'),
        backgroundColor: Colors.red.shade400,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Instant notification
            ElevatedButton.icon(
              icon: Icon(Icons.notifications_active),
              label: Text('Send Notification NOW'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.all(16),
              ),
              onPressed: () async {
                await _notificationService.showTestNotification();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Notification sent instantly!')),
                );
              },
            ),

            SizedBox(height: 16),

            // Schedule in 5 seconds
            ElevatedButton.icon(
              icon: Icon(Icons.timer),
              label: Text('Send Notification in 5 seconds'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.all(16),
              ),
              onPressed: () async {
                await _notificationService.scheduleTestNotification(seconds: 5);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Notification scheduled for 5 seconds!')),
                );
              },
            ),

            SizedBox(height: 16),

            // daily 09:00
            ElevatedButton.icon(
              icon: Icon(Icons.alarm),
              label: Text('Schedule Daily at 9:00 AM'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.all(16),
              ),
              onPressed: () async {
                await _notificationService.scheduleDailyRecipeNotification(
                  hour: 9,
                  minute: 0,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Daily notification set for 9:00 AM')),
                );
              },
            ),

            SizedBox(height: 16),

            // daily 21:00
            ElevatedButton.icon(
              icon: Icon(Icons.nightlight),
              label: Text('Schedule Daily at 9:00 PM'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: EdgeInsets.all(16),
              ),
              onPressed: () async {
                await _notificationService.scheduleDailyRecipeNotification(
                  hour: 21,
                  minute: 0,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Daily notification set for 9:00 PM')),
                );
              },
            ),

            SizedBox(height: 16),

            ElevatedButton.icon(
              icon: Icon(Icons.list),
              label: Text('Check Scheduled Notifications'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.all(16),
              ),
              onPressed: () async {
                var pending = await _notificationService.getPendingNotifications();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Pending Notifications'),
                    content: Text(
                        pending.isEmpty
                            ? 'No notifications scheduled'
                            : 'You have ${pending.length} notification(s) scheduled'
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),

            SizedBox(height: 16),

            // cancel alll notifications
            ElevatedButton.icon(
              icon: Icon(Icons.cancel),
              label: Text('Cancel All Notifications'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.all(16),
              ),
              onPressed: () async {
                await _notificationService.cancelAllNotifications();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('All notifications cancelled')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}