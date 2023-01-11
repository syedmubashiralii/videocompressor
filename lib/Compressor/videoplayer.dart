import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoApp extends StatefulWidget {
  File f;
  File f1;
  VideoApp({Key? key, required this.f, required this.f1}) : super(key: key);

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;
  late VideoPlayerController _controller1;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.f)
      ..initialize().then((_) {
        setState(() {});
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      });
    _controller1 = VideoPlayerController.file(widget.f1)
      ..initialize().then((_) {
        setState(() {
          _controller.play();
          _controller1.play();
        });
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      })
      ..setLooping(true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: SafeArea(
        child: Scaffold(
          body: InkWell(
            onTap: () {
              _controller.play();
              _controller1.play();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .5,
                    child: Center(
                      child: _controller.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            )
                          : Container(),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .5,
                    child: Center(
                      child: _controller1.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _controller1.value.aspectRatio,
                              child: VideoPlayer(_controller1),
                            )
                          : Container(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
