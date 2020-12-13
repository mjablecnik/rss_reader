import 'package:flutter/material.dart';
import 'package:flutter_web_app/models/rss_feed.dart';
import 'package:hive/hive.dart';

import '../main.dart';


class FeedList extends ChangeNotifier {

  List<Feed> feedList;

  FeedList() {
    feedList = [];
    this.load();
  }

  void add(Feed feed) {
    this.feedList.add(feed);
    notifyListeners();
  }

  bool contains(Feed feed) {
    return this.feedList.map((e) => e.sourceUrl).contains(feed.sourceUrl);
  }

  void reorder(int oldIndex, int newIndex) {
    var item = this.feedList.removeAt(oldIndex);
    this.feedList.insert(newIndex, item);
    notifyListeners();
    this.save();
  }

  void remove(Feed feed) {
    this.feedList.removeWhere((e) => e.sourceUrl == feed.sourceUrl);
    notifyListeners();
  }

  List<Feed> getFeeds() {
    return feedList;
  }

  void save() {
    var box = Hive.box(hiveBoxName);
    var feeds = this.getFeeds();

    box.put('feeds', feeds);
    this.load();
  }

  Future<void> load() async {
    var box = Hive.box(hiveBoxName);
    feedList = List<Feed>.from(box.get('feeds') ?? []);
  }
}
