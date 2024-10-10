import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jumpvalues/models/tutorial_video_modle.dart';
import 'package:jumpvalues/screens/dashboard/video_player_screen.dart';
import 'package:jumpvalues/screens/widgets/widgets.dart';
import 'package:jumpvalues/utils/utils.dart';

class TutorialVideoModule extends StatelessWidget {
  const TutorialVideoModule({Key? key, this.videos}) : super(key: key);
  final List<VideoRow>? videos;

  @override
  Widget build(BuildContext context) => (videos == null || videos!.isEmpty)
      ? dataNotFoundWidget(context, showImage: false).onTap(() {})
      : ListView.builder(
          itemCount: videos?.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final video = videos?[index];
            var videoId = convertUrlToId(video?.url ?? '');
            var thumbnailUrl = getThumbnail(videoId: videoId ?? '');
            return ListTile(
              leading: Stack(
                children: [
                  CachedNetworkImage(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.13,
                    imageUrl: '$thumbnailUrl',
                    placeholder: (context, v) => Container(
                      color: Colors.grey, // Replace with your grey color
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey, // Replace with your grey color
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Icon(
                        Icons.play_circle_fill,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
              trailing: const Icon(
                Icons.arrow_right,
                size: 30,
              ),
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(video?.title ?? '',
                  style: const TextStyle(
                      fontWeight:
                          FontWeight.bold)), // Replace with your text style
              subtitle: Text(video?.slug ?? ''),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerScreen(
                      videoUrl: video?.url ?? '',
                      title: video?.title ?? '',
                    ),
                  ),
                );
              },
            );
          },
        );
}
