import 'package:flutter/material.dart';

import 'browser.dart';

class UrlFormScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Url form"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: UrlForm(
          defaultUrl: "https://google.com/",
          onSubmit: (url) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BrowserScreen(url: url),
              ),
            );
          },
        ),
      ),
    );
  }
}

class UrlForm extends StatefulWidget {
  final String defaultUrl;
  final Function onSubmit;

  UrlForm({Key key, this.defaultUrl, this.onSubmit}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UrlForm();
  }
}

class _UrlForm extends State<UrlForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController urlController = TextEditingController();
  bool showHiddingIcon = true;

  @override
  void initState() {
    urlController.text = widget.defaultUrl;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: TextFormField(
                controller: urlController,
                onFieldSubmitted: processSearch,
                validator: (value) {
                  RegExp exp = new RegExp(r"http(s)?://[a-z0-9-.:/=?&]+");
                  if (value.substring(0, 8) != "https://") {
                    return "Url must start with 'https://'";
                  }

                  if (!exp.hasMatch(value)) {
                    return 'This is not valid url';
                  }
                  return null;
                },
                onChanged: (text) {
                  setState(() {
                    showHiddingIcon = urlController.text.length > 0;
                  });
                },
                decoration: InputDecoration(
                  //filled: true,
                  //prefixIcon: IconButton(icon: Icon(Icons.search)),
                  suffixIcon: () {
                    if (showHiddingIcon) {
                      return IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.red,
                          ),
                          splashColor: Colors.redAccent,
                          onPressed: () {
                            setState(() {
                              urlController.clearComposing();
                              urlController.text = "https://";
                              showHiddingIcon = false;
                            });
                          });
                    } else {
                      return null;
                    }
                  }()
                ),
              ),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 50),
            child: ElevatedButton(
              onPressed: validateAndSubmit,
              child: Text('Go'),
            ),
          )
        ],
      ),
    );
  }

  void processSearch(String input) {
    validateAndSubmit();
  }

  void validateAndSubmit() {
    if (_formKey.currentState.validate()) {
      widget.onSubmit(urlController.text);
    }
  }
}
