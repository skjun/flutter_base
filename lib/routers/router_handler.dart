import 'dart:convert' as convert;

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:medical/bean/patients.dart';
import 'package:medical/utils/provider_config.dart';

var patientEditPageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return ProviderConfig.getInstance().getPatientPage(params['patient']);
});
