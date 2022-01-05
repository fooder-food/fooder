import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification/model/comment_user_model.dart';
import 'package:flutter_notification/model/restaurant_comment_photo_model.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FooderPhotoWrapper extends StatefulWidget {
  FooderPhotoWrapper({
    Key? key,
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex = 0,
    required this.galleryItems,
    required this.user,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex), super(key: key);
  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final List<RestaurantCommentPhoto> galleryItems;
  final Axis scrollDirection;
  final PageController pageController;
  final CommentUser user;
  @override
  State<FooderPhotoWrapper> createState() => _FooderPhotoWrapperState();
}

class _FooderPhotoWrapperState extends State<FooderPhotoWrapper> {
  late int currentIndex = widget.initialIndex;
  bool isShow = false;
  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }
  String dateFormatter(DateTime normalDate) {
    final dateFormatter = DateFormat('yyyy-MM-dd');
    return dateFormatter.format(normalDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          children: <Widget>[

            Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isShow = !isShow;
                    });
                  },
                  child: PhotoViewGallery.builder(
                    scrollPhysics: const BouncingScrollPhysics(),
                    customSize: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height- 150) ,
                    builder: _buildItem,
                    itemCount: widget.galleryItems.length,
                    loadingBuilder: widget.loadingBuilder,
                    backgroundDecoration: widget.backgroundDecoration,
                    pageController: widget.pageController,
                    onPageChanged: onPageChanged,
                    scrollDirection: widget.scrollDirection,
                  ),
                ),
            ),
            Positioned(
                top: 10,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedOpacity(
                      opacity: isShow ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white,),
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      )
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    AnimatedOpacity(
                      opacity: isShow ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: Row(
                        children: [
                          avatar(widget.user),
                          Container(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              widget.user.username,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17.0,
                                decoration: null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: AnimatedOpacity(
                opacity: isShow ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    dateFormatter(widget.galleryItems[currentIndex].updateDate),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                      decoration: null,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final RestaurantCommentPhoto item = widget.galleryItems[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: NetworkImage(item.imageUrl),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: item.uniqueId),
    );
  }

  Widget avatar(CommentUser user) {
    if(user.avatar.isNotEmpty) {
      return CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: user.avatar,
        imageBuilder: (ctx, imageProvider) {
          return Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        placeholder: (context, url) =>
        const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    }
    return SizedBox(
      width:40,
      height: 40,
      child: ClipOval(
        child: SvgPicture.asset(
          'assets/img/guest-avatar.svg',
        ),
      ),
    );

  }
}
