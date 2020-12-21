import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_web_app/main.dart';
import 'package:flutter_web_app/models/article.dart';
import 'package:flutter_web_app/screens/article_detail_screen.dart';
import 'package:intl/intl.dart';

enum Actions { removeAll, readAll, downloadNews, about }

class ArticleListScreen extends StatelessWidget {
  ArticleListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.read(feedsProvider).currentFeed.title),
        actions: [
          Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: PopupMenuButton<Actions>(
                child: Icon(Icons.more_vert),
                onSelected: (Actions result) {
                  var currentFeed = context.read(feedsProvider).currentFeed;
                  switch (result) {
                    case Actions.removeAll:
                      currentFeed.articles = [];
                      context.read(feedsProvider).saveCurrentArticles();
                      break;
                    case Actions.readAll:
                      currentFeed.articles.forEach((e) {
                        e.read = true;
                      });
                      context.read(feedsProvider).saveCurrentArticles();
                      break;
                    case Actions.downloadNews:
                      print("Download articles..");
                      break;
                    default:
                      print("Not implemented yet.");
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<Actions>>[
                  const PopupMenuItem<Actions>(
                    value: Actions.removeAll,
                    child: Text('Odstranit vše'),
                  ),
                  const PopupMenuItem<Actions>(
                    value: Actions.readAll,
                    child: Text('Označit vše jako přečtené'),
                  ),
                  const PopupMenuItem<Actions>(
                    value: Actions.downloadNews,
                    child: Text('Stáhnout nové články'),
                  ),
                  const PopupMenuItem<Actions>(
                    value: Actions.about,
                    child: Text('O aplikaci'),
                  ),
                ],
              ))
        ],
      ),
      body: Consumer(builder: (context, watch, _) {
        return ArticleList(articles: watch(feedsProvider).currentFeed.articles);
      }),
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
          GestureDetector(
            onTap: () {
              article.read = true;
              context.read(feedsProvider).saveCurrentArticles();

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ArticleDetailScreen(article: article)),
              );
            },
            child: ArticleItem(article: article),
          ),
      ],
    );
  }
}

class ArticleItem extends StatelessWidget {
  const ArticleItem({
    Key key,
    @required this.article,
  }) : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1, color: Color.fromRGBO(191, 191, 191, 0.3)),
          borderRadius: BorderRadius.circular(7)),
      margin: EdgeInsets.only(top: 5, bottom: 5),
      height: 150,
      child: Row(
        children: [
          Flexible(
            flex: 6,
            child: buildTextPart(),
          ),
          Spacer(),
          Flexible(
            flex: 5,
            child: buildImagePart(),
          ),
        ],
      ),
    );
  }

  Container buildImagePart() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(7),
          bottomRight: Radius.circular(7),
        ),
        image: DecorationImage(
          fit: BoxFit.fitHeight,
          image: NetworkImage(article.imageUrl),
        ),
      ),
    );
  }

  Container buildTextPart() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              article.title.length < 90 ? article.title : article.title.substring(0, 90) + "...",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: !article.read ? Colors.black : Colors.grey,
              ),
            ),
          ),
          Spacer(),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              DateFormat('dd.MM. yyyy  HH:mm').format(article.pubDate),
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
