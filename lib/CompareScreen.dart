import 'dart:io';

import 'package:flutter/material.dart';

import 'Utils/route.dart';
import 'VideoPlayer.dart';

class CompareScreen extends StatefulWidget {
  String path;
  String cpath;
  var thumb;
  var cthumb;
  String csize;
  String osize;
  CompareScreen({
    super.key,
    required this.path,
    required this.cpath,
    required this.thumb,
    required this.cthumb,
    required this.csize,
    required this.osize,
  });

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
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
            padding: const EdgeInsets.all(12),
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
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Original Video",
                      style: TextStyle(
                          letterSpacing: .5,
                          color: Colors.white,
                          fontFamily: "poppins",
                          fontWeight: FontWeight.normal,
                          fontSize: 16),
                    ),
                    Text(
                      widget.osize,
                      style: TextStyle(
                          letterSpacing: .5,
                          color: Colors.white,
                          fontFamily: "poppins",
                          fontWeight: FontWeight.normal,
                          fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(createRoute(MyVideoPlayerPage(
                        file: File(widget.path),
                      )));
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white)),
                          width: double.infinity,
                          child: Image.memory(
                            widget.thumb,
                            fit: BoxFit.cover,
                          ),
                        ),
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
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Compressed Video",
                      style: TextStyle(
                          letterSpacing: .5,
                          color: Colors.white,
                          fontFamily: "poppins",
                          fontWeight: FontWeight.normal,
                          fontSize: 16),
                    ),
                    Text(
                      widget.csize,
                      style: TextStyle(
                          letterSpacing: .5,
                          color: Colors.white,
                          fontFamily: "poppins",
                          fontWeight: FontWeight.normal,
                          fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyVideoPlayerPage(
                                    file: File(widget.cpath),
                                  )));
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white)),
                          width: double.infinity,
                          child: Image.memory(
                            widget.cthumb,
                            fit: BoxFit.cover,
                          ),
                        ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
