import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class AppointmentCameraModal extends StatefulWidget {
  @override
  _AppointmentCameraModalState createState() => _AppointmentCameraModalState();
}

class _AppointmentCameraModalState extends State<AppointmentCameraModal> {
  // rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mov
  final String urlToStreamVideo = 'http://208.72.70.171/mjpg/video.mjpg';
  VlcPlayerController _controller;
  final double playerWidth = 640;
  final double playerHeight = 360;

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      _controller = new VlcPlayerController(
          onInit: () {
        _controller.play();
      });
    }
    return FractionallySizedBox(
        heightFactor: .8,
        child: Container(
            child: ClipRRect(
          borderRadius: new BorderRadius.circular(5.0),
          child: Container(
            decoration: new BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0))),
            child: Theme(
              data: ThemeData(
                  accentColor: Theme.of(context).primaryColor,
                  primaryColor: Theme.of(context).primaryColor),
              child: _getContent(),
            ),
          ),
        )));
  }

  _getContent() {
    return SizedBox(
        height: playerHeight,
        width: playerWidth,
        child: new VlcPlayer(
          aspectRatio: 16 / 9,
          url: urlToStreamVideo,
          controller: _controller,
          placeholder: Center(child: CircularProgressIndicator()),
        ));
  }
}
