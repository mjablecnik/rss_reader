import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_app/rss_feeds.dart';

import 'RssFeed.dart';


final feedsProvider = ChangeNotifierProvider<FeedList>((ref) => FeedList());

String defaultImageUrl = "https://img2.pngio.com/documentation-screenshotlayer-api-default-png-250_250.png";

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: RssFeedListScreen()
      ),
    )
  );
}
