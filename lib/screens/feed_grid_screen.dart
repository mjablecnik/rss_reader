import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_web_app/main.dart';
import 'package:flutter_web_app/models/feed.dart';
import 'package:flutter_web_app/screens/article_list_screen.dart';
import 'package:flutter_web_app/screens/rss_finder_screen.dart';
import 'package:flutter_web_app/widgets/builders.dart';
import 'package:reorderables/reorderables.dart';

class FeedGridScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rss feeds"),
        actions: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Consumer(
              builder: (ctx, watch, child) {
                if (watch(feedsProvider).downloadingArticles) {
                  return Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: 5),
                    child: SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(backgroundColor: Colors.white, strokeWidth: 3),
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: context.read(feedsProvider).downloadAllArticles,
                    child: Icon(Icons.refresh),
                  );
                }
              },
            ),
          )
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.all(15),
        child: FeedGrid(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RssFinderScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }
}

class FeedGrid extends StatefulWidget {
  @override
  _FeedGridState createState() => _FeedGridState();
}

class _FeedGridState extends State<FeedGrid> {
  Container getItemText(Feed feed) {
    return Container(
      width: 60,
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(top: 10),
      child: Text(
        feed.title,
        //feed.title.length > 22 ? feed.title.substring(0, 19) : feed.title
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
    );
  }

  Stack getItemImage(Feed feed) {
    var unreadArticlesNum = feed.articles.where((e) => !e.read).length;
    return Stack(
      children: <Widget>[
        Container(
          width: 60.0,
          height: 60.0,
          decoration: buildItemDecoration(feed),
        ),
        buildIndicator(unreadArticlesNum),
      ],
    );
  }

  Positioned buildIndicator(int unreadArticlesNum) {
    if (unreadArticlesNum == 0) {
      return Positioned(width: 0, height: 0, child: Container());
    }

    return Positioned(
      right: 0,
      height: 18,
      width: 15.0 + (unreadArticlesNum.toString().length * 5.0),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          color: Colors.red,
        ),
        alignment: Alignment.center,
        child: Text(
          unreadArticlesNum.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, _) {
        var _items = [
          for (var feed in watch(feedsProvider).getFeeds())
            GestureDetector(
              onTap: () {
                context.read(feedsProvider).currentFeed = feed;

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ArticleListScreen()),
                );
              },
              child: Container(
                child: Column(
                  children: [
                    getItemImage(feed),
                    getItemText(feed),
                  ],
                ),
              ),
            )
        ];

        return ReorderableWrap(
          spacing: 22.0,
          runSpacing: 10.0,
          padding: const EdgeInsets.all(8),
          children: _items,
          onReorder: context.read(feedsProvider).reorder,
        );
      },
    );
  }
}
