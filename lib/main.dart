import 'package:flutter/material.dart';
import 'package:phonebase/app.dart';

import 'package:phonebase/utils/provider_config.dart';

void main() {
  runApp(
    ProviderConfig.getInstance().getGlobal(Myapp()),
  );
}
