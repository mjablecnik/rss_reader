import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_web_app/main.dart';
import 'package:flutter_web_app/models/article.dart';
import 'package:flutter_web_app/screens/browser_screen.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  ArticleDetailScreen({Key key, this.article}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.read(feedsProvider).currentFeed.title),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Text(
              article.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 20, bottom: 20),
              padding: EdgeInsets.only(top: 5, bottom: 5),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: Colors.grey),
                  top: BorderSide(width: 1, color: Colors.grey),
                ),
              ),
              child: Text(
                DateFormat('dd.MM. yyyy  HH:mm').format(article.pubDate),
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Image.network(article.imageUrl),
            Container(
              margin: EdgeInsets.only(top: 30, bottom: 30),
              child: Text(
                HtmlUnescape().convert(article.description),
                style: TextStyle(fontSize: 17, height: 1.4),
              ),
            ),
            Container(
              height: 60,
              child: RaisedButton(
                color: Colors.white24,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BrowserScreen(url: article.originalUrl),
                    ),
                  );
                },
                child: Text(
                  "Pokračovat na web",
                  style: TextStyle(fontSize: 17, color: Colors.black54),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
