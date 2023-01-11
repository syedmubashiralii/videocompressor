import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'VideoPlayer.dart';

class AlbumPreview extends StatefulWidget {
  var thumb;
  String path;
  AlbumPreview({super.key, required this.thumb, required this.path});

  @override
  State<AlbumPreview> createState() => _AlbumPreviewState();
}

class _AlbumPreviewState extends State<AlbumPreview> {
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
                        Navigator.pop(context, false);
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
                      width: w * .2,
                    ),
                    const Text(
                      "Compressed Video",
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
                  height: 20,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyVideoPlayerPage(
                                    file: File(widget.path),
                                  )));
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.memory(widget.thumb),
                        const Center(
                          child: CircleAvatar(
                              backgroundColor: Colors.black54,
                              radius: 18,
                              child: Icon(
                                Icons.play_arrow,
                                size: 22,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
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
                          await Share.shareFiles([widget.path],
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
                          Navigator.pop(context, true);
                        },
                        child: Column(
                          children: const [
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            Text(
                              "DELETE",
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
