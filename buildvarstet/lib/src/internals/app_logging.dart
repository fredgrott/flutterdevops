// Copyright 2022 Fredrick Allan Grott. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// ignore_for_file: cast_nullable_to_non_nullable

import 'dart:developer';

import 'package:buildvarstet/src/internals/app_globals.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:logging_appenders/logging_appenders.dart';

Logger appLogger = Logger(kAppTitle);

/// AppLogging singleton to configure app logging, ti's called via
/// ```dart
/// AppLogging();
/// ```
///
/// @author Fredrick Allan Grott
class AppLogging {
  static late AppLogging _singleton;

  factory AppLogging() => _singleton = AppLogging._internal();

  AppLogging._internal() {
    if (kDebugMode) {
      // In debug mode we want all logging levels emitted.
      recordStackTraceAtLevel = Level.ALL;

      // Ignore avoid-ignoring-return-values.  
      Logger.root.onRecord.listen((record) {
        if (record.error != null && record.stackTrace != null) {
          log('${record.level.name}: ${record.loggerName}: ${record.time}: ${record.message}: ${record.error}: ${record.stackTrace}');

          log(
            'level: ${record.level.name} loggerName: ${record.loggerName} time: ${record.time} message: ${record.message} error: ${record.error} exception: ${record.stackTrace}',
          );
        } else if (record.error != null) {
          log('level: ${record.level.name} loggerName: ${record.loggerName} time: ${record.time} message: ${record.message} error: ${record.error}');
        } else {
          log('level: ${record.level.name} loggerName: ${record.loggerName} time: ${record.time} message: ${record.message}');
        }
      });

      MyDevLogAppender(formatter: const MyDevLogRecordFormatter())
          .attachToLogger(Logger.root);
    }

    if (kReleaseMode) {
      // In release app logging we want warning level and above only.
      recordStackTraceAtLevel = Level.WARNING;

      Logger.root.onRecord.listen((record) {
        if (record.error != null && record.stackTrace != null) {
          log('${record.level.name}: ${record.loggerName}: ${record.time}: ${record.message}: ${record.error}: ${record.stackTrace}');

          log(
            'level: ${record.level.name} loggerName: ${record.loggerName} time: ${record.time} message: ${record.message} error: ${record.error} exception: ${record.stackTrace}',
          );
        } else if (record.error != null) {
          log('level: ${record.level.name} loggerName: ${record.loggerName} time: ${record.time} message: ${record.message} error: ${record.error}');
        } else {
          log('level: ${record.level.name} loggerName: ${record.loggerName} time: ${record.time} message: ${record.message}');
        }
      });

      MyReleaseLogAppender(formatter: const MyReleaseLogRecordFormatter())
          .attachToLogger(Logger.root);
    }
  }
}

class MyDevLogAppender extends BaseLogAppender {
  void Function(Object line)? printer;
  MyDevLogAppender({LogRecordFormatter? formatter})
      : super(formatter ?? defaultLogRecordFormatter());

  MyDevLogAppender setupLogging({
    Level level = Level.ALL,
    Level stderrLevel = Level.OFF,
  }) {
    Logger.root.clearListeners();
    Logger.root.level = level;

    return defaultLogAppender(stderrLevel: stderrLevel)
      ..attachToLogger(Logger.root);
  }

  @override
  void handle(LogRecord record) {
    log(formatter.format(record));
  }
}

MyDevLogAppender defaultLogAppender({
  LogRecordFormatter? formatter,
  Level? stderrLevel,
}) =>
    MyDevLogAppender(formatter: formatter);

class MyReleaseLogAppender extends BaseLogAppender {
  void Function(Object line)? printer;
  MyReleaseLogAppender({LogRecordFormatter? formatter})
      : super(formatter ?? defaultReleaseLogRecordFormatter());

  MyReleaseLogAppender setupLogging({
    Level level = Level.ALL,
    Level stderrLevel = Level.OFF,
  }) {
    Logger.root.clearListeners();
    Logger.root.level = level;

    return defaultReleaseLogAppender(stderrLevel: stderrLevel)
      ..attachToLogger(Logger.root);
  }

  @override
  void handle(LogRecord record) {
    log(formatter.format(record));
  }
}

MyReleaseLogAppender defaultReleaseLogAppender({
  LogRecordFormatter? formatter,
  Level? stderrLevel,
}) =>
    MyReleaseLogAppender(formatter: formatter);

LogRecordFormatter defaultLogRecordFormatter() =>
    const DefaultLogRecordFormatter();

LogRecordFormatter defaultReleaseLogRecordFormatter() =>
    const DefaultLogRecordFormatter();

class MyDevLogRecordFormatter extends LogRecordFormatter {
  const MyDevLogRecordFormatter();
  @override
  StringBuffer formatToStringBuffer(
    LogRecord rec,
    StringBuffer sb,
  ) {
    sb.write('${rec.time} ${rec.level.name} ${rec.zone} '
        '${rec.loggerName} - ${rec.message}');

    if (rec.error != null) {
      sb.writeln();
      sb.write('### ${rec.error?.runtimeType}: ');
      sb.write(rec.error);
    }

    final stackTrace = rec.stackTrace ??
        (rec.error is Error ? (rec.error as Error).stackTrace : null);
    if (stackTrace != null) {
      sb.writeln();
      sb.write(stackTrace);
    }

    return sb;
  }
}

class MyReleaseLogRecordFormatter extends LogRecordFormatter {
  const MyReleaseLogRecordFormatter();
  @override
  StringBuffer formatToStringBuffer(
    LogRecord rec,
    StringBuffer sb,
  ) {
    sb.write('${rec.time} ${rec.level.name}  '
        '${rec.loggerName} - ${rec.message}');

    if (rec.error != null) {
      sb.writeln();
      sb.write('### ${rec.error?.runtimeType}: ');
      sb.write(rec.error);
    }

    final stackTrace = rec.stackTrace ??
        (rec.error is Error ? (rec.error as Error).stackTrace : null);
    if (stackTrace != null) {
      sb.writeln();
      sb.write(stackTrace);
    }

    return sb;
  }
}
