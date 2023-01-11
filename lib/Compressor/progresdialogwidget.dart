
// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:video_compress/video_compress.dart';

class progressdialogwidget extends StatefulWidget {
  const progressdialogwidget({super.key});

  @override
  State<progressdialogwidget> createState() => _progressdialogwidgetState();
}

class _progressdialogwidgetState extends State<progressdialogwidget> {
  late Subscription subscription;
  double? progress;
  @override
  void initState() {
    super.initState();
    subscription = VideoCompress.compressProgress$.subscribe((progress) {
      setState(() {
        this.progress = progress;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    VideoCompress.cancelCompression();
    subscription.unsubscribe();
  }

  @override
  Widget build(BuildContext context) {
    final value = progress == null ? progress : progress! / 100;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Compressing video...",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          LinearProgressIndicator(
            value: value,
            minHeight: 12,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                VideoCompress.cancelCompression();
              },
              child: const Text("Cancel"))
        ],
      ),
    );
  }
}
