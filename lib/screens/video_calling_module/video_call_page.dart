import 'package:flutter/material.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:twilio_programmable_video/twilio_programmable_video.dart';

class VideoCallPage extends StatefulWidget {
  VideoCallPage({required this.sessionId});
  final int sessionId;

  @override
  _VideoCallPageState createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  Room? _room;
  LocalVideoTrack? _localVideoTrack;
  CameraCapturer? _cameraCapturer;
  bool _isLoading = false;
  Map<String, RemoteVideoTrack?> _remoteParticipantVideoTracks = {};
  bool _isMuted = false;
  bool _remoteParticipantJoined = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    setState(() {
      _isLoading = true;
    });
    debugPrint('Initializing video call setup...');
    await _initCameraCapturer();
    await _initVideoPreview();
    await getTwilioAccessToken();
  }

  Future<void> getTwilioAccessToken() async {
    try {
      debugPrint('Fetching Twilio access token...');
      var response = await twilioAccessToken(widget.sessionId);
      if (response?.status == true) {
        debugPrint('Twilio access token received successfully.');
        await _joinRoom(response!.token!, response.roomId!);
      } else {
        SnackBarHelper.showStatusSnackBar(
          context,
          StatusIndicator.error,
          response?.message ?? 'Something went wrong',
        );
      }
    } catch (e) {
      debugPrint('Error fetching Twilio access token: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _initCameraCapturer() async {
    try {
      debugPrint('Initializing camera capturer...');
      var cameraSources = await CameraSource.getSources();
      var backCameraSource =
          cameraSources.firstWhere((source) => source.isBackFacing);

      _cameraCapturer = CameraCapturer(backCameraSource);
      debugPrint('Camera capturer initialized.');
    } catch (e) {
      debugPrint('Camera initialization failed: $e');
    }
  }

  Future<void> _initVideoPreview() async {
    try {
      debugPrint('Initializing local video preview...');
      _localVideoTrack = LocalVideoTrack(
        true,
        _cameraCapturer!,
        name: 'preview-video',
      );
      await _localVideoTrack?.create();
      debugPrint('Local Video Track created');
    } catch (e) {
      debugPrint('VideoTrack creation failed: $e');
      SnackBarHelper.showStatusSnackBar(
        context,
        StatusIndicator.error,
        'Failed to create video track: $e',
      );
    }
  }

  Future<void> _joinRoom(String token, String roomId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint('Joining the room...');
      var connectOptions = ConnectOptions(
        token,
        roomName: roomId,
        audioTracks: [LocalAudioTrack(true, 'audio_track')],
        videoTracks: [_localVideoTrack!],
      );

      _room = await TwilioProgrammableVideo.connect(connectOptions);

      _room?.onConnected.listen((Room room) {
        debugPrint('Connected to room: ${room.name}');
        SnackBarHelper.showStatusSnackBar(
          context,
          StatusIndicator.success,
          'Connected to ${room.name}',
        );
        _onConnected(room);
      });

      _room?.onConnectFailure.listen((RoomConnectFailureEvent event) {
        SnackBarHelper.showStatusSnackBar(
          context,
          StatusIndicator.error,
          'Failed to connect to room ${event.room.name}: ${event.exception}',
        );
        setState(() {
          _isLoading = false;
        });
      });

      _room?.onDisconnected.listen((RoomDisconnectedEvent event) {
        SnackBarHelper.showStatusSnackBar(
          context,
          StatusIndicator.warning,
          'Disconnected from ${event.room.name}',
        );
        _onDisconnected(event);
      });
    } catch (e) {
      SnackBarHelper.showStatusSnackBar(
        context,
        StatusIndicator.error,
        'Failed to join room: $e',
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onConnected(Room room) {
    setState(() {
      _isLoading = false;
    });

    debugPrint(
        '++++++++++++++++> Count of room participants: ${room.remoteParticipants.length}');

    for (final participant in room.remoteParticipants) {
      _addRemoteParticipantListeners(participant);
    }

    room.onParticipantConnected.listen((participant) {
      debugPrint('Participant connected: ${participant.remoteParticipant.sid}');
      _addRemoteParticipantListeners(participant.remoteParticipant);
    });
  }

  void _onDisconnected(RoomDisconnectedEvent event) {
    setState(() {
      _room = null;
      _remoteParticipantVideoTracks.clear();
      _remoteParticipantJoined = false;
    });
  }

  void _addRemoteParticipantListeners(RemoteParticipant participant) {
    // Listen for video track subscription events
    participant.onVideoTrackSubscribed.listen((event) {
      debugPrint(
          'Remote video track subscribed for participant: ${participant.sid}');
      setState(() {
        // Store the remote participant's video track
        _remoteParticipantVideoTracks[participant.sid!] =
            event.remoteVideoTrack;
        _logRemoteParticipantVideoTracks();
        // Mark that a remote participant has joined
        _remoteParticipantJoined = true;
      });
    });

    // Listen for video track unsubscription events
    participant.onVideoTrackUnsubscribed.listen((event) {
      debugPrint(
          'Remote video track unsubscribed for participant: ${participant.sid}');
      setState(() {
        // Remove the video track when unsubscribed
        _remoteParticipantVideoTracks.remove(participant.sid!);
        _logRemoteParticipantVideoTracks();
        // Update the state based on remaining participants
        _remoteParticipantJoined = _remoteParticipantVideoTracks.isNotEmpty;
      });
    });

    // Listen for participant disconnect events
    participant.onVideoTrackDisabled.listen((event) {
      debugPrint('Remote participant disconnected: ${participant.sid}');
      setState(() {
        _remoteParticipantVideoTracks.remove(participant.sid!);
        _logRemoteParticipantVideoTracks();
        _remoteParticipantJoined = _remoteParticipantVideoTracks.isNotEmpty;
      });
    });
  }

  void _logRemoteParticipantVideoTracks() {
    debugPrint(
        'Current Remote Participant Video Tracks:===========================');
    _remoteParticipantVideoTracks.forEach((key, value) {
      debugPrint(
          '============>>>>  Participant SID: $key, Video Track: $value');
    });
  }

  Future<void> _leaveRoom() async {
    debugPrint('Leaving room...');
    await _room?.disconnect();
    setState(() {
      _room = null;
      _localVideoTrack = null;
      _remoteParticipantVideoTracks.clear();
      _remoteParticipantJoined = false;
    });
  }

  @override
  void dispose() {
    _leaveRoom();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // if (!_remoteParticipantJoined)
          //   Center(
          //     child: Text(
          //       'Connecting...',
          //       style: TextStyle(color: Colors.white),
          //     ),
          //   ),

          if (_remoteParticipantJoined &&
              _remoteParticipantVideoTracks.isNotEmpty)
            Positioned.fill(
              child: _remoteParticipantVideoTracks.values.first?.widget() ??
                  Container(),
            ),

          if (_localVideoTrack != null)
            Positioned(
              bottom: 20,
              right: 20,
              width: 120,
              height: 180,
              child: Draggable(
                feedback: _localVideoTrack!.widget(),
                child: _localVideoTrack!.widget(),
              ),
            ),

          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _switchCamera,
            tooltip: 'Switch Camera',
            child: const Icon(Icons.cameraswitch),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _toggleMute,
            tooltip: _isMuted ? 'Unmute' : 'Mute',
            child: Icon(_isMuted ? Icons.mic_off : Icons.mic),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _leaveRoom,
            tooltip: 'End Call',
            backgroundColor: Colors.red,
            child: const Icon(Icons.call_end),
          ),
        ],
      ),
    );

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
    _localVideoTrack?.enable(!_isMuted);
  }

  void _switchCamera() async {
    debugPrint('Switching camera...');
    // await _cameraCapturer?.switchCamera();
  }
}
