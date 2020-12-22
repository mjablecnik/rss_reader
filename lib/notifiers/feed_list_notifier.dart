import 'package:flutter/material.dart';
import 'package:flutter_web_app/models/feed.dart';
import 'package:flutter_web_app/utils/downloader.dart';
import 'package:flutter_web_app/utils/enums.dart';
import 'package:hive/hive.dart';

import '../main.dart';


class FeedList extends ChangeNotifier {

  List<Feed> _feedList;
  Feed currentFeed;
  bool downloadingArticles = false;
  Sort sort = Sort.newToOld;

  FeedList() {
    _feedList = [];
    this.load().then((value) => this.loadSort());
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
      this._feedList.forEach((e) => e.saveArticles());
    }
    this.load();
  }

  Future<void> load() async {
    var box = Hive.box(hiveBoxName);
    this._feedList = List<Feed>.from(box.get('feeds') ?? []);
    this._feedList.forEach((e) => e.loadArticles());
  }

  void saveCurrentArticles() {
    currentFeed.saveArticles();
    notifyListeners();
  }

  void downloadAllArticles() {
    downloadingArticles = true;
    notifyListeners();
    var downloader = Downloader();

    var progress = 0;
    for (var feed in _feedList) {
      downloader.downloadArticles(feed).then((value) {
        feed.saveArticles();
        if (++progress == _feedList.length) {
          downloadingArticles = false;
          notifyListeners();
        }
      });
    }
  }

  void downloadArticles() {
    downloadingArticles = true;
    notifyListeners();

    Downloader().downloadArticles(currentFeed).then((value) {
      currentFeed.saveArticles();
      downloadingArticles = false;
      notifyListeners();
    });
  }

  void changeSort() {
    if (sort == Sort.newToOld) {
      sort = Sort.oldToNew;
    } else {
      sort = Sort.newToOld;
    }
    this.saveSort();
    this._feedList.forEach((e) => e.articlesSort = sort);
    notifyListeners();
  }


  void saveSort() {
    var box = Hive.box(hiveBoxName);
    box.put('sort', this.sort.toString());
  }

  Future<void> loadSort() async {
    var box = Hive.box(hiveBoxName);
    this.sort = await box.get('sort') == Sort.oldToNew.toString() ? Sort.oldToNew : Sort.newToOld;

    if (this.sort == Sort.newToOld) {
      this._feedList.forEach((e) => e.articlesSort = sort);
      notifyListeners();
    }
  }
}
