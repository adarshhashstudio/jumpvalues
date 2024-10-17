import 'package:flutter/material.dart';
import 'package:headset_connection_event/headset_event.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:twilio_programmable_video/twilio_programmable_video.dart';
import 'package:uuid/uuid.dart';

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
  final Map<String, RemoteVideoTrack?> _remoteParticipantVideoTracks = {};
  bool _isMuted = false;
  bool _remoteParticipantJoined = false;
  CameraSource? _currentCameraSource;
  int participentLength = 0;
  String participentSid = '';
  HeadsetEvent headsetPlugin = HeadsetEvent();
  HeadsetState? _headsetState;

  @override
  void initState() {
    super.initState();
    _init();
    _setupHeadsetListener(); // Set up the listener for headset events
  }

  @override
  void dispose() {
    _leaveRoom();
    super.dispose();
  }

// Set up headset listener
  void _setupHeadsetListener() {
    // Get the current headset state when initializing
    headsetPlugin.getCurrentState.then((_val) {
      setState(() {
        _headsetState = _val;
      });
      _routeAudioBasedOnHeadset(_val!);
    });

    // Listen for changes in the headset state during the call
    headsetPlugin.setListener((_val) {
      setState(() {
        _headsetState = _val;
      });
      _routeAudioBasedOnHeadset(_val);
    });
  }

