import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_compress/video_compress.dart';

class MyAlbumController extends ChangeNotifier {
  bool isloading = true;
  var dir2;
  var ImagesPath;
  List allimageslist = [];
  getalbum() async {
    isloading = true;
    notifyListeners();
    allimageslist = [];
    var appDir = await getApplicationDocumentsDirectory();
    dir2 = Directory('${appDir.path}/Videos');
    ImagesPath = '${appDir.path}/Videos';
    bool directoryExists = await Directory(ImagesPath).exists();
    if (directoryExists) {
      List<FileSystemEntity> files = dir2!.listSync();
      for (FileSystemEntity f1 in files) {
        allimageslist.add({
          "path": f1.absolute.path,
          "thumbnail": await genratethumbnail(f1.absolute.path),
          "size": await getFileSize(f1.absolute.path, 1)
        });
      }
      allimageslist = allimageslist.reversed.toList();
    }
    isloading = false;
    notifyListeners();
    return allimageslist;
  }

  genratethumbnail(String path) async {
    final uint8list = await VideoCompress.getByteThumbnail(path);
    return uint8list;
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
