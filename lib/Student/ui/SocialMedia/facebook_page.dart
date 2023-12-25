import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FacebookPage extends StatefulWidget {
  final String url;

  const FacebookPage({
    Key key,
    this.url,
  }) : super(key: key);
  @override
  _FacebookPageState createState() => _FacebookPageState();
}

class _FacebookPageState extends State<FacebookPage> {
  WebViewController _controller;
  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: widget.url,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _controller = webViewController;
      },
    );
  }
}
