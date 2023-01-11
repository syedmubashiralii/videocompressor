import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:photo_manager/photo_manager.dart';

class VideoController with ChangeNotifier {
  List videos = [];
  bool isloading = false;
  FetchVideos() async {
    isloading = true;
    notifyListeners();
    final albums = await PhotoManager.getAssetPathList(
        onlyAll: true, type: RequestType.video);
    final recentAlbum = albums.first;
    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0, // start at index 0
      end: 40, // end at a very big index (to get all the assets)
    );

    for (int i = 0; i < recentAssets.length; i++) {
      File? file = await recentAssets[i].file;
      var size = await getFileSize(file!.path.replaceAll('file://', ''), 1);
      videos.add({
        "thumbnail": await recentAssets[i].thumbnailData,
        "size": size,
        "duration": recentAssets[i].videoDuration,
        "path": file.path
      });
    }
    isloading = false;
    notifyListeners();
    return videos;
  }

  getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }
}
