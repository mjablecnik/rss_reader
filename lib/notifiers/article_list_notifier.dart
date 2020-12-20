import 'package:flutter/material.dart';
import 'package:flutter_web_app/models/article.dart';
import 'package:flutter_web_app/models/feed.dart';
import 'package:hive/hive.dart';

import '../main.dart';
import 'feed_list_notifier.dart';


class ArticleList extends ChangeNotifier {

  List<Article> _articleList;
  Feed _feed;
  FeedList _feeds;

  ArticleList(this._feeds);

  void setFeed(Feed feed) {
    _feed = feed;
    _articleList = feed.articles;
    notifyListeners();
  }

  List<Article> getArticles() {
    return this._articleList;
  }

  void save() {
    _feeds.saveArticles(_feed);
    notifyListeners();
  }

}
