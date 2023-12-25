import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:intrack/Student/blocs/gallery_bloc.dart';
import 'package:intrack/Student/models/gallery_model.dart';
import 'package:intrack/Student/ui/Gallery/gallery_image_view.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class GalleryDetail extends StatefulWidget {
  final String userToken;
  final Datum galleryData;
  GalleryDetail({
    Key key,
    this.userToken,
    this.galleryData,
  }) : super(key: key);
  @override
  _GalleryDetailState createState() => _GalleryDetailState();
}

class _GalleryDetailState extends State<GalleryDetail> {
  double cHeight;
  double cWidth;
  YoutubePlayerController _controller;
  TextEditingController _idController;
  TextEditingController _seekToController;

  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  int videoIndex = 0;

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.galleryData.youTubeLinkUrl.length > 0) {
      var _videoId = YoutubePlayer.convertUrlToId(
          widget.galleryData.youTubeLinkUrl[0].youTubeLink);
      _controller = YoutubePlayerController(
        initialVideoId: _videoId,
        flags: YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHideAnnotation: true,
          // forceHD: false,
          enableCaption: true,
        ),
      )..addListener(listener);
      _idController = TextEditingController();
      _seekToController = TextEditingController();
      _videoMetaData = YoutubeMetaData();
      _playerState = PlayerState.unknown;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;

    EdgeInsets _pad;

    _pad = EdgeInsets.only(
      left: cWidth * 0.01,
      right: cWidth * 0.01,
      top: cHeight * 0.01,
      bottom: cHeight * 0.01,
    );
    galleryBloc.fetchAllGallery(
      widget.userToken,
      context,
    );

    imageCarousel(List<ImageUrl> images) {
      List<NetworkImage> imagesList = [];
      for (int i = 0; i < images.length; i++) {
        imagesList.add(NetworkImage(images[i].imageLink));
      }
      return Container(
        height: cHeight * 0.3,
        width: cWidth,
        child: Carousel(
          indicatorBgPadding: 8.0,
          // showIndicator: false,
          dotSize: cHeight * 0.005,
          autoplay: false,
          images: imagesList,
        ),
      );
    }

    youtubePlayer(
        BuildContext context, void listener(), List<YouTubeLinkUrl> urlList) {
      int totalVideos = urlList.length;

      var videoId =
          YoutubePlayer.convertUrlToId(urlList[videoIndex].youTubeLink);
      return Column(
        children: <Widget>[
          YoutubePlayer(
            controller: _controller,
            // context: context,
            // videoId: videoId,
            // flags: YoutubePlayerFlags(
            //   mute: false,
            //   autoPlay: true,
            //   forceHideAnnotation: true,
            //   // showVideoProgressIndicator: true,

            //   disableDragSeek: false,
            // ),
            showVideoProgressIndicator: true,

            progressIndicatorColor: Color(0xFFFF0000),

            bottomActions: <Widget>[
              Spacer(),
              IconButton(
                  icon: Icon(
                    Icons.fullscreen,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _controller.toggleFullScreenMode();
                  }),
              // IconButton(
              //   icon: Icon(
              //     Icons.arrow_back_ios,
              //     color: Colors.white,
              //     size: 20.0,
              //   ),
              //   onPressed: () {},
              // ),
              // Text(
              //   'Hello! This is a test title.',
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 18.0,
              //   ),
              // ),
              // Spacer(),
              // IconButton(
              //   icon: Icon(
              //     Icons.settings,
              //     color: Colors.white,
              //     size: 25.0,
              //   ),
              //   onPressed: () {},
              // ),
            ],
            progressColors: ProgressBarColors(
              playedColor: Color(0xFFFF0000),
              handleColor: Color(0xFFFF4433),
            ),

            // onPlayerInitialized: (controller) {
            //   _controller = controller;
            //   _controller.addListener(listener);
            // },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              videoIndex > 0
                  ? FlatButton(
                      color: Colors.grey[200],
                      child: Text("Previous"),
                      onPressed: () {
                        if (videoIndex > 0) {
                          setState(() {
                            videoIndex--;
                          });
                          print(videoIndex);
                        }
                      },
                    )
                  : FlatButton(
                      color: Colors.transparent,
                      child: Text("    "),
                      onPressed: null,
                    ),
              Text("${videoIndex + 1}/$totalVideos"),
              videoIndex + 1 < totalVideos
                  ? FlatButton(
                      color: Colors.grey[200],
                      child: Text("Next"),
                      onPressed: () {
                        if (videoIndex + 1 < totalVideos) {
                          setState(() {
                            videoIndex++;
                          });
                          print(videoIndex);
                        }
                      },
                    )
                  : FlatButton(
                      color: Colors.transparent,
                      child: Text("    "),
                      onPressed: null,
                    ),
            ],
          )
        ],
      );
    }

    // void listener() {
    //   if (_controller.value.playerState == PlayerState.ended) {
    //     // _showThankYouDialog();
    //   }
    //   if (mounted) {
    //     setState(() {
    //       _playerStatus = _controller.value.playerState.toString();
    //       _errorCode = _controller.value.errorCode.toString();
    //     });
    //   }
    // }

    @override
    void deactivate() {
      // This pauses video while navigating to next page.
      _controller.pause();
      super.deactivate();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Gallery"),
      ),
      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.galleryData.imageUrl.length > 0
              ? Padding(
                  padding: EdgeInsets.only(
                    left: cWidth * 0.03,
                    top: cHeight * 0.01,
                    right: cWidth * 0.03,
                  ),
                  child: GestureDetector(
                    child: imageCarousel(widget.galleryData.imageUrl),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => GalleryImageView(
                            userToken: widget.userToken,
                            galleryData: widget.galleryData,
                          ),
                        ),
                      );
                    },
                  ),
                  // child: Text(
                  //   snapshot.data.data[index].id,
                  //   style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: cHeight * 0.027),
                  // ),
                )
              : Offstage(),
          widget.galleryData.youTubeLinkUrl.length > 0
              ? Card(
                  child: ExpansionTile(
                    title: Text(
                        "Show Videos (${widget.galleryData.youTubeLinkUrl.length})"),
                    children: widget.galleryData.youTubeLinkUrl.length > 0
                        ? <Widget>[
                            youtubePlayer(context, listener,
                                widget.galleryData.youTubeLinkUrl),
                          ]
                        : <Widget>[],
                  ),
                )
              : Offstage(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: cHeight * 0.025,
                  left: cWidth * 0.03,
                  // right: cWidth * 0.03,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: cWidth * 0.8,
                      child: Text(
                        widget.galleryData.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: cHeight * 0.027,
                        ),
                      ),
                    ),
                    Container(
                      width: cWidth * 0.8,
                      child: Text(
                        widget.galleryData.description,
                        style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: cHeight * 0.023),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: cHeight * 0.01,
                        bottom: cHeight * 0.01,
                      ),
                      child: Text(
                        "${widget.galleryData.created.toString().substring(0, 10)}, ${widget.galleryData.created.toString().substring(12, 16)}",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: _pad,
              //   child: CircleAvatar(
              //     radius: cHeight * 0.005,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
