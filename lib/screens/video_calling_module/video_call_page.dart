import 'package:flutter/material.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';
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
  LocalAudioTrack? _localAudioTrack;
  CameraCapturer? _cameraCapturer;
  bool _isLoading = false;
  Map<String, RemoteVideoTrack?> _remoteParticipantVideoTracks = {};
  bool _isMuted = false;
  bool _remoteParticipantJoined = false;
  CameraSource? _currentCameraSource;
  int participentLength = 0;
  String participentSid = '';

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

  Future<void> coachAcceptOrRejectSessions(int status, int sessionId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      var request = <String, dynamic>{
        'status': status,
      };

      var response = await acceptOrRejectSessions(request, sessionId);
      if (response?.status == true) {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.success,
            response?.message ?? 'Saved Successfully.');
      } else {
        if (response?.message != null) {
          SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
              response?.message ?? 'Something went wrong');
        }
      }
    } catch (e) {
      debugPrint('coachAcceptOrRejectSessions Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
      _currentCameraSource =
          backCameraSource; // Initialize with the back camera
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
      _localAudioTrack = LocalAudioTrack(true, 'audio_track');

      var connectOptions = ConnectOptions(
        token,
        roomName: roomId,
        audioTracks: [_localAudioTrack!],
        videoTracks: [_localVideoTrack!],
      );

      _room = await TwilioProgrammableVideo.connect(connectOptions);

      _room?.onConnected.listen((Room room) {
        debugPrint('Connected to room: ${room.name}');
        SnackBarHelper.showStatusSnackBar(
          context,
          StatusIndicator.success,
          'Wait for participent to join.',
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
        coachAcceptOrRejectSessions(
            getSessionStatusCode(SessionStatus.abandoned), widget.sessionId);
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
      await coachAcceptOrRejectSessions(
          getSessionStatusCode(SessionStatus.abandoned), widget.sessionId);
    }
  }

  void _onConnected(Room room) {
    setState(() {
      _isLoading = false;
    });

    participentLength = room.remoteParticipants.length;
    debugPrint(
        '++++++++++++++++> Count of room participants: $participentLength');

    for (final participant in room.remoteParticipants) {
      _addRemoteParticipantListeners(participant);
    }

    room.onParticipantConnected.listen((participant) {
      participentSid = participant.remoteParticipant.sid ?? '';
      debugPrint('++++++++++++++++> Participant connected: $participentSid');
      
      _addRemoteParticipantListeners(participant.remoteParticipant);

      coachAcceptOrRejectSessions(
          getSessionStatusCode(SessionStatus.waitingInProgress),
          widget.sessionId);
    });
  }

  void _onDisconnected(RoomDisconnectedEvent event) {
    setState(() {
      _room = null;
      _remoteParticipantVideoTracks.clear();
      _remoteParticipantJoined = false;
    });
    debugPrint('Current Remote ============>>>> ${event.room.state}');
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
          'Current Remote ============>>>>  Participant SID: $key, Video Track: $value');
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
    if (participentLength != 0 || participentSid != '') {
      // if both participents are connected then we can complete call and send true for rate the coach from client
      await coachAcceptOrRejectSessions(
              getSessionStatusCode(SessionStatus.completed), widget.sessionId)
          .then((v) {
        Navigator.of(context).pop(true);
      });
      Navigator.of(context).pop(true);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _leaveRoom();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Position for the draggable small video window
    double _smallVideoTop = 50;
    double _smallVideoLeft = 50;

    // Dimensions of the small video window
    final double smallVideoWidth = 100;
    final double smallVideoHeight = 150;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          (_remoteParticipantJoined && _remoteParticipantVideoTracks.isNotEmpty)
              ? Positioned.fill(
                  child: _remoteParticipantVideoTracks.values.first?.widget() ??
                      Container(),
                )
              : Text(
                  'Connecting...',
                  style: boldTextStyle(color: white),
                ).center(),
          if (_localVideoTrack != null)
              Positioned(
                top: 50,
                left: 50,
                width: 100,
                height: 150,
                child: Draggable(
                  feedback: _localVideoTrack!.widget(),
                  axis: Axis.vertical,
                  child: _localVideoTrack!.widget(),
                ),
              ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          controlButtons(),
        ],
      ),
    );
  }

  Widget controlButtons() => // Call control buttons
      Positioned(
        bottom: 20,
        left: 20,
        right: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Mute/Unmute button
            Container(
              decoration: boxDecorationDefault(color: white.withOpacity(0.2)),
              child: IconButton(
                icon: Icon(
                  _isMuted ? Icons.mic_off : Icons.mic,
                  color: Colors.white,
                ),
                onPressed: _toggleMute,
              ),
            ),

            // End call button
            Container(
              decoration: boxDecorationDefault(color: white.withOpacity(0.2)),
              child: IconButton(
                icon: const Icon(
                  Icons.call_end,
                  color: Colors.red,
                ),
                onPressed: _leaveRoom,
              ),
            ),

            // Switch camera button
            Container(
              decoration: boxDecorationDefault(color: white.withOpacity(0.2)),
              child: IconButton(
                icon: const Icon(
                  Icons.switch_camera,
                  color: Colors.white,
                ),
                onPressed: _switchCamera,
              ),
            ),
          ],
        ),
      );

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
    _localAudioTrack?.enable(!_isMuted);
  }

  Future<void> _switchCamera() async {
    try {
      debugPrint('Switching camera...');

      // Fetch available camera sources
      var cameraSources = await CameraSource.getSources();
      if (cameraSources.isEmpty) {
        debugPrint('No camera sources available.');
        return;
      }

      // Debug print all camera sources
      cameraSources.forEach((source) {
        debugPrint(
            'Camera: ${source.cameraId}, isFrontFacing: ${source.isFrontFacing}');
      });

      CameraSource? newCameraSource;

      if (_currentCameraSource?.isBackFacing == true) {
        // Try to switch to the front camera
        var frontCameraSource =
            cameraSources.firstWhere((source) => source.isFrontFacing);
        if (frontCameraSource != null &&
            _currentCameraSource?.cameraId != frontCameraSource.cameraId) {
          newCameraSource = frontCameraSource;
        }
      } else {
        // Try to switch to the back camera
        var backCameraSource = cameraSources.firstWhere(
          (source) => source.isBackFacing,
        );
        if (backCameraSource != null &&
            _currentCameraSource?.cameraId != backCameraSource.cameraId) {
          newCameraSource = backCameraSource;
        }
      }

      if (newCameraSource != null) {
        // Debug print the new camera information
        debugPrint(
            'Switching to camera: ${newCameraSource.cameraId}, isFrontFacing: ${newCameraSource.isFrontFacing}');

        // Switch camera
        await _cameraCapturer?.switchCamera(newCameraSource);
        _currentCameraSource = newCameraSource;
        debugPrint('Camera switched successfully.');
      } else {
        debugPrint('Already using the selected camera or no camera found.');
      }
    } catch (e) {
      debugPrint('Failed to switch camera: $e');
    }
  }
}
