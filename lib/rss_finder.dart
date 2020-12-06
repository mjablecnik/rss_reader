import 'package:feed_finder/feed_finder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed/domain/rss_feed.dart';


class RssFinderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rss finder"),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: RssFinder(),
      ),
    );
  }
}

class RssFinder extends StatefulWidget {
  RssFinder({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RssFinder();
  }
}

class _RssFinder extends State<RssFinder> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();
  bool _showHiddingIcon = true;
  List<RssFeed> _rssFeeds = [];
  String _defaultImageUrl = "https://img2.pngio.com/documentation-screenshotlayer-api-default-png-250_250.png";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getSearchForm(),
        Container(
          padding: EdgeInsets.only(top: 10),
          height: 400,
          child: getRssFeedList(),
        )
      ],
    );
  }

  ListView getRssFeedList() {
    return ListView(
      children: <Widget>[
        for (var rssFeed in _rssFeeds)
          ListTile(
            leading: new Container(
              width: 60.0,
              height: 60.0,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: new NetworkImage(rssFeed.image != null ? rssFeed.image.url : _defaultImageUrl)
                )
              )),
            title: Text(rssFeed.title),
            subtitle: Text(rssFeed.link),
          )
      ],
    );
  }

  Form getSearchForm() {
    return Form(
      key: _formKey,
      child: Container(
        //color: Colors.red,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: getSearchField(),
            ),
            getSearchButton()
          ],
        ),
      ),
    );
  }

  GestureDetector getSearchButton() {
    return GestureDetector(
      onTap: () async {
        if (!_formKey.currentState.validate()) return;

        setState(() {
          _isLoading = true;
          _rssFeeds = [];
        });

        var url = Uri.parse(_controller.text);
        var httpsUrl;
        if (url.scheme != "https") {
          httpsUrl = "https://" + url.host + url.path;
        }

        var feedUrls = await FeedFinder.scrape(httpsUrl);
        if (feedUrls.isNotEmpty) {
          var client = http.Client();
          for (var url in feedUrls) {
            try {
              var response = await client.get(url);
              var feed = RssFeed.parse(response.body);
              setState(() {
                _rssFeeds.add(feed);
              });
            } catch (e) {
              print("Cannot gain RssFeed for: " + url);
            }
          }
          client.close();
          setState(() {
            _isLoading = false;
          });
        }
      },
      child: () {
        if (!_isLoading) {
          return Container(
            constraints: BoxConstraints(maxWidth: 48, maxHeight: 48),
            padding: const EdgeInsets.only(
                top: 8, left: 9, bottom: 8, right: 9),
            margin: const EdgeInsets.all(10),
            child: Icon(Icons.search, size: 20, color: Colors.white),
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(5)),
          );
        } else {
          return Container(
            padding: const EdgeInsets.only(top: 2),
            constraints: BoxConstraints(maxWidth: 25, maxHeight: 25),
            margin: const EdgeInsets.all(10),
            child: CircularProgressIndicator(),
          );
        }
      }()
    );
  }

  Padding getSearchField() {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: TextFormField(
        controller: _controller,
        textInputAction: TextInputAction.search,
        validator: (value) {
          RegExp exp = new RegExp(r"^[a-z0-9-./]+$");

          if (!exp.hasMatch(value)) {
            return 'This is not valid url';
          }
          return null;
        },
        onChanged: (text) {
          setState(() {
            _showHiddingIcon = _controller.text.length > 0;
          });
        },
        decoration: InputDecoration(suffixIcon: () {
          if (_showHiddingIcon) {
            return IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.red,
                ),
                splashColor: Colors.redAccent,
                onPressed: () {
                  setState(() {
                    _controller.clearComposing();
                    _showHiddingIcon = false;
                  });
                });
          } else {
            return null;
          }
        }()),
      ),
    );
  }
}
