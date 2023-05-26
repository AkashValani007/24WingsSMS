import 'package:flutter/material.dart';

class ReminderView extends StatefulWidget {
  const ReminderView({Key? key}) : super(key: key);

  @override
  State<ReminderView> createState() => _ReminderViewState();
}

class _ReminderViewState extends State<ReminderView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Text("Reminder View"),
            ),
          ],
        ),
      ),
    );
  }
}
