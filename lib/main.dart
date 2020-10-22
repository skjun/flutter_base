import 'package:flutter/material.dart';
import 'package:medical/app.dart';

import 'package:medical/utils/provider_config.dart';

void main() {
  runApp(
    ProviderConfig.getInstance().getGlobal(Myapp()),
  );
}
