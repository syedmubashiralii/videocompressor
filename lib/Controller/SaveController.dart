import 'dart:io';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class SaveandShare {
  saveImage(var img) async {
    // final image = await widget.Img.exportImage();
    Directory? directory = await getApplicationDocumentsDirectory();
    bool directoryExists = await Directory('${directory.path}/Videos').exists();
    if (!directoryExists) {
      await Directory('${directory.path}/Videos').create(recursive: true);
    }
    final fullPath =
        '${directory.path}/Videos/SI${DateTime.now().millisecondsSinceEpoch}.mp4';
    File imageFile = File(fullPath);
    imageFile.writeAsBytes(img!);
    // await GallerySaver.saveVideo(imageFile.path, albumName: 'Bash Compressor')
    //     .then((value) {});
  }
}
