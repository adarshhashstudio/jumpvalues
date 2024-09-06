import 'package:better_player/better_player.dart';
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
  late BetterPlayerController _betterPlayerController;
  late YoutubePlayerController _youtubePlayerController;
  bool isYoutube = false;
  bool _isFullScreen = false; // Add this line

  @override
  void initState() {
    super.initState();

    // Check if the URL is a YouTube link
    isYoutube = _isYoutubeUrl(widget.videoUrl);

    if (isYoutube) {
      // Initialize YouTube Player
      final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
      _youtubePlayerController = YoutubePlayerController(
        initialVideoId: videoId!,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          enableCaption: false,
        ),
      )..addListener(_youtubePlayerListener); // Add listener here
    } else {
      // Initialize BetterPlayer for normal video links
      var betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.videoUrl,
      );
      _betterPlayerController = BetterPlayerController(
        const BetterPlayerConfiguration(
          aspectRatio: 16 / 9,
          autoPlay: true,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            enableFullscreen: true,
            enablePlayPause: true,
            enableMute: true,
          ),
        ),
        betterPlayerDataSource: betterPlayerDataSource,
      );
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
    if (isYoutube) {
      _youtubePlayerController
          .removeListener(_youtubePlayerListener); // Remove listener
      _youtubePlayerController.dispose();
    } else {
      _betterPlayerController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          if (isYoutube && _youtubePlayerController.value.isFullScreen) {
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
                      if (isYoutube &&
                          _youtubePlayerController.value.isFullScreen) {
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
          backgroundColor: blackColor,
          body: isYoutube ? _buildYoutubePlayer() : _buildBetterPlayer(),
        ),
      );

  // YouTube Player widget
  Widget _buildYoutubePlayer() => YoutubePlayer(
        controller: _youtubePlayerController,
        showVideoProgressIndicator: true,
      ).center();

  // Better Player widget
  Widget _buildBetterPlayer() => AspectRatio(
        aspectRatio: 16 / 9,
        child: BetterPlayer(
          controller: _betterPlayerController,
        ),
      ).center();

  // Check if the URL is from YouTube
  bool _isYoutubeUrl(String url) =>
      url.contains('youtube.com') || url.contains('youtu.be');
}
