import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:videocompressor/LandingPage.dart';
import 'package:videocompressor/Utils/drawer.dart';

import 'AlbumPage.dart';
import 'Utils/ExitDialog.dart';
import 'Utils/route.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isloading = true;
  bool videostatus = false;
  @override
  void initState() {
    super.initState();
    permission();
    Future.delayed(Duration(seconds: 4), () {
      isloading = false;
      setState(() {});
    });
  }

  permission() async {
    ///camera
    var status = await Permission.videos.status;
    if (status.isDenied) {
      videostatus = false;
      await Permission.storage.request().then((value) {
        if (value.isGranted) {
          videostatus = true;
        } else {
          videostatus = false;
        }
      });
    } else if (status.isPermanentlyDenied) {
      videostatus = false;
    } else {
      videostatus = true;
    }
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        return ExitDialog(context);
      },
      child: Container(
        color: Colors.black,
        child: SafeArea(
          child: Scaffold(
            drawer: MainDrawer(),
            key: scaffoldKey,
            backgroundColor: Colors.black,
            body: Container(
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            scaffoldKey.currentState?.openDrawer();
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey.shade900,
                            child: const Icon(
                              Icons.menu,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          "Version (1.0.1)",
                          style: TextStyle(
                              fontFamily: "poppins", color: Colors.white),
                        ),
                        SizedBox(
                          width: w * .1,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: h * .08,
                    ),
                    CircleAvatar(
                      radius: 72,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(
                            "assets/images/Icon.png",
                            fit: BoxFit.contain,
                          )),
                    ),
                    SizedBox(
                      height: h * .03,
                    ),
                    const Text(
                      "Video Compressor",
                      style: TextStyle(
                          letterSpacing: .5,
                          color: Colors.white,
                          fontFamily: "poppins",
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                    const Text(
                      "Best Video Compressor and Player with ai video compression",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          letterSpacing: .5,
                          color: Colors.white,
                          fontFamily: "poppins",
                          fontWeight: FontWeight.w300,
                          fontSize: 14),
                    ),
                    SizedBox(
                      height: h * .02,
                    ),
                    Lottie.asset("assets/images/splash.json"),
                    Spacer(),
                    InkWell(
                      onTap: !isloading
                          ? () async {
                              await permission();
                              if (videostatus) {
                                Navigator.of(context)
                                    .push(createRoute(const LandingPage()));
                              } else {
                                EasyLoading.showToast(
                                    "Allow Permission from settings");
                                openAppSettings();
                              }
                            }
                          : () {},
                      child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          alignment: Alignment.center,
                          width: w * .4,
                          height: h * .06,
                          decoration: BoxDecoration(
                              color: !isloading ? Colors.red : Colors.grey,
                              borderRadius: BorderRadius.circular(100)),
                          child: !isloading
                              ? const Text(
                                  "Select",
                                  style: TextStyle(
                                      letterSpacing: .5,
                                      color: Colors.white,
                                      fontFamily: "poppins",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                )
                              : const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                )),
                    ),
                    SizedBox(
                      height: h * .05,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
