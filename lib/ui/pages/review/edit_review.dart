import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notification/bloc/comments/comments_repo.dart';
import 'package:flutter_notification/bloc/restaurant-details/restaurant_details_bloc.dart';
import 'package:flutter_notification/bloc/review/review_bloc.dart';
import 'package:flutter_notification/model/providers/user_model.dart';
import 'package:flutter_notification/ui/shared/widget/custom_app_bar.dart';
import 'package:flutter_notification/ui/shared/widget/custom_text_form_field.dart';
import 'package:flutter_notification/ui/shared/widget/toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_manager/photo_manager.dart';

class FooderRestaurantEditReviewScreen extends StatefulWidget {
  static const routeName = '/edit-review';
  const FooderRestaurantEditReviewScreen({Key? key}) : super(key: key);

  @override
  _FooderEditRestaurantReviewScreenState createState() => _FooderEditRestaurantReviewScreenState();
}

class _FooderEditRestaurantReviewScreenState extends State<FooderRestaurantEditReviewScreen> {

  bool onSubmit = false;
  final _formKey = GlobalKey<FormState>();
  String uniqueId = '';
  String restaurantUniqueId = '';
  List<AssetEntity> _selectedMedia = [];
  late TextEditingController _contentTextEditingController;
  late final ReviewBloc _reviewBloc;
  late final RestaurantDetailsBloc _restaurantDetailsBloc;
  late final AuthModel auth;
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
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      auth = context.read<AuthModel>();
    });
    _contentTextEditingController = TextEditingController();
    _reviewBloc = BlocProvider.of<ReviewBloc>(context);
    _restaurantDetailsBloc = BlocProvider.of<RestaurantDetailsBloc>(context);
    Future.delayed(Duration.zero,() {
      final arg = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      setState(() {
        uniqueId = arg["uniqueId"];
        restaurantUniqueId = arg['restaurantUniqueId'];
      });
     _reviewBloc.add(FetchReview(uniqueId));

    });
  }


  @override
  Widget build(BuildContext context) {
    final appbarTheme = Theme.of(context).appBarTheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: screenAppBar(
          appbarTheme,
          appTitle: 'Update Review',
          actions: [
            IconButton(
                onPressed: () async {
                   List<File> photos = [];
                  if(_selectedMedia.isNotEmpty) {
                    for (var media in _selectedMedia) {
                      final file = await media.file;
                      photos.add(file!);
                    }
                  }
                  _reviewBloc.add(UpdateReview(photos: photos));
                },
                icon: Icon(
                  Icons.check_rounded,
                  color: Colors.grey[600],
                )
            ),
          ]
      ),
      body: BlocConsumer<ReviewBloc, ReviewState>(
        listener: (context, state) {
          if(state.status == ReviewStatus.loadSuccess) {
            _contentTextEditingController.text = state.review!.content;
          }
          if(state.status == ReviewStatus.updateSucess) {

            _restaurantDetailsBloc.add(FetchRestaurantInfo(restaurantUniqueId,
              userUniqueId: auth.user?.user?.uniqueId,
            ));
            showToast(
              context: context,
              msg: 'Update Success'
            );
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if(state.status == ReviewStatus.loadSuccess ||
             state.status == ReviewStatus.onEdit ||
             state.status == ReviewStatus.editSuccess
          ) {
            return Stack(
                children: [
                  Positioned.fill(
                    child: SingleChildScrollView(
                      child: GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus!.unfocus();
                        },
                        child: Column(
                          children: [
                            typeSelection(state.review!.type),
                            SingleChildScrollView(child: reviewContent()),
                            SizedBox(
                              height: 150,
                              child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    for(var firstIndex = 0;firstIndex < state.review!.images.length; firstIndex++)
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        width: 150,
                                        height: 150,
                                        child: Stack(
                                          children: [
                                            Positioned.fill(child:  Image.network(
                                              state.review!.images[firstIndex].imageUrl,
                                              fit: BoxFit.cover,
                                            )),
                                            Positioned(
                                              top: 5,
                                              right: 5,
                                              child: GestureDetector(
                                                onTap: () {
                                                  _reviewBloc.add(DelCommentImage(state.review!.images[firstIndex].id));
                                                },
                                                child: const Icon(Icons.cancel_rounded, color: Colors.white,),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    for(var index = 0;index < _selectedMedia.length; index++)
                                      FutureBuilder<Uint8List?>(
                                        future: _selectedMedia[index].thumbData,
                                        builder: (_, snapshot) {
                                          final bytes = snapshot.data;
                                          // If we have no data, display a spinner
                                          if (bytes == null) return const Center(child: CircularProgressIndicator());
                                          // If there's data, display it as an image
                                          return Stack(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(8),
                                                width: 150,
                                                height: 150,
                                                child: Image.memory(
                                                  bytes,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Positioned(
                                                top: 15,
                                                right: 15,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    _selectedMedia.removeAt(index);
                                                    setState(() {
                                                      _selectedMedia = _selectedMedia;
                                                    });
                                                  },
                                                  child: const Icon(Icons.cancel_rounded, color: Colors.white,),
                                                ),
                                              )
                                            ],
                                          );
                                        },
                                      ),
                                  ],
                              ),
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
            );
          }
          if(state.status == ReviewStatus.onLoad) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget typeSelection(String type) {
    final textTheme = Theme.of(context).textTheme;
    int selectionType = 0;
    if(type.toUpperCase() == 'NORMAL') {
      selectionType = 1;
    } else if (type.toUpperCase() == 'BAD') {
      selectionType = 2;
    }

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
                      _reviewBloc.add(ChangeReviewType(item["id"]));
                      // setState(() {
                      //   _selectionType = item["id"];
                      // });
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
                                fontWeight:  selectionType == item["id"]
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 14,
                                color:  selectionType == item["id"]
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
