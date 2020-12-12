import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_web_app/models/rss_feed.dart';
import 'package:flutter_web_app/screens/rss_finder_screen.dart';
import 'package:flutter_web_app/widgets/builders.dart';
import 'package:reorderables/reorderables.dart';
import '../main.dart';

class FeedGridScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rss feeds"),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        margin: const EdgeInsets.only(top: 30),
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
      width: 80,
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 6),
      child: Text(
          feed.title.length > 22 ? feed.title.substring(0, 19) : feed.title,
          style: TextStyle(fontSize: 12)
      ),
    );
  }

  Container getItemImage(Feed feed) {
    return Container(
        width: 60.0,
        height: 60.0,
        decoration: buildItemDecoration(feed)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, _) {
         var _items = [
          for (var feed in watch(feedsProvider).getFeeds())
            Container(
              child: Column(
                children: [
                  getItemImage(feed),
                  getItemText(feed),
                ],
              ),
            )
        ];

        return ReorderableWrap(
            spacing: 8.0,
            runSpacing: 4.0,
            padding: const EdgeInsets.all(8),
            children: _items,
            onReorder: context.read(feedsProvider).reorder,
        );
      },
    );
  }
}
