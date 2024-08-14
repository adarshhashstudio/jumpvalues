import 'package:flutter/material.dart';
import 'package:jumpvalues/models/twilio_access_token_response_model.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:twilio_programmable_video/twilio_programmable_video.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallPage extends StatefulWidget {
  final int sessionId;
  final bool joinRoomAutomatically;

  VideoCallPage({required this.sessionId, this.joinRoomAutomatically = true});

  @override
  _VideoCallPageState createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  Room? _room;
  LocalAudioTrack? _localAudioTrack;
  LocalVideoTrack? _localVideoTrack;
  CameraCapturer? _cameraCapturer;
  bool _isLoading = false;
  bool _isMuted = false;
  CameraSource? _currentCameraSource;
  List<CameraSource>? _cameraSources;
  TwilioAccessTokenResponseModel? twilioAccessTokenResponseModel;
  List<ParticipantWidget> _participants = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    setState(() {
      _isLoading = true;
    });
    await _requestPermissions();
    await _initCameraCapturer();
    await _initVideoPreview();
    await getTwilioAccessToken();
  }

  Future<void> getTwilioAccessToken() async {
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

  Future<void> _requestPermissions() async {
    await [Permission.camera, Permission.microphone].request();
  }

  Future<void> _initCameraCapturer() async {
    try {
      _cameraSources = await CameraSource.getSources();
      _currentCameraSource =
          _cameraSources?.firstWhere((source) => source.isBackFacing);

      if (_currentCameraSource != null) {
        _cameraCapturer = CameraCapturer(_currentCameraSource!);
      } else {
        throw Exception('No back-facing camera found');
      }
    } catch (e) {
      debugPrint('Camera initialization failed: $e');
    }
  }

  Future<void> _initVideoPreview() async {
    try {
      _localVideoTrack = LocalVideoTrack(
        true,
        _cameraCapturer!,
        name: 'preview-video#1',
      );
      await _localVideoTrack?.create();
    } catch (e) {
      debugPrint('VideoTrack creation failed: $e');
      SnackBarHelper.showStatusSnackBar(
        context,
        StatusIndicator.error,
        'Failed to create video track: $e',
      );
    }
  }

  Future<void> _joinRoom() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var connectOptions = ConnectOptions(
        twilioAccessTokenResponseModel?.token ?? '',
        roomName: twilioAccessTokenResponseModel?.roomId ?? 'SESSION_ROOM0004',
        audioTracks: [LocalAudioTrack(true, 'audio_track')],
        videoTracks: [
          _localVideoTrack ?? LocalVideoTrack(true, _cameraCapturer!)
        ],
        dataTracks: [
          LocalDataTrack(
            DataTrackOptions(name: 'preview-data-track#1'),
          )
        ],
        enableDominantSpeaker: true,
        enableNetworkQuality: true,
        networkQualityConfiguration: NetworkQualityConfiguration(
          remote: NetworkQualityVerbosity.NETWORK_QUALITY_VERBOSITY_MINIMAL,
        ),
      );

      _room = await TwilioProgrammableVideo.connect(connectOptions);

      _room?.onConnected.listen((Room room) {
        SnackBarHelper.showStatusSnackBar(
            context, StatusIndicator.success, 'Connected to ${room.name}');
        _onConnected(room);
      });

      _room?.onConnectFailure.listen((RoomConnectFailureEvent event) {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
            'Failed to connect to room ${event.room.name}: ${event.exception}');
        _onConnectFailure(event);
      });

      _room?.onDisconnected.listen((RoomDisconnectedEvent event) {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.warning,
            'Disconnected from ${event.room.name}');
        _onDisconnected(event);
      });
    } catch (e) {
      SnackBarHelper.showStatusSnackBar(
          context, StatusIndicator.error, 'Failed to join room: $e');
      setState(() {
        _isLoading = false;
      });
      debugPrint('Failed to join room: $e');
    }
  }

  void _onConnected(Room room) {
    final localParticipant = room.localParticipant;
    if (localParticipant != null) {
      _participants.add(_buildParticipant(
        child: localParticipant.localVideoTracks[0].localVideoTrack.widget(),
        id: localParticipant.identity,
      ));
    }

    for (final remoteParticipant in room.remoteParticipants) {
      _addRemoteParticipantListeners(remoteParticipant);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _onDisconnected(RoomDisconnectedEvent event) {
    setState(() {
      _room = null;
      _participants.clear();
    });
  }

  void _onConnectFailure(RoomConnectFailureEvent event) {
    setState(() {
      _isLoading = false;
    });
  }

  void _addRemoteParticipantListeners(RemoteParticipant remoteParticipant) {
    remoteParticipant.onVideoTrackSubscribed
        .listen((RemoteVideoTrackSubscriptionEvent event) {
      _participants.add(_buildParticipant(
        child: event.remoteVideoTrack.widget(),
        id: remoteParticipant.sid!,
      ));
      setState(() {});
    });

    remoteParticipant.onVideoTrackUnsubscribed
        .listen((RemoteVideoTrackSubscriptionEvent event) {
      _participants.removeWhere(
          (participant) => participant.id == remoteParticipant.sid);
      setState(() {});
    });

    remoteParticipant.onAudioTrackSubscribed
        .listen((RemoteAudioTrackSubscriptionEvent event) {
      // Handle remote audio track
    });

    remoteParticipant.onAudioTrackUnsubscribed
        .listen((RemoteAudioTrackSubscriptionEvent event) {
      // Handle remote audio track
    });
  }

  ParticipantWidget _buildParticipant(
      {required Widget child, required String id}) {
    return ParticipantWidget(
      id: id,
      child: child,
    );
  }

  Future<void> _leaveRoom() async {
    await _room?.disconnect();
    await _localVideoTrack?.release();
    setState(() {
      _room = null;
      _localVideoTrack = null;
      _participants.clear();
    });
  }

  void _switchCamera() {
    if (_cameraSources != null && _cameraSources!.isNotEmpty) {
      final newSource = _cameraSources!.firstWhere(
        (source) => source != _currentCameraSource,
        orElse: () => _cameraSources!.first,
      );
      _cameraCapturer?.switchCamera(newSource);
      _currentCameraSource = newSource;
    }
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _localAudioTrack?.enable(!_isMuted);
    });
  }

  @override
  void dispose() {
    _leaveRoom();
    super.dispose();
  }

  // Position for the draggable small video window
  double _smallVideoTop = 50;
  double _smallVideoLeft = 50;

  // Dimensions of the small video window
  final double smallVideoWidth = 150;
  final double smallVideoHeight = 200;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Video Call'),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _room == null
                ? Center(
                    child: ElevatedButton(
                      onPressed: _joinRoom,
                      child: const Text('Join Room'),
                    ),
                  )
                : _buildRoomWidget(),
      );

  Widget _buildRoomWidget() => Stack(
        children: [
          
          // Big Video Window (Full Screen)
          _participants.isNotEmpty
              ? Container(
                  child: Stack(children: [
                  ..._participants.map((participant) => Positioned.fill(
                        child: participant.child,
                      ))
                ]))
              : Positioned.fill(
                  child: Container(
                    color: Colors.black, // Placeholder for the big video
                    child: Center(
                      child: Text(
                        'Connecting...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),

          // Draggable Small Video Window
         if(_localVideoTrack != null ) Positioned(
            top: _smallVideoTop,
            left: _smallVideoLeft,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  // Update the position of the small video window
                  _smallVideoTop += details.delta.dy;
                  _smallVideoLeft += details.delta.dx;

                  // Ensure the small video stays within the screen boundaries
                  _smallVideoTop = _smallVideoTop.clamp(0.0,
                      MediaQuery.of(context).size.height - smallVideoHeight);
                  _smallVideoLeft = _smallVideoLeft.clamp(
                      0.0, MediaQuery.of(context).size.width - smallVideoWidth);
                });
              },
              child: Container(
                width: smallVideoWidth,
                height: smallVideoHeight,
                color: Colors.grey, // Placeholder for the small video
                child: _localVideoTrack!.widget(),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.call_end, color: Colors.red, size: 30),
                onPressed: _leaveRoom,
              ).center(),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 80,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: Icon(
                  _isMuted ? Icons.mic_off : Icons.mic,
                  color: Colors.black,
                  size: 30,
                ),
                onPressed: _toggleMute,
              ).center(),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.switch_camera,
                    color: Colors.black, size: 30),
                onPressed: _switchCamera,
              ).center(),
            ),
          ),
        ],
      );
}

class ParticipantWidget extends StatelessWidget {
  final Widget child;
  final String id;

  const ParticipantWidget({required this.child, required this.id});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: 10,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 120,
            height: 180,
            child: child,
          ),
        ),
      ),
    );
  }
}
