import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:webfeed/domain/rss_feed.dart';

import 'main.dart';

part 'rss_feed.g.dart';

@HiveType(typeId: 1)
class Feed extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  String sourceUrl;

  @HiveField(3)
  String imageUrl;

  @HiveField(4)
  String lastPubDate;

  @HiveField(5)
  bool read = false;

  Feed (this.title, this.description, this.sourceUrl, this.imageUrl, this.lastPubDate);
}



class RssFeedWrapper {

  String sourceUrl;
  RssFeed sourceFeed;
  Feed feed;

  RssFeedWrapper({sourceUrl, feed}) {
    this.sourceUrl = sourceUrl;
    this.sourceFeed = feed;
  }

  factory RssFeedWrapper.fromXml(String sourceUrl, String sourceXml) {
    return RssFeedWrapper(sourceUrl: sourceUrl, feed: RssFeed.parse(sourceXml));
  }
  
  factory RssFeedWrapper.fromFeed(Feed feed) {
    return RssFeedWrapper()..feed = feed;
  }
  
  Feed getFeed() {
    if (feed == null) {
      return new Feed(
          sourceFeed.title,
          sourceFeed.description,
          this.sourceUrl,
          sourceFeed.image != null ? sourceFeed.image.url : defaultImageUrl,
          sourceFeed.pubDate.toString()
      );
    } else {
      return feed;
    }
  }
}

class FeedList extends ChangeNotifier {

  List<RssFeedWrapper> feedWrapperList;

  FeedList() {
    feedWrapperList = [];
    this.load();
  }

  void add(RssFeedWrapper feed) {
    this.feedWrapperList.add(feed);
    notifyListeners();
  }

  bool contains(RssFeedWrapper feed) {
    return this.feedWrapperList.map((e) => e.sourceUrl).contains(feed.sourceUrl);
  }

  void remove(RssFeedWrapper feed) {
    this.feedWrapperList.removeWhere((e) => e.sourceUrl == feed.sourceUrl);
    notifyListeners();
  }

  List<Feed> getFeeds() {
    return feedWrapperList.map((e) => e.getFeed()).toList();
  }

  void save() {
    var box = Hive.box(hiveBoxName);
    var feeds = this.getFeeds();

    box.put('feeds', feeds);
    this.load();
  }

  Future<void> load() async {
    var box = Hive.box(hiveBoxName);
    var feeds = List<Feed>.from(box.get('feeds') ?? []);
    feedWrapperList = [
      for (var feed in feeds)
        RssFeedWrapper.fromFeed(feed)
    ];
  }
}
