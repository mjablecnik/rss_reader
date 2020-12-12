import 'package:hive/hive.dart';

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

  @HiveField(6)
  String originalUrl;

  Feed (this.title, this.description, this.sourceUrl, this.imageUrl, this.lastPubDate, this.originalUrl);
}
