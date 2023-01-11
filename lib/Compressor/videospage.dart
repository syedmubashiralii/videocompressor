// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:photo_manager/photo_manager.dart';

// class VideosPage extends StatefulWidget {
//   const VideosPage({super.key});

//   @override
//   State<VideosPage> createState() => _VideosPageState();
// }

// class _VideosPageState extends State<VideosPage> {
//   // This will hold all the assets we fetched
//   List<AssetEntity> assets = [];
//   List thumb = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchAssets();
//   }

//   _fetchAssets() async {
//     final albums = await PhotoManager.getAssetthumbnailList(
//         onlyAll: true, type: RequestType.video);
//     final recentAlbum = albums.first;
//     final recentAssets = await recentAlbum.getAssetListRange(
//       start: 0, // start at index 0
//       end: 1000000, // end at a very big index (to get all the assets)
//     );
//     assets = recentAssets;
//     for (int i = 0; i < assets.length; i++) {
//       thumb.add(await assets[i].thumbnailData);
//     }
//     log(assets.length.toString() + "${thumb.length.toString()}");
//     setState(() {});
//   }

//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(

//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               const SizedBox(),
//               Expanded(
//                 child: GridView.builder(
//                     gridDelegate:
//                         const SliverGridDelegateWithMaxCrossAxisExtent(
//                             maxCrossAxisExtent: 200,
//                             childAspectRatio: 3 / 2,
//                             crossAxisSpacing: 20,
//                             mainAxisSpacing: 20),
//                     itemCount: thumb.length,
//                     itemBuilder: (BuildContext ctx, index) {
//                       return Stack(
//                         fit: StackFit.expand,
//                         children: [
//                           Image.memory(
//                             thumb[index],
//                             fit: BoxFit.cover,
//                           ),
//                           const Center(
//                             child: CircleAvatar(child: Icon(Icons.play_arrow)),
//                           )
//                         ],
//                       );
//                     }),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:collection';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  HashSet selectItems = HashSet();
  bool isMultiSelectionEnabled = false;
  List<AssetEntity> assets = [];
  List thumb = [];

  @override
  void initState() {
    super.initState();
    _fetchAssets();
  }

  _fetchAssets() async {
    final albums = await PhotoManager.getAssetPathList(
        onlyAll: true, type: RequestType.video);
    final recentAlbum = albums.first;
    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0, // start at index 0
      end: 1000000, // end at a very big index (to get all the assets)
    );
    assets = recentAssets;
    for (int i = 0; i < assets.length; i++) {
      thumb.add(await assets[i].thumbnailData);
    }
    log(assets.length.toString() + "${thumb.length.toString()}");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: isMultiSelectionEnabled
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isMultiSelectionEnabled = false;
                      selectItems.clear();
                    });
                  },
                  icon: Icon(Icons.close))
              : null,
          title: Text(isMultiSelectionEnabled
              ? getSelectedItemCount()
              : "Gridview Multi Selection"),
        ),
        body: Container(
            child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          childAspectRatio: 1.5,
          children: thumb.map((var thumbnail) {
            return getGridItem(thumbnail);
          }).toList(),
        )));
  }

  String getSelectedItemCount() {
    return selectItems.isNotEmpty
        ? selectItems.length.toString() + " item selected"
        : "No item selected";
  }

  void doMultiSelection(Uint8List thumbnail) {
    if (isMultiSelectionEnabled) {
      setState(() {
        if (selectItems.contains(thumbnail)) {
          selectItems.remove(thumbnail);
        } else {
          selectItems.add(thumbnail);
        }
      });
    } else {
      //
    }
  }

  GridTile getGridItem(Uint8List thumbnail) {
    return GridTile(
      child: InkWell(
        onTap: () {
          doMultiSelection(thumbnail);
        },
        onLongPress: () {
          isMultiSelectionEnabled = true;
          doMultiSelection(thumbnail);
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.memory(
              thumbnail,
              color: Colors.black
                  .withOpacity(selectItems.contains(thumbnail) ? 1 : 0),
              colorBlendMode: BlendMode.color,
              fit: BoxFit.cover,
            ),
            Center(
              child: CircleAvatar(
                  child: Icon(
                !selectItems.contains(thumbnail)
                    ? Icons.play_arrow
                    : Icons.check,
                size: 30,
              )),
            ),
          ],
        ),
      ),
    );
  }
}