// Route audio based on headset connection status
  void _routeAudioBasedOnHeadset(HeadsetState headsetState) async {
    if (_room != null) {
      // Ensure this is only called during a video call
      if (headsetState == HeadsetState.CONNECT) {
        // If headset is connected, route audio through the headset
        await TwilioProgrammableVideo.setAudioSettings(
          speakerphoneEnabled: false,
          bluetoothPreferred: false,
        );
        debugPrint('Headset connected: routing audio through headset.');
      } else {
        // If headset is disconnected, route audio through the speaker
        await TwilioProgrammableVideo.setAudioSettings(
          speakerphoneEnabled: true,
          bluetoothPreferred: false,
        );
        debugPrint('Headset disconnected: routing audio through speaker.');
      }
    }
  }

  Future<void> _init() async {
    setState(() {
      _isLoading = true;
    });
    debugPrint('VIDEO CALL ==> Initializing video call setup...');
    await _initCameraCapturer();
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
      debugPrint('VIDEO CALL ==> coachAcceptOrRejectSessions Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> getTwilioAccessToken() async {
    try {
      debugPrint('VIDEO CALL ==> Fetching Twilio access token...');
      var response = await twilioAccessToken(widget.sessionId);
      if (response?.status == true) {
        debugPrint('VIDEO CALL ==> Twilio access token received successfully.');
        await _joinRoom(response!.token!, response.roomId!);
      } else {
        SnackBarHelper.showStatusSnackBar(
          context,
          StatusIndicator.error,
          response?.message ?? 'Something went wrong',
        );
      }
    } catch (e) {
      debugPrint('VIDEO CALL ==> Error fetching Twilio access token: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _initCameraCapturer() async {
    try {
      debugPrint('VIDEO CALL ==> Initializing camera capturer...');
      var cameraSources = await CameraSource.getSources();
      var frontCameraSource =
          cameraSources.firstWhere((source) => source.isFrontFacing);

      _cameraCapturer = CameraCapturer(frontCameraSource);
      _currentCameraSource =
          frontCameraSource; // Initialize with the front camera
      debugPrint('VIDEO CALL ==> Camera capturer initialized.');
    } catch (e) {
      debugPrint('VIDEO CALL ==> Camera initialization failed: $e');
    }
  }

  Future<void> _joinRoom(String token, String roomId) async {
    setState(() {
      _isLoading = true;
    });
    await TwilioProgrammableVideo.setAudioSettings(
        speakerphoneEnabled: true, bluetoothPreferred: true);
    var trackId = const Uuid().v4();

    try {
      debugPrint('VIDEO CALL ==> Joining the room...');

      _localAudioTrack = LocalAudioTrack(true, 'audio_track-$trackId');

      try {
        debugPrint('VIDEO CALL ==> Initializing local video preview...');
        _localVideoTrack = LocalVideoTrack(
          true,
          _cameraCapturer!,
          name: 'preview-video-$trackId',
        );
        await _localVideoTrack?.create();
        // await _localVideoTrack?.publish();
        debugPrint('VIDEO CALL ==> Local Video Track created');
      } catch (e) {
        debugPrint('VIDEO CALL ==> VideoTrack creation failed: $e');
        // SnackBarHelper.showStatusSnackBar(
        //   context,
        //   StatusIndicator.error,
        //   'Failed to create video track: $e',
        // );
      }

      var connectOptions = ConnectOptions(
        token,
        roomName: roomId,
        preferredAudioCodecs: [OpusCodec()],
        audioTracks: [_localAudioTrack!],
        dataTracks: [
          LocalDataTrack(
            DataTrackOptions(ordered: true, name: 'data_track-$trackId'),
          )
        ],
        videoTracks: [_localVideoTrack!],
        enableNetworkQuality: true,
        networkQualityConfiguration: NetworkQualityConfiguration(
          remote: NetworkQualityVerbosity.NETWORK_QUALITY_VERBOSITY_MINIMAL,
        ),
        enableDominantSpeaker: true,
      );

      _room = await TwilioProgrammableVideo.connect(connectOptions);

      _room?.onConnected.listen((Room room) {
        debugPrint('VIDEO CALL ==> Connected to room: ${room.name}');
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
      debugPrint(
        'Failed to join room: $e',
      );
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
      debugPrint(
          'VIDEO CALL ==> ++++++++++++++++> Participant connected: $participentSid');

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
    debugPrint(
        'VIDEO CALL ==> Current Remote ============>>>> ${event.room.state}');
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
      debugPrint(
          'VIDEO CALL ==> Remote participant disconnected: ${participant.sid}');
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
    debugPrint('VIDEO CALL ==> Leaving room...');
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
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<bool> _onWillPop() async =>
      await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Are you Confirm?'),
          content: const Text('Are you sure you want to leave the call?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Stay on the page
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: _leaveRoom,
              child: const Text('Okay'),
            ),
          ],
        ),
      ) ??
      false;

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              (_remoteParticipantJoined &&
                      _remoteParticipantVideoTracks.isNotEmpty)
                  ? Positioned.fill(
                      child: _remoteParticipantVideoTracks.values.first
                              ?.widget() ??
                          Container(),
                    )
                  : Text(
                      'Connecting...',
                      style: boldTextStyle(color: white),
                    ).center(),
              // if (_localVideoTrack != null)
              //   Positioned(
              //     top: 50,
              //     left: 50,
              //     width: 100,
              //     height: 150,
              //     child: _localVideoTrack!.widget(),
              //   ),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              controlButtons(),
            ],
          ),
        ),
      );

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
                  onPressed: _switchCamera),
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
      debugPrint('VIDEO CALL ==> Switching camera...');

      // Fetch all available camera sources
      var cameraSources = await CameraSource.getSources();
      if (cameraSources.isEmpty) {
        debugPrint('No camera sources available.');
        return;
      }

      var currentCameraSource = _currentCameraSource;

      // Find a new camera source that is different from the current one
      var newCameraSource = cameraSources.firstWhere(
        (source) => source.isFrontFacing != currentCameraSource?.isFrontFacing,
      );

      // Switch the camera source
      await _cameraCapturer?.switchCamera(newCameraSource);

      // Update current camera source
      _currentCameraSource = newCameraSource;

      _localVideoTrack = LocalVideoTrack(
        true,
        _cameraCapturer!,
        name: 'preview-video${const Uuid().v4()}',
      );
      await _localVideoTrack?.create();
      await _localVideoTrack?.publish();

      setState(() {});

      debugPrint(
          'VIDEO CALL ==> Camera switched to ${newCameraSource.isFrontFacing ? "front" : "back"} camera.');

      // Refresh UI if necessary
      setState(() {});
    } catch (e) {
      debugPrint('VIDEO CALL ==> Failed to switch camera: $e');
    }
  }
}
