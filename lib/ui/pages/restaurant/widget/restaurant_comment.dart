import 'dart:ui';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notification/bloc/restaurant-details/restaurant_details_bloc.dart';
import 'package:flutter_notification/model/comment_user_model.dart';
import 'package:flutter_notification/model/providers/user_model.dart';
import 'package:flutter_notification/model/restaurant_comment_model.dart';
import 'package:flutter_notification/model/restaurant_comment_photo_model.dart';
import 'package:flutter_notification/ui/pages/restaurant/widget/restaurant_photo_wrapper.dart';
import 'package:flutter_notification/ui/pages/review/edit_review.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class FooderCommentCard extends StatefulWidget {
  FooderCommentCard({
    Key? key,
    required this.comments,
    required this.restaurantName,
    required this.restaurantUnique,
    this.type = 'NORMAL',
  }) : super(key: key);
  List<RestaurantComment> comments;
  String restaurantName;
  String restaurantUnique;
  String type;
  @override
  _FooderCommentCardState createState() => _FooderCommentCardState();
}

class _FooderCommentCardState extends State<FooderCommentCard> {
  late final AuthModel auth = context.read<AuthModel>();
  late final RestaurantDetailsBloc _restaurantDetailsBloc;
  @override
  void initState() {
    _restaurantDetailsBloc = BlocProvider.of<RestaurantDetailsBloc>(context);
    super.initState();
  }

  String commentTypeIcon(String type) {
    if(type.toUpperCase() == 'GOOD') {
      return "assets/img/delicious.svg";
    } else if (type.toUpperCase() == 'NORMAL') {
      return "assets/img/notBad.svg";
    }
    return"assets/img/normal.svg";
  }

  String commentTypeTitle(String type) {
    if(type.toUpperCase() == 'GOOD') {
      return "Delicious!";
    } else if (type.toUpperCase() == 'NORMAL') {
      return "Not Bad";
    }
    return "Normal";
  }

  void _commentOptions(RestaurantComment comment) {
    final textTheme = Theme.of(context).textTheme;
    final user = auth.user?.user;
    if(
      user != null &&
      user.uniqueId == comment.user.uniqueId
    ) {
      showAdaptiveActionSheet(
        context: context,
        title: Text('Select Action', style: textTheme.subtitle1,),
        actions: <BottomSheetAction>[
          BottomSheetAction(
              leading: Container(
                padding: const EdgeInsets.only(right: 10),
                child: const Icon(Icons.edit_rounded, color: Colors.grey,),
              ),
              title: Text('Edit review', style: textTheme.subtitle1,),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/edit-review', arguments: {
                  "uniqueId": comment.uniqueId,
                  "restaurantUniqueId": widget.restaurantUnique,
                });

              }
          ),
          BottomSheetAction(
              leading: Container(
                padding: const EdgeInsets.only(right: 10),
                child: const Icon(Icons.delete_rounded, color: Colors.grey,),
              ),
              title: Text('Delete review', style: textTheme.subtitle1,),
              onPressed: () {
                Navigator.of(context).pop();
                _restaurantDetailsBloc.add(DeleteReview(comment.uniqueId));
              }
          ),
        ],
      );
    } else {
      showAdaptiveActionSheet(
        context: context,
        title: Text('Select Action', style: textTheme.subtitle1,),
        actions: <BottomSheetAction>[
          BottomSheetAction(
              leading: Container(
                padding: const EdgeInsets.only(right: 10),
                child: const Icon(Icons.report_rounded, color: Colors.grey,),
              ),
              title: Text('Report review', style: textTheme.subtitle1,),
              onPressed: () {
              }
          ),
        ],
      );
    }

  }

  @override
  Widget build(BuildContext context) {

    final commentLength = widget.type != 'NORMAL'
        ?  widget.comments.length
        :widget.comments.isEmpty ? 0 : widget.comments.length > 3 ? 3 : widget.comments.length;

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
              Navigator.of(context).pushNamed('/single-review', arguments: {
                "uniqueId": comment.uniqueId,
                "restaurantUniqueId": widget.restaurantUnique,
              });
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
                  commentFunctionList(comment),
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
    final String icon = commentTypeIcon(comment.type);
    final String title = commentTypeTitle(comment.type);

    return Container(
      width: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            child: SvgPicture.asset(icon)
          ),
         // Padding(
         //   padding: const EdgeInsets.only(right: 10, top: 10),
         //  child: SvgPicture.asset(icon)
         // ),
          Center(
            child: Text(
              title,
              style: textTheme.subtitle2!.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Theme.of(context).primaryColor,
              ) ,
            ),
          )
        ],
      ),
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

  Widget commentImage({
    required List<RestaurantCommentPhoto> galleryItems,
    required int index,
    required CommentUser user,
  }) {
    return Row(
      children: [
        InkWell(
          onTap: () {
           Navigator.of(context).push(
             MaterialPageRoute(
               builder: (context) => FooderPhotoWrapper(
                 galleryItems: galleryItems,
                 user: user,
                 backgroundDecoration: const BoxDecoration(
                   color: Colors.black,
                 ),
                 initialIndex: index,
               ),
             )
           );
          },
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: galleryItems[index].imageUrl,
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
          for(var index = 0; index < comment.photos.length ; index++)
            commentImage(
              galleryItems: comment.photos,
              index: index,
              user: comment.user,
            ),
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

  Widget commentFunctionList(RestaurantComment comment) {
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
              isActive: comment.totalLikeUser.where((item) => item.uniqueId == auth.user?.user?.uniqueId).toList().isNotEmpty,
              onTap: () {
                if(auth.user == null) {
                  Navigator.of(context).pushNamed('/login');
                } else {
                  _restaurantDetailsBloc.add(SetCommentLike(comment.uniqueId));
                }

              },
            ),
            const SizedBox(width: 10,),
            // commentFunctionButton(
            //   textTheme,
            //   inActiveIcon:Icons.chat_bubble_outline_rounded,
            //   title: 'Comment',
            //   onTap: () {
            //     if(auth.user == null) {
            //       Navigator.of(context).pushNamed('/login');
            //     }
            //   },
            // ),
          ],
        ),
        GestureDetector(
          onTap: () {
            _commentOptions(comment);
          },
          child: Icon(
            Icons.more_horiz_rounded,
            size: 25,
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
        // PopupMenuButton<String>(
        //   icon: Icon(
        //     Icons.more_horiz_rounded,
        //     size: 25,
        //     color: Theme.of(context).secondaryHeaderColor,
        //   ),
        //   onSelected: (value) {},
        //   itemBuilder: (BuildContext context) {
        //     return {'Logout', 'Settings'}.map((String choice) {
        //       return PopupMenuItem<String>(
        //         value: choice,
        //         child: Text(choice),
        //       );
        //     }).toList();
        //   },
        // ),
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
