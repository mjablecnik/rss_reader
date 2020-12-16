import 'package:hive/hive.dart';

part 'article.g.dart';

@HiveType(typeId: 2)
class Article extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  String originalUrl;

  @HiveField(4)
  String imageUrl;

  @HiveField(5)
  DateTime pubDate;

  @HiveField(6)
  bool read = false;


  Article (this.title, this.description, this.originalUrl, this.imageUrl, this.pubDate);

}
