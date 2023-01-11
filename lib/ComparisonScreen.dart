// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_compress/video_compress.dart';
import 'package:videocompressor/AlbumPage.dart';

import 'CompareScreen.dart';
import 'Controller/SaveController.dart';
import 'Controller/VideosController.dart';
import 'Utils/route.dart';

class Comparisonscreen extends StatefulWidget {
  var compressedvideos;
  var originalvideos;
  var thumbnail;
  var size;
  var compressedvideosize;
  var compressedfilesthumbnail;

  Comparisonscreen(
      {super.key,
      required this.originalvideos,
      required this.compressedvideos,
      required this.thumbnail,
      required this.size,
      required this.compressedfilesthumbnail,
      required this.compressedvideosize});

  @override
  State<Comparisonscreen> createState() => _ComparisonscreenState();
}

class _ComparisonscreenState extends State<Comparisonscreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        radius: 19,
                        backgroundColor: Colors.grey.shade900,
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: w * .3,
                    ),
                    const Text(
                      "Compare",
                      style: TextStyle(
                          letterSpacing: .5,
                          color: Colors.white,
                          fontFamily: "poppins",
                          fontWeight: FontWeight.w300,
                          fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.compressedvideos.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            borderRadius: BorderRadius.circular(20)),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        height: h * .2,
                        child: Row(
                          children: [
                            Expanded(
                              child: Stack(
                                fit: StackFit.expand,
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.white)),
                                    child: Image.memory(
                                      widget.thumbnail[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(createRoute(
                                          CompareScreen(
                                              path:
                                                  widget.originalvideos[index],
                                              cpath: widget
                                                  .compressedvideos[index]
                                                  .file
                                                  .path,
                                              thumb: widget.thumbnail[index],
                                              cthumb: widget
                                                      .compressedfilesthumbnail[
                                                  index],
                                              csize: widget
                                                  .compressedvideosize[index]
                                                  .toString(),
                                              osize: widget.size[index])));
                                    },
                                    child: Center(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            border: Border.all(
                                                color: Colors.white)),
                                        child: const Text(
                                          "Compare",
                                          style: TextStyle(
                                              letterSpacing: .5,
                                              color: Colors.white,
                                              fontFamily: "poppins",
                                              fontWeight: FontWeight.w300,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text(
                                        "Original",
                                        style: TextStyle(
                                            letterSpacing: .5,
                                            color: Colors.white,
                                            fontFamily: "poppins",
                                            fontWeight: FontWeight.w300,
                                            fontSize: 13),
                                      ),
                                      Text(
                                        widget.size[index],
                                        style: const TextStyle(
                                            letterSpacing: .5,
                                            color: Colors.white,
                                            fontFamily: "poppins",
                                            fontWeight: FontWeight.w300,
                                            fontSize: 13),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text(
                                        "Compressed",
                                        style: TextStyle(
                                            letterSpacing: .5,
                                            color: Colors.white,
                                            fontFamily: "poppins",
                                            fontWeight: FontWeight.w300,
                                            fontSize: 13),
                                      ),
                                      Text(
                                        widget.compressedvideosize[index]
                                            .toString(),
                                        style: const TextStyle(
                                            letterSpacing: .5,
                                            color: Colors.white,
                                            fontFamily: "poppins",
                                            fontWeight: FontWeight.w300,
                                            fontSize: 13),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ))
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(20)),
              height: h * .1,
              child: Column(
                children: [
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Column(
                          children: const [
                            Icon(
                              Icons.rotate_left,
                              color: Colors.white,
                            ),
                            Text(
                              "BACK",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          List<String> videopath = [];
                          for (var items in widget.compressedvideos) {
                            videopath.add(items.file.path);
                          }
                          await Share.shareFiles(videopath,
                              text: "Compressed Videos by Bash Compressor");
                        },
                        child: Column(
                          children: const [
                            Icon(
                              Icons.share,
                              color: Colors.white,
                            ),
                            Text(
                              "SHARE",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          for (var item in widget.compressedvideos) {
                            var uint =
                                await File(item.file!.path).readAsBytes();
                            await SaveandShare().saveImage(uint);
                          }
                          await VideoCompress.deleteAllCache();
                          Navigator.of(context)
                              .pushReplacement(createRoute(const AlbumPage()));
                        },
                        child: Column(
                          children: const [
                            Icon(
                              Icons.download,
                              color: Colors.white,
                            ),
                            Text(
                              "SAVE",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
