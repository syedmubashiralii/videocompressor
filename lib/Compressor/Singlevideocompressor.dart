import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';
import 'progresdialogwidget.dart';

import '../Controller/videocompressapi.dart';

class SingleVideoCompressor extends StatefulWidget {
  SingleVideoCompressor({Key? key}) : super(key: key);

  @override
  SingleVideoCompressorState createState() => SingleVideoCompressorState();
}

class SingleVideoCompressorState extends State<SingleVideoCompressor> {
  MediaInfo? compressedvideoinfo;
  int? videosize;
  Uint8List? _thumbnailbytes;
  File? videofile;
  var file;
  _takevideo() async {
    final picker = ImagePicker();
    var pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile == null) {
      return;
    } else {
      file = File(pickedFile.path);
      log(file.toString());
      videofile = file;
      await generatethumbnail(videofile!);
      await getvideosize(videofile!);
    }
  }

  generatethumbnail(File filee) async {
    _thumbnailbytes = await VideoCompress.getByteThumbnail(filee.path);
  }

  getvideosize(File filee) async {
    final size = await filee.length();
    videosize = size;
    setState(() {});
  }

  Future compressvideo() async {
    showDialog(
        context: context,
        builder: (context) => const Dialog(
              child: progressdialogwidget(),
            ));
    // final info = await VideoCompressApi().compressVideo(videofile!);
    // if (info == null) {
    // } else {
    //   compressedvideoinfo = info;
    //   setState(() {});
    // }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Center(
        child: videofile == null
            ? ElevatedButton(
                onPressed: () {
                  _takevideo();
                },
                child: const Text("Pick Video"))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        compressvideo();
                      },
                      child: const Text("Compress Video")),
                  _thumbnailbytes != null
                      ? Image.memory(
                          _thumbnailbytes!,
                          height: 300,
                        )
                      : const CircularProgressIndicator(),
                  videosize != null
                      ? Text(
                          "Original Video Info\nVideo Size:${videosize! / 1000}kb")
                      : const CircularProgressIndicator(),
                  const SizedBox(
                    height: 20,
                  ),
                  compressedvideoinfo != null
                      ? Text(
                          "compressed Video Info\nVideo Size:${compressedvideoinfo!.filesize! / 1000}kb")
                      : const SizedBox(),
                  const SizedBox(
                    height: 20,
                  ),
                  compressedvideoinfo != null
                      ? Text("Video path:${compressedvideoinfo!.path!}")
                      : const SizedBox(),
                  compressedvideoinfo != null
                      ? ElevatedButton(
                          onPressed: () {
                            compressedvideoinfo = null;
                            videosize = null;
                            _thumbnailbytes = null;
                            videofile = null;
                            setState(() {});
                          },
                          child: const Text("Compress another Video"))
                      : const SizedBox(),
                ],
              ),
      ),
    );
  }
}
