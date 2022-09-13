import 'package:buildvariants/src/app.dart';
import 'package:buildvariants/src/controllers/settings_controller.dart';
import 'package:buildvariants/src/internals/assets_list.dart';
import 'package:buildvariants/src/services/settings_service.dart';
import 'package:flutter/material.dart';

// Required for build variants functionality.
void mainDelegate() => main();



void main() async {

  // Ensure that the Flutter SkyEngine has fully initialized.
  final binding = WidgetsFlutterBinding.ensureInitialized();

  // Calls this as last step of WidgetsflutterBinding initialization.
  binding.addPostFrameCallback((_) async {
    final Element? context = binding.renderViewElement;
    if (context != null) {
      for (final asset in assetList) {
        precacheImage(
          AssetImage(asset),
          context,
        );
      }
    }
  });




  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(settingsController: settingsController));
}
