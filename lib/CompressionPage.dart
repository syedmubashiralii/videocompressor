import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:video_compress/video_compress.dart';
import 'ComparisonScreen.dart';
import 'Controller/videocompressapi.dart';
import 'Utils/route.dart';

class CompressionPage extends StatefulWidget {
  var files;
  var thumbnail;
  var size;
  VideoQuality quality;
  CompressionPage(
      {super.key,
      required this.files,
      required this.thumbnail,
      required this.size,
      required this.quality});

  @override
  State<CompressionPage> createState() => _CompressionPageState();
}

class _CompressionPageState extends State<CompressionPage> {
  var compressedmediainfo;
  bool isvalue = true;
  List compressedvideossize = [];
  int index = 1;
  int totalindex = 0;
  bool isloading = true;
  double? progress = 0;
  late Subscription subscription;
  var compressedfilesthumbnail;
  @override
  void initState() {
    super.initState();
    isvalue = false;
    Future.delayed(const Duration(seconds: 1), () {
      isvalue = false;
      setState(() {});
    });
    compressedmediainfo = [];
    compressedfilesthumbnail = [];
    subscription = VideoCompress.compressProgress$.subscribe((progress) {
      setState(() {
        this.progress = progress;
      });
    });
    totalindex = widget.files.length;
    compressvideo();
  }

  @override
  void dispose() {
    super.dispose();
    VideoCompress.cancelCompression();
    subscription.unsubscribe();
  }

  Future compressvideo() async {
    isloading = true;
    try {
      for (int i = 0; i < widget.files.length; i++) {
        index = i + 1;
        setState(() {});
        final info = await VideoCompressApi()
            .compressVideo(File(widget.files[i]), widget.quality);
        if (info == null) {
          widget.files.removeAt(i);
          widget.size.removeAt(i);
          widget.thumbnail.removeAt(i);
          EasyLoading.showToast("C'nt Compress this Video");
        } else {
          compressedmediainfo.add(info);
        }
      }
      for (var item in compressedmediainfo) {
        var uint = await VideoCompress.getByteThumbnail(item.file!.path);
        compressedfilesthumbnail.add(uint!);
      }
      for (var item in compressedmediainfo) {
        compressedvideossize.add(await getFileSize(item.file.path, 1));
        // var uint = await File(item.file!.path).readAsBytes();
        // var path = await SaveandShare().saveImage(uint);
        // compressedvideos.add(path);
      }

      // Directory? directory = await getExternalStorageDirectory();
      // bool directoryExists =
      //     await Directory('${directory!.path}/video_compress').exists();
      // if (directoryExists) {
      //   final dir = Directory('${directory.path}/video_compress');
      //   dir.deleteSync(recursive: true);
      // }

      isloading = false;
      setState(() {});
    } catch (e) {
      compressedmediainfo = [];
      compressedfilesthumbnail = [];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final value = progress == null ? progress : progress! / 100;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Container(
            height: double.infinity,
            width: double.infinity,
            // decoration: const BoxDecoration(
            //     image:
            //         DecorationImage(image: AssetImage("assets/images/bg.jpeg"))),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          VideoCompress.cancelCompression();
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
                        width: w * .2,
                      ),
                      const Text(
                        "Video Compression",
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
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CarouselSlider(
                        items: [
                          for (var items in widget.thumbnail) ...[
                            Container(
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                image: DecorationImage(
                                  image: MemoryImage(items),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ]
                        ],
                        options: CarouselOptions(
                          height: 300.0,
                          enlargeCenterPage: false,
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          viewportFraction: 0.8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    !isloading
                        ? "Videos Compressed SuccessfullyClick on proceed button to save videos in gallery and album"
                        : "Compressing your videos please\n be patient!",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        letterSpacing: .5,
                        color: Colors.white,
                        fontFamily: "poppins",
                        fontWeight: FontWeight.normal,
                        fontSize: 14),
                  ),
                  const Spacer(),
                  isvalue
                      ? SizedBox()
                      : Text(
                          "($index/$totalindex)"
                          "${(value! * 100).toStringAsFixed(0)} %",
                          style: const TextStyle(
                              color: Colors.white, fontFamily: "poppins"),
                        ),
                  isvalue
                      ? SizedBox()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LinearProgressIndicator(
                              value: value,
                              backgroundColor: Colors.white,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.red,
                              ),
                              minHeight: 7,
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 5,
                  ),
                  // Visibility(
                  //   visible: !isloading,
                  //   child: InkWell(
                  //     onTap: isloading
                  //         ? () {
                  //             // VideoCompress.cancelCompression();
                  //             // Navigator.pop(context);
                  //           }
                  //         : () async {},
                  //     child: AnimatedContainer(
                  //       duration: const Duration(milliseconds: 500),
                  //       alignment: Alignment.center,
                  //       width: w * .7,
                  //       height: h * .072,
                  //       decoration: BoxDecoration(
                  //           color: isloading ? Colors.grey : Colors.red,
                  //           borderRadius: BorderRadius.circular(100)),
                  //       child: Text(
                  //         !isloading ? "Compare Videos" : "Cancel Compression",
                  //         style: const TextStyle(
                  //             letterSpacing: .5,
                  //             color: Colors.white,
                  //             fontFamily: "poppins",
                  //             fontWeight: FontWeight.w600,
                  //             fontSize: 18),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  const Spacer(),
                  InkWell(
                    onTap: isloading
                        ? () {
                            VideoCompress.cancelCompression();
                            Navigator.pop(context);
                          }
                        : () async {
                            Navigator.of(context).pushReplacement(createRoute(
                                Comparisonscreen(
                                    compressedvideos: compressedmediainfo,
                                    originalvideos: widget.files,
                                    thumbnail: widget.thumbnail,
                                    size: widget.size,
                                    compressedfilesthumbnail:
                                        compressedfilesthumbnail,
                                    compressedvideosize:
                                        compressedvideossize)));
                          },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      alignment: Alignment.center,
                      width: w * .7,
                      height: h * .072,
                      decoration: BoxDecoration(
                          color: isloading ? Colors.grey : Colors.red,
                          borderRadius: BorderRadius.circular(100)),
                      child: Text(
                        !isloading ? "Compare Videos" : "Cancel Compression",
                        style: const TextStyle(
                            letterSpacing: .5,
                            color: Colors.white,
                            fontFamily: "poppins",
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
