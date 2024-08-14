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
  Map<String, ParticipantWidget> _participants =
      {}; // Store participants by their ID

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
      debugPrint('Local Video Track created');
      // Add local video track to participants list
      _addParticipant(_buildParticipant(
        child: _localVideoTrack!.widget(),
        id: 'local', // Assign a unique ID for local participant
      ));
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
    // Ensure local participant's video is already added
    final localParticipant = room.localParticipant;
    if (localParticipant != null && _participants['local'] == null) {
      _addParticipant(_buildParticipant(
        child: localParticipant.localVideoTracks[0].localVideoTrack.widget(),
        id: 'local',
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
      _addParticipant(_buildParticipant(
        child: event.remoteVideoTrack.widget(),
        id: remoteParticipant.sid!,
      ));
    });

    remoteParticipant.onVideoTrackUnsubscribed
        .listen((RemoteVideoTrackSubscriptionEvent event) {
      _removeParticipant(remoteParticipant.sid!);
    });
  }

  void _addParticipant(ParticipantWidget participant) {
    setState(() {
      _participants[participant.id] = participant;
    });
  }

  void _removeParticipant(String id) {
    setState(() {
      _participants.remove(id);
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

  Widget _buildRoomWidget() {
    final remoteParticipants = _participants.values
        .where((participant) => participant.id != 'local')
        .map((participant) => participant.child)
        .toList();

    return Stack(
      children: [
        // Big Video Window (Full Screen) for remote participants
        Positioned.fill(
          child: remoteParticipants.isNotEmpty
              ? remoteParticipants.first // Show the first remote participant
              : Container(
                  color: Colors.black, // Placeholder for the big video
                  child: Center(
                    child: Text(
                      'Connecting...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
        ),
        // Small Video Window for local participant
        Positioned(
          top: 20,
          right: 20,
          width: 120,
          height: 160,
          child: _participants['local']?.child ??
              Container(
                color: Colors.grey, // Placeholder for the small video
                child: const Center(
                  child: Text(
                    'Local Video',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
        ),
        // Call end button
        Positioned(
          bottom: 20,
          left: 20,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.call_end),
              onPressed: _leaveRoom,
            ),
          ),
        ),
        // Mute button
        Positioned(
          bottom: 20,
          right: 20,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(_isMuted ? Icons.mic_off_rounded : Icons.mic_rounded),
              onPressed: _toggleMute,
            ),
          ),
        ),
        // Switch camera button
        Positioned(
          bottom: 20,
          right: 80,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.switch_camera),
              onPressed: _switchCamera,
            ),
          ),
        ),
      ],
    );
  }
}

class ParticipantWidget {
  final String id;
  final Widget child;

  ParticipantWidget({required this.id, required this.child});
}
