import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class DroidCamStream1 extends StatefulWidget {
  @override
  _DroidCamStreamState1 createState() => _DroidCamStreamState1();
}

class _DroidCamStreamState1 extends State<DroidCamStream1> {
  late VlcPlayerController _vlcController;

  @override
  void initState() {
    super.initState();
    // Lock orientation to landscape for fullscreen video
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    _vlcController = VlcPlayerController.network(
      'http://192.168.171.144:5000/video_feed',
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