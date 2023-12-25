import 'dart:io';
import 'dart:typed_data';

// import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:vector_math/vector_math_64.dart' show Vector3;
import 'package:photo_view/photo_view.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String fileType;

  const WebViewScreen({
    Key key,
    this.url,
    this.fileType,
  }) : super(key: key);
  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool loading = false;
  bool downloading = false;
  var progressString = "";
  var dir;
  Future<void> downloadFile(String imgUrl) async {
    Dio dio = Dio();

    try {
      dir = await getApplicationDocumentsDirectory();

      await dio.download(imgUrl, "${dir.path}/myimage.pdf",
          onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");

        setState(() {
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      progressString = "Completed";
    });
    OpenFile.open("${dir.path}/myimage.pdf");
    print("Download completed");
  }

  _getHttp() async {
    setState(() {
      loading = true;
    });
    // dir = await getApplicationDocumentsDirectory();
    var response = await Dio()
        .get(widget.url, options: Options(responseType: ResponseType.bytes));
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result.toString().split("///").last);
    // print(dir.path);
    print("ds");
    setState(() {
      loading = false;
    });

    OpenFile.open(result.toString().split("///").last);
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text("Image Saved")));
  }

  _saveDocument() async {
    setState(() {
      loading = true;
    });
    var appDocDir = await getTemporaryDirectory();
    String savePath = appDocDir.path + "/temp.pdf";
    await Dio().download(widget.url, savePath);
    final result = await ImageGallerySaver.saveFile(savePath);
    print(result);

    setState(() {
      loading = false;
    });
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text("Document Saved")));
  }

  @override
  void initState() {
    super.initState();
    PermissionHandler().requestPermissions(<PermissionGroup>[
      PermissionGroup.storage, // 在这里添加需要的权限
    ]);
  }

  WebViewController _controller;
  @override
  Widget build(BuildContext context) {
    if (widget.fileType == "image") {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Document"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.file_download),
                onPressed: () {
                  _getHttp();
                  // _saveDocument();
                })
          ],
        ),
        body: Stack(
          children: <Widget>[
            Container(
                child: PhotoView(
              imageProvider: NetworkImage(widget.url),
            )),
            loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Offstage(),
          ],
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Document"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.file_download),
                onPressed: () {
                  _saveDocument();
                })
          ],
        ),
        body: Stack(
          children: <Widget>[
            WebView(
              initialUrl: widget.url,
            ),
            loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Offstage(),
          ],
        ),
      );
    }
  }
}
