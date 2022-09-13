// Copyright 2022 Fredrick Allan Grott. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:buildvariants/main.dart';
import 'package:buildvariants/src/internals/build_variant_vars.dart';

void main() {
  Constants().setEnvironment(Environment.debug);
  mainDelegate();
}
