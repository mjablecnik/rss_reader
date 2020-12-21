import 'package:flutter_web_app/models/article.dart';
import 'package:hive/hive.dart';
import 'package:webfeed/domain/rss_feed.dart';

import '../main.dart';

part 'feed.g.dart';

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

  List<Article> articles;

  Feed (this.title, this.description, this.originalUrl, this.sourceUrl, this.imageUrl, this.lastPubDate);


  factory Feed.fromXml(String sourceUrl, String sourceXml) {
    var sourceFeed = RssFeed.parse(sourceXml);
    var feed = new Feed(
        sourceFeed.title,
        sourceFeed.description,
        sourceFeed.link,
        sourceUrl,
        sourceFeed.image != null ? sourceFeed.image.url : defaultImageUrl,
        sourceFeed.pubDate
    );

    feed.articles = [
      for (var item in sourceFeed.items)
        Article(item.title, item.description, item.link, item.enclosure.url, item.pubDate)
    ];
    return feed;
  }

  void saveArticles() {
    var hiveArticleListKey = "feed:${this.sourceUrl}:article";
    var box = Hive.box(hiveBoxName);

    box.put(hiveArticleListKey, this.articles);
  }

  Future<void> loadArticles() async {
    var hiveArticleListKey = "feed:${this.sourceUrl}:article";
    var box = Hive.box(hiveBoxName);

    this.articles = List<Article>.from(box.get(hiveArticleListKey) ?? []);
  }

  Future<void> parseNewArticles(xmlSource) async {
    var articles = Feed.fromXml(this.sourceUrl, xmlSource).articles;
    if (this.articles.isEmpty) {
      this.articles = articles;
    } else {
      List<Article> newArticles = [];
      for (var article in articles) {
        if (this.articles.where((e) => e.originalUrl == article.originalUrl).isEmpty) {
          newArticles.add(article);
        } else {
          break;
        }
      }

      this.articles.insertAll(0, newArticles);
    }
  }
}
