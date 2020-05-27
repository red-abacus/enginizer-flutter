import 'dart:async';

import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/providers/camera.provider.dart';
import 'package:app/modules/appointments/services/camera.service.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:provider/provider.dart';

class AppointmentCameraModal extends StatefulWidget {
  @override
  _AppointmentCameraModalState createState() => _AppointmentCameraModalState();
}

class _AppointmentCameraModalState extends State<AppointmentCameraModal> {
  final String url =
      "rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mov";
  VlcPlayerController _controller;
  final double playerWidth = 640;
  final double playerHeight = 360;

  bool _initDone = false;
  bool _isLoading = false;

  CameraProvider _provider;

  Timer _timer;

  @override
  void dispose() {
    _controller?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      _controller = new VlcPlayerController(onInit: () {
        _controller.play();

        if (_timer == null) {
          const oneDecimal = const Duration(seconds: 5);
          _timer = new Timer.periodic(oneDecimal, (Timer timer) {
            if (_provider.cameraConvert != null) {
              _provider.pidIsAlive(_provider.cameraConvert.pid).then((isAlive) {
                if (!isAlive) {
                  _initDone = false;
                  _provider.resetParams();

                  _controller?.dispose();
                  _controller = null;
                  _timer?.cancel();
                  _timer = null;

                  _loadData();
                }
              });
            }
          });
        }
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

  @override
  void didChangeDependencies() async {
    if (!_initDone) {
      _provider = Provider.of<CameraProvider>(context);
      _provider.resetParams();

      _loadData();
      _initDone = true;
    }

    super.didChangeDependencies();
  }

  _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _provider.getCameraConvert(this.url).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error.toString().contains(CameraService.CONVERT_VIDEO_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_convert_camera, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _getContent() {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SizedBox(
            height: playerHeight,
            width: playerWidth,
            child: new VlcPlayer(
              aspectRatio: 16 / 9,
              url: _provider.cameraConvert?.fileUrl,
              controller: _controller,
              placeholder: Center(child: CircularProgressIndicator()),
            ));
  }
}
