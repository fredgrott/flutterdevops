// Copyright 2022 Fredrick Allan Grott. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// ignore_for_file: cast_nullable_to_non_nullable

import 'dart:async';

import 'package:buildvarstet/src/controllers/settings_controller.dart';
import 'package:buildvarstet/src/internals/app_globals.dart';
import 'package:buildvarstet/src/internals/app_logging.dart';
import 'package:buildvarstet/src/internals/asset_list.dart';
import 'package:buildvarstet/src/internals/catcher_options.dart';
import 'package:buildvarstet/src/my_app.dart';
import 'package:buildvarstet/src/services/settings_service.dart';
import 'package:catcher/catcher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

// Required for build variants functionality.
void mainDelegate() => main();

//
// ignore: long-method
void main() async {
  // Ensure that the Flutter SkyEngine has fully initialized.
  final binding = WidgetsFlutterBinding.ensureInitialized();

  // Calls this as last step of WidgetsflutterBinding initialization.
  binding.addPostFrameCallback(
    (_) async {
      final Element? context = binding.renderViewElement;
      if (context != null) {
        for (final asset in assetList) {
          precacheImage(
            AssetImage(asset),
            context,
          );
        }
        for (final riveAsset in riveList) {
          RiveFile.asset(riveAsset);
        }
      }
    },
  );

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // This initializes the logging system.
  AppLogging();

  appLogger.info("app initialized");

  // An internal FlutterError reporter that dumps to console.
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (kDebugMode) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode report to the application zone to report to
      // app exceptions provider. We do not need this in Profile mode.
      // ignore: no-empty-block
      if (kReleaseMode) {
        // FlutterError class has something not changed as far as null safety
        // so I just assume we do not have a stack trace but still want the
        // detail of the exception.

        Zone.current.handleUncaughtError(
          details.exception,
          details.stack as StackTrace,
        );
      }
    }
  };

  runZonedGuarded<Future<void>>(
    () async {
      // Service and other initializations here
      // Catcher takes care of app-user feedback on app errors, error reports to devs and dev team via sentry,
      // crashanalytics, slack, etc.
      Catcher(
        rootWidget: MyApp(
          navigatorKey: kRootNavKey,
          settingsController: settingsController,
        ),
        debugConfig: debugOptions,
        releaseConfig: releaseOptions,
        navigatorKey: kRootNavKey,
      );
    },
    (
      Object error,
      StackTrace stack,
      //
      // ignore: no-empty-block
    ) {
      // MyBackend.sendError(error, stack);.
    },
    zoneSpecification: ZoneSpecification(
      // Intercept all print calls.
      print: (
        self,
        parent,
        zone,
        line,
      ) async {
        // Include a timestamp and the name of the App.
        final messageToLog = "[${DateTime.now()}] $kAppTitle $line $zone";

        // Also print the message in the "Debug Console"
        // but it's ony an info message and contains no
        // privacy prohibited stuff
        parent.print(
          zone,
          messageToLog,
        );
      },
    ),
  );
}
