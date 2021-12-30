import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification/model/providers/user_model.dart';
import 'package:flutter_notification/model/restaurant_comment_model.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FooderCommentCard extends StatefulWidget {
  FooderCommentCard({
    Key? key,
    required this.comments,
  }) : super(key: key);
  List<RestaurantComment> comments;
  @override
  _FooderCommentCardState createState() => _FooderCommentCardState();
}

class _FooderCommentCardState extends State<FooderCommentCard> {

  bool isLike = false;
  late final AuthModel auth;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      auth = context.read<AuthModel>();
    });
    super.initState();
  }

  IconData commentTypeIcon(String type) {
    if(type.toUpperCase() == 'GOOD') {
      return Icons.mood;
    } else if (type.toUpperCase() == 'NORMAL') {
      return Icons.sentiment_dissatisfied;
    }
    return Icons.sentiment_dissatisfied_rounded;
  }

  String commentTypeTitle(String type) {
    if(type.toUpperCase() == 'GOOD') {
      return "Delicious!";
    } else if (type.toUpperCase() == 'NORMAL') {
      return "Not Bad";
    }
    return "Normal";
  }

  @override
  Widget build(BuildContext context) {
    final commentLength = widget.comments.isEmpty ? 0 : widget.comments.length > 3 ? 3 : widget.comments.length;
    return Column(
      children: [
        for(var i = 0; i < commentLength; i++)
          commentCard(widget.comments[i]),
      ],
    );
  }

  Widget commentCard(RestaurantComment comment) {
    return  Container(
      margin: const EdgeInsets.all(10),
      child: Ink(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
            )
        ),
        child: InkWell(
            onTap: () {
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              avatar(comment),
                              const SizedBox(
                                width: 5,
                              ),
                              writerInfo(comment),
                            ],
                          )
                      ),
                      commentType(comment)
                    ],
                  ),
                  commentContent(comment),
                  const SizedBox(
                    height: 20,
                  ),
                  commentImageList(comment),
                  commentExtraInfo(comment),
                  const Divider(),
                  commentFunctionList(),
                ],
              ),
            )
        ),
      ),
    );
  }

  Widget avatar(RestaurantComment comment) {
    if(comment.user.avatar.isNotEmpty) {
      return CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: comment.user.avatar,
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

  Widget writerInfo(RestaurantComment comment) {
    return Column(
      children: [
        Text(
          comment.user.username,
          style: Theme.of(context).textTheme.subtitle2!.copyWith(
            fontSize: 16,
          ),),
      ],
    );
  }

  Widget commentType(RestaurantComment comment) {
    final textTheme = Theme.of(context).textTheme;
    final IconData icon = commentTypeIcon(comment.type);
    final String title = commentTypeTitle(comment.type);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 40,
          color: Theme.of(context).primaryColor,
        ),
        Text(
          title,
          style: textTheme.subtitle2!.copyWith(
            fontWeight: FontWeight.normal,
            fontSize: 12,
            color: Theme.of(context).primaryColor,
          ) ,
        )
      ],
    );
  }

  Widget commentContent(RestaurantComment comment) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(10),
      child: Expanded(
        child: Text(
          comment.content,
          overflow: TextOverflow.ellipsis,
          maxLines: 5,
          style: textTheme.subtitle1!.copyWith(
            fontWeight: FontWeight.w300,
            fontSize: 16,
            height: 1.5,
          ),
          ),
      ),
    );
  }

  Widget commentImage() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            print('images');
          },
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: "https://images.unsplash.com/photo-1453728013993-6d66e9c9123a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dmlld3xlbnwwfHwwfHw%3D&w=1000&q=80",
            imageBuilder: (ctx, imageProvider) {
              return Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
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
          ),
        ),
       const SizedBox(width: 3,),
      ],
    );
  }

  Widget commentImageList(RestaurantComment comment) {
    if(comment.photos.isEmpty) {
      return Container();
    }
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          commentImage(),
          commentImage(),
          commentImage(),
          commentImage(),
        ],
      ),
    );
  }

  Widget commentExtraInfo(RestaurantComment comment) {
    final textTheme = Theme.of(context).textTheme;
    final dateFormatter = DateFormat('yyyy-MM-dd');
    final String formatDate = dateFormatter.format(comment.updateDate);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                 '${comment.likeTotal} Like',
                  style: textTheme.subtitle2!.copyWith(
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(width: 10,),
                Text(
                  '${comment.replyTotal} comment',
                  style: textTheme.subtitle2!.copyWith(
                    color: Colors.grey[400],
                  ),
                )
              ],
            ),
          ),
          Text(
            formatDate,
            style: textTheme.subtitle2!.copyWith(
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget commentFunctionList() {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            commentFunctionButton(
              textTheme,
              inActiveIcon:Icons.favorite_border_rounded,
              activeIcon: Icons.favorite_rounded,
              activeColor: Theme.of(context).primaryColor,
              title: 'Like',
              isActive: isLike,
              onTap: () {
                if(auth.user == null) {
                  Navigator.of(context).pushNamed('/login');
                }
                setState(() {
                  isLike = !isLike;
                });
              },
            ),
            const SizedBox(width: 10,),
            commentFunctionButton(
              textTheme,
              inActiveIcon:Icons.chat_bubble_outline_rounded,
              title: 'Comment',
              onTap: () {
                if(auth.user == null) {
                  Navigator.of(context).pushNamed('/login');
                }
              },
            ),
          ],
        ),
        PopupMenuButton<String>(
          icon: Icon(
            Icons.more_horiz_rounded,
            size: 25,
            color: Theme.of(context).secondaryHeaderColor,
          ),
          onSelected: (value) {},
          itemBuilder: (BuildContext context) {
            return {'Logout', 'Settings'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ],
    );
  }

  Widget commentFunctionButton(TextTheme textTheme, {
    required IconData inActiveIcon,
    IconData? activeIcon,
    Color? activeColor,
    bool? isActive,
    required String title,
    void Function()? onTap,
  }) {

    return InkWell(
      onTap: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
             isActive == true ? activeIcon : inActiveIcon,
              size: 25,
              color: isActive == true? activeColor :  Theme.of(context).secondaryHeaderColor,
            ),
            const SizedBox(width: 5,),
            Text(title,
              style: textTheme.subtitle1!.copyWith(
                fontWeight: FontWeight.normal,
                color: isActive == true? activeColor :  Theme.of(context).secondaryHeaderColor,
              ),)
          ],
        ),
      ),
    );
  }
}
