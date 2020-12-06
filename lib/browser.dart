import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';


class BrowserScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('InAppWebView Example'),
              //actions: [
              //  GestureDetector(
              //    onTap: () => {print("test")},
              //    child: Container(
              //      margin: EdgeInsets.only(left: 15, right: 15),
              //      child: Icon(Icons.refresh)
              //    )
              //  )
              //],
            ),
            body: Browser(),
        )
    );
  }
}

class Browser extends StatefulWidget {

  @override
  _BrowserState createState() => new _BrowserState();

}

class _BrowserState extends State<Browser> {

  InAppWebViewController webView;
  String url;
  double progress = 0;
  TextEditingController urlController = TextEditingController();
  bool withUrlBar = false;
  bool withButtonBar = false;

  _BrowserState() {
    url = "https://seznam.cz/";//context.read(browserDataProvider).state["url"];
  }

  @override
  void initState() {
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
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                  child: Container(
                      margin: EdgeInsets.only(left: 5, right: 20),
                      child: TextField(
                          controller: urlController
                      )
                  )
              ),
              ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 50),
                  child: RaisedButton(
                      onPressed: () =>
                      {
                        setState(() {
                          this.url = urlController.text;
                        }),
                        this.webView.loadUrl(url: this.url)
                      },
                      child: Text("Go")
                  )
              )
            ]),
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
      //margin: const EdgeInsets.all(10.0),
      //decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
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

    return Container(
      child: Column(children: <Widget>[
        getUrlBar(withUrlBar),
        getProgressIndicator(),
        Expanded(child: getWebView()),
        getButtonBar(withButtonBar)
      ])
    );
  }
}