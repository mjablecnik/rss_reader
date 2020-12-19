import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_web_app/models/article.dart';
import 'package:flutter_web_app/models/feed.dart';

class ArticleListScreen extends StatelessWidget {
  final Feed currentFeed;

  ArticleListScreen({Key key, this.currentFeed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.currentFeed.title),
      ),
      body: ArticleList(articles: currentFeed.articles),
    );
  }
}

class ArticleList extends StatefulWidget {
  final List<Article> articles;

  ArticleList({Key key, this.articles}) : super(key: key);

  @override
  _ArticleListState createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: <Widget>[
        for (var article in widget.articles)
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1, color: Color.fromRGBO(191, 191, 191, 0.3)),
                borderRadius: BorderRadius.circular(7)
            ),
            margin: EdgeInsets.only(top: 5, bottom: 5),
            height: 150,
            child: Row(
              children: [
                Flexible(
                  flex: 6,
                  child: Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                article.title.length < 90 ? article.title : article.title.substring(0, 90) + "...",
                                style: TextStyle(fontWeight: FontWeight.bold)
                            ),
                          ),
                          Spacer(),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(DateFormat('HH:mm   dd.MM. yyyy').format(article.pubDate),
                                style: TextStyle(color: Colors.grey)
                            ),
                          ),
                        ],
                      )
                  ),
                ),
                Spacer(),
                Flexible(
                  flex: 5,
                  child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(7), bottomRight: Radius.circular(7)),
                          image: DecorationImage(
                              fit: BoxFit.fitHeight,
                              image: NetworkImage(article.imageUrl)
                          )
                      )
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
