// Copyright 2022 Fredrick Allan Grott. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// ignore_for_file: unnecessary_late

enum Environment {
  debug,
  stagging,
  prod,
  preview,
  
}

late bool isItDebug = false;

late bool isItStagging = false;

late bool isItProd = false;

late bool isItPreview = false;


class Constants {
  late Map<String, dynamic> _config;

  void setEnvironment(Environment env) {
    switch (env) {
      case Environment.debug:
        _config = _Config.debugConstants;
        isItDebug = true;
        break;
      case Environment.stagging:
        _config = _Config.qaConstants;
        isItStagging = true;
        break;
      case Environment.prod:
        _config = _Config.prodConstants;
        isItProd = true;
        break;
      case Environment.preview:
        _config = _Config.previewConstants;
        isItPreview = true;
        break;
     
    }
  }

  dynamic get whereAmI {
    return _config[_Config.whereAmI];
  }
}


// ignore: avoid_classes_with_only_static_members
class _Config {
  static final Map<String, dynamic> debugConstants = <String, Object>{
    whereAmI: "debug",
  };

  static final Map<String, dynamic> prodConstants = <String, Object>{
    whereAmI: "prod",
  };

  static final Map<String, dynamic> qaConstants = <String, Object>{
    whereAmI: "stagging",
  };

  static final Map<String, dynamic> previewConstants = <String, Object>{
    whereAmI: "preview",
  };

  

  // Our env variables.
  static const whereAmI = "where_am_i";
}
