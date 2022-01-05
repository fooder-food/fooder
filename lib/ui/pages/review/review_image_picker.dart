import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_notification/ui/shared/widget/custom_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:gallery_saver/gallery_saver.dart';

class FooderReviewImagePicker extends StatefulWidget {
  static const routeName='/review-images';
  const FooderReviewImagePicker({Key? key}) : super(key: key);

  @override
  _FooderReviewImagePickerState createState() => _FooderReviewImagePickerState();
}

class _FooderReviewImagePickerState extends State<FooderReviewImagePicker> {
  List<AssetPathEntity> _albums = [];
  List<AssetEntity> _selectedMedia = [];
  List<AssetEntity> _media = [];
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance!.addPostFrameCallback((_) async{
     await _fetchMedia();
    });
    super.initState();
  }

  _fetchMedia() async {
    var result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      List<AssetPathEntity> albums =
      await PhotoManager.getAssetPathList();
      List<AssetEntity> media = await albums[0].getAssetListPaged(0, 20);
      setState(() {
        _albums = albums;
        _media = media;
      });

      // success
    } else {
      // fail
      /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
    }
  }


  @override
  Widget build(BuildContext context) {
    final appbarTheme = Theme.of(context).appBarTheme;
    return Scaffold(
      appBar: screenAppBar(
        appbarTheme,
        appTitle: 'new Review',
        actions: [
          IconButton(
              onPressed: () async {
                Directory directory;
                String path = '';
                try {
                 final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                 await GallerySaver.saveImage(image!.path);
                 _fetchMedia();
                  // directory = (await getExternalStorageDirectory())!;
                  // List<String> folders = directory.path.split('/');
                  // String newPath = '';
                  // for(int x = 1; x < folders.length; x++) {
                  //   String folder = folders[x];
                  //   if(folder != 'Android') {
                  //     newPath +='/'+folder;
                  //   } else {
                  //     break;
                  //   }
                  // }
                  // newPath = newPath +"/fooder-malaysia";
                  // directory = Directory(newPath);
                  // print(directory.path);
                  // if(!await directory.exists()) {
                  //   await directory.create(recursive: true);
                  // }
                  // if(await directory.exists()) {
                  //   File saveFile = File(directory.path +'/${image!.path.toString()}');
                  // }
                } catch(e) {
                  print(e);
                }

              },
              icon: Icon(
                Icons.camera_alt_rounded,
                color: Colors.grey[600],
              )
          ),
          IconButton(
              onPressed: () async {
                Navigator.of(context).pop(_selectedMedia);
              },
              icon: Icon(
                Icons.check_rounded,
                color: Colors.grey[600],
              )
          ),
        ]
      ),
      body: GridView.builder(
          itemCount: _media.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
             crossAxisCount: 3,
             childAspectRatio: 1.0,
             crossAxisSpacing: 5,
             mainAxisSpacing: 5,
          ), itemBuilder: (context, index) {
            return imageBuilder(_media[index]);
      }
      ),
    );
  }
  bool isExists(AssetEntity asset) {
    for (var element in _selectedMedia) {
      if(element.id == asset.id) {
        return true;
        break;
      }
    }
    return false;
  }

  int getIndex(AssetEntity asset) {
    return _selectedMedia.indexWhere((element) => element.id == asset.id) + 1;
  }

  Widget imageBuilder( AssetEntity asset) {
    return GestureDetector(
      onTap: () {
        for(int x = 0; x < _selectedMedia.length; x++) {
          if(_selectedMedia[x].id == asset.id) {
            setState(() {
              _selectedMedia.removeWhere((element) => element.id == asset.id);
            });
            return;
          }
        }
        setState(() {
          _selectedMedia.add(asset);
        });
      },
      child: FutureBuilder<Uint8List?>(
        future: asset.thumbData,
        builder: (_, snapshot) {
          final bytes = snapshot.data;
          // If we have no data, display a spinner
          if (bytes == null) return const Center(child: CircularProgressIndicator());
          // If there's data, display it as an image
          return Stack(
            children: [
              Positioned.fill(
                child: Image.memory(
                  bytes,
                  colorBlendMode:isExists(asset) ? BlendMode.softLight : null,
                  color:isExists(asset) ? Colors.black: null,
                  fit: BoxFit.cover,
                ),
              ),
              isExists(asset)
              ? Positioned(
                top: 10,
                right: 10,
                child: ClipOval(
                  child: Container(
                    width: 20,
                    height: 20,
                    color: Colors.red,
                    child: Center(
                      child: Text(
                        '${getIndex(asset)}',
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              : Container(),
            ],
          );
        },
      ),
    );
  }
}
