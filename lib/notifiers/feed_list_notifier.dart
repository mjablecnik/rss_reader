import 'package:flutter/material.dart';
import 'package:flutter_web_app/models/article.dart';
import 'package:flutter_web_app/models/feed.dart';
import 'package:hive/hive.dart';

import '../main.dart';


class FeedList extends ChangeNotifier {

  List<Feed> _feedList;
  Feed currentFeed;

  FeedList() {
    _feedList = [];
    this.load();
  }

  void add(Feed feed) {
    this._feedList.add(feed);
    notifyListeners();
  }

  bool contains(Feed feed) {
    return this._feedList.map((e) => e.sourceUrl).contains(feed.sourceUrl);
  }

  void reorder(int oldIndex, int newIndex) {
    var item = this._feedList.removeAt(oldIndex);
    this._feedList.insert(newIndex, item);
    notifyListeners();
    this.save(withArticles: false);
  }

  void remove(Feed feed) {
    this._feedList.removeWhere((e) => e.sourceUrl == feed.sourceUrl);
    notifyListeners();
  }

  List<Feed> getFeeds() {
    return _feedList;
  }

  void save({ bool withArticles = true }) {
    var box = Hive.box(hiveBoxName);
    box.put('feeds', this._feedList);
    if (withArticles) {
      this._feedList.forEach(saveArticles);
    }
    this.load();
  }

  Future<void> load() async {
    var box = Hive.box(hiveBoxName);
    this._feedList = List<Feed>.from(box.get('feeds') ?? []);
    this._feedList.forEach(loadArticles);
  }

  void saveArticles(Feed feed) {
    var hiveArticleListKey = "feed:${feed.sourceUrl}:article";
    var box = Hive.box(hiveBoxName);

    box.put(hiveArticleListKey, feed.articles);
  }

  Future<void> loadArticles(Feed feed) async {
    var hiveArticleListKey = "feed:${feed.sourceUrl}:article";
    var box = Hive.box(hiveBoxName);

    feed.articles = List<Article>.from(box.get(hiveArticleListKey) ?? []);
  }
}
