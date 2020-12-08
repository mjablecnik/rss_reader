import 'package:flutter/material.dart';
import 'package:webfeed/domain/rss_feed.dart';

class MyRssFeed extends RssFeed {

  String rssLink;

  MyRssFeed(rssLink, title, link, image): super(title: title, link: link, image: image) {
    this.rssLink = rssLink;
  }

  factory MyRssFeed.from(String rssLink, RssFeed rssFeed) {
    return MyRssFeed(rssLink, rssFeed.title, rssFeed.link, rssFeed.image);
  }
}

class FeedList extends ChangeNotifier {

  Map<String, MyRssFeed> feed;

  FeedList() {
    this.feed = {};
  }

  void add(MyRssFeed feed) {
    this.feed.addAll({feed.rssLink: feed});
    notifyListeners();
  }

  bool contains(MyRssFeed feed) {
    return this.feed.containsKey(feed.rssLink);
  }

  void remove(MyRssFeed feed) {
    this.feed.remove(feed.rssLink);
    notifyListeners();
  }

  Map<String, MyRssFeed> getFeeds() {
    return feed;
  }
}
