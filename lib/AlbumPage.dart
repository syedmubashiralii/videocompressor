import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videocompressor/Controller/AlbumController.dart';

import 'AlbumPreview.dart';
import 'Utils/route.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({super.key});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  List videos = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getvideos();
    });
  }

  getvideos() async {
    final applicationBloc =
        Provider.of<MyAlbumController>(context, listen: false);
    videos = await applicationBloc.getalbum();
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
                      width: w * .15,
                    ),
                    const Text(
                      "Compressed Videos",
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
                  height: 50,
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Consumer<MyAlbumController>(
                        builder: (context, value, child) {
                      return ScrollConfiguration(
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
                            itemCount: value.isloading
                                ? 12
                                : value.isloading == false && videos.isEmpty
                                    ? 12
                                    : videos.length,
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
                                  : value.isloading == false && videos.isEmpty
                                      ? Container(
                                          color: Colors.black,
                                          alignment: Alignment.center,
                                          child: index == 4
                                              ? const Text(
                                                  "No Videos",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: "poppins"),
                                                )
                                              : const SizedBox(),
                                        )
                                      : InkWell(
                                          onTap: () async {
                                            int idx = index;

                                            Navigator.of(context)
                                                .push(createRoute(AlbumPreview(
                                              thumb: videos[index]["thumbnail"],
                                              path: videos[index]["path"],
                                            )))
                                                .then((value) {
                                              if (value == true) {
                                                File(videos[index]["path"])
                                                    .delete();
                                                videos.removeAt(idx);
                                                setState(() {});
                                              } else {}
                                            });
                                          },
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
                                              const Center(
                                                child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.black26,
                                                    radius: 18,
                                                    child: Icon(
                                                      Icons.play_arrow,
                                                      size: 22,
                                                    )),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Text(
                                                  videos[index]["size"]
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontFamily: "poppins",
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                            }),
                      );
                    }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
