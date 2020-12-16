import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_app/screens/feed_grid_screen.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'models/article.dart';
import 'models/feed.dart';
import 'notifiers/FeedLIstNotifier.dart';


final feedsProvider = ChangeNotifierProvider<FeedList>((ref) => FeedList());

String defaultImageUrl = "https://img2.pngio.com/documentation-screenshotlayer-api-default-png-250_250.png";
String hiveBoxName = 'RssReader';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  Hive
    ..init(directory.path)
    ..registerAdapter(FeedAdapter())
    ..registerAdapter(ArticleAdapter());

  await Hive.openBox(hiveBoxName);

  runApp(
    ProviderScope(
      child: MaterialApp(
        home: FeedGridScreen()
      ),
    )
  );
}
