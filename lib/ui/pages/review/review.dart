import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_notification/bloc/comments/comments_repo.dart';
import 'package:flutter_notification/ui/shared/widget/custom_app_bar.dart';
import 'package:flutter_notification/ui/shared/widget/custom_text_form_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_manager/photo_manager.dart';

class FooderRestaurantReviewScreen extends StatefulWidget {
  static const routeName = '/review';
  const FooderRestaurantReviewScreen({Key? key}) : super(key: key);

  @override
  _FooderRestaurantReviewScreenState createState() => _FooderRestaurantReviewScreenState();
}

class _FooderRestaurantReviewScreenState extends State<FooderRestaurantReviewScreen> {

  int _selectionType = 0;
  bool onSubmit = false;
  final _formKey = GlobalKey<FormState>();
  final _commentsRepo = CommentsRepo();
  List<AssetEntity> _selectedMedia = [];
  String restaurantUniqueId = '';
  late TextEditingController _contentTextEditingController;
  final List<Map<String, dynamic>> _selectionTypeList = [
    {
      "id": 0,
      "icon":  'assets/img/delicious.svg',
      "text":  'Delicious!',
    },
    {
      "id": 1,
      "icon":  'assets/img/notBad.svg',
      "text": 'Not Bad',
    },
    {
      "id": 2,
      "icon":  'assets/img/normal.svg',
      "text": 'Normal',
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _contentTextEditingController = TextEditingController();
    Future.delayed(Duration.zero,() {
      final arg = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      restaurantUniqueId = arg["uniqueId"];
    });
  }


  @override
  Widget build(BuildContext context) {
    final appbarTheme = Theme.of(context).appBarTheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: screenAppBar(
        appbarTheme,
        appTitle: 'Create Review',
        actions: [
          IconButton(
              onPressed: () async {
                List<File> photos = [];
                print(restaurantUniqueId);
                // if(onSubmit) {
                //   return;
                // }
                if(_selectedMedia.isNotEmpty) {
                  for (var media in _selectedMedia) {
                    final file = await media.file;
                    photos.add(file!);
                  }
                }
                print(_selectionType);
                await _commentsRepo.addReview(
                    content: _contentTextEditingController.text,
                    type: _selectionType,
                    restaurantUniqueId: restaurantUniqueId,
                    photos: photos.isEmpty ? null : photos,
                );

                // setState(() {
                //   onSubmit = true;
                // });
                await Future.delayed(const Duration(milliseconds: 500));
                // setState(() {  
                //   onSubmit = false;
                // });
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.check_rounded,
                color: Colors.grey[600],
              )
          ),
        ]
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                 FocusManager.instance.primaryFocus!.unfocus();
                },
                child: Column(
                  children: [
                    typeSelection(),
                    SingleChildScrollView(child: reviewContent()),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                          itemCount: _selectedMedia.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return  FutureBuilder<Uint8List?>(
                              future: _selectedMedia[index].thumbData,
                              builder: (_, snapshot) {
                                final bytes = snapshot.data;
                                // If we have no data, display a spinner
                                if (bytes == null) return const Center(child: CircularProgressIndicator());
                                // If there's data, display it as an image
                                return Container(
                                  padding: const EdgeInsets.all(8),
                                  width: 150,
                                  height: 150,
                                  child: Image.memory(
                                    bytes,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 0,
            right: 0,
            child: commentExtraSelection(),
          ),
        ]
      ),
    );
  }

  Widget typeSelection() {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for(var item in _selectionTypeList)
              Expanded(
                child: InkWell(
                  onTap: () {
                    print(item["id"]);
                    setState(() {
                      _selectionType = item["id"];
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            item["icon"],
                          ),
                          // Icon(
                          //   item["icon"],
                          //   size: 40,
                          //   color: _selectionType == item["id"]
                          //       ? Theme.of(context).primaryColor
                          //       : Colors.grey[400],
                          // ),
                          Text(
                            item["text"],
                            style: textTheme.subtitle2!.copyWith(
                              fontWeight:  _selectionType == item["id"]
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 14,
                              color:  _selectionType == item["id"]
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[400],
                            ) ,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget reviewContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Form(
        key: _formKey,
        child: TextFormField(
          maxLines: 10,
          controller: _contentTextEditingController,
          // decoration: const InputDecoration(
          //   // border: InputBorder.none,
          // ),
        ),
      ),
    );
  }

  Widget commentExtraSelection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey[400]!,
          )
        )
      ),
      child: Row(
        children: [
          Material(
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () async {
               final result = await Navigator.of(context).pushNamed('/review-images',
               arguments: {
                 "selectedMedia": _selectedMedia,
               }
               );
               if(result != null) {
                 setState(() {
                   _selectedMedia = result as List<AssetEntity>;
                 });
               }

              },
              child: Container(
                padding: const EdgeInsets.all(5),

                child: Icon(
                  Icons.image_rounded,
                  size: 40,
                  color: Colors.green[400],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
