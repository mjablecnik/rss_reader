import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'browser2.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    //ProviderScope(child: BrowserScreen())
    BrowserScreen()
  );
}
