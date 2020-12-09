import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_web_app/rss_finder.dart';
import 'main.dart';

class RssFeedListScreen extends StatelessWidget {
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
        child: RssFeedList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RssFinderScreen()
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }
}

class RssFeedList extends StatefulWidget {
  @override
  _RssFeedListState createState() => _RssFeedListState();
}

class _RssFeedListState extends State<RssFeedList> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, _) {

        return GridView.count(
          crossAxisCount: 4,
          crossAxisSpacing: 0,
          children: [
            for (var feed in watch(feedsProvider).getFeeds())
              Container(
                child: Column(
                  children: [
                    Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(feed.image != null ? feed.image.url : defaultImageUrl)
                            )
                        )
                    ),
                    Container(
                      width: 80,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 6),
                        child: Text(
                            feed.title.length > 22 ? feed.title.substring(0, 19) : feed.title,
                            style: TextStyle(fontSize: 12)
                        ),
                    ),
                  ],
                ),
              )
          ],
        );
      },
    );
  }
}

