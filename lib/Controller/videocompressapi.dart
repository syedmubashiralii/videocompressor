import 'dart:developer';
import 'dart:io';

import 'package:video_compress/video_compress.dart';

class VideoCompressApi {
  Future<MediaInfo?> compressVideo(File file, VideoQuality quality) async {
    try {
      log("quality,,${quality.toString()}");
      await VideoCompress.setLogLevel(0);
      return VideoCompress.compressVideo(
        file.path,
        quality: quality,
        deleteOrigin: false,
        includeAudio: true,
      );
    } catch (e) {
      log("exception${e.toString()}");
      VideoCompress.cancelCompression();
    }
  }
}
