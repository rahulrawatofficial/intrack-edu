import 'package:flutter/material.dart';

class NewsImageView extends StatefulWidget {
  final List<String> imageList;
  NewsImageView({Key key, this.imageList}) : super(key: key);
  @override
  _NewsImageViewState createState() => _NewsImageViewState();
}

class _NewsImageViewState extends State<NewsImageView> {
  double cHeight;
  double cWidth;
  int index;
  int listCount;

  @override
  void initState() {
    listCount = widget.imageList.length;
    index = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("image"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${index + 1}/$listCount",
              style: TextStyle(
                  fontSize: cHeight * 0.02,
                  color: Colors.grey[300],
                  fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: cHeight * 0.3),
            child: Stack(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  height: 300,
                  width: cWidth,
                  child: Image.network(
                    widget.imageList[index],
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: cHeight * 0.12,
                  left: cWidth * 0.83,
                  child: IconButton(
                    onPressed: () {
                      print("1");
                      print(index);
                      if (index < listCount - 1)
                        setState(() {
                          index = index + 1;
                        });
                      else
                        setState(() {
                          index = 0;
                        });
                      print("2");
                      print(index);
                    },
                    iconSize: cHeight * 0.1,
                    icon: Icon(
                      Icons.navigate_next,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                Positioned(
                  top: cHeight * 0.12,
                  right: cWidth * 0.83,
                  child: IconButton(
                    iconSize: cHeight * 0.1,
                    icon: Icon(
                      Icons.navigate_before,
                      color: Colors.grey[300],
                    ),
                    onPressed: () {
                      if (index > 0)
                        setState(() {
                          index = index - 1;
                        });
                      else
                        setState(() {
                          index = listCount - 1;
                        });
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
