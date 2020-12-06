import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_web_app/url_form.dart';
import 'browser.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      home: UrlFormScreen()
    )
  );
}
