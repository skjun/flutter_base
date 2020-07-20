import 'dart:convert' as convert;

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:phonebase/pages/main/mul_page.dart';

var indexPageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return MulPage();
});
