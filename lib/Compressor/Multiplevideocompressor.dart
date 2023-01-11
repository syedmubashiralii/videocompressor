import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_compress/video_compress.dart';
import 'package:videocompressor/Compressor/constants.dart';
import '../Controller/videocompressapi.dart';
import 'progresdialogwidget.dart';
import 'videoplayer.dart';

class MultipleVideoCompressor extends StatefulWidget {
  const MultipleVideoCompressor({super.key});

  @override
  State<MultipleVideoCompressor> createState() =>
      _MultipleVideoCompressorState();
}

class _MultipleVideoCompressorState extends State<MultipleVideoCompressor> {
  @override
  void initState() {
    super.initState();
    selectedfileslist = [];
    selectedfilesthumbnail = [];
    selectedfilessize = [];
    compressedmediainfo = [];
    compressedfilesthumbnail = [];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        height: double.infinity,
        width: double.infinity,
        child: selectedfileslist.isEmpty
            ? SizedBox(
                height: 40,
                width: 40,
                child: ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.video,
                        allowMultiple: true,
                      );
                      for (var item in result!.files) {
                        selectedfileslist.add(item.path!);
                        log(item.path.toString());
                      }
                      for (var item in selectedfileslist) {
                        await generatethumbnail(File(item));
                        await getvideosize(File(item));
                      }
                      log(selectedfilessize.length.toString());
                      setState(() {});
                    },
                    child: const Text("Pick Videos")),
              )
            : Column(
                children: [
                  SizedBox(
                    height: 400,
                    child: ListView.builder(
                      itemCount: selectedfileslist.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          trailing: Text(
                              (selectedfilessize[index] / 1000).toString()),
                          leading: Image.memory(selectedfilesthumbnail[index]),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await compressvideo();
                      },
                      child: Text("compress videos")),
                  Expanded(
                    child: SizedBox(
                      height: 400,
                      child: ListView.builder(
                        itemCount: compressedmediainfo.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VideoApp(
                                            f: File(selectedfileslist[index]),
                                            f1: compressedmediainfo[index]
                                                .file!,
                                          )));
                             },
                            title: Text(
                                (compressedmediainfo[index].filesize! / 1000)
                                    .toString()),
                            trailing:
                                Image.memory(compressedfilesthumbnail[index]),
                            leading: SizedBox(
                              width: 200,
                              child: Text(
                                  "Video path:${compressedmediainfo[index].path!}"),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
      )),
    );
  }

  Future compressvideo() async {
    try {
      showDialog(
          context: context,
          builder: (context) => const Dialog(
                child: progressdialogwidget(),
              ));
      // for (int i = 0; i < selectedfileslist.length; i++) {
      //   final info =
      //       await VideoCompressApi().compressVideo(File(selectedfileslist[i]));
      //   if (info == null) {
      //     //selectedfileslist.remove(selectedfileslist[i]);
      //     selectedfileslist.removeAt(i);
      //     selectedfilessize.removeAt(i);
      //     selectedfilesthumbnail.removeAt(i);
      //   } else {
      //     compressedmediainfo.add(info);
      //   }
      // }
      for (var item in compressedmediainfo) {
        var uint = await VideoCompress.getByteThumbnail(item.file!.path);
        compressedfilesthumbnail.add(uint!);
      }
      setState(() {});
      Navigator.pop(context);
    } catch (e) {
      log("bshdsdhjsadgshdgsadgs");
      selectedfileslist = [];
      selectedfilesthumbnail = [];
      selectedfilessize = [];
      compressedmediainfo = [];
      compressedfilesthumbnail = [];
      Navigator.pop(context);
      setState(() {});
    }
  }

  generatethumbnail(File filee) async {
    var uint = await VideoCompress.getByteThumbnail(filee.path);
    selectedfilesthumbnail.add(uint!);
  }

  getvideosize(File filee) async {
    final size = await filee.length();
    selectedfilessize.add(size);
  }
}
