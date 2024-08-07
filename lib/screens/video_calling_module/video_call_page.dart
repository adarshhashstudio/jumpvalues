import 'package:flutter/material.dart';
import 'package:jumpvalues/models/twilio_access_token_response_model.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:twilio_programmable_video/twilio_programmable_video.dart';
import 'package:uuid/uuid.dart';

class VideoCallPage extends StatefulWidget {
  VideoCallPage({required this.sessionId, this.joinRoomAutomatically = false});
  final int sessionId;
  final bool joinRoomAutomatically;

  @override
  _VideoCallPageState createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  Room? _room;
  CameraCapturer? _cameraCapturer;
  LocalVideoTrack? _localVideoTrack;
  final LocalAudioTrack _localAudioTrack =
      LocalAudioTrack(true, '${DateTime.now()}');
  bool _isLoading = false;
  TwilioAccessTokenResponseModel? twilioAccessTokenResponseModel;

  @override
  void initState() {
    super.initState();
    getTwilioAccessToken();
  }

  Future<void> getTwilioAccessToken() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var response = await twilioAccessToken(widget.sessionId);
      if (response?.status == true) {
        setState(() {
          twilioAccessTokenResponseModel = response;
        });
        if (widget.joinRoomAutomatically) {
          await _joinRoom();
        }
      } else {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
            response?.message ?? 'Something went wrong');
      }
    } catch (e) {
      debugPrint('getTwilioAccessToken Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _createOneToOneRoom() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final cameraSources = await CameraSource.getSources();
      _cameraCapturer = CameraCapturer(
        cameraSources.firstWhere((source) => source.isFrontFacing),
      );

      _room = await TwilioProgrammableVideo.connect(
        ConnectOptions(
          twilioAccessTokenResponseModel?.token ?? '',
          roomName: twilioAccessTokenResponseModel?.roomId,
          enableAutomaticSubscription: true,
          preferredAudioCodecs: [OpusCodec()],
          audioTracks: [
            LocalAudioTrack(true, 'audio_track-${const Uuid().v4()}')
          ],
          videoTracks: [LocalVideoTrack(true, _cameraCapturer!)],
        ),
      );

      _room!.onConnected.listen((event) {
        setState(() {
          _isLoading = false;
        });
      });

      _room!.onDisconnected.listen((event) {
        setState(() {
          _room = null;
        });
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Failed to create room: $e');
    }
  }

  Future<void> _joinRoom() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var status = await Permission.camera.request();
      if (status.isGranted) {
        var cameraSources = await CameraSource.getSources();
        var cameraSource =
            cameraSources.firstWhere((source) => source.isFrontFacing);
        _cameraCapturer = CameraCapturer(cameraSource);

        _localVideoTrack = LocalVideoTrack(true, _cameraCapturer!);

        var connectOptions = ConnectOptions(
          twilioAccessTokenResponseModel?.token ?? '',
          roomName: twilioAccessTokenResponseModel?.roomId,
          audioTracks: [_localAudioTrack],
          videoTracks: [_localVideoTrack!],
        );

        _room = await TwilioProgrammableVideo.connect(connectOptions);

        _room!.onConnected.listen((Room room) {
          debugPrint('Connected to ${room.name}');
          setState(() {
            _isLoading = false;
          });
        });

        _room!.onConnectFailure.listen((RoomConnectFailureEvent event) {
          debugPrint(
              'Failed to connect to room ${event.room.name}: ${event.exception}');
          setState(() {
            _isLoading = false;
          });
        });

        _room!.onDisconnected.listen((event) {
          debugPrint('Disconnected from ${event.room.name}');
          setState(() {
            _room = null;
          });
        });
      } else {
        throw Exception('Camera permission not granted');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Failed to join room: $e');
    }
  }

  Future<void> _leaveRoom() async {
    await _room?.disconnect();
    await _localVideoTrack?.release();
    await _cameraCapturer
        ?.switchCamera(const CameraSource('cameraId', true, false, false));
    setState(() {
      _room = null;
      _localVideoTrack = null;
      _cameraCapturer = null;
    });
  }

  @override
  void dispose() {
    _leaveRoom();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Video Call'),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _room == null
                ? _buildCreateRoomButton()
                : _buildRoomWidget(),
      );

  Widget _buildCreateRoomButton() => Center(
        child: ElevatedButton(
          onPressed: _createOneToOneRoom,
          child: const Text('Create One-to-One Room'),
        ),
      );

  Widget _buildRoomWidget() => Stack(
        children: [
          if (_localVideoTrack != null)
            Positioned.fill(
              child: _localVideoTrack!.widget(),
            ),
          Positioned(
            bottom: 20,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.call_end, color: Colors.red, size: 30),
              onPressed: _leaveRoom,
            ),
          ),
        ],
      );
}
