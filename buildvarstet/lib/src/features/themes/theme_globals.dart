// Copyright 2022 Fredrick Allan Grott. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:buildvarstet/src/features/themes/brand_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

bool isHighContrast =
    SchedulerBinding.instance.window.accessibilityFeatures.highContrast;

Brightness appBrightness = SchedulerBinding.instance.window.platformBrightness;
bool isDarkMode = appBrightness == Brightness.dark;

ThemeData materialThemeSwtich() {
  if (!isDarkMode && !isHighContrast) {
    return brandThemeDataLight;
  }
  if (!isDarkMode && isHighContrast) {
    return brandThemeDataLightHighContrast;
  }
  if (isDarkMode && isHighContrast) {
    return brandThemeDataDarkHighContrast;
  }

  return brandThemeDataDark;
}
