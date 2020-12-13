import 'package:hive/hive.dart';
import 'package:webfeed/domain/rss_feed.dart';

import '../main.dart';

part 'rss_feed.g.dart';

@HiveType(typeId: 1)
class Feed extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  String originalUrl;

  @HiveField(3)
  String sourceUrl;

  @HiveField(4)
  String imageUrl;

  @HiveField(5)
  DateTime lastPubDate;


  Feed (this.title, this.description, this.originalUrl, this.sourceUrl, this.imageUrl, this.lastPubDate);


  factory Feed.fromXml(String sourceUrl, String sourceXml) {
    var sourceFeed = RssFeed.parse(sourceXml);
    return new Feed(
        sourceFeed.title,
        sourceFeed.description,
        sourceFeed.link,
        sourceUrl,
        sourceFeed.image != null ? sourceFeed.image.url : defaultImageUrl,
        sourceFeed.pubDate
    );
  }
}
