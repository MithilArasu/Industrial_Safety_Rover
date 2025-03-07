import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class DroidCamStream extends StatefulWidget {
  @override
  _DroidCamStreamState createState() => _DroidCamStreamState();
}

class _DroidCamStreamState extends State<DroidCamStream> {
  late VlcPlayerController _vlcController;

  @override
  void initState() {
    super.initState();
    // Lock orientation to landscape for fullscreen video
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    _vlcController = VlcPlayerController.network(
      'http://192.168.171.180:4747/video',
      autoPlay: true,
    );
  }

  @override
  void dispose() {
    // Reset orientation to default when exiting the screen
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _vlcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black, // Black background for fullscreen video
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: VlcPlayer(
                controller: _vlcController,
                aspectRatio: constraints.maxWidth / constraints.maxHeight, // Dynamically adjust aspect ratio
                placeholder: Center(child: CircularProgressIndicator()),
              ),
            );
          },
        ),
      ),
    );
  }
}