import 'package:flutter/material.dart';

class TodayBooking extends StatefulWidget {
  const TodayBooking({Key? key}) : super(key: key);

  @override
  State<TodayBooking> createState() => _TodayBookingState();
}

class _TodayBookingState extends State<TodayBooking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Competed"),
        ],
      ),
    );
  }
}
