import 'dart:collection';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_compress/video_compress.dart';
import 'package:videocompressor/AlbumPage.dart';
import 'package:videocompressor/CompressionPage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'Controller/VideosController.dart';
import 'Utils/Dialog.dart';
import 'Utils/QualityPicker.dart';
import 'Utils/route.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late SharedPreferences prefs;
  List videos = [];
  bool isloading = true;
  HashSet selectItems = HashSet();
  bool isMultiSelectionEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getvideos();
      prefss();
    });
  }

  prefss() async {
    prefs = await SharedPreferences.getInstance();
    var i = prefs.getInt('index');
    if (i == null) {
      prefs.setInt("index", 0);
      quality = dropdownlist[0];
      setState(() {});
    } else {
      quality = dropdownlist[i];
      setState(() {});
    }
  }

  getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  getvideos() async {
    final applicationBloc =
        Provider.of<VideoController>(context, listen: false);
    videos = await applicationBloc.FetchVideos();
  }

  String getSelectedItemCount() {
    return selectItems.isNotEmpty
        ? "${selectItems.length} item selected"
        : "No item selected";
  }

  void doMultiSelection(String path) {
    if (isMultiSelectionEnabled) {
      setState(() {
        if (selectItems.contains(path)) {
          selectItems.remove(path);
          if (selectItems.isEmpty) {
            isMultiSelectionEnabled = false;
            setState(() {});
          }
        } else {
          selectItems.add(path);
        }
      });
    } else {
      //
    }
  }

  List<VideoQuality> dropdownlist = [
    VideoQuality.LowQuality,
    VideoQuality.MediumQuality,
    VideoQuality.HighestQuality,
    VideoQuality.Res1280x720Quality,
    VideoQuality.Res1920x1080Quality,
    VideoQuality.Res640x480Quality,
    VideoQuality.Res960x540Quality
  ];
  var quality = VideoQuality.LowQuality;
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            splashColor: Colors.black,
            backgroundColor: Colors.white,
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.video,
                allowMultiple: true,
              );
              if (result == null) {
                EasyLoading.showToast("No Videos Selected");
              } else {
                List selectedfileslist = [];
                List selectedfilesthumbnail = [];
                List sizee = [];
                for (var item in result.files) {
                  selectedfileslist.add(item.path!);
                }
                for (var item in selectedfileslist) {
                  var uint = await VideoCompress.getByteThumbnail(item);
                  selectedfilesthumbnail.add(uint!);
                }
                for (var item in selectedfileslist) {
                  final size = await getFileSize(item, 2);
                  sizee.add(size!);
                }

                Navigator.of(context).push(createRoute(CompressionPage(
                    files: selectedfileslist,
                    thumbnail: selectedfilesthumbnail,
                    size: sizee,
                    quality: quality)));
              }
            },
            child: Icon(Icons.video_call),
          ),
          backgroundColor: Colors.black,
          body: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12, top: 12),
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
                        radius: 20,
                        backgroundColor: Colors.grey.shade900,
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Spacer(),
                    Text(
                      isMultiSelectionEnabled
                          ? getSelectedItemCount()
                          : "Video Compressor",
                      style: const TextStyle(
                          letterSpacing: .5,
                          color: Colors.white,
                          fontFamily: "poppins",
                          fontWeight: FontWeight.w300,
                          fontSize: 19),
                    ),
                    Spacer(),
                    isMultiSelectionEnabled
                        ? SizedBox(
                            height: h * .06,
                          )
                        : InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AlbumPage()));
                            },
                            child: SizedBox(
                                height: h * .06,
                                child: Lottie.asset(
                                    "assets/images/97385-video.json")),
                          ),
                    isMultiSelectionEnabled
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                isMultiSelectionEnabled = false;
                                selectItems.clear();
                              });
                            },
                            icon: const Icon(Icons.close, color: Colors.white))
                        : SizedBox(),
                  ],
                ),
                Container(
                  height: h * .25,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(child: SizedBox()),
                      const Text(
                        "Compress Your Video",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            letterSpacing: .5,
                            color: Colors.white,
                            fontFamily: "poppins",
                            fontWeight: FontWeight.bold,
                            fontSize: 26),
                      ),
                      const Text(
                        "Tap on Videos to Select Videos\n for compression",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            letterSpacing: .5,
                            color: Colors.white,
                            fontFamily: "poppins",
                            fontWeight: FontWeight.normal,
                            fontSize: 13),
                      ),
                      const Expanded(child: SizedBox()),
                      InkWell(
                        onTap: isMultiSelectionEnabled
                            ? () {
                                List thumbnail = [];
                                List Size = [];
                                List path = [];
                                for (int i = 0; i < videos.length; i++) {
                                  if (selectItems.contains(videos[i]["path"])) {
                                    thumbnail.add(videos[i]["thumbnail"]);
                                    Size.add(videos[i]["size"]);
                                    path.add(videos[i]["path"]);
                                  } else {
                                    //do nothing
                                  }
                                }
                                Navigator.of(context).push(createRoute(
                                    CompressionPage(
                                        files: path,
                                        thumbnail: thumbnail,
                                        size: Size,
                                        quality: quality)));
                              }
                            : () {},
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          alignment: Alignment.center,
                          width: w * .4,
                          height: h * .06,
                          decoration: BoxDecoration(
                              color: isMultiSelectionEnabled
                                  ? Colors.red
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(100)),
                          child: Text(
                            isMultiSelectionEnabled ? "Compress" : "Select",
                            style: const TextStyle(
                                letterSpacing: .5,
                                color: Colors.white,
                                fontFamily: "poppins",
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: h * .01,
                      )
                    ],
                  ),
                ),
                Container(
                  height: h * .05,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "All Videos",
                        style: TextStyle(
                            fontFamily: "poppins",
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () async {
                          var txt = await showCupertinoModalBottomSheet<int>(
                              expand: false,
                              context: context,
                              builder: (context) => SizedBox(
                                  height: h * .72,
                                  child: QualityPicker(
                                    dropdown: dropdownlist,
                                  )));
                          if (txt == null) {
                          } else {
                            quality = dropdownlist[txt];
                            prefs.setInt("index", txt);
                            setState(() {});
                          }
                        },
                        child: Row(
                          children: const [
                            Text(
                              "Select Quality",
                              style: TextStyle(
                                  fontFamily: "poppins",
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal),
                            ),
                            Icon(
                              Icons.high_quality_rounded,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Consumer<VideoController>(
                      builder: (context, value, child) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: ScrollConfiguration(
                        behavior:
                            const ScrollBehavior().copyWith(overscroll: false),
                        child: GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 3 / 4,
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 4,
                                    mainAxisSpacing: 4),
                            itemCount: value.isloading ? 9 : videos.length,
                            itemBuilder: (BuildContext ctx, index) {
                              return value.isloading
                                  ? Container(
                                      color: Colors.grey.withOpacity(.2),
                                      alignment: Alignment.center,
                                      child: index == 4
                                          ? const CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            )
                                          : const SizedBox(),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        isMultiSelectionEnabled = true;
                                        doMultiSelection(videos[index]["path"]);
                                      },
                                      // onLongPress: () {
                                      //   isMultiSelectionEnabled = true;
                                      //   doMultiSelection(videos[index]["size"]);
                                      // },
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Opacity(
                                            opacity: .6,
                                            child: Image.memory(
                                              videos[index]["thumbnail"],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Center(
                                            child: CircleAvatar(
                                                backgroundColor: Colors.black26,
                                                radius: 18,
                                                child: Icon(
                                                  !selectItems.contains(
                                                          videos[index]["path"])
                                                      ? Icons.play_arrow
                                                      : Icons.check,
                                                  size: 22,
                                                )),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: Text(
                                              videos[index]["size"].toString(),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontFamily: "poppins",
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                            }),
                      ),
                    );
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
