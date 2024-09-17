import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({required this.videoUrl, required this.title});
  final String videoUrl;
  final String title;

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _youtubePlayerController;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();

    // Initialize YouTube Player
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    if (videoId != null) {
      _youtubePlayerController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          enableCaption: false,
        ),
      )..addListener(_youtubePlayerListener); // Add listener here
    }
  }

  void _youtubePlayerListener() {
    if (mounted) {
      setState(() {
        _isFullScreen = _youtubePlayerController.value.isFullScreen;
      });
    }
  }

  @override
  void dispose() {
    _youtubePlayerController.removeListener(_youtubePlayerListener); // Remove listener
    _youtubePlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          if (_youtubePlayerController.value.isFullScreen) {
            _youtubePlayerController.toggleFullScreenMode();
            return false; // Prevents the page from popping
          }
          return true; // Allows the page to pop
        },
        child: Scaffold(
          appBar: _isFullScreen
              ? null
              : AppBar(
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(4.0),
                    child: Container(
                      color: Colors.grey,
                      height: 0.5,
                    ),
                  ),
                  leading: GestureDetector(
                    onTap: () {
                      if (_youtubePlayerController.value.isFullScreen) {
                        _youtubePlayerController.toggleFullScreenMode();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: 14.0),
                      child: Icon(Icons.arrow_back_ios_new),
                    ),
                  ),
                  centerTitle: true,
                  title: Text(
                    widget.title,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 20),
                  ),
                ),
          backgroundColor: Colors.black,
          body: _buildYoutubePlayer(),
        ),
      );

  // YouTube Player widget
  Widget _buildYoutubePlayer() => YoutubePlayer(
        controller: _youtubePlayerController,
        showVideoProgressIndicator: true,
      ).center();
}
