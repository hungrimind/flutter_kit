import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class LoggingService {
  LoggingService() {
    _initializeLogging();
  }

  late StreamSubscription _loggerSubscription;

  void _initializeLogging() {
    Logger.root.level = Level.ALL; // Adjust this based on your needs

    _loggerSubscription = Logger.root.onRecord.listen((record) {
      if (!kReleaseMode) {
        _printLog(record);
        return;
      }

      // TODO: do any logging to sentry or other logging service in production
    });
  }

  void _printLog(LogRecord record) {
    switch (record.level) {
      case Level.WARNING:
        // ignore: avoid_print
        print('🟡 ${record.level.name}: ${record.loggerName}: ${record.message}');
        break;
      case Level.SEVERE:
        // ignore: avoid_print
        print('🔴 ${record.level.name}: ${record.loggerName}: ${record.message}');
        break;
      case Level.SHOUT:
        // ignore: avoid_print
        print('🔴 ${record.level.name}: ${record.loggerName}: ${record.message}');
        break;
      default:
        // ignore: avoid_print
        print('🟢 ${record.level.name}: ${record.loggerName}: ${record.message}');
        break;
    }
  }

  void dispose() {
    _loggerSubscription.cancel();
  }
}
