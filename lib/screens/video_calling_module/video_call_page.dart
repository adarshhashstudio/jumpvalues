import 'package:flutter/material.dart';
import 'package:jumpvalues/models/twilio_access_token_response_model.dart';
import 'package:jumpvalues/network/rest_apis.dart';
import 'package:jumpvalues/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:twilio_programmable_video/twilio_programmable_video.dart';

class VideoCallPage extends StatefulWidget {
  VideoCallPage({required this.sessionId, this.joinRoomAutomatically = true});
  final int sessionId;
  final bool joinRoomAutomatically;

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

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndJoinRoom();
  }

  Future<void> _checkPermissionsAndJoinRoom() async {
    final permissions = await _requestPermissions();
    if (permissions) {
      await getTwilioAccessToken();
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<bool> _requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final micStatus = await Permission.microphone.request();
    final bluetoothStatus = await Permission.bluetooth.request();

    return cameraStatus.isGranted &&
        micStatus.isGranted &&
        bluetoothStatus.isGranted;
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

  Future<void> _joinRoom() async {
    setState(() {
      _isLoading = true;
    });

    await _initCameraCapturer();
    await _initVideoPreview();

    try {
      var connectOptions = ConnectOptions(
        twilioAccessTokenResponseModel?.token ?? '',
        roomName: twilioAccessTokenResponseModel?.roomId,
        audioTracks: [_localAudioTrack ?? LocalAudioTrack(true, '')],
        videoTracks: [_localVideoTrack!],
      );

      _room = await TwilioProgrammableVideo.connect(connectOptions);

      _room!.onConnected.listen((Room room) {
        SnackBarHelper.showStatusSnackBar(
            context, StatusIndicator.success, 'Connected to ${room.name}');
        debugPrint('Connected to ${room.name}');
        setState(() {
          _isLoading = false;
        });
      });

      _room!.onConnectFailure.listen((RoomConnectFailureEvent event) {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.error,
            'Failed to connect to room ${event.room.name}: ${event.exception}');
        debugPrint(
            'Failed to connect to room ${event.room.name}: ${event.exception}');
        setState(() {
          _isLoading = false;
        });
      });

      _room!.onDisconnected.listen((event) {
        SnackBarHelper.showStatusSnackBar(context, StatusIndicator.warning,
            'Disconnected from ${event.room.name}');
        debugPrint('Disconnected from ${event.room.name}');
        setState(() {
          _room = null;
        });
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

  Future<void> _initCameraCapturer() async {
    _cameraSources = await CameraSource.getSources();
    _currentCameraSource =
        _cameraSources?.firstWhere((source) => source.isFrontFacing);

    if (_currentCameraSource != null) {
      _cameraCapturer = CameraCapturer(_currentCameraSource!);
    }
  }

  Future<void> _initVideoPreview() async {
    _localVideoTrack = LocalVideoTrack(
      true,
      _cameraCapturer!,
      name: 'preview-video#1',
    );
    await _localVideoTrack?.create();
  }

  Future<void> _leaveRoom() async {
    await _room?.disconnect();
    await _localVideoTrack?.release();
    setState(() {
      _room = null;
      _localVideoTrack = null;
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
          Positioned(
            bottom: 20,
            right: 80,
            child: IconButton(
              icon: Icon(
                _isMuted ? Icons.mic_off : Icons.mic,
                color: Colors.white,
                size: 30,
              ),
              onPressed: _toggleMute,
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.switch_camera,
                  color: Colors.white, size: 30),
              onPressed: _switchCamera,
            ),
          ),
        ],
      );
}
