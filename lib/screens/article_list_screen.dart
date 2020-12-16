import 'package:flutter/material.dart';
import 'package:flutter_web_app/models/article.dart';
import 'package:flutter_web_app/models/feed.dart';


class ArticleListScreen extends StatelessWidget {

  Feed currentFeed;

  ArticleListScreen ({ Key key, this.currentFeed }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Articles"),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 30),
        padding: const EdgeInsets.all(15),
        child: ArticleList(articles: currentFeed.articles),
      ),
    );
  }
}


class ArticleList extends StatefulWidget {

  List<Article> articles;

  ArticleList ({ Key key, this.articles }): super(key: key);

  @override
  _ArticleListState createState() => _ArticleListState();
}


class _ArticleListState extends State<ArticleList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        for (var article in widget.articles)
          Container(
            height: 50,
            color: Colors.amber[600],
            child: Center(child: Text(article.title)),
          ),
      ],
    );
  }
}

