import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ds_bfi/flutter_ds_bfi.dart';
import 'package:oktoast/oktoast.dart';
import 'package:task_rahmanda_one/utils/general_utils.dart';
import 'package:task_rahmanda_one/widget/custom_toast_widget.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();

    videoPlayerController = VideoPlayerController.asset(
      'assets/imgs/nike_animation.mp4',
    )
      ..initialize().then((value) {
        setState(() {});
      })
      ..setVolume(0.0);

    _checkConnectivity();
  }

  _checkConnectivity() {
    GeneralUtils().checkConnectivity().then((value) async {
      if (value) {
        videoPlayerController.play();

        await Future.delayed(const Duration(seconds: 3));

        Navigator.pushReplacementNamed(context, '/post-list-screen');
      } else {
        videoPlayerController.play();

        await Future.delayed(const Duration(seconds: 4));

        showToastWidget(
            CustomToast(
              message: 'Error Connection, Please Try Again',
              backgroundColor: Colors.red,
              isSuccess: false,
            ),
            position: ToastPosition.top,
            duration: const Duration(seconds: 4));
      }
    });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: videoPlayerController.value.initialized
              ? AspectRatio(
                  aspectRatio: videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(videoPlayerController),
                )
              : Container()),
    );
  }
}
