import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class LoggingAbstraction {
  StreamSubscription initializeLogging({List<Function(LogRecord)>? onLogs}) {
    Logger.root.level = Level.ALL; // Adjust this based on your needs

    return Logger.root.onRecord.listen((record) {
      if (!kReleaseMode) {
        _printLog(record);
        return;
      }
      if (onLogs != null) {
        for (Function(LogRecord) onLog in onLogs) {
          onLog(record);
        }
      }
    });
  }

  void _printLog(LogRecord record) {
    switch (record.level) {
      case Level.WARNING:
        debugPrint(
          '🟡 ${record.level.name}: ${record.loggerName}: ${record.message}',
        );
        break;
      case Level.SEVERE:
        debugPrint(
          '🔴 ${record.level.name}: ${record.loggerName}: ${record.message}',
        );
        break;
      case Level.SHOUT:
        debugPrint(
          '🔴 ${record.level.name}: ${record.loggerName}: ${record.message}',
        );
        break;
      default:
        debugPrint(
          '🟢 ${record.level.name}: ${record.loggerName}: ${record.message}',
        );
        break;
    }
  }
}
