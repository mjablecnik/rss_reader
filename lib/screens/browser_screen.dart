import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_web_app/screens/url_form_screen.dart';



class BrowserScreen extends StatefulWidget {

  String url;

  BrowserScreen ({ Key key, this.url }): super(key: key);

  @override
  _BrowserScreenState createState() => new _BrowserScreenState();

}


class _BrowserScreenState extends State<BrowserScreen> {

  InAppWebViewController webView;
  String url;
  double progress = 0;
  bool withUrlBar = false;
  bool withButtonBar = false;


  @override
  void initState() {
    this.url = widget.url.replaceAll("http://", "https://");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Container getUrlBar(bool show) {
    if (show) {
      return Container(
        padding: EdgeInsets.all(10.0),
        child: UrlForm(
          defaultUrl: widget.url.replaceAll("http://", "https://"),
          onSubmit: (url) {
            setState(() {
              this.url = url;
            });
            this.webView.loadUrl(url: url);
          },
        ),
      );
    } else {
      return Container();
    }
  }

  Container getProgressIndicator() {
    return Container(
        padding: EdgeInsets.all(1.0),
        child: progress < 1.0
            ? LinearProgressIndicator(value: progress)
            : Container()
    );
  }

  Container getWebView() {
    return Container(
      child: InAppWebView(
        initialUrl: this.url,
        initialHeaders: {},
        initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              debuggingEnabled: true,
            )
        ),
        onWebViewCreated: (InAppWebViewController controller) {
          webView = controller;
        },
        onLoadStart: (InAppWebViewController controller, String url) {
          setState(() {
            this.url = url;
          });
        },
        onLoadStop: (InAppWebViewController controller,
            String url) async {
          setState(() {
            this.url = url;
          });
        },
        onProgressChanged: (InAppWebViewController controller,
            int progress) {
          setState(() {
            this.progress = progress / 100;
          });
        },
      ),
    );
  }

  Container getButtonBar(bool show) {
    if (show) {
      return Container(
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Icon(Icons.arrow_back),
              onPressed: () {
                if (webView != null) {
                  webView.goBack();
                }
              },
            ),
            RaisedButton(
              child: Icon(Icons.arrow_forward),
              onPressed: () {
                if (webView != null) {
                  webView.goForward();
                }
              },
            ),
            RaisedButton(
              child: Icon(Icons.refresh),
              onPressed: () {
                if (webView != null) {
                  webView.reload();
                }
              },
            ),
            RaisedButton(
              child: Icon(Icons.arrow_downward),
              onPressed: () {
                setState(() {
                  this.withButtonBar = false;
                  this.withUrlBar = false;
                });
              },
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('InAppWebView Example'),
        actions: [
          GestureDetector(
            onTap: () => {
              setState(() {
                this.withButtonBar = withButtonBar ? false : true;
                this.withUrlBar = withUrlBar ? false : true;
              })
            },
            child: Container(
              margin: EdgeInsets.only(left: 16, right: 16),
              child: Icon(Icons.web)
            )
          )
        ],
      ),
      body: Container(
          child: Column(children: <Widget>[
          getUrlBar(withUrlBar),
          getProgressIndicator(),
          Expanded(child: getWebView()),
          getButtonBar(withButtonBar)
        ])
      ),
    );
  }
}