// Copyright 2022 Fredrick Allan Grott. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:buildvarstet/main.dart';
import 'package:buildvarstet/src/internals/build_variants_vars.dart';

void main() {
  Constants().setEnvironment(Environment.prod);
  mainDelegate();
}
