import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:twilio_programmable_video/twilio_programmable_video.dart';
import 'package:uuid/uuid.dart';

class VideoCallPage extends StatefulWidget {
  @override
  _VideoCallPageState createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  final List<String> _users = ["Alice", "Bob", "Charlie", "Dave"];
  Room? _room;
  CameraCapturer? _cameraCapturer;
  LocalVideoTrack? _localVideoTrack;
  LocalAudioTrack _localAudioTrack = LocalAudioTrack(true, '${DateTime.now()}');
  // String? _identity;
  bool _isLoading = false;
  String accessToken =
      'eyJhbGciOiJIUzI1NiIsImN0eSI6InR3aWxpby1mcGE7dj0xIiwidHlwIjoiSldUIn0.eyJqdGkiOiJTS2UyOTkzNTM3YjJjYjZkMzgxYzNlZjAyYmU2MTU2MjYzLTE3MjA2MDIxNDIiLCJncmFudHMiOnsidmlkZW8iOnsicm9vbSI6Ik9uZVRvT25lUm9vbSJ9LCJpZGVudGl0eSI6InVzZXIifSwiaXNzIjoiU0tlMjk5MzUzN2IyY2I2ZDM4MWMzZWYwMmJlNjE1NjI2MyIsImV4cCI6MTcyMDYwNTc0MiwibmJmIjoxNzIwNjAyMTQyLCJzdWIiOiJBQzU3MzFlMDE2MmNjMjU2MjhjYmQ2OTc2MzZiMjc1YjU0In0.45KhK7WnmAN0yXZ1sF2uaq428u22POlPDGWL9KPvJZM';

  @override
  void dispose() {
    _leaveRoom();
    super.dispose();
  }

  Future<void> _createOneToOneRoom(String identity) async {
    setState(() {
      _isLoading = true;
    });

    try {

      // Retrieve camera source
      final cameraSources = await CameraSource.getSources();
      _cameraCapturer = CameraCapturer(
        cameraSources.firstWhere((source) => source.isFrontFacing),
      );

      _room = await TwilioProgrammableVideo.connect(
        ConnectOptions(
          accessToken,
          // roomName: 'OneToOneRoom-${Uuid().v4()}',
          roomName: 'OneToOneRoom',
          preferredAudioCodecs: [OpusCodec()],
          audioTracks: [LocalAudioTrack(true, 'audio_track-${Uuid().v4()}')],
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
      print('Failed to create room: $e');
    }
  }

  Future<void> _joinRoom(String identity) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // _identity = identity;

      // Request CAMERA permission
      var status = await Permission.camera.request();
      if (status.isGranted) {
        // Retrieve camera sources
        var cameraSources = await CameraSource.getSources();
        var cameraSource =
            cameraSources.firstWhere((source) => source.isFrontFacing);
        _cameraCapturer = CameraCapturer(cameraSource);

        _localVideoTrack = LocalVideoTrack(true, _cameraCapturer!);

        var connectOptions = ConnectOptions(
          accessToken,
          roomName: 'FlutterChatRoom',
          audioTracks: [_localAudioTrack],
          videoTracks: [_localVideoTrack!],
        );

        _room = await TwilioProgrammableVideo.connect(connectOptions);

        _room!.onConnected.listen((Room room) {
          print('Connected to ${room.name}');
          setState(() {});
        });

        _room!.onConnectFailure.listen((RoomConnectFailureEvent event) {
          print(
              'Failed to connect to room ${event.room.name}: ${event.exception}');
          setState(() {});
        });

        _room!.onDisconnected.listen((event) {
          print('Disconnected from ${event.room.name}');
          setState(() {
            _room = null;
          });
        });

        setState(() {
          _isLoading = false;
        });
      } else {
        throw Exception('Camera permission not granted');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Failed to join room: $e');
    }
  }

  Future<void> _leaveRoom() async {
    await _room?.disconnect();
    _localVideoTrack?.release(); // Release local video track
    await _cameraCapturer?.switchCamera(CameraSource(
        'cameraId', true, false, false)); // Release camera capturer
    setState(() {
      _room = null;
      _localVideoTrack = null;
      _cameraCapturer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Call'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          :
           _room == null
              ? _buildCreateRoomButton()
              :
          _buildRoomWidget(),
    );
  }

  Widget _buildCreateRoomButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () =>
            _createOneToOneRoom('Alice'), // Replace with participant's identity
        child: Text('Create One-to-One Room'),
      ),
    );
  }

  Widget _buildUserListWidget() {
    return ListView.builder(
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        return ListTile(
          title: Text(user),
          trailing: IconButton(
            icon: Icon(Icons.call),
            onPressed: () => _joinRoom(user),
          ),
        );
      },
    );
  }

  Widget _buildRoomWidget() {
    return Stack(
      children: [
        if (_localVideoTrack != null)
          Positioned.fill(
            child: _localVideoTrack!.widget(),
          ),
        Positioned(
          bottom: 20,
          left: 20,
          child: IconButton(
            icon: Icon(Icons.call_end, color: Colors.red, size: 30),
            onPressed: _leaveRoom,
          ),
        ),
      ],
    );
  }
}
