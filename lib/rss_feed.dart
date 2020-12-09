import 'package:flutter/material.dart';
import 'package:webfeed/domain/rss_feed.dart';

class RssFeedWrapper {

  String sourceUrl;
  RssFeed feed;

  RssFeedWrapper({sourceUrl, sourceXml, feed}) {
    this.sourceUrl = sourceUrl;
    this.feed = feed;
  }

  factory RssFeedWrapper.create(String sourceUrl, String sourceXml) {
    return RssFeedWrapper(sourceUrl: sourceUrl, feed: RssFeed.parse(sourceXml));
  }
}

class FeedList extends ChangeNotifier {

  List<RssFeedWrapper> feedList;

  FeedList() {
    this.feedList = [];
  }

  void add(RssFeedWrapper feed) {
    this.feedList.add(feed);
    notifyListeners();
  }

  bool contains(RssFeedWrapper feed) {
    return this.feedList.map((e) => e.sourceUrl).contains(feed.sourceUrl);
  }

  void remove(RssFeedWrapper feed) {
    this.feedList.removeWhere((e) => e.sourceUrl == feed.sourceUrl);
    notifyListeners();
  }

  List<RssFeed> getFeeds() {
    return feedList.map((e) => e.feed).toList();
  }
}
