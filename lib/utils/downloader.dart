import 'dart:typed_data';

import 'package:charset_converter/charset_converter.dart';
import 'package:feed_finder/feed_finder.dart';
import 'package:flutter_web_app/models/feed.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';



class Downloader {

  Client _client;
  Uri _url;

  Downloader() {
    _client = http.Client();
  }

  _setUrl(Uri url) {
    if (!url.isScheme("https")) {
      this._url = Uri.parse("https://" + url.host + url.path);
    } else {
      this._url = url;
    }
  }

  Future<String> _getSource(String url) async {
    var response = await _client.get(url);
    if (response.headers["content-type"].toLowerCase().contains("utf-8")) {
      return response.body;
    } else {
      return CharsetConverter.decode("utf8", Uint8List.fromList(response.body.codeUnits));
    }
  }

  Future<List<Feed>> getFeeds(String url) async {
    List<Feed> feeds = [];
    _setUrl(Uri.parse(url));

    var feedUrls = await FeedFinder.scrape(this._url.toString(), verify: false);

    if (feedUrls.isNotEmpty) {
      for (var url in feedUrls) {
        try {
          var xmlSource = await _getSource(url);
          var feed = Feed.fromXml(url, xmlSource);
          feeds.add(feed);
        } catch (e) {
          print("Cannot gain RssFeed for: " + url);
        }
      }
    }
    return feeds;
  }

  Future<void> downloadArticles(Feed feed) async {
    try {
      var xmlSource = await _getSource(feed.sourceUrl);
      feed.parseNewArticles(xmlSource);
    } catch (e) {
      print("Cannot gain RssFeed for: " + feed.sourceUrl);
    }
  }
}