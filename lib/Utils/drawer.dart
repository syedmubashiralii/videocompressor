import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:videocompressor/AlbumPage.dart';
import 'package:videocompressor/Utils/route.dart';

import 'ExitDialog.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  State<MainDrawer> createState() => MainDrawerState();
}

class MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Drawer(
      width: w * .7,
      child: Opacity(
        opacity: .9,
        child: Container(
          height: double.infinity,
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: h * .07,
                    ),
                    SizedBox(
                        height: h * .15,
                        child: Image.asset("assets/images/Icon.png")),
                    SizedBox(
                      height: h * .01,
                    ),
                    const Text(
                      "Video Compressor",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "poppins",
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(
                      height: h * .01,
                    ),
                    const Text(
                      textAlign: TextAlign.center,
                      "Ai Video Compressor and Player",
                      style: TextStyle(
                        fontFamily: "poppins",
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: h * .06,
              ),
              items(
                  text: "My Album",
                  ic: Icons.photo_album_outlined,
                  ontap: () {
                    Navigator.of(context).push(createRoute(const AlbumPage()));
                  }),
              items(
                  text: "Privacy Policy",
                  ic: Icons.privacy_tip_outlined,
                  ontap: () async {
                    if (Platform.isAndroid) {
                      launchUrl(Uri.parse(
                          "https://sites.google.com/view/privacy-video-compressor/home"));
                    } else if (Platform.isIOS) {
                      launchUrl(Uri.parse(
                          "https://sites.google.com/view/privacy-video-compressor/home"));
                    }
                  }),
              Visibility(
                visible: Platform.isAndroid,
                child: items(
                    text: "More Apps",
                    ic: Icons.apps,
                    ontap: () async {
                      var url =
                          'https://play.google.com/store/apps/developer?id=Thetas+Lab';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(
                          Uri.parse(url),
                          mode: LaunchMode.externalNonBrowserApplication,
                        );
                      }
                    }),
              ),
              Visibility(
                visible: Platform.isAndroid,
                child: items(
                    text: "Rate Us",
                    ic: Icons.thumb_up_alt_rounded,
                    ontap: () async {
                      var url =
                          'https://play.google.com/store/apps/details?id=com.thetaslab.videocompressor';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(
                          Uri.parse(url),
                          mode: LaunchMode.externalNonBrowserApplication,
                        );
                      }
                    }),
              ),
              items(
                  text: "Feedback",
                  ic: Icons.feedback_outlined,
                  ontap: () {
                    if (Platform.isAndroid) {
                      launchUrl(Uri(
                        scheme: 'mailto',
                        path: 'thetaslabb@gmail.com',
                        query: 'Bash Video Converter',
                      ));
                    } else if (Platform.isIOS) {
                      launchUrl(Uri(
                        scheme: 'mailto',
                        path: 'thetaslabb@gmail.com',
                        query: 'Bash Video Converter',
                      ));
                    }
                  }),
              const Expanded(child: SizedBox()),
              Align(
                alignment: Alignment.bottomCenter,
                child: items(
                    text: "Exit",
                    ic: Icons.exit_to_app,
                    ontap: () {
                      ExitDialog(context);
                    }),
              ),
              SizedBox(
                height: h * .03,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class items extends StatefulWidget {
  String text;
  IconData ic;
  VoidCallback ontap;
  items({Key? key, required this.text, required this.ic, required this.ontap})
      : super(key: key);

  @override
  State<items> createState() => _itemsState();
}

class _itemsState extends State<items> {
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Container(
        height: h * .05,
        child: ListTile(
          leading: Icon(
            widget.ic,
            size: 28,
            color: Colors.white,
          ),
          title: Text(
            widget.text,
            style: TextStyle(
                color: Colors.white, fontFamily: "poppins", fontSize: 13),
          ),
          onTap: widget.ontap,
        ),
      ),
    );
  }
}

buildMenuItem(String s, {bool active = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: InkWell(
      onTap: () {},
      child: Text(
        s.toUpperCase(),
        style: TextStyle(
          fontSize: 22,
          color: active ? const Color(0xffffffff) : null,
          fontWeight: FontWeight.w900,
        ),
      ),
    ),
  );
}
