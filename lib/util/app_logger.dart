import 'dart:async';
import 'dart:developer' as developer;
import 'package:logging/logging.dart';

class AppLogger {
  static void log(Object? message) {
    developer.log(message.toString(),
        name: "SafePickup",
        level: Level.INFO.value,
        zone: Zone.root,
        time: DateTime.now());
  }
}
