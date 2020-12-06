import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final browserDataProvider = StateProvider((ref) => BrowserData("https://zive.cz/"));
class BrowserData extends StateNotifier<int> {

  InAppWebViewController webView;
  String url;
  double progress = 0;
  bool withUrlBar;
  bool withButtonBar;

  BrowserData(url, {withUrlBar: true, withButtonBar: true}) : super(null) {
    this.url = url;
    this.withUrlBar = withUrlBar;
    this.withButtonBar = withButtonBar;
  }
}

class BrowserScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('InAppWebView Example'),
              actions: [
                GestureDetector(
                  onTap: () => {print("test")},
                  child: Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: Icon(Icons.refresh)
                  )
                )
              ],
            ),
            body: Browser(),
        )
    );
  }
}

class Browser extends StatelessWidget {

  //InAppWebViewController webView;
  //String url;
  //double progress = 0;
  TextEditingController urlController = TextEditingController();


  Container getUrlBar(BuildContext context, bool show) {
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
                      onPressed: ()
                      {
                        var browserData = context.read(browserDataProvider).state;
                        browserData.url = urlController.text;
                        browserData.webView.loadUrl(url: browserData.url);
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

  Container getProgressIndicator(BuildContext context) {
    var progress = context.read(browserDataProvider).state.progress;
    return Container(
        padding: EdgeInsets.all(1.0),
        child: progress < 1.0
            ? LinearProgressIndicator(value: progress)
            : Container()
    );
  }

  Container getWebView(BuildContext context) {
    return Container(
      //margin: const EdgeInsets.all(10.0),
      //decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
      child: InAppWebView(
        initialUrl: context.read(browserDataProvider).state.url,
        initialHeaders: {},
        initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              debuggingEnabled: true,
            )
        ),
        onWebViewCreated: (InAppWebViewController controller) {
          context.read(browserDataProvider).state.webView = controller;
        },
        onLoadStart: (InAppWebViewController controller, String url) {
          context.read(browserDataProvider).state.url = url;
        },
        onLoadStop: (InAppWebViewController controller, String url) async {
          context.read(browserDataProvider).state.url = url;
        },
        onProgressChanged: (InAppWebViewController controller, int progress) {
          context.read(browserDataProvider).state.progress = progress / 100;
        },
      ),
    );
  }

  Container getButtonBar(BuildContext context, bool show) {
    if (show) {
      return Container(
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Icon(Icons.arrow_back),
              onPressed: () {
                var webView = context.read(browserDataProvider).state.webView;
                if (webView != null) {
                  webView.goBack();
                }
              },
            ),
            RaisedButton(
              child: Icon(Icons.arrow_forward),
              onPressed: () {
                var webView = context.read(browserDataProvider).state.webView;
                if (webView != null) {
                  webView.goForward();
                }
              },
            ),
            RaisedButton(
              child: Icon(Icons.refresh),
              onPressed: () {
                var webView = context.read(browserDataProvider).state.webView;
                if (webView != null) {
                  webView.reload();
                }
              },
            ),
            RaisedButton(
              child: Icon(Icons.arrow_downward),
              onPressed: () {
                var browserData = context.read(browserDataProvider).state;
                browserData.withUrlBar = false;
                browserData.withButtonBar = false;
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
    final browserData = context.read(browserDataProvider).state;
    this.urlController.text = browserData.url;

    return Container(
      child: Column(children: <Widget>[
        getUrlBar(context, browserData.withUrlBar),
        getProgressIndicator(context),
        Expanded(child: getWebView(context)),
        getButtonBar(context, browserData.withButtonBar)
      ])
    );
  }
}