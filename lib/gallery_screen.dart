import 'dart:io';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shreyas_camera_assignment/gallery_preview.dart';
import 'package:shreyas_camera_assignment/image_screen.dart';
import 'package:shreyas_camera_assignment/video_preview.dart';

class GalleryScreen extends StatefulWidget {
  final ScrollController scrollController;

  const GalleryScreen({Key key, this.scrollController}) : super(key: key);

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String currentFilePath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar:  AppBar(
        backgroundColor: Colors.black,
        title: Text("Preview"),
      ),
      body: FutureBuilder(
        future: _getAllImages(),
        builder: (context, AsyncSnapshot<List<FileSystemEntity>> snapshot) {
          if (!snapshot.hasData || snapshot.data.isEmpty) {
            return Container();
          }
          print('${snapshot.data.length} ${snapshot.data}');
          if (snapshot.data.length == 0) {
            return Center(
              child: Text('No images found.'),
            );
          }

          return GridView.builder(
            controller: widget.scrollController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
              itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              currentFilePath = snapshot.data[index].path;
              var extension = path.extension(snapshot.data[index].path);
              if (extension == '.jpeg') {
                return GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageScreen(imagePath: snapshot.data[index].path,),
                      ),
                    );
                  },
                  child: Image.file(
                    File(snapshot.data[index].path),
                  ),
                );
              } else {
                return GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPreview(videoPath: snapshot.data[index].path,),
                      ),
                    );
                  },
                  child: VideoPreview(
                    videoPath: snapshot.data[index].path,
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }

  _shareFile() async {
    var extension = path.extension(currentFilePath);
    await Share.file(
      'image',
      (extension == '.jpeg') ? 'image.jpeg' : '	video.mp4',
      File(currentFilePath).readAsBytesSync(),
      (extension == '.jpeg') ? 'image/jpeg' : '	video/mp4',
    );
  }

  _deleteFile() {
    final dir = Directory(currentFilePath);
    dir.deleteSync(recursive: true);
    print('deleted');
    setState(() {});
  }

  Future<List<FileSystemEntity>> _getAllImages() async {
    var extDir = await ExtStorage.getExternalStorageDirectory();
    final String dirPath = '${extDir}/assignment_task';
    final myDir = Directory(dirPath);
    List<FileSystemEntity> _images;
    _images = myDir.listSync(recursive: true, followLinks: false);
    _images.sort((a, b) {
      return b.path.compareTo(a.path);
    });
    return _images;
  }
}